# uninstall.ps1
# 一键卸载脚本 —— 完全还原系统设置

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  mouse-remap-windows 一键卸载" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. 停止 AHK 进程
Stop-Process -Name "AutoHotkey*" -Force -ErrorAction SilentlyContinue
Write-Host "✅ AutoHotkey 进程已停止" -ForegroundColor Green

# 2. 删除开机快捷方式
$startupDir = [Environment]::GetFolderPath("Startup")
$lnk = "$startupDir\MouseRemap.lnk"
if (Test-Path $lnk) { Remove-Item $lnk -Force }
Write-Host "✅ 开机自启快捷方式已删除" -ForegroundColor Green

# 3. 还原注册表
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Remove-ItemProperty -Path $regPath -Name "DisableXMouseButtonNavigation" -ErrorAction SilentlyContinue
Write-Host "✅ 注册表已还原（鼠标侧键前进/后退功能恢复）" -ForegroundColor Green

Write-Host "`n卸载完成，所有设置已还原。`n" -ForegroundColor Cyan
