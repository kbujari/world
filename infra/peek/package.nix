{ lib, ocamlPackages, withTools, ... }:

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

  nativeBuildInputs = lib.optionals withTools [
    ocamlPackages.ocamlformat
    ocamlPackages.ocaml-lsp
    ocamlPackages.merlin
  ];
}
