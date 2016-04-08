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
			current_player_index := 1
			create item_to_find.make (image_factory.items[players[current_player_index].items_to_find.first], Item_to_find_x, Item_to_find_y)
			create {LINKED_LIST[SPRITE]} on_screen_sprites.make
			create spare_card.make(3, image_factory, 801, 144, 1)
			create spare_card_button.make (create {GAME_SURFACE}.make (84, 84), 801, 144)
			create board.make (image_factory)
			create background.make(image_factory.backgrounds[1], 0, 0)
			create btn_ok.make (image_factory.buttons[11], 925, 200)
			create btn_rotate_left.make (image_factory.buttons[1], 745, 159)
			create btn_rotate_right.make (image_factory.buttons[2], 904, 159)
			create {ARRAYED_LIST[SPRITE]} on_screen_sprites.make(100)
			create text_player.make (image_factory.text[current_player_index], Text_player_x, Text_player_y)


			on_screen_sprites.extend (background)
			on_screen_sprites.extend (btn_rotate_left)
			on_screen_sprites.extend (btn_rotate_right)
			on_screen_sprites.extend (item_to_find)
			across board.board_paths as l_rows loop
				across l_rows.item as l_cards loop
					on_screen_sprites.extend (l_cards.item)
				end
			end
			on_screen_sprites.extend (spare_card)
			across players as la_players loop
				on_screen_sprites.extend (la_players.item)
			end
			on_screen_sprites.extend (text_player)

			board.on_click_actions.extend(agent board_click_action)
			spare_card_button.on_click_actions.extend(agent spare_card_click_action(?))
			btn_rotate_left.on_click_actions.extend(agent rotate_spare_card (-1))
			btn_rotate_right.on_click_actions.extend(agent rotate_spare_card (1))
			btn_ok.on_click_actions.extend (agent confirm_finished)

			buttons.extend(btn_rotate_left)
			buttons.extend(btn_rotate_right)
			buttons.extend(spare_card_button)
			buttons.extend (board)

			number_of_players := players.count
			has_to_place_spare_card := True
		end

