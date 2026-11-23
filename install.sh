#!/bin/sh
set -eu

REPO="${FUCKSLOW_REPO:-DOGTT/fuckslow}"
BRANCH="${FUCKSLOW_BRANCH:-main}"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
INSTALL_DIR="$DATA_HOME/fuckslow"
BIN_DIR="${XDG_BIN_HOME:-$HOME/.local/bin}"
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT
trap 'exit 1' HUP INT TERM

PYTHON_BIN="${PYTHON:-}"
if [ -z "$PYTHON_BIN" ]; then
    if command -v python3 >/dev/null 2>&1; then
        PYTHON_BIN=python3
    elif command -v python >/dev/null 2>&1; then
        PYTHON_BIN=python
    else
        echo "fuckslow needs Python 3.10+. Install Python and rerun this command." >&2
        exit 1
    fi
fi

"$PYTHON_BIN" -c 'import sys; raise SystemExit(sys.version_info < (3, 10))' || {
    echo "fuckslow needs Python 3.10 or later." >&2
    exit 1
}

SOURCE_DIR=""
SCRIPT_PATH="${BASH_SOURCE:-$0}"
if [ -f "$SCRIPT_PATH" ]; then
    CANDIDATE_DIR="$(CDPATH= cd -- "$(dirname -- "$SCRIPT_PATH")" && pwd)"
    if [ -f "$CANDIDATE_DIR/fuckslow" ]; then
        SOURCE_DIR="$CANDIDATE_DIR"
    fi
fi

if [ -z "$SOURCE_DIR" ]; then
    ARCHIVE="$TEMP_DIR/source.tar.gz"
    URL="https://codeload.github.com/$REPO/tar.gz/refs/heads/$BRANCH"
    echo "Downloading $REPO ($BRANCH)…"
    curl -fsSL "$URL" -o "$ARCHIVE"
    tar -xzf "$ARCHIVE" -C "$TEMP_DIR"
    SOURCE_DIR="$TEMP_DIR/$(tar -tzf "$ARCHIVE" | sed -n '1s@/.*@@p')"
fi

mkdir -p "$INSTALL_DIR" "$BIN_DIR"
cp "$SOURCE_DIR/fuckslow" "$INSTALL_DIR/fuckslow"
chmod 755 "$INSTALL_DIR/fuckslow"

case "$(uname -s)" in
    Linux)
        "$PYTHON_BIN" -m venv "$INSTALL_DIR/.venv"
        "$INSTALL_DIR/.venv/bin/python" -m pip install --disable-pip-version-check 'psutil>=6,<8'
        ;;
    Darwin)
        ;;
    *)
        echo "Use install.ps1 from Windows PowerShell." >&2
        exit 1
        ;;
esac

cat > "$BIN_DIR/fuckslow" <<'LAUNCHER'
#!/bin/sh
INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fuckslow"
if [ -x "$INSTALL_DIR/.venv/bin/python" ]; then
    exec "$INSTALL_DIR/.venv/bin/python" "$INSTALL_DIR/fuckslow" "$@"
fi
exec python3 "$INSTALL_DIR/fuckslow" "$@"
LAUNCHER
chmod 755 "$BIN_DIR/fuckslow"

case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *)
        echo "Add this directory to PATH to run fuckslow by name:"
        echo "  $BIN_DIR"
        ;;
esac

echo "Installed fuckslow in $INSTALL_DIR"
echo "Run: $BIN_DIR/fuckslow"
