note
	description: "Demande les informations de connection � l'usager pour une partie en r�seau."
	author: "Pascal Belisle"
	date: "Avril 2016"
	revision: ""

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
		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a �t� fait dans le cadre du cours de programmation orient�e object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
