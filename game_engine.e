note
	description : "projetLabyrinthe application root class"
	date        : "15 Février 2016"

class
	GAME_ENGINE

inherit
	GAME_LIBRARY_SHARED
	AUDIO_LIBRARY_SHARED
	IMG_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialisation

	make
			-- Crée les ressources et lance le jeu.
		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_window:GAME_WINDOW_SURFACED
		do
			init_surfaces
			create on_screen_sprites.make
			create l_window_builder
			if attached surfaces["main_back"] as la_surface then
				create back.make (la_surface)
			else
				create back.make (create {GAME_SURFACE} .make (1, 1))
			end
			create board.make(surfaces)
			create p1.make (surfaces)
			create path_test.make(1, surfaces)
			path_test.x := 110
			path_test.y := 110
			p1.x := 100
			p1.y := 100
			on_screen_sprites.extend (back)
			on_screen_sprites.extend (board)
			on_screen_sprites.extend (p1)
			on_screen_sprites.extend (path_test)
			l_window_builder.set_dimension (Window_width, Window_height)
			l_window_builder.set_title ("Shameless labyrinthe clone")
			l_window := l_window_builder.generate_window
			game_library.quit_signal_actions.extend (agent on_quit(?))
			game_library.iteration_actions.extend (agent on_iteration(?, l_window))
			l_window.mouse_button_pressed_actions.extend (agent on_mouse_pressed(?,?,?))
			l_window.mouse_button_released_actions.extend (agent on_mouse_released(?,?,?))
			game_library.launch
		end

	init_surfaces
		-- Stock en mémoire toutes les fichiers images convertis en `GAME_SURFACE
		do
			create surfaces.make(20)
			surfaces.put(img_to_surface("Images/path_type1a.png"), "path_card_1a")
			surfaces.put(img_to_surface("Images/path_type1b.png"), "path_card_1b")
			surfaces.put(img_to_surface("Images/path_type1c.png"), "path_card_1c")
			surfaces.put(img_to_surface("Images/path_type1d.png"), "path_card_1d")
			surfaces.put(img_to_surface("Images/path_type2a.png"), "path_card_2a")
			surfaces.put(img_to_surface("Images/path_type2b.png"), "path_card_2b")
			surfaces.put(img_to_surface("Images/path_type2c.png"), "path_card_2c")
			surfaces.put(img_to_surface("Images/path_type2d.png"), "path_card_2d")
			surfaces.put(img_to_surface("Images/path_type3a.png"), "path_card_3a")
			surfaces.put(img_to_surface("Images/path_type3b.png"), "path_card_3b")
			surfaces.put(img_to_surface("Images/path_type3c.png"), "path_card_3c")
			surfaces.put(img_to_surface("Images/path_type3d.png"), "path_card_3d")
			surfaces.put(img_to_surface("Images/p1_still.png"), "p1_still")
			surfaces.put(img_to_surface("Images/p1_walk_down.png"), "p1_walk_down")
			surfaces.put(img_to_surface("Images/p1_walk_up.png"), "p1_walk_up")
			surfaces.put(img_to_surface("Images/p1_walk_right.png"), "p1_walk_right")
			surfaces.put(img_to_surface("Images/p1_walk_left.png"), "p1_walk_left")
			surfaces.put(img_to_surface("Images/back_board.png"), "back_board")
			surfaces.put(img_to_surface("Images/main_back.png"), "main_back")
		end

	img_to_surface (a_img_path:STRING):GAME_SURFACE
		local
			l_image:IMG_IMAGE_FILE
			l_surface:GAME_SURFACE
		do
			create l_image.make (a_img_path)
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create l_surface.make_from_image (l_image)
				else
					create l_surface.make(1,1)
				end
			else
				create l_surface.make(1,1)
			end
			Result := l_surface
		end

feature {NONE} -- Implementation

	back:BACKGROUND
	board:BOARD
	p1:PLAYER
	path_test: PATH_CARD
	surfaces : STRING_TABLE[GAME_SURFACE]

	on_iteration(a_timestamp:NATURAL_32; game_window:GAME_WINDOW_SURFACED)
			-- Event that is launch at each iteration.
		do
			across
				on_screen_sprites as l_sprites
			loop
				l_sprites.item.draw_self (game_window.surface)
            end
            game_window.update
            audio_library.update
		end

	on_quit(a_timestamp: NATURAL_32)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			game_library.stop  -- Stop the controller loop (allow game_library.launch to return)
		end

	on_mouse_pressed(a_timestamp: NATURAL_32; mouse_state:GAME_MOUSE_BUTTON_PRESSED_STATE; nb_clicks:NATURAL_8)
			-- Méthode appelée lorsque le joueur appuie sur un bouton de la souris.
		do
			path_test.rotate(90.0)
		end

	on_mouse_released(a_timestamp: NATURAL_32; mouse_state:GAME_MOUSE_BUTTON_RELEASED_STATE; nb_clicks:NATURAL_8)
			-- Méthode appelée lorsque le joueur relâche un bouton de la souris.
		do

		end

	on_screen_sprites: LINKED_LIST[SPRITE]
		-- Liste des sprites à afficher.

feature {NONE} -- Constantes

	Window_width:NATURAL_16 = 1000
		-- La largeur de la fenêtre en pixels.

	Window_height:NATURAL_16 = 700
		-- La hauteur de la fenêtre en pixels.

end

