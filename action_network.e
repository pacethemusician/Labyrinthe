note
	description: "Action du joueur que recevra les joueurs réseau "
	author: "Pascal Belisle"
	date: "Session Hiver 2016"
	revision: "1.0"

class
	ACTION_NETWORK

create
	make

feature {NONE} -- Implementation

	make (a_commande: STRING; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Initialization de `Current'
			-- Les commandes suivantes correspondent aux fonction du {BOARD_ENGINE}:
			-- "REL" -> on_mouse_release
			-- "SPARE" -> spare_card_click_action
			-- "BOARD" -> board_click_action
			-- ""
		do
			commande := a_commande
			mouse_state := a_mouse_state
		end

feature -- Access

	commande: STRING
			-- Mot clé indiquant la fonction à exécuter avec le `mouse_state'

	mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE
			-- Le `mouse_state' du {PLAYER} qu'on devra passe à la bonne fonction indiquée par la `commande'

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"
end
