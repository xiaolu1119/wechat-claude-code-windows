# wechat-claude-code Windows 部署指南

在 Windows 上部署 [wechat-claude-code](https://github.com/Wechat-ggGitHub/wechat-claude-code)，实现用微信远程控制本地 Claude Code。

## 环境

以下为实际验证通过的环境：

| 项目 | 版本/说明 |
|------|----------|
| 操作系统 | Windows 11 Home China 10.0.26100 |
| Node.js | v24.15.0 |
| Claude Code | v2.1.152 |
| wechat-claude-code | v1.0.0 |
| 包管理器 | npm |

## 前置条件

- Node.js >= 18（Windows 版本即可）
- Claude Code 已安装并配置好 API Key
- 一个**微信小号**（存在封号风险，不建议用主号）

## 快速开始

### 1. 克隆并安装

```powershell
git clone https://github.com/Wechat-ggGitHub/wechat-claude-code.git ~/.claude/skills/wechat-claude-code
cd ~/.claude/skills/wechat-claude-code
npm install
```

> `postinstall` 会自动编译 TypeScript 到 `dist/` 目录。

### 2. 扫码绑定微信

```powershell
npm run setup
```

- 会自动弹出二维码图片，用微信扫码
- 扫码成功后输入工作目录（直接回车使用当前目录）
- `which` 相关的报错可忽略，不影响功能

### 3. 启动守护进程

```powershell
node dist/main.js
```

终端会保持前台运行，监听微信消息。**关闭终端即停止服务。**

#### 后台运行（可选）

**CMD：**
```cmd
start /B node dist/main.js
```

**PowerShell：**
```powershell
Start-Process -NoNewWindow node -ArgumentList "dist/main.js"
```

或直接双击仓库里的 `start-daemon.bat`。

### 4. 测试

在微信中给机器人发送 `/help`，收到命令列表即表示成功。

## 微信端命令

| 命令 | 说明 |
|------|------|
| `/help` | 显示帮助 |
| `/clear` | 清除当前会话 |
| `/reset` | 完全重置（含工作目录等设置） |
| `/model <名称>` | 切换 Claude 模型 |
| `/permission <模式>` | 切换权限模式 |
| `/prompt [内容]` | 查看或设置系统提示词 |
| `/status` | 查看当前会话状态 |
| `/cwd [路径]` | 查看或切换工作目录 |
| `/skills` | 列出已安装的 Skill |
| `/history [数量]` | 查看最近 N 条对话 |
| `/compact` | 压缩上下文 |
| `/undo [数量]` | 撤销最近 N 条对话 |
| `/<skill> [参数]` | 触发已安装的 Skill |

## 权限模式

| 模式 | 说明 |
|------|------|
| `default` | 每次工具调用需手动审批（推荐） |
| `acceptEdits` | 自动批准文件编辑，其他需审批 |
| `plan` | 只读模式，不允许任何操作 |
| `auto` | 自动批准所有（危险，谨慎使用） |

在微信中回复 `y` 批准、`n` 拒绝，120 秒未回复自动拒绝。

## Windows 兼容性说明

原项目标注仅支持 macOS/Linux。经实测，核心 Node.js 代码在 Windows 上可直接运行，但存在以下差异：

### 无需处理的问题

- `daemon.sh` 不可用 → 直接用 `node dist/main.js` 启动，或使用 Windows 任务计划程序实现开机自启
- `which`/`readlink` 报错 → 静默 fallback，不影响功能
- `chmod` 在代码中已做 `process.platform !== 'win32'` 判断

### 服务持久化方案

原项目在 macOS 上用 launchd、Linux 上用 systemd 实现开机自启。Windows 上可选：

1. **手动启动**：每次开机后运行 `node dist/main.js`
2. **任务计划程序**：创建开机启动任务
3. **nssm**（Non-Sucking Service Manager）：注册为 Windows 服务

## 数据目录

```
~/.wechat-claude-code/
├── accounts/       # 微信账号凭证
├── config.env      # 工作目录、模型、权限、提示词配置
├── sessions/       # 会话持久化数据
├── get_updates_buf # 消息轮询同步缓冲
└── logs/           # 运行日志（每日轮转，保留 30 天）
```

## 故障排查

| 问题 | 解决 |
|------|------|
| `which` 报错 | 忽略，不影响功能 |
| 扫码后无响应 | 重新运行 `npm run setup` |
| 微信提示会话过期 | 重新运行 `npm run setup` 扫码 |
| Claude 无回复 | 检查 API Key 配置、网络连接 |
| 权限请求无响应 | 确认权限模式，回复 `y` 或 `n` |

## 相关链接

- [原始项目](https://github.com/Wechat-ggGitHub/wechat-claude-code)
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code)
