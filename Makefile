# 使い方: make switch PROFILE=private
# PROFILE を省略した場合は private をデフォルトにする。
PROFILE ?= private

.PHONY: switch build update fmt

# switch = 設定をビルドして実際に適用する。
switch:
	sudo darwin-rebuild switch --flake .#$(PROFILE)

# build = 適用せずビルドだけ(動作確認・dry run 用)。
build:
	darwin-rebuild build --flake .#$(PROFILE)

# update = inputs(nixpkgs 等)を最新化して flake.lock を更新。
update:
	nix flake update

# fmt = nix ファイルを整形。
fmt:
	nix fmt
