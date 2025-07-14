# neurofetch

Simple script that installs `neofetch` and sets it up to run on every shell start.

Also adds a shortcut alias called `fuckit` — which just clears the terminal and runs `neofetch`, because sometimes that’s all I need to feel like my system’s clean and ready.

---

## What it does

- Installs `neofetch` via available package manager (`apt`, `pacman`, `brew`)
- If that fails — pulls directly from GitHub and installs manually
- Detects your shell (`bash` or `zsh`) and appends `neofetch` + `alias fuckit='clear && neofetch'` to your RC file
- Tested on:
  - Ubuntu / Debian
  - macOS
  - Rocky Linux / Alma / CentOS

---

## Why?

Because I like seeing `neofetch` every time I open a terminal.  
And I like typing `fuckit` even more.

This script is part of my personal learning process — Bash scripting, Git, VS Code, writing halfway decent setup scripts.  
Nothing fancy. But it works.



## Installation

Using `curl`:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/neurogeneraptor/neurofetch/main/install.sh)
```

Using `wget`

```bash
wget -qO- https://raw.githubusercontent.com/neurogeneraptor/neurofetch/main/install.sh | bash
```

Or any way you want...




## Disclaimer

This project is not affiliated with the original [neofetch](https://github.com/dylanaraps/neofetch). 
It simply installs and configures it automatically for personal or educational use.
