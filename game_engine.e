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
			l_font: TEXT_FONT
		do
			make_image_factory
			create l_font.make ("ARCADECLASSIC.ttf", 36)
			if l_font.is_openable then
				l_font.open
			end
			create spare_card.make(3, path_card_surfaces[3], 801, 144, 1, item_surfaces)
			create board.make (path_card_surfaces, item_surfaces)
			create {ARRAYED_LIST[SPRITE]} on_screen_sprites.make(70)
			create l_window_builder
			create back.make (img_to_surface("Images/back_main.png"), 11, 11)
			create back_title.make (img_to_surface("Images/back_titlescreen.png"), 0, 0)
			create current_player.make (player_surfaces[4], 79, 56)
				-- le offset du player par rapport à la path_card est de 23 pixels
			create btn_rotate_left.make (button_surfaces[1], 745, 159)
			create btn_rotate_right.make (button_surfaces[2], 904, 159)
			create btn_create_game.make (button_surfaces[3], 60, 230)
			create btn_join_game.make (button_surfaces[3], 60, 340)
			game_state := "start"
			btn_rotate_left.on_click_actions.extend(agent rotate_spare_card (-1))
			btn_rotate_right.on_click_actions.extend(agent rotate_spare_card (1))
			btn_create_game.on_click_actions.extend (agent change_state("menu_players"))
			btn_join_game.on_click_actions.extend (agent change_state("menu_join"))
			on_screen_sprites.extend (back)
--            on_screen_sprites.extend (board)
			on_screen_sprites.extend (btn_rotate_left)
			on_screen_sprites.extend (btn_rotate_right)
			on_screen_sprites.extend (spare_card)
			across board.board_paths as l_rows loop
				across l_rows.item as l_cards loop
					on_screen_sprites.extend (l_cards.item)
				end
			end
			on_screen_sprites.extend (current_player)
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
		-- "start" on ouvre l'écran titre pour lancer une nouvelle partie
		-- "ok" le GAME_ENGINE attend une action du `current_player'
		-- "busy" le GAME_ENGINE performe une action, il faut attendre
		-- "drag" l'utilisateur déplace la spare card.
	back, back_title:BACKGROUND
	board: BOARD
	btn_rotate_left, btn_rotate_right: BUTTON
	btn_create_game, btn_join_game: BUTTON
	on_screen_sprites: LIST[SPRITE]
		-- Liste des sprites à afficher.
	spare_card: PATH_CARD
		-- La carte que le joueur doit placer
	current_player: PLAYER
	-- players: LIST[PLAYER]

	on_iteration(a_timestamp:NATURAL_32; game_window:GAME_WINDOW_SURFACED)
			-- À faire à chaque iteration.
		do
			if game_state.is_equal ("start") then
				back_title.draw_self (game_window.surface)
				btn_create_game.draw_self (game_window.surface)
				btn_join_game.draw_self (game_window.surface)
			elseif game_state.is_equal ("menu_players") then

			elseif game_state.is_equal ("menu_join") then

			else
				board.adjust_paths(32)
				if game_state.is_equal ("ok") then
					spare_card.approach_point (801, 144, 64)
				end
				if not current_player.path.is_empty then
	            	current_player.follow_path
	            end
				across
					on_screen_sprites as l_sprites
				loop
					l_sprites.item.draw_self (game_window.surface)
	            end

            end
            game_window.update
            audio_library.update
		end

	on_quit(a_timestamp: NATURAL_32)
			-- Méthode appelée si l'utilisateur quitte la partie (par ex. en fermant la fenêtre).
		do
			game_library.stop  -- Stop the controller loop (allow game_library.launch to return)
		end

	change_state(a_new_state:STRING)
			-- change le `game_state'
		do
			game_state := a_new_state
		end

	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state:GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks:NATURAL_8)
			-- Méthode appelée lorsque le joueur appuie sur un bouton de la souris.
		local
			l_next_spare_card: PATH_CARD
		do
--			board.refresh_board_surface
			if game_state.is_equal ("ok") then
				if a_mouse_state.is_right_button_pressed then
					l_next_spare_card := board.get_next_spare_card_row (4, true)
					board.rotate_row (4, spare_card, true)
					spare_card := l_next_spare_card
				end
				-- Si le joueur clique sur le bouton de rotation gauche:
				btn_rotate_left.execute_actions(a_mouse_state)
				-- Si le joueur clique sur le bouton de rotation droite:
				btn_rotate_right.execute_actions(a_mouse_state)
				if click_on(a_mouse_state, 56, 56, 644, 644) then
					-- Si le joueur clique sur le board:
					if current_player.path.is_empty then
						if not ((((current_player.x - 56) // 84) + 1) = (((a_mouse_state.x - 56) // 84) + 1) and
							(((current_player.y - 56) // 84) + 1) = (((a_mouse_state.y - 56) // 84) + 1))	then
							current_player.path := board.pathfind_to((((current_player.x - 56) // 84) + 1), ((current_player.y - 56) // 84) + 1,
																				(((a_mouse_state.x - 56) // 84) + 1), ((a_mouse_state.y - 56) // 84) + 1)
						end
					end
					-- Si le joueur clique sur la carte jouable:
				elseif click_on(a_mouse_state, spare_card.x, spare_card.y, spare_card.x + 84, spare_card.y + 84) then
						game_state := "drag"
						spare_card.set_x_offset(a_mouse_state.x - spare_card.x)
						spare_card.set_y_offset(a_mouse_state.y - spare_card.y)
				end
			elseif game_state.is_equal ("start") then
				btn_create_game.execute_actions (a_mouse_state)
				btn_join_game.execute_actions (a_mouse_state)
			elseif game_state.is_equal ("menu_player") then

			elseif game_state.is_equal ("menu_join") then

			end

		end

	click_on(mouse:GAME_MOUSE_BUTTON_PRESSED_STATE; x1, y1, x2, y2: INTEGER):BOOLEAN
		do
			Result := (mouse.x >= x1) and (mouse.x < x2) and (mouse.y >= y1) and (mouse.y < y2)
		end

	rotate_spare_card(a_steps: INTEGER)
			-- Méthode qui se déclenche lorsq'on clique sur
			-- btn_rotate_left ou btn_rotate_right.
		require
			a_steps.abs <= 4
		do
			spare_card.rotate (a_steps)
			spare_card.play_rotate_sfx
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

