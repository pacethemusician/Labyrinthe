note
	description: "La carte que le joueur doit placer."
	author: "Pascal Belisle"
	date: "Session Hiver 2016"
	revision: "0.1"

class
	SPARE_PATH_CARD

inherit
	PATH_CARD
		rename
			make as make_path_card
		undefine
			set_surface
		end

	BUTTON
		rename
			make as make_button
		undefine
			draw_self, execute_actions
		end

create
	make

feature {NONE}

	make (a_type: INTEGER_32; a_image_factory: IMAGE_FACTORY; a_x, a_y, a_rotation, a_item_index: INTEGER_32)
			-- Initialisation de `current', de type `a_type' avec les images de `a_image_factory' aux coordonnées `a_x', `a_y'
		do
			make_button(create {GAME_SURFACE}.make (1, 1), a_x, a_y)
			make_path_card(a_type, a_image_factory, a_x, a_y, a_rotation, a_item_index)
		end

feature

	execute_actions (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- <Precursor>
		do
			if (a_mouse_state.x >= x) and (a_mouse_state.x < (x + current_surface.width)) and (a_mouse_state.y >= y) and (a_mouse_state.y < (y + current_surface.height)) then
				across
					on_click_actions as l_actions
				loop
					l_actions.item.call(a_mouse_state)
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
