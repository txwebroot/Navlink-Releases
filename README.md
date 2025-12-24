# NavLink 安装指南（Docker 镜像版）

## 🚀 快速开始

### 方式一：一键安装（推荐）

直接在服务器终端执行以下命令：

```bash
curl -fsSL https://raw.githubusercontent.com/txwebroot/Navlink-Releases/main/install.sh | bash
```

脚本会自动：
1. 检测 Docker 环境
2. 下载配置文件
3. 如果是首次安装，自动生成 `.env`
4. 拉取镜像并启动服务

### 方式二：手动安装

#### 1. 获取部署文件

```bash
# 下载 docker-compose.yml
curl -O https://raw.githubusercontent.com/txwebroot/Navlink-Releases/main/docker-compose.yml

# 下载环境变量模板
curl -o .env https://raw.githubusercontent.com/txwebroot/Navlink-Releases/main/.env.example
```

#### 2. 创建目录

```bash
# 创建必需的目录并设置权限
mkdir -p data plugins logs
chmod 777 data plugins logs
```

#### 3. 启动服务

```bash
# 拉取镜像（无需登录）
docker-compose pull

# 启动服务
docker-compose up -d
```

---

## 💻 访问应用

- **主页**: http://localhost:3001
- **管理后台**: http://localhost:3001/admin
- **默认账号**: admin / admin123

> ⚠️ **重要**：首次登录后请立即修改管理员密码！生产环境请修改 `.env` 中的密钥。

---

## 📊 常用命令

```bash
# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 更新到最新版本
docker-compose pull
docker-compose up -d
```

---

## 💾 数据备份

所有的重要数据都保存在 `data/` 目录下。建议定期备份该目录。

```bash
# 备份命令示例
tar czf backup.tar.gz data/ plugins/
```
