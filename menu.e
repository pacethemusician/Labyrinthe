note
	description: "Classe abstraite défénissant un menu."
	author: "Pascal"
	date: "25 mars"
	revision: ""

deferred class
	MENU

inherit
	ENGINE
		redefine
			make
		end

feature {NONE} -- Initialization

	make(a_image_factory: IMAGE_FACTORY)
		do
			Precursor (a_image_factory)
			create {LINKED_LIST[BUTTON]}buttons.make
			choice := 0
			is_done := false
		end

feature
	background : SPRITE

	is_done: BOOLEAN
	choice: INTEGER

	is_choice_return:BOOLEAN
		do
			Result := choice = 1
		end

	buttons: LIST[BUTTON]

	check_btn(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
		-- déclanche l'action des boutons s'il y a click
		do
			across buttons as la_buttons loop
				la_buttons.item.execute_actions (a_mouse_state)
			end
		end

	set_choice(a_choice: INTEGER)
		-- Assigne le `a_choice' de l'usager à `choice'
		do
			is_done := true
			choice := a_choice
		end
end
