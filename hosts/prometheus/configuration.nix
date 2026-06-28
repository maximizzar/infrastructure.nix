{
  modulesPath,
  lib,
  stateVersion,
  inputs,
  inventory,
  ...
}:
let
  bridge = "br0";
in
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

  # Node Exporter
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "cgroups"
      "systemd"
    ];

    extraFlags = [
      "--collector.netdev.device-exclude=^(veth|docker|podman|lo)"
      "--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|run|var/lib/[docker|podman|containers])($|/)"
    ];

    openFirewall = true;
  };

  system.stateVersion = stateVersion;

  containers.prometheus = {
    autoStart = true;
    restartIfChanged = true;
    privateNetwork = true;
    hostBridge = bridge;
    localMacAddress = "2E:E9:07:11:23:B8";

    specialArgs = { inherit inputs stateVersion; };

    config = { ... }: {
      networking = {
        useDHCP = false;
        useNetworkd = true;
      };

      # Use own resolved in container
      systemd.network.enable = true;
      networking.useHostResolvConf = lib.mkForce false;
      services.resolved.enable = true;

      # Configure main interface
      systemd.network.networks."10-eth0" = {
        matchConfig.Name = "eth0";

        networkConfig = {
          IPv6AcceptRA = true;
          IPv6PrivacyExtensions = false;
          IPv6LinkLocalAddressGenerationMode = "eui64";
        };

        ipv6AcceptRAConfig = {
          UseAutonomousPrefix = true;
          UseDNS = false;
        };

        linkConfig.RequiredForOnline = "routable";
      };

      # Import Modules to define functionality
      imports = [
        ../../modules/security
        ./prometheus.nix
      ];

      system.stateVersion = stateVersion;
    };
  };
}
