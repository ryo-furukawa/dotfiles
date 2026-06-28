# 使い方: make switch PROFILE=private
# PROFILE を省略した場合は private をデフォルトにする。
PROFILE ?= private

.PHONY: switch build update fmt adopt

# switch = 設定をビルドして実際に適用する。
switch:
	sudo darwin-rebuild switch --flake .#$(PROFILE)

# adopt = 手動インストール済みの .app を brew 管理下へ取り込む(初回移行用)。
# nix の casks 宣言を単一の真実の源として抽出し、全 cask に --adopt を試す。
# 既存 .app があれば消さずに取り込み、無ければ通常インストール扱いになる。
# 既に brew 管理のものは冪等にスキップされるので、何度流しても安全。
# nix-darwin の宣言経由では --adopt を渡せないため、switch とは別ターゲットにする。
#
# make のレシピは /bin/sh(brew の PATH 未設定)で走るため brew はフルパスで呼ぶ。
# Apple Silicon は /opt/homebrew、Intel は /usr/local に brew がある。
#
# --adopt は補助バイナリを持つ cask(docker/obsidian 等)で xattr 書き込みに
# 失敗することがあり、その際 .app を消した後に止まる危険がある。失敗したら
# 通常 install へフォールバックして .app を確実に再配置する(二段構え)。
adopt:
	@brew=$$(command -v brew || echo /opt/homebrew/bin/brew); \
	[ -x "$$brew" ] || brew=/usr/local/bin/brew; \
	[ -x "$$brew" ] || { echo "brew が見つかりません" >&2; exit 1; }; \
	nix eval --json ".#darwinConfigurations.$(PROFILE).config.homebrew.casks" \
		| jq -r '.[].name' \
		| while read -r app; do \
			echo "=== adopt: $$app ==="; \
			"$$brew" install --cask --adopt "$$app" \
				|| { echo "--adopt 失敗。通常 install で再配置: $$app"; \
					"$$brew" install --cask --force "$$app" || true; }; \
		done

# build = 適用せずビルドだけ(動作確認・dry run 用)。
build:
	darwin-rebuild build --flake .#$(PROFILE)

# update = inputs(nixpkgs 等)を最新化して flake.lock を更新。
update:
	nix flake update

# fmt = nix ファイルを整形。
fmt:
	nix fmt
