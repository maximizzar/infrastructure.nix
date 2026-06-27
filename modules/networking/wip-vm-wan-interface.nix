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

    # --- UPLINK  ---
    systemd.network.networks."30-uplink" = {
      matchConfig.Name = cfg.interface;

      networkConfig = {
        DHCP = "ipv6";
        IPv6AcceptRA = true;

        IPv6PrivacyExtensions = false;
        DHCPPrefixDelegation = false;
        LinkLocalAddressing = "ipv6";
      };

      # request /64 prefix via DHCP-v6-PD
      dhcpV6Config.PrefixDelegationHint = "::/64";
      ipv6AcceptRAConfig = {
        UseAutonomousPrefix = false;
        UseOnLinkPrefix = false;
      };
    };

    systemd.network.netdevs."10-dummy" = {
      netdevConfig = {
        Kind = "dummy";
        Name = "dummy0";
      };
    };

    # Handle all layer-3 traffic on the bridge interface
    systemd.network.networks."40-bridge" = {
      matchConfig.Name = cfg.bridge;

      networkConfig = {
        ConfigureWithoutCarrier = true;

        # Enables the assignment of the delegated prefix on this bridge
        DHCPPrefixDelegation = true;

        # Sends RAs into the bridge network
        IPv6SendRA = true;

        # Forces the host to process its own RAs on the bridge
        # so that it obtains an SLAAC address from the /64 itself.
        IPv6AcceptRA = true;

        IPv6PrivacyExtensions = false;
        IPv6LinkLocalAddressGenerationMode = "eui64";
      };

      ipv6SendRAConfig = {
        Managed = false;
        OtherInformation = false;
        EmitDNS = true;
      };

      ipv6AcceptRAConfig = {
        UseAutonomousPrefix = true;
        UseDNS = true;
      };

      linkConfig.RequiredForOnline = "no";
    };

    systemd.network.networks."10-dummy-link" = {
      matchConfig.Name = "dummy0";
      networkConfig.Bridge = "br0";
    };

    boot.kernel.sysctl = {
      "net.ipv6.conf.${cfg.interface}.autoconf" = 0;
      "net.ipv6.conf.${cfg.interface}.accept_ra" = 1;
      "net.ipv6.conf.${cfg.interface}.accept_ra_pinfo" = 0;

      # Ensure the host bridge interface doesn't ignore network RAs
      "net.ipv6.conf.${cfg.bridge}.accept_ra" = 2;
    };
  };
}
