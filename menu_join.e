note
	description: "Demande les informations de connection � l'usager pour une partie en r�seau."
	author: "Pascal Belisle"
	date: "Session Hiver 2016"
	revision: "1.0"

class
	MENU_JOIN

inherit
	MENU
		redefine
			make
		end

create
	make

feature {NONE} -- Initialisation

	make (a_image_factory: IMAGE_FACTORY)
			-- <Precursor>
		do
			Precursor(a_image_factory)
			create background.make (image_factory.backgrounds[2], 0, 0)

			-- Section hard cod� � refaire si le temps le permet
			is_done := True
			is_go_selected := True
		end

feature
	is_go_selected: BOOLEAN assign set_is_go_selected

	set_is_go_selected (a_value: BOOLEAN)
			-- Assigne `a_value' � `is_go_selected'
		do
			is_go_selected := a_value
		end

	get_ip: TUPLE[INTEGER]
			-- Retourne l'adresse IP s�lectionn�e
			-- Pour l'instant, l'adresse local_host est hard-cod�
		do
			Result := [127, 0, 0, 1]
		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a �t� fait dans le cadre du cours de programmation orient�e object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
