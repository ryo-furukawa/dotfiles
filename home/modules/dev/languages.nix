{ pkgs, ... }:
{
  # グローバルに置く言語ランタイム。
  # プロジェクト外で雑に動かすための土台で、各プロジェクトでは direnv + nix-direnv が
  # flake/shell.nix で宣言した版でこれを上書きする(cli/utils.nix の direnv 設定を参照)。
  # ruby はここに置かず、必要なプロジェクトでだけ direnv 経由で入れる。
  home.packages = with pkgs; [
    nodejs
    python3
    go
  ];
}
