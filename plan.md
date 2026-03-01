# VSCode Extension サンプルプロジェクト 構築計画

## Context

`curl | bash` の1行で GitHub Releases から最新の `.vsix` をダウンロード＆インストールできる VSCode Extension のサンプルを作る。リポジトリは `s4na/vscode-extension-hoge` で、現在は README.md のみの空状態。ランタイム管理には mise を使用。

## 構成概要

```
vscode-extension-hoge/
├── .github/
│   └── workflows/
│       └── release.yml          # tag push で vsix をビルド & Release に添付
├── .vscode/
│   └── launch.json              # 拡張機能デバッグ用
├── src/
│   └── extension.ts             # エントリポイント（Hello World）
├── .gitignore
├── .mise.toml                   # mise で Node.js バージョン管理
├── .vscodeignore
├── install.sh                   # curl | bash 用インストールスクリプト
├── package.json                 # 拡張機能マニフェスト
├── tsconfig.json
├── plan.md                      # この計画書
└── README.md                    # 使い方を記載
```

## 実装ステップ

### Step 1: mise + VSCode Extension の雛形作成

**対象ファイル:** `.mise.toml`, `package.json`, `tsconfig.json`, `.gitignore`, `.vscodeignore`, `.vscode/launch.json`

- `.mise.toml`: Node.js 22 を指定
- `package.json`: 拡張機能マニフェスト（name: `hoge`, publisher: `s4na`, activationEvents, contributes でコマンド `hoge.helloWorld` 登録）
- `tsconfig.json`: TypeScript コンパイル設定（target: ES2020, module: commonjs, outDir: out）
- `.gitignore`: `node_modules/`, `out/`, `*.vsix`
- `.vscodeignore`: ビルド不要ファイルの除外
- `.vscode/launch.json`: Extension Development Host 起動設定

### Step 2: Extension 本体の実装

**対象ファイル:** `src/extension.ts`

- `activate()` で `hoge.helloWorld` コマンドを登録
- 実行すると `vscode.window.showInformationMessage("Hello World from Hoge!")` を表示
- シンプルな Hello World で動作確認しやすくする

### Step 3: install.sh の作成

**対象ファイル:** `install.sh`

- GitHub API (`repos/s4na/vscode-extension-hoge/releases/latest`) から最新リリースの `.vsix` URL を取得
- `/tmp/hoge.vsix` にダウンロード → `code --install-extension` → 一時ファイル削除
- エラーハンドリング（`code` コマンドの存在確認、curl 失敗時のメッセージ）

使い方:
```bash
curl -fsSL https://raw.githubusercontent.com/s4na/vscode-extension-hoge/main/install.sh | bash
```

### Step 4: GitHub Actions ワークフロー

**対象ファイル:** `.github/workflows/release.yml`

- **トリガー:** `v*` タグの push（例: `v0.1.0`）
- **ジョブ:**
  1. チェックアウト
  2. mise で Node.js セットアップ
  3. `npm install`
  4. `npx vsce package` で `.vsix` をビルド
  5. `gh release create` でタグ名のリリースを作成し `.vsix` を添付

### Step 5: README.md の更新

- プロジェクトの説明
- インストール方法（curl ワンライナー）
- 開発方法（clone → mise install → npm install → F5 でデバッグ）
- リリース方法（`git tag v0.x.0 && git push --tags`）

## リリースフロー

```
git tag v0.1.0
git push --tags
  → GitHub Actions が起動
  → .vsix をビルド
  → GitHub Release に .vsix を添付
  → ユーザーは curl | bash で最新版をインストール
```

## 検証方法

1. `mise install` → `npm install` → `npx vsce package` でローカルビルド確認
2. 生成された `.vsix` を `code --install-extension` で手動インストール
3. VSCode でコマンドパレット → `Hoge: Hello World` が動くか確認
4. タグ push 後、GitHub Actions が成功し Release に `.vsix` が添付されるか確認
5. `install.sh` で最新版がインストールできるか確認
