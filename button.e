note
	description: "Summary description for {BUTTON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BUTTON

inherit
	SPRITE
		rename
			make as make_sprite
		end

create
	make

feature -- Initialisation

	make (a_default_surface: GAME_SURFACE; a_x, a_y: INTEGER_32)
		do
			make_sprite (a_default_surface, a_x, a_y)
			-- a_default_surface.height
			-- a_default_surface.width
		end

feature -- implementation


end
