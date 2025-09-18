{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "hbohlen";
  home.homeDirectory = "/home/hbohlen";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
     # Development tools
     pkgs.git
     pkgs.curl
     pkgs.wget
     pkgs.jq
     pkgs.yq
     pkgs.httpie
     pkgs.tree
     pkgs.ripgrep
     pkgs.fd
     pkgs.bat
     pkgs.eza
     pkgs.fzf
     pkgs.tldr
     pkgs.htop
     pkgs.tmux

     # Programming languages and tools
     pkgs.python3
     pkgs.nodejs
     pkgs.go
     pkgs.rustc
     pkgs.cargo

     # Security and secrets
     pkgs._1password-cli
     pkgs.sops
     pkgs.age
     pkgs.gnupg

     # Text editors and tools
     pkgs.vscode

     # Shell utilities
     pkgs.zsh
     pkgs.fish
     pkgs.starship
     pkgs.zsh-completions
     pkgs.zsh-autosuggestions
     pkgs.zsh-syntax-highlighting

     # Container and virtualization
     pkgs.docker
     pkgs.docker-compose
     pkgs.podman
     pkgs.podman-compose

     # Cloud tools
     pkgs.awscli2
     pkgs.google-cloud-sdk
     pkgs.azure-cli

     # Database tools
     pkgs.sqlite
     pkgs.postgresql

     # Media and utilities
     pkgs.ffmpeg
     pkgs.imagemagick
     pkgs.yt-dlp
   ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # SSH configuration
  programs.ssh = {
     enable = true;
     matchBlocks."*" = {
       extraOptions = {
         StrictHostKeyChecking = "no";
         UserKnownHostsFile = "/dev/null";
       };
     };
   };

  # Home Manager can also manage your environment variables through
   # 'home.sessionVariables'. If you don't want to manage your shell through Home
   # Manager then you have to manually source 'hm-session-vars.sh' located at
   # either
   #
   #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
   #
   # or
   #
   #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
   #
   # or
   #
   #  /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
   #
   home.sessionVariables = {
     EDITOR = "nvim";
     VISUAL = "code";
     PAGER = "less";
     LESS = "-R";
   };

  # Git configuration
  programs.git = {
     enable = true;
     userName = "Hayden Bohlen";
     userEmail = "hbohlen@gmail.com";
     extraConfig = {
       init.defaultBranch = "main";
       pull.rebase = true;
       push.autoSetupRemote = true;
     };
   };

  # Zsh shell configuration
  programs.zsh = {
     enable = true;
     enableCompletion = true;
     autosuggestion.enable = true;
     syntaxHighlighting.enable = true;

     shellAliases = {
       ll = "ls -alF";
       la = "ls -A";
       l = "ls -CF";
       ".." = "cd ..";
       "..." = "cd ../..";
       "...." = "cd ../../..";
       grep = "grep --color=auto";
       fgrep = "fgrep --color=auto";
       egrep = "egrep --color=auto";
       diff = "diff --color=auto";
       ip = "ip --color=auto";

       # Git aliases
       gs = "git status";
       ga = "git add";
       gc = "git commit";
       gp = "git push";
       gl = "git log --oneline";
       gd = "git diff";
       gco = "git checkout";
       gb = "git branch";

       # Nix aliases
       nrs = "sudo nixos-rebuild switch --flake $HOME/hbohlen-io/nixos";
       nrt = "sudo nixos-rebuild test --flake $HOME/hbohlen-io/nixos";
       nrb = "sudo nixos-rebuild boot --flake $HOME/hbohlen-io/nixos";
       hms = "home-manager switch --flake $HOME/hbohlen-io/nixos#hbohlen";
       hmt = "home-manager build --flake $HOME/hbohlen-io/nixos#hbohlen";

      # Rebuild aliases for different hosts
      rebuild-laptop = "sudo nixos-rebuild switch --flake $HOME/hbohlen-io/nixos#laptop";
      rebuild-desktop = "sudo nixos-rebuild switch --flake $HOME/hbohlen-io/nixos#desktop";
      rebuild-server = "sudo nixos-rebuild switch --flake $HOME/hbohlen-io/nixos#server";

       # Development
       py = "python3";
       pip = "python3 -m pip";
     };

     initContent = ''
       # Custom functions
       mkcd() {
         mkdir -p "$1" && cd "$1"
       }

       # Rebuild function for NixOS hosts
       rebuild() {
         if [ -z "$1" ]; then
           echo "Usage: rebuild <host> [action]"
           echo "Hosts: laptop, desktop, server, home"
           echo "Actions: switch (default), test, boot, build"
           return 1
         fi

         local host="$1"
         local action="''${2:-switch}"
         local flake_path="$HOME/hbohlen-io/nixos"

         case "$host" in
           laptop|desktop|server)
             echo "🔄 Rebuilding $host with action: $action"
             if [[ "$action" == "build" ]]; then
               nixos-rebuild build --flake "$flake_path#$host"
             else
               sudo nixos-rebuild "$action" --flake "$flake_path#$host"
             fi
             ;;
           home|hm)
             echo "🏠 Rebuilding home-manager configuration"
             if [[ "$action" == "switch" ]]; then
               home-manager switch --flake "$flake_path#hbohlen"
             else
               home-manager "$action" --flake "$flake_path#hbohlen"
             fi
             ;;
           *)
             echo "❌ Unknown host: $host"
             echo "Available hosts: laptop, desktop, server, home"
             return 1
             ;;
         esac
       }

       # Better history
       setopt histignorealldups
       setopt sharehistory

       # Auto cd
       setopt autocd

       # Extended globbing
       setopt extendedglob

       # Load environment variables from .env files if they exist
       if [ -f .env ]; then
         export $(cat .env | xargs)
       fi
     '';
   };

   # Starship prompt
   programs.starship = {
     enable = true;
     enableZshIntegration = true;
     settings = {
       add_newline = false;
       format = "$username$hostname$directory$git_branch$git_status$cmd_duration$nix_shell$character";
       directory = {
         truncation_length = 3;
         truncate_to_repo = false;
       };
       git_branch = {
         format = "[$branch]($style) ";
       };
       git_status = {
         format = "[$all_status$ahead_behind]($style) ";
       };
       nix_shell = {
         format = "[$symbol$state]($style) ";
       };
       character = {
         success_symbol = "[❯](green)";
         error_symbol = "[❯](red)";
       };
     };
   };

   # Neovim configuration
   programs.neovim = {
     enable = true;
     vimAlias = true;
     vimdiffAlias = true;
     withNodeJs = true;
     withPython3 = true;
     extraConfig = ''
       " Basic settings
       set number
       set relativenumber
       set tabstop=2
       set shiftwidth=2
       set expandtab
       set smartindent
       set autoindent
       set ignorecase
       set smartcase
       set incsearch
       set hlsearch
       set showmatch
       set wildmenu
       set wildmode=longest:full,full
       set scrolloff=8
       set sidescrolloff=8
       set termguicolors
       set background=dark
       set mouse=a

       " Key mappings
       let mapleader = " "
       nnoremap <leader>w :w<CR>
       nnoremap <leader>q :q<CR>
       nnoremap <leader>h :nohlsearch<CR>
       nnoremap <C-n> :Explore<CR>

       " Syntax highlighting
       syntax on
       filetype plugin indent on
     '';
     plugins = with pkgs.vimPlugins; [
       vim-nix
       vim-fugitive
       vim-surround
       vim-commentary
       vim-sensible
       gruvbox
     ];
   };

   # FZF configuration
   programs.fzf = {
     enable = true;
     enableZshIntegration = true;
     defaultCommand = "fd --type f --hidden --exclude .git";
     defaultOptions = [
       "--height 40%"
       "--border"
       "--preview 'bat --style=numbers --color=always {}'"
     ];
   };

   # Tmux configuration
   programs.tmux = {
     enable = true;
     clock24 = true;
     keyMode = "vi";
     customPaneNavigationAndResize = true;
     aggressiveResize = true;
     baseIndex = 1;
     escapeTime = 0;
     historyLimit = 10000;
     extraConfig = ''
       # Better colors
       set -g default-terminal "screen-256color"
       set -ga terminal-overrides ",*256col*:Tc"

       # Status bar
       set -g status-bg black
       set -g status-fg white
       set -g status-left "#[fg=green]#S "
       set -g status-right "#[fg=yellow]%H:%M %d-%b-%y"

       # Window options
       set -g window-status-current-style fg=black,bg=white
       set -g pane-border-style fg=white
       set -g pane-active-border-style fg=green

       # Key bindings
       bind-key r source-file ~/.tmux.conf \; display-message "Config reloaded"
       bind-key | split-window -h
       bind-key - split-window -v
     '';
   };

   # Direnv for automatic environment loading
   programs.direnv = {
     enable = true;
     enableZshIntegration = true;
     nix-direnv.enable = true;
   };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}