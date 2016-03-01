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

	make (a_default_surface: GAME_SURFACE)
			-- Initialisation de `current' avec l'animation `default_animation'.
		do
			current_surface := a_default_surface
			x := 0
			y := 0
		end

feature {GAME_ENGINE} -- Implementation

	draw_self (destination_surface: GAME_SURFACE)
			-- Dessiner `current' sur `destination_surface'.
		do
			destination_surface.draw_surface (current_surface, x, y)
		end

	approach_point (a_x, a_y, a_speed:INTEGER_32)
			-- Approche `current' du point (`a_x', `a_y').
			-- La vitesse horizontale et verticale sont idépendantes
			-- l'une de l'autre et valent, au plus, `a_speed'.
		do
			x := x + (a_speed.min ((x - a_x).abs) * a_x.three_way_comparison (x))
			y := y + (a_speed.min ((y - a_y).abs) * a_y.three_way_comparison (y))
		end

	set_x (a_x: INTEGER_32)
			-- Assigne `a_x' à `x'.
		do
			x := a_x
		ensure
			Is_Assign: x = a_x
		end

	set_y (a_y: INTEGER_32)
			-- Assigne `a_y' à `y'.
		do
			y := a_y
		ensure
			Is_Assign: y = a_y
		end

	set_surface (a_surface: GAME_SURFACE)
		do
			current_surface := a_surface
		end

feature {GAME_ENGINE} -- Attributs

	x: INTEGER_32 assign set_x
			-- La position horizontale du `current'.

	y: INTEGER_32 assign set_y
			-- La position verticale de `current'.

	current_surface: GAME_SURFACE assign set_surface
			-- L'animation actuelle de `current'. C'est cette animation qui est affichée.

end
