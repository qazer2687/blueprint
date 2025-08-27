{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  options.modules.hyprland.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      withUWSM = true;
    };

    programs.dconf.enable = true;
    security.polkit.enable = true;

    systemd.tmpfiles.rules = [
    "f %h/.config/hypr/hyprland.conf - - - -
      # Monitor
      monitor=eDP-1,highrr,auto,2

      # General
      general {
        layout = master
        gaps_in = 2
        gaps_out = 4
        border_size = 2
        col.active_border = rgba(cba6f7ff)
        col.inactive_border = rgba(6f5b87ff)
        resize_on_border = false
        allow_tearing = true
      }

      # Master Layout
      master {
        mfact = 0.75
        orientation = left
        inherit_fullscreen = true
      }

      # Gestures
      gestures {
        workspace_swipe = false
      }

      # Decoration
      decoration {
        rounding = 4
        active_opacity = 1
        inactive_opacity = 1
        blur {
          enabled = false
        }
        shadow {
          enabled = false
        }
      }

      # Animations
      animations {
        enabled = false
        bezier = easeOutCirc, 0, 0.55, 0.45, 1
        animation = windowsIn, 0, 0.25, easeOutCirc
        animation = windowsMove, 0, 0.25, easeOutCirc
        animation = windowsOut, 0, 0.25, easeOutCirc
        animation = fadeIn, 0, 0.25, easeOutCirc
        animation = workspaces, 0, 2, easeOutCirc, slide
      }

      # Input
      input {
        follow_mouse = 0
        mouse_refocus = false
        kb_layout = gb
        kb_variant = colemak
        kb_options = ctrl:nocaps
        touchpad {
          tap-to-click = false
          scroll_factor = 0.5
          natural_scroll = true
          clickfinger_behavior = true
          middle_button_emulation = true
          disable_while_typing = true
        }
      }

      # Cursor
      cursor {
        no_warps = true
      }

      # Render
      render {
        direct_scanout = 1
      }

      # Misc
      misc {
        disable_splash_rendering = true
        disable_hyprland_logo = true
        vfr = true
        vrr = 0
      }

      # Rules
      workspace = w[tv1], gapsout:4, gapsin:0
      workspace = f[1], gapsout:4, gapsin:0

      windowrulev2 = immediate, fullscreen:1
      windowrulev2 = rounding 0, class:^(.waybar-wrapped)$
      layerrule = noanim,(?i).*tofi.*

      # Binds
      bind = SUPER, Return, exec, ${pkgs.foot}/bin/foot
      bind = SUPER, E, exec, ${pkgs.tofi}/bin/tofi-run | sh
      bind = SUPER, Q, killactive
      bind = SUPER, F, fullscreen

      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10

      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6
      bind = SUPER SHIFT, 7, movetoworkspace, 7
      bind = SUPER SHIFT, 8, movetoworkspace, 8
      bind = SUPER SHIFT, 9, movetoworkspace, 9
      bind = SUPER SHIFT, 0, movetoworkspace, 10

      bind = SUPER, left, cyclenext, prev
      bind = SUPER, right, cyclenext
      bind = SUPER, up, cyclenext, prev
      bind = SUPER, down, cyclenext
      bind = SUPER, space, layoutmsg, swapwithmaster

      bind = SUPER SHIFT, left, layoutmsg, mfact -0.05
      bind = SUPER SHIFT, right, layoutmsg, mfact +0.05

      bind = SUPER SHIFT, Q, exit

      binde = ,XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 2
      binde = ,XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 2
      binde = ,XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t
      binde = ,XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source -t

      binde = ,XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%+
      binde = ,XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%-

      binde = SUPER, XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl --class leds --device kbd_backlight set 5%+
      binde = SUPER, XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl --class leds --device kbd_backlight set 5%-

      binde = CTRL, XF86MonBrightnessUp, exec, temp=$(hyprctl hyprsunset temperature); [ $temp -le 6000 ] && hyprctl hyprsunset temperature $((temp + 500)); sleep 0.5; pkill -RTMIN+1 waybar
      binde = CTRL, XF86MonBrightnessDown, exec, temp=$(hyprctl hyprsunset temperature); hyprctl hyprsunset temperature $((temp - 500)); sleep 0.5; pkill -RTMIN+1 waybar

      bindl = ,switch:on:Apple SMC power/lid events,exec,hyprlock --immediate

      bindm = SUPER, mouse:273, resizewindow
      bindm = SUPER, mouse:272, movewindow

      exec-once = waybar
      exec-once = ${pkgs.wbg}/bin/wbg /home/alex/.config/wallpaper/wallpaper.png
      exec-once = ${pkgs.hyprsunset}/bin/hyprsunset -t 3500

      # Add extra config here...
    "
  ];

    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
