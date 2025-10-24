#!/bin/bash
# 如果未提供路径参数，则默认在脚本所在目录下查找以 .podspec 结尾的文件，否则使用提供的路径
if [ -z "$1" ]; then
  podspec_path=$(find "$(dirname "$0")" -maxdepth 1 -type f -name "*.podspec" | head -n 1)
else
  podspec_path="$1"
fi

# 检查是否找到了 .podspec 文件
if [ -z "$podspec_path" ]; then
  echo "No .podspec file found."
  exit 1
fi

# 使用 grep 和 awk 提取版本信息并将其赋值给 version 变量
version=$(grep -o "s.version\s*=\s*'.*'" "$podspec_path" | awk -F"'" '{print $2}')

# 输出版本信息
echo "version: $version"

# 如果没有找到版本信息，则输出错误信息并退出
if [ -z "$version" ]; then
  echo "No version found in .podspec file."
  exit 1
fi

pod repo push ios-specs AFNetworking.podspec --sources=http://172.18.136.31/iOSComponent/ios-specs.git --verbose --allow-warnings --use-libraries --use-modular-headers

