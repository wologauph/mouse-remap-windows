# mouse-remap-windows

> 将 Windows 鼠标侧键重映射为「语音唤醒 + 智能复制粘贴」的全局方案。
> 无需任何付费软件，仅依赖 AutoHotkey v2（免费开源）。

---

## 效果

| 按键 | 动作 | 说明 |
|------|------|------|
| 后侧键 (XButton1) | 语音转文字唤醒 | 浏览器不再后退，语音软件正常响应 |
| 前侧键 (XButton2) 单击（无选中）| 粘贴 | 把剪贴板内容输入当前位置 |
| 前侧键 (XButton2) 单击（有选中）| 复制 | 把选中文字复制到剪贴板 |
| 前侧键 (XButton2) 长按 >0.35s | 删除 | 相当于 Backspace |
| 前侧键 (XButton2) 双击 <0.25s | 覆盖粘贴 | 剪贴板内容覆盖当前选中的文字 |

---

## 前置要求

- Windows 10 / 11
- [AutoHotkey v2](https://www.autohotkey.com/) 已安装

---

## 一键安装（推荐）

```powershell
# 右键 setup.ps1 -> 用 PowerShell 运行
# 或在项目根目录执行：
powershell -ExecutionPolicy Bypass -File setup.ps1
```

脚本会自动完成：
1. 写注册表，从系统层禁用鼠标侧键的前进/后退导航
2. 创建开机自启快捷方式
3. 立刻启动脚本

---

## 手动安装

1. 写注册表（二选一）：
   - 运行 `setup.ps1`（推荐）
   - 或手动在注册表 `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced` 添加 DWORD 值：`DisableXMouseButtonNavigation = 1`

2. 双击 `scripts/MouseRemap.ahk` 启动

3. 开机自启：按 `Win+R` 输入 `shell:startup`，把 `MouseRemap.ahk` 的快捷方式放进去

---

## 卸载

```powershell
powershell -ExecutionPolicy Bypass -File uninstall.ps1
```

---

## 文件结构

```
mouse-remap-windows/
├── scripts/
│   └── MouseRemap.ahk      # 主脚本（核心逻辑）
├── docs/
│   └── troubleshooting.md  # 排错指南
├── logs/                   # 运行日志（本地生成，不上传）
├── setup.ps1               # 一键安装
├── uninstall.ps1           # 一键卸载
├── .gitignore
└── README.md
```

---

## 原理说明

### 为什么不用 PowerToys / X-Mouse Button Control？
PowerToys 的 Keyboard Manager 对鼠标侧键支持有限。AutoHotkey 的系统钩子优先级更高，可覆盖大多数应用的默认行为。

### 为什么需要注册表 + AHK 双层方案？
单用 AHK 拦截 `XButton1` 会把语音软件的热键也一起屏蔽掉。  
注册表层负责告诉 Explorer 和浏览器"侧键不是导航键"，AHK 层只负责定制前侧键的复合逻辑，两者互不干扰。

### 已知兼容性
- ✅ Chrome / Edge / Firefox
- ✅ Windows 桌面环境
- ✅ 微软「听写」语音输入 (Win+H)
- ✅ 第三方语音转文字软件（以全局热键方式监听）

---

## 排错

详见 [`docs/troubleshooting.md`](docs/troubleshooting.md)

---

## License

MIT
