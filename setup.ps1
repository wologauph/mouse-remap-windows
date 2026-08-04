# setup.ps1
# 一键安装脚本 —— mouse-remap-windows
# 运行方式：右键 -> 用 PowerShell 运行
# 或在终端执行：powershell -ExecutionPolicy Bypass -File setup.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  mouse-remap-windows 一键安装脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# ── Step 1：写注册表，从系统层禁用侧键导航 ──────────────────
Write-Host "`n[1/3] 写入注册表，禁用鼠标侧键前进/后退导航..." -ForegroundColor Yellow
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $regPath -Name "DisableXMouseButtonNavigation" -Value 1 -Type DWord -Force
Write-Host "      ✅ 注册表写入成功" -ForegroundColor Green

# ── Step 2：把脚本放到开机启动文件夹 ────────────────────────
Write-Host "`n[2/3] 创建开机自启快捷方式..." -ForegroundColor Yellow

$ahkExe = "D:\软件安装地址\autohotk\v2\AutoHotkey64.exe"
# 如果不在默认路径，自动搜索
if (-not (Test-Path $ahkExe)) {
    Write-Host "      正在全盘搜索 AutoHotkey64.exe..." -ForegroundColor Gray
    $found = Get-ChildItem -Path "C:\", "D:\", "E:\" -Recurse -Filter "AutoHotkey64.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $ahkExe = $found.FullName
        Write-Host "      找到：$ahkExe" -ForegroundColor Gray
    } else {
        Write-Host "      ❌ 未找到 AutoHotkey，请先安装：https://www.autohotkey.com/" -ForegroundColor Red
        exit 1
    }
}

$scriptPath = Join-Path $PSScriptRoot "scripts\MouseRemap.ahk"
$startupDir = [Environment]::GetFolderPath("Startup")

$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut("$startupDir\MouseRemap.lnk")
$shortcut.TargetPath = $ahkExe
$shortcut.Arguments = "`"$scriptPath`""
$shortcut.WorkingDirectory = Split-Path $scriptPath
$shortcut.Description = "鼠标侧键重映射 - mouse-remap-windows"
$shortcut.Save()
Write-Host "      ✅ 快捷方式已放入启动文件夹：$startupDir" -ForegroundColor Green

# ── Step 3：立刻启动脚本 ─────────────────────────────────────
Write-Host "`n[3/3] 立刻启动脚本..." -ForegroundColor Yellow
Stop-Process -Name "AutoHotkey*" -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 500
Start-Process $ahkExe -ArgumentList "`"$scriptPath`""
Start-Sleep -Seconds 1

$proc = Get-Process | Where-Object {$_.ProcessName -match "AutoHotkey"}
if ($proc) {
    Write-Host "      ✅ 脚本已运行，进程 ID：$($proc.Id)" -ForegroundColor Green
} else {
    Write-Host "      ⚠️  脚本未能自动启动，请手动双击 scripts\MouseRemap.ahk" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  安装完成！" -ForegroundColor Green
Write-Host "  后侧键：触发语音软件（浏览器不再后退）" -ForegroundColor White
Write-Host "  前侧键：复制/粘贴/长按删除/双击覆盖" -ForegroundColor White
Write-Host "========================================`n" -ForegroundColor Cyan
