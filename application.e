note
	description : "projetLabyrinthe application root class"
	date        : "15 Février 2016"

class
	APPLICATION

inherit
	ARGUMENTS
	GAME_LIBRARY_SHARED		-- Pour utiliser `game_library'
	IMG_LIBRARY_SHARED		-- Pour utitiser `image_file_library'

create
	make

feature {NONE} -- Initialisation

	make
			-- Lance l'application.
		do
			game_library.enable_video -- Enable the video functionalities
			image_file_library.enable_image (true, false, false)  -- Enable PNG image (but not TIF or JPG).
			run_game  -- Run the core creator of the game.
			image_file_library.quit_library  -- Correctly unlink image files library
			game_library.quit_library  -- Clear the library before quitting
		end

	run_game
			-- Créer les ressources et lance le jeu
		local
			l_window_builder:GAME_WINDOW_RENDERED_BUILDER
			l_path_straight:PATH

end
