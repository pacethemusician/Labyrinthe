note
	description: "Summary description for {MENU_PLAYER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MENU_PLAYER

inherit
	MENU

create
	make

feature {NONE} -- Initialisation

	make (a_game_surfaces: IMAGE_FACTORY)
		do
			choice := ""
			
			game_surfaces := a_game_surfaces
			create btn_add_player.make (game_surfaces.buttons[7], 136, 510)
			create btn_add_connexion.make (game_surfaces.buttons[8], 136, 589)
			create btn_cancel_p2.make (game_surfaces.buttons[9], 548, 135)
			create btn_cancel_p3.make (game_surfaces.buttons[9], 290, 323)
			create btn_cancel_p4.make (game_surfaces.buttons[9], 548, 323)

			create {ARRAYED_LIST[PLAYER]} players.make (4)
			create {ARRAYED_LIST[INTEGER]} used_sprites.make (5)
			create background.make (game_surfaces.backgrounds[2])
			create {ARRAYED_LIST[PLAYER_SELECT_MENU_SURFACE]} player_menu_surfaces.make(4)

			-- Action des boutons:
			btn_add_player.on_click_actions.extend (agent add_player)
			btn_cancel_p2.on_click_actions.extend (agent cancel(2))
			btn_cancel_p3.on_click_actions.extend (agent cancel(3))
			btn_cancel_p4.on_click_actions.extend (agent cancel(4))

		end

feature {GAME_ENGINE} -- Implementation

	get_players: LIST[PLAYER]
		-- Retourne la liste des joueurs sélectionnés
		do
			create {ARRAYED_LIST[PLAYER]} Result.make(4)
		end

	show(a_timestamp:NATURAL_32; a_game_window:GAME_WINDOW_SURFACED)
		do
			background.draw_self (a_game_window.surface)
			btn_add_player.draw_self (a_game_window.surface)
			btn_add_connexion.draw_self (a_game_window.surface)
		end

	player_menu_surfaces: LIST[PLAYER_SELECT_MENU_SURFACE]
	used_sprites: LIST[INTEGER]
	players: LIST[PLAYER]

	btn_add_player, btn_add_connexion: BUTTON
	btn_cancel_p2, btn_cancel_p3, btn_cancel_p4: BUTTON

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
				player_menu_surfaces.extend (create {PLAYER_SELECT_MENU_SURFACE} .make (game_surfaces, l_x, l_y, used_sprites))
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
			btn_add_player.execute_actions (a_mouse_state)
			across player_menu_surfaces as menu loop
				menu.item.check_btn(a_mouse_state)
			end
		end
end
