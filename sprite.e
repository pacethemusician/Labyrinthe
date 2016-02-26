note
	description: "Classe pour objet ayant une image et coordonn�es x, y {SPRITE}."
	author: "Pascal Belisle"
	date: "15 F�vrier 2016"
	revision: None

class
	SPRITE

create
	make

feature {NONE}	-- Initialisation

	make (default_animation:ANIMATION)
		do
			current_animation := default_animation
			animation_timer := 0
			x := 0
			y := 0
		end

feature {GAME_ENGINE}	-- Declaration des arguments

	x:INTEGER_16 assign set_x
		-- La position horizontale du `current'.

	y:INTEGER_16 assign set_y
		-- La position verticale de `current'.

	current_animation:ANIMATION assign set_animation
		-- L'animation actuelle de `current'. C'est cette animation qui est affich�e.

	animation_timer:INTEGER_32 assign set_timer
		-- Timer qui indique l'avancement de `current_animation'.

feature {GAME_ENGINE}	-- Implementation

	draw_self(destination_surface:GAME_SURFACE)
		-- Dessiner `current' sur `destination_surface'.
		local
			l_frame_width:INTEGER_32
			l_frame_offset:INTEGER_32
		do
			l_frame_width := current_animation.frames.width // current_animation.frame_number
			l_frame_offset := l_frame_width * (animation_timer // current_animation.delay)
			destination_surface.draw_sub_surface (current_animation.frames,
				l_frame_offset, 0, l_frame_width, current_animation.frames.height, x, y)
		end

	set_timer(a_time:INTEGER_32)
		do
			animation_timer := a_time \\ (current_animation.frame_number * current_animation.delay)
			if animation_timer < 0 then
				animation_timer := -animation_timer
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
