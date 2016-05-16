note
	description: "Contient les données d'un {PLAYER} à envoyer sur le réseau."
	author: "Pascal Belisle"
	date: "Session Hiver 2016"
	revision: "1.0"

class
	PLAYER_DATA

create
	make

feature {NONE} --

	make (a_x, a_y, a_sprite_index, a_index: INTEGER)
			-- Constructeur de `Current'
		do
			x := a_x
			y := a_y
			sprite_index := a_sprite_index
			index := a_index
		end

feature
	sprite_index: INTEGER
			-- Indique quel sprite utiliser dans `image_factory'

	index: INTEGER
	 		-- La position de `current' dans la `player_select_submenus' de la classe {MENU_PLAYER}

	x, y: INTEGER
			-- Position du sous-menu

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
