note
	description: "Pion d'un joueur et ses informations."
	author: "Pascal Belisle et Charles Lemay"
	date: "18 février 2016"

class
	PLAYER

inherit

	ANIMATED_SPRITE
		rename
			make as make_animated_sprite
		end

create
	make

feature {NONE} -- Initialisation

	make (a_surfaces: LIST [GAME_SURFACE]; a_x, a_y: INTEGER_32; a_score: SCORE_SURFACE)
			-- Initialisation de `Current' à la position (`a_x', `a_y').
			-- On assigne `a_surfaces' à `animations', les {SPRITE} de `Current'
			-- Le `a_score' est la surface sur laquelle on dessine le `item_found_number' et le `items_to_find'
			-- le offset x du player par rapport à la path_card est de 23 pixels.
		require
			anim_list_size: a_surfaces.count = 5
		do
			x := a_x
			y := a_y
			score := a_score
			animations := a_surfaces
			make_animated_sprite (a_surfaces [1], 22, 7, x, y)
			create {LINKED_LIST [PATH_CARD]} path.make
			create {LINKED_LIST [INTEGER]} items_to_find.make
			create item_pickup_sound_fx.make("Audio/get_item.ogg")
			create winner_sound_fx.make("Audio/winner.ogg")
			path_index := 1
			item_found_number := 0
		end

feature {ENGINE, THREAD_BOARD_ENGINE} -- Implementation

	score: SCORE_SURFACE assign set_score_surface
			-- Pointe vers la {SCORE_SURFACE} du {BOARD_ENGINE} et se met à jour lors de item_pickup

	animations: LIST [GAME_SURFACE]
			-- Liste des animations du joueur.

	path: LIST [PATH_CARD] assign set_path
			-- Le chemin que `current' peut suivre avec `follow_path'.

	items_to_find: LIST [INTEGER]
			-- La liste des items que `Current' doit trouver

	item_found_number: INTEGER assign set_item_found_number
			-- Le nombre d'items trouvés

	path_index: INTEGER
			-- L'index du {PATH} dans `current_path' vers lequel `current' se déplace.

	item_pickup_sound_fx: SOUND_FX
			-- Le son entendu quand `Current' ramasse un item
	winner_sound_fx: SOUND_FX
			-- Le son entendu quand `Current' gagne la partie

	next_x: INTEGER assign set_next_x
	next_y: INTEGER assign set_next_y
			-- L'endroit où le {PLAYER} devra se rendre s'il est sur une {PATH_CARD} qui bouge

	get_col_index: INTEGER
			-- Retourne le numéro de la colonne où se trouve `Current' sur le {BOARD}
		do
			Result := ((x - 56) // 84) + 1
		end

	get_row_index: INTEGER
			-- Retourne le numéro de la rangée où se trouve `Current' sur le {BOARD}
		do
			Result := ((y - 56) // 84) + 1
		end

	set_score_surface (a_new_score_surface: SCORE_SURFACE)
			-- Met à jour `score'
		do
			score := a_new_score_surface
		ensure
			is_assign: score = a_new_score_surface
		end

	set_path (a_path_list: LIST [PATH_CARD])
			-- Assigne `a_path_list' à `path'.
		do
			path := a_path_list
		ensure
			is_assign: path = a_path_list
		end

	set_item_found_number (a_value: INTEGER)
			-- Assigne `a_value' à `item_found_number' s'assurant qu'il y a eu incrémentation de 1 seulement
		do
			item_found_number := a_value
		ensure
			is_increment_one: item_found_number = old item_found_number + 1
		end

	set_next_x (a_value: INTEGER)
			-- Assigne `a_value' à `next_x'
		do
			next_x := a_value
		ensure
			is_assign: next_x = a_value
		end

	set_next_y (a_value: INTEGER)
			-- Assigne `a_value' à `next_y'
		do
			next_y := a_value
		ensure
			is_assign: next_y = a_value
		end

	pick_up_item (a_path_card: PATH_CARD)
			-- Si l' `item_index' de `a_path_card' est égual à `items_to_find[item_found_number + 1]',
			-- `item_index' est mis à 0 et `item_found_number' est incrémenté de 1.
		do
			if (item_found_number < items_to_find.count) then
				if (a_path_card.item_index = items_to_find [item_found_number + 1]) then
					a_path_card.item_index := 0
					if (item_found_number ~ items_to_find.count) then
						winner_sound_fx.play
					else
						item_pickup_sound_fx.play
						item_found_number := item_found_number + 1
					end
					score.update(item_found_number)
				end
			end
		end

	follow_path
			-- Fait suivre `path' à `current'. Si `current' arrive à destination, `path' est vidé.
			-- L'animation de `current' est changée selon sa position relative à la destination.
			-- La destination est `path[path_index]'. `pick_up_item' est éxécuté avec toutes les
			-- {PATH_CARD} traversées.
		require
			has_path: not path.is_empty
		do
			approach_point (path [path_index].x + X_offset, path [path_index].y, Walking_speed)
			if ((x = path [path_index].x + X_offset) and (y = path [path_index].y)) then
				pick_up_item (path [path_index])
				path_index := path_index + 1
				if path_index > path.count then
					change_animation (animations [1], 22, 7)
					path.wipe_out
					path_index := 1
				elseif (path [path_index].x > x) then
					change_animation (animations [4], 6, 7)
				elseif (path [path_index].x < x - 23) then
					change_animation (animations [5], 6, 7)
				elseif (path [path_index].y > y) then
					change_animation (animations [2], 6, 7)
				elseif (path [path_index].y < y) then
					change_animation (animations [3], 6, 7)
				end
			end
		end

feature --Constantes

	Walking_speed:INTEGER = 3

	X_offset:INTEGER = 23

invariant

note
	license: "WTFPL"
	source: "[
		Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
		Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
	]"

end
