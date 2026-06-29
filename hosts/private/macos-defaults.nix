{ ... }:
{
  # macOS のシステム設定を宣言的に管理する(手動の defaults write の代替)。
  # 値は実機の現状を棚卸しして抽出したもの。switch で実機へ適用される。
  system.defaults = {
    NSGlobalDomain = {
      # キーリピート速度を最速級に(数値が小さいほど速い)。
      KeyRepeat = 2;
      # リピート開始までの待ち時間(小さいほど早く始まる)。
      InitialKeyRepeat = 25;
      # ナチュラルスクロールを無効化(従来方向のスクロール)。
      "com.apple.swipescrolldirection" = false;
      # 全ファイルの拡張子を常に表示(拡張子偽装の見抜き・種別の明確化)。
      AppleShowAllExtensions = true;
    };

    dock = {
      # Dock を画面右に配置。
      orientation = "right";
      # 自動非表示はしない(常に表示)。
      autohide = false;
      # Mission Control でアプリごとにウィンドウをグループ化。
      expose-group-apps = true;
      # ホットコーナー: 右下にカーソルでクイックメモ(14)。
      # 他3隅は無効のままにしたいが、このオプションは正の整数のみ受け付け 0 を
      # 渡せない(0=無効)。未指定にして nix-darwin に触らせず現状(無効)を保つ。
      wvous-br-corner = 14;
    };

    finder = {
      # パスバー・ステータスバーを表示。
      ShowPathbar = true;
      ShowStatusBar = true;
      # NewWindowTarget は実機が生コード "PfAF"(Recents/AirDrop 系)で、
      # nix-darwin の enum("Home"/"Recents" 等)に綺麗に対応しないため宣言しない。
      # デスクトップに表示するドライブ類。
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
      ShowRemovableMediaOnDesktop = true;
      # デフォルトの表示形式をアイコン表示にする(icnv)。
      FXPreferredViewStyle = "icnv";
    };

    trackpad = {
      # タップでクリックは無効(物理的に押し込んだ時だけクリック)。
      Clicking = false;
    };
  };
}
