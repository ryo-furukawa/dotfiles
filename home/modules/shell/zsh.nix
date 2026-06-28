{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true; # 旧 zsh-completions プラグインの代替

    # 旧 OMZ プラグインの代替(手動 clone 不要・HM がパッケージ管理)
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ]; # autosuggestion 等は上のネイティブに移したので git のみ
    };

    # 旧 .zshenv の cargo env を移植(.zshenv 相当 = ログイン前に評価)
    envExtra = ''
      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    '';

    # Homebrew の PATH/MANPATH 等を通す。cask で入れた GUI アプリの CLI
    # (code/obsidian 等)や brew 本体を対話シェルから使えるようにする。
    # Apple Silicon は /opt/homebrew、Intel は /usr/local に brew がある。
    initContent = ''
      if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi
    '';
  };

  # 旧 PATH 追加を移植。
  home.sessionPath = [ "$HOME/.local/bin" ];
}
