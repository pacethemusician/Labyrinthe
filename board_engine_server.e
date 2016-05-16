note
	description: "Classe abstraite qui contrôle le gameplay."
	author: "Pascal Belisle, Charles Lemay"
	date: "Mars 2016"
	revision: ""

class
	BOARD_ENGINE_SERVER

inherit
	BOARD_ENGINE
		rename
			make as make_board_engine
		end

create
	make

feature {NONE} -- Initialization

	make (a_image_factory: IMAGE_FACTORY; a_players: LIST[PLAYER]; a_game_window:GAME_WINDOW_SURFACED; a_socket_serveur:NETWORK_STREAM_SOCKET)
			-- Initialisation de `Current'
		do
			players := a_players
			initialize (a_image_factory, a_game_window)
			socket_serveur := a_socket_serveur
			send_player_data
		end

feature

	socket_serveur:detachable NETWORK_STREAM_SOCKET
			-- Connection réseau

	send_player_data
			-- Envoie la liste `players' au joueur `a_player'
		require
			Socket_valid: attached socket_serveur as la_socket and then la_socket.is_connected
		do
			if attached socket_serveur as la_socket then
				la_socket.independent_store (player_data)
				print("La liste a ete envoyee!")
			end
		end

	player_data:LIST[PLAYER_DATA]
			-- Prépare les données pour envoyer sur le réseau selon les {PLAYER} choisis
		do
			create {ARRAYED_LIST[PLAYER_DATA]} Result.make (players.count)
			across players as la_players loop
				Result.extend(create {PLAYER_DATA} .make(la_players.item.x,
												 la_players.item.y,
												 la_players.item.sprite_index,
												 la_players.item.index))
			end
		end


invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
