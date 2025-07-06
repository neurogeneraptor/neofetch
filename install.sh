#!/usr/bin/env bash

# Abort if script is run via sudo (protects root's rc file)
if [[ "$EUID" -eq 0 && -n "$SUDO_USER" ]]; then
    echo "Don't run this script with sudo. It will fuck your root's rc file."
    exit 1
fi

# Check if neofetch is installed
if ! command -v neofetch &>/dev/null; then
    echo "Neofetch not found. Attempting to install..."
    
    # Determine sudo usage
    if [[ "$EUID" -ne 0 ]]; then
        SUDO="sudo"
    else
        SUDO=""
    fi 

    # Detect package manager (apt/pacman/brew)
    if command -v apt &>/dev/null; then
        PM="apt install -y"
    elif command -v pacman &>/dev/null; then
        PM="pacman -S --noconfirm"
    elif command -v brew &>/dev/null; then
        PM="brew install"
    else
        echo "You have no apt, pacman or brew, so your system sucks."
        sleep 1
        echo "My script doesn't. Bye!"
        exit 1  
    fi

    # Install neofetch
    if ! $SUDO $PM neofetch; then
        echo "Installation failed. Unexpected error. I'm sorry. Bye!"
        exit 1
    fi
else
    echo "Neofetch already installed"
fi

# Detect shell (bash or zsh)
if [ -f ~/.bashrc ]; then
    RC=~/.bashrc
elif [ -f ~/.zshrc ]; then
    RC=~/.zshrc
else
    echo "No supported shell RC file found (.bashrc or .zshrc). Bye!"
    exit 1
fi

# Update RC file with neofetch
if ! grep -q "neofetch" "$RC"; then
    echo "" >> "$RC"
    echo "neofetch" >> "$RC"
fi

# Update RC file with alias
if ! grep -q "alias fuckit=" "$RC"; then
    echo "" >> "$RC"
    echo "alias fuckit='clear && neofetch'" >> "$RC"
fi

# Final output
echo "Installation complete successfully!"
sleep 1
echo "Now run:  source ~/.bashrc   or   source ~/.zshrc   or open new terminal"
sleep 1
echo 'After that you can use "fuckit" alias to combine "clear" and "neofetch" commands'
exit 0