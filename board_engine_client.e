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
		end

create
	make

feature {NONE} -- Initialization

	make (a_image_factory: IMAGE_FACTORY; a_game_window:GAME_WINDOW_SURFACED; a_socket: SOCKET)
			-- Initialisation de `Current'
		local
			l_player_data: LIST[PLAYER_DATA]
		do
			has_error := False
			socket := a_socket
			players := create_players(player_data, a_image_factory)
			my_index := get_my_index
			create board.make (a_image_factory)
			initialize (a_image_factory, a_game_window)
		end

feature

	has_error: BOOLEAN
			--

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
				end
			else	-- Si la clause 'rescue' a été utilisée, affiche un message d'erreur
				io.put_string("Le message recu n'est pas une liste valide.%N")
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
			create Result.make (a_image_factory)
			if not l_retry then		-- Si la clause 'rescue' n'a pas été utilisé, reçoit la liste
				if
					attached socket as la_socket and then
					attached {ARRAYED_LIST [ARRAYED_LIST [PATH_CARD]]} la_socket.retrieved as la_board
				then
					print("Le board est supposé etre correct")
					Result.board_paths := la_board
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
				end

			else	-- Si la clause 'rescue' a été utilisée, affiche un message d'erreur
				io.put_string("L'objet reçu n'est pas valide.%N")
			end
			rescue	-- Permet d'attraper une exception
				l_retry := True
				retry
		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
