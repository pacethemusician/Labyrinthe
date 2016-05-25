note
	description: "Attend que le serveur envoie l'action du joueur pendant la partie"
	author: "Pascal Belisle"
	date: "Session Hiver 2016"
	revision: "1.0"

class
	THREAD_NETWORK_CLIENT

inherit
	THREAD

	rename
		make as make_thread
	end

create
	make

feature {NONE} -- Initialization

	make (a_socket: SOCKET)
			-- Initialisation de `Current'
		do
			has_error := False
			make_thread
			is_done := false
			socket := a_socket
		end

feature -- Access

	has_error:BOOLEAN
			-- `True' si une erreur est arrivé à la création du `socket'

	mouse_state: detachable GAME_MOUSE_BUTTON_PRESSED_STATE assign set_mouse_state
			-- L'action du {PLAYER} contenant l'instruction et un `mouse_state'

	set_mouse_state (a_value: detachable GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Setter pour `mouse_state'
		do
			mouse_state := a_value
		end

	socket: SOCKET
			-- {SOCKET} du {PLAYER_NETWORK} qui lance le thread. Reçoit et envoie les données.

	is_done: BOOLEAN assign set_is_done
			-- Indique que `Current' est terminé

	set_is_done (a_value: BOOLEAN)
			-- Setter pour `is_done'
		do
			is_done := a_value
		end

	execute
			-- Tâches du thread
			-- Met le `socket' en mode d'attente de connexion.
		do
			from until is_done loop
				if
					attached socket as la_socket and then
					attached {GAME_MOUSE_BUTTON_PRESSED_STATE} la_socket.retrieved as la_mouse_state
				then
					mouse_state := la_mouse_state
					from until (not attached mouse_state) or is_done loop
						sleep (1000000)
						--	On attend......... -_- zzz
					end
				end
			end
		end

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
