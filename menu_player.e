note
	description: "Sélection du nombre de joueurs et de leurs sprites. Gère aussi les sockets."
	author: "Pascal Belisle"
	date: "Mars 2016"
	revision: "1.0"

class
	MENU_PLAYER

inherit
	ARGUMENTS

	MENU
		rename
			make as make_menu
		redefine
			show, check_button
		end

create
	make

feature {NONE} -- Initialisation

	make (a_image_factory: IMAGE_FACTORY; a_socket:NETWORK_STREAM_SOCKET)
			-- <Precursor>
		do
			make_menu(a_image_factory)
			socket := a_socket

			create button_add_player.make (image_factory.buttons[7], 80, 510)
			create button_add_connexion.make (image_factory.buttons[8], 80, 589)
			create button_go.make (image_factory.buttons[10], 434, 510)
			create {ARRAYED_LIST[BOOLEAN]} available_sprites.make (5)
			create {ARRAYED_LIST[ANIMATED_SPRITE]} sprite_preview_surface_list.make (5)
			create background.make (image_factory.backgrounds[2], 0, 0)
			create {ARRAYED_LIST[PLAYER_SELECT_SUBMENU]} player_select_submenus.make(4)
			create {ARRAYED_LIST[SOCKET]} sockets.make (3)
			across 1 |..| 5 as la_index loop
				available_sprites.extend (True)
				sprite_preview_surface_list.extend(create {ANIMATED_SPRITE} .make (image_factory.players.at (la_index.item)[1], 22, 10, 0, 0))
			end
			button_add_player.on_click_actions.extend (agent add_player(True))
			buttons.extend(button_add_player)
			on_screen_sprites.extend(background)
			on_screen_sprites.extend(button_add_connexion)
			button_go.on_click_actions.extend (agent check_ok)
			if a_socket.is_bound then
				buttons.extend(button_add_connexion)
				button_add_connexion.on_click_actions.extend (agent add_player(False))
			else
				button_add_connexion.current_surface := image_factory.buttons[12]
			end
			buttons.extend (button_go)

			on_screen_sprites.extend(button_add_player)
			on_screen_sprites.extend(button_go)
			add_player (True)
			to_connect := 0
		end

