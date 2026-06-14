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
}
