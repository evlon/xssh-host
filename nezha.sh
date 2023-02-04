#!/usr/bin/env bash

# 传哪吒三个参数
NEZHA_SERVER=$1
NEZHA_PORT=$2
NEZHA_KEY=$3

# 三个变量不全则不安装哪吒客户端
check_variable() {
  [[ -z "${NEZHA_SERVER}" || -z "${NEZHA_PORT}" || -z "${NEZHA_KEY}" ]] && exit 0
}

# 安装系统依赖
check_dependencies() {
  DEPS_CHECK=("wget" "unzip")
  DEPS_INSTALL=(" wget" " unzip")
  for ((i=0;i<${#DEPS_CHECK[@]};i++)); do [[ ! $(type -p ${DEPS_CHECK[i]}) ]] && DEPS+=${DEPS_INSTALL[i]}; done
  [ -n "$DEPS" ] && { apt-get update >/dev/null 2>&1; apt-get install -y $DEPS >/dev/null 2>&1; }
}

# 下载最新版本 Nezha Agent
download_agent() {
  URL=$(wget -qO-  "https://api.github.com/repos/naiba/nezha/releases/latest" | grep -o "https.*linux_amd64.zip")
  echo download agent from $URL
  wget -t 2 -T 10 -N ${URL}
  unzip -qod ./ nezha-agent_linux_amd64.zip && rm -f nezha-agent_linux_amd64.zip
}

# 运行客户端
run() {
  ./nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY}
}
echo check veriable
check_variable
echo check dependencies
check_dependencies
echo download agent
download_agent
echo run
run