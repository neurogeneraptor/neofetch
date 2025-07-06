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

    INSTALL_FROM_PM=false
    INSTALL_FROM_URL=false

    # Detect package manager
    if command -v apt &>/dev/null; then
        PM="$SUDO apt install -y"
        INSTALL_FROM_PM=true
    elif command -v pacman &>/dev/null; then
        PM="$SUDO pacman -S --noconfirm"
        INSTALL_FROM_PM=true
    elif command -v brew &>/dev/null; then
        PM="brew install"
        INSTALL_FROM_PM=true
    else
        echo "No known package manager found. Will try installing from GitHub..."
        INSTALL_FROM_URL=true
    fi

    # Try package manager
    if [[ "$INSTALL_FROM_PM" == true ]]; then
        if $PM neofetch; then
            echo "Neofetch installed via package manager."
        else
            echo "Package manager failed. Will try installing from GitHub..."
            INSTALL_FROM_URL=true
        fi
    fi

    # Try GitHub (raw script) install
    if [[ "$INSTALL_FROM_URL" == true ]]; then
        INSTALL_DIR="$HOME/.local/bin"
        mkdir -p "$INSTALL_DIR"
        INSTALL_PATH="$INSTALL_DIR/neofetch"

        if command -v curl &>/dev/null; then
            curl -fsSL https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch -o "$INSTALL_PATH"
        elif command -v wget &>/dev/null; then
            wget -q https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch -O "$INSTALL_PATH"
        else
            echo "Neither curl nor wget found. Can't install neofetch. Bye!"
            exit 1
        fi

        chmod +x "$INSTALL_PATH"
        echo "Neofetch installed to $INSTALL_PATH"

        # Add to PATH if not already present
        if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
            if [ -f ~/.bashrc ]; then
                echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> ~/.bashrc
            elif [ -f ~/.zshrc ]; then
                echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> ~/.zshrc
            fi
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
echo -e "Now run: \e[32msource ~/.bashrc\e[0m or \e[36msource ~/.zshrc\e[0m or open new terminal"
sleep 1
echo -e 'After that you can use \e[33m"fuckit"\e[0m alias to combine "clear" and "neofetch" commands'
exit 0
