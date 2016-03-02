note
	description: "Pion d'un joueur"
	author: "Pascal Belisle et Charles Lemay"
	date: "18 février 2016"
	revision: none

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

	make (a_surfaces: STRING_TABLE[GAME_SURFACE])
		do
			if attached a_surfaces["p1_still"] as la_surface then
				make_animated_sprite (la_surface, 22, 2)
			else
				make_sprite (create {GAME_SURFACE} .make (1, 1))
			end
		end

end
