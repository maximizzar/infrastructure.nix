# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  pkgs,
  ...
}:
{
  maximizzar.modules.hardware.bootSystemd.enable = true;
  networking.hostName = "hrattic";

  # Enalbe the Plasma-Desktop Profile
  maximizzar.modules.profiles.plasmaDesktop.enable = true;

  # Define User accounts
  users.users = {
    maximizzar = {
      enable = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };

    peter = {
      enable = true;
      extraGroups = [ "networkmanager" ];
    };

    kurt.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    git
    kdePackages.kmahjongg
  ];

  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];
  };

}
