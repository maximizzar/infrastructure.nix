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

# Build generic VM image (QCOW2)
build-vm:
    nix build .#vm-template

# Build Proxmox LXC template
build-lxc:
    nix build .#lxc-template

# Deploy a Forwarding BIND9 NS with Filtering
deploy-nameserver target:
	nix run nixpkgs#nixos-rebuild -- switch --flake .#nameserver --target-host {{ target }}
