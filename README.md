## 更详细说明：www.webxx.top
### 演示地址：http://demo.webxx.top
### 演示帐号：demo / 密码：demo
### 演示帐号不可修改数据，会自动返回登录界面

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

- **主页**: http://localhost:8000
- **管理后台**: http://localhost:8000/admin
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

---

## ⚠️ 迁移/重装重要提示

> **重要警告**：如果您需要迁移到新服务器或重新安装，请务必在迁移前完成以下步骤！

### 迁移前必须操作：

1. **登录管理后台** → 进入「系统设置」→「授权管理」
2. **申请新的激活码** 并保存到安全的地方
3. **备份数据目录** (`data/` 和 `plugins/`)
4. 在新环境安装完成后，使用保存的激活码重新激活

### 为什么需要这样做？

- 更换服务器后硬件指纹会变化，原授权状态失效
- 如果没有保存激活码，您将无法在新服务器上激活

> 💡 **提示**：常规的版本升级（通过后台「系统升级」功能）不会影响授权状态，无需重新激活。
