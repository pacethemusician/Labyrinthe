note
	description: "Classe responsable du plateau de jeu."
	author: "Pascal"
	date: "22 février 2016"
	revision: "0.1"

class
	BOARD

inherit
	SPRITE
		rename
			make as make_sprite
		end

create
	make

feature {NONE} -- Initialisation

	make (a_surfaces: LIST[LIST[GAME_SURFACE]])

		do
			init_board_paths(a_surfaces)
			create board_surface.make(84 * 7, 84 * 7)
			refresh_board_surface
			make_sprite(board_surface, 56, 56)
		end

feature {GAME_ENGINE} -- Implementation

	board_paths : ARRAYED_LIST[ARRAYED_LIST[PATH_CARD]]
		-- Liste des PATH_CARDS contenuent dans `current'.

	board_surface: GAME_SURFACE
		-- Surface sur laquelle est dessinée la liste "board_paths".

	refresh_board_surface
		-- Mets à jour board_surface.
		do
			across
				board_paths as l_board
            loop
            	across
            		l_board.item as l_row
            	loop
            		if l_row.item /= void then
            			l_row.item.draw_self(board_surface)
            		end
            	end
            end
		end

	init_board_paths (a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Initialise `board_paths' en le remplissant de PATH_CARD.
		local
			type_amount: ARRAYED_LIST[INTEGER]
			l_rng: GAME_RANDOM
			random_type: INTEGER
			random_rotation: INTEGER
			sticky_cards: ARRAYED_LIST[PATH_CARD]
			sticky_cards_index: INTEGER
			i, j: INTEGER
		do
			sticky_cards := init_sticky_cards(a_surfaces)
			sticky_cards_index := 1
			create type_amount.make (3)
			type_amount.extend (16)
			type_amount.extend (11)
			type_amount.extend (6)
			create l_rng
			create board_paths.make(7)
			from
				i := 1
			until
				i > 7
			loop
				board_paths.extend (create {ARRAYED_LIST[PATH_CARD]}.make(7))
				from
					j := 1
				until
					j > 7
				loop
					if (i \\ 2) = 0 or (j \\ 2) = 0 then
						l_rng.generate_new_random
						random_rotation := l_rng.last_random_integer_between (1, 4)
						l_rng.generate_new_random
						from
							random_type := l_rng.last_random_integer_between (1, 3)
						until
							type_amount[random_type] > 0
						loop
							random_type := (random_type \\ 3) + 1
						end
						type_amount[random_type] := type_amount[random_type] - 1
						board_paths[i].extend (create {PATH_CARD}.make (random_type,
							a_surfaces[random_type], (j - 1) * 84, (i - 1) * 84, random_rotation))
					else
						board_paths[i].extend (sticky_cards[sticky_cards_index])
						sticky_cards_index := sticky_cards_index + 1
					end
					j := j + 1
				end
				i := i + 1
			end
		end

	init_sticky_cards (a_surfaces: LIST[LIST[GAME_SURFACE]]): ARRAYED_LIST[PATH_CARD]
			-- Retourne la liste des PATH_CARD qui ne changent pas entre les parties.
		local
			l_cards: ARRAYED_LIST[PATH_CARD]
		do
			create l_cards.make (16)
			l_cards.extend (create {PATH_CARD} .make (1, a_surfaces[1], 0, 0, 4))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 168, 0, 2))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 336, 0, 3))
			l_cards.extend (create {PATH_CARD} .make (1, a_surfaces[1], 504, 0, 1))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 0, 168, 1))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 168, 168, 3))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 336, 168, 2))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 504, 168, 4))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 0, 336, 4))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 168, 336, 2))
			l_cards.extend (create {PATH_CARD} .make (2, a_surfaces[2], 336, 336, 4))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 504, 336, 2))
			l_cards.extend (create {PATH_CARD} .make (1, a_surfaces[1], 0, 504, 3))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 168, 504, 3))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 336, 504, 1))
			l_cards.extend (create {PATH_CARD} .make (1, a_surfaces[1], 504, 504, 2))
			result := l_cards
		end

	rotate_column(a_column_id:NATURAL_8; a_add_on_top:BOOLEAN)
		do

		end

	rotate_row(a_row_id:NATURAL_8; a_add_on_right:BOOLEAN)
		local
			l_i: INTEGER
			l_temp_card: PATH_CARD
		do
			if a_add_on_right then
				-- Rotate from right to left
				l_temp_card := (board_paths[a_row_id])[1]
				from l_i := 1 until l_i > 6 loop
					(board_paths[a_row_id])[l_i] := (board_paths[a_row_id])[l_i + 1]
					(board_paths[a_row_id])[l_i].x := (board_paths[a_row_id])[l_i].x - 84
					l_i := l_i + 1
				end
				l_temp_card.x := l_temp_card.x + (84 * 6)
				(board_paths[a_row_id])[7] := l_temp_card
			else
				-- Rotate from left to right
				l_temp_card := (board_paths[a_row_id])[7]
				from l_i := 7 until l_i < 2 loop
					(board_paths[a_row_id])[l_i] := (board_paths[a_row_id])[l_i - 1]
					(board_paths[a_row_id])[l_i].x := (board_paths[a_row_id])[l_i].x + 84
					l_i := l_i - 1
				end
				l_temp_card.x := l_temp_card.x - (84 * 6)
				(board_paths[a_row_id])[1] := l_temp_card
			end
		end

	path_can_go_direction (a_x, a_y, a_direction: INTEGER): BOOLEAN
			-- Retrourne `true' si la PATH_CARD à l'index `a_x', `a_y' a
			-- un chemin complet vers la direction `a_direction'.
		require
			x_over_zero: a_x > 0
			y_over_zero: a_y > 0
			x_below_eight: a_x <= 7
			y_below_eight: a_y <= 7
			direction_positive: a_direction >= 0
			direction_below_four: a_direction < 4
		local
			l_result: BOOLEAN
		do
			l_result := false
			if (board_paths[a_y])[a_x].is_connected(a_direction) then
				if a_direction = 0 then
					if (a_y - 1 > 0) then
						if (board_paths[a_y - 1])[a_x].is_connected(2) then
							l_result := true
						end
					end
				elseif a_direction = 1 then
					if (a_x + 1 <= 7) then
						if (board_paths[a_y])[a_x + 1].is_connected(3) then
							l_result := true
						end
					end
				elseif a_direction = 2 then
					if (a_y + 1 <= 7) then
						if (board_paths[a_y + 1])[a_x].is_connected(0) then
							l_result := true
						end
					end
				elseif (a_x - 1 > 0) then
					if (board_paths[a_y])[a_x - 1].is_connected(1) then
						l_result := true
					end
				end
			end
			result := l_result
		end

	pathfind_to (a_x1, a_y1, a_x2, a_y2: INTEGER): LINKED_LIST[PATH_CARD]
			-- Retourne une liste contenant les PATH_CARD à traverser pour
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
			l_visited_paths: LINKED_LIST[PATH_CARD]
			l_result: LINKED_LIST[PATH_CARD]
		do
			create l_visited_paths.make
			create l_result.make
			pathfind_to_recursive (a_x2, a_y2, a_x1, a_y1, l_result, l_visited_paths)
			result := l_result
		end

feature {NONE} -- Implementation

	pathfind_to_recursive (a_x1, a_y1, a_x2, a_y2: INTEGER; a_result, a_visited_paths: LINKED_LIST[PATH_CARD])
			-- Partie récursive de pathfind_to.
			-- Ne devrait être utilisée que par pathfind_to.
		do
			a_visited_paths.extend ((board_paths[a_y1])[a_x1])
			if (a_x1 = a_x2) and (a_y1 = a_y2) then
				a_result.extend ((board_paths[a_y1])[a_x1])
			else
				if a_result.is_empty and path_can_go_direction(a_x1, a_y1, 0) then
					if not a_visited_paths.has ((board_paths[a_y1 - 1])[a_x1]) then
						pathfind_to_recursive(a_x1, a_y1 - 1, a_x2, a_y2, a_result, a_visited_paths)
					end
				end
				if a_result.is_empty and path_can_go_direction(a_x1, a_y1, 1) then
					if not a_visited_paths.has ((board_paths[a_y1])[a_x1 + 1]) then
						pathfind_to_recursive(a_x1 + 1, a_y1, a_x2, a_y2, a_result, a_visited_paths)
					end
				end
				if a_result.is_empty and path_can_go_direction(a_x1, a_y1, 2) then
					if not a_visited_paths.has ((board_paths[a_y1 + 1])[a_x1]) then
						pathfind_to_recursive(a_x1, a_y1 + 1, a_x2, a_y2, a_result, a_visited_paths)
					end
				end
				if a_result.is_empty and path_can_go_direction(a_x1, a_y1, 3) then
					if not a_visited_paths.has ((board_paths[a_y1])[a_x1 - 1]) then
						pathfind_to_recursive(a_x1 - 1, a_y1, a_x2, a_y2, a_result, a_visited_paths)
					end
				end
				if not a_result.is_empty then
					a_result.extend ((board_paths[a_y1])[a_x1])
				end
			end
		end

end
