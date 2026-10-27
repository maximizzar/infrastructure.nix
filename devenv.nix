{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  packages = with pkgs; [
    deploy-rs
    nvfetcher
    goreleaser
    just
    reuse
    sops
    ssh-to-age
  ];

  languages.nix = {
    enable = true;

  };
}
