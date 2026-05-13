#!/usr/bin/env just --justfile

# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

ATTIC_CACHE := "prod"
FLAKE_DIR := "."

# A list of all available operations
default:
  just --list

# Run attic cmd
attic *args:
    nix run nixpkgs#attic-client -- {{ args }}

# Update the complete flake
update-flake:
	nix flake update

# Build generic VM disk (QCOW2)
build-vm-disk:
    nix build .#vm-template

# Update vma.zst to a remote
upload-vm user sshkey host:
    curl --insecure -u {{ user }}: --key ~/.ssh/{{ sshkey }} --pubkey ~/.ssh/{{ sshkey }}.pub -T result/*.vma.zst sftp://{{ host }}/var/lib/vz/dump/

# Deploy a choosen configuration to a Remote Target
deploy target:
    nix run nixpkgs#nixos-rebuild -- switch --flake .#$(nix flake show --json | jq -r '.nixosConfigurations | keys[]' | fzf) --target-host {{ target }} --sudo --ask-sudo-password

deploy-nameserver:
    #!/usr/bin/env bash

    nix_switch() {
      local flake="$1"
      local target="$2"

      nix run nixpkgs#nixos-rebuild -- switch --flake .#$flake --target-host $target --sudo --ask-sudo-password
    }

    forwarder() {
      nix_switch core-ns-fw-primary fd80:3aa8:691a:20:be24:11ff:fec9:4372
      nix_switch core-ns-fw-secondary fd80:3aa8:691a:20:be24:11ff:fe3b:7814
    }

    authoritive() {
      nix_switch core-ns-authoritive-primary fd80:3aa8:691a:20:be24:11ff:fee8:c513
      nix_switch core-ns-authoritive-secondary fd80:3aa8:691a:20:be24:11ff:fed9:139f
    }


    main() {
      #authoritive
      forwarder
    }

    main


_list-configs:
    @echo "❌ Deployment failed! Available NixOS configurations in this Flake:"
    @nix flake show --json 2>/dev/null | jq -r '.nixosConfigurations | keys[]' | sed 's/^/  - /' || echo "No NixOS configurations found."





