
#!/usr/bin/env bash
set -e

CONFIG_DIR="$HOME/.config"
NVIM_DIR="$CONFIG_DIR/nvim"
REPO_DIR="$(pwd)/nvim"

# -----------------------------
# 1. Check dependencies
# -----------------------------
check_dep() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "❌ Missing dependency: $1"
        MISSING_DEPS+=("$1")
    else
        echo "✔ $1 found"
    fi
}

echo ">>> Checking dependencies..."
MISSING_DEPS=()

check_dep nvim
check_dep git
check_dep curl
check_dep unzip
check_dep rg
check_dep fd

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo "----------------------------------------"
    echo "❗ Missing dependencies detected:"
    printf '%s\n' "${MISSING_DEPS[@]}"
    echo "----------------------------------------"
    echo "Please install them manually before continuing."
    exit 1
fi

# -----------------------------
# 2. Install Nerd Fonts (JetBrainsMono)
# -----------------------------
install_nerd_font() {
    FONT_NAME="JetBrainsMono"
    FONT_DIR="$HOME/.local/share/fonts"

    if fc-list | grep -qi "$FONT_NAME"; then
        echo "✔ Nerd Font already installed: $FONT_NAME"
        return
    fi

    echo ">>> Installing Nerd Font: $FONT_NAME"
    mkdir -p "$FONT_DIR"

    curl -L -o /tmp/JBM.zip \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

    unzip -o /tmp/JBM.zip -d "$FONT_DIR"
    fc-cache -fv

    echo "✔ Nerd Font installed"
}

install_nerd_font

# -----------------------------
# 3. Create ~/.config and symlink
# -----------------------------
echo ">>> Installing Neovim config..."

mkdir -p "$CONFIG_DIR"

if [ -d "$NVIM_DIR" ] || [ -L "$NVIM_DIR" ]; then
    echo ">>> Removing old ~/.config/nvim"
    rm -rf "$NVIM_DIR"
fi

echo ">>> Creating symlink ~/.config/nvim -> $REPO_DIR"
ln -s "$REPO_DIR" "$NVIM_DIR"

echo ">>> Done! Start Neovim and Lazy will install plugins automatically."
