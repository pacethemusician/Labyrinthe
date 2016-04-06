note
	description: "Classe abstraite définissant les bases d'un menu"
	author: "Pascal Belisle"
	date: "25 mars"
	version: "1.0"

deferred class
	MENU

inherit
	ENGINE
		redefine
			make
		end

feature {NONE} -- Initialization

	make(a_image_factory: IMAGE_FACTORY)
			-- <Precursor>
		do
			Precursor (a_image_factory)
			create {LINKED_LIST[BUTTON]}buttons.make
			choice := 0
			is_done := false
		end

feature
	background : SPRITE
		-- Image d'arrière-plan de `Current'.

	is_done: BOOLEAN
		-- True si l'usager à fait un choix.

	choice: INTEGER
		-- Le choix de l'usager.

	buttons: LIST[BUTTON]
		-- Contient les objets cliquables.

	check_button(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Déclanche l'action des boutons s'il y a clique.
		do
			across buttons as la_buttons loop
				la_buttons.item.execute_actions (a_mouse_state)
			end
		end

	set_choice(a_choice: INTEGER)
			-- Assigne le `a_choice' de l'usager à `choice'
		require
			valid_choice: a_choice > 0
		do
			is_done := True
			choice := a_choice
		ensure
			is_done_set: is_done = True
			choice_set: choice = a_choice
		end

	set_is_done (new_value: BOOLEAN)
			-- assigne `new_value' à `is_done'
		do
			is_done := new_value
		ensure
			is_assigned: is_done = new_value
		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
