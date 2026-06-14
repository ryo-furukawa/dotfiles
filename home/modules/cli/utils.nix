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
    # TODO: zsh との統合を有効にするオプションを 1 行追加する
  };

  # zoxide: 賢い cd。よく行くディレクトリを学習してジャンプできる
  programs.zoxide = {
    enable = true;
  };

  # direnv: ディレクトリ毎に環境変数/シェルを自動ロード。nix と相性が良い
  programs.direnv = {
    enable = true;
  };
}
