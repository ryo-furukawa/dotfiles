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

  # flakes と新 CLI を有効化(Determinate Nix では既定で有効だが明示しておく)。
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
