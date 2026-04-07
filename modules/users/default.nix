# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# modules/users/default.nix
{ pkgs, ... }: {
  imports = [
    ./maximizzar.nix
  ];

  # Global sudo configuration for all "wheel" users
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  # Ensure SSH is enabled so these users can actually log in
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false; # Security best practice
    settings.KbdInteractiveAuthentication = false;
  };
}
