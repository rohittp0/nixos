{ config, pkgs, ... }:

{
  system.fsPackages = [ pkgs.sshfs ];

  fileSystems."/mnt/kay" = {
    device = "sinansftp@sinanmohd.com:";
    fsType = "sshfs";
    options =
      [ # Filesystem options
        "allow_other"          # for non-root access
        "_netdev"              # this is a network fs
        "x-systemd.automount"  # mount on demand

        # SSH options
        "reconnect"              # handle connection drops
        "ServerAliveInterval=15" # keep connections alive
        "IdentityFile=/var/secrets/kaysftp-key"
      ];
  };
}
