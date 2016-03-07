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
		-- `a_surface' contient les 4 rotations du chemin
		-- `a_rotation' est un index de 1 à 4 pour savoir quelle image utiliser
		require
			a_type > 0
			a_type < 4
			a_rotation > 0
			a_rotation < 5

		local
			i:INTEGER
			l_sfx_file:AUDIO_SOUND_FILE
		do
			x := a_x
			y := a_y
			type := a_type
			index := 1
			create {ARRAYED_LIST[GAME_SURFACE]} rotated_surfaces.make(4)
			rotated_surfaces := a_surfaces
			make_sprite (rotated_surfaces[a_rotation], x, y)
			can_go_right := FALSE
			can_go_down := TRUE
			if type = 1 then
				can_go_up := FALSE
				can_go_left := TRUE
			elseif type = 2 then
				can_go_up := TRUE
				can_go_left := FALSE
			elseif type = 3 then
				can_go_up := TRUE
				can_go_left := TRUE
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
		end

feature {BOARD, GAME_ENGINE}
	type, index : INTEGER
	rotated_surfaces: LIST[GAME_SURFACE]
	sound_fx_source: AUDIO_SOURCE
	sound_fx_rotate: AUDIO_SOUND


	rotate_clockwise -- Rotate Clockwise
		local
			l_can_go_temp: BOOLEAN
		do
			index := (index \\ 4) + 1
			l_can_go_temp := can_go_up
			can_go_up := can_go_left
			can_go_left := can_go_down
			can_go_down := can_go_right
			can_go_right := l_can_go_temp
			current_surface := rotated_surfaces[index]
			if sound_fx_rotate.is_open then
				sound_fx_source.stop
				sound_fx_source.queue_sound(sound_fx_rotate)
				sound_fx_source.play
			end
		end

feature {NONE}
	can_go_up, can_go_right, can_go_left, can_go_down: BOOLEAN

end
