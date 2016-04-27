note
	description: "Tests unitaires pour les classes MENU"
	author: "Pascal Belisle"
	date: "Session Hiver 2016"
	revision: "1.0"
	testing: "type/manual"

class
	TEST_MENU_PLAYER

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end

	MENU_PLAYER
		undefine
			default_create
		end

	GAME_LIBRARY_SHARED
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			if not game_library.is_video_enable then
				game_library.enable_video
			end
			make (create {IMAGE_FACTORY}.make, create {NETWORK_STREAM_SOCKET}.make)
			assert ("test_menu_player_on_prepare", not game_library.has_error)
		end

feature -- Test routines

	test_is_go_selected
			-- Test is_go_selected
		do
			choice := 1
			assert ("is_go_selected not set properly", is_go_selected)
			choice := 2
			assert ("is_go_selected not set properly", not is_go_selected)
		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
