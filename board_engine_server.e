note
	description: "Classe abstraite qui contrôle le gameplay."
	author: "Pascal Belisle, Charles Lemay"
	date: "Mars 2016"
	revision: ""

class
	BOARD_ENGINE_SERVER

inherit
	BOARD_ENGINE
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_image_factory: IMAGE_FACTORY; a_players: LIST[PLAYER]; a_game_window:GAME_WINDOW_SURFACED)
			-- Initialisation de `Current'
		do
			Precursor(a_image_factory, a_players, a_game_window)
			send_stuff
		end

feature

	send_stuff
			-- Envoie le stuff aux joueurs en réseau
		do
			send_player_data
			send_player_indexes
			-- send_board

		end

	send_player_data
			-- Envoie les {PLAYER_DATA} au joueur `a_player'
		do
			across players as la_players loop
				if attached {PLAYER_NETWORK} la_players.item as la_player then
					if attached la_player.socket as la_socket then
						la_socket.independent_store (player_data)
					end
				end
			end
		end

	send_board
			-- Envoie le {BOARD} aux joueurs en réseau
		do
			across players as la_players loop
				if attached {PLAYER_NETWORK} la_players.item as la_player then
					if attached la_player.socket as la_socket then
						la_socket.independent_store (board.board_paths)
					end
				end
			end
		end

	send_player_indexes
			-- Envoie les index des joueurs pour qu'ils sachent quand c'est leur tour
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > players.count
			loop
				if attached {PLAYER_NETWORK} players[i] as la_player then
					if attached la_player.socket as la_socket then
						la_socket.put_integer (i)
					end
				end
				i := i + 1
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
												 la_players.item.index,
												 la_players.item.items_to_find))
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
