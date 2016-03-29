note
	description: "Classe abstraite défénissant un menu."
	author: "Pascal"
	date: "25 mars"
	revision: ""

deferred class
	MENU

feature
	background : BACKGROUND
	game_surfaces: IMAGE_FACTORY
	done: BOOLEAN
	choice: STRING

	show(a_timestamp:NATURAL_32; a_game_window:GAME_WINDOW_SURFACED)
		deferred
		end

	check_btn(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
		deferred
		end

	reset
		-- On reset le menu
		do
			choice := ""
			done := false
		end
end
