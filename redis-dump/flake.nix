{
  description = "A shell with dependencies for redis-dump";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      perSystem =
        { pkgs, lib, ... }:
        let
          gems = pkgs.bundlerEnv {
            name = "gems-for-redis-dump";
            gemfile = ./Gemfile;
            lockfile = ./Gemfile.lock;
            gemset = ./gemset.nix;
            exes = [
              "redis-dump"
              "redis-load"
            ];

          };
        in
        {
          devShells.default = pkgs.mkShell {
            name = "koreader devenv";
            packages = [
              gems
              gems.wrappedRuby
            ];
            shellHook = ''
              echo "welcome to a koreader devshell"
            '';
          };
        };
    };
}
