{ config, pkgs, ... }:

let
  user = config.userdata.user;
  groups = config.userdata.groups;
  description = config.userdata.email;
  pubKeys = config.userdata.pubKeys;
  host = config.networking.hostName;
in
{
  disabledModules = [
    "services/networking/pppd.nix"
    "tasks/network-interfaces-scripted.nix"
  ];
  imports = [
    ./modules/userdata.nix
    ./modules/dev.nix
    ./modules/pppd.nix
    ./modules/network-interfaces-scripted.nix
  ];

  # boot
  boot = {
    tmp.useTmpfs = true;
    loader = {
      timeout = 1;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # users
  users.users.${user} = {
    inherit description;
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
    ] ++ groups;
    packages = with pkgs; [
      yt-dlp
      geoipWithDatabase
      dig
      nnn
      ffmpeg
      rtorrent
      ps_mem
      brightnessctl
      neofetch
      (pass.withExtensions (exts: [ exts.pass-otp ]))
    ];
    openssh.authorizedKeys.keys = pubKeys;
  };

  # system
  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    shellAliases = {
      ls = "ls --color=auto --group-directories-first";
      grep = "grep --color=auto";
    };
    systemPackages = with pkgs; [
      dash
      luajit
      unzip
      bc
      file
      git
      htop
      curl
      neovim
      age
      sops
    ];
  };
  system.stateVersion = "23.11";
  time.timeZone = "Asia/Kolkata";

  # nix
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  # sops
  sops = {
    defaultSopsFile = ./hosts/${host}/secrets.yaml;
    age.keyFile = "/var/secrets/sops.key";
  };

  # programs
  programs.bash.promptInit = ''
    if [ "$UID" -ne 0 ]; then
        PROMPT_COLOR="1;32m"
    else
        PROMPT_COLOR="1;31m"
    fi

    PS1="\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
  '';
}
