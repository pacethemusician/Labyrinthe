note
	description: "Classe pour objet ayant une image et coordonnées x, y {SPRITE}."
	author: "Pascal Belisle"
	date: "15 Février 2016"
	revision: None

class
	SPRITE

inherit

create
	make

feature {NONE}	-- Initialisation
	make
		do

		end

feature {NONE}	-- Declaration des arguments
	x:INTEGER_16
	y:INTEGER_16
	current_animation:ANIMATION
	current_frame:NATURAL_8

feature {NONE}	-- Implementation
	draw_self
		do

		end


end
