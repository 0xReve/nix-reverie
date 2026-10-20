# Username / stateVersion only. Features merge from sibling modules.
{
  flake.modules.homeManager."users/reve" = {
    home.username = "reve";
    home.homeDirectory = "/home/reve";
    home.stateVersion = "25.11";
  };
}
