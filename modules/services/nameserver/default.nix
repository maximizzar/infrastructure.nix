# modules/services/nameserver/default.nix
{ ... }: let

in {
    flake.nixosModules.services-nameserver-authoritive = ./authoritive.nix;
    flake.nixosModules.services-nameserver-forwarder = ./forwarder.nix;
}
