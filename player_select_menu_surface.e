note
	description: "Une case pour le menu sélection de joueur"
	author: "Pascal Belisle"
	date: "24 mars 2016"
	revision: ""

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

	make (a_game_surfaces: IMAGE_FACTORY; a_x, a_y: INTEGER; a_used_sprites: LIST[INTEGER])
		do
			x := a_x
			y := a_y
			used_sprites := a_used_sprites
			game_surfaces := a_game_surfaces
			sprite_index := first_available_index(1)
			make_sprite (game_surfaces.player_choice_menu.at(used_sprites.count + 1), x, y)
			create left_arrow.make (game_surfaces.buttons[5], x + 35, y + 74)
			create right_arrow.make (game_surfaces.buttons[6], x + 164, y + 74)
			left_arrow.on_click_actions.extend (agent switch_sprite_index(1))
			right_arrow.on_click_actions.extend (agent switch_sprite_index(-1))
		end


feature {MENU_PLAYER} -- Implementation

	left_arrow, right_arrow: BUTTON
	sprite_index: INTEGER assign set_sprite_index
	used_sprites: LIST[INTEGER]
	game_surfaces: IMAGE_FACTORY

	check_btn(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- déclanche l'action des boutons s'il y a click
		do
			left_arrow.execute_actions (a_mouse_state)
			right_arrow.execute_actions (a_mouse_state)
		end

	first_available_index (a_direction: INTEGER): INTEGER
		-- Trouve un sprite inutilisé en vérifiant `used_sprites'
		-- `a_direction' indicte dans quel sens 1 ordre croissant, -1 décroissant
		local
			found: BOOLEAN
		do
			if (a_direction > 1) then
				Result := 1
				from found := false	until found	loop
					if used_sprites.has (Result) then
						Result := Result + 1
					else
						found := true
					end
				end
			else
				Result := 5
				from found := false until found loop
					if used_sprites.has (Result) then
						Result := Result - 1
					else
						found := true
					end
				end
			end
		end

	switch_sprite_index(a_direction: INTEGER)
		-- Change le sprite en appelant
		do
			sprite_index := first_available_index(a_direction)
		end

	draw_self(a_destination_surface: GAME_SURFACE)
		do
			a_destination_surface.draw_surface (current_surface, x, y)
			a_destination_surface.draw_surface (game_surfaces.players.at(sprite_index + 7).at(1), x + 72, y + 40)
			left_arrow.draw_self(a_destination_surface)
			right_arrow.draw_self(a_destination_surface)

		end

	set_sprite_index(a_index: INTEGER)
		do
			sprite_index := a_index
		end

feature {NONE} -- Private

	-- arcade_font_36: TEXT_FONT
	-- text_image: GAME_SURFACE

end
