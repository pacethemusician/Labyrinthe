note
	description : "Projet Labyrinthe application root class"
	author: "Pascal Belisle et Charles Lemay"
	date: "Session Hiver 2016"
	version: "2.0"

class
	GAME_ENGINE

inherit
	GAME_LIBRARY_SHARED
	AUDIO_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialisation

	make
		-- Créer les ressources et lance le jeu.
		-- "Gérer les erreurs!!!!!"

		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_window:GAME_WINDOW_SURFACED
			l_music_file:AUDIO_SOUND_FILE
		do
			create l_window_builder
			l_window_builder.set_dimension (Window_width, Window_height)
			l_window_builder.set_title ("Shameless labyrinthe clone")
			l_window := l_window_builder.generate_window

			-- Création de la musique
			audio_library.sources_add
			music_source := audio_library.last_source_added
			create l_music_file.make("Audio/Solitaire.ogg")
			if l_music_file.is_openable then
				l_music_file.open
				if l_music_file.is_open then
					music_source.queue_sound_infinite_loop (l_music_file)
					music_source.play
				else
					print("Cannot open sound file.")
				end
			else
				print("Sound file not valid.")
			end

			create image_factory.make
			create {ARRAYED_LIST[PLAYER]} players.make (4)
			create {MENU_TITLE_SCREEN} current_engine.make (image_factory)

			-- Création des agents:
			game_library.quit_signal_actions.extend (agent on_quit(?))
			game_library.iteration_actions.extend (agent on_iteration(?, l_window))
			l_window.mouse_button_pressed_actions.extend (agent on_mouse_pressed(?,?,?))
			l_window.mouse_button_released_actions.extend (agent on_mouse_released(?,?,?))
			l_window.mouse_motion_actions.extend (agent on_mouse_move(?, ?, ?, ?))

			game_library.launch

		end


feature {NONE} -- Implementation

	music_source: AUDIO_SOURCE

	players: LIST[PLAYER]

	image_factory: IMAGE_FACTORY
		-- Contient toutes les images du projet
	current_engine:ENGINE
		-- Pointe vers l'engin en court (différents menus et jeu)

	on_iteration(a_timestamp:NATURAL_32; a_game_window:GAME_WINDOW_SURFACED)
			-- À faire à chaque iteration.
		do
			if attached {MENU_TITLE_SCREEN} current_engine as la_menu_title_screen then
				if not la_menu_title_screen.is_done then
					la_menu_title_screen.show(a_game_window)
				else
					if la_menu_title_screen.is_menu_player_chosen then
						current_engine := create {MENU_PLAYER}.make(image_factory)
					elseif la_menu_title_screen.is_menu_join_chosen then
						current_engine := create {MENU_JOIN}.make(image_factory)
					end
				end
			elseif attached {MENU_PLAYER} current_engine as la_menu_player then
				if not la_menu_player.is_done then
					la_menu_player.show (a_game_window)
				else
					if la_menu_player.is_go_selected then
						players := la_menu_player.get_players
						current_engine := create {BOARD_ENGINE}.make(image_factory, players, a_game_window)

					-- elseif la_menu_player.is_cancel_selected then
						-- À faire...
					end
				end
			elseif attached {MENU_JOIN} current_engine as la_menu_join then
				la_menu_join.show(a_game_window)
			end
			if attached {BOARD_ENGINE} current_engine as la_board_engine then
				la_board_engine.update
			else
				-- On update `a_game_window' seulement si `current_engine' n'est pas un
				-- {BOARD_ENGINE}, parce que dans ce cas là, c'est un {THREAD} qui s'en occupe.
				a_game_window.update
			end
            audio_library.update
		end

	on_quit(a_timestamp: NATURAL_32)
			-- Méthode appelée si l'utilisateur quitte la partie (par ex. en fermant la fenêtre).
		do
			if attached {BOARD_ENGINE} current_engine as la_board_engine then
				la_board_engine.thread.must_stop := true
			end
			game_library.stop  -- Stop the controller loop (allow game_library.launch to return)
		end

	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state:GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks:NATURAL_8)
			-- Méthode appelée lorsque le joueur appuie sur un bouton de la souris.
		do
			current_engine.check_button(a_mouse_state)
		end

	on_mouse_released(a_timestamp: NATURAL_32; a_mouse_state:GAME_MOUSE_BUTTON_RELEASED_STATE; a_nb_clicks:NATURAL_8)
			-- Méthode appelée lorsque le joueur relâche un bouton de la souris.
		do
			if attached {BOARD_ENGINE} current_engine as la_board_engine then
				la_board_engine.on_mouse_released(a_mouse_state)
			end
		end

	on_mouse_move(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_MOTION_STATE; a_delta_x, a_delta_y: INTEGER_32)
			-- Routine de mise à jour du drag and drop
		do
			if attached {BOARD_ENGINE} current_engine as la_board_engine then
				la_board_engine.on_mouse_move(a_mouse_state)
			end
		end

feature {NONE} -- Constantes

	Window_width:NATURAL_16 = 1000
		-- La largeur de la fenêtre en pixels.

	Window_height:NATURAL_16 = 700
		-- La hauteur de la fenêtre en pixels.

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
