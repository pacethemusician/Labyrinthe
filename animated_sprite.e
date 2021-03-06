note
	description: "Objet ayant une animation et des coordonn�es pouvant �tre affich�es."
	author: "Charles Lemay"
	date: "F�vrier 2016"
	revision: "1.0"

class
	ANIMATED_SPRITE

inherit

	SPRITE
		rename
			make as make_sprite
		redefine
			draw_self
		end

create
	make

feature {NONE} -- Initialization

	make (a_default_surface: GAME_SURFACE; a_frame_count, a_delay, a_x, a_y: INTEGER_32)
			-- Initialisation de `Current' avec l'animation `a_default_surface' � la position (`a_x', `a_y').
			-- `a_frame_count' -> Assign� � `frame_count'.
			-- `a_delay' -> Assign� � `delay'.
		require
			frame_over_zero: a_frame_count > 0
			delay_over_zero: a_delay > 0
		do
			make_sprite (a_default_surface, a_x, a_y)
			set_frame_count (a_frame_count)
			set_delay (a_delay)
			set_timer (0)
		end

feature -- Implementation

	draw_self (destination_surface: GAME_SURFACE)
			-- Dessine `Current' sur `destination_surface' et met � jour `animation_timer'.
		local
			l_frame_width: INTEGER_32
			l_frame_offset: INTEGER_32
		do
			l_frame_width := current_surface.width // frame_count
			l_frame_offset := l_frame_width * (animation_timer // delay)
			destination_surface.draw_sub_surface (current_surface, l_frame_offset, 0, l_frame_width, current_surface.height, x, y)
			set_timer (animation_timer + 1)
		end

	change_animation (a_surface: detachable GAME_SURFACE; a_frame_count, a_delay: INTEGER_32)
			-- Change l'animation de `Current' pour `a_surface' et remet `animation_timer' � 0.
			-- `a_frame_count' -> Sera assign� � `frame_count' dans le `make'.
			-- `a_delay' -> Sera assign� � `delay' dans le `make'.
		require
			frame_over_zero: a_frame_count > 0
			delay_over_zero: a_delay > 0
		do
			if attached a_surface as surface then
				make (surface, a_frame_count, a_delay, x, y)
			else
				print ("Cannot change animation. Surface does not exist.")
			end
		end

	set_timer (a_time: INTEGER_32)
			-- Assigne `a_time' � `animation_timer'.
		local
			l_time: INTEGER_32
		do
			l_time := a_time \\ (frame_count * delay)
			if l_time < 0 then
				l_time := (frame_count * delay) + a_time
			end
			animation_timer := l_time
		ensure
			timer_valid: animation_timer < (frame_count * delay)
		end

	set_frame_count (a_frame_count: INTEGER_32)
			-- Assigne `a_frame_count' � `frame_count'.
		require
			frame_over_zero: a_frame_count > 0
		do
			frame_count := a_frame_count
		ensure
			is_assign: frame_count = a_frame_count
		end

	set_delay (a_delay: INTEGER_32)
			-- Assigne `a_delay' � `delay'.
		require
			delay_over_zero: a_delay > 0
		do
			delay := a_delay
		ensure
			is_assign: delay = a_delay
		end

feature {GAME_ENGINE} -- Attributs

	animation_timer: INTEGER_32 assign set_timer
			-- 'Timer' qui indique l'avancement de `current_surface'.

	frame_count: INTEGER_32 assign set_frame_count
			-- Le nombre de 'frames' de l'animation actuelle.

	delay: INTEGER_32 assign set_delay
			-- Le d�lai entre chaque changement de 'frame'.

invariant
	timer_valid: animation_timer < (frame_count * delay)
	delay_over_zero: delay > 0
	frame_over_zero: frame_count > 0

note
	license: "WTFPL"
	source: "[
				Ce jeu a �t� fait dans le cadre du cours de programmation orient�e object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
