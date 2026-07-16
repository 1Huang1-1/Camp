# GitHub 推送工具

将这个文件夹的内容**复制到你的项目根目录**，然后运行脚本即可一键推送到 GitHub 组织仓库。

---

## 使用方法

### 前提条件

- 已安装 [Git](https://git-scm.com/)
- 在 GitHub 组织下**预先创建好空仓库**（不要勾选 README / .gitignore）
- 确保你对仓库有写入权限

### 步骤（一键脚本）

```powershell
# 1. 将本文件夹全部复制到你的项目根目录
# 2. 打开 setup-github.ps1，修改仓库地址和分支名
#    $GITHUB_REPO = "https://github.com/你的组织名/仓库名.git"
#    $BRANCH_NAME = "main"         # 要推送到哪个分支
# 3. 在项目目录下执行
.\setup-github.ps1
```

### 手动操作

```powershell
# 推送到自定义分支（以 dev 为例）
git init
git remote add origin https://github.com/你的组织名/仓库名.git
git checkout -b dev           # 创建并切换到 dev 分支
git add -A
git commit -m "Initial commit"
git push -u origin dev
```

---

## 文件说明

| 文件 | 说明 |
|------|------|
| `.gitignore.template` | .gitignore 模板（不会覆盖你项目已有的 .gitignore） |
| `setup-github.ps1` | 一键推送脚本（支持自定义分支，先修改仓库地址和分支名） |
| `README.md` | 本说明文件 |

> 如果项目根目录还没有 `.gitignore`，可以把 `.gitignore.template` 重命名为 `.gitignore`。如果已经有了，直接忽略模板文件就行，你的保持不变。

---

## 常见问题

### 如果 GitHub 上主分支名是 master

最新版 Git 默认分支名是 `main`。如果你 GitHub 仓库用的是 `master`，把脚本里的 `$BRANCH_NAME` 改成 `"master"` 就好。

### 推送时需要认证

GitHub 从 2021 年起不再接受 HTTPS 密码认证，请使用**个人访问令牌（Personal Access Token）**：

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. 勾选 `repo` 权限，生成令牌
3. 推送时用户名填你的 GitHub 用户名，密码填令牌
