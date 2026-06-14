{
  description = "ryofurukawa macOS dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    let
      system = "aarch64-darwin"; # Apple Silicon Mac
      username = "ryofurukawa"; # 個人 PC のユーザー名
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      # darwinConfigurations.private = 個人 PC の設定一式。
      # make switch PROFILE=private で、ここが適用される。
      # 将来、会社 PC 用に darwinConfigurations.work を同じ形で追加する。
      darwinConfigurations.private = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs username; };
        modules = [
          ./hosts/private/default.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # HM が管理する dotfiles に既存の実体ファイルがあると衝突して停止する。
            # 衝突したファイルを <name>.backup にリネームしてから上書きさせる。
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs username; };
            home-manager.users.${username} = import ./home;
          }
        ];
      };
    };
}
