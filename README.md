<!--
SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>

SPDX-License-Identifier: GPL-3.0-or-later
-->

# Nix-OS Configuration for my Homelab Infrastructure

This repository contains the NixOS configurations for my homelab.
It uses Nix Flakes for reproducibility and a just-file to simplify common maintenance tasks.


## 📂 Repository Structure

The configuration is organized into logical components to keep logic separated from host-specific data:

- `hosts/`: Entry points for specific machines (e.g., `server`, `workstation`). 
    Contains `configuration.nix` and hardware definitions.
- `modules/`: The "building blocks" of the infrastructure.
  - `profiles/`: High-level collections of settings (e.g., `base`, `graphical`, `server-hardened`).
  - `services/`: Specific service configurations (e.g., `docker`, `nginx`, `dnsdist`).
  - `users/`: User account definitions and Home Manager repo integrations.
- `lib/`: Custom helper functions used throughout the Flake to reduce boilerplate.
- `flake.nix`: Defines inputs (nixpkgs, overlays) and outputs (nixosConfigurations).


## Management Commands

I use `just` as a task runner to wrap complex Nix commands.


## Flake Inputs

This configuration relies on the following upstream sources:
- `nixpkgs`: Main NixOS package repository (currently using: `nixos-25.11`).
- ...


## Deployment

To Deploy centrally remote Systems use the just-file.
To bootstrap a new machine from this flake:

1. Clone the repo: `git clone <repo-url> /etc/nixos`
2. Generate hardware config: (If not already in `hosts/`) `nixos-generate-config --show-hardware-config`
3. Apply:
```shell
# Replace <hostname> with the target folder name in /hosts
sudo nixos-rebuild switch --flake .#<hostname>
```


## 📜 License

**This configuration is intended for personal use.**
Feel free to use under GPL-3.0-or-later.

