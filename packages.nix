# Software env
{ config, pkgs, ...}:

let
  nonfree = import <nixos> { config.allowUnfree = true; };
in {
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.variables = { EDITOR = "vim"; };

  environment.systemPackages = with pkgs; [

    # Utils
    git htop wget mc tldr
    
    # VIM Config
    ((vim_configurable.override { python = python3; }).customize{
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [
          nerdtree 
          vim-nix 
          vim-lastplace 
        ];
        opt = [];
      };
      vimrcConfig.customRC = ''
        syntax on

        set number
        set relativenumber

        set hlsearch
        set incsearch

        set paste
        set wildmenu
        set smarttab
        set showmatch

        set t_Co=256
        set background=dark
        colorscheme elflord 

        set clipboard=unnamedplus 

        " Tab 4 chars, hotkeys 'c - t' ->, 'c - d' <- 
        set tabstop=4 softtabstop=-1 shiftwidth=0 expandtab
        set backspace=indent,eol,start

        " Exec NerdTree plugin 
        map <C-n> :NERDTreeToggle<CR>
      '';
    })
  ];
}