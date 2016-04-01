note
	description: "Un sous-menu pour la s�lection des joueurs"
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

	make (a_index: INTEGER; a_image_factory: IMAGE_FACTORY; a_x, a_y: INTEGER; a_available_sprites: LIST[BOOLEAN]; a_sprite_list: LIST[ANIMATED_SPRITE])
		do
			make_menu (a_image_factory)
			x := a_x
			y := a_y
			index := a_index;
			available_sprites := a_available_sprites
			sprite_index := first_available_index(1)
			sprite_list := a_sprite_list
			create btn_cancel.make (image_factory.buttons[9], x + 208, y + 5)
			create background.make (image_factory.player_choice_menu.at(index), x, y)
			create left_arrow.make (image_factory.buttons[5], x + 35, y + 74)
			create right_arrow.make (image_factory.buttons[6], x + 164, y + 74)

			left_arrow.on_click_actions.extend (agent set_sprite_index(first_available_index(-1)))
			right_arrow.on_click_actions.extend (agent set_sprite_index(first_available_index(1)))
			btn_cancel.on_click_actions.extend (agent cancel(index))

			buttons.extend(left_arrow)
			buttons.extend(right_arrow)
			buttons.extend (btn_cancel)

			on_screen_sprites.extend (background)
			on_screen_sprites.extend (sprite_list[index])
			on_screen_sprites.at (2).x := x + 100
			on_screen_sprites.at (2).y := y + 30
			on_screen_sprites.extend (left_arrow)
			on_screen_sprites.extend (right_arrow)
			if index > 1 then
				on_screen_sprites.extend (btn_cancel)
			end
		end


feature {MENU_PLAYER} -- Implementation

	left_arrow, right_arrow: BUTTON
	btn_cancel: BUTTON
	sprite_index: INTEGER assign set_sprite_index
	sprite_list: LIST[ANIMATED_SPRITE]
	available_sprites: LIST[BOOLEAN]
	index: INTEGER
	 	-- La position de `current' dans la `player_select_submenus' de la classe `MENU_PLAYER'
	x, y: INTEGER
		-- Position du sous-menu

	is_cancel_selected: BOOLEAN assign set_is_cancel_selected

	set_is_cancel_selected (a_value: BOOLEAN)
		-- Setter pour `is_cancel_selected'
		do
			is_cancel_selected := a_value
		end

	cancel (a_index: INTEGER)
		do
			is_done := True
			is_cancel_selected := True
		end

	first_available_index(a_direction: INTEGER):INTEGER
			-- Retourne l'index du premier `SPRITE' disponible dans `available_sprites'
		do

			Result := 0
		end

	set_sprite_index(a_index: INTEGER)
		do
			sprite_index := a_index
		end

end
