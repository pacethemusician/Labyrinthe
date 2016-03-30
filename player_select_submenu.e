note
	description: "Un sous-menu pour la sélection des joueurs"
	author: "Pascal Belisle"
	date: "Mars 2016"
	revision: ""

class
	PLAYER_SELECT_SUBMENU

inherit
	MENU
		rename
			make as make_menu
		end

create
	make

feature {NONE} -- Initialisation

	make (a_image_factory: IMAGE_FACTORY; a_x, a_y: INTEGER; a_used_sprites: LIST[INTEGER]; a_available_sprites: LIST[BOOLEAN])
		do
			make_menu (a_image_factory)
			x := a_x
			y := a_y
			available_sprites := a_available_sprites
			sprite_index := first_available_index(1)
			sprite_preview_surface_list := a_sprite_preview_surface_list

			create btn_cancel_p2.make (image_factory.buttons[9], 548, 135)
			create btn_cancel_p3.make (image_factory.buttons[9], 290, 323)
			create btn_cancel_p4.make (image_factory.buttons[9], 548, 323)
			create background.make (image_factory.player_choice_menu.at(1), x, y)
			create left_arrow.make (image_factory.buttons[5], x + 35, y + 74)
			create right_arrow.make (image_factory.buttons[6], x + 164, y + 74)

			left_arrow.on_click_actions.extend (agent switch_sprite_index(1))
			right_arrow.on_click_actions.extend (agent switch_sprite_index(-1))
			btn_cancel_p2.on_click_actions.extend (agent cancel(2))
			btn_cancel_p3.on_click_actions.extend (agent cancel(3))
			btn_cancel_p4.on_click_actions.extend (agent cancel(4))

			buttons.extend(left_arrow)
			buttons.extend(right_arrow)
			buttons.extend (btn_cancel_p2)
			buttons.extend (btn_cancel_p3)
			buttons.extend (btn_cancel_p4)

			on_screen_sprites.extend (background)
			on_screen_sprites.extend (left_arrow)
			on_screen_sprites.extend (right_arrow)
			on_screen_sprites.extend (btn_cancel_p2)
			on_screen_sprites.extend (btn_cancel_p3)
			on_screen_sprites.extend (btn_cancel_p4)
			on_screen_sprites.extend (create {SPRITE} .make (sprite_preview_surface_list[1], x + 87, y + 35))
		end


feature {MENU_PLAYER} -- Implementation

	left_arrow, right_arrow: BUTTON
	btn_cancel_p2, btn_cancel_p3, btn_cancel_p4: BUTTON
	sprite_index: INTEGER assign set_sprite_index
	sprite_preview_surface_list: LIST[GAME_SURFACE]
	available_sprites: LIST[BOOLEAN]
	x, y: INTEGER
		-- Position du sous-menu

	first_available_index (a_direction: INTEGER): INTEGER
		-- Trouve un sprite inutilisé en vérifiant `available_sprites'
		-- `a_direction' indicte dans quel sens. 1 = ordre croissant, -1 = décroissant
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

	cancel (a_index: INTEGER)
		do

		end

	set_sprite_index(a_index: INTEGER)
		do
			sprite_index := a_index
		end

feature {NONE} -- Private

	-- arcade_font_36: TEXT_FONT
	-- text_image: GAME_SURFACE

end
