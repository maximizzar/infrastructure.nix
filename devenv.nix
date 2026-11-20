{ pkgs, ... }: {
  packages = with pkgs; [
    nixos-rebuild
    deploy-rs
    nvfetcher
    just

    authelia
    sops
    ssh-to-age

    reuse
    goreleaser

    jq
  ];
}
