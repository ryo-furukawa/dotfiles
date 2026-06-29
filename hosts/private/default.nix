{ username, ... }:
{
  # macOS システム設定(Dock/Finder/キーボード等)は別モジュールに分離。
  imports = [ ./macos-defaults.nix ];

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

    # CLI は原則 home-manager(Nix)で入れるが、nixpkgs に無いものだけ brew で
    # 宣言する。deck は k1LoW 製の Markdown→Google Slides 生成ツールで、nixpkgs
    # の同名 deck(Kong 用)とは別物のため Nix へ移行できず brew 管理を継続する。
    brews = [
      "deck"
    ];

    # 既存の手動インストール .app は、初回だけ `make adopt` を実行して brew
    # 管理下へ取り込む(nix-darwin の宣言経由では --adopt を渡せないため)。
    # adopt 済みなら以降の switch は冪等にスキップされる。詳細は Makefile 参照。
    casks = [
      "1password"
      "blackhole-2ch"
      "chatgpt"
      "claude"
      "claude-code"
      "dbeaver-community"
      "deepl"
      "discord"
      "docker-desktop"
      "figma"
      "ghostty"
      "google-chrome"
      "menubarx"
      "notion"
      "obsidian"
      "postman"
      "raycast"
      "slack"
      "tableplus"
      "visual-studio-code"
      "zoom"
    ];

    # 以下は /Applications にあるが、意図的に cask 宣言へ入れていないもの
    # (棚卸し済み。再検討の手間を省くため理由ごと記録する)。
    #
    # cask 化は可能だが手動運用のままにしているもの:
    #   AltTab (alt-tab) / CheatSheet (cheatsheet) / Clipy (clipy) /
    #   iTerm (iterm2) / Sourcetree (sourcetree) / Wireshark (wireshark-app)
    #   → 必要になれば上の casks に足して make adopt すれば管理下に入る。
    #
    # cask 化できない/すべきでないもの(管理外が正常):
    #   - Mac App Store 製: Amazon Kindle / LINE / Shazam / Mail+ / Magnet /
    #     Xcode / Swift Playground(宣言するなら mas + homebrew.masApps が必要)
    #   - Apple 純正・OS 同梱: Safari / Keynote / Numbers
    #   - メーカー独自更新: Logi Options(plus)
    #   - その他: 1Password 7(旧版。cask は v8)/ Raycast Beta(安定版は raycast)
    #     / FileZilla(公式が cask 提供を停止)
  };
}
