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

	AUDIO_LIBRARY_SHARED
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
			l_factory: IMAGE_FACTORY
			l_i: INTEGER
		do
			if not audio_library.is_sound_enable then
				audio_library.enable_sound
			end
			if not game_library.is_video_enable then
				game_library.enable_video
			end
			create l_factory.make
			create l_image_list.make (5)
			from l_i := 1 until l_i > 5 loop
				l_image_list.extend (create {GAME_SURFACE}.make (1, 1))
				l_i := l_i + 1
			end
			make (l_factory, 1, 266, 266, l_i, create {SCORE_SURFACE}.make (create {GAME_SURFACE}.make (1, 1), 0, 0, 25, l_factory))
			assert ("test_player_on_prepare", not game_library.has_error)
		end

	on_clean
		do
			audio_library.disable_sound
			game_library.quit_library
		end

feature -- Test routines

	get_col_index_normal
			-- Test normal de `col_index'.
		do
			assert ("get_col_index_normal_1", col_index = 3)
			x := x + 84
			assert ("get_col_index_normal_2", col_index = 4)
			x := x + 84
			assert ("get_col_index_normal_3", col_index = 5)
		end

	get_col_index_limite
			-- Test limite de `col_index'.
		do
			x := -100
			assert ("get_col_index_limite_1", col_index = 1)
			x := 5000
			assert ("get_col_index_limite_2", col_index = 7)
		end

	get_row_index_normal
			-- Test normal de `row_index'.
		do
			assert ("get_row_index_normal_1", row_index = 3)
			y := y + 84
			assert ("get_row_index_normal_2", row_index = 4)
			y := y + 84
			assert ("get_row_index_normal_3", row_index = 5)
		end

	get_row_index_limite
			-- Test limite de `row_index'.
		do
			y := -100
			assert ("get_row_index_limite_1", row_index = 1)
			y := 5000
			assert ("get_row_index_limite_2", row_index = 7)
		end

	set_score_surface_normal
			-- Test normal de `set_score_surface'.
		local
			l_score_surface: SCORE_SURFACE
		do
			create l_score_surface.make (create {GAME_SURFACE}.make (1, 1), 0, 0, 0, create {IMAGE_FACTORY}.make)
			set_score_surface(l_score_surface)
			assert ("set_score_surface_normal_1", l_score_surface = score)
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
			set_next_x (10)
			assert ("set_next_x_normal_1", next_x = 10)
			set_next_x (-8)
			assert ("set_next_x_normal_2", next_x = -8)
			set_next_x (321)
			assert ("set_next_x_normal_2", next_x = 321)
		end

	set_next_y_normal
			-- Test normal de `set_next_y'.
		do
			set_next_y (11)
			assert ("set_next_y_normal_1", next_y = 10)
			set_next_y (-9)
			assert ("set_next_y_normal_2", next_y = -8)
			set_next_y (322)
			assert ("set_next_y_normal_2", next_y = 321)
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


