# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ pkgs, ... }: {
  maximizzar.modules.hardware.bootSystemd.enable = true;
  boot.initrd.luks.devices."luks-35770c58-e4d0-40c2-ac88-8586d43fb541".device =
    "/dev/disk/by-uuid/35770c58-e4d0-40c2-ac88-8586d43fb541";

  networking = {
    hostName = "mip3"; # Define your hostname.
    wireless.enable = true; # Enables wireless support via wpa_supplicant.
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enalbe the Plasma-Desktop Profile
  maximizzar.modules.profiles.plasmaDesktop.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maximizzar = {
    enable = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
  ];

  maximizzar.modules.security.knownHosts = {
    gitRemotes.enable = true;
    guests.enable = true;
    machines.enable = true;
  };
}
