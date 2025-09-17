{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hb.yubikey;
in
{
  options.hb.yubikey = {
    enable = mkEnableOption "YubiKey integration";

    ssh = {
      enable = mkEnableOption "SSH authentication with YubiKey";
      agent.enable = mkEnableOption "YubiKey SSH agent";
    };

    pam = {
      enable = mkEnableOption "PAM authentication with YubiKey";
      sudo = mkEnableOption "Require YubiKey for sudo";
      login = mkEnableOption "Require YubiKey for login";
    };

    gpg.enable = mkEnableOption "GPG integration with YubiKey";
  };

  config = mkIf cfg.enable {
    # Install YubiKey packages
    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubikey-personalization
      yubico-piv-tool
      yubikey-agent
      libyubikey
      yubikey-manager-qt
    ] ++ optionals cfg.pam.enable [
      pam_yubico
    ];

    # Enable PC/SC daemon for smart card support
    services.pcscd.enable = true;

    # Udev rules for YubiKey access
    services.udev.packages = with pkgs; [
      yubikey-personalization
    ];

    # PAM configuration
    security.pam = mkIf cfg.pam.enable {
      yubico = {
        enable = true;
        debug = false;
        mode = "challenge-response";
      };

      services = mkMerge [
        (mkIf cfg.pam.sudo {
          sudo.yubicoAuth = true;
        })
        (mkIf cfg.pam.login {
          login.yubicoAuth = true;
        })
      ];
    };

    # SSH agent configuration
    systemd.user.services = mkIf cfg.ssh.agent.enable {
      yubikey-agent = {
        description = "YubiKey SSH Agent";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.yubikey-agent}/bin/yubikey-agent -l";
          Restart = "always";
        };
      };
    };

    # GPG configuration
    programs.gnupg.agent = mkIf cfg.gpg.enable {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };

    # Environment variables for SSH
    environment.sessionVariables = mkIf cfg.ssh.enable {
      SSH_AUTH_SOCK = "$HOME/.yubikey-agent.sock";
    };
  };
}