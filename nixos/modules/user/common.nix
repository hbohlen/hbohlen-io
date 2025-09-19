# Common user configuration shared across all hosts
{ config, pkgs, ... }:

{
  # User Account
  users.users.hbohlen = {
    isNormalUser = true;
    description = "Hayden Bohlen";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    shell = pkgs.zsh;
  };
}