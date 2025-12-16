# 🎄 Christmas Desktop Buddy

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-blue?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/macOS-13.0+-green?style=flat-square" alt="macOS Version">
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=flat-square" alt="Swift">
  <img src="https://img.shields.io/badge/Built%20with-Claude%20Code-blueviolet?style=flat-square" alt="Built with Claude Code">
</p>

<p align="center">
  <strong>🌐 Language / 언어 / 言語</strong><br>
  <a href="README.md">English</a> • <a href="README_ko.md">한국어</a> • <a href="#japanese">日本語</a>
</p>

<p align="center">
  <a href="https://chattymin.github.io/ChristmasBuddy/">🌐 ウェブサイト</a> •
  <a href="https://github.com/chattymin/ChristmasBuddy/releases/latest">⬇️ ダウンロード</a>
</p>

---

<a name="japanese"></a>

## ✨ 概要

**Christmas Desktop Buddy**は、あなたのMacデスクトップにクリスマスの雰囲気をお届けする可愛いデスクトップコンパニオンアプリです！愛らしいキャラクターがデスクトップに住み、時間帯に合わせたメッセージを届けたり、散らばったギフトボックスを集めたりします。

> 🤖 **Claude Codeで100% バイブコーディング**
>
> このプロジェクトは、Anthropicの公式CLI [Claude Code](https://claude.ai/download)とのバイブコーディングで全て作成されました。コンセプトから実装まで、全てのコードがAIとの自然な会話を通じて生成されました。

## 🎬 プレビュー

<p align="center">
  <strong>⛄ 雪だるま</strong> • <strong>🎅 サンタ</strong> • <strong>🦌 ルドルフ</strong>
</p>

## 🎁 機能

| 機能 | 説明 |
|------|------|
| 💬 **時間帯別メッセージ** | 朝、昼、午後、夕方、夜の時間帯に合わせた可愛いメッセージを受け取れます |
| 🎁 **ギフトボックス収集** | 画面にギフトボックスを散らばせて、キャラクターが集めるのを見守りましょう |
| 💃 **アイドルアニメーション** | キャラクターが生きているように動きます |
| 😵‍💫 **めまい反応** | キャラクターを長時間ドラッグすると目が回ります！ |
| 🔋 **バッテリー通知** | バッテリーが少なくなるとお知らせします |
| ❄️ **メニューバーアニメーション** | メニューバーで雪が降るクリスマスツリーを見ることができます |
| 🎭 **複数キャラクター** | 雪だるま、サンタ、ルドルフから選べます |
| 💭 **ランダム挨拶** | キャラクターが15〜30分ごとにランダムに挨拶します |
| 🌨️ **雪エフェクト** | 接続されたすべてのモニターに美しい雪が降ります |

## 📥 ダウンロードとインストール

### ダウンロード
👉 **[最新版をダウンロード](https://github.com/chattymin/ChristmasBuddy/releases/latest)**

### インストール手順
1. 上記のリンクからDMGファイルをダウンロードしてください
2. DMGを開き、アプリをApplicationsフォルダにドラッグしてください
3. アプリを**右クリック** → **「開く」**を選択 → ダイアログで**「開く」**をクリック
4. メニューバーの🎄アイコンでキャラクター変更や設定を調整できます

> **注意**: コード署名されていないアプリのため、macOSがデフォルトでブロックします。右クリック → 開くで一度実行すれば、以降は通常のダブルクリックで起動できます。

## 💻 システム要件

- **macOS 13.0 (Ventura)** 以降
- Apple Silicon & Intel対応

## 🛠️ ソースからビルド

```bash
# リポジトリをクローン
git clone https://github.com/chattymin/ChristmasBuddy.git
cd ChristmasBuddy

# アプリをビルド
./build_app.sh

# アプリを実行
open ChristmasDesktopBuddy.app

# DMGを作成（配布用）
./create_dmg.sh
```

## 📁 プロジェクト構成

```
ChristmasDesktopBuddy/
├── Sources/
│   ├── App/                  # アプリエントリーポイント
│   ├── Core/                 # コアコンポーネント
│   ├── Features/             # 機能モジュール
│   │   ├── InfoDisplay/      # 情報表示システム
│   │   ├── Message/          # メッセージシステム
│   │   ├── Snow/             # 雪エフェクトシステム
│   │   └── Box/              # ギフトボックスシステム
│   ├── Models/               # データモデル
│   └── Resources/            # リソース（SVGキャラクター）
└── Package.swift
```

## 🤖 バイブコーディングとは？

このプロジェクトは**バイブコーディング**のショーケースです - 欲しいものを自然言語で説明すると、AIがコードを生成する新しい開発パラダイムです。

このアプリの全ての機能は、Claude Codeに欲しい機能を説明するだけで作成されました：
- 「動き回る雪だるまキャラクターを追加して」
- 「キャラクターがギフトボックスを集めるようにして」
- 「時間帯別の挨拶メッセージを追加して」
- 「メニューバーに雪が降るツリーのアニメーションアイコンを作って」
- 「接続されたすべてのモニターに雪を降らせて」

手動コーディングは不要 - バイブだけでOK！ ✨

## 📄 ライセンス

MIT License - 詳細は[LICENSE](LICENSE)を参照してください。

## 🙏 クレジット

- Anthropicの[Claude Code](https://claude.ai/download)で100%制作
- クリスマスのために❤️を込めて作りました

---

<p align="center">
  🎄 メリークリスマス！ 🎄
</p>
