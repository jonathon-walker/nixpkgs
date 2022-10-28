.PHONY: fmt switch

fmt:
	nixfmt **/*.nix

switch:
	./result/sw/bin/darwin-rebuild switch --verbose --flake .

node2nix:
	cd ./pkgs/node-packages; nix run my#nodePackages.node2nix -- -18