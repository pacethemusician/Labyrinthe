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
			socket := a_socket
			players := create_players(player_data, a_image_factory)
			initialize (a_image_factory, a_game_window)
			-- my_index := a_my_index -- y faut savoir son index dans la shit
			io.put_string ("Création du Board Engine Client")
		end

feature

	my_index: INTEGER
			-- La position de `Current' dans la liste `players'

	socket : SOCKET
			-- Le socket de connexion

	create_players(a_player_data: LIST[PLAYER_DATA]; a_image_factory: IMAGE_FACTORY): LIST[PLAYER]
			-- Créer et retourne la liste des {PLAYER} choisis
		do
			create {ARRAYED_LIST[PLAYER]} Result.make(player_data.count)
			across a_player_data as la_players loop
				Result.extend(create {PLAYER} .make(a_image_factory, la_players.item.sprite_index,
												 	la_players.item.x,
												 	la_players.item.y,
												 	la_players.item.index, create {SCORE_SURFACE}.make (create{GAME_SURFACE}.make (1, 1),1 , 1, 0, a_image_factory)))
			end
		end

feature -- network implementation

	player_data:LIST[PLAYER_DATA]
		  -- Attend que le serveur envoie une liste de {PLAYER}
		local
			l_retry: BOOLEAN
		do
			create {ARRAYED_LIST[PLAYER_DATA]} Result.make(4)
			if not l_retry then		-- Si la clause 'rescue' n'a pas été utilisé, reçoit la liste
				if
					attached socket as la_socket and then
					attached {LIST[PLAYER_DATA]} la_socket.retrieved as la_list
				then
					io.put_string("Liste reçue: %N")
					Result := la_list
				end

			else	-- Si la clause 'rescue' a été utilisée, affiche un message d'erreur
				io.put_string("Le message recu n'est pas une liste valide.%N")
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
