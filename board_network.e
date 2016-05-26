note
	description: "Classe abstraite pour les fonctions communes aux {BOARD_ENGINE_CLIENT} et {BOARD_ENGINE_SERVER} ."
	author: "Pascal Belisle"
	date: "Session Hiver 2016"
	revision: "1.0"

deferred class
	BOARD_NETWORK

inherit
	BOARD_ENGINE
		redefine
			on_mouse_move, confirm_finished
		end

feature -- Access

	network_has_finished: BOOLEAN
			-- True si le joueur réseau appuie sur le `btn_ok' avant que le serveur n'ait fini l'animation

	is_my_turn: BOOLEAN
			-- True si c'est au tour de `Current' à jouer
		do
			Result := not attached {PLAYER_NETWORK} players[current_player_index]
		end

	on_mouse_move (a_mouse_state: GAME_MOUSE_MOTION_STATE)
			-- Routine de mise à jour du drag and drop
		do
			if is_my_turn then
				Precursor(a_mouse_state)
			end
		end

	confirm_finished
			-- <Precursor>
		do
			if has_to_move and players[current_player_index].path.is_empty then
				Precursor
			else
				network_has_finished := True
			end
		end

	on_mouse_released_network (a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE)
			-- Méthode appelée lorsque le joueur relâche un bouton de la souris.
		do
			if players[current_player_index].is_dragging then
				if is_drop_zone (140, -28, a_mouse_state) then
					rotate (2, False, True)
				elseif is_drop_zone (308, -28, a_mouse_state) then
					rotate (4, False, True)
				elseif is_drop_zone (476, -28, a_mouse_state) then
					rotate (6, False, True)
				elseif is_drop_zone (-28, 140, a_mouse_state) then
					rotate (2, True, False)
				elseif is_drop_zone (-28, 308, a_mouse_state) then
					rotate (4, True, False)
				elseif is_drop_zone (-28, 476, a_mouse_state) then
					rotate (6, True, False)
				elseif is_drop_zone (644, 140, a_mouse_state) then
					rotate (2, True, True)
				elseif is_drop_zone (644, 308, a_mouse_state) then
					rotate (4, True, True)
				elseif is_drop_zone (644, 476, a_mouse_state) then
					rotate (6, True, True)
				elseif is_drop_zone (140, 644, a_mouse_state) then
					rotate (2, False, False)
				elseif is_drop_zone (308, 644, a_mouse_state) then
					rotate (4, False, False)
				elseif is_drop_zone (476, 644, a_mouse_state) then
					rotate (6, False, False)
				end
				players[current_player_index].is_dragging := False
			end
		end

	check_button_network(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Déclanche l'action des boutons d'après le `a_mouse_state' reçu via network
		do
			across buttons as la_buttons loop
				la_buttons.item.execute_actions (a_mouse_state)
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
