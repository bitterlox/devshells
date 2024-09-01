{
  description = "A development environment for koreader";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      perSystem = { pkgs, lib, ... }: {
        devShells.default = pkgs.mkShell {
          name = "koreader devenv";
          packages = with pkgs; [
            autoconf
            ccache
            cmake
            gettext
            libgcc # or libgcc
            gnumake
            meson
            ninja
            gnupatch
            perl
            pkg-config
            unzip
            wget
            getopt # macOS getopt is borked
            flock # idk but it's needed
            automake # wasn't listed
            libtool # wasn't listed
            python3 # wasn't listed
          ];
          # this is what fixed luajit (i think?) complaining about missing
          # dynamic library for SDL2
          # todo: figure out why setting it manually inside the shellHook
          # didn't work
          LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.SDL2 ];
          shellHook = ''
            echo "welcome to a koreader devshell"
          '';
        };
      };
    };
}
