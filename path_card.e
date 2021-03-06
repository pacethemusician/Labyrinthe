﻿note
	description: "Carte dont le board est formé."
	author: "Pascal Belisle et Charles Lemay"
	date: "15 Février 2016"

class
	PATH_CARD

inherit

	GAME_LIBRARY_SHARED

	AUDIO_LIBRARY_SHARED

	SPRITE
		rename
			make as make_sprite
		redefine
			draw_self
		end

create
	make

feature {NONE} -- Initialisation

	make (a_type: INTEGER; a_image_factory: IMAGE_FACTORY; a_x, a_y, a_rotation, a_item_index: INTEGER_32)
			-- `a_type' peut être soit 1='╗' 2='║'  3='╣'.
			-- `a_game_factory' contient les images du jeu
			-- `a_rotation' est un index de 1 à 4 pour savoir quelle image utiliser.
		require
			type_over_zero: a_type > 0
			type_below_four: a_type < 4
			rotation_over_zero: a_rotation > 0
			rotation_below_five: a_rotation < 5
		do
			x := a_x
			y := a_y
			x_offset := 0
			y_offset := 0
			type := a_type
			item_index := a_item_index
			image_factory := a_image_factory
			items := a_image_factory.items
			index := 1
			create {ARRAYED_LIST [GAME_SURFACE]} rotated_surfaces.make (4)
			rotated_surfaces := image_factory.path_cards [a_type]
			make_sprite (rotated_surfaces [a_rotation], a_x, a_y)
			if a_type = 1 then
				connections := 0b0011
			elseif a_type = 2 then
				connections := 0b1010
			elseif a_type = 3 then
				connections := 0b1011
			end
			rotate (a_rotation - 1)
		end

feature

	rotate (a_steps: INTEGER)
			-- Tourne `current' `a_steps' fois. Si `a_steps' est positif, la rotation
			-- se fait dans le sens des aiguilles d'une montre.
		require
			valid_rotation: a_steps.abs <= 4
		local
			l_steps: INTEGER
		do
				-- Rotation de l'index.
			index := index - 1
			index := (index + a_steps) \\ 4
			if index < 0 then
				index := index + 4
			end
			index := index + 1
			current_surface := rotated_surfaces [index]
				-- Rotation des connections.
			if a_steps < 0 then
				l_steps := 4 + a_steps
			else
				l_steps := a_steps
			end
			connections := connections.bit_or (connections.bit_shift_left (4))
			connections := connections.bit_shift_right (l_steps).bit_and (0b1111)
		end

	is_connected (a_direction: INTEGER): BOOLEAN
			-- Retourne 'true' si `current' a un chemin connecté vers la direction
			-- `a_direction'. la direction 0 équivaut au côté du haut et circule
			-- dans le sens des aiguilles d'une montre.
		require
			direction_positive: a_direction >= 0
			direction_below_four: a_direction < 4
		do
			result := connections.bit_test (3 - a_direction)
		end

	set_x_offset (a_value: INTEGER)
			-- Assigne `a_value' à `x_offset'.
		do
			x_offset := a_value
		ensure
			x_offset_valid: x_offset = a_value
		end

	set_y_offset (a_value: INTEGER)
			-- Assigne `a_value' à `y_offset'.
		do
			y_offset := a_value
		ensure
			y_offset_valid: y_offset = a_value
		end

	set_item_index (a_value: INTEGER)
			-- Assigne `a_value' à `index'.
		require
			value_valid: a_value <= items.count
			value_positive: a_value >= 0
		do
			item_index := a_value
		ensure
			item_index_valid: item_index = a_value
		end

	draw_self (destination_surface: GAME_SURFACE)
			-- Dessiner `current' ainsi que ses items sur `destination_surface'
			-- et mettre à jour `animation_timer'.
		do
			destination_surface.draw_surface (current_surface, x, y)
			if not (item_index = 0) then
				destination_surface.draw_surface (items.at (item_index), x, y)
			end
		end

feature -- Attributs

	type: INTEGER
			-- peut être soit 1='╗' 2='║'  3='╣'

	items: LIST [GAME_SURFACE]
			-- Les images des items que le joueur peut ramasser.

	image_factory: IMAGE_FACTORY
			-- Les images du jeu

	index: INTEGER
			-- Index de la surface de `current' dans `rotated_surfaces'.

	rotated_surfaces: LIST [GAME_SURFACE]
			-- Liste d'images utilisées par `current'.

	connections: INTEGER
			-- Nombre de 4 bits. Chaque bit représente un côté de `current'.
			-- Les bits valent 1 si un chemin est connecté sur leur côté, sinon 0.

	item_index: INTEGER assign set_item_index
			-- Index de l'item sur `current' dans la liste `items'.
			-- Est égual à 0 si aucun item n'est sur `current'.

	x_offset, y_offset: INTEGER
			-- Position relative à la souris lorsque `current' se fait déplacer.

invariant
	item_index_valid: item_index <= items.count
	item_index_positive: item_index >= 0
	connections_not_all: connections /= 0b1111
	connections_over_one: (connections.bit_test (0).to_integer + connections.bit_test (1).to_integer +
							connections.bit_test (2).to_integer + connections.bit_test (3).to_integer) > 1

note
	license: "WTFPL"
	source: "[
		Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
		Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
	]"

end
