# 排错指南 (Troubleshooting)

## 问题 1：脚本运行后，浏览器侧键依然触发后退

**原因**：注册表项未生效，或鼠标驱动把侧键硬编码为 `Alt+Left`。

**解法**：
1. 确认注册表值已写入（运行 `setup.ps1` 或手动检查）
2. 重启 Windows Explorer：`taskkill /f /im explorer.exe && start explorer.exe`
3. 如仍无效，在 `MouseRemap.ahk` 脚本中加入以下行并重启脚本：
   ```ahk
   Browser_Back::return
   !Left::return
   ```
   注意：这会同时屏蔽语音软件的热键，需把语音软件的快捷键改为 `F13` 等冷门键。

---

## 问题 2：后侧键按下后语音软件没有响应

**原因**：`MouseRemap.ahk` 中误写了 `XButton1::return`，把信号完全屏蔽。

**解法**：确认脚本中没有对 `XButton1` 的任何拦截行，保持空白即可。

---

## 问题 3：AHK 弹出"Could not close the previous instance"

**原因**：有旧版本脚本还在运行，新实例无法启动。

**解法**：在 PowerShell 执行：
```powershell
Stop-Process -Name "AutoHotkey*" -Force
```
然后重新启动脚本。

---

## 问题 4：前侧键单击逻辑不准确（明明没选中文字，却执行了复制）

**原因**：某些应用在获取焦点时自动选中了一段文字（如地址栏）。

**解法**：`ClipWait` 的等待时间可适当缩短，在脚本中把 `ClipWait(0.15)` 改为 `ClipWait(0.08)`。

---

## 如何查看 AHK 是否在以管理员权限运行

右键系统托盘中的 AutoHotkey 图标 → 点击"Open" → 菜单栏查看是否显示"管理员"字样。

---

## 如何查看脚本运行日志

AutoHotkey v2 本身不自动产生日志文件。若需调试，在脚本顶部加入：
```ahk
; 开启日志（仅调试时使用）
FileAppend "脚本启动 " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n", A_ScriptDir "\..\logs\debug.log"
```
