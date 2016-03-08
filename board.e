note
	description: "Classe responsable du plateau de jeu."
	author: "Pascal"
	date: "22 février 2016"
	revision: "0.1"

class
	BOARD

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
		end

feature {GAME_ENGINE} -- Implementation

	board : LIST[LIST[PATH_CARD]]

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
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 56, 56, 4))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 140, 56, 1))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 224, 56, 2))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 308, 56, 3))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 392, 56, 3))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 476, 56, 2))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 560, 56, 1))
			board.extend (l_list)
		end

	init_row_2(a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Rangée 2:
			-- Le type peut être soit 1='╗' 2='║'  3='╣'
		local
			l_list:ARRAYED_LIST[PATH_CARD]
		do
			create l_list.make (7)
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56, 140, 1))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 140, 140, 2))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 224, 140, 3))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 308, 140, 1))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 392, 140, 2))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 476, 140, 4))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 560, 140, 4))
			board.extend (l_list)
		end

	init_row_3(a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Rangée 3:
			-- Le type peut être soit 1='╗' 2='║'  3='╣'
		local
			l_list:ARRAYED_LIST[PATH_CARD]
		do
			create l_list.make (7)
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56, 224, 1))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 140, 224, 2))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 224, 224, 3))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 308, 224, 4))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 392, 224, 2))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 476, 224, 3))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 560, 224, 4))
			board.extend (l_list)
		end

	init_row_4(a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Rangée 4:
			-- Le type peut être soit 1='╗' 2='║'  3='╣'
		local
			l_list:ARRAYED_LIST[PATH_CARD]
		do
			create l_list.make (7)
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 56, 308, 4))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 140, 308, 3))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 224, 308, 2))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 308, 308, 1))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 392, 308, 2))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 476, 308, 3))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 560, 308, 4))
			board.extend (l_list)
		end

	init_row_5(a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Rangée 5:
			-- Le type peut être soit 1='╗' 2='║'  3='╣'
		local
			l_list:ARRAYED_LIST[PATH_CARD]
		do
			create l_list.make (7)
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 56, 392, 4))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 140, 392, 1))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 224, 392, 2))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 308, 392, 3))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 392, 392, 4))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 476, 392, 3))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 560, 392, 2))
			board.extend (l_list)
		end

	init_row_6(a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Rangée 6:
			-- Le type peut être soit 1='╗' 2='║'  3='╣'
		local
			l_list:ARRAYED_LIST[PATH_CARD]
		do
			create l_list.make (7)
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 56, 476, 1))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 140, 476, 2))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 224, 476, 3))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 308, 476, 4))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 392, 476, 3))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 476, 476, 2))
			l_list.extend (create {PATH_CARD} .make (2, a_surfaces[2], 560, 476, 4))
			board.extend (l_list)
		end

	init_row_7(a_surfaces: LIST[LIST[GAME_SURFACE]])
			-- Rangée 7:
			-- Le type peut être soit 1='╗' 2='║'  3='╣'
		local
			l_list:ARRAYED_LIST[PATH_CARD]
		do
			create l_list.make (7)
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 56, 560, 3))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 140, 560, 4))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 224, 560, 3))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 308, 560, 2))
			l_list.extend (create {PATH_CARD} .make (3, a_surfaces[3], 392, 560, 1))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 476, 560, 4))
			l_list.extend (create {PATH_CARD} .make (1, a_surfaces[1], 560, 560, 2))
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
