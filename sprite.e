note
	description: "Classe pour objet ayant une image et coordonnées x, y {SPRITE}."
	author: "Pascal Belisle"
	date: "15 Février 2016"
	revision: None

class
	SPRITE

create
	make

feature {NONE}	-- Initialisation
	make (starting_animation:ANIMATION)
		do
			current_animation := starting_animation
			current_frame := 0
			x := 0
			y := 0
		end

feature {GAME_ENGINE}	-- Declaration des arguments
	x:INTEGER_16 assign set_x
	y:INTEGER_16 assign set_y
	current_animation:ANIMATION assign set_animation
	current_frame:INTEGER_32 assign set_frame

feature {GAME_ENGINE}	-- Implementation
	draw_self(destination_surface:GAME_SURFACE)
		local
			l_frame_width:INTEGER_32
			l_frame_offset:INTEGER_32
		do
			l_frame_width := current_animation.frames.width // current_animation.frame_number
			l_frame_offset := l_frame_width * (current_frame // current_animation.speed)
			destination_surface.draw_sub_surface (current_animation.frames,
				l_frame_offset, 0, l_frame_width, current_animation.frames.height, x, y)
		end

	set_frame(a_frame:INTEGER_32)
		do
			current_frame := a_frame \\ (current_animation.frame_number * current_animation.speed)
			if current_frame < 0 then
				current_frame := -current_frame
			end
		end

	set_animation(a_animation:ANIMATION)
		do
			current_animation := a_animation
		end

	set_x(a_x:INTEGER_16)
		do
			x := a_x
		end

	set_y(a_y:INTEGER_16)
		do
			y := a_y
		end

end
