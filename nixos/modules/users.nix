# User account configuration
{ config, pkgs, ... }:

{
  # User Account
  users.users.hbohlen = {
    isNormalUser = true;
    description = "Hayden";
    extraGroups = [ "networkmanager" "wheel" ];
    # Temporary password - change after first login with: passwd
    initialPassword = "changeme";
  };
}