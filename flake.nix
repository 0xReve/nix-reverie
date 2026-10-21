{
  description = "Dendritic NixOS module library (nix-reverie)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:denful/import-tree";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    # Twilight channel rehosts artifacts for reproducible hashes.
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Own nixpkgs (unstable): Ambxst + axctl / Quickshell track upstream, not 26.05.
    ambxst.url = "github:Axenide/Ambxst";

    # Auto-updated Cursor AppImage flake (tracks upstream closely).
    cursor.url = "github:omarcresp/cursor-flake";

    # Spiced Spotify for reve.
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    # Declarative Discord clients (Equibop / Equicord for reve).
    nixcord.url = "github:4evy/nixcord";

    # Packaged LazyVim (josh/lazy-nvim-nix) for reve's nvim wrapper.
    lazy-nvim-nix = {
      url = "github:josh/lazy-nvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # flake-parts + denful/import-tree: every modules/**/*.nix is a module (skip _*).
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
