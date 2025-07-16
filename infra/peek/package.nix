{ lib, ocamlPackages, ... }:

ocamlPackages.buildDunePackage {
  pname = "peek";
  version = "trunk";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./dune-project
      ./bin
      ./lib
      ./test
    ];
  };
}
