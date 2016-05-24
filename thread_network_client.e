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

	action: detachable ACTION_NETWORK assign set_action
			-- L'action du {PLAYER} contenant l'instruction et un `mouse_state'

	set_action (a_value: detachable ACTION_NETWORK)
			-- Setter pour `action_state'
		do
			action := a_value
		end

	socket: SOCKET
			-- Reçoit les données

	is_done: BOOLEAN assign set_is_done
			-- Indique que `Current' est terminé

	set_is_done (a_value: BOOLEAN)
			-- Setter pour `is_done'
		do
			is_done := a_value
		end

--	mouse_state: detachable GAME_MOUSE_BUTTON_PRESSED_STATE assign set_mouse_state

--	set_mouse_state(a_value: detachable GAME_MOUSE_BUTTON_PRESSED_STATE)
--			-- Setter
--		do
--			mouse_state := a_value
--		end

	execute
			-- Tâches du thread
			-- Met le `socket' en mode d'attente de connexion.
		local
			l_action_state: ACTION_NETWORK
		do

			from until is_done loop
				if
					attached socket as la_socket and then
					attached {ACTION_NETWORK} la_socket.retrieved as la_action
				then
					action := la_action
				end
				from until (not attached action) or is_done loop
					--	On attend......... -_- zzz
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
