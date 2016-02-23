note
	description : "projetLabyrinthe application root class"
	date        : "15 Février 2016"

class
	GAME_ENGINE

inherit
	ARGUMENTS
	GAME_LIBRARY_SHARED
	IMG_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialisation

	make
			-- Lance l'application.
		do
			game_library.enable_video
			image_file_library.enable_image (true, false, false)
			run_game
			image_file_library.quit_library
			game_library.quit_library
		end

	run_game
			-- Crée les ressources et lance le jeu
		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_window:GAME_WINDOW_SURFACED
		do
			create on_screen_sprites.make

			create l_window_builder
			l_window_builder.set_dimension (Window_width, Window_height)
			l_window_builder.set_title ("Shameless labyrinthe clone")
			l_window := l_window_builder.generate_window
			game_library.quit_signal_actions.extend (agent on_quit(?))
			game_library.iteration_actions.extend (agent on_iteration(?, l_window))
			-- https://www.eiffelgame2.org/Documentation/game_core/event/game_window_events_chart.html
			l_window.mouse_button_pressed_actions.extend (agent on_mouse_pressed(?,?,?))
			l_window.mouse_button_released_actions.extend (agent on_mouse_released(?,?,?))
			game_library.launch
		end

feature {NONE} -- Implementation

	on_iteration(a_timestamp:NATURAL_32; game_window:GAME_WINDOW_SURFACED)
			-- Event that is launch at each iteration.
		do
			across
				on_screen_sprites as l_sprites
			loop
				l_sprites.item.draw_self (game_window.surface)
            end
		end

	on_quit(a_timestamp: NATURAL_32)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			game_library.stop  -- Stop the controller loop (allow game_library.launch to return)
		end

	on_mouse_pressed(a_timestamp: NATURAL_32; mouse_state:GAME_MOUSE_BUTTON_PRESSED_STATE; nb_clicks:NATURAL_8)
		do

		end

	on_mouse_released(a_timestamp: NATURAL_32; mouse_state:GAME_MOUSE_BUTTON_RELEASED_STATE; nb_clicks:NATURAL_8)
		do

		end

	on_screen_sprites: LINKED_LIST[SPRITE]

feature {NONE} -- Constants

	Window_width:NATURAL_16 = 1000
		-- La largeur de la fenêtre

	Window_height:NATURAL_16 = 700
		-- La hauteur de la fenêtre

end

