{ pkgs, ... }: {
  users.users."rohit" = {
    isNormalUser = true;
    packages = with pkgs; [ git ];
  };
}
