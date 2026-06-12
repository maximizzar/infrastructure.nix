{
  modulesPath,
  lib,
  pkgs,
  ...
}@args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Bootloader settings for systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;
  services.qemuGuest.enable = true;

  security.sudo.wheelNeedsPassword = false;

  # enable maximizzar user
  maximizzar.modules.users.maximizzar.enable = true;

  system.stateVersion = "26.05";
}
