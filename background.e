note
	description: "S'occupe des éléments d'arrière-plan (musique et image)."
	author: "Pascal Belisle"
	date: "29 février"
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
			-- Initialise `current' avec la surface `a_surface' à la position (0, 0).
		do
			make_sprite(a_surface, 0, 0)
		end

end
