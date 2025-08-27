{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    asahi.url = "github:nix-community/nixos-apple-silicon";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {self, ...} @ inputs: {
    #overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      jet = (import ./flake/jet) {inherit inputs self;};
    };
  };
}
