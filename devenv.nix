{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  packages = with pkgs; [
    just
    deploy-rs
    nvfetcher
    sops
  ];

  languages.nix = {
    enable = true;

  };
}
