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

	make

feature
	current_sprite_index: INTEGER assign set_current_sprite_index
			-- Indique quel sprite utiliser dans `image_factory'

	is_local: BOOLEAN
			-- Si `True' le joueur est local sinon en r�seau

	index: INTEGER assign set_index
	 		-- La position de `current' dans la `player_select_submenus' de la classe {MENU_PLAYER}

	x, y: INTEGER
			-- Position du sous-menu



invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a �t� fait dans le cadre du cours de programmation orient�e object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
