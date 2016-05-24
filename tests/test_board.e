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
			on_prepare,
			on_clean
		end

	ABSTRACT_BOARD
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
		note
			testing: "execution/isolated"
		do
			create {ARRAYED_LIST[PLAYER]} players.make(4)
			if not game_library.is_video_enable then
				game_library.enable_video
			end
			make (create {IMAGE_FACTORY}.make, players)
			assert ("test_board_on_prepare", not game_library.has_error)
		end

	on_clean
		do
			game_library.quit_library
		end

feature -- Test routines

	players: LIST[PLAYER]

	init_board_paths_normal
			-- Test normal de `init_board_paths'.
		do
			init_board_paths(players)
			assert ("init_board_paths_normal_1", board_paths.count = 7)
			across board_paths as rows loop
				assert ("init_board_paths_normal_2", rows.item.count = 7)
			end
		end

	init_row_normal
			-- Test normal de `init_row'.
		do
			board_paths.first.wipe_out
			init_row (1, init_sticky_cards, create {ARRAYED_LIST [INTEGER]}
				.make_from_array (<<3, 2, 2>>), create {GAME_RANDOM})
			assert ("init_row_normal_1", board_paths.first.full)
		end

	distribute_items_normal
			-- Test normal de `distribute_items'.
		local
			l_item_count: INTEGER
		do
			across board_paths as rows loop
				across rows.item as paths loop
					paths.item.item_index := 0
				end
			end
			distribute_items (image_factory.items, create {GAME_RANDOM})
			across board_paths as rows loop
				across rows.item as paths loop
					if (paths.item.item_index > 0) then
						l_item_count := l_item_count + 1
					end
				end
			end
			assert ("distribute_items_normal_1", l_item_count = image_factory.items.count - 5)
		end

	get_next_spare_card_column_normal
			-- Test normal de `get_next_spare_card_column'.
		local
			l_path_card: PATH_CARD
			l_second_path_card: PATH_CARD
		do
			l_path_card := (board_paths[1])[2]
			l_second_path_card := get_next_spare_card_column (2, false)
			assert ("get_next_spare_card_column_normal_1", l_path_card = l_second_path_card)
			l_path_card := (board_paths.last)[4]
			l_second_path_card := get_next_spare_card_column (4, true)
			assert ("get_next_spare_card_column_normal_2", l_path_card = l_second_path_card)
			l_path_card := (board_paths[1])[6]
			l_second_path_card := get_next_spare_card_column (6, false)
			assert ("get_next_spare_card_column_normal_3", l_path_card = l_second_path_card)
		end

	get_next_spare_card_row_normal
			-- Test normal de `get_next_spare_card_row'.
		local
			l_path_card: PATH_CARD
			l_second_path_card: PATH_CARD
		do
			l_path_card := (board_paths[2])[1]
			l_second_path_card := get_next_spare_card_row (2, true)
			assert ("get_next_spare_card_row_normal_1", l_path_card = l_second_path_card)
			l_path_card := (board_paths[4]).last
			l_second_path_card := get_next_spare_card_row (4, false)
			assert ("get_next_spare_card_row_normal_2", l_path_card = l_second_path_card)
			l_path_card := (board_paths[6])[1]
			l_second_path_card := get_next_spare_card_row (6, true)
			assert ("get_next_spare_card_row_normal_3", l_path_card = l_second_path_card)
		end

	rotate_column_normal
			-- Test normal de `rotate_column'.
		local
			l_path_card: PATH_CARD
			l_second_path_card: PATH_CARD
		do
			l_path_card := (board_paths[1])[2]
			l_second_path_card := (board_paths.last)[2]
			rotate_column (2, l_path_card, false)
			assert ("rotate_column_normal_1", l_path_card = (board_paths.last)[2] and l_second_path_card = (board_paths[6])[2])
			l_path_card := (board_paths[1])[4]
			l_second_path_card := (board_paths.last)[4]
			rotate_column (4, l_second_path_card, true)
			assert ("rotate_column_normal_2", l_path_card = (board_paths[2])[4] and l_second_path_card = (board_paths[1])[4])
		end

	rotate_row_normal
			-- Test normal de `rotate_row'.
		local
			l_path_card: PATH_CARD
			l_second_path_card: PATH_CARD
		do
			l_path_card := (board_paths[2])[1]
			l_second_path_card := (board_paths[2]).last
			rotate_row (2, l_path_card, true)
			assert ("rotate_row_normal_1", l_path_card = (board_paths[2]).last and l_second_path_card = (board_paths[2])[6])
			l_path_card := (board_paths[4])[1]
			l_second_path_card := (board_paths[4]).last
			rotate_row (4, l_second_path_card, false)
			assert ("rotate_row_normal_2", l_path_card = (board_paths[4])[2] and l_second_path_card = (board_paths[4])[1])
		end

	adjust_paths_normal
			-- Test normal de `adjust_paths'.
		do
			(board_paths[1])[1].x := (board_paths[1])[1].x + 5
			(board_paths[1])[1].y := (board_paths[1])[1].y - 5
			adjust_paths (3)
			assert ("adjust_paths_normal_1", (board_paths[1])[1].x = 58 and (board_paths[1])[1].y = 54)
			adjust_paths (3)
			assert ("adjust_paths_normal_1", (board_paths[1])[1].x = 56 and (board_paths[1])[1].y = 56)
		end

	path_can_go_direction_normal
			-- Test normal de `path_can_go_direction'.
		do
			assert ("path_can_go_direction_normal_1", path_can_go_direction (1, 1, 1))
			assert ("path_can_go_direction_normal_2", not path_can_go_direction (7, 7, 3))
			assert ("path_can_go_direction_normal_3", path_can_go_direction (4, 4, 0))
		end

	pathfind_to_normal
			-- Test normal de `pathfind_to'.
		local
			l_path_list: LINKED_LIST [PATH_CARD]
		do
			l_path_list := pathfind_to (1, 1, 3, 3)
			assert ("pathfind_to_normal_1", (l_path_list [1] = board_paths.first.first) and
											(l_path_list [2] = board_paths.first [2]) and
											(l_path_list [3] = board_paths.first [3]) and
											(l_path_list [4] = (board_paths [2]) [3]) and
											(l_path_list [5] = (board_paths [3]) [3]))
			l_path_list := pathfind_to (2, 7, 3, 6)
			assert ("pathfind_to_normal_2", (l_path_list [1] = (board_paths [7]) [2]) and
											(l_path_list [2] = (board_paths [7]) [3]) and
											(l_path_list [3] = (board_paths [6]) [3]))
			l_path_list := pathfind_to (1, 1, 7, 7)
			assert ("pathfind_to_normal_3", l_path_list.count = 0)
		end

note
	license: "WTFPL"
	source: "[
		Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
		Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
	]"

end


