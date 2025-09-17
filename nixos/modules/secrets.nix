{ config, lib, ... }:

with lib;

let
  secretsFile = ../../secrets/secrets.yaml;
  secrets = if builtins.pathExists secretsFile
    then builtins.fromJSON (builtins.readFile secretsFile)
    else {};
in
{
  options.hb.secrets = {
    github_token = mkOption {
      type = types.str;
      default = "";
      description = "GitHub personal access token";
    };

    openai_api_key = mkOption {
      type = types.str;
      default = "";
      description = "OpenAI API key";
    };

    database = {
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "Database host";
      };

      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Database username";
      };

      password = mkOption {
        type = types.str;
        default = "";
        description = "Database password";
      };
    };

    ssh_private_key = mkOption {
      type = types.str;
      default = "";
      description = "SSH private key";
    };

    wireguard_private_key = mkOption {
      type = types.str;
      default = "";
      description = "WireGuard private key";
    };

    tailscale_auth_key = mkOption {
      type = types.str;
      default = "";
      description = "Tailscale authentication key";
    };

    server = {
      api_key = mkOption {
        type = types.str;
        default = "";
        description = "Server API key";
      };

      webhook_secret = mkOption {
        type = types.str;
        default = "";
        description = "Server webhook secret";
      };
    };
  };

  config.hb.secrets = secrets;
}