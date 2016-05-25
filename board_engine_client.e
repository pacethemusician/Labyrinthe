note
	description: "Classe abstraite qui contrôle le gameplay."
	author: "Pascal Belisle, Charles Lemay"
	date: "Session Hiver 2016"
	revision: "1.0"

class
	BOARD_ENGINE_CLIENT

inherit
	BOARD_ENGINE
		rename
			make as make_board_engine
		redefine
			update,	check_button, on_mouse_released, on_mouse_move
		end

create
	make

feature {NONE} -- Initialization

	make (a_image_factory: IMAGE_FACTORY; a_game_window:GAME_WINDOW_SURFACED; a_socket: SOCKET)
			-- Initialisation de `Current'
		do
			has_error := False
			socket := a_socket
			players := create_players(player_data, a_image_factory)
			my_index := get_my_index
			board := get_board(a_image_factory)
			create receive_mouse_thread.make(socket)
			receive_mouse_thread.launch
			initialize (a_image_factory, a_game_window)
		end

feature -- Access

	has_error: BOOLEAN
			-- True en cas d'erreur

	is_my_turn: BOOLEAN
			-- True si c'est au tour de `Current' à jouer
		 do
		 	Result := current_player_index ~ my_index
		 end

	receive_mouse_thread: THREAD_NETWORK_CLIENT
			-- Le thread réseau qui attend un {ACTION_NETWORK}

	my_index: INTEGER
			-- La position de `Current' dans la liste `players'

	socket : SOCKET
			-- Le socket de connexion

	create_players(a_player_data: LIST[PLAYER_DATA]; a_image_factory: IMAGE_FACTORY): LIST[PLAYER]
			-- Créer et retourne la liste des {PLAYER} choisis
		do
			create {ARRAYED_LIST[PLAYER]} Result.make(a_player_data.count)
			across a_player_data as la_players loop
				Result.extend(create {PLAYER} .make(a_image_factory, la_players.item.sprite_index,
												 	la_players.item.x,
												 	la_players.item.y,
												 	la_players.item.index, create {SCORE_SURFACE}.make (create{GAME_SURFACE}.make (1, 1),1 , 1, 0, a_image_factory)))
				Result.last.items_to_find := la_players.item.items_to_find
			end
		end

feature -- network implementation

	player_data:LIST[PLAYER_DATA]
		  -- Attend que le serveur envoie une liste de {PLAYER_DATA}
		local
			l_retry: BOOLEAN
		do
			create {ARRAYED_LIST[PLAYER_DATA]} Result.make(4)
			if not l_retry then		-- Si la clause 'rescue' n'a pas été utilisé, reçoit la liste
				if
					attached socket as la_socket and then
					attached {LIST[PLAYER_DATA]} la_socket.retrieved as la_list
				then
					Result := la_list
				else
					has_error := True
				end
			else	-- Si la clause 'rescue' a été utilisée, affiche un message d'erreur
				io.put_string("Le message recu n'est pas une liste valide.%N")
				has_error := True
			end
			rescue	-- Permet d'attraper une exception
				l_retry := True
				retry
		end

	get_board(a_image_factory: IMAGE_FACTORY):BOARD
		  -- Attend que le serveur envoie une {ARRAYED_LIST [ARRAYED_LIST [PATH_CARD]]}
		  -- `a_image_factory' pour créer le {BOARD}
		local
			l_retry: BOOLEAN
		do
			create Result.make (a_image_factory, players)
			if not l_retry then		-- Si la clause 'rescue' n'a pas été utilisé, reçoit la liste
				if
					attached socket as la_socket and then
					attached {ARRAYED_LIST [ARRAYED_LIST [PATH_CARD]]} la_socket.retrieved as la_board
				then
					Result.set_board_paths(la_board)
				else
					has_error := True
				end
			else
				has_error := True
			end
			rescue
				l_retry := True
				retry
		end

	get_my_index:INTEGER
			-- Reçoit `my_index'
		local
			l_retry: BOOLEAN
		do
			if not l_retry then		-- Si la clause 'rescue' n'a pas été utilisé, reçoit la liste
				if attached socket as la_socket then
					la_socket.read_integer
					Result := la_socket.last_integer
				else
					has_error := True
				end
			else	-- Si la clause 'rescue' a été utilisée, affiche un message d'erreur
				io.put_string("L'objet reçu n'est pas valide.%N")
				has_error := True
			end
			rescue	-- Permet d'attraper une exception
				l_retry := True
				retry
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
					socket.independent_store (True)
					if not is_my_turn then
						if attached {GAME_MOUSE_BUTTON_RELEASED_STATE} receive_mouse_thread.mouse_state as la_mouse_state then
							on_mouse_released_from_server(la_mouse_state)
						elseif attached {GAME_MOUSE_BUTTON_PRESSED_STATE} receive_mouse_thread.mouse_state as la_mouse_state then
							check_button_from_server(la_mouse_state)
						end
						receive_mouse_thread.mouse_state := void
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
						item_to_find.current_surface := (image_factory.items [players [my_index].items_to_find [players [current_player_index].item_found_number + 1]])
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

	check_button (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- <Precursor>
		do
			if is_my_turn then
				Precursor(a_mouse_state)
				socket.independent_store (a_mouse_state)
			end
		end

	check_button_from_server(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Déclanche l'action des boutons d'après le `a_mouse_state' reçu via network
		do
			across buttons as la_buttons loop
				la_buttons.item.execute_actions (a_mouse_state)
			end
		end

	on_mouse_released (a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE)
			-- <Precursor>
			-- On ajoute une condition pour gérer le réseau
		do
			if is_my_turn then
				Precursor(a_mouse_state)
				socket.independent_store(a_mouse_state)
			end
		end

	on_mouse_released_from_server (a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE)
			-- Méthode appelée lorsque un des autres joueurs réseau relâche un bouton de la souris.
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

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
