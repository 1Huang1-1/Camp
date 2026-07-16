<#
.SYNOPSIS
    初始化 Git 仓库并推送到 GitHub 组织仓库的指定分支
.DESCRIPTION
    在当前文件夹初始化 Git，创建初始提交，并推送到指定的 GitHub 组织仓库和分支。
    使用前请修改下面的仓库地址和分支名为你自己的。
#>

# ─── 修改为你的 GitHub 组织仓库地址 ───
$GITHUB_REPO = "https://github.com/1Huang1-1/Camp.git"
$BRANCH_NAME  = "wechatbotdemo"   # 默认推送到 main，可以改为 dev / feature-xxx 等
# ──────────────────────────────────────

$PROJECT_PATH = Get-Location
$REPO_NAME = Split-Path $PROJECT_PATH -Leaf

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  GitHub 推送工具" -ForegroundColor Cyan
Write-Host "  项目: $REPO_NAME" -ForegroundColor Cyan
Write-Host "  分支: $BRANCH_NAME" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 检查 git 是否可用
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[错误] 未找到 git 命令，请先安装 Git" -ForegroundColor Red
    exit 1
}

# 2. 检查是否已有 .git 目录
if (Test-Path ".git") {
    Write-Host "[信息] 已存在 Git 仓库，跳过初始化" -ForegroundColor Yellow
} else {
    Write-Host "[1/5] 初始化 Git 仓库..." -ForegroundColor Green
    git init
    if ($LASTEXITCODE -ne 0) { Write-Host "[错误] git init 失败" -ForegroundColor Red; exit 1 }
}

# 3. 添加远程仓库
$REMOTE = git remote get-url origin 2>$null
if (-not $REMOTE) {
    Write-Host "[2/5] 添加远程仓库: $GITHUB_REPO" -ForegroundColor Green
    git remote add origin $GITHUB_REPO
} else {
    Write-Host "[信息] 远程仓库已存在: $REMOTE" -ForegroundColor Yellow
}

# 4. 创建并切换到目标分支
$CURRENT_BRANCH = git branch --show-current
if (-not $CURRENT_BRANCH) {
    # 刚 git init 没有提交时，先用 git checkout -b 创建分支
    Write-Host "[3/5] 创建分支: $BRANCH_NAME" -ForegroundColor Green
    git checkout -b $BRANCH_NAME
} elseif ($CURRENT_BRANCH -ne $BRANCH_NAME) {
    Write-Host "[3/5] 切换到分支: $BRANCH_NAME" -ForegroundColor Green
    git checkout -b $BRANCH_NAME 2>$null
    if ($LASTEXITCODE -ne 0) {
        git checkout $BRANCH_NAME  # 分支已存在，直接切换
    }
}

# 5. 添加文件并提交
Write-Host "[4/5] 添加文件并创建初次提交..." -ForegroundColor Green
git add -A
git commit -m "Initial commit"

# 6. 推送到 GitHub
Write-Host "[5/5] 推送到 GitHub..." -ForegroundColor Green
Write-Host ""
Write-Host "即将推送到: $GITHUB_REPO" -ForegroundColor Yellow
Write-Host "目标分支:   $BRANCH_NAME" -ForegroundColor Yellow
Write-Host "如果这是第一次推送，可能需要登录 GitHub。" -ForegroundColor Yellow
Write-Host ""

$BRANCH = git branch --show-current
git push -u origin $BRANCH

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "  完成！项目已推送到 GitHub" -ForegroundColor Green
    Write-Host "  $GITHUB_REPO  -> 分支: $BRANCH_NAME" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "[提示] 推送失败，请检查:" -ForegroundColor Yellow
    Write-Host "  1. 是否已在 GitHub 创建了空仓库: $GITHUB_REPO" -ForegroundColor Yellow
    Write-Host "  2. 目标分支 $BRANCH_NAME 在 GitHub 上是否已存在且与本地不冲突" -ForegroundColor Yellow
    Write-Host "  3. 网络连接是否正常" -ForegroundColor Yellow
    Write-Host "  4. 是否有仓库的写入权限" -ForegroundColor Yellow
    Write-Host "  5. 如果使用 HTTPS，可能需要配置个人访问令牌 (PAT)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  手动重试: git push -u origin $BRANCH" -ForegroundColor Cyan
}
