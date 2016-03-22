note
	description: "Plateau de jeu contenant les cartes du labyrinthe."
	author: "Pascal Belisle et Charles Lemay"
	date: "22 mars 2016"
	revision: "0.1"

class
	BOARD

--inherit
--	SPRITE
--		rename
--			make as make_sprite
--		end

create
	make

feature {NONE} -- Initialisation

	make (a_surfaces: LIST[LIST[GAME_SURFACE]]; a_items: LIST[GAME_SURFACE])

		do
			init_board_paths(a_surfaces, a_items)
--			create board_surface.make(84 * 7, 84 * 7)
--			refresh_board_surface
--			make_sprite(board_surface, 56, 56)
		end

feature {GAME_ENGINE} -- Implementation

	board_paths : ARRAYED_LIST[ARRAYED_LIST[PATH_CARD]]
		-- Liste des PATH_CARDS contenuent dans `current'.

--	board_surface: GAME_SURFACE
--		-- Surface sur laquelle est dessinée la liste "board_paths".

--	refresh_board_surface
--		-- Mets à jour board_surface.
--		do
--			across
--				board_paths as l_board
--            loop
--            	across
--            		l_board.item as l_row
--            	loop
--            		if l_row.item /= void then
--            			l_row.item.draw_self(board_surface)
--            		end
--            	end
--            end
--		end

	init_board_paths (a_surfaces: LIST[LIST[GAME_SURFACE]]; a_items: LIST[GAME_SURFACE])
			-- Initialise `board_paths' en le remplissant de PATH_CARD.
		local
			l_type_amount: ARRAYED_LIST[INTEGER]
			l_rng: GAME_RANDOM
			l_random_type: INTEGER
			l_random_rotation: INTEGER
			l_sticky_cards: ARRAYED_LIST[PATH_CARD]
			l_sticky_cards_index: INTEGER
			l_i, l_j: INTEGER
		do
			l_sticky_cards := init_sticky_cards(a_surfaces, a_items)
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
			create board_paths.make(7)
			from l_i := 1 until l_i > 7 loop
				board_paths.extend (create {ARRAYED_LIST[PATH_CARD]}.make(7))
				from l_j := 1 until l_j > 7 loop
					if (l_i \\ 2) = 0 or (l_j \\ 2) = 0 then
						l_rng.generate_new_random
						l_random_rotation := l_rng.last_random_integer_between (1, 4)
						l_rng.generate_new_random
						from
							l_random_type := l_rng.last_random_integer_between (1, 3)
						until
							l_type_amount[l_random_type] > 0
						loop
							l_random_type := (l_random_type \\ 3) + 1
						end
						l_type_amount[l_random_type] := l_type_amount[l_random_type] - 1
						board_paths[l_i].extend (create {PATH_CARD}.make (l_random_type,
							a_surfaces[l_random_type], ((l_j - 1) * 84) + 56,
							((l_i - 1) * 84) + 56, l_random_rotation, a_items))
					else
						board_paths[l_i].extend (l_sticky_cards[l_sticky_cards_index])
						l_sticky_cards[l_sticky_cards_index].x := l_sticky_cards[l_sticky_cards_index].x + 56
						l_sticky_cards[l_sticky_cards_index].y := l_sticky_cards[l_sticky_cards_index].y + 56
						l_sticky_cards_index := l_sticky_cards_index + 1
					end
					l_j := l_j + 1
				end
				l_i := l_i + 1
			end
		end

	init_sticky_cards (a_surfaces: LIST[LIST[GAME_SURFACE]]; a_items: LIST[GAME_SURFACE]): ARRAYED_LIST[PATH_CARD]
			-- Retourne la liste des PATH_CARD qui ne changent pas entre les parties.
		local
			l_cards: ARRAYED_LIST[PATH_CARD]
		do
			create l_cards.make (16)
			l_cards.extend (create {PATH_CARD} .make (1, a_surfaces[1], 0, 0, 4, a_items))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 168, 0, 2, a_items))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 336, 0, 3, a_items))
			l_cards.extend (create {PATH_CARD} .make (1, a_surfaces[1], 504, 0, 1, a_items))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 0, 168, 1, a_items))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 168, 168, 3, a_items))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 336, 168, 2, a_items))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 504, 168, 4, a_items))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 0, 336, 4, a_items))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 168, 336, 2, a_items))
			l_cards.extend (create {PATH_CARD} .make (2, a_surfaces[2], 336, 336, 4, a_items))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 504, 336, 2, a_items))
			l_cards.extend (create {PATH_CARD} .make (1, a_surfaces[1], 0, 504, 3, a_items))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 168, 504, 3, a_items))
			l_cards.extend (create {PATH_CARD} .make (3, a_surfaces[3], 336, 504, 1, a_items))
			l_cards.extend (create {PATH_CARD} .make (1, a_surfaces[1], 504, 504, 2, a_items))
			result := l_cards
		end

