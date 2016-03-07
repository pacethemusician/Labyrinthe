note
	description : "projet Labyrinthe application root class"
	author: "Pascal Belisle et Charles Lemay"
	date: "1 mars 2016"

class
	GAME_ENGINE

inherit
	GAME_LIBRARY_SHARED
	AUDIO_LIBRARY_SHARED
	IMG_LIBRARY_SHARED
	IMAGE_FACTORY
		rename
			make as make_image_factory
		end

create
	make

feature {NONE} -- Initialisation

	make
		-- Créer les ressources et lance le jeu.
		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_window:GAME_WINDOW_SURFACED
		do
			-- init_surfaces
			make_image_factory
			create board.make (path_card_surfaces)
			create on_screen_sprites.make
			create l_window_builder
			create back.make (img_to_surface("Images/back_main.png"), 11, 11)
			create p1.make (surfaces, 100, 100)
			on_screen_sprites.extend (p1)
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
			-- Stock en mémoire tous les fichiers images convertis en `GAME_SURFACE'
			do
				create surfaces.make(20)
				surfaces.put(img_to_surface("Images/p1_still.png"), "p1_still")
				surfaces.put(img_to_surface("Images/p1_walk_down.png"), "p1_walk_down")
				surfaces.put(img_to_surface("Images/p1_walk_up.png"), "p1_walk_up")
				surfaces.put(img_to_surface("Images/p1_walk_right.png"), "p1_walk_right")
				surfaces.put(img_to_surface("Images/p1_walk_left.png"), "p1_walk_left")
				-- surfaces.put(img_to_surface("Images/back_main.png"), "back_main")
				surfaces.put(img_to_surface("Images/arrow_off.png"), "arrow_off")
				surfaces.put(img_to_surface("Images/arrow_on.png"), "arrow_on")
				surfaces.put(img_to_surface("Images/arrow_on_g.png"), "arrow_on_g")
				surfaces.put(img_to_surface("Images/btn_rotate_left.png"), "btn_rotate_left")
				surfaces.put(img_to_surface("Images/btn_rotate_right.png"), "btn_rotate_left")
				-- surfaces.put(img_to_surface("Images/.png"), "")
			end

<<<<<<< HEAD
=======
		path_type_surfaces:LIST[LIST[GAME_SURFACE]]
			local
				l_surfaces: LIST[LIST[GAME_SURFACE]]
			do
				create {ARRAYED_LIST[LIST[GAME_SURFACE]]} l_surfaces.make (3)
				l_surfaces.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(4))
				l_surfaces.at (1) .extend(img_to_surface("Images/path_type1a.png"))
				l_surfaces.at (1) .extend(img_to_surface("Images/path_type1b.png"))
				l_surfaces.at (1) .extend(img_to_surface("Images/path_type1c.png"))
				l_surfaces.at (1) .extend(img_to_surface("Images/path_type1d.png"))
				l_surfaces.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(4))
				l_surfaces.at (2) .extend(img_to_surface("Images/path_type2a.png"))
				l_surfaces.at (2) .extend(img_to_surface("Images/path_type2b.png"))
				l_surfaces.at (2) .extend(img_to_surface("Images/path_type2c.png"))
				l_surfaces.at (2) .extend(img_to_surface("Images/path_type2d.png"))
				l_surfaces.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(4))
				l_surfaces.at (3) .extend(img_to_surface("Images/path_type3a.png"))
				l_surfaces.at (3) .extend(img_to_surface("Images/path_type3b.png"))
				l_surfaces.at (3) .extend(img_to_surface("Images/path_type3c.png"))
				l_surfaces.at (3) .extend(img_to_surface("Images/path_type3d.png"))
				Result := l_surfaces
			end

		init_board
				-- Initialize the `board'
			-- 1ere path_card y et x = 56
			local
				l_surfaces: LIST[LIST[GAME_SURFACE]]
			do
				l_surfaces := path_type_surfaces
				init_row_1(l_surfaces)
				init_row_2(l_surfaces)
				init_row_3(l_surfaces)
				init_row_4(l_surfaces)
				init_row_5(l_surfaces)
				init_row_6(l_surfaces)
				init_row_7(l_surfaces)
			end

		init_row_1(a_surfaces: LIST[LIST[GAME_SURFACE]])
				-- Rangée 1:
				-- Le type peut être soit 1='╗' 2='║'  3='╣'
			local
				l_list:ARRAYED_LIST[PATH_CARD]
			do
				create l_list.make (7)
				l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 56, 56, 4))
				l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 56 + 84 * 1, 56, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 2, 56, 4))
				l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 56 + 84 * 3, 56, 4))
				l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 56 + 84 * 4, 56, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 5, 56, 4))
				l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 56 + 84 * 6, 56, 1))
				board.extend (l_list)
			end

		init_row_2(a_surfaces: LIST[LIST[GAME_SURFACE]])
				-- Rangée 2:
				-- Le type peut être soit 1='╗' 2='║'  3='╣'
			local
				l_list:ARRAYED_LIST[PATH_CARD]
			do
				create l_list.make (7)
				l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 56, 140, 4))
				l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 56 + 84 * 1, 140, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 2, 140, 4))
				l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 56 + 84 * 3, 140, 4))
				l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 56 + 84 * 4, 140, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 5, 140, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 6, 140, 4))
				board.extend (l_list)
			end

		init_row_3(a_surfaces: LIST[LIST[GAME_SURFACE]])
				-- Rangée 3:
				-- Le type peut être soit 1='╗' 2='║'  3='╣'
			local
				l_list:ARRAYED_LIST[PATH_CARD]
			do
				create l_list.make (7)
				l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 56, 224, 4))
				l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 56 + 84 * 1, 224, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 2, 224, 4))
				l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 56 + 84 * 3, 224, 4))
				l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 56 + 84 * 4, 224, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 5, 224, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 6, 224, 4))
				board.extend (l_list)
			end

		init_row_4(a_surfaces: LIST[LIST[GAME_SURFACE]])
				-- Rangée 4:
				-- Le type peut être soit 1='╗' 2='║'  3='╣'
			local
				l_list:ARRAYED_LIST[PATH_CARD]
			do
				create l_list.make (7)
				l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 56, 308, 4))
				l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 56 + 84 * 1, 308, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 2, 308, 4))
				l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 56 + 84 * 3, 308, 4))
				l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 56 + 84 * 4, 308, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 5, 308, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 6, 308, 4))
				board.extend (l_list)
			end

		init_row_5(a_surfaces: LIST[LIST[GAME_SURFACE]])
				-- Rangée 5:
				-- Le type peut être soit 1='╗' 2='║'  3='╣'
			local
				l_list:ARRAYED_LIST[PATH_CARD]
			do
				create l_list.make (7)
				l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 56, 392, 4))
				l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 56 + 84 * 1, 392, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 2, 392, 4))
				l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 56 + 84 * 3, 392, 4))
				l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 56 + 84 * 4, 392, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 5, 392, 4))
				l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56 + 84 * 6, 392, 4))
				board.extend (l_list)
			end
>>>>>>> 92eefca7a5f120694be87d7726bfc17f7e384df8


feature {NONE} -- Implementation
	surfaces : STRING_TABLE[GAME_SURFACE]
	back:BACKGROUND
	board: BOARD
	p1:PLAYER

	on_iteration(a_timestamp:NATURAL_32; game_window:GAME_WINDOW_SURFACED)
			-- À faire à chaque iteration.
		do
			back.draw_self (game_window.surface)
			board.draw (game_window.surface)
			across
				on_screen_sprites as l_sprites
			loop
				l_sprites.item.draw_self (game_window.surface)
            end

            game_window.update
            audio_library.update
            p1.approach_point (200, 500, 1)
		end

	on_quit(a_timestamp: NATURAL_32)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			game_library.stop  -- Stop the controller loop (allow game_library.launch to return)
		end

	on_mouse_pressed(a_timestamp: NATURAL_32; mouse_state:GAME_MOUSE_BUTTON_PRESSED_STATE; nb_clicks:NATURAL_8)
			-- Méthode appelée lorsque le joueur appuie sur un bouton de la souris.
		do

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

