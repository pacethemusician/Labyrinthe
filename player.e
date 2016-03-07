note
	description: "Pion d'un joueur et ses informations"
	author: "Pascal Belisle et Charles Lemay"
	date: "18 février 2016"
	revision: "0.1"

class
	PLAYER

inherit
	ANIMATED_SPRITE
		rename
			make as make_animated_sprite
		end

create
	make

feature {NONE} -- Initialisation

	make (a_surfaces: LIST[GAME_SURFACE]; a_x, a_y:INTEGER_32)
		-- Les `a_type' sont 1= explorateur 2= magicien
		do
			animations := a_surfaces
			make_animated_sprite (a_surfaces[1], 22, 5, a_x, a_y)
		end

feature {NONE} -- Implementation
	animations : LIST[GAME_SURFACE]

end
