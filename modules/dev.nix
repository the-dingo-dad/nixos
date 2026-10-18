{ pkgs, ... }: {
  # Lets Mason-downloaded LSPs/formatters run on NixOS
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ stdenv.cc.cc zlib openssl ];
  };

  environment.systemPackages = with pkgs; [
    neovim neovide wezterm
    git gcc gnumake unzip curl wget
    ripgrep fd fzf lazygit
    nodejs python3 cargo tree-sitter
    wl-clipboard
  ];

  environment.variables.EDITOR = "nvim";
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
}
