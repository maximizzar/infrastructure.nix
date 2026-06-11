{ lib, ... }: {
  ipam = import ./ipam.nix { inherit lib; };
}
