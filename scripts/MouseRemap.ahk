#Requires AutoHotkey v2.0
#SingleInstance Force

; =========================================================
; mouse-remap-windows / scripts / MouseRemap.ahk
; 版本：v1.3.0  |  更新：2026-08-05
; =========================================================

; 鼠标旁边显示气泡提示（1秒后自动消失）
ShowTip(text)
{
    ToolTip(text)
    SetTimer () => ToolTip(), -1000
}

; ---------------------------------------------------------
; 后侧键 (XButton1) ── 封杀后退 + 触发语音
; ---------------------------------------------------------
$XButton1::
{
    ShowTip("🎤 触发语音输入 (后侧键)")
    Send("#h")
    Send("{F13}")
}

; ---------------------------------------------------------
; 前侧键 (XButton2) ── 复制 / 粘贴 / 长按删除 / 双击覆盖
; ---------------------------------------------------------
$XButton2::
{
    ; 1. 长按检测 (> 0.35 秒未松开)
    if !KeyWait("XButton2", "T0.35")
    {
        ShowTip("✂️ 删除 (长按)")
        Send("{Backspace}")
        KeyWait("XButton2")
        return
    }

    ; 2. 双击检测 (0.2 秒内再次按下)
    if KeyWait("XButton2", "D T0.20")
    {
        ShowTip("📋 覆盖粘贴 (双击)")
        Send("^v")
        KeyWait("XButton2")
        return
    }

    ; 3. 单击逻辑：探测是否有选中的文字
    savedClip := ClipboardAll()
    A_Clipboard := ""
    Send("^c")

    if ClipWait(0.12)
    {
        ShowTip("📄 已复制")
    }
    else
    {
        A_Clipboard := savedClip
        Sleep(30)
        Send("^v")
        ShowTip("📋 已粘贴")
    }
}
