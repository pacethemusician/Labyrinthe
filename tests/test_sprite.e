note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_SPRITE

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end
	SPRITE
		undefine
			default_create
		end
	GAME_LIBRARY_SHARED
		undefine
			default_create
		end

feature -- Events

	on_prepare
		do
			if not game_library.is_video_enable then
				game_library.enable_video
			end
			make (create {GAME_SURFACE}.make (1, 1), 1, 1)
			assert ("test_sprite_on_prepare", not game_library.has_error)
		end

	on_clean
		do
			game_library.quit_library
			assert ("test_sprite_on_prepare", not game_library.has_error)
		end

feature -- Test routines

	draw_self_normal
			-- Test normal de `draw_self'.
		do
			draw_self (create {GAME_SURFACE}.make (5, 5))
			assert ("set_x_normal_1", not current_surface.has_error)
		end

	set_x_normal
			-- Test normal de `set_x'.
		do
			set_x (321)
			assert ("set_x_normal_1", x = 321)
			set_x (-123)
			assert ("set_x_normal_2", x = -123)
		end

	set_y_normal
			-- Test normal de `set_y'.
		do
			set_y (123)
			assert ("set_y_normal_1", y = 123)
			set_y (-321)
			assert ("set_y_normal_2", y = -321)
		end

	approach_point_normal
			-- Test normal de `approach_point'.
		do
			set_x (0)
			set_y (0)
			approach_point (5, 5, 3)
			assert ("approach_point_normal_1", (x = 3) and (y = 3))
			approach_point (5, 5, 3)
			assert ("approach_point_normal_2", (x = 5) and (y = 5))
		end

	approach_point_limite
			-- Test limite de `approach_point'.
		do
			set_x (0)
			set_y (0)
			approach_point (0, 0, 99)
			assert ("approach_point_limite_1", (x = 0) and (y = 0))
			approach_point (-1, -1, 99)
			assert ("approach_point_limite_2", (x = -1) and (y = -1))
		end

	set_surface_normal
			-- Test normal de `set_surface'.
		local
			l_surface: GAME_SURFACE
		do
			create l_surface.make (1, 1)
			set_surface (l_surface)
			assert ("approach_point_limite_2", current_surface = l_surface)
		end
end


