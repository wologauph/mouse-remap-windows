#Requires AutoHotkey v2.0
#SingleInstance Force
InstallMouseHook

; =========================================================
; MouseRemap.ahk  v3.0  |  2026-08-12
;
; 原理：AHK 先于 SayIt 启动 → SayIt 的钩子排在 AHK 之上
;       侧键1按下时：SayIt 钩子先触发（语音识别）→ AHK 钩子后触发（拦截浏览器后退）
;       侧键2：智能复制/粘贴/删除/覆盖，浏览器前进彻底拦截
; =========================================================

ShowTip(text)
{
    ToolTip(text)
    SetTimer () => ToolTip(), -1000
}

; ---------------------------------------------------------
; 后侧键 (XButton1) → 只拦截浏览器后退，SayIt 自己处理语音
; ---------------------------------------------------------
$XButton1::
{
    ShowTip("🎤 语音")
    ; 不发送任何键！SayIt 已通过自己的钩子处理。
    ; 这里只负责不让浏览器收到后退信号。
    return
}

; ---------------------------------------------------------
; 前侧键 (XButton2) → 智能复制/粘贴/删除/覆盖，拦截浏览器前进
; ---------------------------------------------------------
$XButton2::
{
    ; 长按 > 0.35s → 删除一个字符
    if !KeyWait("XButton2", "T0.35")
    {
        ShowTip("✂️ 删除")
        Send("{Backspace}")
        KeyWait("XButton2")
        return
    }

    ; 双击 0.2s 内 → 覆盖粘贴
    if KeyWait("XButton2", "D T0.20")
    {
        ShowTip("📋 覆盖粘贴")
        Send("^v")
        KeyWait("XButton2")
        return
    }

    ; 单击 → 复制；无内容则粘贴
    savedClip := ClipboardAll()
    A_Clipboard := ""
    Sleep(20)
    Send("^c")
    Sleep(30)
    if ClipWait(0.25)
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
