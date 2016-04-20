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

--	new_test_routine
--			-- New test routine
--		do
--			assert ("not_cool", False)
--		end

end


