{ username, ... }: {
    home-manager.users.${username} = {
        programs.neovim = {
            enable = true;
	    extraConfig = ''
	        set number relativenumber
	    '';
        };
    };
}
