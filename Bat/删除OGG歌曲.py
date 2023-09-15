from send2trash import send2trash
import sys
import os
import pathlib

def delete_on_dir(dir_path, delete_types = ['.mp3', '.aac', '.ogg'], allowed_types = ['.flac']):
    file_list = os.scandir(dir_path)
    for file_name in file_list:
        path = pathlib.Path(f"{dir_path}/{file_name.name}")
        print("正在检查" + file_name.name)
        if path.suffix in allowed_types:
            continue
        if path.suffix in delete_types:
            hires_found = False
            for allowed_type in allowed_types:
                if (path.with_suffix(allowed_type)).is_file():
                    hires_found = True
                    break
            
            if hires_found:
                send2trash(file_name.path)
                print(file_name.name + '已删除')


if __name__ == '__main__':
    delete_on_dir(sys.argv[1])