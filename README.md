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

`main` ブランチにプッシュすると、GitHub Actions が `package.json` のバージョンを読み取り、自動で `.vsix` をビルドして Release を作成します。

新しいリリースを作るには `package.json` の `version` を更新してプッシュしてください。同じバージョンのリリースが既に存在する場合はスキップされます。
