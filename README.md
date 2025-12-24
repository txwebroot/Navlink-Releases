# NavLink 安装指南（Docker 镜像版）

## 🚀 快速开始

### 系统要求

- Docker 20.10+
- Docker Compose 2.0+
- 2GB 可用内存
- 5GB 可用磁盘
- GitHub Personal Access Token（因为镜像仓库是私有的）

### 安装步骤

#### 1. 获取部署文件

**方式 A：** 直接下载

```bash
curl -O https://raw.githubusercontent.com/txwebroot/Navlink-Releases/main/docker-compose.yml
```

**方式 B：** 从安装包解压

```bash
unzip navlink-deploy.zip
cd navlink-deploy
```

#### 2. 登录 GitHub Container Registry

因为镜像仓库是私有的，需要先登录 GHCR：

```bash
# 使用您的 GitHub Personal Access Token
echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u txwebroot --password-stdin
```

**如何获取 GitHub Token**：
1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 勾选 `read:packages` 权限
4. 复制生成的 Token

#### 3. 创建数据目录（重要！）

**必须先创建目录并设置权限**，否则会出现权限错误：

```bash
# 创建必需的目录
mkdir -p data plugins logs

# 设置目录权限（允许容器内的 node 用户写入）
chmod 777 data plugins logs
```

> [!IMPORTANT]
> 这一步很关键！如果跳过，容器会因为无法创建数据库文件而不断重启。

#### 4. 拉取镜像

```bash
docker-compose pull
```

#### 5. 启动服务

```bash
docker-compose up -d
```

#### 6. 访问应用

- **主页**: http://localhost:3001
- **管理后台**: http://localhost:3001/admin
- **默认账号**: admin / admin123

⚠️ **重要**：首次登录后请立即修改管理员密码！

---

## 📊 管理命令

### 查看状态

```bash
docker compose ps
```

### 查看日志

```bash
docker compose logs -f
```

### 停止服务

```bash
docker compose down
```

### 重启服务

```bash
docker compose restart
```

### 更新到最新版本

```bash
# 拉取最新镜像
docker compose pull

# 重启服务
docker compose down
docker compose up -d
```

---

## 💾 数据备份

### 备份所有数据

```bash
# 停止服务
docker compose down

# 备份数据目录
tar czf navlink-backup-$(date +%Y%m%d).tar.gz data/ plugins/ logs/

# 重启服务
docker compose up -d
```

### 恢复数据

```bash
# 停止服务
docker compose down

# 解压备份
tar xzf navlink-backup-20241207.tar.gz

# 重启服务
docker compose up -d
```

---

## 🔧 故障排查

### 容器无法启动

```bash
# 查看详细日志
docker compose logs

# 检查端口占用
lsof -i :3001

# 检查权限
ls -la data/ plugins/ logs/
```

### 忘记管理员密码

```bash
# 方法1：重置数据库（会丢失数据）
docker compose down
rm -rf data/auth.db
docker compose up -d

# 方法2：修改 .env 中的默认密码后重启
vim .env
docker compose restart
```

### 应用商城无法访问

检查 `.env` 文件中的 `PLUGIN_REGISTRY_TOKEN` 是否正确配置。

---

## 🔒 安全建议

1. **更改默认密钥** - 使用强随机字符串
2. **使用强密码** - 管理员密码至少12位
3. **定期备份** - 至少每周备份一次
4. **限制访问** - 使用防火墙限制端口访问
5. **HTTPS** - 生产环境使用 Nginx 反向代理

---

## 📝 配置说明

### 端口配置

默认端口: 3001

修改端口（编辑 `docker-compose.yml`）：

```yaml
ports:
  - "8080:3001"  # 主机端口:容器端口
```

### 数据目录

| 目录 | 说明 |
|------|------|
| `data/` | 数据库和配置文件 |
| `plugins/` | 已安装的插件 |
| `logs/` | 应用日志 |

---

## 🎯 应用商城

应用商城已预先配置，无需额外设置。

进入管理后台 → 系统设置 → 应用商城，即可浏览和安装插件。

---

## 📞 技术支持

- 使用问题：查看日志 `docker compose logs`
- 功能建议：联系管理员
- 紧急问题：检查官方文档

---

## ⚠️ 重要提醒

- 不要将 `.env` 文件分享给他人
- 定期更新到最新版本
- 生产环境务必修改所有默认密钥

---

**祝使用愉快！** 🎉
