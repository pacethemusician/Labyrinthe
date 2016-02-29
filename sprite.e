note
	description: "Oject ayant une animation et des coordonnées qui peut être affiché."
	author: "Pascal Belisle et Charles Lemay"
	date: "15 Février 2016"
	revision: None

class
	SPRITE

create
	make

feature {NONE} -- Initialisation

	make (default_animation: ANIMATION)
			-- Initialisation de `current' avec l'animation `default_animation'.
		do
			current_animation := default_animation
			animation_timer := 0
			x := 0
			y := 0
		end

feature {GAME_ENGINE} -- Implementation

	draw_self (destination_surface: GAME_SURFACE)
			-- Dessiner `current' sur `destination_surface'.
		local
			l_frame_width: INTEGER_32
			l_frame_offset: INTEGER_32
		do
			l_frame_width := current_animation.frames.width // current_animation.frame_number
			l_frame_offset := l_frame_width * (animation_timer // current_animation.delay)
			destination_surface.draw_sub_surface (current_animation.frames, l_frame_offset, 0, l_frame_width, current_animation.frames.height, x, y)
		end

	set_timer (a_time: INTEGER_32)
			-- Assigne `a_time' à `animation_timer'.
		do
			animation_timer := a_time \\ (current_animation.frame_number * current_animation.delay)
			if animation_timer < 0 then
				animation_timer := - animation_timer
			end
		end

	set_animation (a_animation: ANIMATION)
			-- Assigne `a_animation' à `current_animation'.
		do
			current_animation := a_animation
		end

	set_x (a_x: INTEGER_16)
			-- Assigne `a_x' à `x'.
		do
			x := a_x
		ensure
			Is_Assign: x = a_x
		end

	set_y (a_y: INTEGER_16)
			-- Assigne `a_y' à `y'.
		do
			y := a_y
		ensure
			Is_Assign: y = a_y
		end

feature {GAME_ENGINE} -- Attributs

	x: INTEGER_16 assign set_x
			-- La position horizontale du `current'.

	y: INTEGER_16 assign set_y
			-- La position verticale de `current'.

	current_animation: ANIMATION assign set_animation
			-- L'animation actuelle de `current'. C'est cette animation qui est affichée.

	animation_timer: INTEGER_32 assign set_timer
			-- Timer qui indique l'avancement de `current_animation'.

end
