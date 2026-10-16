{
  description = "mk's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
#      url = "github:nix-community/home-manager/release-26.05";
      # makes home manager use the prexisting ones instead of double downloading
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };



  };

  # outputs = a function that receives your inputs and produces your system
  # { self, nixpkgs, home-manager, ... } unpacks specific inputs by name
  # ... means ignore any other inputs
  # @inputs means also give me ALL inputs as one variable called inputs
  outputs = { self, nixpkgs, home-manager, lanzaboote, ... }@inputs:

  let
    system = "x86_64-linux";
  in
  {
    # nixosConfigurations is a special output nix understands
    # nixos is the name of your system, referenced as #nixos in rebuild command
    nixosConfigurations.nixos =
      # this function builds a full NixOS system from your modules
      nixpkgs.lib.nixosSystem {

        inherit system;

        # specialArgs passes extra variables into your modules
        # configuration.nix gains acesss to extra modules besides config, pkgs, lib    example: inputs and self 
        specialArgs = {
          inherit inputs self;
        };

        modules = [
          ./configuration.nix
          lanzaboote.nixosModules.lanzaboote

          # accessed as home-manager input → nixosModules attribute → home-manager module (his is what makes home-manager work inside NixOS)
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              # use the same pkgs as the system instead of a separate instance and install user packages into the user profile instead of system
              useGlobalPkgs = true;
              useUserPackages = true;

              # pass inputs into home.nix so it can access flake inputs if needed
              extraSpecialArgs = {
                inherit inputs;
              };
              users.mk = import ./home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
  };
}
