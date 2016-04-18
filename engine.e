note
	description: "Classe abstraite pour défénir la base des engins (menus et jeu)"
	author: "Pascal Belisle"
	date: "Mars 2016"
	revision: ""

deferred class
	ENGINE

feature {NONE} -- Initialization

	make (a_image_factory: IMAGE_FACTORY)
			-- Initialisation de `Current' assignant `a_image_factory' à `image_factory'
		do
			image_factory := a_image_factory
			create {LINKED_LIST[SPRITE]} on_screen_sprites.make
		end


feature -- Implementation

	image_factory: IMAGE_FACTORY

	on_screen_sprites: LIST[SPRITE]
		-- Liste des sprites à afficher.

	check_button(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- déclanche l'action des boutons s'il y a click
		deferred
		end

	show(a_game_window:GAME_WINDOW_SURFACED)
		do
			across on_screen_sprites as la_on_screen_sprites  loop
				la_on_screen_sprites.item.draw_self (a_game_window.surface)
			end
			a_game_window.update
		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
