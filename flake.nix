{
  description = "Nix Flake for mixedCCA R package";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        mixedCCAPkg = pkgs.rPackages.buildRPackage {
          name = "mixedCCA";
          src = self;
          nativeBuildInputs = with pkgs.rPackages; [
            MASS
            Matrix
            Rcpp
            RcppArmadillo
            fMultivar
            irlba
            latentcor
            mnormt
            pcaPP
            pulsar
          ];
        };
      in
      {
        packages.default = mixedCCAPkg;
        devShells.default = pkgs.mkShell {
          buildInputs = [ mixedCCAPkg ];
          inputsFrom = pkgs.lib.singleton mixedCCAPkg;
        };
      }
    );
}