feature -- Implementation

	board: BOARD
		-- Le board principal contenant les {PATH_CARD}

	spare_card: PATH_CARD
		-- la carte que le joueur doit placer
	spare_card_button: BUTTON
		-- pour détecter si le joueur clique sur la `spare_card' et assigner une action

	has_finished, has_to_place_spare_card, has_to_move: BOOLEAN
		-- Pour contrôler les étapes que doit suivre le `current_player'

	btn_ok: BUTTON
		-- Le joueur confirme la fin de son tour après qu'il ait placé la `spare_card' et bougé son personnage

	btn_rotate_left, btn_rotate_right: BUTTON
		-- Les boutons qui tourne la `spare_card'

	is_dragging: BOOLEAN
		-- True si le joueur déplace la `spare_card'

	-- current_player: PLAYER
		-- Pointe vers le {PLAYER} dans `players' dont c'est le tour à jouer.

	players: LIST[PLAYER]
		-- La liste de tous les {PLAYER} actifs

	current_player_index: INTEGER
		-- Index vers le {PLAYER} dans `players' dont c'est le tour à jouer.

	number_of_players: INTEGER

	item_to_find, text_player: SPRITE

	rotate_spare_card(a_steps: INTEGER)
			-- Méthode qui se déclenche lorsqu'on clique sur `btn_rotate_left' ou `btn_rotate_right'.
		require
			a_steps.abs <= 4
		do
			if has_to_place_spare_card then
				spare_card.rotate (a_steps)
				spare_card.play_rotate_sfx
			end
		end

	on_mouse_move(a_mouse_state: GAME_MOUSE_MOTION_STATE)
			-- Routine de mise à jour du drag and drop
		do
			if is_dragging then
				spare_card.x := a_mouse_state.x - spare_card.x_offset
				spare_card.y := a_mouse_state.y - spare_card.y_offset
			end
		end

	is_drop_zone(a_x, a_y, a_x2, a_y2: INTEGER; a_mouse_state:GAME_MOUSE_BUTTON_RELEASED_STATE):BOOLEAN
			-- Vérifie que la {SPARE_PATH_CARD} est au dessus d'une zone dropable lors du mouse release selon les coordonnées
		do
			if (a_mouse_state.x >= a_x) and (a_mouse_state.x < a_x2) and (a_mouse_state.y >= a_y) and (a_mouse_state.y < a_y2) then
				Result := True
			end
		end

	rotate(a_index: NATURAL_8; a_is_row, a_is_from_top_or_right: BOOLEAN)
			-- Appelle la fonction de rotation du {BOARD} selon `a_index'
			-- Si `a_is_row' est vrai, on bouge une rangée sinon une colonne
		local
			l_next_spare_card: PATH_CARD
		do
			if a_is_row then
				l_next_spare_card := board.get_next_spare_card_row (a_index, a_is_from_top_or_right)
				board.rotate_row (a_index, spare_card, a_is_from_top_or_right)
			else
				l_next_spare_card := board.get_next_spare_card_column (a_index, a_is_from_top_or_right)
				board.rotate_column (a_index, spare_card, a_is_from_top_or_right)
			end
			spare_card := l_next_spare_card
			has_to_move := True
			has_to_place_spare_card := False
		end

	on_mouse_released(a_mouse_state:GAME_MOUSE_BUTTON_RELEASED_STATE)
			-- Méthode appelée lorsque le joueur relâche un bouton de la souris.
		do
			if is_dragging then
				if is_drop_zone(140, 18, 224, 56, a_mouse_state) then
					rotate(2, False, True)
				elseif is_drop_zone(308, 18, 392, 56, a_mouse_state) then
					rotate(4, False, True)
				elseif is_drop_zone(476, 18, 560, 56, a_mouse_state) then
					rotate(6, False, True)
				elseif is_drop_zone(18, 140, 56, 224, a_mouse_state) then
					rotate(2, True, False)
				elseif is_drop_zone(18, 308, 56, 392, a_mouse_state) then
					rotate(4, True, False)
				elseif is_drop_zone(18, 476, 56, 560, a_mouse_state) then
					rotate(6, True, False)
				elseif is_drop_zone(644, 140, 728, 224, a_mouse_state) then
					rotate(2, True, True)
				elseif is_drop_zone(644, 308, 728, 392, a_mouse_state) then
					rotate(4, True, True)
				elseif is_drop_zone(644, 476, 728, 560, a_mouse_state) then
					rotate(6, True, True)
				elseif is_drop_zone(140, 644, 224, 728, a_mouse_state) then
					rotate(2, False, False)
				elseif is_drop_zone(308, 644, 392, 728, a_mouse_state) then
					rotate(4, False, False)
				elseif is_drop_zone(476, 644, 560, 728, a_mouse_state) then
					rotate(6, False, False)
				end
				is_dragging := False
			end
		end

	spare_card_click_action (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Initialise le drag et calcul le offset par rapport aux coordonnées de `a_mouse_state'
		do
			if has_to_place_spare_card then
				is_dragging := True
				spare_card.set_x_offset(a_mouse_state.x - spare_card.x)
				spare_card.set_y_offset(a_mouse_state.y - spare_card.y)
			end
		end

	board_click_action (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Action à faire si l'usager clique sur le {BOARD}
		local
			l_player_x_to_coordinate, l_player_y_to_coordinate: INTEGER
			l_mouse_x_to_coordinate, l_mouse_y_to_coordinate: INTEGER
			-- Ces coordonnées donnent un chiffre de 1 à 7 pour servir d'index pour accéder au vecteur de {PATH_CARD} du {BOARD}
		do
			if has_to_move then
				l_player_x_to_coordinate := ((players[current_player_index].x - 56) // 84) + 1
				l_player_y_to_coordinate := ((players[current_player_index].y - 56) // 84) + 1
				l_mouse_x_to_coordinate := ((a_mouse_state.x - 56) // 84) + 1
				l_mouse_y_to_coordinate := ((a_mouse_state.y - 56) // 84) + 1
				if players[current_player_index].path.is_empty then
					if not ((l_player_x_to_coordinate = l_mouse_x_to_coordinate) and (l_player_y_to_coordinate = l_mouse_y_to_coordinate)) then
						players[current_player_index].path := board.pathfind_to(l_player_x_to_coordinate, l_player_y_to_coordinate, l_mouse_x_to_coordinate, l_mouse_y_to_coordinate)
					end
				end
			end
		end

	confirm_finished
			-- Confirme que le joueur a fini son tour
		do
			has_finished := True
			print("has finished")
		end


feature
	update(game_window:GAME_WINDOW_SURFACED)
		do
			board.adjust_paths(32)
			if not is_dragging then
				spare_card.approach_point (801, 144, 64)
			end
			if players[current_player_index].path.is_empty then
				if has_finished then
					has_finished := False
					-- Vérifier si le joueur a trouvé l'item... À FAIRE!!!
						players[current_player_index].item_found_number := players[current_player_index].item_found_number + 1
					current_player_index := (current_player_index + 1) \\ 4
					has_to_place_spare_card := True
					item_to_find.current_surface := (image_factory.items[players[current_player_index].items_to_find.first])
					text_player.current_surface := (image_factory.text[current_player_index])
				end
			else
            	players[current_player_index].follow_path
            end

			across on_screen_sprites as l_sprites loop
				l_sprites.item.draw_self (game_window.surface)
            end
            if has_to_move then
            	btn_ok.draw_self (game_window.surface)
            end

		end

feature {NONE} -- Constants

	Item_to_find_x: INTEGER = 801
	Item_to_find_y: INTEGER = 327
	Text_player_x: INTEGER = 795
	Text_player_y: INTEGER = 35

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
