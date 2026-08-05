#Requires AutoHotkey v2.0
#SingleInstance Force

; =========================================================
; mouse-remap-windows / scripts / MouseRemap.ahk
; 版本：v1.4.0  |  更新：2026-08-05
; 作者：徐雨轩（银月辅助完成）
;
; 核心修复：
;   1. 彻底移除 Win+H（不再弹出微软自带语音）
;   2. 后侧键 ($XButton1) 全局吃掉后退信号，同时发送 F13 给第三方语音软件
;   3. 前侧键 ($XButton2) 增加 20ms+30ms 延迟缓冲与 0.25s ClipWait，
;      完美解决 Chrome/Edge 多进程渲染引擎下的复制粘贴失效问题
; =========================================================

ShowTip(text)
{
    ToolTip(text)
    SetTimer () => ToolTip(), -1000
}

; ---------------------------------------------------------
; 后侧键 (XButton1) ── 100% 拦截后退！绝不后退！不弹微软语音！
; ---------------------------------------------------------
$XButton1::
{
    ShowTip("🎤 语音模式 (后退已拦截)")
    Send("{F13}")  ; 发送 F13 给第三方语音软件
    return        ; 彻底切断 XButton1，保证所有浏览器都不后退
}

; ---------------------------------------------------------
; 前侧键 (XButton2) ── 复制 / 粘贴 / 长按删除 / 双击覆盖
; 优化 Chrome / Edge / 网页环境下的复制响应速度
; ---------------------------------------------------------
$XButton2::
{
    ; 1. 长按检测 (> 0.35 秒)
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

    ; 3. 单击逻辑：优化浏览器剪贴板响应
    savedClip := ClipboardAll()
    A_Clipboard := ""
    
    Sleep(20)       ; 缓冲：给浏览器焦点响应按键
    Send("^c")      ; 发送复制
    Sleep(30)       ; 缓冲：给 Chrome 多进程渲染引擎写入剪贴板的时间

    ; 等待最多 0.25 秒（适应 Chrome/Edge/Firefox 的异步剪贴板延迟）
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
