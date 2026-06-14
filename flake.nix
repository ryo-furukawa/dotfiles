{
  description = "ryofurukawa macOS dotfiles";

  # inputs = 外部から取り込む依存。github:owner/repo の形で指定する。
  inputs = {
    # nixpkgs = 全パッケージの巨大カタログ。unstable は最新追従ブランチ。
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nix-darwin = macOS のシステム設定(Dock, Homebrew, ホスト名…)を司る。
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    # ↓ nix-darwin が内部で使う nixpkgs を、上の nixpkgs に統一する(二重DL防止)。
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # home-manager = ユーザーの dotfiles・CLI ツール(zsh, git…)を司る。
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "aarch64-darwin"; # Apple Silicon Mac
      # pkgs = この system 向けの nixpkgs を取り出したもの。
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;
    };
}
