{ lib, config, ... }: let

in {
  options.maximizzar.networking.ipForwarding = {
    enableIPv4 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable IPv4 packet forwarding.";
    };

    enableIPv6 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable IPv6 packet forwarding.";
    };
  };

  config = {
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" =
        lib.boolToInt config.maximizzar.networking.ipForwarding.enableIPv4;

      "net.ipv6.conf.all.forwarding" =
        lib.boolToInt config.maximizzar.networking.ipForwarding.enableIPv6;

      "net.ipv6.conf.default.forwarding" =
        lib.boolToInt config.maximizzar.networking.ipForwarding.enableIPv6;
    };
  };
}
