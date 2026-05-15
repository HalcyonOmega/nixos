{
  pkgs,
  username,
  githubEmail,
  githubUsername,
  ...
}:
{
  home-manager.users.${username} = {
    home.packages = [
      pkgs.git
      pkgs.gh
    ];
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "${githubUsername}";
          email = "${githubEmail}";
        };
        init.defaultBranch = "main";
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
        pull.ff = "only";
        color.ui = true;
        url = {
          "git@github.com:".insteadOf = [
            "gh:"
            "https://github.com/"
          ];
          "git@github.com:frost-phoenix/".insteadOf = "fp:";
        };
        core.excludesFile = "/home/${username}/.config/git/.gitignore";
      };

    };

    programs.delta = {
      enable = true;
      options = {
        line-numbers = true;
        side-by-side = false;
        diff-so-fancy = true;
        navigate = true;
      };
      enableGitIntegration = true;
    };

    xdg.configFile."git/.gitignore".text = ''
      .vscode
      .idea
    '';
  };
}
