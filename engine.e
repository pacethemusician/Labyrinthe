note
	description: "Summary description for {ENGINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENGINE

feature {NONE} -- Initialization

	make (a_image_factory: IMAGE_FACTORY)
		do
			image_factory := a_image_factory
			create {LINKED_LIST[SPRITE]} on_screen_sprites.make
		end


feature {GAME_ENGINE} -- Implementation

	image_factory: IMAGE_FACTORY

	on_screen_sprites: LIST[SPRITE]
		-- Liste des sprites à afficher.

	check_btn(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- déclanche l'action des boutons s'il y a click
		deferred

		end

	on_mouse_move(

	show(a_game_window:GAME_WINDOW_SURFACED)
		do
			across on_screen_sprites as la_sprites  loop
				la_sprites.item.draw_self (a_game_window.surface)
			end
		end
end
