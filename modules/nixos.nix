{
  flake.nixosModules.myLib =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      _module.args.myLib = import ../lib {
        inherit config lib pkgs;
      };
    };
}
