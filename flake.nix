{
  description = "Dendritic multi-host NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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

    # Own nixpkgs (unstable): sops-install-secrets needs Go >= 1.26; 25.11 defaults to 1.25.
    sops-nix.url = "github:Mic92/sops-nix";

    # Twilight channel rehosts artifacts for reproducible hashes.
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Own nixpkgs (unstable): Ambxst + axctl / Quickshell track upstream, not 25.11.
    ambxst.url = "github:Axenide/Ambxst";

    # Auto-updated Cursor AppImage flake (tracks upstream closely).
    cursor.url = "github:omarcresp/cursor-flake";

    nix-secrets = {
      url = "git+ssh://git@github.com/0xReve/nix-secrets.git";
      flake = false;
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
