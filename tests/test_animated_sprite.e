note
	description: "Tests unitaires de la classe {ANIMATED_SPRITE}"
	author: "Charles Lemay"
	date: "2016-04-25"
	revision: "1.0"
	testing: "type/manual"

class
	TEST_ANIMATED_SPRITE

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

	ANIMATED_SPRITE
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
			make (create {GAME_SURFACE}.make (1, 1), 5, 2, 1, 1)
			assert ("test_animated_sprite_on_prepare", not game_library.has_error)
		end

feature -- Test routines

	change_animation_normal
			-- Test normal de `change_animation'.
		local
			l_surface: GAME_SURFACE
		do
			create l_surface.make (2, 2)
			change_animation (l_surface, 4, 6)
			assert ("change_animation_normal_1", (frame_count = 4) and (delay = 6) and (current_surface = l_surface))
			change_animation (void, 1, 1)
			assert ("change_animation_normal_2", (frame_count = 4) and (delay = 6) and (current_surface = l_surface))
		end

	set_timer_normal
			-- Test normal de `set_timer'.
		do
			set_timer (3)
			assert ("set_timer_normal_1", animation_timer = 3)
			set_timer (5)
			assert ("set_timer_normal_2", animation_timer = 5)
		end

	set_timer_limite
			-- Test limite de `set_timer'.
		do
			set_timer (9)
			assert ("set_timer_limite_1", animation_timer = 9)
			set_timer (0)
			assert ("set_timer_limite_2", animation_timer = 0)
		end

	set_frame_count_normal
			-- Test normal de `set_frame_count'.
		do
			set_frame_count (3)
			assert ("set_frame_count_normal_1", frame_count = 3)
			set_frame_count (14)
			assert ("set_frame_count_normal_2", frame_count = 14)
		end

	set_frame_count_limite
			-- Test limite de `set_frame_count'.
		do
			set_frame_count (1)
			assert ("set_frame_count_limite_1", frame_count = 1)
		end

	set_delay_normal
			-- Test normal de `set_delay'.
		do
			set_delay (3)
			assert ("set_delay_normal_1", delay = 3)
			set_delay (14)
			assert ("set_delay_normal_2", delay = 14)
		end

	set_delay_limite
			-- Test limite de `set_delay'.
		do
			set_delay (1)
			assert ("set_delay_limite_1", delay = 1)
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
