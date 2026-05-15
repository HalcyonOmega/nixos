{ pkgs, username, ... }:
{
  users.users.${username} = {
    shell = pkgs.fish;
  };
}
