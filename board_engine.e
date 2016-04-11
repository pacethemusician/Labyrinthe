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
			-- Initialisation de `Current'
		do
			make_menu (a_image_factory)
			players := a_players
			current_player_index := 1
			create sound_fx_rotate.make ("Audio/rotate.wav")
			create item_to_find.make (image_factory.items[players[current_player_index].items_to_find.first], 801, 327)
			create {LINKED_LIST[SPRITE]} on_screen_sprites.make
			create spare_card.make(3, image_factory, 801, 144, 1)
			-- create spare_card_button.make (create {GAME_SURFACE}.make (84, 84), 801, 144)
			create board.make (image_factory)
			-- create no_drop.make (image_factory.buttons[12], -130, -130)
			create sound_fx_error.make ("Audio/sfx_error.wav")
			create sound_fx_ok.make ("Audio/sfx_ok.wav")
			create sound_fx_slide.make ("Audio/sfx_slide.wav")
			create background.make(image_factory.backgrounds[1], 0, 0)
			create btn_ok.make (image_factory.buttons[11], 945, 245)
			create btn_rotate_left.make (image_factory.buttons[1], 745, 159)
			create btn_rotate_right.make (image_factory.buttons[2], 904, 159)
			create {ARRAYED_LIST[SPRITE]} on_screen_sprites.make(100)
			create text_player.make (image_factory.text[current_player_index], 795, 35)
			create circle_btn_ok.make (image_factory.backgrounds[3], 72, 1, 922, 222)
			create circle_player.make (image_factory.backgrounds[3], 72, 1, players[current_player_index].x - 23, players[current_player_index].y)

			on_screen_sprites.extend (background)
			on_screen_sprites.extend (btn_rotate_left)
			on_screen_sprites.extend (btn_rotate_right)
			on_screen_sprites.extend (item_to_find)
			across board.board_paths as la_rows loop
				across la_rows.item as la_cards loop
					on_screen_sprites.extend (la_cards.item)
					if attached {BUTTON} la_cards.item as la_button then
						buttons.extend (la_button)
					end
				end
			end

			on_screen_sprites.extend (text_player)
--			on_screen_sprites.extend (no_drop)
			on_screen_sprites.extend (spare_card)

			board.on_click_actions.extend(agent board_click_action)
			spare_card.on_click_actions.extend(agent spare_card_click_action(?))
			btn_rotate_left.on_click_actions.extend(agent rotate_spare_card (-1))
			btn_rotate_right.on_click_actions.extend(agent rotate_spare_card (1))
			btn_ok.on_click_actions.extend (agent confirm_finished)

			buttons.extend(btn_rotate_left)
			buttons.extend(btn_rotate_right)
			buttons.extend(spare_card)
			buttons.extend (board)
			buttons.extend (btn_ok)

			number_of_players := players.count
			has_to_place_spare_card := True
		end

feature -- Implementation

	board: BOARD
			-- Le board principal contenant les {PATH_CARD}

	circle_btn_ok: ANIMATED_SPRITE
			-- Repère visuel pour `btn_ok'
	circle_player: ANIMATED_SPRITE
			-- Repère visuel pour le `players[current_player_index]'

	sound_fx_rotate: SOUND_FX
			-- Le son joué lorsque le {PLAYER} tourne la `spare_card'
	sound_fx_ok: SOUND_FX
			-- Le son joué lorsque le {PLAYER} click sur `btn_ok'
	sound_fx_error: SOUND_FX
			-- Le son joué lorsque le {PLAYER} essaie de droper la `spare_card' sur le `no_drop'
	sound_fx_slide: SOUND_FX
			-- Le son joué lorsque le {PLAYER} drop la `spare_card' avec succès
	-- no_drop: SPRITE
			-- Le jeu ne peut pas y droper la `spare_card'

	spare_card: SPARE_PATH_CARD
			-- la carte que le joueur doit placer
	-- spare_card_button: BUTTON
			-- pour détecter si le joueur clique sur la `spare_card' et assigner une action

	has_finished, has_to_place_spare_card, has_to_move, is_setting_next_player: BOOLEAN
			-- Pour contrôler les étapes que doit suivre le `current_player'

	btn_ok: BUTTON
			-- Le joueur confirme la fin de son tour après qu'il ait placé la `spare_card' et bougé son personnage

	btn_rotate_left, btn_rotate_right: BUTTON
			-- Les boutons qui tourne la `spare_card'

	is_dragging: BOOLEAN
			-- True si le joueur déplace la `spare_card'

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
				sound_fx_rotate.play
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

	is_drop_zone(a_x, a_y: INTEGER; a_mouse_state:GAME_MOUSE_BUTTON_RELEASED_STATE):BOOLEAN
			-- Vérifie que la {SPARE_PATH_CARD} est au dessus d'une zone dropable lors du mouse release selon les coordonnées
		do
			if (a_mouse_state.x >= a_x) and (a_mouse_state.x < a_x + 84) and (a_mouse_state.y >= a_y) and (a_mouse_state.y < a_y + 84) then
