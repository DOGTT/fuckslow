# fuckslow

⚡ A blunt, bilingual CLI for finding what's making your computer crawl.

It samples memory, swap, CPU, and disk usage, groups helper processes under familiar apps and AI agents, explains common system processes, and shows a short, prioritized list of things you can quit.

The report defaults to English and switches to Chinese when your system locale is Chinese. It has a little terminal attitude. The diagnostics stay read-only until you choose a target and confirm the quit action.

## Install

macOS and Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/DOGTT/fuckslow/main/install.sh | sh
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/DOGTT/fuckslow/main/install.ps1 | iex
```

The install commands become available after this repository is published at `github.com/DOGTT/fuckslow`. For a local checkout, run `./install.sh` on macOS/Linux or `install.ps1` from PowerShell.

The installer places `fuckslow` under your user account and does not require administrator privileges. Linux and Windows create a private Python virtual environment and install psutil there. macOS uses Python's built-in process tools.

The install scripts support `FUCKSLOW_REPO` and `FUCKSLOW_BRANCH` overrides for testing or alternate forks.

After installing, open a new terminal if needed and run:

```sh
fuckslow
```

## What it reports

- Memory pressure, available and compressed memory, swap use and activity, CPU use, and free space.
- Memory and CPU rankings grouped by app or process.
- Unranked process groups combined, the largest groups outside the visible ranking, and the combined footprint of small process groups.
- Explanations and investigation tips for common system processes. System processes are excluded from the quit menu.
- Agent and developer apps, including Claude Code, Codex, DeepSeek Harness, Grok Build, OpenCode, VS Code, Cursor, Chrome, Docker, Android Emulator, Ollama, and others.
- A blunt summary with a next step tailored to the observed bottleneck.

## Quit menu

The interactive menu shows up to five eligible targets when the sample indicates a problem. Enter multiple numbers such as `123` or `32`, then press Enter. Selected rows shake and change color. You will be asked to confirm with `y` before any quit request is sent.

macOS asks regular apps to quit normally. Linux sends SIGTERM. Windows force-stops the selected process. Agent CLI sessions and virtual machines are handled as individual processes, so stop active work and save first.

## Options

```sh
fuckslow --seconds 5 --limit 8
fuckslow --report-only
fuckslow --no-animation
fuckslow --help
```

- `--seconds` sets the sample window from 1 to 10 seconds.
- `--limit` sets how many groups appear in each ranking. The quit menu stays capped at five.
- `--report-only` skips interactive prompts.
- `--no-animation` disables typing and selection effects.

## Languages

English is the fallback. `fuckslow` checks `LC_ALL`, `LC_MESSAGES`, and `LANG` in that order. macOS then checks the preferred system language, while Windows checks the user locale.

Set a locale for one run:

```sh
LC_ALL=zh_CN.UTF-8 fuckslow
LC_ALL=en_US.UTF-8 fuckslow
```

## Requirements

- Python 3.10 or later.
- macOS has no third-party runtime dependencies.
- Linux and Windows install [psutil](https://psutil.readthedocs.io/) in a private virtual environment.

## Development

```sh
git clone https://github.com/DOGTT/fuckslow.git
cd fuckslow
python3 -m pip install -r requirements.txt  # Linux/Windows
./fuckslow --report-only
```

On Windows PowerShell, run:

```powershell
python -m pip install -r requirements.txt
.\fuckslow.cmd --report-only
```

The main CLI is a standalone Python script. Linux and Windows use psutil for process and system metrics.

## License

MIT. See [LICENSE](LICENSE).

## Contributing

Bug reports and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).
