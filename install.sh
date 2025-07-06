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

    # Detect package manager
    INSTALL_FROM_PM=false
    if command -v apt &>/dev/null; then
        PM="$SUDO apt install -y"
        INSTALL_FROM_PM=true
    elif command -v pacman &>/dev/null; then
        PM="$SUDO pacman -S --noconfirm"
        INSTALL_FROM_PM=true
    elif command -v brew &>/dev/null; then
        PM="brew install"  # brew не требует sudo
        INSTALL_FROM_PM=true
    else
        echo "No known package manager found. Will try installing from GitHub..."
    fi

    # Try package manager if available
    if [[ "$INSTALL_FROM_PM" == true ]]; then
        if $PM neofetch; then
            echo "Neofetch installed via package manager."
        else
            echo "Package manager failed. Trying GitHub..."
            INSTALL_FROM_GITHUB=true
        fi
    else
        INSTALL_FROM_GITHUB=true
    fi

    # Try GitHub installation
    if [[ "$INSTALL_FROM_GITHUB" == true ]]; then
        if git clone https://github.com/dylanaraps/neofetch "$HOME/neofetch-git" \
            && cd "$HOME/neofetch-git" \
            && $SUDO make install; then
            echo "Neofetch installed from GitHub."
        else
            echo "Both package manager and GitHub installation failed. Your system sucks. Bye!"
            exit 1
        fi
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