{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  functions = pkgs.writeTextFile {
    name = "functions.fish";
    text = ''
      function fish_prompt
        set -l nix_shell_info (
          if test -n "$IN_NIX_SHELL"
            echo -n -s (set_color yellow) "<nix-shell> " (set_color normal)
          end
        )

        # Get user and hostname with default colors
        set -l current_user (whoami)
        set -l host_name (hostname -s)

        # Default fish prompt styling
        echo -n -s "$nix_shell_info" \
          (set_color green) "$current_user" \
          (set_color normal) "@" \
          (set_color blue) "$host_name" \
          (set_color normal) " " \
          (set_color cyan) (prompt_pwd) \
          (set_color normal) "> "
      end

      function nix-shell
        command nix-shell --run fish $argv
      end
    '';
  };
in {
  options.modules.fish.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.fish.enable {

    users.users.alex = {
      shell = pkgs.fish;
    };
  
    programs.fish = {
      enable = true;
      
      interactiveShellInit = ''
        # Disable the greeting
        set fish_greeting

        # Source the functions from the generated file
        source "${functions}"
      '';

      shellAliases = {
        "check" = ''nix-shell -p alejandra -p deadnix -p statix --command "alejandra -q . && deadnix -e && statix fix"'';
        "rebuild" = "nh os switch github:qazer2687/dotfiles -H $(hostname) -- --refresh --option eval-cache false";
        "reboot" = ''printf "Are you sure you want to reboot? [N/y]\n"; read -n 1 confirm; test "$confirm" = y && sudo reboot'';
      };
    };
  };
}
