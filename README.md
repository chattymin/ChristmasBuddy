# 🎄 Christmas Desktop Buddy

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-blue?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/macOS-13.0+-green?style=flat-square" alt="macOS Version">
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=flat-square" alt="Swift">
  <img src="https://img.shields.io/badge/Built%20with-Claude%20Code-blueviolet?style=flat-square" alt="Built with Claude Code">
</p>

<p align="center">
  <strong>🌐 Language / 언어 / 言語</strong><br>
  <a href="#english">English</a> • <a href="README_ko.md">한국어</a> • <a href="README_ja.md">日本語</a>
</p>

<p align="center">
  <a href="https://chattymin.github.io/ChristmasBuddy/">🌐 Website</a> •
  <a href="https://github.com/chattymin/ChristmasBuddy/releases/latest">⬇️ Download</a>
</p>

---

<a name="english"></a>

## ✨ About

**Christmas Desktop Buddy** is a cute desktop companion app for macOS that brings Christmas spirit to your screen! A charming character lives on your desktop, delivering time-based messages and collecting scattered gift boxes.

> 🤖 **100% Vibe Coded with Claude Code**
>
> This entire project was created through vibe coding with [Claude Code](https://claude.ai/download) - Anthropic's official CLI for Claude. From concept to implementation, every line of code was generated through natural conversation with AI.

## 🎬 Preview

<p align="center">
  <strong>⛄ Snowman</strong> • <strong>🎅 Santa</strong> • <strong>🦌 Rudolph</strong>
</p>

## 🎁 Features

| Feature | Description |
|---------|-------------|
| 💬 **Time-based Messages** | Receive different cute messages based on the time of day (morning, lunch, afternoon, evening, night) |
| 🎁 **Gift Box Collection** | Scatter gift boxes across the screen and watch your character collect them |
| 💃 **Idle Animation** | Characters move and breathe like they're alive |
| 😵‍💫 **Dizzy Reaction** | Drag the character for too long and they'll get dizzy! |
| 🔋 **Battery Alert** | Get notified when your battery is low |
| ❄️ **Animated Menu Bar** | Watch snow fall on the Christmas tree in your menu bar |
| 🎭 **Multiple Characters** | Choose between Snowman, Santa, and Rudolph |
| 💭 **Random Greetings** | Character randomly says hello every 15-30 minutes |
| 🌨️ **Snow Effect** | Beautiful snow falling effect across all your monitors |

## 📥 Download & Installation

### Download
👉 **[Download Latest Release](https://github.com/chattymin/ChristmasBuddy/releases/latest)**

### Installation Steps
1. Download the DMG file from the link above
2. Open the DMG and drag the app to your Applications folder
3. **Important**: Run this command in Terminal to remove quarantine:
   ```bash
   xattr -cr /Applications/ChristmasDesktopBuddy.app
   ```
4. On first launch, go to `System Settings > Privacy & Security` and allow the app to run
5. Use the 🎄 icon in the menu bar to change characters and settings

## 💻 System Requirements

- **macOS 13.0 (Ventura)** or later
- Apple Silicon & Intel supported

## 🛠️ Build from Source

```bash
# Clone the repository
git clone https://github.com/chattymin/ChristmasBuddy.git
cd ChristmasBuddy

# Build the app
./build_app.sh

# Run the app
open ChristmasDesktopBuddy.app

# Create DMG (for distribution)
./create_dmg.sh
```

## 📁 Project Structure

```
ChristmasDesktopBuddy/
├── Sources/
│   ├── App/                  # App entry point
│   ├── Core/                 # Core components
│   ├── Features/             # Feature modules
│   │   ├── InfoDisplay/      # Info display system
│   │   ├── Message/          # Message system
│   │   └── Box/              # Gift box system
│   ├── Models/               # Data models
│   └── Resources/            # Resources (SVG characters)
└── Package.swift
```

## 🤖 About Vibe Coding

This project is a showcase of **vibe coding** - a new development paradigm where you describe what you want in natural language and AI generates the code.

Every feature in this app was created by simply describing the desired functionality to Claude Code:
- "Add a snowman character that moves around"
- "Make the character collect gift boxes"
- "Add time-based greeting messages"
- "Create an animated snow-falling tree icon for the menu bar"

No manual coding required - just vibes! ✨

## 📄 License

MIT License - See [LICENSE](LICENSE) for details.

## 🙏 Credits

- Built 100% with [Claude Code](https://claude.ai/download) by Anthropic
- Made with ❤️ for Christmas

---

<p align="center">
  🎄 Merry Christmas! 🎄
</p>
