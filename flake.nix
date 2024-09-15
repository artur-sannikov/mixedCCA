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
        mixedCCA = pkgs.rPackages.buildRPackage {
          name = "mixedCCA";
          src = self;
          propagatedBuildInputs = with pkgs.rPackages; [
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
        packages.default = mixedCCA;
        devShells.default = pkgs.mkShell {
          buildInputs = [ mixedCCA ];
        };
      }
    );
}
