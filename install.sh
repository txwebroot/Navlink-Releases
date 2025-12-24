#!/bin/bash
# NavLink 一键安装脚本（Docker 版本）
# 适用于私有 GitHub镜像仓库

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# 检查 Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}错误: 未检测到 Docker Compose${NC}"
    echo "请先安装 Docker Compose"
    exit 1
fi

echo -e "${GREEN}✓${NC} Docker 环境检查通过"
echo ""

# 获取 GitHub Token
echo -e "${YELLOW}因为镜像仓库是私有的，需要 GitHub Personal Access Token${NC}"
echo ""
echo "如何获取 Token:"
echo "1. 访问 https://github.com/settings/tokens"
echo "2. 点击 'Generate new token (classic)'"
echo "3. 勾选 'read:packages' 权限"
echo "4. 复制生成的 Token"
echo ""

if [ -n "$GITHUB_TOKEN" ]; then
    echo -e "${GREEN}检测到环境变量 GITHUB_TOKEN${NC}"
    TOKEN="$GITHUB_TOKEN"
else
    echo -n "请输入您的 GitHub Token: "
    read -s TOKEN
    echo ""
fi

if [ -z "$TOKEN" ]; then
    echo -e "${RED}错误: Token 不能为空${NC}"
    exit 1
fi

# 登录 GHCR
echo ""
echo -e "${YELLOW}1. 登录 GitHub Container Registry...${NC}"
echo "$TOKEN" | docker login ghcr.io -u txwebroot --password-stdin

if [ $? -ne 0 ]; then
    echo -e "${RED}登录失败，请检查 Token 是否正确${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} 登录成功"
echo ""

# 下载 docker-compose.yml
echo -e "${YELLOW}2. 下载部署配置文件...${NC}"
    # 下载 docker-compose.yml (从 Navlink-Releases 公共库)
    curl -sSL -o docker-compose.yml https://raw.githubusercontent.com/txwebroot/Navlink-Releases/main/docker-compose.yml

if [ $? -ne 0 ]; then
    echo -e "${RED}下载失败，请检查网络连接${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} 配置文件下载完成"
echo ""

# 创建必需的目录
echo -e "${YELLOW}3. 创建数据目录...${NC}"
mkdir -p data plugins logs
chmod 777 data plugins logs

echo -e "${GREEN}✓${NC} 数据目录创建完成"
echo ""

# 拉取镜像
echo -e "${YELLOW}4. 拉取 Docker 镜像...${NC}"
docker-compose pull

if [ $? -ne 0 ]; then
    echo -e "${RED}镜像拉取失败${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} 镜像拉取完成"
echo ""

# 启动服务
echo -e "${YELLOW}4. 启动 NavLink 服务...${NC}"
docker-compose up -d

if [ $? -ne 0]; then
    echo -e "${RED}服务启动失败${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} 服务启动成功"
echo ""

# 等待服务启动
echo -e "${YELLOW}等待服务就绪...${NC}"
sleep 5

# 检查服务状态
if docker-compose ps | grep -q "Up"; then
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
    echo ""
    echo -e "${RED}⚠️  重要提示:${NC}"
    echo "  1. 首次登录后请立即修改管理员密码"
    echo "  2. 数据存储在当前目录的 data/ 文件夹"
    echo "  3. 查看日志: docker-compose logs -f"
    echo "  4. 停止服务: docker-compose down"
    echo ""
else
    echo -e "${RED}服务启动异常，请检查日志:${NC}"
    echo "docker-compose logs"
    exit 1
fi
