import os
import json
import argparse
import random
import shutil
import uuid

USER_QUESTIONS = [
    "这是什么品种的羊",
    "图上是什么羊",
    "这张图片显示的是什么羊的品种？",
    "请告诉我图中羊的品种。",
    "你能识别出这是什么羊吗？"
]

ALLOWED_EXTENSIONS = {'.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.tiff'}

def main():
    parser = argparse.ArgumentParser(description='生成羊品种识别数据集')
    parser.add_argument('--input_dir', required=True, help='包含品种子文件夹的输入目录')
    parser.add_argument('--output_file', default='data.jsonl', help='输出的JSONL文件路径')
    args = parser.parse_args()

    # 准备输出目录
    output_dir = os.path.dirname(os.path.abspath(args.output_file))
    os.makedirs(output_dir, exist_ok=True)

    with open(args.output_file, 'w', encoding='utf-8') as f_out:
        # 遍历品种文件夹
        for breed_name in os.listdir(args.input_dir):
            breed_dir = os.path.join(args.input_dir, breed_name)
            if not os.path.isdir(breed_dir):
                continue

            # 处理每个图片文件
            for filename in os.listdir(breed_dir):
                file_path = os.path.join(breed_dir, filename)
                if os.path.isfile(file_path):
                    ext = os.path.splitext(filename)[1].lower()
                    if ext in ALLOWED_EXTENSIONS:
                        # 生成唯一文件名
                        new_name = f"{uuid.uuid4().hex}{ext}"
                        dest_path = os.path.join(output_dir, new_name)
                        
                        # 复制文件到输出目录
                        try:
                            shutil.copy2(file_path, dest_path)
                        except Exception as e:
                            print(f"复制文件失败: {file_path} -> {dest_path}，错误：{str(e)}")
                            continue

                        # 构建数据条目
                        entry = {
                            "messages": [
                                {
                                    "role": "user",
                                    "content": [
                                        {"text": random.choice(USER_QUESTIONS)},
                                        {"image": new_name}
                                    ]
                                },
                                {
                                    "role": "assistant",
                                    "content": [
                                        {"text": f"这是 {breed_name}"}
                                    ]
                                }
                            ]
                        }
                        f_out.write(json.dumps(entry, ensure_ascii=False) + '\n')

if __name__ == '__main__':
    main()