{
  pkgs,
  ...
}:

{
  packages = with pkgs; [
    nixos-rebuild
    deploy-rs
    nvfetcher
    just
    sops
    ssh-to-age
    #(nixpkgs bug) reuse
    goreleaser
  ];
}
