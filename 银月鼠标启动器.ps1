# 银月鼠标启动器 v3.0 - PowerShell 版
# 保证 AHK 先于 SayIt 启动，确保 SayIt 钩子优先级更高

Start-Sleep -Seconds 2

# 杀掉旧实例
Stop-Process -Name "AutoHotkey64" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "sayit" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

# 1. 先启动 AHK（钩子#1，排在底部）
$ahkExe = "D:\软件安装地址\autohotk\v2\AutoHotkey64.exe"
$ahkScript = "D:\银月baby的工作玉简\01_日常行动与工作方案\mouse-remap-windows\scripts\MouseRemap.ahk"
Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkScript`""

# 2. 等 3 秒，让 AHK 钩子完全装好
Start-Sleep -Seconds 3

# 3. 再启动 SayIt（钩子#2，排在顶部，先于 AHK 被调用）
$sayitExe = "D:\软件安装地址\SayIt\sayit.exe"
Start-Process -FilePath $sayitExe -ArgumentList "--minimized"