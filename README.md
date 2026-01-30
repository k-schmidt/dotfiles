# ⚡️ Dotfiles

This is an automated developer environment setup for macOS, built with **chezmoi**. It is opinionated and optimized for AI Engineering, Data Infrastructure, and high-performance workflows.

## 🛠 The Stack

* **Core:** `zsh`, `chezmoi`, `homebrew`
* **Editor:** [Cursor](https://cursor.sh) (AI-native) & VS Code
* **Terminal:** iTerm2 with [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
* **Python:** `uv` (Blazing fast package management)
* **AI Agents:** `claude-code`, `ollama`
* **Infra:** `orbstack` (Docker replacement), `direnv`, `gh`
* **Productivity:** Raycast, Obsidian, Todoist

## 🚀 Installation (Fresh Machine)

1. **Install Xcode Command Line Tools:**
```bash
xcode-select --install

```


2. **Bootstrap & Apply:**
Run this single command to install Homebrew, clone this repo, and set up the machine.
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply k-schmidt

```


*(Replace `k-schmidt` with your actual GitHub username)*

## 🛑 Post-Install (Manual Steps)

Automation gets us 95% of the way there. Complete these steps manually:

1. **Authenticate Tools:**
* **GitHub:** `gh auth login`
* **Claude:** `claude auth login`
* **OrbStack:** Open the app once to initialize the Docker engine.


2. **Terminal Fonts (Critical):**
* Open iTerm2 → *Settings* (`Cmd+,`) → *Profiles* → *Text*.
* Set Font to **JetBrainsMono Nerd Font**.
* *Without this, the prompt icons will be broken squares.*


3. **System Permissions:**
* **System Settings > Privacy & Security > Accessibility**: Grant access to iTerm2 and Raycast.
* **Touch ID for Sudo:** The script attempts to enable this, but if `sudo` still asks for a password, run:
```bash
sudo sed -i '' '2i\auth       sufficient     pam_tid.so' /etc/pam.d/sudo

```

## 🔧 Workflow & Maintenance

### Adding a new tool (Brew)

Don't install manually. Add it to the manifest:

1. Edit the Brewfile: `chezmoi edit ~/.config/brew/Brewfile`
2. Apply changes: `chezmoi apply`

### Editing Configs

To change your `.zshrc`, `.gitconfig`, etc.:

1. `chezmoi edit ~/.zshrc`
2. `chezmoi apply`

### Saving Changes

When you are happy with your setup, push changes back to GitHub:

```bash
cd ~/.local/share/chezmoi
git add .
git commit -m "feat: updated config"
git push

```

## 📂 Structure

* `run_onchange_install-packages.sh`: Watches `Brewfile` and runs `brew bundle`.
* `dot_config/brew/Brewfile`: The master list of all software.
* `dot_zshrc`: Shell configuration (OMZ, Plugins, Aliases).
* `run_once_*.sh`: Setup scripts that run only on the first install (macOS defaults, node tools, etc).