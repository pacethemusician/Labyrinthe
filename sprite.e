note
	description: "Objet pouvant �tre affich� selon ses coordonn�es."
	author: "Pascal Belisle et Charles Lemay"
	date: "15 F�vrier 2016"
	revision: "0.2"

deferred class
	SPRITE

feature {NONE} -- Initialisation

	make (a_default_surface: GAME_SURFACE; a_x, a_y: INTEGER_32)
			-- Initialisation de `current' avec `a_default_surface' � la position (`a_x', `a_y').
		do
			current_surface := a_default_surface
			set_x(a_x)
			set_y(a_y)
		end

feature {GAME_ENGINE} -- Implementation

	draw_self (destination_surface: GAME_SURFACE)
			-- Dessiner `current' sur `destination_surface'.
		do
			destination_surface.draw_surface (current_surface, x, y)
		end



	set_x (a_x: INTEGER_32)
			-- Assigne `a_x' � `x'.
		do
			x := a_x
		ensure
			is_assign: x = a_x
		end

	set_y (a_y: INTEGER_32)
			-- Assigne `a_y' � `y'.
		do
			y := a_y
		ensure
			is_assign: y = a_y
		end

	set_surface (a_surface: GAME_SURFACE)
			-- Assigne `a_surface' � `current_surface'.
		do
			current_surface := a_surface
		ensure
			is_assign: current_surface = a_surface
		end

feature {GAME_ENGINE, BOARD} -- Attributs

	x: INTEGER_32 assign set_x
			-- La position horizontale du `current'.

	y: INTEGER_32 assign set_y
			-- La position verticale de `current'.

	current_surface: GAME_SURFACE assign set_surface
			-- La surface actuelle de `current'. C'est cette image qui est affich�e.

end
