# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

default:
    just --list

# Build a QCow2 Disk-Image
build-disk-image flake:
    nix build .#{{ flake }}

# Push a QCow2 Disk-Image to a remote
push-disk-image host remote_path:
    scp result/main.qcow2 {{ host }}:{{ remote_path }}

# Deploy a flake target to a remote
deploy flake host:
    nix run nixpkgs#nixos-rebuild -- switch --flake .#{{ flake }} --target-host "{{ host }}" --sudo

deploy-build-remote flake host:
    nix run nixpkgs#nixos-rebuild switch -- --flake .#{{ flake }} --target-host "{{ host }}" --build-host "{{ host }}" --sudo

# Deploy a flake to local system
deploy-local flake:
    sudo nixos-rebuild switch --flake .#{{ flake }}

# Edit Secrets from a specified host
edit-secrets host:
    nix run nixpkgs#sops -- edit hosts/{{ host }}/secrets.yaml

# Get a Hosts age key using ssh-to-age
get-agekey host:
    nix-shell -p ssh-to-age --run 'ssh-keyscan {{ host }} | ssh-to-age'

# Updates nvfetcheres _sources and generates a git commit with changes
nvfetcher:
    @echo "saving current workspace state..."
    git stash push -m "temp-stash-for-nvfetcher"

    @echo "Updating nvfetcher sources"
    nix run nixpkgs#nvfetcher

    @echo "Committing sources"
    git add _sources
    git commit -m "chore(nvfetcher): update sources"

    @echo "Restoring workspace..."
    git stash pop

# Updates Lockfile and generates git commit with changes
update:
    @echo "Saving current workspace state..."
    git stash push -m "temp-stash-for-update"

    @echo "Updating flake.lock..."
    nix flake update

    @echo "Committing lockfile..."
    git add flake.lock
    git commit -m "chore: update flake.lock"

    @echo "Restoring workspace..."
    git stash pop
