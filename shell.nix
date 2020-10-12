{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, containers, directory, errors, filepath
      , generic-deriving, lens, mtl, stdenv, text, transformers, wl-pprint-text
      , hspec, hspec-expectations-pretty-diff
      }:
      mkDerivation {
        pname = "purescript-bridge";
        version = "0.13.1.0";
        src = ./.;
        libraryHaskellDepends = [
          base containers directory errors filepath generic-deriving lens mtl
          text transformers wl-pprint-text hspec hspec-expectations-pretty-diff
        ];
        description = "Generate PureScript data types from Haskell data types";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
