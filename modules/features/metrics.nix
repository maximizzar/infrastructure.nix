{
  flake.nixosModules.metrics =
    { config, lib, ... }:
    let
      cfg = config.maximizzar.metrics;
    in
    {
      options.maximizzar.metrics = {
        enable = lib.mkEnableOption "Metrics Exporting";
        allowedScrapers = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "";
        };

        targets = lib.mkOption {
          default = { };
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                port = lib.mkOption { type = lib.types.port; };
                path = lib.mkOption {
                  type = lib.types.str;
                  default = "/metrics";
                };
                labels = lib.mkOption {
                  type = lib.types.attrsOf lib.types.str;
                  default = { };
                };
              };
            }
          );
        };

      };

      config = lib.mkIf cfg.enable {
        networking.firewall.extraInputRules = lib.concatStrings (
          lib.concatMap (
            t: map (ip: "ip saddr ${ip} tcp dport ${toString t.port} accept\n") cfg.allowedScrapers
          ) (lib.attrValues cfg.targets)
        );
      };
    };
}
