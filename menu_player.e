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
			make, show
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
			create background.make (image_factory.backgrounds[2], 0, 0)
			create {ARRAYED_LIST[PLAYER_SELECT_SUBMENU]} player_select_submenus.make(4)

			create {ARRAYED_LIST[GAME_SURFACE]} sprite_preview_surface_list.make (5)
			sprite_preview_surface_list.extend(image_factory.player_choice_menu[8])
			sprite_preview_surface_list.extend(image_factory.player_choice_menu[9])
			sprite_preview_surface_list.extend(image_factory.player_choice_menu[10])
			sprite_preview_surface_list.extend(image_factory.player_choice_menu[11])

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
	sprite_preview_surface_list: LIST[GAME_SURFACE]
	btn_add_player, btn_add_connexion: BUTTON

	btn_go: BUTTON

	add_player
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
				player_select_submenus.extend (create {PLAYER_SELECT_SUBMENU} .make (image_factory, l_x, l_y, used_sprites, sprite_preview_surface_list))
			end
		end

	show(a_game_window:GAME_WINDOW_SURFACED)
		do
			Precursor (a_game_window)
			across player_select_submenus as la_player_select_submenus loop
				la_player_select_submenus.item.show(a_game_window)
			end
		end

	set_is_done (new_value: BOOLEAN)
		do
			is_done := new_value
		end

	start_game
		do
			is_done := true
		end

	get_players: LIST[PLAYER]
		-- Retourne la liste des joueurs sélectionnés
		do
			create {ARRAYED_LIST[PLAYER]} Result.make(player_select_submenus.count)
		end

	on_mouse_move(a_mouse_state: GAME_MOUSE_MOTION_STATE)
		do
		end

end
