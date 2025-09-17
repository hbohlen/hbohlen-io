# User account configuration
{ config, pkgs, ... }:

{
  # User Account
  users.users.hbohlen = {
    isNormalUser = true;
    description = "Hayden";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}