{ config, lib, pkgs, ... }:

{
  home.sessionVariables = { EDITOR = "nvim"; };

  home.packages = with pkgs; [
    awscli
    bat
    buf
    comma
    curl
    docker-compose
    envsubst
    gnused
    google-cloud-sdk
    goreleaser
    grpcurl
    jq
    kubectl
    kubectx
    kubernetes-helm
    kubetail
    libxml2
    m-cli
    mas
    mkcert
    moreutils
    ngrok
    nixfmt
    nodePackages."@vue/cli"
    nodePackages.gitlab-ci-local
    nodePackages.iterm2-tab-set
    nodePackages.pnpm
    nodePackages.speccy
    open-policy-agent
    pkg-config
    pstree
    ripgrep
    tmux
    trash-cli
    tree
    wget
    yarn
    yq
    zsh-powerlevel10k
  ];
}
