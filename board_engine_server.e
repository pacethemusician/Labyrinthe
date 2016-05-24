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
			make, update, --confirm_finished,
			on_mouse_released, spare_card_click_action, board_click_action
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
				end
			end
		end

feature

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
				-- do some shit
			else
				if players[current_player_index].is_winner then
					print("Vous avez Guillaume Hamel Gagné!!!!! LOL!!!!!!!!")
					game_over := True
				else
					if attached {PLAYER_NETWORK} players[current_player_index] as la_player then
						across network_action_threads as la_connexions loop
							if attached la_connexions.item.action as la_action then
								if la_action.commande ~ "REL" then
									if attached {GAME_MOUSE_BUTTON_RELEASED_STATE} la_action.mouse_state as la_mouse_state then
										on_mouse_released(la_mouse_state)
									end
								elseif la_action.commande ~ "SPARE" then
									spare_card_click_action(la_action.mouse_state)
								elseif la_action.commande ~ "BOARD" then
									board_click_action(la_action.mouse_state)
								end
								la_connexions.item.action := void
							end

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

--	check_button(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
--		do
--			if not (attached {PLAYER_NETWORK} players[current_player_index]) then
--				across buttons as la_buttons loop
--						la_buttons.item.execute_actions (a_mouse_state)
--				end
--			end
--			across players as la_players loop
--				if attached {PLAYER_NETWORK} la_players.item as la_player then
--					if attached la_player.socket as la_socket then
--						la_socket.independent_store (a_mouse_state)
--					end
--				end
--			end
--		end

	on_mouse_released (a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE)
			-- precursor
		do
			send_action(create {ACTION_NETWORK} .make("REL", a_mouse_state))
			Precursor (a_mouse_state)
		end

	spare_card_click_action (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- precursor
		do
			send_action(create {ACTION_NETWORK} .make("SPARE", a_mouse_state))
			Precursor (a_mouse_state)
		end

	board_click_action (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- precursor
		do
			send_action(create {ACTION_NETWORK} .make("BOARD", a_mouse_state))
			Precursor (a_mouse_state)
		end

--	confirm_finished_network (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
--			-- precursor
--		do
--			Precursor
--			send_action(create {ACTION_NETWORK} .make("BOARD", a_mouse_state))
--		end

	send_action (a_action: ACTION_NETWORK)
			-- Envoie un {ACTION_NETWORK} à tous les joueurs réseau
		do
			across players as la_players loop
				if attached {PLAYER_NETWORK} la_players.item as la_player then
					if attached la_player.socket as la_socket then
						la_socket.independent_store (a_action)
						print("Action envoyée %N")
					end
				end
			end
		end

--	get_network_action:GAME_MOUSE_BUTTON_PRESSED_STATE
--		  -- Attend que le serveur envoie le `mouse_state' du client
--		local
--			l_retry: BOOLEAN
--		do
--			create Result.make (0, 0, 0, 0)
--			if not l_retry then		-- Si la clause 'rescue' n'a pas été utilisé, reçoit la liste
--				if
--					attached {PLAYER_NETWORK} players[current_player_index] as la_player and then
--					attached la_player.socket as la_socket and then
--					attached {GAME_MOUSE_BUTTON_PRESSED_STATE} la_socket.retrieved as la_mouse_state
--				then
--					Result := la_mouse_state
--				end
--			else
--				print("Erreur lors de la réception du mouse_state")
--			end
--			rescue
--				l_retry := True
--				retry
--		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
