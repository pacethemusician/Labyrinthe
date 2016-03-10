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
			make_image_factory
			create {LINKED_LIST[PATH_CARD]} walking_paths.make
			create spare_card.make(3, path_card_surfaces[3], 801, 144, 1)
			create board.make (path_card_surfaces)
			create {ARRAYED_LIST[SPRITE]} on_screen_sprites.make(70)
			create l_window_builder
			create back.make (img_to_surface("Images/back_main.png"), 11, 11)
			create current_player.make (player_surfaces[2], 79, 56)
				-- le offset du player par rapport à la path_card est de 23 pixels
			create btn_rotate_left.make (button_surfaces[1], 745, 159)
			create btn_rotate_right.make (button_surfaces[2], 904, 159)
			game_state := "ok"
			on_screen_sprites.extend (back)
            on_screen_sprites.extend (board)
			on_screen_sprites.extend (current_player)
			on_screen_sprites.extend (btn_rotate_left)
			on_screen_sprites.extend (btn_rotate_right)
			on_screen_sprites.extend (spare_card)
			l_window_builder.set_dimension (Window_width, Window_height)
			l_window_builder.set_title ("Shameless labyrinthe clone")
			l_window := l_window_builder.generate_window
			game_library.quit_signal_actions.extend (agent on_quit(?))
			game_library.iteration_actions.extend (agent on_iteration(?, l_window))
			l_window.mouse_button_pressed_actions.extend (agent on_mouse_pressed(?,?,?))
			l_window.mouse_button_released_actions.extend (agent on_mouse_released(?,?,?))
			l_window.mouse_motion_actions.extend (agent on_mouse_move(?, ?, ?, ?))
			game_library.launch

		end


feature {NONE} -- Implementation
	game_state: STRING
		-- Le `game_state' contient l'état du jeu:
		-- "ok" le GAME_ENGINE attend une action du `current_player'
		-- "drag" le GAME_ENGINE performe une action, il faut attendre
	back:BACKGROUND
	board: BOARD
	btn_rotate_left, btn_rotate_right: BUTTON
	on_screen_sprites: LIST[SPRITE]
		-- Liste des sprites à afficher.
	spare_card: PATH_CARD
		-- La carte que le joueur doit placer
	walking_paths: LIST[PATH_CARD]
	walking_paths_index: INTEGER
	current_player: PLAYER

	on_iteration(a_timestamp:NATURAL_32; game_window:GAME_WINDOW_SURFACED)
			-- À faire à chaque iteration.
		do
			across
				on_screen_sprites as l_sprites
			loop
				l_sprites.item.draw_self (game_window.surface)
            end
            if current_player.is_walking then
            	current_player.approach_point (walking_paths[walking_paths_index].x + board.x + 23, walking_paths[walking_paths_index].y + board.y, 3)
            else
            	if walking_paths_index >= walking_paths.count then
            		walking_paths.wipe_out
            	else
	            	current_player.is_walking := true
	            	walking_paths_index := walking_paths_index + 1
		            if (walking_paths[walking_paths_index].x + board.x > current_player.x) then
						current_player.change_animation (current_player.animations[4], 6, 3)
					elseif (walking_paths[walking_paths_index].x + board.x < current_player.x - 23) then
						current_player.change_animation (current_player.animations[5], 6, 3)
					elseif (walking_paths[walking_paths_index].y + board.y > current_player.y) then
						current_player.change_animation (current_player.animations[2], 6, 3)
					elseif (walking_paths[walking_paths_index].y + board.y < current_player.y) then
						current_player.change_animation (current_player.animations[3], 6, 3)
					end
				end
            end
            game_window.update
            audio_library.update
		end

	on_quit(a_timestamp: NATURAL_32)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			game_library.stop  -- Stop the controller loop (allow game_library.launch to return)
		end

	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state:GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks:NATURAL_8)
			-- Méthode appelée lorsque le joueur appuie sur un bouton de la souris.
		do
			if game_state.is_equal ("ok") then
				if click_on(a_mouse_state, 56, 56, 644, 644) then
					-- Si le joueur clique sur le board:
					if not current_player.is_walking then
						walking_paths.wipe_out
						if not ((((current_player.x - 56) // 84) + 1) = (((a_mouse_state.x - 56) // 84) + 1) and
							(((current_player.y - 56) // 84) + 1) = (((a_mouse_state.y - 56) // 84) + 1))	then
							walking_paths := board.pathfind_to((((current_player.x - 56) // 84) + 1), ((current_player.y - 56) // 84) + 1,
										    					(((a_mouse_state.x - 56) // 84) + 1), ((a_mouse_state.y - 56) // 84) + 1)
							walking_paths_index := 0
						end
					end
					-- Si le joueur clique sur la carte jouable:
				elseif click_on(a_mouse_state, spare_card.x, spare_card.y, spare_card.x + 84, spare_card.y + 84) then
						game_state := "drag"
						spare_card.set_x_offset(a_mouse_state.x - spare_card.x)
						spare_card.set_y_offset(a_mouse_state.y - spare_card.y)
					-- Si le joueur clique sur le bouton de rotation gauche:
				elseif click_on(a_mouse_state, btn_rotate_left.x, btn_rotate_left.y,
							    btn_rotate_left.x + btn_rotate_left.current_surface.width,
							    btn_rotate_left.y + btn_rotate_left.current_surface.height) then
						spare_card.rotate (-1)
						spare_card.play_rotate_sfx
					-- Si le joueur clique sur le bouton de rotation droite:
				elseif click_on(a_mouse_state, btn_rotate_right.x, btn_rotate_right.y,
							    btn_rotate_right.x + btn_rotate_right.current_surface.width,
							    btn_rotate_right.y + btn_rotate_right.current_surface.height) then
						spare_card.rotate (1)
						spare_card.play_rotate_sfx
				end
			end

		end

	click_on(mouse:GAME_MOUSE_BUTTON_PRESSED_STATE; x1, y1, x2, y2: INTEGER):BOOLEAN
		do
			Result := (mouse.x >= x1) and (mouse.x < x2) and (mouse.y >= y1) and (mouse.y < y2)
		end
	on_mouse_released(a_timestamp: NATURAL_32; mouse_state:GAME_MOUSE_BUTTON_RELEASED_STATE; nb_clicks:NATURAL_8)
			-- Méthode appelée lorsque le joueur relâche un bouton de la souris.
		do
			if game_state.is_equal ("drag") then
				-- "Vérifier si la spare_card est au-dessus d'une zone dropable"

				-- Sinon on reset:
				spare_card.x := 801
				spare_card.y := 144
				game_state := "ok"
			end
		end

	on_mouse_move(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_MOTION_STATE; a_delta_x, a_delta_y: INTEGER_32)
		-- Routine de mise à jour du drag and drop
		do
			if a_mouse_state.is_left_button_pressed and game_state.is_equal ("drag") then
				spare_card.x := a_mouse_state.x - spare_card.x_offset
				spare_card.y := a_mouse_state.y - spare_card.y_offset
			end

		end

feature {NONE} -- Constantes

	Window_width:NATURAL_16 = 1000
		-- La largeur de la fenêtre en pixels.

	Window_height:NATURAL_16 = 700
		-- La hauteur de la fenêtre en pixels.

end

