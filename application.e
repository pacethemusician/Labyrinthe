note
	description: "Classe principale qui lance le jeu et le ferme correctement"
	author: "Pascal Belisle et Louis Marchand"
	date: "Session Hiver 2016"
	revision: "1.0"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED
	TEXT_LIBRARY_SHARED
	AUDIO_LIBRARY_SHARED
	IMG_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make
			-- Initialisation de `Current'
		local
			l_engine:detachable GAME_ENGINE
		do
			game_library.enable_video
			audio_library.enable_sound
			text_library.enable_text
			image_file_library.enable_image (true, false, false)
			create l_engine.make
			l_engine := Void
			game_library.clear_all_events
			text_library.quit_library
			audio_library.quit_library
			image_file_library.quit_library
			game_library.quit_library
		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
