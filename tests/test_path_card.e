note
	description: "Tests unitaires de la classe {ANIMATED_SPRITE}"
	author: "Charles Lemay"
	date: "2016-04-25"
	revision: "1.0"
	testing: "type/manual"

class
	TEST_PATH_CARD

inherit

	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end

	PATH_CARD
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
			make (1, create {IMAGE_FACTORY}.make, 0, 0, 1, 0)
			assert ("test_path_card_on_prepare", not game_library.has_error)
		end

	on_clean
		do
			game_library.quit_library
		end

feature -- Test routines

	rotate_normal
			-- Test normal de `rotate'.
		do
			index := 1
			connections := 0b0011
			rotate (1)
			assert ("rotate_normal_1", (connections = 0b1001) and (index = 2))
			rotate (3)
			assert ("rotate_normal_2", (connections = 0b0011) and (index = 1))
		end

	rotate_limiterotation

		do
			index := 1
			connections := 0b0011
			rotate (0)
			assert ("rotate_limite_1", (connections = 0b0011) and (index = 1))
			rotate (4)
			assert ("rotate_limite_2", (connections = 0b0011) and (index = 1))
		end

	is_connected_normal
			-- Test normal de `is_connected'.
		do
			assert ("is_connected_normal_1", not is_connected (0))
			assert ("is_connected_normal_2", not is_connected (1))
			assert ("is_connected_normal_3", is_connected (2))
			assert ("is_connected_normal_4", is_connected (3))
		end

	set_x_offset_normal
			-- Test normal de `set_x_offset'.
		do
			set_x_offset (0)
			assert ("set_x_offset_normal_1", x_offset = 0)
			set_x_offset (22)
			assert ("set_x_offset_normal_2", x_offset = 22)
			set_x_offset (-33)
			assert ("set_x_offset_normal_3", x_offset = -33)
		end

	set_y_offset_normal
			-- Test normal de `set_y_offset'.
		do
			set_y_offset (0)
			assert ("set_y_offset_normal_1", y_offset = 0)
			set_y_offset (22)
			assert ("set_y_offset_normal_2", y_offset = 22)
			set_y_offset (-33)
			assert ("set_y_offset_normal_3", y_offset = -33)
		end

	set_item_index_normal
			-- Test normal de `set_item_index'.
		do
			set_item_index (10)
			assert ("set_item_index_normal_1", item_index = 10)
			set_item_index (7)
			assert ("set_item_index_normal_2", item_index = 7)
		end

	set_item_index_limite
			-- Test limite de `set_item_index'.
		do
			set_item_index (0)
			assert ("set_item_index_limite_1", item_index = 0)
			set_item_index (items.count)
			assert ("set_item_index_limite_2", item_index = items.count)
		end

	draw_self_normal
			-- Test normal de `draw_self'.
		do
			draw_self (create {GAME_SURFACE}.make (5, 5))
			assert ("draw_self_normal_1", not current_surface.has_error)
		end

note
	license: "WTFPL"
	source: "[
		Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
		Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
	]"

end
