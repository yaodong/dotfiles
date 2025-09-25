# Arch Linux (Wayland) — Fcitx5 Pinyin Quick Setup

A concise, Wayland‑native setup that works on GNOME, KDE, Sway, Hyprland, etc.

## 1) Install

```bash
sudo pacman -S fcitx5 fcitx5-configtool fcitx5-chinese-addons fcitx5-pinyin-zhwiki
# Optional, for Xwayland apps: fcitx5-gtk fcitx5-qt
```

- **core:** `fcitx5`
- **config tool:** `fcitx5-configtool`
- **IME (Pinyin, emoji, cloud, etc.):** `fcitx5-chinese-addons`
- **big dictionary:** `fcitx5-pinyin-zhwiki`

## 2) Add Pinyin

```bash
fcitx5-configtool
```

- Open **Input Method → +**
- Search **"Pinyin"** and add **Pinyin**
- Reorder if needed (keep your keyboard layout first)

## 3) Wayland integration

- **Native Wayland apps**: no env vars required (uses text-input protocol)
- **Xwayland apps that misbehave**: set IM modules
```bash
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
```

## 4) Hotkeys

- **Toggle IM on/off**: Ctrl + Space
- Change in **Fcitx5 Configuration → Global Options → Hotkey**

## 5) Start / Autostart

- If not started: run `fcitx5 &`
- KDE Wayland: **System Settings → Input Devices → Virtual Keyboard → Fcitx 5**
- GNOME Wayland: install Kimpanel for popups (AUR: `gnome-shell-extension-kimpanel-git`)

## 6) Troubleshooting (Wayland)

- Restart Fcitx5: `pkill fcitx5 && fcitx5 &`
