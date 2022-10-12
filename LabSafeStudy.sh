#!/bin/bash

while [ true ];  do
    echo "study!"
    curl 'https://labsafe.nwafu.edu.cn/exam_xuexi_online.php' \
  -H 'authority: labsafe.nwafu.edu.cn' \
  -H 'accept: */*' \
  -H 'accept-language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'cookie: zg_did=%7B%22did%22%3A%20%22182f381551a2b8-08fab9fdfb7834-72422e2e-240000-182f381551b9e1%22%7D; zg_=%7B%22sid%22%3A%201664079578275%2C%22updated%22%3A%201664079578279%2C%22info%22%3A%201664079578278%2C%22superProperty%22%3A%20%22%7B%7D%22%2C%22platform%22%3A%20%22%7B%7D%22%2C%22utm%22%3A%20%22%7B%7D%22%2C%22referrerDomain%22%3A%20%22newehall.nwafu.edu.cn%22%2C%22cuid%22%3A%20%222022056025%22%2C%22zs%22%3A%200%2C%22sc%22%3A%200%2C%22firstScreen%22%3A%201664079578275%7D; sess=ST-5531911-fXrp4NPtShyIaQgTEFcg-MFO7fsauthserver4' \
  -H 'dnt: 1' \
  -H 'origin: https://labsafe.nwafu.edu.cn' \
  -H 'referer: https://labsafe.nwafu.edu.cn/redir.php?catalog_id=124&object_id=3551' \
  -H 'sec-ch-ua: "Microsoft Edge";v="105", " Not;A Brand";v="99", "Chromium";v="105"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36 Edg/105.0.1343.50' \
  -H 'x-requested-with: XMLHttpRequest' \
  --data-raw 'cmd=xuexi_online' \
  --compressed
    sleep 30s
done
