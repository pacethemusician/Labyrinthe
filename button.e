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
			create on_click_actions.make
		end

feature -- implementation

	on_click_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE]]

	execute_actions(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
		do
			if (a_mouse_state.x >= x) and (a_mouse_state.x < (x + current_surface.width))
			and (a_mouse_state.y >= y) and (a_mouse_state.y < (y + current_surface.height)) then
				across on_click_actions as l_actions loop
					l_actions.item.call
				end
			end
		end

end
