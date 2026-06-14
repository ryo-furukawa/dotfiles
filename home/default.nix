{ username, ... }:
{
  # modules/ 配下の設定をまとめて読み込む。
  imports = [ ./modules ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
