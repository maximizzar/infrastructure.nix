{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.lazygit =
    {
      pkgs,
      lib,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        self.packages.${pkgs.stdenv.hostPlatform.system}.lazygit
      ];
    };
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    let
      config-file = pkgs.writeText "config.yml" ''
        gui:
          nerdFontsVersion: "3"
      '';
    in
    {
      packages.lazygit = inputs.wrappers.lib.wrapPackage ({
        inherit pkgs;
        package = pkgs.lazygit;
        flags = {
          "--use-config-file" = config-file;
        };
      });
    };
}
