#!/bin/bash
# NavLink 一键安装脚本（Docker 版本）
# 适用于公共部署

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}   NavLink Docker 一键安装${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

# 检查 Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}错误: 未检测到 Docker${NC}"
    echo "请先安装 Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}错误: 未检测到 Docker Compose${NC}"
    echo "请先安装 Docker Compose"
    exit 1
fi

echo -e "${GREEN}✓${NC} Docker 环境检查通过"
echo ""

# 下载配置文件
echo -e "${YELLOW}1. 下载部署配置文件...${NC}"
curl -sSL -o docker-compose.yml https://raw.githubusercontent.com/txwebroot/Navlink-Releases/main/docker-compose.yml
curl -sSL -o .env.example https://raw.githubusercontent.com/txwebroot/Navlink-Releases/main/.env.example

if [ ! -f .env ]; then
    echo -e "${YELLOW}首次安装，生成 .env 配置文件...${NC}"
    cp .env.example .env
fi

if [ $? -ne 0 ]; then
    echo -e "${RED}下载失败，请检查网络连接${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} 配置文件准备就绪"

# 创建目录
echo -e "${YELLOW}2. 创建数据目录...${NC}"
mkdir -p data plugins logs
chmod 777 data plugins logs

# 拉取镜像
echo -e "${YELLOW}3. 拉取 Docker 镜像...${NC}"
docker-compose pull

# 启动服务
echo -e "${YELLOW}4. 启动 NavLink 服务...${NC}"
docker-compose up -d

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}   ✅ 安装完成！${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo -e "${BLUE}访问地址:${NC}"
echo "  主页: http://localhost:3001"
echo "  管理后台: http://localhost:3001/admin"
echo ""
echo -e "${BLUE}默认账号:${NC}"
echo "  用户名: admin"
echo "  密码: admin123"
