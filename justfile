# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

default:
    just --list

# Build a QCow2 Disk-Image
build-disk-image flake:
    nix build .#{{ flake }}

# Push a QCow2 Disk-Image to a remote
push-disk-image host:
    scp result/main.qcow2 {{ host }}

# Deploy a flake target to a remote
deploy flake host:
    nix run nixpkgs#nixos-rebuild -- switch --flake .#{{ flake }} --target-host "{{ host }}" --sudo
