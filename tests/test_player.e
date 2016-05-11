note
	description: "Tests unitaires de la classe {PLAYER}"
	author: "Charles Lemay"
	date: "2016-05-02"
	revision: "1.0"
	testing: "type/manual"

class
	TEST_PLAYER

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end

	PLAYER
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
		local
			l_image_list: ARRAYED_LIST [GAME_SURFACE]
			l_i: INTEGER
		do
			if not game_library.is_video_enable then
				game_library.enable_video
			end
			create l_image_list.make (5)
			from l_i := 1 until l_i > 5 loop
				l_image_list.extend (create {GAME_SURFACE}.make (1, 1))
			end
			make (l_image_list, 0, 0, l_i, create {SCORE_SURFACE}.make (create {GAME_SURFACE}.make (1, 1), 0, 0, 25, create {IMAGE_FACTORY}.make))
			assert ("test_player_on_prepare", not game_library.has_error)
		end

	on_clean
		do
			game_library.quit_library
		end

feature -- Test routines

	get_col_index_normal
			-- Test normal de `get_col_index'.
		do
			assert ("not_implemented", get_col_index = -1)
		end

	get_row_index_normal
			-- Test normal de `get_row_index'.
		do
			assert ("not_implemented", False)
		end

	set_score_surface_normal
			-- Test normal de `set_score_surface'.
		do
			assert ("not_implemented", False)
		end

	set_path_normal
			-- Test normal de `set_path'.
		do
			assert ("not_implemented", False)
		end

	set_item_found_number_normal
			-- Test normal de `set_item_found_number'.
		do
			assert ("not_implemented", False)
		end

	set_next_x_normal
			-- Test normal de `set_next_x'.
		do
			assert ("not_implemented", False)
		end

	set_next_y_normal
			-- Test normal de `set_next_y'.
		do
			assert ("not_implemented", False)
		end

	pick_up_item_normal
			-- Test normal de `pick_up_item'.
		do
			assert ("not_implemented", False)
		end

	follow_path_normal
			-- Test normal de `follow_path'.
		do
			assert ("not_implemented", False)
		end

end


