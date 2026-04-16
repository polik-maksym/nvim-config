#!/usr/bin/env bash

set -e

CONFIG_DIR="$HOME/.config"
NVIM_DIR="$CONFIG_DIR/nvim"
REPO_DIR="$(pwd)/nvim"

echo ">>> Installing Neovim config..."

mkdir -p "$CONFIG_DIR"

if [ -d "$NVIM_DIR" ] || [ -L "$NVIM_DIR" ]; then
    echo ">>> Removing old ~/.config/nvim"
    rm -rf "$NVIM_DIR"
fi

echo ">>> Creating symlink ~/.config/nvim -> $REPO_DIR"
ln -s "$REPO_DIR" "$NVIM_DIR"

echo ">>> Done! Start Neovim and Lazy will install plugins automatically."
