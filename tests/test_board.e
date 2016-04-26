note
	description: "Tests unitaires de la classe {BOARD}"
	author: "Charles Lemay"
	date: "2016-04-26"
	revision: "1.0"
	testing: "type/manual"

class
	TEST_BOARD

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end

	BOARD
		undefine
			default_create
		end

	GAME_LIBRARY_SHARED
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			if not game_library.is_video_enable then
				game_library.enable_video
			end
			make (create {IMAGE_FACTORY}.make)
			assert ("test_board_on_prepare", not game_library.has_error)
		end

feature -- Test routines

	init_board_paths_normal
			-- Test normal de `init_board_paths'.
		local
			l_sticky_cards: ARRAYED_LIST [PATH_CARD]
			l_i, l_j: INTEGER
			l_sticky_cards_index: INTEGER
		do
			init_board_paths
			l_sticky_cards_index := 1
			assert ("init_board_paths_normal_1", board_paths.count = 7)
			across board_paths as rows loop
				assert ("init_board_paths_normal_2", rows.item.count = 7)
			end
		end

	init_row_normal
			-- Test normal de `init_row'.
		do
			assert ("not_implemented", False)
		end

	distribute_items_normal
			-- Test normal de `distribute_items'.
		do
			assert ("not_implemented", False)
		end

	get_next_spare_card_column_normal
			-- Test normal de `get_next_spare_card_column'.
		do
			assert ("not_implemented", False)
		end

	get_next_spare_card_row_normal
			-- Test normal de `get_next_spare_card_row'.
		do
			assert ("not_implemented", False)
		end

	rotate_column_normal
			-- Test normal de `rotate_column'.
		do
			assert ("not_implemented", False)
		end

	rotate_row_normal
			-- Test normal de `rotate_row'.
		do
			assert ("not_implemented", False)
		end

	adjust_paths_normal
			-- Test normal de `adjust_paths'.
		do
			assert ("not_implemented", False)
		end

	path_can_go_direction_normal
			-- Test normal de `path_can_go_direction'.
		do
			assert ("not_implemented", False)
		end

	pathfind_to_normal
			-- Test normal de `pathfind_to'.
		do
			assert ("not_implemented", False)
		end

note
	license: "WTFPL"
	source: "[
		Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
		Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
	]"

end


