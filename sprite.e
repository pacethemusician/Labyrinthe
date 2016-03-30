note
	description: "Objet pouvant être affiché selon ses coordonnées."
	author: "Pascal Belisle et Charles Lemay"
	date: "15 Février 2016"
	revision: "0.2"

class
	SPRITE

create
	make
	
feature {NONE} -- Initialisation

	make (a_default_surface: GAME_SURFACE; a_x, a_y: INTEGER_32)
			-- Initialisation de `current' avec `a_default_surface' à la position (`a_x', `a_y').
		do
			current_surface := a_default_surface
			set_x(a_x)
			set_y(a_y)
		end

feature -- Implementation

	draw_self (destination_surface: GAME_SURFACE)
			-- Dessiner `current' sur `destination_surface'.
		do
			destination_surface.draw_surface (current_surface, x, y)
		end

	approach_point (a_x, a_y, a_speed:INTEGER_32)
			-- Approche `current' du point (`a_x', `a_y') d'un maximum de
			-- `a_speed' verticalement et horizontalement.
		require
			speed_over_zero: a_speed > 0
		do
			x := x + (a_speed.min ((x - a_x).abs) * a_x.three_way_comparison (x))
			y := y + (a_speed.min ((y - a_y).abs) * a_y.three_way_comparison (y))
		end

	set_x (a_x: INTEGER_32)
			-- Assigne `a_x' à `x'.
		do
			x := a_x
		ensure
			is_assign: x = a_x
		end

	set_y (a_y: INTEGER_32)
			-- Assigne `a_y' à `y'.
		do
			y := a_y
		ensure
			is_assign: y = a_y
		end

	set_surface (a_surface: GAME_SURFACE)
			-- Assigne `a_surface' à `current_surface'.
		do
			current_surface := a_surface
		ensure
			is_assign: current_surface = a_surface
		end

feature -- Attributs

	x: INTEGER_32 assign set_x
			-- La position horizontale du `current'.

	y: INTEGER_32 assign set_y
			-- La position verticale de `current'.

	current_surface: GAME_SURFACE assign set_surface
			-- La surface actuelle de `current'. C'est cette image qui est affichée.

end
