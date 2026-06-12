default:
    just --list

# Build a QCow2 Disk-Image
build-disk-image flake:
    nix build .#{{ flake }}

# Push a QCow2 Disk-Image to a remote
push-disk-image host:
    scp result/main.qcow2 {{ host }}

deploy flake host:
    nix run nixpkgs#nixos-rebuild -- switch --flake .#{{ flake }} --target-host {{ host }} --sudo
