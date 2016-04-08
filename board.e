note
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

	make (a_image_factory: IMAGE_FACTORY)
			-- Initialisation de `current'. Utilise `a_image_factory' comme `image_factory'.
		do
			make_button(create {GAME_SURFACE} .make (1, 1), 56, 56)
			image_factory := a_image_factory
			init_board_paths
		end

feature {BOARD_ENGINE} -- Implementation

	image_factory: IMAGE_FACTORY
			-- Contient les images de `Current'

	board_paths: ARRAYED_LIST [ARRAYED_LIST [PATH_CARD]]
			-- Liste des {PATH_CARD} contenues dans `Current'.

	init_board_paths
			-- Initialise `board_paths' en le remplissant de {PATH_CARD}.
		local
			l_type_amount: ARRAYED_LIST [INTEGER]
			l_rng: GAME_RANDOM
			l_random_type: INTEGER
			l_random_rotation: INTEGER
			l_sticky_cards: ARRAYED_LIST [PATH_CARD]
			l_sticky_cards_index: INTEGER
			l_i, l_j: INTEGER
		do
			l_sticky_cards := init_sticky_cards
			l_sticky_cards_index := 1
			create l_type_amount.make (3)
			l_type_amount.extend (16)
				-- Le nombre de PATH_CARD de type 1.
			l_type_amount.extend (11)
				-- Le nombre de PATH_CARD de type 2.
			l_type_amount.extend (6)
				-- Le nombre de PATH_CARD de type 3.
				-- Le total des 3 types doit valoir 33 ou plus.
			create l_rng
			create board_paths.make (7)
			from
				l_i := 1
			until
				l_i > 7
			loop
				board_paths.extend (create {ARRAYED_LIST [PATH_CARD]}.make (7))
				from
					l_j := 1
				until
					l_j > 7
				loop
					if (l_i \\ 2) = 0 or (l_j \\ 2) = 0 then
						l_rng.generate_new_random
						l_random_rotation := l_rng.last_random_integer_between (1, 4)
						l_rng.generate_new_random
						from
							l_random_type := l_rng.last_random_integer_between (1, 3)
						until
							l_type_amount [l_random_type] > 0
						loop
							l_random_type := (l_random_type \\ 3) + 1
						end
						l_type_amount [l_random_type] := l_type_amount [l_random_type] - 1
						board_paths [l_i].extend (create {PATH_CARD}.make (l_random_type, image_factory, ((l_j - 1) * 84) + 56, ((l_i - 1) * 84) + 56, l_random_rotation))
					else
						board_paths [l_i].extend (l_sticky_cards [l_sticky_cards_index])
						l_sticky_cards [l_sticky_cards_index].x := l_sticky_cards [l_sticky_cards_index].x + 56
						l_sticky_cards [l_sticky_cards_index].y := l_sticky_cards [l_sticky_cards_index].y + 56
						l_sticky_cards_index := l_sticky_cards_index + 1
					end
					l_j := l_j + 1
				end
				l_i := l_i + 1
			end
			distribute_items(image_factory.items)
		end

	distribute_items (a_items: LIST [GAME_SURFACE])
			-- Change le `item_index' des {PATH_CARD} contenues dans `board_paths'.
		local
			l_rng: GAME_RANDOM
			l_index_x: INTEGER
			l_index_y: INTEGER
			l_item_index: INTEGER
			l_free_position_found: BOOLEAN
			l_remaining_cards: INTEGER
		do
			create l_rng
			from
				l_item_index := a_items.count
			until
				l_item_index <= 0
			loop
				l_rng.generate_new_random
				l_index_x := l_rng.last_random_integer_between (1, board_paths.count)
				l_rng.generate_new_random
				l_index_y := l_rng.last_random_integer_between (1, board_paths[l_index_x].count)
				from
					l_free_position_found := (board_paths[l_index_x].i_th (l_index_y).item_index = 0)
					l_remaining_cards := (board_paths.count * board_paths[1].count) - (l_item_index - a_items.count)
				until
					l_free_position_found = true
				loop
					l_index_x := (l_index_x \\ board_paths.count) + 1
					if l_index_x = 1 then
						l_index_y := (l_index_y \\ board_paths[l_index_x].count) + 1
					end
					l_free_position_found := (board_paths[l_index_x].i_th (l_index_y).item_index = 0)
					l_remaining_cards := l_remaining_cards - 1
				variant
					enough_cards: l_remaining_cards
				end
				board_paths[l_index_x].i_th (l_index_y).item_index := l_item_index
				l_item_index := l_item_index - 1
			end
		end

	init_sticky_cards: ARRAYED_LIST [PATH_CARD]
			-- Retourne la liste des {PATH_CARD} qui ne changent pas entre les parties.
		do
			create Result.make (16)
			Result.extend (create {PATH_CARD}.make (1, image_factory, 0, 0, 4))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 168, 0, 2))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 336, 0, 3))
			Result.extend (create {PATH_CARD}.make (1, image_factory, 504, 0, 1))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 0, 168, 1))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 168, 168, 3))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 336, 168, 2))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 504, 168, 4))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 0, 336, 4))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 168, 336, 2))
			Result.extend (create {PATH_CARD}.make (2, image_factory, 336, 336, 4))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 504, 336, 2))
			Result.extend (create {PATH_CARD}.make (1, image_factory, 0, 504, 3))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 168, 504, 3))
			Result.extend (create {PATH_CARD}.make (3, image_factory, 336, 504, 1))
			Result.extend (create {PATH_CARD}.make (1, image_factory, 504, 504, 2))
		end

	get_next_spare_card_column(a_column_id:NATURAL_8; a_add_on_top:BOOLEAN): PATH_CARD
			-- Retourne la {PATH_CARD} qui sera éjectée du board si la
			-- méthode rotate_column est lancée.
		require
			valid_index: a_column_id <= board_paths.last.count and a_column_id <= board_paths[1].count
		do
			if a_add_on_top then
				result := (board_paths.last) [a_column_id]
			else
				result := (board_paths [1]) [a_column_id]
			end
		end

	get_next_spare_card_row (a_row_id: NATURAL_8; a_add_on_right: BOOLEAN): PATH_CARD
			-- Retourne la {PATH_CARD} qui sera éjectée du board si la
			-- méthode rotate_row est lancée.
		require
			valid_index: a_row_id <= board_paths.count
		do
			if a_add_on_right then
				result := (board_paths [a_row_id]) [1]
			else
				result := board_paths [a_row_id].last
			end
		end

	rotate_column(a_column_id:NATURAL_8; a_path_card: PATH_CARD; a_add_on_top:BOOLEAN)
			-- Insert `a_path_card' dans la colone `a_column_id'. `a_path_card' est
			-- inséré par le haut si `a_add_on_top' est vrai, sinon par le bas.
		local
			l_i: INTEGER
		do
			if a_add_on_top then
				from l_i := 1 until l_i > 6 loop
					(board_paths [l_i]) [a_column_id] := (board_paths [l_i + 1]) [a_column_id]
					l_i := l_i + 1
				end
				(board_paths [7]) [a_column_id] := a_path_card
			else
				from l_i := 7 until l_i < 2 loop
					(board_paths [l_i]) [a_column_id] := (board_paths [l_i - 1]) [a_column_id]
					l_i := l_i - 1
				end
				(board_paths [1]) [a_column_id] := a_path_card
			end
		end

	rotate_row (a_row_id: NATURAL_8; a_path_card: PATH_CARD; a_add_on_right: BOOLEAN)
			-- Insert `a_path_card' dans la rangée `a_row_id'. `a_path_card' est
			-- inséré par la droite si `a_add_on_right' est vrai, sinon par la gauche.
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
			-- Approche les {PATHS_CARD} de `current' vers leur
			-- position respective de `a_speed' pixels.
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
			-- Retrourne 'true' si la {PATH_CARD} à l'index `a_x', `a_y' a
			-- un chemin complet vers la direction `a_direction'.
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
			pathfind_to_recursive (a_x2, a_y2, a_x1, a_y1, result, l_visited_paths)
		end

feature
	execute_actions (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Execute les routines de `on_click_actions' si la souris est au dessus de `current'.
		do
			if (a_mouse_state.x >= x) and (a_mouse_state.x < (x + 588)) and (a_mouse_state.y >= y) and (a_mouse_state.y < (y + 588)) then
				across
					on_click_actions as l_actions
				loop
					l_actions.item.call(a_mouse_state)
				end
			end
		end

feature {NONE} -- Implementation

	pathfind_to_recursive (a_x1, a_y1, a_x2, a_y2: INTEGER; a_result, a_visited_paths: LINKED_LIST [PATH_CARD])
			-- Partie récursive de pathfind_to.
			-- Ne devrait être utilisée que par pathfind_to.
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

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
