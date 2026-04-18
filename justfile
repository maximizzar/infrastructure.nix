#!/usr/bin/env just --justfile

# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# A list of all available operations
default:
  just --list

# Update the complete flake
update-flake:
	nix flake update

# Build generic VM disk (QCOW2)
build-vm-disk:
    nix build .#vm-template

# Update vma.zst to a remote
upload-vm user sshkey host:
    curl --insecure -u {{ user }}: --key ~/.ssh/{{ sshkey }} --pubkey ~/.ssh/{{ sshkey }}.pub -T result/*.vma.zst sftp://{{ host }}/var/lib/vz/dump/

# Deploy a Forwarding nameserver with Filtering
deploy-nameserver target:
	nix run nixpkgs#nixos-rebuild -- switch --flake .#ns --target-host {{ target }}
