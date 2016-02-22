note
	description: "Représentation objet de chaque carte chemin sur le plateau {PATH_CARD}."
	author: "Pascal Belisle"
	date: "15 Février 2016"
	revision: none

class
	PATH_CARD

	--inherit
	--SPRITE
	--	redefine
	--		parent_make
	--	end

create
	parent_make

feature {NONE}

	parent_make	-- Constructeur
		do

		end

feature {NONE}

	is_walkable (a_direction: INTEGER): BOOLEAN
		do
		end

	draw_self
		do
				-- "DRAW_ROTATED(`rotation' * 90)"
		end

feature {NONE} -- Attributs

	type: INTEGER

	rotation: INTEGER

	path_table: LIST[NATURAL_8]

	items_on_top: LIST[ITEM]

end
