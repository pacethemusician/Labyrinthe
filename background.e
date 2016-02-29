note
	description: "S'occupe des éléments d'arrière-plan (musique et image)."
	author: "Pascal Belisle"
	date: "29 février"
	revision: "0.1"

class
	BACKGROUND

inherit
	AUDIO_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make
		local
			l_music_file:AUDIO_SOUND_FILE
		do
			audio_library.sources_add
			music_source:=audio_library.last_source_added
			create l_music_file.make("Audio/Solitaire.ogg")
			if l_music_file.is_openable then
				l_music_file.open
				if l_music_file.is_open then
					music_source.queue_sound_infinite_loop (l_music_file)
					music_source.play
				else
					print("Cannot open sound files.")
				end
			else
				print("Sound file not valid.")
			end
		end

feature {NONE}
	music_source: AUDIO_SOURCE

end
