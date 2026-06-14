# dotfiles

macOS (Apple Silicon) の環境を **Nix Flakes + nix-darwin + home-manager** で
宣言的に管理する dotfiles。`make switch` 一発で CLI ツール・dotfiles・
(将来は)GUI アプリや macOS システム設定を再現する。

## 前提

- macOS (Apple Silicon / `aarch64-darwin`)
- [Determinate Systems 版 Nix](https://docs.determinate.systems/) を使用

### なぜ Determinate 版の Nix か

公式インストーラではなく Determinate 版を選んでいる理由:

- **flakes / nix-command がデフォルトで有効**。`experimental-features` を手で設定しなくてよい。
- **アンインストールが安全・確実**。専用のアンインストーラで綺麗に戻せる。
- **macOS アップデートで壊れにくい**。OS アップデートで `/nix` マウントが飛ぶ問題の復旧を自動化している。
- 独自デーモン (`determinate-nixd`) が Nix 本体を管理する。このため nix-darwin 側の
  Nix 管理とは衝突する → `nix.enable = false` で無効化している(後述)。

## 構成

```
.
├── flake.nix                 # 入口: inputs + darwinConfigurations
├── Makefile                  # make switch / build / update / fmt
├── hosts/
│   └── private/default.nix   # ホスト固有設定(個人 PC)
└── home/
    ├── default.nix           # home-manager の入口
    └── modules/              # 機能ごとのモジュール
        ├── shell/zsh.nix
        ├── git/  git.nix gh.nix
        └── cli/  utils.nix
```

`darwinConfigurations.<profile>` を nix-darwin で生成し、その中に
home-manager を組み込む統合構成。`make switch` で system + user を一括適用する。

## 初回セットアップ

### 1. Nix をインストール (Determinate 版)

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. このリポジトリを clone

clone 先はどこでもよい。以後はそのディレクトリで作業する。

```sh
git clone https://github.com/ryo-furukawa/dotfiles.git
cd dotfiles
```

### 3. マシン固有の git 設定を作成 (重要)

git の email はマシンごとに変えるため **リポジトリには含めていない**。
clone 後、以下のファイルを手動で作成する:

`~/.gitconfig.local`

```ini
[user]
	email = あなたのメールアドレス
```

この値は Nix 生成の `~/.gitconfig` から `[include]` 経由で読み込まれる。
(表示名 `user.name` は共通なので Nix 側で管理している)

### 4. 適用

```sh
make switch
```

初回は `darwin-rebuild` がまだ無いので、代わりに以下で起動する:

```sh
nix run nix-darwin -- switch --flake .#private
```

適用後、**新しいターミナルを開く** と設定が反映される。

## 日常の操作 (Makefile)

| コマンド | 内容 |
| --- | --- |
| `make switch` | 設定を適用 |
| `make build` | 適用せずビルドだけ試す |
| `make update` | flake の input を更新 |
| `make fmt` | nix ファイルを整形 |

`PROFILE` はデフォルト `private`。会社 PC 等は `make switch PROFILE=work` で切り替える。

## 設計上のメモ

- **`nix.enable = false`**: Determinate Nix と nix-darwin の Nix 管理が衝突するため無効化。
- **`programs.zsh.enable = true` (nix-darwin 側)**: `/etc/zshrc` に Nix プロファイルを
  PATH へ通す初期化を挿入する。これがないと Nix 版コマンドが PATH に乗らない。
- **git 管理外ファイル**: `~/.gitconfig.local` はマシン固有値のため追跡しない。
  退避した旧設定は `~/.*.pre-nix` に残してある。

## トラブルシュート

- **`make switch` が "would be clobbered" で止まる**:
  既存ファイルと衝突。`flake.nix` の `home-manager.backupFileExtension` で自動退避するが、
  想定外のファイルなら手動で `.backup` 等にリネームする。
- **Nix で入れたコマンドが使われない (`which` が古いパスを指す)**:
  PATH 順序の問題。`~/.zlogin` 等が PATH を上書きしていないか確認する。
