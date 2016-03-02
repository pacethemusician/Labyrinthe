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

	make (a_type:NATURAL; a_surfaces: STRING_TABLE[GAME_SURFACE])
	-- Le `a_type' peut être soit 1='╗' 2='║'  3='╣'
		require
			a_type > 0
			a_type < 4

		local
			l_image_key:STRING
			i:INTEGER
			l_sfx_file:AUDIO_SOUND_FILE
		do
			index := 1
			create rotated_surfaces.make(4)
			from
				i := 1
			until
				i = 5
			loop
				l_image_key := "path_card_" + a_type.out + "_" + i.out
				if attached a_surfaces[l_image_key] as la_surface then
					rotated_surfaces.extend (la_surface)
				else
					rotated_surfaces.extend (create {GAME_SURFACE} .make (1, 1))
				end
				i := i + 1
			end
			make_sprite (rotated_surfaces[1])
			can_go_right := FALSE
			can_go_down := TRUE
			if a_type = 1 then
				can_go_up := FALSE
				can_go_left := TRUE
			elseif a_type = 2 then
				can_go_up := TRUE
				can_go_left := FALSE
			elseif a_type = 3 then
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
	index : INTEGER
	rotated_surfaces: ARRAYED_LIST[GAME_SURFACE]
	sound_fx_source: AUDIO_SOURCE
	sound_fx_rotate: AUDIO_SOUND


	rotate_clockwise -- Rotate Clockwise
		do
			index := (index \\ 4) + 1
			current_surface := rotated_surfaces[index]
			-- "Modifier les can_go_up can_go_down can_go_left et can_go_right"
			if sound_fx_rotate.is_open then
				sound_fx_source.stop
				sound_fx_source.queue_sound(sound_fx_rotate)
				sound_fx_source.play
			end
		end

feature {NONE}
	can_go_up, can_go_right, can_go_left, can_go_down: BOOLEAN

end
