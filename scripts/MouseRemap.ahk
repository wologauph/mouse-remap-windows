#Requires AutoHotkey v2.0

; =========================================================
; mouse-remap-windows / scripts / MouseRemap.ahk
; 版本：v1.0.0  |  更新：2026-08-05
; 作者：徐雨轩（银月辅助完成）
;
; 功能说明：
;   后侧键 (XButton1) ── 透传，仅由注册表层屏蔽系统默认的前进/后退
;                         语音软件可正常接收此按键信号
;   前侧键 (XButton2) ── 四档逻辑：
;       单击(无选中) = 粘贴 (Ctrl+V)
;       单击(有选中) = 复制 (Ctrl+C)
;       长按 >0.35s  = 删除 (Backspace)
;       双击 <0.25s  = 覆盖粘贴 (Ctrl+V，选中状态下自动覆盖)
;
; 依赖前置条件：
;   注册表键值已设置（由 setup.ps1 自动完成）：
;   HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
;   DisableXMouseButtonNavigation = 1
; =========================================================


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
