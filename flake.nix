{
  description = "Hydra Ledger";

  nixConfig = {
    extra-substituters = "https://horizon.cachix.org";
    extra-trusted-public-keys = "horizon.cachix.org-1:MeEEDRhRZTgv/FFGCv3479/dmJDfJ82G6kfUDxMSAw0=";
  };

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    horizon-cardano.url = "git+https://gitlab.horizon-haskell.net/package-sets/horizon-cardano";
    horizon-devtools.url = "git+https://gitlab.horizon-haskell.net/package-sets/horizon-devtools?ref=lts/ghc-9.6.x";
    nixpkgs.url = "github:nixos/nixpkgs/haskell-updates";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      perSystem = { pkgs, system, ... }:
        let

          myOverlay = final: prev: { horizon-template = final.callCabal2nix "hydra-ledger-triton" ./hydra-ledger-triton { }; };

          legacyPackages = inputs.horizon-cardano.legacyPackages.${system}.extend myOverlay;

        in
        {

          devShells.default = legacyPackages.horizon-template.env.overrideAttrs (attrs: {
            buildInputs = attrs.buildInputs ++ [
              legacyPackages.cabal-install
              inputs.horizon-devtools.legacyPackages.${system}.haskell-language-server
            ];
          });

          packages.default = legacyPackages.horizon-template;

        };
    };
}
