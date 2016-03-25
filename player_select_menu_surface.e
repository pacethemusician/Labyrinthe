note
	description: "Summary description for {PLAYER_SELECT_MENU}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER_SELECT_MENU_SURFACE

inherit
	SPRITE
		rename
			make as make_sprite
		redefine
			draw_self
		end

create
	make

feature {NONE} -- Initialisation

	make (a_player: PLAYER; a_game_surfaces: IMAGE_FACTORY; a_x, a_y, a_index: INTEGER; a_used_sprites: LIST[INTEGER])
		require
			a_index > 0
			a_index < 5
		do
			x := a_x
			y := a_y
			player := a_player
			player_index := a_index
			used_sprites := a_used_sprites
			game_surfaces := a_game_surfaces
			make_sprite (game_surfaces.player_choice_menu.at(player_index), x, y)
			create left_arrow.make (game_surfaces.buttons[5], x + 35, y + 74) -- mettre à la bonne place...
			create right_arrow.make (game_surfaces.buttons[6], x + 164, y + 74) -- mettre à la bonne place...

			left_arrow.on_click_actions.extend (agent switch_player_type(1))
			right_arrow.on_click_actions.extend (agent switch_player_type(-1))
			-- btn_cancel.on_click_actions.extend (agent cancel)
		end


feature {GAME_ENGINE} -- Implementation


	left_arrow, right_arrow: BUTTON
	player_index: INTEGER
	player: PLAYER
	used_sprites: LIST[INTEGER]
	game_surfaces: IMAGE_FACTORY

	switch_player_type (direction: INTEGER)
			-- change le type si disponible
		local
			l_dispo: BOOLEAN
		do
			from
				l_dispo := false
			until
				l_dispo = true
			loop
				if not used_sprites.has (1) then
					l_dispo := true
				else

				end
			end

		end

	draw_self(destination_surface: GAME_SURFACE)
		do
			destination_surface.draw_surface (current_surface, x, y)
			destination_surface.draw_sub_surface (game_surfaces.players.at(player_index).at(1), 0 , 0, 84, 84, x + 72, y + 40)
			left_arrow.draw_self(destination_surface)
			right_arrow.draw_self(destination_surface)

		end

feature {NONE} -- Private

	-- arcade_font_36: TEXT_FONT
	-- text_image: GAME_SURFACE

end