--	get_next_spare_card_column(a_column_id:NATURAL_8; a_add_on_top:BOOLEAN): PATH_CARD

	get_next_spare_card_row(a_row_id:NATURAL_8; a_add_on_right:BOOLEAN): PATH_CARD
			-- Retourne la PATH_CARD qui sera éjecté du board si la
			-- méthode rotate_row est lancée.
		do
			if a_add_on_right then
				result := (board_paths[a_row_id])[1]
			else
				result := board_paths[a_row_id].last
			end
		end

--	rotate_column(a_column_id:NATURAL_8; a_path_card: PATH_CARD; a_add_on_top:BOOLEAN)

	rotate_row(a_row_id:NATURAL_8; a_path_card: PATH_CARD; a_add_on_right:BOOLEAN)
			-- Insert `a_path_card' dans la rangée `a_row_id'. `a_path_card' est
			-- inséré par la droite si `a_add_on_right' est vrai, sinon par la gauche.
		local
			l_i: INTEGER
		do
			if a_add_on_right then
				-- Rotate from right to left
				from l_i := 1 until l_i > 6 loop
					(board_paths[a_row_id])[l_i] := (board_paths[a_row_id])[l_i + 1]
					l_i := l_i + 1
				end
				(board_paths[a_row_id])[7] := a_path_card
			else
				-- Rotate from left to right
				from l_i := 7 until l_i < 2 loop
					(board_paths[a_row_id])[l_i] := (board_paths[a_row_id])[l_i - 1]
					l_i := l_i - 1
				end
				(board_paths[a_row_id])[1] := a_path_card
			end
		end

	adjust_paths (a_speed: INTEGER)
			-- Approche les PATHS_CARDS de `current' vers leur
			-- position respective de `a_speed' pixels.
		require
			speed_over_zero: a_speed > 0
		local
			l_i, l_j: INTEGER
		do
			from  l_i := 1 until l_i > board_paths.count loop
				from  l_j := 1 until l_j > board_paths.count loop
					(board_paths[l_j])[l_i].approach_point (((l_i - 1) * 84) + 56, ((l_j - 1) * 84) + 56, a_speed)
					l_j := l_j + 1
				end
				l_i := l_i + 1
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
		do
			result := false
			if (board_paths[a_y])[a_x].is_connected(a_direction) then
				if a_direction = 0 then
					if (a_y - 1 > 0) then
						if (board_paths[a_y - 1])[a_x].is_connected(2) then
							result := true
						end
					end
				elseif a_direction = 1 then
					if (a_x + 1 <= 7) then
						if (board_paths[a_y])[a_x + 1].is_connected(3) then
							result := true
						end
					end
				elseif a_direction = 2 then
					if (a_y + 1 <= 7) then
						if (board_paths[a_y + 1])[a_x].is_connected(0) then
							result := true
						end
					end
				elseif (a_x - 1 > 0) then
					if (board_paths[a_y])[a_x - 1].is_connected(1) then
						result := true
					end
				end
			end
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
		do
			create l_visited_paths.make
			create result.make
			pathfind_to_recursive (a_x2, a_y2, a_x1, a_y1, result, l_visited_paths)
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
