{ config, lib, ... }:
let
  cfg = config.maximizzar.modules.application.steam;
in
{
  options.maximizzar.modules.application.steam.enable = lib.mkEnableOption "steam";
  config.programs.steam = {
    enable = cfg.enable;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
