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


end
