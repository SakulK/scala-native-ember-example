{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    sbt.url = "github:zaninime/sbt-derivation/master";
    sbt.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, sbt }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = (import nixpkgs) { inherit system; };
      in {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            stdenv
            pkgs.sbt
            openjdk
            boehmgc
            libunwind
            clang
            zlib
            s2n-tls
            which
          ];
        };
        packages.default = sbt.mkSbtDerivation.x86_64-linux {
          pname = "scala-ember-native-example";
          version = "1.0.0";
          src = ./.;
          depsSha256 = "sha256-NImH/BSwSPXurXbw5QK/38xV9qYvlBceljvHwC53VsY=";
          buildPhase = ''
            sbt nativeLink
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp target/scala-3.2.0/scala-native-ember-example-out $out/bin/scala-ember-native-example
          '';
          nativeBuildInputs = with pkgs; [
            boehmgc
            libunwind
            clang
            zlib
            s2n-tls
            which
          ];
        };
      });
}
