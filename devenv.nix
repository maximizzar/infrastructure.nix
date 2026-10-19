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
    reuse
    sops
  ];

  languages.nix = {
    enable = true;

  };
}
