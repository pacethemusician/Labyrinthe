note
	description: "Summary description for {MENU_TITLE_SCREEN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MENU_TITLE_SCREEN

inherit
	MENU
		redefine
			make
		end

create
	make

feature {NONE} -- Initialisation

	make (a_image_factory: IMAGE_FACTORY)
		do
			Precursor(a_image_factory)
			create btn_create_game.make (image_factory.buttons[3], 60, 230)
			create btn_join_game.make (image_factory.buttons[4], 60, 340)
			create background.make (image_factory.backgrounds[2], 0, 0)
			-- Action des boutons:
			btn_create_game.on_click_actions.extend (agent set_choice(Menu_player_choice))
			btn_join_game.on_click_actions.extend (agent set_choice(Menu_join_choice))

			buttons.extend(btn_create_game)
			buttons.extend(btn_join_game)

			on_screen_sprites.extend(background)
			on_screen_sprites.extend(btn_create_game)
			on_screen_sprites.extend(btn_join_game)
		end

feature		 -- Implementation

	btn_create_game, btn_join_game: BUTTON

	is_menu_player_chosen:BOOLEAN
		do
			Result := choice = Menu_player_choice
		end

	is_menu_join_chosen:BOOLEAN
		do
			Result := choice = Menu_join_choice
		end

feature {NONE} -- Constants

	Menu_player_choice:INTEGER = 1

	Menu_join_choice:INTEGER = 2

end
