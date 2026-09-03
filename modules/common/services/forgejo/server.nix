{ config, ... }:
let
  cfg = config.maximizzar.modules.services.forgejo;

  basedomain = "maximizzar.org";
  fqdn = "forgejo.srv.genesis.prod.${basedomain}";
  rootdomain = "forgejo.maximizzar.org";
in
{
  services.forgejo.enable = cfg.enable;
  services.forgejo = {
    lfs.enable = true;
    repositoryRoot = "/mnt/repositories";

    settings = {
      DEFAULT = {
        APP_NAME = "Forgejo <maximizzar.org>";
        APP_SLOGAN = "Yet another forgejo instance!";
      };

      server = {
        DOMAIN = "${fqdn}";
        ROOT_URL = "https://${rootdomain}/";
        SSH_DOMAIN = "ssh.${rootdomain}";

        PROTOCOL = "http+unix";
      };
      session.COOKIE_SECURE = true;

      service = {
        ENABLE_CAPTCHA = false;
        DISABLE_REGISTRATION = true;
        REQUIRE_SIGNIN_VIEW = false;
      };

      oauth2_client = {
        ENABLE_AUTO_REGISTRATION = true;
      };
    };
  };

}
