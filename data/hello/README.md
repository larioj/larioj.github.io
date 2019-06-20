# Hello World in Haskell using Nix

## Files
-   nixpkgs.json
-   default.nix
-   hello.nix
-   hello.cabal
-   Main.hs

## Pinning Nix Channel
    $ nix-shell --packages nix-prefetch-git --run \
        'nix-prefetch-git https://github.com/NixOS/nixpkgs.git \
          83ba5afcc9682b52b39a9a958f730b966cc369c5 > nixpkgs.json'

## Cabal2nix
  $ nix-shell --packages haskellPackages.cabal2nix --run \
      'cabal2nix .'

## Build
    $ nix-build
