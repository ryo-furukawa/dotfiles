{
  description = "Python プロジェクトの開発環境";

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
            # メジャー固定したい場合は python312 のように版を付ける。
            python3

            # 依存管理に uv を使う場合は有効化(venv を uv 側で切る運用)。
            # uv
          ];

          # venv ベースで運用するなら、shellHook で自動有効化すると楽。
          # shellHook = ''
          #   test -d .venv || python -m venv .venv
          #   source .venv/bin/activate
          # '';
        };
      }
    );
}
