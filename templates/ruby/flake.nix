{
  description = "Ruby プロジェクトの開発環境";

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
            # メジャー固定。別系統が要るなら ruby_3_4 等に変える。
            ruby_3_3
            bundler
          ];

          # gem をプロジェクト内(vendor/bundle)に閉じ込める。
          # グローバルな gem ディレクトリを汚さず、direnv 退出で環境が元に戻る。
          shellHook = ''
            export BUNDLE_PATH="$PWD/vendor/bundle"
            export GEM_HOME="$BUNDLE_PATH"
            export PATH="$BUNDLE_PATH/bin:$PATH"
          '';
        };
      }
    );
}
