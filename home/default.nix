{ username, ... }:
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # home-manager の状態バージョン。初回構築時の値で固定し、以後は変えない。
  home.stateVersion = "24.11";

  # home-manager 自身を home-manager で管理できるようにする(定番のおまじない)。
  programs.home-manager.enable = true;

  # ↓ Phase 1 の動作確認用に、zsh をプレーン構成で有効化する。
  #   OMZ や各種ツールは Phase 2 以降で足していく。
  programs.zsh.enable = true;
}
