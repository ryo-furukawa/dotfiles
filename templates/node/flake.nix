{
  description = "Node.js プロジェクトの開発環境";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    # eachDefaultSystem で aarch64-darwin / x86_64-linux 等を自動展開し、
    # どのマシンでも同じ flake が動くようにする(system はハードコードしない)。
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # `.envrc` の `use flake` がこの devShell を読み込む。
        # ここに列挙したものだけが、cd でこのディレクトリに入ったとき PATH に乗る。
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # メジャー固定したい場合は nodejs_22 のように版を付ける。
            nodejs

            # corepack を使うなら下を有効化(pnpm/yarn をプロジェクトの packageManager から解決)。
            # corepack
          ];
        };
      }
    );
}
