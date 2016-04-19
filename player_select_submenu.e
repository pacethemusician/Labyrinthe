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

	make (a_index: INTEGER; a_image_factory: IMAGE_FACTORY; a_x, a_y: INTEGER; a_available_sprites: LIST[BOOLEAN]; a_sprite_list: LIST[ANIMATED_SPRITE]; a_is_local:BOOLEAN)
			-- `a_index' est la position de `Current' dans la liste pour créer le bon `background'
			-- `a_available_sprites' pointe vers la liste du {MENU_PLAYER} pour savoir si les sprites sont disponibles.
			-- `a_sprite_list' pointe vers la liste du {MENU_PLAYER} pour avoir accès aux sprites
			-- on assigne `a_is_local' à `is_local'
		do
			make_menu (a_image_factory)
			x := a_x
			y := a_y
			is_local := a_is_local
			index := a_index
			available_sprites := a_available_sprites
			sprite_list := a_sprite_list
			create btn_cancel.make (image_factory.buttons[9], x + 208, y + 5)
			create background.make (image_factory.player_choice_menu.at(index), x, y)
			create left_arrow.make (image_factory.buttons[5], x + 35, y + 44)
			create right_arrow.make (image_factory.buttons[6], x + 164, y + 44)
			if is_local then
				create type_image.make (image_factory.player_choice_menu[6], x, y + 150)
			else
				create type_image.make (image_factory.player_choice_menu[7], x, y + 150)
			end
			buttons.extend(left_arrow)
			buttons.extend(right_arrow)
			buttons.extend (btn_cancel)

			current_sprite_index := first_available_index
			available_sprites[current_sprite_index] := False

			on_screen_sprites.extend (background)
			on_screen_sprites.extend (sprite_list[current_sprite_index])
			on_screen_sprites.extend (left_arrow)
			on_screen_sprites.extend (right_arrow)
			if index > 1 then
				on_screen_sprites.extend (btn_cancel)
			end
			on_screen_sprites.extend (type_image)

			on_screen_sprites.at (2).x := x + 87
			on_screen_sprites.at (2).y := y + 35

			left_arrow.on_click_actions.extend (agent switch_sprite(-1))
			right_arrow.on_click_actions.extend (agent switch_sprite(1))
			btn_cancel.on_click_actions.extend (agent cancel(index))
		end

feature {MENU_PLAYER} -- Implementation

	left_arrow, right_arrow: BUTTON

	btn_cancel: BUTTON

	current_sprite_index: INTEGER assign set_current_sprite_index

	sprite_list: LIST[ANIMATED_SPRITE]
		-- pointe vers la liste du {MENU_PLAYER} pour avoir accès aux sprites

	type_image: SPRITE
		-- une image indiquant s'il s'agit d'un jouer local ou réseau

	is_local: BOOLEAN
		-- Si `True' le joueur est local sinon en réseau

	available_sprites: LIST[BOOLEAN]
		-- pointe vers la liste du {MENU_PLAYER} pour savoir si les sprites sont disponibles.

	index: INTEGER assign set_index
	 	-- La position de `current' dans la `player_select_submenus' de la classe {MENU_PLAYER}

	x, y: INTEGER
		-- Position du sous-menu

	is_cancel_selected: BOOLEAN assign set_is_cancel_selected
		-- Choix de l'usager

	set_is_cancel_selected (a_value: BOOLEAN)
			-- Setter pour `is_cancel_selected'
		do
			is_cancel_selected := a_value
		end

	cancel (a_index: INTEGER)
			-- Indique que le choix de l'usager est de canceller `current'
		do
			is_cancel_selected := True
		end

	set_index (a_value: INTEGER)
			-- setter pour `index'
		do
			index := a_value
		end

	first_available_index:INTEGER
			-- Retourne l'index du premier {SPRITE} disponible dans `available_sprites'
		local
			l_found: BOOLEAN
		do
			from
				Result := 1
			until Result > available_sprites.count or l_found loop
				if available_sprites[Result] then
					l_found := True
				else
					Result := Result + 1
				end
			end
		end

	update_coordinates (a_x, a_y, a_index: INTEGER)
			-- Pour afficher `Current' à la bonne place si le joueur cancelle le {PLAYER_SELECT_SUBMENU} précédant
		do
			x := a_x
			y := a_y
			index := a_index
			on_screen_sprites.at (2).x := x + 87
			on_screen_sprites.at (2).y := y + 35
			background.current_surface := image_factory.player_choice_menu.at(index)
			background.x := x
			background.y := y
			if index > 1 then
				btn_cancel.x := x + 208
				btn_cancel.y := y + 5
			end
			left_arrow.x := x + 35
			left_arrow.y := y + 44
			right_arrow.x := x + 164
			right_arrow.y := y + 44
			type_image.x := x
			type_image.y := y + 150
		end

	next_available_index(a_direction: INTEGER):INTEGER
			-- Retourne l'index du premier `SPRITE' disponible par rapport à `current_sprite_index' selon `a_direction' dans `available_sprites'
		local
			l_found: BOOLEAN
		do
			if a_direction > 0 then
				from
					Result := current_sprite_index \\ 5 + 1
				until l_found loop
					if available_sprites[Result] then
						l_found := True
					else
						Result := Result \\ 5 + 1
					end
				end
			else
				from
					Result := current_sprite_index - 1
				 until l_found loop
				 	if Result = 0 then
						Result := 5
					end
					if available_sprites[Result] then
						l_found := True
					else
						Result := Result - 1
					end
				end
			end
		end

	set_current_sprite_index(a_index: INTEGER)
			-- setter pour `current_sprite_index'
		do
			current_sprite_index := a_index
		end

	switch_sprite(a_direction: INTEGER)
			-- change le `ANIMATED_SPRITE' contenu à la position 2 de la liste `on_screen_sprites'
			-- et met à jour `current_sprite_index' et `available_sprites'
		do
			available_sprites[current_sprite_index] := True
			current_sprite_index := next_available_index (a_direction)
			on_screen_sprites.at(2) := sprite_list[current_sprite_index]
			on_screen_sprites.at (2).x := x + 87
			on_screen_sprites.at (2).y := y + 35
			available_sprites[current_sprite_index] := False
		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
