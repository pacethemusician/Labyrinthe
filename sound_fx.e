note
	description: "Créer un effet sonore."
	author: "Pascal Belisle"
	date: "Session Hiver 2016"
	revision: "0.1"

class
	SOUND_FX

inherit
	AUDIO_LIBRARY_SHARED

create
	make

feature {NONE} -- Implementation

	make (a_file_name: STRING)
			-- Initialisation de `Current'
		local
			l_sfx_file: AUDIO_SOUND_FILE
		do
			error_msg := ""
			audio_library.sources_add
			source := audio_library.last_source_added
			create l_sfx_file.make (a_file_name)
			if l_sfx_file.is_openable then
				l_sfx_file.open
				if not l_sfx_file.is_open then
					set_error("Cannot open sound file")
				end
			else
				set_error("Sound file not valid.")
			end
			sound := l_sfx_file
		end

	has_error: BOOLEAN
			-- Devient True si une erreur se produit dans `Current'

	set_error(a_message: STRING)
			-- Lorsqu'une erreur survient, assigne `a_message' à `error_msg'
		do
			has_error := True
			error_msg := a_message
		end

feature

	error_msg: STRING

	source: AUDIO_SOURCE

	sound: AUDIO_SOUND

	play
			-- Fait jouer le son `Current'.
		do
			if sound.is_open then
				source.stop
				source.queue_sound (sound)
				source.play
			end
		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
