# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{ self, inventory, ... }: {
  flake.nixosModules.mip3Configuration =
    { pkgs, ... }:
    let
      host = inventory.overlay.sites.genesis.hosts.mip3;
    in
    {
      imports = [
        self.nixosModules.systemdBoot
        ./_hardware-configuration.nix

        self.nixosModules.kdePlasma
        self.nixosModules.cliTooling
        self.nixosModules.gaming
        self.nixosModules.virtualization
        self.nixosModules.psysonic
      ];

      boot.initrd.luks.devices."luks-35770c58-e4d0-40c2-ac88-8586d43fb541".device =
        "/dev/disk/by-uuid/35770c58-e4d0-40c2-ac88-8586d43fb541";

      hardware.graphics.extraPackages = with pkgs; [
        rocmPackages.clr.icd
        libva
      ];

      networking = {
        inherit (host) hostName domain;
        stevenblack.enable = true;
        wireless = {
          enable = true; # Enables wireless support via wpa_supplicant.
          extraConfig = ''
            mac_addr=1
          '';

        };
      };

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.maximizzar = {
        enable = true;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
      };

      # Enable services the host runs
      services.openssh.enable = true;

      # Own custom Modules
      maximizzar = {
        # Enable various cli tools
        cliTooling = {
          enable = true;
          dev = true;
          sys = true;
        };

        # Enable qemu_kmv virtualization with libvirt virt-manager
        virtualization = {
          enable = true;
          libvirt = {
            enable = true;
            useVirtmanager = true;
          };
        };

        knownHosts = {
          gitRemotes.enable = true;
          guests.enable = true;
          machines.enable = true;
        };

      };

      # List packages installed in system profile.
      environment.systemPackages = with pkgs; [
        # bitwarden-desktop # currently insecure Electorn version
        git
        ffmpeg

        home-manager
        keepassxc
        translate-shell

        jellyfin-desktop

        maple-mono.NF-CN
      ];

    };
}
