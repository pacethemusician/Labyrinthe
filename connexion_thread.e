note
	description: ""
	author: "Pascal Belisle"
	date: "Session Hiver 2016"
	revision: "1.0"

class
	CONNEXION_THREAD

inherit
	THREAD

	rename
		make as make_thread
	end

create
	make

feature {NONE} -- Initialization

	make (a_socket: NETWORK_STREAM_SOCKET)
			-- Initialisation de `Current'
		require
			Socket_Valid: a_socket.is_bound
		do
			has_error := False
			make_thread
			socket := a_socket
		end

feature

	has_error:BOOLEAN
			-- `True' si une erreur est arrivé à la création du `socket'

	is_connected: BOOLEAN

	socket: NETWORK_STREAM_SOCKET

	client_socket: detachable NETWORK_STREAM_SOCKET

	is_done: BOOLEAN
			-- Indique que `Current' est terminé

	execute
			-- Tâches du thread
			-- Met le `socket' en mode d'attente de connexion.
		do
			socket.listen (1)
			socket.accept
			client_socket := socket.accepted
			is_done := True
		end

invariant
	Socket_Valid: socket.is_bound

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
