{ pkgs, ... }: {
  users.users."rohit" = {
    isNormalUser = true;
    packages = with pkgs; [ git ];

    openssh.authorizedKeys.keys =
      [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZcWF1zVyxsCdZ/j+h+RlHZlyhgY2Bky03847bxFNSH rohit@victus" ];
  };
}
