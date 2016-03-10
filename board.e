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
			create {ARRAYED_LIST[LIST[PATH_CARD]]} board.make (7)
			init_row_1(a_surfaces)
			init_row_2(a_surfaces)
			init_row_3(a_surfaces)
			init_row_4(a_surfaces)
			init_row_5(a_surfaces)
			init_row_6(a_surfaces)
			init_row_7(a_surfaces)
			create board_surface.make(84 * 7, 84 * 7)
			refresh_board_surface
			make_sprite(board_surface, 56, 56)
		end

feature {GAME_ENGINE} -- Implementation

	board : LIST[LIST[PATH_CARD]]
		-- Liste des PATH_CARDS contenuent dans `current'.

	board_surface: GAME_SURFACE
		-- Surface sur laquelle est dessinée la liste "board".

	refresh_board_surface
		-- Mets à jour board_surface.
		do
			across
				board as l_board
            loop
            	across
            		l_board.item as l_row
            	loop
            		l_row.item.draw_self(board_surface)
            	end
            end
		end

	rotate_column(column_id:NATURAL_8; add_on_top:BOOLEAN)
		do

		end

	rotate_row(row_id:NATURAL_8; add_on_right:BOOLEAN)
		do

		end

	init_row_1(a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Rangée 1:
			-- Le type peut être soit 1='╗' 2='║'  3='╣'
		local
			l_list:ARRAYED_LIST[PATH_CARD]

		do
			create l_list.make (7)
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 0, 0, 4))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 84, 0, 1))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 168, 0, 2))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 252, 0, 3))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 336, 0, 3))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 420, 0, 2))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 504, 0, 1))
			board.extend (l_list)
		end

	init_row_2(a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Rangée 2:
			-- Le type peut être soit 1='╗' 2='║'  3='╣'
		local
			l_list:ARRAYED_LIST[PATH_CARD]
			l_rng: GAME_RANDOM
		do
			create l_rng
			create l_list.make (7)
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 0, 84, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 84, 84, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 168, 84, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 252, 84, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 336, 84, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 420, 84, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 504, 84, l_rng.last_random_integer_between (1, 4)))
			board.extend (l_list)
		end

	init_row_3(a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Rangée 3:
			-- Le type peut être soit 1='╗' 2='║'  3='╣'
		local
			l_list:ARRAYED_LIST[PATH_CARD]
		do
			create l_list.make (7)
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 0, 168, 1))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 84, 168, 2))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 168, 168, 3))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 252, 168, 4))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 336, 168, 2))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 420, 168, 3))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 504, 168, 4))
			board.extend (l_list)
		end

	init_row_4(a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Rangée 4:
			-- Le type peut être soit 1='╗' 2='║'  3='╣'
		local
			l_list:ARRAYED_LIST[PATH_CARD]
			l_rng: GAME_RANDOM
		do
			create l_rng
			create l_list.make (7)
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 0, 252, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 84, 252, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 168, 252, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 252, 252, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 336, 252, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 420, 252, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 504, 252, l_rng.last_random_integer_between (1, 4)))
			board.extend (l_list)
		end

	init_row_5(a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Rangée 5:
			-- Le type peut être soit 1='╗' 2='║'  3='╣'
		local
			l_list:ARRAYED_LIST[PATH_CARD]
		do
			create l_list.make (7)
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 0, 336, 4))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 84, 336, 1))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 168, 336, 2))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 252, 336, 3))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 336, 336, 4))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 420, 336, 3))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 504, 336, 2))
			board.extend (l_list)
		end

	init_row_6(a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Rangée 6:
			-- Le type peut être soit 1='╗' 2='║'  3='╣'
		local
			l_list:ARRAYED_LIST[PATH_CARD]
			l_rng: GAME_RANDOM
		do
			create l_rng
			create l_list.make (7)
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 0, 420, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 84, 420, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 168, 420, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 252, 420, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 336, 420, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 420, 420, l_rng.last_random_integer_between (1, 4)))
			l_rng.generate_new_random
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 504, 420, l_rng.last_random_integer_between (1, 4)))
			board.extend (l_list)
		end

	init_row_7(a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Rangée 7:
			-- Le type peut être soit 1='╗' 2='║'  3='╣'
		local
			l_list:ARRAYED_LIST[PATH_CARD]
		do
			create l_list.make (7)
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 0, 504, 3))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 84, 504, 4))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 168, 504, 3))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 252, 504, 2))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 336, 504, 1))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 420, 504, 4))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 504, 504, 2))
			board.extend (l_list)
		end

	path_can_go_direction (a_x, a_y, a_direction: INTEGER): BOOLEAN
			-- Retrourne `true' si la PATH_CARD à l'index `a_x', `a_y' a
			-- un chemin complet vers la direction `a_direction'.
		require
			a_x > 0
			a_y > 0
			a_x <= 7
			a_y <= 7
			a_direction >= 0
			a_direction < 4
		local
			l_result: BOOLEAN
		do
			l_result := false
			if (board[a_y])[a_x].is_connected(a_direction) then
				if a_direction = 0 then
					if (a_y - 1 > 0) then
						if (board[a_y - 1])[a_x].is_connected(2) then
							l_result := true
						end
					end
				elseif a_direction = 1 then
					if (a_x + 1 <= 7) then
						if (board[a_y])[a_x + 1].is_connected(3) then
							l_result := true
						end
					end
				elseif a_direction = 2 then
					if (a_y + 1 <= 7) then
						if (board[a_y + 1])[a_x].is_connected(0) then
							l_result := true
						end
					end
				elseif (a_x - 1 > 0) then
					if (board[a_y])[a_x - 1].is_connected(1) then
						l_result := true
					end
				end
			end
			result := l_result
		end

	pathfind_to (a_x1, a_y1, a_x2, a_y2: INTEGER): LINKED_LIST[PATH_CARD]
			-- Retourne une liste contenant les PATH_CARD à traverser pour
			-- atteindre la destination (`a_x2', `a_y2') à partir de (`a_x1', `a_y1').
			-- `a_x1', `a_y1', `a_x2' et `a_y2' sont des index de `board'.
			-- si aucun chemin n'est trouvé, une liste vide est retournée.
		require
			a_x1 > 0
			a_y1 > 0
			a_x1 <= 7
			a_y1 <= 7
			a_x2 > 0
			a_y2 > 0
			a_x2 <= 7
			a_y2 <= 7
		local
			l_visited_paths: LINKED_LIST[PATH_CARD]
			l_result: LINKED_LIST[PATH_CARD]
			l_destination_found: BOOLEAN
		do
			create l_visited_paths.make
			create l_result.make
			l_destination_found := pathfind_to_recursive (a_x2, a_y2, a_x1, a_y1, l_result, l_visited_paths)
			result := l_result
		end

feature {NONE} -- Implementation

	pathfind_to_recursive (a_x1, a_y1, a_x2, a_y2: INTEGER; a_result, a_visited_paths: LINKED_LIST[PATH_CARD]): BOOLEAN
			-- Partie récursive de pathfind_to.
			-- Ne devrait être utilisée que par pathfind_to.
		local
			l_destination_found: BOOLEAN
		do
			a_visited_paths.extend ((board[a_y1])[a_x1])
			if (a_x1 = a_x2) and (a_y1 = a_y2) then
				l_destination_found := true
			else
				l_destination_found := false
			end
			if (not l_destination_found) and path_can_go_direction(a_x1, a_y1, 0) then
				if not a_visited_paths.has ((board[a_y1 - 1])[a_x1]) then
					l_destination_found := pathfind_to_recursive(a_x1, a_y1 - 1, a_x2, a_y2, a_result, a_visited_paths)
				end
			end
			if (not l_destination_found) and path_can_go_direction(a_x1, a_y1, 1) then
				if not a_visited_paths.has ((board[a_y1])[a_x1 + 1]) then
					l_destination_found := pathfind_to_recursive(a_x1 + 1, a_y1, a_x2, a_y2, a_result, a_visited_paths)
				end
			end
			if (not l_destination_found) and path_can_go_direction(a_x1, a_y1, 2) then
				if not a_visited_paths.has ((board[a_y1 + 1])[a_x1]) then
					l_destination_found := pathfind_to_recursive(a_x1, a_y1 + 1, a_x2, a_y2, a_result, a_visited_paths)
				end
			end
			if (not l_destination_found) and path_can_go_direction(a_x1, a_y1, 3) then
				if not a_visited_paths.has ((board[a_y1])[a_x1 - 1]) then
					l_destination_found := pathfind_to_recursive(a_x1 - 1, a_y1, a_x2, a_y2, a_result, a_visited_paths)
				end
			end
			if l_destination_found then
				a_result.extend ((board[a_y1])[a_x1])
			end
			result := l_destination_found
		end

end
