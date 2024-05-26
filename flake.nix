{
  description = "RTKLIB command line utilities";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem ( system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "rtklib-cli";
          version = "b43i";
          buildInputs = with pkgs; [
            gcc
            gfortran
            openblas
          ];
          nativeBuildInputs = with pkgs; [
            gcc
            gfortran
            gfortran.cc
            openblas
            gnumake
          ];
          src = pkgs.fetchFromGitHub {
            owner = "rtklibexplorer";
            repo = "RTKLIB";
            rev = "ea6c1596ce1ff2425925fc087d9d1efdca25fe85";
            hash = "sha256-5ipxHqd5ZDU9ksIU8taE04jhatc0hBBg+3jJUPA0bCk=";
          };
          # phases = [ "buildPhase" "installPhase"];
          buildPhase = ''
            cd ./app/consapp/convbin/gcc/
            make -j $NIX_BUILD_CORES

            cd ../../pos2kml/gcc
            make -j $NIX_BUILD_CORES

            cd ../../rnx2rtkp/gcc
            make -j $NIX_BUILD_CORES

            cd ../../rtkrcv/gcc
            make -j $NIX_BUILD_CORES

            cd ../../str2str/gcc
            make -j $NIX_BUILD_CORES

            cd ../../../..
          '';
          installPhase = ''
            echo $out
            pwd
            mkdir -p $out/bin
            cp app/consapp/convbin/gcc/convbin $out/bin/
            cp ./app/consapp/pos2kml/gcc/pos2kml $out/bin
            cp ./app/consapp/rnx2rtkp/gcc/rnx2rtkp $out/bin
            cp ./app/consapp/rtkrcv/gcc/rtkrcv $out/bin
            cp ./app/consapp/str2str/gcc/str2str $out/bin
          '';
          meta = {
            description = "RTKLIB command line utilities";
            homepage = "https://github.com/rtklibexplorer/RTKLIB";
            license = "BSD-2";
          };
        };
      }
    );
}
