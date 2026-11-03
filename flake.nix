{
  description = "Shared CLI tools for macOS and Ubuntu on WSL2";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [ "claude-code" ];
      };
    in {
      packages = forAllSystems (system:
        let pkgs = pkgsFor system;
        in {
          default = pkgs.buildEnv {
            name = "dotfiles-cli";
            paths = import ./nix/packages.nix { inherit pkgs; };
            pathsToLink = [ "/bin" "/share" "/etc/profile.d" ];
          };
        });
      devShells = forAllSystems (system:
        let pkgs = pkgsFor system;
        in {
          default = pkgs.mkShell {
            packages = import ./nix/packages.nix { inherit pkgs; };
          };
        });
      formatter = forAllSystems (system: (pkgsFor system).nixfmt);
    };
}
