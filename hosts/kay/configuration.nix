{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/network.nix
    ./modules/www.nix
    ./modules/sftp.nix
    ./modules/dns
    ../../common.nix
  ];

  boot.consoleLogLevel = 3;
}
