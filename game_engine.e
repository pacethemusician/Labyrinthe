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

create
	make

feature {NONE} -- Initialisation

	make
		-- Créer les ressources et lance le jeu.
		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_window:GAME_WINDOW_SURFACED
		do
			init_surfaces
			create board.make(7)
			init_board
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

		init_board
			-- 1ere path_card y et x = 56
			local
				l_surfaces: ARRAYED_LIST[ARRAYED_LIST[GAME_SURFACE]]
				l_rotated_surfaces: ARRAYED_LIST[GAME_SURFACE]
				l_path_row: ARRAYED_LIST[PATH_CARD]
			do
				create l_path_row.make (7)
				create l_surfaces.make (3)
				create l_rotated_surfaces.make (4)
				l_rotated_surfaces.extend(img_to_surface("Images/path_type1a.png"))
				l_rotated_surfaces.extend(img_to_surface("Images/path_type1b.png"))
				l_rotated_surfaces.extend(img_to_surface("Images/path_type1c.png"))
				l_rotated_surfaces.extend(img_to_surface("Images/path_type1d.png"))
				l_surfaces.extend (l_rotated_surfaces)
				l_rotated_surfaces.wipe_out
				l_rotated_surfaces.extend(img_to_surface("Images/path_type2a.png"))
				l_rotated_surfaces.extend(img_to_surface("Images/path_type2b.png"))
				l_rotated_surfaces.extend(img_to_surface("Images/path_type2c.png"))
				l_rotated_surfaces.extend(img_to_surface("Images/path_type2d.png"))
				l_surfaces.extend (l_rotated_surfaces)
				l_rotated_surfaces.wipe_out
				l_rotated_surfaces.extend(img_to_surface("Images/path_type3a.png"))
				l_rotated_surfaces.extend(img_to_surface("Images/path_type3b.png"))
				l_rotated_surfaces.extend(img_to_surface("Images/path_type3c.png"))
				l_rotated_surfaces.extend(img_to_surface("Images/path_type3d.png"))
				l_surfaces.extend (l_rotated_surfaces)
				-- Le type peut être soit 1='╗' 2='║'  3='╣'
				-- Rangée 1:
				l_path_row.extend (create {PATH_CARD} .make (1, l_surfaces[1], 56, 56, 1))
				l_path_row.extend (create {PATH_CARD} .make (2, l_surfaces[2], 56 + 84 * 1, 56, 4))
				l_path_row.extend (create {PATH_CARD} .make (3, l_surfaces[3], 56 + 84 * 2, 56, 4))
				l_path_row.extend (create {PATH_CARD} .make (1, l_surfaces[1], 56 + 84 * 3, 56, 4))
				l_path_row.extend (create {PATH_CARD} .make (2, l_surfaces[2], 56 + 84 * 4, 56, 4))
				l_path_row.extend (create {PATH_CARD} .make (3, l_surfaces[3], 56 + 84 * 5, 56, 4))
				l_path_row.extend (create {PATH_CARD} .make (1, l_surfaces[1], 56 + 84 * 6, 56, 4))
				board.extend (l_path_row)
				l_path_row.wipe_out
				-- Rangée 2:
				l_path_row.extend (create {PATH_CARD} .make (1, l_surfaces[1], 56, 140, 4))
				l_path_row.extend (create {PATH_CARD} .make (2, l_surfaces[2], 56 + 84 * 1, 140, 4))
				l_path_row.extend (create {PATH_CARD} .make (3, l_surfaces[3], 56 + 84 * 2, 140, 4))
				l_path_row.extend (create {PATH_CARD} .make (1, l_surfaces[1], 56 + 84 * 3, 140, 4))
				l_path_row.extend (create {PATH_CARD} .make (2, l_surfaces[2], 56 + 84 * 4, 140, 4))
				l_path_row.extend (create {PATH_CARD} .make (3, l_surfaces[3], 56 + 84 * 5, 140, 4))
				board.extend (l_path_row)
				l_path_row.wipe_out
				-- Rangée 3:
				l_path_row.extend (create {PATH_CARD} .make (1, l_surfaces[1], 56 + 6 * 84, 56, 1))
				l_path_row.extend (create {PATH_CARD} .make (2, l_surfaces[2], 56, 56 + 6 * 84, 3))
				l_path_row.extend (create {PATH_CARD} .make (3, l_surfaces[3], 56 + 6 * 84, 56 + 6 * 84, 2))
				board.extend (l_path_row)
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
	surfaces : STRING_TABLE[GAME_SURFACE]
	back:BACKGROUND
	board: ARRAYED_LIST[ARRAYED_LIST[PATH_CARD]]
	p1:PLAYER

	on_iteration(a_timestamp:NATURAL_32; game_window:GAME_WINDOW_SURFACED)
			-- À faire à chaque iteration.
		do
			back.draw_self (game_window.surface)
			board.at (1).at (1).draw_self (game_window.surface)
--            across
--				board as l_board
--            loop
--            	across
--            		l_board.item as l_row
--            	loop
--            		l_row.item.draw_self (game_window.surface)
--            	end
--            end
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

