{
  localSystem ? builtins.currentSystem,
  crossSystem ? localSystem,
  withTools ? false, # Enable dev tooling when buildilng derivation
  ...
}:

let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/7c4f34d1d13a4776aa1c96183ddfd6da2fdd601d.tar.gz";
    sha256 = "0ys4mvl9f7slaix1av676ya1j2kscyc6b79fwl3mdgvrzahbkkr0";
  };

  pkgs = import nixpkgs {
    inherit localSystem crossSystem;
    config = { };
  };

  inherit (pkgs) lib;
  fs = lib.fileset;
  inherit (lib)
    callPackageWith
    filesystem
    ;

  callPackage = callPackageWith (pkgs // { inherit world withTools; });

  sourceFiles = fs.difference ./. (
    fs.unions [
      (fs.maybeMissing ./result)
      ./default.nix
    ]
  );

  world = filesystem.packagesFromDirectoryRecursive {
    inherit callPackage;
    directory = fs.toSource {
      root = ./.;
      fileset = sourceFiles;
    };
  };
in
world
