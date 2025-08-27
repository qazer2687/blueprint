{
  inputs,
  self,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs self;};
  modules = [
    ../../hosts/jet
    ../../modules/jet
    ../../modules/shared
    inputs.sops-nix.nixosModules.sops
    inputs.asahi.nixosModules.apple-silicon-support
  ];
}
