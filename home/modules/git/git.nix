{ ... }:
{
  programs.git = {
    enable = true;

    # 全リポジトリ共通の無視リスト(旧 ~/.gitignore_global から移植)。
    # Phoenix(Elixir)遺物の mix-manifest.json / app.css / app.js は不要なので落とした。
    ignores = [
      "*~"
      ".DS_Store"
      ".claude/settings.local.json"
    ];

    # .gitconfig の中身は settings に集約する(最近の home-manager の方式)。
    settings = {
      # 両ホスト共通の表示名。
      # email はマシン別に変えたいので Nix には書かず、後述の include 経由で
      # git 管理外ファイル(~/.gitconfig.local)から読む。
      user.name = "ryo-furukawa";

      # 旧 .gitconfig の設定を移植。
      push.default = "current";
      init.defaultBranch = "main";

      # マシン別の値(email)を git 管理外ファイルから読む。
      # git は include 先を後から読んで上書きするため、ここで宣言した name は
      # 共通値として効きつつ、email はローカルファイルの値が最終的に効く。
      include.path = "~/.gitconfig.local";
    };
  };

  # delta: 差分を見やすく色付けするページャ。
  # 最近の home-manager ではトップレベルの programs.delta に独立した。
  # enableGitIntegration で .gitconfig の core.pager 等が自動設定される。
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
