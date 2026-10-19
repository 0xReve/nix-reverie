# Placeholder Home Manager user. Features merge from sibling modules.
{
  flake.modules.homeManager."users/example" = {
    home.username = "example";
    home.homeDirectory = "/home/example";
    home.stateVersion = "25.11";
  };
}
