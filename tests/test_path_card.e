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
			on_prepare
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
			make (1, create {IMAGE_FACTORY}.make, 0, 0, 1)
			assert ("test_sprite_on_prepare", not game_library.has_error)
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

	rotate_limite
			-- Test limite de `rotate'.
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
			assert ("not_implemented", False)
		end

	set_x_offset_normal
			-- Test normal de `set_x_offset'.
		do
			assert ("not_implemented", False)
		end

	set_y_offset_normal
			-- Test normal de `set_y_offset'.
		do
			assert ("not_implemented", False)
		end

	set_item_index_normal
			-- Test normal de `set_item_index'.
		do
			assert ("not_implemented", False)
		end

	draw_self_normal
			-- Test normal de `draw_self'.
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
