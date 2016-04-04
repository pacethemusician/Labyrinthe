note
	description: "Sprite éxécutant une liste de routine lors qu'on clique dessus."
	author: "Charles Lemay"
	date: "22 mars 2016"

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
			-- Initialisation de `current' avec `a_default_surface' à la position (`a_x', `a_y').
		do
			make_sprite (a_default_surface, a_x, a_y)
			create on_click_actions.make
		end

feature -- implementation

	on_click_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE]]
		-- Liste de procédures éxécutées par `current' quand on clique dessus.

	execute_actions(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Execute les routines de on_click_actions si la souris est au dessus de `current'.
		do
			if (a_mouse_state.x >= x) and (a_mouse_state.x < (x + current_surface.width))
			and (a_mouse_state.y >= y) and (a_mouse_state.y < (y + current_surface.height)) then
				across on_click_actions as l_actions loop
					l_actions.item.call
				end
			end
		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
