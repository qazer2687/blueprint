{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.vscode.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.vscode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium-fhs;
      defaultEditor = true;
    };
  };
}
