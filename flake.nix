{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # This rev of sops-nix is needed for golang compatibility with nixpkgs
    sops-nix.url = "github:Mic92/sops-nix?rev=17eea6f3816ba6568b8c81db8a4e6ca438b30b7c";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, sops-nix }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops
      ];
    };
  };
}
