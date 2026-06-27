{
  config,
  lib,
  ...
}:
let
  cfg = config.maximizzar.networking.vmWanInterface;
in
{
  options.maximizzar.networking.vmWanInterface = {
    enable = lib.mkEnableOption "Enable Wan Interface Configuration!";

    interface = lib.mkOption {
      type = lib.types.str;
      default = "ens18";
      description = "Wan Interface name";
    };

    bridge = lib.mkOption {
      type = lib.types.str;
      default = "br0";
      description = "Bridge Interface name";
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      useNetworkd = true;
      useDHCP = false;
    };

    # Define Bridge Interface
    systemd.network.netdevs."20-${cfg.bridge}" = {
      netdevConfig = {
        Name = "${cfg.bridge}";
        Kind = "bridge";
      };
    };

    # Enslave the physical interface to the bridge
    systemd.network.networks."30-${cfg.interface}" = {
      matchConfig.Name = cfg.interface;
      networkConfig.Bridge = cfg.bridge;
      linkConfig.RequiredForOnline = "enslaved";
    };

    # Handle all layer-3 traffic on the bridge interface
    systemd.network.networks."40-${cfg.bridge}" = {
      matchConfig.Name = cfg.bridge;

      networkConfig = {
        IPv6AcceptRA = "yes";
        IPv6PrivacyExtensions = false;
        IPv6LinkLocalAddressGenerationMode = "eui64";
        DHCP = "ipv4";
      };

      dhcpV4Config.ClientIdentifier = "mac";
      ipv6AcceptRAConfig = {
        UseAutonomousPrefix = true;
        UseDNS = true;
      };

      linkConfig.RequiredForOnline = "routable";
    };

    boot.kernel.sysctl = {
      # Ensure the host bridge interface doesn't ignore network RAs
      "net.ipv6.conf.${cfg.bridge}.accept_ra" = 2;
    };
  };
}
