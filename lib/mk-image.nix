# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# lib/mk-image.nix
{ nixpkgs, system, ... }:

let
  lib = nixpkgs.lib;
in
{
  mkImage = modules: lib.nixosSystem {
    inherit system;
    modules = [
      ../modules/services/common/sshd.nix
      ../modules/services/common/pki.nix
      ../modules/users/default.nix
      { system.stateVersion = "25.11"; }
    ] ++ modules;
  };
}