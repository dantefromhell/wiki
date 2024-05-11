{
  description = "The Wiki repo + devshell";

  inputs.nixpkgs.url = "github:auxolotl/nixpkgs/nixos-unstable";

  inputs.treefmt-nix.url = "github:numtide/treefmt-nix";

  outputs =
    { nixpkgs, treefmt-nix, ... }:
    let
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      forAllSystems =
        function: nixpkgs.lib.genAttrs systems (system: function nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = forAllSystems (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.callPackage ./shell.nix { };
      });

      # treefmt for `nix fmt`
      formatter = forAllSystems (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      # treefmt for `nix flake check`
      checks = treefmtEval.${pkgs.system}.config.build.check self;
    };
}
