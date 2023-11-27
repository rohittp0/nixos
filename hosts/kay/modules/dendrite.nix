{ config, lib, pkgs, ... }:

let
  domain = config.userdata.domain;
  database = {
    connection_string = "postgres:///dendrite?host=/run/postgresql";
    max_open_conns = 90;
    max_idle_conns = 5;
    conn_max_lifetime = -1;
  };
in
{
  sops.secrets."misc/matrix-${domain}" = {};

  services = {
    postgresql = {
      enable = true;
      package = with pkgs; postgresql_15;
      settings = {
        log_timezone = config.time.timeZone;
        listen_addresses = lib.mkForce "";
      };
      ensureDatabases = [ "dendrite" ];
      ensureUsers = [{
        name = "dendrite";
        ensureDBOwnership = true;
      }];
    };

    dendrite = {
      enable = true;
      loadCredential = [
        "private_key:${config.sops.secrets."misc/matrix-${domain}".path}"
      ];

      settings = {
        sync_api.search = {
          enable = true;
          index_path = "/var/lib/dendrite/searchindex";
        };
        global = {
          server_name = domain;
          private_key = "$CREDENTIALS_DIRECTORY/private_key";
          trusted_third_party_id_servers = [
            "matrix.org"
            "vector.im"
          ];
          inherit database;
        };
        logging = [{
          type = "std";
          level = "warn";
        }];
        mscs = {
          inherit database;
          mscs = [ "msc2836" ];
        };
        sync_api = {
          inherit database;
          real_ip_header = "X-Real-IP";
        };
        media_api = {
          inherit database;
          dynamic_thumbnails = true;
          max_file_size_bytes = 12800000000;
        };
        federation_api = {
          inherit database;
          send_max_retries = 8;
          key_perspectives = [{
            server_name = "matrix.org";
            keys = [
              {
                key_id = "ed25519:auto";
                public_key = "Noi6WqcDj0QmPxCNQqgezwTlBKrfqehY1u2FyWP9uYw";
              }
              {
                key_id = "ed25519:a_RXGa";
                public_key = "l8Hft5qXKn1vfHrg3p4+W8gELQVo8N13JkluMfmn2sQ";
              }
            ];
          }];
        };

        app_service_api = {
          inherit database;
        };
        room_server = {
          inherit database;
        };
        push_server = {
          inherit database;
        };
        relay_api = {
          inherit database;
        };
        key_server = {
          inherit database;
        };
        user_api = {
          account_database = database;
          device_database = database;
        };
      };
    };
  };
}
