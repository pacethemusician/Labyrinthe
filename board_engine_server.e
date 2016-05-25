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
			make, update,
			check_button,
			on_mouse_released,
			on_mouse_move
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
			is_my_turn := True
		end

feature

	is_my_turn: BOOLEAN
			-- 	Indique que c'est au `current_player' de jouer si c'est un joueur local

	network_action_threads: LIST[THREAD_NETWORK_CLIENT]
			-- -- Les threads réseaux qui attendent un {ACTION_NETWORK}

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
						is_my_turn := False
						across network_action_threads as la_connexions loop
							if attached {GAME_MOUSE_BUTTON_RELEASED_STATE} la_connexions.item.action as la_action then
								on_mouse_released_from_client(la_action)
								print("serveur release%N")
							elseif attached {GAME_MOUSE_BUTTON_PRESSED_STATE} la_connexions.item.action as la_action then
								check_button_from_client(la_action)
							end
							la_connexions.item.action := void
						end
					else
						is_my_turn := True
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
					if not players[current_player_index].path.is_empty then
						players[current_player_index].follow_path
					end
					if players [current_player_index].item_found_number < players [current_player_index].items_to_find.count then
						item_to_find.current_surface := (image_factory.items [players [current_player_index].items_to_find [players [current_player_index].item_found_number + 1]])
					end
					if not players[current_player_index].is_dragging then
						spare_card.approach_point (801, 144, Spare_card_speed)
					end
				end
			end
		end

	on_mouse_move (a_mouse_state: GAME_MOUSE_MOTION_STATE)
			-- Routine de mise à jour du drag and drop
		do
			if is_my_turn then
				Precursor(a_mouse_state)
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

	on_mouse_released_from_client (a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE)
			-- Méthode appelée lorsque le joueur relâche un bouton de la souris.
		do
			if players[current_player_index].is_dragging then
				if is_drop_zone (140, -28, a_mouse_state) then
					rotate (2, False, True)
				elseif is_drop_zone (308, -28, a_mouse_state) then
					rotate (4, False, True)
				elseif is_drop_zone (476, -28, a_mouse_state) then
					rotate (6, False, True)
				elseif is_drop_zone (-28, 140, a_mouse_state) then
					rotate (2, True, False)
				elseif is_drop_zone (-28, 308, a_mouse_state) then
					rotate (4, True, False)
				elseif is_drop_zone (-28, 476, a_mouse_state) then
					rotate (6, True, False)
				elseif is_drop_zone (644, 140, a_mouse_state) then
					rotate (2, True, True)
				elseif is_drop_zone (644, 308, a_mouse_state) then
					rotate (4, True, True)
				elseif is_drop_zone (644, 476, a_mouse_state) then
					rotate (6, True, True)
				elseif is_drop_zone (140, 644, a_mouse_state) then
					rotate (2, False, False)
				elseif is_drop_zone (308, 644, a_mouse_state) then
					rotate (4, False, False)
				elseif is_drop_zone (476, 644, a_mouse_state) then
					rotate (6, False, False)
				end
				players[current_player_index].is_dragging := False
			end
		end

	check_button_from_client(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Déclanche l'action des boutons d'après le `a_mouse_state' reçu via network
		do
			across buttons as la_buttons loop
				la_buttons.item.execute_actions (a_mouse_state)
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
