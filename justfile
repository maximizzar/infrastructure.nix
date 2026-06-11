default:
    just --list

deploy flake host:
    nix run nixpkgs#nixos-rebuild -- switch --flake .#{{ flake }} --target-host {{ host }} --sudo
