{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # This rev of sops-nix is needed for golang compatibility with nixpkgs
    sops-nix.url = "github:Mic92/sops-nix?rev=17eea6f3816ba6568b8c81db8a4e6ca438b30b7c";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    immich-dlna.url = "github:arrocke/immich-dlna/v0.1.0";
  };

  outputs = { self, nixpkgs, sops-nix, home-manager, immich-dlna }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops
        immich-dlna.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.adrian = ./home.nix;
        }
      ];
    };
  };
}
