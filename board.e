﻿note
	description: "Plateau de jeu contenant les {PATH_CARD} du labyrinthe."
	author: "Pascal Belisle et Charles Lemay"
	date: "Session Hiver 2016"
	version: "1.0"

class
	BOARD

inherit

	BUTTON
		rename
			make as make_button
		redefine
			execute_actions
		end

create
	make

feature {NONE} -- Initialisation

	make (a_image_factory: IMAGE_FACTORY; a_players: LIST[PLAYER])
			-- Initialisation de `Current'
			-- `a_image_factory' Contient toutes les images {GAME_SURFACE} du jeu. Assigné à `image_factory'
			-- `a_players' La liste des joueurs.
		do
			make_button (create {GAME_SURFACE}.make (1, 1), 56, 56)
			image_factory := a_image_factory
			init_board_paths(a_players)
		end

feature -- Implementation

	image_factory: IMAGE_FACTORY
			-- Contient les images de `Current'

	board_paths: ARRAYED_LIST [ARRAYED_LIST [PATH_CARD]] assign set_board_paths
			-- Liste des {PATH_CARD} contenues dans `Current'.

	set_board_paths (a_paths: ARRAYED_LIST [ARRAYED_LIST [PATH_CARD]])
			-- Re-initialise le `board_paths' avec les données reçues par réseau
		local
			i, j: INTEGER
		do
			board_paths.wipe_out
			from
				i := 1
			until
				i > 7
			loop
				board_paths.extend (create {ARRAYED_LIST [PATH_CARD]}.make (7))
				from
					j := 1
				until
					j > 7
				loop
					board_paths.last.extend (create {SPARE_PATH_CARD}.make (a_paths[i].at (j).type,
																		    image_factory,
																		    a_paths[i].at (j).x,
																		    a_paths[i].at (j).y,
																		    a_paths[i].at (j).index,
																		    a_paths[i].at (j).item_index ))
					j := j + 1
				end
				i := i + 1
			end
		end

	set_starting_point(a_players: LIST[PLAYER])
			-- Met en place les points de départ de chaque [PLAYER] contenu dans `a_players'
		local
			i: INTEGER
			l_item_index: INTEGER
		do
			i := 1
			across a_players as la_players loop
				l_item_index := la_players.item.sprite_index + 24
				inspect i
					when 1 then
						board_paths [1].i_th (1).item_index := l_item_index
					when 2 then
						board_paths [1].i_th (7).item_index := l_item_index
					when 3 then
						board_paths [7].i_th (1).item_index := l_item_index
					else
						board_paths [7].i_th (7).item_index := l_item_index
				end
				i := i + 1
			end
		end

	init_board_paths(a_players: LIST[PLAYER])
			-- Initialise `board_paths' en le remplissant de {PATH_CARD}.
			-- La fonction place également les items
			-- `a_players' La liste des joueurs.
		local
			l_type_amount: ARRAYED_LIST [INTEGER]
			l_rng: GAME_RANDOM
			l_sticky_cards: ARRAYED_LIST [PATH_CARD]
			l_row_index: INTEGER
		do
			l_sticky_cards := init_sticky_cards
			create l_type_amount.make_from_array (<<type_one_amount, type_two_amount, type_three_amount>>)
			create l_rng
			create board_paths.make (7)
			from
				l_row_index := 1
			until
				l_row_index > 7
			loop
				board_paths.extend (create {ARRAYED_LIST [PATH_CARD]}.make (7))
				init_row (l_row_index, l_sticky_cards, l_type_amount, l_rng)
				l_row_index := l_row_index + 1
			end
			set_starting_point(a_players)
			distribute_items (image_factory.items, l_rng)
		end

	get_next_spare_card_column (a_column_id: INTEGER; a_add_on_top: BOOLEAN): SPARE_PATH_CARD
			-- Retourne la {PATH_CARD} qui sera éjectée du board si la méthode `rotate_column' est lancée.
			-- `a_column_id' -> L'index de la colonne contenant la {SPARE_PATH_CARD} qui sera éjectée.
			-- `a_add_on_top' -> True si le joueur a inséré la {SPARE_PATH_CARD} par en haut, donc on sort celle du dessous.
		require
			column_id_even: (a_column_id \\ 2) = 0
			valid_index: a_column_id <= board_paths.last.count and a_column_id <= board_paths [1].count
		local
			l_result: PATH_CARD
		do
			if a_add_on_top then
				l_result := (board_paths.last) [a_column_id]
			else
				l_result := (board_paths [1]) [a_column_id]
			end
			check attached {SPARE_PATH_CARD} l_result as la_result then
				Result := la_result
			end
		end

	get_next_spare_card_row (a_row_id: INTEGER; a_add_on_right: BOOLEAN): SPARE_PATH_CARD
			-- Retourne la {PATH_CARD} qui sera éjectée du board si la méthode `rotate_row' est lancée.
			-- `a_row_id' -> L'index de la rangée contenant la {SPARE_PATH_CARD} qui sera éjectée.
			-- `a_add_on_right' -> True si le joueur a inséré la {SPARE_PATH_CARD} par la droite, donc on sort celle de gauche.
		require
			row_id_even: (a_row_id \\ 2) = 0
			valid_index: a_row_id <= board_paths.count
		local
			l_result: PATH_CARD
		do
			if a_add_on_right then
				l_result := (board_paths [a_row_id]) [1]
			else
				l_result := board_paths [a_row_id].last
			end
			check attached {SPARE_PATH_CARD} l_result as la_result then
				Result := la_result
			end
		end

	rotate_column (a_column_id: INTEGER; a_path_card: PATH_CARD; a_add_on_top: BOOLEAN)
			-- Insert `a_path_card' dans la colonne `a_column_id'.
			-- `a_add_on_top' -> True si le joueur a inséré la {SPARE_PATH_CARD} par en haut.
		require
			column_id_even: (a_column_id \\ 2) = 0
		local
			l_i: INTEGER
		do
			if a_add_on_top then
				from l_i := 7 until l_i < 2 loop
					(board_paths [l_i]) [a_column_id] := (board_paths [l_i - 1]) [a_column_id]
					l_i := l_i - 1
				end
				(board_paths [1]) [a_column_id] := a_path_card
			else
				from l_i := 1 until l_i > 6 loop
					(board_paths [l_i]) [a_column_id] := (board_paths [l_i + 1]) [a_column_id]
					l_i := l_i + 1
				end
				(board_paths [7]) [a_column_id] := a_path_card
			end
		end

	rotate_row (a_row_id: INTEGER; a_path_card: PATH_CARD; a_add_on_right: BOOLEAN)
			-- Insert `a_path_card' dans la rangée `a_row_id'.
			-- `a_add_on_right' -> True si le joueur a inséré la {SPARE_PATH_CARD} par la droite.
		require
			row_id_even: (a_row_id \\ 2) = 0
		local
			l_i: INTEGER
		do
			if a_add_on_right then
					-- Rotation de droite à gauche.
				from l_i := 1 until l_i > 6 loop
					(board_paths [a_row_id]) [l_i] := (board_paths [a_row_id]) [l_i + 1]
					l_i := l_i + 1
				end
				(board_paths [a_row_id]) [7] := a_path_card
			else
					-- Rotation de gauche à droite.
				from l_i := 7 until l_i < 2 loop
					(board_paths [a_row_id]) [l_i] := (board_paths [a_row_id]) [l_i - 1]
					l_i := l_i - 1
				end
				(board_paths [a_row_id]) [1] := a_path_card
			end
		end

	adjust_paths (a_speed: INTEGER)
			-- Déplace les {PATHS_CARD} de `Current' vers leur position respective.
			-- `a_speed' -> La vitesse. Doit être positive.
		require
			speed_over_zero: a_speed > 0
		local
			l_i, l_j: INTEGER
		do
			from l_i := 1 until l_i > board_paths.count loop
				from l_j := 1 until l_j > board_paths.count loop
					(board_paths [l_j]) [l_i].approach_point (((l_i - 1) * 84) + 56, ((l_j - 1) * 84) + 56, a_speed)
					l_j := l_j + 1
				end
				l_i := l_i + 1
			end
		end

	path_can_go_direction (a_x, a_y, a_direction: INTEGER): BOOLEAN
			-- Retourne True si la {PATH_CARD} à l'index `a_x', `a_y' a un chemin complet vers la direction `a_direction'.
		require
			x_over_zero: a_x > 0
			y_over_zero: a_y > 0
			x_below_eight: a_x <= 7
			y_below_eight: a_y <= 7
			direction_positive: a_direction >= 0
			direction_below_four: a_direction < 4
		do
			result := false
			if (board_paths [a_y]) [a_x].is_connected (a_direction) then
				if a_direction = 0 then
					if (a_y - 1 > 0) then
						if (board_paths [a_y - 1]) [a_x].is_connected (2) then
							result := true
						end
					end
				elseif a_direction = 1 then
					if (a_x + 1 <= 7) then
						if (board_paths [a_y]) [a_x + 1].is_connected (3) then
							result := true
						end
					end
				elseif a_direction = 2 then
					if (a_y + 1 <= 7) then
						if (board_paths [a_y + 1]) [a_x].is_connected (0) then
							result := true
						end
					end
				elseif (a_x - 1 > 0) then
					if (board_paths [a_y]) [a_x - 1].is_connected (1) then
						result := true
					end
				end
			end
		end

	pathfind_to (a_x1, a_y1, a_x2, a_y2: INTEGER): LINKED_LIST [PATH_CARD]
			-- Retourne une liste contenant les {PATH_CARD} à traverser pour
			-- atteindre la destination (`a_x2', `a_y2') à partir de (`a_x1', `a_y1').
			-- `a_x1', `a_y1', `a_x2' et `a_y2' sont des index de `board_paths'.
			-- si aucun chemin n'est trouvé, une liste vide est retournée.
		require
			x1_over_zero: a_x1 > 0
			y1_over_zero: a_y1 > 0
			x1_below_eight: a_x1 <= 7
			y1_below_eight: a_y1 <= 7
			x2_over_zero: a_x2 > 0
			y2_over_zero: a_y2 > 0
			x2_below_eight: a_x2 <= 7
			y2_below_eight: a_y2 <= 7
		local
			l_visited_paths: LINKED_LIST [PATH_CARD]
		do
			create l_visited_paths.make
			create result.make
			pathfind_to_recursive (a_x2, a_y2, a_x1, a_y1, Result, l_visited_paths)
		end

	execute_actions (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Execute les routines de `on_click_actions' si la souris est au dessus de `current'.
			-- `a_mouse_state' -> L'état de la souris.
		do
			if (a_mouse_state.x >= x) and (a_mouse_state.x < (x + 588)) and (a_mouse_state.y >= y) and (a_mouse_state.y < (y + 588)) then
				across
					on_click_actions as l_actions
				loop
					l_actions.item.call (a_mouse_state)
				end
			end
		end

feature {NONE} -- Implementation

	pathfind_to_recursive (a_x1, a_y1, a_x2, a_y2: INTEGER; a_result, a_visited_paths: LINKED_LIST [PATH_CARD])
			-- Partie récursive de pathfind_to.
			-- `a_x1', `a_y1', `a_x2' et `a_y2' sont des index de `board_paths'.
			-- `a_result' -> Pointe vers le `Result' de `pathfind_to'.
			-- `a_visited_paths' -> Les chemins déjà visités
			-- Ne devrait être utilisée que par `pathfind_to'.
		do
			a_visited_paths.extend ((board_paths [a_y1]) [a_x1])
			if (a_x1 = a_x2) and (a_y1 = a_y2) then
				a_result.extend ((board_paths [a_y1]) [a_x1])
			else
				if a_result.is_empty and path_can_go_direction (a_x1, a_y1, 0) then
					if not a_visited_paths.has ((board_paths [a_y1 - 1]) [a_x1]) then
						pathfind_to_recursive (a_x1, a_y1 - 1, a_x2, a_y2, a_result, a_visited_paths)
					end
				end
				if a_result.is_empty and path_can_go_direction (a_x1, a_y1, 1) then
					if not a_visited_paths.has ((board_paths [a_y1]) [a_x1 + 1]) then
						pathfind_to_recursive (a_x1 + 1, a_y1, a_x2, a_y2, a_result, a_visited_paths)
					end
				end
				if a_result.is_empty and path_can_go_direction (a_x1, a_y1, 2) then
					if not a_visited_paths.has ((board_paths [a_y1 + 1]) [a_x1]) then
						pathfind_to_recursive (a_x1, a_y1 + 1, a_x2, a_y2, a_result, a_visited_paths)
					end
				end
				if a_result.is_empty and path_can_go_direction (a_x1, a_y1, 3) then
					if not a_visited_paths.has ((board_paths [a_y1]) [a_x1 - 1]) then
						pathfind_to_recursive (a_x1 - 1, a_y1, a_x2, a_y2, a_result, a_visited_paths)
					end
				end
				if not a_result.is_empty then
					a_result.extend ((board_paths [a_y1]) [a_x1])
				end
			end
		end

	init_row (a_row_index: INTEGER; a_sticky_cards: ARRAYED_LIST [PATH_CARD]; a_type_amount: ARRAYED_LIST [INTEGER]; a_rng: GAME_RANDOM)
			-- Initialise la rangée `a_row_index' de `board_paths' en la remplissant de {PATH_CARD}.
			-- `a_sticky_cards' -> La liste des {PATH_CARD} fixes.
			-- `a_type_amount' ->
			-- `a_rng' -> Générateur de nombre aléatoire.
		require
			type_amount_valid: a_type_amount.count = 3
		local
			l_column_index: INTEGER
			l_sticky_cards_index: INTEGER
			l_random_type: INTEGER
			l_random_rotation: INTEGER
		do
			l_sticky_cards_index := ((a_row_index // 2) * 4) + 1
			from
				l_column_index := 1
			until
				l_column_index > 7
			loop
				if ((a_row_index \\ 2) = 0) or ((l_column_index \\ 2) = 0) then
					a_rng.generate_new_random
					l_random_rotation := a_rng.last_random_integer_between (1, 4)
					a_rng.generate_new_random
					from
						l_random_type := a_rng.last_random_integer_between (1, 3)
					invariant
						enough_cards: (a_type_amount [1] + a_type_amount [2] + a_type_amount [3] > 0)
					until
						a_type_amount [l_random_type] > 0
					loop
						l_random_type := (l_random_type \\ 3) + 1
					end
					a_type_amount [l_random_type] := a_type_amount [l_random_type] - 1
					board_paths [a_row_index].extend (create {SPARE_PATH_CARD}.make (l_random_type, image_factory, ((l_column_index - 1) * 84) + 56, ((a_row_index - 1) * 84) + 56, l_random_rotation, 0))
				else
					board_paths [a_row_index].extend (a_sticky_cards [l_sticky_cards_index])
					a_sticky_cards [l_sticky_cards_index].x := a_sticky_cards [l_sticky_cards_index].x + 56
					a_sticky_cards [l_sticky_cards_index].y := a_sticky_cards [l_sticky_cards_index].y + 56
					l_sticky_cards_index := l_sticky_cards_index + 1
				end
				l_column_index := l_column_index + 1
			end
		end

	distribute_items (a_items: LIST [GAME_SURFACE]; a_rng: GAME_RANDOM)
			-- Change le `item_index' des {PATH_CARD} contenues dans `board_paths'.
			-- `a_items' -> La liste des {GAME_SURFACE} des items à trouver.
			-- `a_rng' -> Générateur de nombre aléatoire.
		local
			l_index_x: INTEGER
			l_index_y: INTEGER
			l_item_index: INTEGER
			l_free_position_found: BOOLEAN
			l_remaining_cards: INTEGER
		do
			from
				l_item_index := a_items.count - 6
			until
				l_item_index <= 0
			loop
				a_rng.generate_new_random
				l_index_x := a_rng.last_random_integer_between (1, board_paths.count)
				a_rng.generate_new_random
				l_index_y := a_rng.last_random_integer_between (1, board_paths [l_index_x].count)
				from
					l_free_position_found := (board_paths [l_index_x].i_th (l_index_y).item_index = 0)
					l_remaining_cards := (board_paths.count * board_paths [1].count) - (l_item_index - a_items.count)
				until
					l_free_position_found = True
				loop
					l_index_x := (l_index_x \\ board_paths.count) + 1
					if l_index_x = 1 then
						l_index_y := (l_index_y \\ board_paths [l_index_x].count) + 1
					end
					l_free_position_found := (board_paths [l_index_x].i_th (l_index_y).item_index = 0)
					l_remaining_cards := l_remaining_cards - 1
				variant
					enough_cards: l_remaining_cards
				end
				board_paths [l_index_x].i_th (l_index_y).item_index := l_item_index
				l_item_index := l_item_index - 1
			end
		end

	init_sticky_cards: ARRAYED_LIST [PATH_CARD]
			-- Retourne la liste des {PATH_CARD} qui ne changent pas entre les parties.
		do
			create Result.make (16)
				-- Rangée 1
			Result.extend (create {PATH_CARD}.make (1, image_factory, 0, 0, 4, 0))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 168, 0, 4, 0))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 336, 0, 4, 0))
			Result.extend (create {PATH_CARD}.make (1, image_factory, 504, 0, 1, 0))
				-- Rangée 3
			Result.extend (create {PATH_CARD}.make (3, image_factory, 0, 168, 3, 0))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 168, 168, 3, 0))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 336, 168, 4, 0))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 504, 168, 1, 0))
				-- Rangée 5
			Result.extend (create {PATH_CARD}.make (3, image_factory, 0, 336, 3, 0))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 168, 336, 2, 0))
			Result.extend (create {PATH_CARD}.make (2, image_factory, 336, 336, 2, 0))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 504, 336, 1, 0))
				-- Rangée 7
			Result.extend (create {PATH_CARD}.make (1, image_factory, 0, 504, 3, 0))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 168, 504, 2, 0))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 336, 504, 2, 0))
			Result.extend (create {PATH_CARD}.make (1, image_factory, 504, 504, 2, 0))
		end

feature {NONE} -- Constantes

	type_one_amount: INTEGER = 16

	type_two_amount: INTEGER = 11

	type_three_amount: INTEGER = 6

invariant
	enough_cards: (type_one_amount + type_two_amount + type_three_amount) >= 33

note
	license: "WTFPL"
	source: "[
		Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
		Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
	]"

end
