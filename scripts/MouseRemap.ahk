#Requires AutoHotkey v2.0
#SingleInstance Force

; =========================================================
; mouse-remap-windows / scripts / MouseRemap.ahk
; 版本：v1.2.0  |  更新：2026-08-05
; 作者：徐雨轩（银月辅助完成）
;
; 功能说明：
;   后侧键 (XButton1) ── 100% 拦截浏览器后退，发送 Win+H 与 F13 唤醒语音输入
;   前侧键 (XButton2) ── 四档逻辑：
;       单击(无选中) = 粘贴 (Ctrl+V)
;       单击(有选中) = 复制 (Ctrl+C)
;       长按 >0.35s  = 删除 (Backspace)
;       双击 <0.25s  = 覆盖粘贴 (Ctrl+V，选中状态下自动覆盖)
; =========================================================

; =========================================================
; 后侧键 (XButton1) 语音唤醒 + 封杀后退
; =========================================================
$XButton1::
{
    Send("#h")        ; 唤醒 Windows 内置语音输入 (Win+H)
    Send("{F13}")     ; 发送 F13 供第三方语音软件绑定
}


; =========================================================
; 前侧键 (XButton2) 复合逻辑
; =========================================================
$XButton2::
{
    ; 长按检测 (按住超过 0.35 秒)
    if !KeyWait("XButton2", "T0.35")
    {
        Send("{Backspace}")
        KeyWait("XButton2")
        return
    }

    ; 双击检测 (0.25 秒内再次按下)
    if KeyWait("XButton2", "D T0.25")
    {
        Send("^{v}")
        KeyWait("XButton2")
        return
    }

    ; 单击：探测是否有文字被选中
    savedClip := ClipboardAll()
    A_Clipboard := ""
    Send("^{c}")

    if ClipWait(0.15)
    {
        ; 有选中文字 → 复制完成，剪贴板已更新
    }
    else
    {
        ; 无选中文字 → 粘贴
        A_Clipboard := savedClip
        Sleep(50)
        Send("^{v}")
    }
}
