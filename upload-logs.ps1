<#
.SYNOPSIS
    将 Spring Boot 日志文件上传到 GitHub
.DESCRIPTION
    把 logs/ 目录提交到 GitHub 的 logs-branch 分支。
    先决条件：项目已在 GitHub 上创建仓库并关联 remote。
.EXAMPLE
    .\upload-logs.ps1
    使用默认提交信息上传日志
.EXAMPLE
    .\upload-logs.ps1 -CommitMsg "我的备注"
    使用自定义提交信息上传日志
#>

param(
    [string]$CommitMsg = "upload logs on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
)

# ---- 检查环境 ----
$isRepo = git rev-parse --is-inside-work-tree 2>$null
if (-not $isRepo) {
    Write-Host "错误：当前目录不是 git 仓库" -ForegroundColor Red
    Write-Host "请先执行以下命令初始化：" -ForegroundColor Yellow
    Write-Host "  git init" -ForegroundColor Yellow
    Write-Host "  git add ." -ForegroundColor Yellow
    Write-Host "  git commit -m 'init'" -ForegroundColor Yellow
    Write-Host "  git remote add origin https://github.com/你的用户名/仓库名.git" -ForegroundColor Yellow
    Write-Host "  git push -u origin main" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path "logs")) {
    Write-Host "错误：logs/ 目录不存在" -ForegroundColor Red
    Write-Host "请先启动项目 (bootRun) 生成日志后再运行此脚本" -ForegroundColor Yellow
    exit 1
}

$hasRemote = git remote -v 2>$null
if (-not $hasRemote) {
    Write-Host "错误：未关联远程仓库" -ForegroundColor Red
    Write-Host "请执行：git remote add origin https://github.com/你的用户名/仓库名.git" -ForegroundColor Yellow
    exit 1
}

# ---- 开始上传 ----
$currentBranch = git rev-parse --abbrev-ref HEAD

Write-Host "=== 开始上传日志到 GitHub ===" -ForegroundColor Cyan

try {
    Write-Host "[1/4] 切换到日志分支..." -ForegroundColor Yellow
    git checkout --orphan logs-branch 2>&1 | Out-Null
    git rm -rf . 2>&1 | Out-Null

    Write-Host "[2/4] 打包日志文件..." -ForegroundColor Yellow
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $archiveName = "logs-$timestamp.tar.gz"
    tar -czf $archiveName logs/ 2>&1

    New-Item -ItemType Directory -Path "logs-artifact" -Force | Out-Null
    Move-Item $archiveName "logs-artifact/" -Force
    git add logs-artifact/ 2>&1 | Out-Null
    git commit -m $CommitMsg 2>&1 | Out-Null

    Write-Host "[3/4] 推送到 GitHub (logs-branch)..." -ForegroundColor Yellow
    git push origin logs-branch --force 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "推送失败，请检查 git remote 配置"
    }

    Write-Host "[4/4] 切回原分支..." -ForegroundColor Yellow
    git checkout $currentBranch 2>&1 | Out-Null

    # 清理临时文件
    Remove-Item -Path "logs-artifact" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "" 
    Write-Host "=== 上传完成 ===" -ForegroundColor Green

    $remoteUrl = git remote get-url origin 2>$null
    if ($remoteUrl -match 'github\.com[:\/](.+)\.git') {
        $repo = $matches[1]
        Write-Host "查看地址: https://github.com/$repo/tree/logs-branch" -ForegroundColor Green
    }
    Write-Host "包含日志: $archiveName" -ForegroundColor Green
    Write-Host ""
    Write-Host "提示：刷新浏览器触发新请求后，再次运行本脚本更新日志" -ForegroundColor Cyan

} catch {
    Write-Host "出错: $_" -ForegroundColor Red
    git checkout $currentBranch 2>&1 | Out-Null
    exit 1
}
