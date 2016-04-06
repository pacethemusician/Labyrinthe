note
	description: "Classe qui contrôle le gameplay."
	author: "Pascal Belisle, Charles Lemay"
	date: "Mars 2016"
	revision: ""

class
	BOARD_ENGINE

inherit
	MENU
		rename
			make as make_menu
		end

create
	make

feature {NONE} -- Initialization

	make (a_image_factory: IMAGE_FACTORY; a_players: LIST[PLAYER])
			-- Initialisation de `current'
		do
			make_menu (a_image_factory)
			players := a_players
			current_player := players[1]
			create {LINKED_LIST[SPRITE]} on_screen_sprites.make
			create spare_card.make(3, image_factory, 801, 144, 1)
			create board.make (image_factory)
			create background.make(image_factory.backgrounds[1], 0, 0)
			create btn_rotate_left.make (image_factory.buttons[1], 745, 159)
			create btn_rotate_right.make (image_factory.buttons[2], 904, 159)
			create {ARRAYED_LIST[SPRITE]} on_screen_sprites.make(100)
			on_screen_sprites.extend (background)
			on_screen_sprites.extend (btn_rotate_left)
			on_screen_sprites.extend (btn_rotate_right)
			board.on_click_actions.extend(agent board_click_action)
			btn_rotate_left.on_click_actions.extend(agent rotate_spare_card (-1))
			btn_rotate_right.on_click_actions.extend(agent rotate_spare_card (1))
			across board.board_paths as l_rows loop
				across l_rows.item as l_cards loop
					on_screen_sprites.extend (l_cards.item)
				end
			end
			across players as la_players loop
				on_screen_sprites.extend (la_players.item)
			end
			on_screen_sprites.extend (spare_card)
			spare_card.on_click_actions.extend(agent spare_card_click_action(?))
			buttons.extend(btn_rotate_left)
			buttons.extend(btn_rotate_right)
			buttons.extend(spare_card)
			buttons.extend (board)
			is_dragging := False
		end

feature -- Implementation

	board: BOARD
		-- Le board principal avec les cartes chemin

	spare_card: SPARE_PATH_CARD
		-- la carte que le joueur doit placer

	btn_rotate_left, btn_rotate_right: BUTTON
		-- Les boutons qui tourne la `spare_card'

	is_dragging: BOOLEAN
		-- True si le joueur déplace la `spare_card'

	current_player: PLAYER
		-- Pointe vers le {PLAYER} dans `players' dont c'est le tour à jouer.

	players: LIST[PLAYER]
		-- La liste de tous les {PLAYER} actifs

	rotate_spare_card(a_steps: INTEGER)
			-- Méthode qui se déclenche lorsqu'on clique sur
			-- `btn_rotate_left' ou `btn_rotate_right'.
		require
			a_steps.abs <= 4
		do
			spare_card.rotate (a_steps)
			spare_card.play_rotate_sfx
		end

	on_mouse_move(a_mouse_state: GAME_MOUSE_MOTION_STATE)
			-- Routine de mise à jour du drag and drop
		do
			if a_mouse_state.is_left_button_pressed and is_dragging then
				spare_card.x := a_mouse_state.x - spare_card.x_offset
				spare_card.y := a_mouse_state.y - spare_card.y_offset
			end
		end

--	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state:GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks:NATURAL_8)
--			-- Méthode appelée lorsque le joueur appuie sur un bouton de la souris.
--		local
--			l_next_spare_card: PATH_CARD
--		do
--			if not is_dragging then
--				if a_mouse_state.is_right_button_pressed then
--					l_next_spare_card := board.get_next_spare_card_row (4, true)
--					board.rotate_row (4, spare_card, true)
--					spare_card := l_next_spare_card
--				end


	on_mouse_released(mouse_state:GAME_MOUSE_BUTTON_RELEASED_STATE)
			-- Méthode appelée lorsque le joueur relâche un bouton de la souris.
		do
			if is_dragging then
				-- "Vérifier si la spare_card est au-dessus d'une zone dropable"

				-- Sinon on reset:
				-- spare_card.x := 801
				-- spare_card.y := 144
				is_dragging := false
			end
		end

	spare_card_click_action (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Update la `spare_card' lors du drag, utilisant les coordonnées de `a_mouse_state'
		do
			is_dragging := True
			spare_card.set_x_offset(a_mouse_state.x - spare_card.x)
			spare_card.set_y_offset(a_mouse_state.y - spare_card.y)
		end

	board_click_action (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Action à faire si l'usager clique sur le {BOARD}
		local
			l_player_x_to_coordinate, l_player_y_to_coordinate: INTEGER
			l_mouse_x_to_coordinate, l_mouse_y_to_coordinate: INTEGER
			-- Ces coordonnées donnent un chiffre de 1 à 7 pour servir d'index pour accéder au vecteur de {PATH_CARD} du {BOARD}
		do
			l_player_x_to_coordinate := ((current_player.x - 56) // 84) + 1
			l_player_y_to_coordinate := ((current_player.y - 56) // 84) + 1
			l_mouse_x_to_coordinate := ((a_mouse_state.x - 56) // 84) + 1
			l_mouse_y_to_coordinate := ((a_mouse_state.y - 56) // 84) + 1
			if current_player.path.is_empty then
				if not ((l_player_x_to_coordinate = l_mouse_x_to_coordinate) and (l_player_y_to_coordinate = l_mouse_y_to_coordinate)) then
					current_player.path := board.pathfind_to(l_player_x_to_coordinate, l_player_y_to_coordinate, l_mouse_x_to_coordinate, l_mouse_y_to_coordinate)
				end
			end
		end

feature
	update(game_window:GAME_WINDOW_SURFACED)
		do
			board.adjust_paths(32)
			if not is_dragging then
				spare_card.approach_point (801, 144, 64)
			end

			if not current_player.path.is_empty then
            	current_player.follow_path
            end

			across on_screen_sprites as l_sprites loop
				l_sprites.item.draw_self (game_window.surface)
            end

		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
