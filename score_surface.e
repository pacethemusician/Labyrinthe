note
	description: "Summary description for {SCORE_SURFACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCORE_SURFACE

inherit
	SPRITE
		rename
			make as make_sprite
		end

create
	make

feature {NONE} -- Initialization

	make (a_default_surface: GAME_SURFACE; a_x, a_y: INTEGER_32)
			-- Surface sur laquelle on inscrit le nombre d'item trouvé
		do
			precursor (a_default_surface, a_x, a_y)
		end

feature

	update (a_found, a_to_find: INTEGER)
			-- Mise à jour de l'affichage du nombre d'item à trouver
		local
			l_new_surface: GAME_SURFACE
		do
			create l_new_surface.make (70, 14)
			
		end

end
