{ pkgs, ... }:
{
  # ── パッケージを入れるだけ系(設定不要のツール) ──
  # PATH に通すだけでよいツールはここに列挙する。
  home.packages = with pkgs; [
    # TODO: ripgrep, fd, bat, eza, jq, yq, httpie を列挙する
  ];

  # ── プログラムモジュール系(設定・シェル統合あり) ──

  # fzf: ファジーファインダ。zsh 統合を有効にするとキーバインド(Ctrl-R 等)が入る
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # zoxide: 賢い cd。よく行くディレクトリを学習してジャンプできる
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # direnv: ディレクトリ毎に環境変数/シェルを自動ロード。
  # nix-direnv を有効にすると `use flake` のキャッシュ層が入り、cd の度の評価が高速になる。
  # プロジェクトごとの言語環境はこの仕組みで閉じる(global は dev/languages.nix)。
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
