{ config, pkgs, lib, ... }:

let
  inherit (lib) concatStringsSep optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.userInfo) nixConfigDirectory;

  vscode-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "darkplus.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "mofiqul";
      repo = "vscode.nvim";
      rev = "920145bc2c431f8086549957aeb085d8e4c10ab2";
      sha256 = "72nqgkq88bmD/Y09L2zVUC8Xp201NKNz9VD3CSogI/8=";
    };
  };

in {
  # Put neovim configuration located in this repository into place in a way that edits to the
  # configuration don't require rebuilding the `home-manager` environment to take effect.
  xdg.configFile."nvim/lua".source =
    mkOutOfStoreSymlink "${nixConfigDirectory}/configs/nvim/lua";

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;

    # extraConfig = "lua require('init')";

    plugins = with pkgs.vimPlugins; [
      {
        plugin = tokyonight-nvim;
        config = "colorscheme tokyonight";
      }

      {
        plugin = nvim-tree-lua;
        config = "lua require('nvim-tree').setup()";
      }
      {
        plugin = lualine-nvim;
        config = "lua require('lualine').setup()";
      }

      barbar-nvim
      neogit
      plenary-nvim
      nvim-web-devicons
      vim-nix
    ];
  };
}
