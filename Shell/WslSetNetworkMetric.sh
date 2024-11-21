#!/bin/bash

# 定义最大重试次数和等待时间间隔
max_retries=9999999
retry_interval=5

# 初始化重试计数器
retry_count=0

# 循环等待直到eth0接口的默认网关出现在路由表中
while [ $retry_count -lt $max_retries ]; do
  default_gw=$(ip route | grep '^default' | grep 'eth0' | awk '{print $3}')
  
  if [ -n "$default_gw" ]; then
    break
  fi
  
  echo "等待eth0接口的默认网关出现..."
  sleep $retry_interval
  ((retry_count++))
done


# 检查是否成功获取到默认网关
if [ -z "$default_gw" ]; then
  echo "无法找到eth0接口的默认网关"
else
  # 删除当前的默认路由
  ip route del default via $default_gw dev eth0

  # 重新添加默认路由并设置metric为1000
  ip route add default via $default_gw dev eth0 metric 1000

  echo "已成功设置eth0接口的默认网关$default_gw的metric为1000"
fi