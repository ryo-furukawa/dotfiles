{
  description = "Go プロジェクトの開発環境";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # メジャー固定したい場合は go_1_23 のように版を付ける。
            go

            # よく使う補助ツールが必要なら追加する。
            # gopls
            # gotools
          ];
        };
      }
    );
}
