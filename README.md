<!--
SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>

SPDX-License-Identifier: GPL-3.0-or-later
-->

# Infrastructure.nix: Homelab but complicated

Documentation for my Homelab!

## Hosts

- auth: Contains authelia for sso
- forgejo: Hosts a forgejo server for everything sourcecode
- gw-genesis: connects my homeserver to the cloud(tm)
- gw-nbg: the cloud(tm) with site-to-site VPN
- hrattic: a client-pc
- mip3: a client-pc
- prometheus: wip monitoring
- resolver: dns resolution for my home
- runner: WIP forgejo-runner
- vaultwarden: WIP password manager Host

## Get started

I use devenv to make dependencies available. If you have the nix package-manager
on your system use `nix-shell -p devenv --run "devenv shell"`. Else make sure it
is installed and run `devenv shell` in your shell directly.

If you don't want to use devenv, look into the `devenv.nix` and install the
tools needed on your own.
