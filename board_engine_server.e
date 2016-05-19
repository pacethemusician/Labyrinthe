note
	description: "Classe abstraite qui contr�le le gameplay."
	author: "Pascal Belisle, Charles Lemay"
	date: "Mars 2016"
	revision: ""

class
	BOARD_ENGINE_SERVER

inherit
	BOARD_ENGINE
		redefine
			make, update
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
			-- Envoie le stuff aux joueurs en r�seau
		do
			send_player_data
			send_player_indexes
			send_board

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
			-- Envoie le {BOARD} aux joueurs en r�seau
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
			-- Pr�pare les donn�es pour envoyer sur le r�seau selon les {PLAYER} choisis
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

	update
			-- Fonction s'ex�cutant � chaque frame. On affiche chaque sprite sur `a_game_window'
		do
			if game_over then
				-- do some shit
			else
				if players[current_player_index].is_winner then
					print("Vous avez gagnez LOL!")
					game_over := True
				else
					if attached {PLAYER_NETWORK} players[current_player_index] as la_player then
						check_button(get_network_action)
					else
						board.adjust_paths (Path_cards_speed)
						if not players_to_move.is_empty then
							across
								players_to_move as la_players
							loop
								la_players.item.approach_point (la_players.item.next_x, la_players.item.next_y, Path_cards_speed)
							end
							if (players_to_move [1].next_x = players_to_move [1].x) and (players_to_move [1].next_y = players_to_move [1].y) then
								players_to_move.wipe_out
							end
						end
						if not players[current_player_index].path.is_empty then
							players[current_player_index].follow_path
						end
						if players [current_player_index].item_found_number < players [current_player_index].items_to_find.count then
							item_to_find.current_surface := (image_factory.items [players [current_player_index].items_to_find [players [current_player_index].item_found_number + 1]])
						end
						if not is_dragging then
							spare_card.approach_point (801, 144, Spare_card_speed)
						end
					end
				end
			end
		end

	get_network_action:GAME_MOUSE_BUTTON_PRESSED_STATE
		  -- Attend que le serveur envoie le `mouse_state' du client
		local
			l_retry: BOOLEAN
		do
			create Result.make (0, 0, 0, 0)
			if not l_retry then		-- Si la clause 'rescue' n'a pas �t� utilis�, re�oit la liste
				if
					attached {PLAYER_NETWORK} players[current_player_index] as la_player and then
					attached la_player.socket as la_socket and then
					attached {GAME_MOUSE_BUTTON_PRESSED_STATE} la_socket.retrieved as la_mouse_state
				then
					Result := la_mouse_state
				end
			else
				print("Erreur lors de la r�ception du mouse_state")
			end
			rescue
				l_retry := True
				retry
		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a �t� fait dans le cadre du cours de programmation orient�e object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
