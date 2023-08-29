{ pkgs, ... }:

{
  imports = [ ./seatd.nix ];

  # pkgs
  environment.systemPackages = with pkgs; [
    dwl-sinan
    zathura
    pinentry-gnome
    mpv
    qemu
    OVMFFull
    element-desktop
    swaylock
    swayidle
    swaybg
    foot
    grim
    slurp
    wl-clipboard
    wmenu-sinan
    mako
    wayland
    xdg-utils
    imv
    libnotify
    wob
    wlr-randr
    tor-browser-bundle-bin
    wtype
  ];

  # font
  fonts = {
    packages = with pkgs; [
      terminus-nerdfont
      dm-sans
    ];
    enableDefaultPackages = true;
    fontconfig = {
      hinting.style = "full";
      defaultFonts = {
        monospace = [ "Terminess Nerd Font" ];
        serif = [ "DeepMind Sans" ];
        sansSerif = [ "DeepMind Sans" ];
      };
    };
  };

  # misc
  services = {
    seatd.enable = true;
    dbus.enable = true;
  };

  programs = {
    xwayland.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "gnome3";
    };
    firefox = {
      enable = true;
      preferences = {
        "media.ffmpeg.vaapi.enabled" = true;
        "gfx.webrender.all" = true;
        "identity.fxaccounts.enabled" = false;
      };
    };
  };

  security.pam.services.swaylock.text = "auth include login";
  hardware.opengl.enable = true;
}
