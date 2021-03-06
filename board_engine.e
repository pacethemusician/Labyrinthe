note
	description: "Classe abstraite qui contr�le le gameplay."
	author: "Pascal Belisle, Charles Lemay"
	date: "Mars 2016"
	revision: ""

class
	BOARD_ENGINE

inherit

	MENU
		rename
			make as make_menu
		redefine
			show
		end

create
	make

feature {NONE} -- Initialization


	make (a_image_factory: IMAGE_FACTORY; a_players: LIST[PLAYER]; a_game_window: GAME_WINDOW_SURFACED)
			-- Initialisation de `Current'
			-- <Precursor>
		do
			players := a_players
			create board.make (a_image_factory, players)
			initialize (a_image_factory, a_game_window)
		end


	initialize (a_image_factory: IMAGE_FACTORY; a_game_window: GAME_WINDOW_SURFACED)
			-- Suite de l'initialisation de `Current'
		require
			Player_Is_Created: attached players
		do
			make_menu (a_image_factory)
			current_player_index := 1
			create sound_fx_rotate.make ("Audio/rotate.wav")
			create {LINKED_LIST [PLAYER]} players_to_move.make
			create {LINKED_LIST [SPRITE]} on_screen_sprites.make
			create spare_card.make (3, image_factory, 801, 144, 1, 0)
			create sound_fx_ok.make ("Audio/sfx_ok.wav")
			create sound_fx_slide.make ("Audio/sfx_slide.wav")
			create background.make (image_factory.backgrounds [1], 0, 0)
			create btn_ok.make (image_factory.buttons [11], 945, 245)
			create btn_rotate_left.make (image_factory.buttons [1], 745, 159)
			create btn_rotate_right.make (image_factory.buttons [2], 904, 159)
			create {ARRAYED_LIST [SPRITE]} on_screen_sprites.make (100)
			create text_player.make (image_factory.text [current_player_index], 795, 35)
			create circle_btn_ok.make (image_factory.backgrounds [3], 72, 1, 922, 222)
			create circle_player.make (image_factory.backgrounds [3], 72, 1, players [current_player_index].x - 23, players [current_player_index].y)
			create score.make (create {GAME_SURFACE}.make (1, 1), 880, 627, (24 // players.count), a_image_factory)
			create item_to_find.make (a_image_factory.items [players [1].items_to_find.first], 801, 327)
			on_screen_sprites.extend (background)
			on_screen_sprites.extend (btn_rotate_left)
			on_screen_sprites.extend (btn_rotate_right)
			on_screen_sprites.extend (item_to_find)
			across
				board.board_paths as la_rows
			loop
				across
					la_rows.item as la_cards
				loop
					on_screen_sprites.extend (la_cards.item)
					if attached {BUTTON} la_cards.item as la_button then
						buttons.extend (la_button)
					end
				end
			end
			across
				players as la_players
			loop
				la_players.item.set_score_surface (score)
			end
			on_screen_sprites.extend (text_player)
			on_screen_sprites.extend (score)
			on_screen_sprites.extend (spare_card)
			board.on_click_actions.extend (agent board_click_action)
			spare_card.on_click_actions.extend (agent spare_card_click_action(?))
			btn_rotate_left.on_click_actions.extend (agent rotate_spare_card(-1))
			btn_rotate_right.on_click_actions.extend (agent rotate_spare_card(1))
			btn_ok.on_click_actions.extend (agent confirm_finished)
			buttons.extend (btn_rotate_left)
			buttons.extend (btn_rotate_right)
			buttons.extend (spare_card)
			buttons.extend (board)
			buttons.extend (btn_ok)
			has_to_place_spare_card := True
			score.update (players [current_player_index].item_found_number)
		end

feature --

	board: BOARD
			-- Le board principal contenant les {PATH_CARD}

	game_over: BOOLEAN
			-- True lorsqu'un joueur gagne la partie

	score: SCORE_SURFACE
			-- {GAME_SURFACE} indiquant le nombre d'items trouv�s et le nombre � trouver

	circle_btn_ok: ANIMATED_SPRITE
			-- Rep�re visuel pour `btn_ok'

	circle_player: ANIMATED_SPRITE
			-- Rep�re visuel pour le `players[current_player_index]'

	sound_fx_rotate: SOUND_FX
			-- Le son jou� lorsque le {PLAYER} tourne la `spare_card'

	sound_fx_ok: SOUND_FX
			-- Le son jou� lorsque le {PLAYER} click sur `btn_ok'

	sound_fx_slide: SOUND_FX
			-- Le son jou� lorsque le {PLAYER} drop la `spare_card' avec succ�s

	spare_card: SPARE_PATH_CARD
			-- la carte que le joueur doit placer

	has_to_move: BOOLEAN
			-- True si le joueur a plac� la `spare_card'

	has_to_place_spare_card: BOOLEAN
			-- True si le joueur doit plac� la `spare_card'

	btn_ok: BUTTON
			-- Le joueur confirme la fin de son tour apr�s qu'il ait plac� la `spare_card' et boug� son personnage

	btn_rotate_left, btn_rotate_right: BUTTON
			-- Les boutons qui tourne la `spare_card'

	players: LIST [PLAYER]
			-- La liste de tous les {PLAYER} actifs

	players_to_move: LIST [PLAYER]
			-- On y met les {PLAYER} qui devront bouger en m�me temps que les {PATH_CARD}

	current_player_index: INTEGER
			-- Index vers le {PLAYER} dans `players' dont c'est le tour � jouer.

	item_to_find: SPRITE
			-- L'image de l'item � trouver

	text_player: SPRITE
			-- L'image o� il est �crit c'est � qui le tour � jouer. S'affiche en haut � droite de l'�cran.

	rotate_spare_card (a_steps: INTEGER)
			-- M�thode qui se d�clenche lorsqu'on clique sur `btn_rotate_left' ou `btn_rotate_right'.
			-- `a_steps' -> Combien de fois on doit tourner.
		require
			a_steps.abs <= 4
		do
			if has_to_place_spare_card then
				spare_card.rotate (a_steps)
				sound_fx_rotate.play
			end
		end

	on_mouse_move (a_mouse_state: GAME_MOUSE_MOTION_STATE)
			-- Routine de mise � jour du drag and drop.
			-- `a_mouse_state' -> L'�tat de la souris.
		do
			if players[current_player_index].is_dragging then
				spare_card.x := a_mouse_state.x - spare_card.x_offset
				spare_card.y := a_mouse_state.y - spare_card.y_offset
			end
		end

	is_drop_zone (a_x, a_y: INTEGER; a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE): BOOLEAN
			-- V�rifie que la {SPARE_PATH_CARD} est au dessus d'une zone dropable lors du mouse release selon les coordonn�es
		do
			Result := (a_mouse_state.x >= a_x) and (a_mouse_state.x < a_x + 84) and (a_mouse_state.y >= a_y) and (a_mouse_state.y < a_y + 84)
		end

	rotate (a_index: NATURAL_8; a_is_row, a_is_from_top_or_right: BOOLEAN)
			-- Appelle la fonction de rotation du {BOARD} selon `a_index'
			-- Si `a_is_row' est vrai, on bouge une rang�e sinon une colonne
		local
			l_next_spare_card: SPARE_PATH_CARD
		do
			sound_fx_slide.play
			if a_is_row then
				l_next_spare_card := board.get_next_spare_card_row (a_index, a_is_from_top_or_right)
				across
					players as la_players
				loop
					if la_players.item.row_index ~ a_index then
						players_to_move.extend (la_players.item)
						if a_is_from_top_or_right then
							if la_players.item.column_index ~ 1 then
								la_players.item.x := 667
							end
							la_players.item.next_x := la_players.item.x - 84
						else
							if la_players.item.column_index ~ 7 then
								la_players.item.x := -5
							end
							la_players.item.next_x := la_players.item.x + 84
						end
						la_players.item.next_y := la_players.item.y
					end
				end
				board.rotate_row (a_index, spare_card, a_is_from_top_or_right)
			else
				l_next_spare_card := board.get_next_spare_card_column (a_index, a_is_from_top_or_right)
				across
					players as la_players
				loop
					if la_players.item.column_index ~ a_index then
						players_to_move.extend (la_players.item)
						if a_is_from_top_or_right then
							if la_players.item.row_index ~ 7 then
								la_players.item.y := -28
							end
							la_players.item.next_y := la_players.item.y + 84
						else
							if la_players.item.row_index ~ 1 then
								la_players.item.y := 644
							end
							la_players.item.next_y := la_players.item.y - 84
						end
						la_players.item.next_x := la_players.item.x
					end
				end
				board.rotate_column (a_index, spare_card, a_is_from_top_or_right)
			end
			players [current_player_index].pick_up_item ((board.board_paths [players [current_player_index].row_index]) [players [current_player_index].column_index])
			spare_card.on_click_actions.wipe_out
			spare_card := l_next_spare_card
			on_screen_sprites.start
			on_screen_sprites.prune (spare_card)
			on_screen_sprites.extend (spare_card)
			spare_card.on_click_actions.extend (agent spare_card_click_action(?))
			has_to_move := True
			has_to_place_spare_card := False
		end

	on_mouse_released (a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE)
			-- M�thode appel�e lorsque le joueur rel�che un bouton de la souris.
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

	spare_card_click_action (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Initialise le drag et calcul le offset par rapport aux coordonn�es de `a_mouse_state'
		do
			if has_to_place_spare_card then
				players[current_player_index].is_dragging := True
				spare_card.set_x_offset (a_mouse_state.x - spare_card.x)
				spare_card.set_y_offset (a_mouse_state.y - spare_card.y)
			end
		end

	board_click_action (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Action � faire si l'usager clique sur le {BOARD}
		local
			l_player_col_index, l_player_row_index: INTEGER
			l_mouse_col_index, l_mouse_row_index: INTEGER
			-- Ces coordonn�es donnent un chiffre de 1 � 7 pour servir d'index pour acc�der au vecteur de {PATH_CARD} du {BOARD}
		do
			if has_to_move then
				l_player_col_index := players [current_player_index].column_index
				l_player_row_index := players [current_player_index].row_index
				l_mouse_col_index := ((a_mouse_state.x - 56) // 84) + 1
				l_mouse_row_index := ((a_mouse_state.y - 56) // 84) + 1
				if players [current_player_index].path.is_empty then
					if not ((l_player_col_index = l_mouse_col_index) and (l_player_row_index = l_mouse_row_index)) then
						players [current_player_index].path := board.pathfind_to (l_player_col_index, l_player_row_index, l_mouse_col_index, l_mouse_row_index)
					end
				end
			end
		end

	confirm_finished
			-- Confirme que le joueur a fini son tour
		do
			if has_to_move and players[current_player_index].path.is_empty then
				current_player_index := (current_player_index \\ players.count) + 1
				has_to_move := False
				has_to_place_spare_card := True
				text_player.current_surface := (image_factory.text [current_player_index])
				circle_player.x := players [current_player_index].x - players [current_player_index].X_offset
				circle_player.y := players [current_player_index].y
				sound_fx_ok.play
				if not (players [current_player_index].item_found_number ~ players [current_player_index].items_to_find.count) then
					score.update (players [current_player_index].item_found_number)
				end
				players [current_player_index].pick_up_item ((board.board_paths [players [current_player_index].row_index]) [players [current_player_index].column_index])
			end
		end

	show(a_game_window:GAME_WINDOW_SURFACED)
			-- <Precursor>
		do
			across
				on_screen_sprites as l_sprites
			loop
				l_sprites.item.draw_self (a_game_window.surface)
			end
			if has_to_move then
				btn_ok.draw_self (a_game_window.surface)
				circle_btn_ok.draw_self (a_game_window.surface)
			end
			circle_player.draw_self (a_game_window.surface)
			across
				players as la_players
			loop
				la_players.item.draw_self (a_game_window.surface)
			end
		end

	update
			-- Fonction s'ex�cutant � chaque frame. On affiche chaque sprite sur `a_game_window'
		do
			if players[current_player_index].is_winner then
				print("Vous avez Guillaume Hamel Gagn� LOL!")
				game_over := True
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
					if players [current_player_index].item_found_number <= players [current_player_index].items_to_find.count then
						item_to_find.current_surface := (image_factory.items [players [current_player_index].items_to_find [players [current_player_index].item_found_number + 1]])
					end
				end
				if not players[current_player_index].is_dragging then
					spare_card.approach_point (801, 144, Spare_card_speed)
				end
			end
		end

feature {NONE} -- Constantes

	Spare_card_speed: INTEGER = 64

	Path_cards_speed: INTEGER = 3

invariant

note
	license: "WTFPL"
	source: "[
		Ce jeu a �t� fait dans le cadre du cours de programmation orient�e object II au Cegep de Drummondville 2016
		Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
	]"

end
