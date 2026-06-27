{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Hardware configuration
  maximizzar.modules.hardware.bootSystemd.enable = lib.mkDefault true;
  maximizzar.modules.hardware.configuration.qemu.enable = lib.mkDefault true;
  maximizzar.modules.hardware.rootDisk.enable = lib.mkDefault true;

  # Core Services
  services.openssh.enable = lib.mkDefault true;
  services.qemuGuest.enable = lib.mkDefault true;

  # Networking
  networking.hostName = "prometheus";
  maximizzar.networking.ipForwarding.enable = true;
  maximizzar.networking.vmWanInterface.enable = true;

  # User Settings
  security.sudo.wheelNeedsPassword = lib.mkDefault false;
  maximizzar.modules.users.maximizzar.enable = lib.mkDefault true;

  system.stateVersion = "26.05";
}
