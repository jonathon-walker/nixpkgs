{ config, pkgs, ... }: {
  # Git
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
  programs.git.enable = true;

  programs.git.extraConfig = {
    diff.colorMoved = "default";
    pull.rebase = true;

    init.defaultBranch = "main";

    url."git@lab.identitii.com:".insteadOf = "https://lab.identitii.com/";
    url."git@lab.identitii.com:identitii/dateparse.git".insteadOf =
      "https://lab.identitii.com/identitii/dateparse.git";
    url."git@lab.identitii.com:identitii/kin-openapi.git".insteadOf =
      "https://lab.identitii.com/identitii/kin-openapi.git";
    url."git@lab.identitii.com:identitii/oapi-codegen.git".insteadOf =
      "https://lab.identitii.com/identitii/oapi-codegen.git";
    url."git@lab.identitii.com:identitii/proto-registry.git".insteadOf =
      "https://lab.identitii.com/identitii/proto-registry.git";
  };

  programs.git.ignores = [ ".DS_Store" ];

  programs.git.userEmail = config.home.userInfo.email;
  programs.git.userName = config.home.userInfo.fullName;

  # Enhanced diffs
  programs.git.delta = {
    enable = true;
    options.side-by-side = true;
  };

  programs.git.aliases = { st = "status -sb"; };
}
