note
	description: "Summary description for {MENU_TITLE_SCREEN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MENU_TITLE_SCREEN

inherit
	MENU

create
	make

feature {NONE} -- Initialisation

	make (a_game_surfaces: IMAGE_FACTORY)
		do
			choice := ""
			game_surfaces := a_game_surfaces
			create btn_create_game.make (game_surfaces.buttons[3], 60, 230)
			create btn_join_game.make (game_surfaces.buttons[4], 60, 340)
			create background.make (game_surfaces.backgrounds[2])
			-- Action des boutons:
			btn_create_game.on_click_actions.extend (agent set_choice("menu_player"))
			btn_join_game.on_click_actions.extend (agent set_choice("menu_join"))
		end

feature {GAME_ENGINE} -- Implementation

	btn_create_game, btn_join_game: BUTTON

	show(a_timestamp:NATURAL_32; game_window:GAME_WINDOW_SURFACED)
		do
			background.draw_self (game_window.surface)
			btn_create_game.draw_self (game_window.surface)
			btn_join_game.draw_self (game_window.surface)
			-- game_window.surface.draw_surface (text_image, 10, 10)
		end

	check_btn(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
		-- déclanche l'action des boutons s'il y a click
		do
			btn_create_game.execute_actions (a_mouse_state)
			btn_join_game.execute_actions (a_mouse_state)
		end

	set_choice(a_str: STRING)
		-- Assigne le choix de l'usager à `choice'
		-- `a_str' doit être "menu_player" ou "menu_join"
		do
			done := true
			choice := a_str
		end

end
