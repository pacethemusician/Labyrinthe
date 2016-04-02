note
	description: "Menu pour sélectionner le nombre de joueurs"
	author: "Pascal Belisle"
	date: "Mars 2016"
	revision: ""

class
	MENU_PLAYER

inherit
	MENU
		redefine
			make, show, check_btn
		end

create
	make

feature {NONE} -- Initialisation

	make (a_image_factory: IMAGE_FACTORY)
		do
			Precursor(a_image_factory)
			create btn_add_player.make (image_factory.buttons[7], 80, 510)
			create btn_add_connexion.make (image_factory.buttons[8], 80, 589)
			create btn_go.make (image_factory.buttons[10], 434, 510)

			create {ARRAYED_LIST[BOOLEAN]} available_sprites.make (5)
			available_sprites.extend (True)
			available_sprites.extend (True)
			available_sprites.extend (True)
			available_sprites.extend (True)
			available_sprites.extend (True)

			create background.make (image_factory.backgrounds[2], 0, 0)
			create {ARRAYED_LIST[PLAYER_SELECT_SUBMENU]} player_select_submenus.make(4)

			create {ARRAYED_LIST[ANIMATED_SPRITE]} sprite_preview_surface_list.make (5)
			sprite_preview_surface_list.extend(create {ANIMATED_SPRITE} .make (image_factory.players.at (1)[1], 22, 10, 0, 0))
			sprite_preview_surface_list.extend(create {ANIMATED_SPRITE} .make (image_factory.players.at (2)[1], 22, 10, 0, 0))
			sprite_preview_surface_list.extend(create {ANIMATED_SPRITE} .make (image_factory.players.at (3)[1], 22, 10, 0, 0))
			sprite_preview_surface_list.extend(create {ANIMATED_SPRITE} .make (image_factory.players.at (4)[1], 22, 10, 0, 0))
			sprite_preview_surface_list.extend(create {ANIMATED_SPRITE} .make (image_factory.players.at (5)[1], 22, 10, 0, 0))

			-- Action des boutons:
			btn_add_player.on_click_actions.extend (agent add_player)
			btn_go.on_click_actions.extend (agent start_game)
			buttons.extend(btn_add_player)

			buttons.extend (btn_go)
			on_screen_sprites.extend(background)
			on_screen_sprites.extend(btn_add_player)
			on_screen_sprites.extend(btn_add_connexion)
			on_screen_sprites.extend(btn_go)

			add_player

		end

feature {GAME_ENGINE} -- Implementation

	player_select_submenus: LIST[PLAYER_SELECT_SUBMENU]
	available_sprites: LIST[BOOLEAN]
	sprite_preview_surface_list: LIST[ANIMATED_SPRITE]
	btn_add_player, btn_add_connexion: BUTTON
	btn_go: BUTTON

	is_go_selected: BOOLEAN assign set_is_go_selected

	set_is_go_selected (a_value: BOOLEAN)
		do
			is_go_selected := a_value
		end

	add_player
		-- Ajoute un objet `PLAYER_SELECT_SUBMENU' à `player_select_submenus'
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
				player_select_submenus.extend (create {PLAYER_SELECT_SUBMENU} .make (l_count + 1, image_factory, l_x, l_y, available_sprites, sprite_preview_surface_list))
			end
		end

	get_players:LIST[PLAYER]
		local
			l_count: INTEGER
		do
			l_count := player_select_submenus.count
			create {ARRAYED_LIST[PLAYER]} Result.make (l_count)
			across player_select_submenus as la_players loop
				Result.extend (create {PLAYER} .make (image_factory.players[la_players.item.index], 0, 0))
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
			-- On vérifie si le joueur a cancellé un `PLAYER_SELECT_SUBMENU'
		do
			across player_select_submenus as la_player_select_submenus loop
				if la_player_select_submenus.item.is_cancel_selected then
					player_select_submenus := update_player_select_submenus(la_player_select_submenus.item.index)
					available_sprites[la_player_select_submenus.item.current_sprite_index] := True
				end
			end
		end

	show(a_game_window:GAME_WINDOW_SURFACED)
		do
			Precursor (a_game_window)
			check_cancellation
			across player_select_submenus as la_player_select_submenus loop
				la_player_select_submenus.item.show (a_game_window)
			end
		end

	set_is_done (new_value: BOOLEAN)
		do
			is_done := new_value
		end

	start_game
		do
			is_done := True
			is_go_selected := True
		end

	on_mouse_move(a_mouse_state: GAME_MOUSE_MOTION_STATE)
		do
		end

	check_btn (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- On ajoute une vérification pour les sous-menus
		do
			Precursor (a_mouse_state)
			across player_select_submenus as la_list loop
				la_list.item.check_btn(a_mouse_state)
			end
		end

end
