{ pkgs, config, flake, ... }:
{
  home.packages = with pkgs; [
    git-filter-repo
  ];

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = flake.config.people.users.${config.home.username}.name;
    userEmail = flake.config.people.users.${config.home.username}.email;
    attributes =
      [
        "*.c     diff=cpp"
        "*.h     diff=cpp"
        "*.c++   diff=cpp"
        "*.h++   diff=cpp"
        "*.cpp   diff=cpp"
        "*.hpp   diff=cpp"
        "*.cc    diff=cpp"
        "*.hh    diff=cpp"
        "*.py    diff=python"
        "*.html  diff=html"
        "*.lisp  diff=lisp"
        "*.el    diff=lisp"
        "*.org   diff=org"
        "*.rs    diff=rust"
      ];
    aliases = {
      co = "checkout";
      ci = "commit";
      cia = "commit --amend";
      s = "status";
      st = "status";
      b = "branch";
      # p = "pull --rebase";
      pu = "push";

      alias = "!_() { git config --global alias.$1 \"$2\"; }; _";
      aliases = "config --get-regexp ^alias\\.";
      checkup = "!git log -1 && (git fetch --all 2>/dev/null || true) && git status";
      # Run a command with the repository root as cwd. See
      # https://stackoverflow.com/questions/957928#comment9747528_957978.
      exec = "!exec ";
      msg = "log --format=%B -1";
      root = "rev-list --max-parents=0 HEAD";
      setup = "!git init && git commit --allow-empty -m \"Initial commit\"";
      unalias = "!_() { git config --global --unset alias.$1; }; _";

      # Show verbose output about tags, branches or remotes
      tags = "tag -l";
      remotes = "remote -v";
      # Pretty log output
      hist = "log --pretty=format:'%C(auto, yellow)%h%Creset %C(auto,dim cyan) %ad%Creset|%C(auto,italic ul dim magenta)%an%Creset%C(auto)%d%Creset %s' --graph --date=short --abbrev-commit";
    };
    iniContent = {
      # Branch with most recent change comes first
      branch.sort = "-committerdate";
      # Remember and auto-resolve merge conflicts
      # https://git-scm.com/book/en/v2/Git-Tools-Rerere
      rerere.enabled = true;
    };
    ignores = [ "*~" "*.swp" ".DS_Store" ];
    delta = {
      enable = true;
      options = {
        features = "decorations";
        navigate = true;
        light = false;
        side-by-side = true;
      };
    };
    extraConfig = {
      init.defaultBranch = "main"; # https://srid.ca/unwoke
      #protocol.keybase.allow = "always";
      credential.helper = "store --file ~/.git-credentials";
      pull.rebase = "false";
      push.default = "current";
      rebase.autosquash = true;
      protocol.hg.allow = "always";
      core = {
        editor = "vim";
        autocrlf = false;
        safecrlf = true;
      };
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        interactive = "auto";
        pager = true;
      };
      "diff \"lisp\"" = { xfuncname = "^(\\(.*)$"; };
      "diff \"org\"" = { xfuncname = "^(\\*+ +.*)$"; };
      "diff \"rust\"" = { xfuncname = "^[ \t]*(pub|)[ \t]*((fn|struct|enum|impl|trait|mod)[^;]*)$"; };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      # This looks better with the kitty theme.
      gui.theme = {
        lightTheme = false;
        activeBorderColor = [ "white" "bold" ];
        inactiveBorderColor = [ "white" ];
        selectedLineBgColor = [ "reverse" "white" ];
      };
    };
  };
}
