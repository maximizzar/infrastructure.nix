# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/vars/default.nix
{ lib, ... }:
let
  # Liest alle .nix Dateien im Verzeichnis (außer default.nix)
  files = builtins.attrNames (builtins.readDir ./.);
  moduleFiles = builtins.filter
    (f: f != "default.nix" && lib.hasSuffix ".nix" f)
    files;
in
{
  imports = map (f: ./. + "/${f}") moduleFiles;
}
