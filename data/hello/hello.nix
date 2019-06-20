{ haskellPackages
, stdenv
, cabal2nix
, runCommand
}:

let
  name = "hello";
  src = ./.;
  cabalAsNix = runCommand "${name}-cabal.nix" { } ''
    cp --recursive --no-preserve=mode ${src} src
    (cd src && ${cabal2nix}/bin/cabal2nix . > ${name}-cabal.nix)
    mv src/${name}-cabal.nix $out
  '';
in
  haskellPackages.callPackage cabalAsNix { }
