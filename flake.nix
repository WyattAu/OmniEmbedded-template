{
  # OmniEmbedded dev environment — nix owns the cross toolchain + SDK.
  description = "OmniEmbedded-template development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (s: f nixpkgs.legacyPackages.${s});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            gcc-arm-embedded
            cmake
            ninja
            python3
            picotool
            probe-rs-tools
            clang-tools # clang-format + clang-tidy for host files
          ];
          # SDK discovery hint for cmake/pico.cmake when not fetching:
          # PICO_SDK_PATH = "${pkgs.pico-sdk}/lib/pico-sdk";
        };
      });
    };
}
