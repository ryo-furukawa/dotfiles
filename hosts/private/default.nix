{ username, ... }:
{
  # このマシンの CPU/OS。Apple Silicon なので aarch64-darwin。
  nixpkgs.hostPlatform = "aarch64-darwin";

  # vscode, 1password など「フリーでない」パッケージを許可する。
  # これがないと一部 GUI/ツールのインストールで拒否される。
  nixpkgs.config.allowUnfree = true;

  # nix-darwin の状態バージョン。初回構築時の値で固定し、以後は変えない
  # (互換性の基準点。Nix がアップグレード時の移行判断に使う)。
  system.stateVersion = 6;

  # macOS のシステム設定(Dock 等)を適用する対象ユーザー。
  system.primaryUser = username;

  # ユーザーのホームディレクトリを nix-darwin に教える。
  users.users.${username}.home = "/Users/${username}";

  # Determinate Nix を使っているため、Nix 本体の管理は Determinate に任せる。
  # nix-darwin が Nix を管理しようとすると衝突するので無効化する。
  # (flakes 等は Determinate 側で既に有効化済みなので nix.settings は不要)
  nix.enable = false;

  # nix-darwin に /etc/zshrc を管理させ、Nix プロファイル
  # (/etc/profiles/per-user/$USER/bin 等)を PATH へ通す初期化を挿入する。
  # これがないと git/delta/gh などの Nix 版が PATH に乗らず、
  # システムや Homebrew の古いコマンドが優先されてしまう。
  programs.zsh.enable = true;

  # GUI アプリ等は Homebrew cask 経由で「宣言だけ」Nix 管理する。
  # 実体のインストールは brew が行う(nix-darwin は宣言と実体の同期役)。
  # 既に手動 brew で入れたものは冪等にスキップされる。
  homebrew = {
    enable = true;

    onActivation = {
      # 宣言にない cask/formula を絶対に消さない。手動インストール済みの
      # 既存アプリ(Raycast 等)を守るための最重要設定。
      cleanup = "none";
      # switch のたびに brew update / upgrade を走らせない(遅延・意図しない更新を防ぐ)。
      autoUpdate = false;
      upgrade = false;
    };

    casks = [
      "ghostty"
      "blackhole-2ch"
      "claude-code"
    ];
  };
}
