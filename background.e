note
	description: "S'occupe des �l�ments d'arri�re-plan (musique et image)."
	author: "Pascal Belisle"
	date: "29 f�vrier"
	revision: "0.1"

class
	BACKGROUND

inherit
	SPRITE
		rename
			make as make_sprite
		end

create
	make

feature {NONE} -- Initialisation

	make (a_surface:GAME_SURFACE)
			-- Initialise `current' avec la surface `a_surface' � la position (0, 0).
		do
			make_sprite(a_surface, 0, 0)
		end

end
