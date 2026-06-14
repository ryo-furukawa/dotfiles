{ ... }:
{
  # GitHub CLI(gh)。brew 版から Nix 管理に寄せる。
  programs.gh = {
    enable = true;

    settings = {
      # エディタや prompt はデフォルトに任せる。必要になったらここに足す。
      # git の push/clone 認証を gh に肩代わりさせる(https 経由が楽になる)。
      git_protocol = "https";
    };
  };
}
