' 银月鼠标启动器 v3.0
' 保证 AHK 永远先于 SayIt 启动，确保 SayIt 钩子优先级更高
' 此文件放在开机启动文件夹，完全静默运行

Dim oShell
Set oShell = CreateObject("WScript.Shell")

' 1. 先杀掉可能已经运行的旧实例
On Error Resume Next
oShell.Run "taskkill /F /IM AutoHotkey64.exe", 0, True
oShell.Run "taskkill /F /IM sayit.exe", 0, True
On Error GoTo 0

' 2. 等待 1 秒确保进程完全退出
WScript.Sleep 1000

' 3. 先启动 AHK（安装钩子#1，排在队列底部）
oShell.Run """D:\软件安装地址\autohotk\v2\AutoHotkey64.exe"" ""D:\银月baby的工作玉简\01_日常行动与工作方案\mouse-remap-windows\scripts\MouseRemap.ahk""", 0, False

' 4. 等待 3 秒，让 AHK 完全安装好鼠标钩子
WScript.Sleep 3000

' 5. 再启动 SayIt（安装钩子#2，排在队列顶部，先被调用）
oShell.Run """D:\软件安装地址\SayIt\sayit.exe"" --minimized", 0, False
