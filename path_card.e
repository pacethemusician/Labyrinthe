note
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

	make (a_type: INTEGER; a_image_factory: IMAGE_FACTORY; a_x, a_y, a_rotation: INTEGER_32)
			-- `a_type' peut être soit 1='╗' 2='║'  3='╣'.
			-- `a_game_factory' contient les images du jeu
			-- `a_rotation' est un index de 1 à 4 pour savoir quelle image utiliser.
		require
			type_over_zero: a_type > 0
			type_below_four: a_type < 4
			rotation_over_zero: a_rotation > 0
			rotation_below_five: a_rotation < 5
		local
			l_sfx_file: AUDIO_SOUND_FILE
		do
			x := a_x
			y := a_y
			x_offset := 0
			y_offset := 0
			item_index := 0
			image_factory := a_image_factory
			items := a_image_factory.items
			index := 1
			create {ARRAYED_LIST [GAME_SURFACE]} rotated_surfaces.make (4)
			rotated_surfaces := image_factory.path_cards[a_type]
			make_sprite (rotated_surfaces [a_rotation], a_x, a_y)
			if a_type = 1 then
				connections := 0b0011
			elseif a_type = 2 then
				connections := 0b1010
			elseif a_type = 3 then
				connections := 0b1011
			end
			audio_library.sources_add
			sound_fx_source := audio_library.last_source_added
			create l_sfx_file.make ("Audio/rotate.wav")
			if l_sfx_file.is_openable then
				l_sfx_file.open
				if not l_sfx_file.is_open then
					print ("Cannot open sound file")
				end
			else
				print ("Sound file not valid.")
			end
			sound_fx_rotate := l_sfx_file
			rotate (a_rotation - 1)
		end

feature

	play_rotate_sfx
			-- Fait jouer le son `sound_fx_rotate'.
		do
			if sound_fx_rotate.is_open then
				sound_fx_source.stop
				sound_fx_source.queue_sound (sound_fx_rotate)
				sound_fx_source.play
			end
		end

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
		local
			l_result: BOOLEAN
			l_mask: INTEGER
		do
			l_mask := 0b1000
			if connections.bit_and (l_mask.bit_shift_right (a_direction)) = 0 then
				l_result := false
			else
				l_result := true
			end
			result := l_result
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

	x_offset, y_offset: INTEGER
			-- Position relative à la souris lorsque `current' se fait déplacer.

	set_item_index (a_value: INTEGER)
			-- Assigne `a_value' à `index'.
		do
			item_index := a_value
		ensure
			item_index_valid: item_index = a_value
		end

	draw_self (destination_surface: GAME_SURFACE)
			-- Dessiner `current' ainsi que ses items sur `destination_surface'
			-- et mettre à jour `animation_timer'.
		require else
			item_index_positive: item_index >= 0
			item_index_valid: item_index < 25
		do
			destination_surface.draw_surface (current_surface, x, y)
			if not (item_index = 0) then
				destination_surface.draw_surface (items.at (item_index), x, y)
			end
		end

feature -- Attributs

	items: LIST [GAME_SURFACE]
			-- Les images des items que le joueur peut ramasser.

	image_factory: IMAGE_FACTORY
			-- Les images du jeu

	index: INTEGER
			-- Index de la surface de `current' dans `rotated_surfaces'.

	rotated_surfaces: LIST [GAME_SURFACE]
			-- Liste d'images utilisées par `current'.

	sound_fx_source: AUDIO_SOURCE
			-- Source de `sound_fx_rotate'.

	sound_fx_rotate: AUDIO_SOUND
			-- Son qui joue pendant la rotation.

	connections: INTEGER
			-- Nombre de 4 bits. Chaque bit représente un côté de `current'.
			-- Les bits valent 1 si un chemin est connecté sur leur côté, sinon 0.

	item_index: INTEGER assign set_item_index
			-- Index de l'item sur `current' dans la liste `items'.
			-- Est égual à 0 si aucun item n'est sur `current'.

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
