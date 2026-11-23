# fuckslow

⚡ 一个嘴臭、双语的终端工具，帮你揪出电脑卡顿的元凶。

它会采样内存、交换空间、CPU 和磁盘，把 Helper 进程归并到常见软件和 AI Agent，解释常见系统进程，并列出优先级最高的关闭候选。

## 一行安装

macOS 和 Linux：

```sh
curl -fsSL https://raw.githubusercontent.com/DOGTT/fuckslow/main/install.sh | sh
```

Windows PowerShell：

```powershell
irm https://raw.githubusercontent.com/DOGTT/fuckslow/main/install.ps1 | iex
```

仓库发布到 `github.com/DOGTT/fuckslow` 后，上面的公开安装命令即可使用。本地安装时，在仓库目录运行 macOS/Linux 的 `./install.sh`，Windows PowerShell 运行 `install.ps1`。

本地独立 Git 仓库已经准备好。公开的一行安装地址要等 GitHub 仓库创建并推送代码后才会生效。

安装到当前用户目录，不需要管理员权限。Linux 和 Windows 会建独立 Python 虚拟环境并安装 psutil。macOS 使用 Python 自带的系统工具。

## 使用

```sh
fuckslow
fuckslow --seconds 5 --limit 8
fuckslow --report-only
fuckslow --no-animation
```

交互菜单最多列出 5 个候选。输入 `123` 或 `32` 多选，回车锁定，再输入 `y` 才开始退出。macOS 会请求应用正常退出，Linux 发送 SIGTERM，Windows 强制结束选中的进程。Agent 会话和虚拟机按单个进程处理，操作前先保存工作。

## 报告内容

- 内存压力、可用和压缩内存、交换、CPU 和磁盘空间。
- 应用或进程的内存和 CPU 排名。
- 榜外进程组的加总、榜外最大户、零碎小户合计。
- 常见系统进程的用途和排查方法。系统进程不会出现在关闭菜单。
- Claude Code、Codex、DeepSeek Harness、Grok Build、OpenCode、VS Code、Cursor、Chrome、Docker、Android Emulator、Ollama 等软件归并。
- 根据实际瓶颈生成的结论和嘴臭吐槽。

默认英文。程序按 `LC_ALL`、`LC_MESSAGES`、`LANG` 的顺序判断语言。macOS 和 Windows 也会读取系统语言设置。中文环境自动切换为中文。

## 要求

- Python 3.10 或更新版本。
- macOS 不依赖第三方运行库。
- Linux 和 Windows 在独立虚拟环境安装 [psutil](https://psutil.readthedocs.io/)。

## 本地开发

```sh
git clone https://github.com/DOGTT/fuckslow.git
cd fuckslow
python3 -m pip install -r requirements.txt  # Linux/Windows
./fuckslow --report-only
```

Windows PowerShell 使用 `python -m pip install -r requirements.txt`，再在项目目录运行：

```powershell
& "$PWD\fuckslow.cmd" --report-only
```

项目使用 MIT 许可证，见 [LICENSE](LICENSE)。欢迎提交问题和 PR，见 [CONTRIBUTING.md](CONTRIBUTING.md)。
