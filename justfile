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
    #!/usr/bin/env bash
    source "$HOME/.config/user-dirs.dirs"
    source "$XDG_PROJECTS_DIR/scripts/lib/print-functions.sh"
    source "$XDG_PROJECTS_DIR/scripts/lib/read-os-release.sh"

    declare -A arr
    read_os_release arr

    if [[ "${arr[ID]}" == "NixOS" ]]; then
        nixos-rebuild switch --flake .#{{ flake }} --target-host "{{ host }}" --sudo
    else
        nix run nixpkgs#nixos-rebuild -- switch --flake .#{{ flake }} --target-host "{{ host }}" --sudo
    fi

# Deploy a flake to local system
deploy-local flake:
    sudo nixos-rebuild switch --flake .#{{ flake }}

# Run nvfetcher
nvfetcher:
    nix run nixpkgs#nvfetcher

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
