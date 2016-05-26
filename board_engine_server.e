note
	description: "Classe abstraite qui contrôle le gameplay."
	author: "Pascal Belisle, Charles Lemay"
	date: "Mars 2016"
	revision: ""

class
	BOARD_ENGINE_SERVER

inherit
	BOARD_NETWORK
		redefine
			make, update,
			check_button,
			on_mouse_released,
			confirm_finished
		end

create
	make

feature {NONE} -- Initialization

	make (a_image_factory: IMAGE_FACTORY; a_players: LIST[PLAYER]; a_game_window:GAME_WINDOW_SURFACED)
			-- Initialisation de `Current'
		do
			create {LINKED_LIST[THREAD_NETWORK_CLIENT]} network_action_threads.make
			Precursor(a_image_factory, a_players, a_game_window)
			send_stuff
			across players as la_players loop
				if attached {PLAYER_NETWORK} la_players.item as la_player then
					network_action_threads.extend(create {THREAD_NETWORK_CLIENT} .make(la_player.socket))
					network_action_threads.last.launch
				end
			end
		end

feature

	network_action_threads: LIST[THREAD_NETWORK_CLIENT]
			-- Les threads réseaux qui attendent un {ACTION_NETWORK}

	send_stuff
			-- Envoie le stuff aux joueurs en réseau
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
			-- Envoie le `board_paths' du `board' aux joueurs en réseau
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

	update
			-- Fonction s'exécutant à chaque frame. On affiche chaque sprite sur `a_game_window'
		do
			if game_over then
				print("Merci d'avoir joué!!!")
			else
				if players[current_player_index].is_winner then
					print("Vous avez Guillaume Hamel Gagné!!!!! LOL!!!!!!!!")
					game_over := True
				else
					across players as la_players loop
						if attached {PLAYER_NETWORK} la_players.item as la_player then
							la_player.socket.independent_store (True)
						end
					end
					if attached {PLAYER_NETWORK} players[current_player_index] as la_player then
						across network_action_threads as la_connexions loop
							if attached {GAME_MOUSE_BUTTON_RELEASED_STATE} la_connexions.item.mouse_state as la_mouse_state then
								on_mouse_released_network(la_mouse_state)
							elseif attached {GAME_MOUSE_BUTTON_PRESSED_STATE} la_connexions.item.mouse_state as la_mouse_state then
								check_button_network(la_mouse_state)
							end
							la_connexions.item.mouse_state := void
						end
					end
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
					if players[current_player_index].path.is_empty then
						if network_has_finished then
							confirm_finished
							network_has_finished := False
						end
					else
						players[current_player_index].follow_path
						if players [current_player_index].item_found_number <= players [current_player_index].items_to_find.count then
							if not attached {PLAYER_NETWORK} players [current_player_index] then
								item_to_find.current_surface := (image_factory.items [players [current_player_index].items_to_find [players [current_player_index].item_found_number + 1]])
							end
						end
					end
					if not players[current_player_index].is_dragging then
						spare_card.approach_point (801, 144, Spare_card_speed)
					end
				end
			end
		end

	send_mouse_state(a_mouse_state: GAME_MOUSE_STATE)
			-- Envoie le `mouse_state' DUH!!!
		do
			across players as la_players loop
				if attached {PLAYER_NETWORK} la_players.item as la_player then
					if attached la_player.socket as la_socket then
						la_socket.independent_store (a_mouse_state)
					end
				end
			end
		end

	check_button (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- <Precursor>
		do
			if is_my_turn then
				Precursor(a_mouse_state)
				send_mouse_state(a_mouse_state)
			end
		end

	on_mouse_released (a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE)
			-- <Precursor>
			-- On ajoute une condition pour gérer le réseau
		do
			if is_my_turn then
				Precursor(a_mouse_state)
				send_mouse_state(a_mouse_state)
			end
		end

	confirm_finished
			-- <Precursor>
		do
			if has_to_move and players[current_player_index].path.is_empty then
				Precursor
			else
				network_has_finished := True
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
