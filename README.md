# vscode-extension-hoge

VSCode Extension のサンプルプロジェクト。`curl | bash` の1行で GitHub Releases から最新の `.vsix` をダウンロード＆インストールできます。

## インストール

```bash
curl -fsSL https://raw.githubusercontent.com/s4na/vscode-extension-hoge/main/install.sh | bash
```

## アンインストール

```bash
code --uninstall-extension s4na.hoge
```

## 機能

コマンドパレット（`Cmd+Shift+P` / `Ctrl+Shift+P`）から `Hoge: Hello World` を実行すると、メッセージが表示されます。

## 開発

```bash
git clone https://github.com/s4na/vscode-extension-hoge.git
cd vscode-extension-hoge
mise install
npm install
```

VSCode で開いて `F5` を押すと Extension Development Host が起動します。

## リリース

```bash
git tag v0.1.0
git push --tags
```

GitHub Actions が `.vsix` をビルドし、Release に添付します。
