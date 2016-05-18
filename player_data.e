note
	description: "Contient les donn�es d'un {PLAYER} � envoyer sur le r�seau."
	author: "Pascal Belisle"
	date: "Session Hiver 2016"
	revision: "1.0"

class
	PLAYER_DATA

create
	make

feature {NONE} --

	make (a_x, a_y, a_sprite_index, a_index: INTEGER; a_items_to_find: LIST[INTEGER])
			-- Constructeur de `Current'
		do
			x := a_x
			y := a_y
			sprite_index := a_sprite_index
			index := a_index
			items_to_find := a_items_to_find
		end

feature
	sprite_index: INTEGER
			-- Indique quel sprite utiliser dans `image_factory'

	index: INTEGER
	 		-- La position de `current' dans la `player_select_submenus' de la classe {MENU_PLAYER}

	x, y: INTEGER
			-- Position du sous-menu

	items_to_find: LIST[INTEGER]
			-- La liste des index des items � trouver

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a �t� fait dans le cadre du cours de programmation orient�e object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