feature

	socket: NETWORK_STREAM_SOCKET
			-- permet d'obtenir des connexions de client

	player_select_submenus: LIST[PLAYER_SELECT_SUBMENU]
			-- Contient les choix des personnages des usagers

	available_sprites: LIST[BOOLEAN]
			-- True si un sprite est disponible à l'index

	sprite_preview_surface_list: LIST[ANIMATED_SPRITE]
			-- Contient les sprites affichés par les sous-menus de `player_select_submenus'

	connexion: detachable CONNEXION_THREAD
		-- Si l'utilisateur créer un joueur réseau, on crée un thread qui attend la connection du client

	button_add_player: BUTTON
	button_add_connexion: BUTTON
	button_go: BUTTON
			-- Les boutons du menu

	sockets: LIST[SOCKET]
			-- Les connections des {PLAYER_NETWORK}

	to_connect:INTEGER
			-- Le nombre de joueur en réseau, donc le nombre de connection à créer

	waiting_for_connexion
			-- Créer la connexion du {PLAYER_NETWORK}
			-- La fonction a été pensée pour permettre l'ajout de plusieurs {PLAYER_NETWORK} mais
			-- nous n'en permettons seulement 1 pour l'instant.
		local
			i: INTEGER
			l_connexion: CONNEXION_THREAD
			l_finish: BOOLEAN
		do
			if attached connexion as la_connexion then
				if la_connexion.is_done then
					if attached la_connexion.client_socket as la_socket then
						sockets.extend (la_socket)
					end
					la_connexion.yield
					connexion := Void
					to_connect := to_connect - 1
					if to_connect ~ 0 then
						button_go.enabled := true
					end
					from i := 1	until (i > player_select_submenus.count) or l_finish loop
						if (not player_select_submenus[i].is_local) and (not player_select_submenus[i].is_connected) then
							player_select_submenus[i].type_image.set_surface (image_factory.player_choice_menu[8])
							player_select_submenus[i].is_connected := true
							l_finish := true
						end
						i := i + 1
					end
					la_connexion.is_done := False
				end
			else
				if to_connect > 0 then
					create l_connexion.make (socket)
					connexion := l_connexion
					l_connexion.launch
				end
			end
		end

	is_go_selected: BOOLEAN
		do
			Result := choice = Menu_choice_go
		end

	add_player(a_is_local: BOOLEAN)
			-- Ajoute un objet {PLAYER_SELECT_SUBMENU} à `player_select_submenus' selon le `a_type'
		local
			l_x, l_y, l_count: INTEGER
		do
			l_count := player_select_submenus.count
			if l_count < 4 then
				inspect l_count
				when 0 then
					l_x := 80
					l_y := 130
				when 1 then
					l_x := 340
					l_y := 130
				when 2 then
					l_x := 80
					l_y := 318
				else
					l_x := 340
					l_y := 318
				end
				if a_is_local then
					player_select_submenus.extend (create {PLAYER_SELECT_SUBMENU} .make (l_count + 1, image_factory, l_x, l_y, available_sprites, sprite_preview_surface_list, a_is_local))
				elseif sockets.is_empty and (to_connect < 1) then
					player_select_submenus.extend (create {PLAYER_SELECT_SUBMENU} .make (l_count + 1, image_factory, l_x, l_y, available_sprites, sprite_preview_surface_list, a_is_local))
					to_connect := to_connect + 1
					player_select_submenus.last.btn_cancel.enabled := False
					button_go.enabled := false
				end
			end
		ensure
			new_player_added:  (old player_select_submenus.count < 4) and (sockets.is_empty and (to_connect < 1)) implies player_select_submenus.count = old player_select_submenus.count + 1
			new_player_not_over:  old player_select_submenus.count >= 4 implies player_select_submenus.count = old player_select_submenus.count
		end

	get_players:LIST[PLAYER]
			-- Créer et retourne la liste des {PLAYER} choisis
		local
			i, l_x, l_y, l_count, l_item_index, l_socket_index: INTEGER
		do
			l_count := player_select_submenus.count
			l_socket_index := 1
			l_item_index := 1
			create {ARRAYED_LIST[PLAYER]} Result.make (l_count)
			across player_select_submenus as la_players loop
				inspect la_players.item.index
					when 1 then
						l_x := 79
						l_y := 56
					when 2 then
						l_x := 583
						l_y := 56
					when 3 then
						l_x := 79
						l_y := 560
					else
						l_x := 583
						l_y := 560
				end
				if la_players.item.is_local then
					Result.extend (create {PLAYER} .make (image_factory, la_players.item.current_sprite_index, l_x, l_y, la_players.item.index,
								  						   create {SCORE_SURFACE}.make (create{GAME_SURFACE}.make (1, 1), 1, 1, 0, image_factory)))
				else
					Result.extend (create {PLAYER_NETWORK} .make (image_factory, la_players.item.current_sprite_index, l_x, l_y, la_players.item.index,
																  create {SCORE_SURFACE}.make (create{GAME_SURFACE}.make (1, 1), 1, 1, 0, image_factory), sockets[l_socket_index]))
					l_socket_index := l_socket_index + 1
				end
				from
					i := 1
				until
					i > (24 // l_count)
				loop
					Result.last.items_to_find.extend (l_item_index)
					l_item_index := l_item_index + 1
					i := i + 1
				end
				Result.last.items_to_find.extend (la_players.item.current_sprite_index + 24)
			end
		end

	update_player_select_submenus(a_index: INTEGER):LIST[PLAYER_SELECT_SUBMENU]
			-- Recréer et retourne une liste de `PLAYER_SELECT_SUBMENU' sans celui cancellé
		local
			l_x, l_y, i: INTEGER
			l_skipped: BOOLEAN
		do
			i := 1
			create {ARRAYED_LIST[PLAYER_SELECT_SUBMENU]} Result.make (4)
			across player_select_submenus as la_list loop
				if i = a_index and not l_skipped then
					l_skipped := True
				else
					inspect i
						when 1 then
							l_x := 80
							l_y := 130
						when 2 then
							l_x := 340
							l_y := 130
						when 3 then
							l_x := 80
							l_y := 318
						else
							l_x := 340
							l_y := 318
					end
					la_list.item.update_coordinates(l_x, l_y, i)
					Result.extend (la_list.item)
					i := i + 1
				end
			end
		end

	check_cancellation
			-- On vérifie si le joueur a cancellé un {PLAYER_SELECT_SUBMENU}
		do
			across player_select_submenus as la_player_select_submenus loop
				if la_player_select_submenus.item.is_cancel_selected then
					player_select_submenus := update_player_select_submenus(la_player_select_submenus.item.index)
					available_sprites[la_player_select_submenus.item.current_sprite_index] := True
--					if not la_player_select_submenus.item.is_local then
--						to_connect := to_connect - 1
--						if to_connect ~ 0 then
--							if attached connexion as la_connexion then
--								la_connexion.yield
--							end
--							connexion := Void
--						end
--					end
				end
			end
		end

	show(a_game_window:GAME_WINDOW_SURFACED)
		do
			precursor(a_game_window)
			check_cancellation
			across player_select_submenus as la_player_select_submenus loop
				la_player_select_submenus.item.show (a_game_window)
			end
		end

	check_button (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- On ajoute une vérification pour les sous-menus
		do
			Precursor (a_mouse_state)
			across player_select_submenus as la_list loop
				la_list.item.check_button(a_mouse_state)
			end
		end

	check_ok
		-- On valide qu'il n'y a aucune connection en cours avant de débuter la partie
		do
			if to_connect = 0 then
				set_choice(Menu_choice_go)
			end
		end

feature {NONE} -- Constants

	Menu_choice_go: INTEGER = 1

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
