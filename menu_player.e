note
	description: "Summary description for {MENU_PLAYER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MENU_PLAYER

inherit
	MENU
		redefine
			make, check_btn
		end

create
	make

feature {NONE} -- Initialisation

	make (a_image_factory: IMAGE_FACTORY)
		do
			Precursor(a_image_factory)
			create btn_add_player.make (image_factory.buttons[7], 80, 510)
			create btn_add_connexion.make (image_factory.buttons[8], 80, 589)
			create btn_cancel_p2.make (image_factory.buttons[9], 548, 135)
			create btn_cancel_p3.make (image_factory.buttons[9], 290, 323)
			create btn_cancel_p4.make (image_factory.buttons[9], 548, 323)
			create btn_go.make (image_factory.buttons[10], 434, 510)

			create {ARRAYED_LIST[PLAYER]} players.make (4)
			create {ARRAYED_LIST[INTEGER]} used_sprites.make (5)
			create background.make (image_factory.backgrounds[2])
			create {ARRAYED_LIST[PLAYER_SELECT_MENU_SURFACE]} player_menu_surfaces.make(4)

			-- Action des boutons:
			btn_add_player.on_click_actions.extend (agent add_player)
			btn_cancel_p2.on_click_actions.extend (agent cancel(2))
			btn_cancel_p3.on_click_actions.extend (agent cancel(3))
			btn_cancel_p4.on_click_actions.extend (agent cancel(4))
			btn_go.on_click_actions.extend (agent start_game)
			buttons.extend(btn_add_player)
			on_screen_sprites.extend(background)
			on_screen_sprites.extend(btn_add_player)
			on_screen_sprites.extend(btn_add_connexion)
			on_screen_sprites.extend(btn_go)
			
		end

feature {GAME_ENGINE} -- Implementation

	player_menu_surfaces: LIST[PLAYER_SELECT_MENU_SURFACE]
	used_sprites: LIST[INTEGER]
	players: LIST[PLAYER]

	btn_add_player, btn_add_connexion: BUTTON
	btn_cancel_p2, btn_cancel_p3, btn_cancel_p4: BUTTON
	btn_go: BUTTON

	add_player
		local
			l_x, l_y, l_count: INTEGER
		do
			l_count := player_menu_surfaces.count
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
				player_menu_surfaces.extend (create {PLAYER_SELECT_MENU_SURFACE} .make (image_factory, l_x, l_y, used_sprites))
			end
		end

	cancel (a_index: INTEGER)
		do

		end

	update_used_sprites
		do
			used_sprites.wipe_out
			across player_menu_surfaces as menu loop
				used_sprites.extend (menu.item.sprite_index)
			end
		end

	check_btn(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
		-- déclanche l'action des boutons s'il y a click
		do
			update_used_sprites
			Precursor(a_mouse_state)
			across player_menu_surfaces as menu loop
				menu.item.check_btn(a_mouse_state)
			end
		end

	set_done (new_value: BOOLEAN)
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
			create {ARRAYED_LIST[PLAYER]} Result.make(4)
		end

end
