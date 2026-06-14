{ ... }:
{
  # ここに各モジュールを追加していく。
  imports = [
    ./shell/zsh.nix
    ./git/git.nix
    ./git/gh.nix
  ];
}
