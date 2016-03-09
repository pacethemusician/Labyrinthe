note
	description: "Représentation objet de chaque carte chemin sur le plateau {PATH_CARD}."
	author: "Pascal Belisle"
	date: "15 Février 2016"
	revision: "0.2"

class
	PATH_CARD

inherit
	GAME_LIBRARY_SHARED
	AUDIO_LIBRARY_SHARED
	SPRITE
		rename
			make as make_sprite
		end

create
	make

feature {NONE}

	make (a_type: INTEGER; a_surfaces: LIST[GAME_SURFACE]; a_x, a_y, a_rotation: INTEGER_32)
		-- Le `type' peut être soit 1='╗' 2='║'  3='╣'
		-- `a_surfaces' contient les 4 rotations du chemin
		-- `a_rotation' est un index de 1 à 4 pour savoir quelle image utiliser
		require
			a_type > 0
			a_type < 4
			a_rotation > 0
			a_rotation < 5
		local
			l_sfx_file:AUDIO_SOUND_FILE
		do
			x := a_x
			y := a_y
			x_offset := 0
			y_offset := 0
			index := 1
			create {ARRAYED_LIST[GAME_SURFACE]} rotated_surfaces.make(4)
			rotated_surfaces := a_surfaces
			make_sprite (rotated_surfaces[a_rotation], a_x, a_y)
			if a_type = 1 then
				connections := 0b0011
			elseif a_type = 2 then
				connections := 0b1010
			elseif a_type = 3 then
				connections := 0b1011
			end
			audio_library.sources_add
			sound_fx_source := audio_library.last_source_added
			create l_sfx_file.make("Audio/rotate.wav")
			if l_sfx_file.is_openable then
				l_sfx_file.open
				if not l_sfx_file.is_open then
					print("Cannot open sound file")
				end
			else
				print("Sound file not valid.")
			end
			sound_fx_rotate := l_sfx_file
			rotate(a_rotation - 1)
		end

feature {BOARD, GAME_ENGINE}

	play_rotate_sfx
		do
			if sound_fx_rotate.is_open then
				sound_fx_source.stop
				sound_fx_source.queue_sound(sound_fx_rotate)
				sound_fx_source.play
			end
		end
		
	rotate (a_steps: INTEGER)
			-- Tourne `current' `a_steps' fois. Si `a_steps' est positif, la rotation
			-- se fait dans le sens des aiguilles d'une montre.
		require
			a_steps.abs <= 4
		local
			l_steps: INTEGER
		do
			-- Rotate index
			index := index - 1
			index := (index + a_steps) \\ 4
			if index < 0 then
				index := index + 4
			end
			index := index + 1
			current_surface := rotated_surfaces[index]
			-- Rotate connections
			if a_steps < 0 then
				l_steps := 4 + a_steps
			else
				l_steps := a_steps
			end
			connections := connections.bit_or (connections.bit_shift_left (4))
			connections := connections.bit_shift_right (a_steps).bit_and (0b1111)
		end

	is_connected (a_direction: INTEGER): BOOLEAN
			-- Retourne si `current' a un chemin connecté vers la direction
			-- `a_direction'. la direction 0 équivaut au côté du haut et circule
			-- dans le sens des aiguilles d'une montre.
	require
		a_direction >= 0
		a_direction < 4
	local
		l_result: BOOLEAN
		l_mask: INTEGER
	do
		l_mask := 0b1000
		if connections.bit_and (l_mask.bit_shift_right(a_direction)) = 0 then
			l_result := false
		else
			l_result := true
		end
		result := l_result
	end

	set_x_offset(a_value:INTEGER)
		do
			x_offset := a_value
		end

	set_y_offset(a_value:INTEGER)
		do
			y_offset := a_value
		end

	x_offset, y_offset: INTEGER
		-- Pour ajuster l'affichage en rapport avec la souris lors du drag

feature {NONE}	-- Attributs

	index : INTEGER
		-- Index de la surface de `current' dans `rotated_surfaces'

	rotated_surfaces: LIST[GAME_SURFACE]

	sound_fx_source: AUDIO_SOURCE

	sound_fx_rotate: AUDIO_SOUND

	connections: INTEGER
		-- Nombre de 4 bits. Chaque bit représente un côté de `current'.
		-- Les bits valent 1 si un chemin est connecté sur leur côté, sinon 0.

end
