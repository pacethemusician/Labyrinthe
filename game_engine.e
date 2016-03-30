note
	description : "Projet Labyrinthe application root class"
	author: "Pascal Belisle et Charles Lemay"
	date: "1 mars 2016"
	version: "24 mars 2016"

class
	GAME_ENGINE

inherit
	GAME_LIBRARY_SHARED
	AUDIO_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialisation

	make
		-- Créer les ressources et lance le jeu.
		-- "Gérer les erreurs!!!!!"

		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_window:GAME_WINDOW_SURFACED
		do
			create l_window_builder
			l_window_builder.set_dimension (Window_width, Window_height)
			l_window_builder.set_title ("Shameless labyrinthe clone")
			l_window := l_window_builder.generate_window

			create image_factory.make
			create {MENU_TITLE_SCREEN} current_engine.make (image_factory)

			-- Création des agents:
			game_library.quit_signal_actions.extend (agent on_quit(?))
			game_library.iteration_actions.extend (agent on_iteration(?, l_window))
			l_window.mouse_button_pressed_actions.extend (agent on_mouse_pressed(?,?,?))
			l_window.mouse_button_released_actions.extend (agent on_mouse_released(?,?,?))
			l_window.mouse_motion_actions.extend (agent on_mouse_move(?, ?, ?, ?))
			btn_rotate_left.on_click_actions.extend(agent rotate_spare_card (-1))
			btn_rotate_right.on_click_actions.extend(agent rotate_spare_card (1))

			game_library.launch

		end


feature {NONE} -- Implementation
	image_factory: IMAGE_FACTORY
		-- Contient toutes les images du projet
	current_engine:ENGINE
		-- Pointe vers l'engin en court (différents menus et jeu)

	on_iteration(a_timestamp:NATURAL_32; game_window:GAME_WINDOW_SURFACED)
			-- À faire à chaque iteration.
		do
			if attached {MENU_TITLE_SCREEN} current_engine as la_menu_title_screen then
				if not la_menu_title_screen.is_done then
					la_menu_title_screen.show(game_window)
				else
					inspect la_menu_title_screen.choice
					when 1 then
						current_engine := create {MENU_PLAYER}.make(image_factory)
					when 2 then
						current_engine := create {MENU_JOIN}.make(image_factory)
					end
				end
			elseif attached {MENU_PLAYER} current_engine as la_menu_player then
				if la_menu_player.is_done then
					la_menu_player.show (game_window)
				else
					inspect la_menu_player.choice
					when 1 then
						-- "Récupérer la liste des `JOUEUR'"
						-- "Créer le GAME_ENGINE pour démarrer la partie
					end
				end
			elseif attached {MENU_JOIN} current_engine as la_menu_join then
				la_menu_join.show(game_window)
			else
				board.adjust_paths(32)
				if not is_dragging then
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

	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state:GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks:NATURAL_8)
			-- Méthode appelée lorsque le joueur appuie sur un bouton de la souris.
		local
			l_next_spare_card: PATH_CARD
		do
			if not is_dragging then
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
							(((current_player.y - 56) // 84) + 1) = (((a_mouse_state.y - 56) // 84) + 1))
						then
							current_player.path := board.pathfind_to((((current_player.x - 56) // 84) + 1), ((current_player.y - 56) // 84) + 1,
								  									(((a_mouse_state.x - 56) // 84) + 1), ((a_mouse_state.y - 56) // 84) + 1)
						end
					end
					-- Si le joueur clique sur la carte jouable:
				elseif click_on(a_mouse_state, spare_card.x, spare_card.y, spare_card.x + 84, spare_card.y + 84) then
						is_dragging := True
						spare_card.set_x_offset(a_mouse_state.x - spare_card.x)
						spare_card.set_y_offset(a_mouse_state.y - spare_card.y)
				end
			else
				current_engine.check_btn(a_mouse_state)
				-- À faire
			end

		end

	click_on(mouse:GAME_MOUSE_BUTTON_PRESSED_STATE; x1, y1, x2, y2: INTEGER):BOOLEAN
		do
			Result := (mouse.x >= x1) and (mouse.x < x2) and (mouse.y >= y1) and (mouse.y < y2)
		end



	on_mouse_released(a_timestamp: NATURAL_32; mouse_state:GAME_MOUSE_BUTTON_RELEASED_STATE; nb_clicks:NATURAL_8)
			-- Méthode appelée lorsque le joueur relâche un bouton de la souris.
		do
			if is_dragging then
				-- "Vérifier si la spare_card est au-dessus d'une zone dropable"

				-- Sinon on reset:
				spare_card.x := 801
				spare_card.y := 144
				is_dragging := false
			end
		end

	on_mouse_move(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_MOTION_STATE; a_delta_x, a_delta_y: INTEGER_32)
			-- Routine de mise à jour du drag and drop
		do
			if attached {BOARD_ENGINE} current_engine as la_game_engine then
				la_game_engine.on_mouse_move(a_mouse_state)
			end
		end

feature {NONE} -- Constantes

	Window_width:NATURAL_16 = 1000
		-- La largeur de la fenêtre en pixels.

	Window_height:NATURAL_16 = 700
		-- La hauteur de la fenêtre en pixels.

end