--				if is_drop_zone(no_drop.x, no_drop.y, a_mouse_state) then
--					sound_fx_error.play
--				end
				Result := True
--				no_drop.x := a_x
--				no_drop.y := a_y
			end
		end

	rotate(a_index: NATURAL_8; a_is_row, a_is_from_top_or_right: BOOLEAN)
			-- Appelle la fonction de rotation du {BOARD} selon `a_index'
			-- Si `a_is_row' est vrai, on bouge une rangée sinon une colonne
		local
			l_next_spare_card: SPARE_PATH_CARD
		do
			sound_fx_slide.play
			if a_is_row then
				l_next_spare_card := board.get_next_spare_card_row (a_index, a_is_from_top_or_right)
				board.rotate_row (a_index, spare_card, a_is_from_top_or_right)
			else
				l_next_spare_card := board.get_next_spare_card_column (a_index, a_is_from_top_or_right)
				board.rotate_column (a_index, spare_card, a_is_from_top_or_right)
			end
			spare_card.on_click_actions.wipe_out
			spare_card := l_next_spare_card
			on_screen_sprites.start
			on_screen_sprites.prune (spare_card)
			on_screen_sprites.extend (spare_card)
			spare_card.on_click_actions.extend (agent spare_card_click_action(?))
			has_to_move := True
			has_to_place_spare_card := False
		end

	on_mouse_released(a_mouse_state:GAME_MOUSE_BUTTON_RELEASED_STATE)
			-- Méthode appelée lorsque le joueur relâche un bouton de la souris.
		local
			l_index: NATURAL_8
		do
			if is_dragging then
				if is_drop_zone(140, -28, a_mouse_state) then
					rotate(2, False, True)
				elseif is_drop_zone(308, -28, a_mouse_state) then
					rotate(4, False, True)
				elseif is_drop_zone(476, -28, a_mouse_state) then
					rotate(6, False, True)
				elseif is_drop_zone(-28, 140, a_mouse_state) then
					rotate(2, True, False)
				elseif is_drop_zone(-28, 308, a_mouse_state) then
					rotate(4, True, False)
				elseif is_drop_zone(-28, 476, a_mouse_state) then
					rotate(6, True, False)
				elseif is_drop_zone(644, 140, a_mouse_state) then
					rotate(2, True, True)
				elseif is_drop_zone(644, 308, a_mouse_state) then
					rotate(4, True, True)
				elseif is_drop_zone(644, 476, a_mouse_state) then
					rotate(6, True, True)
				elseif is_drop_zone(140, 644, a_mouse_state) then
					rotate(2, False, False)
				elseif is_drop_zone(308, 644, a_mouse_state) then
					rotate(4, False, False)
				elseif is_drop_zone(476, 644, a_mouse_state) then
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
			if has_to_move then
				has_finished := True
				sound_fx_ok.play
			end
		end


feature
	update(a_game_window:GAME_WINDOW_SURFACED)
			-- Fonction s'exécutant à chaque frame. On affiche chaque sprite sur `a_game_window'
		do
			board.adjust_paths(3)
			if not is_dragging then
				spare_card.approach_point (801, 144, 64)
			end
			if players[current_player_index].path.is_empty then
				if has_finished then
					has_finished := False

					-- Vérifier si le joueur a trouvé l'item... À FAIRE!!!

					players[current_player_index].item_found_number := players[current_player_index].item_found_number + 1
					current_player_index := (current_player_index \\ number_of_players) + 1
					has_to_move := False
					has_to_place_spare_card := True
					item_to_find.current_surface := (image_factory.items[players[current_player_index].items_to_find.first])
					text_player.current_surface := (image_factory.text[current_player_index])
					circle_player.x := players[current_player_index].x - 23
					circle_player.y := players[current_player_index].y
				end
			else
            	players[current_player_index].follow_path
            end

			across on_screen_sprites as l_sprites loop
				l_sprites.item.draw_self (a_game_window.surface)
            end
            if has_to_move then
            	btn_ok.draw_self (a_game_window.surface)
            	circle_btn_ok.draw_self (a_game_window.surface)
            end
			circle_player.draw_self (a_game_window.surface)
            across players as l_sprites loop
				l_sprites.item.draw_self (a_game_window.surface)
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
