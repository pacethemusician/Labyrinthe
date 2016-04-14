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

	make (a_surfaces: LIST [GAME_SURFACE]; a_x, a_y: INTEGER_32)
			-- Initialisation de `current' à la position (`a_x', `a_y').
			-- le offset x du player par rapport à la path_card est de 23 pixels
		do
			x := a_x
			y := a_y
			animations := a_surfaces
			make_animated_sprite (a_surfaces [1], 22, 5, x, y)
			create {LINKED_LIST[PATH_CARD]} path.make
			create {LINKED_LIST[INTEGER]} items_to_find.make
			path_index := 1
			item_found_number := 0

		end

feature {ENGINE} -- Implementation

	animations: LIST [GAME_SURFACE]
			-- Liste des animations du joueur.

	path: LIST [PATH_CARD] assign set_path
			-- Le chemin que `current' peut suivre avec `follow_path'.

	items_to_find: LIST[INTEGER]
	item_found_number: INTEGER assign set_item_found_number

	path_index: INTEGER
			-- L'index du {PATH} dans `current_path' vers lequel `current' se déplace.

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

	next_x: INTEGER assign set_next_x
	next_y: INTEGER assign set_next_y
			-- Où le {PLAYER} devra se rendre s'il est sur une {PATH_CARD} qui bouge

	set_path (a_path_list: LIST [PATH_CARD])
			-- Assigne `a_path_list' à `path'.
		do
			path := a_path_list
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
		end

	set_next_y (a_value: INTEGER)
			-- Assigne `a_value' à `next_y'
		do
			next_y := a_value
		end

	follow_path
			-- Fait suivre `path' à `current'. Si `current' arrive à destination, `path' est vidé.
			-- L'animation de `current' est changée selon sa position relative à la destination.
			-- La destination est `path[path_index]'. Si une des {PATH_CARD} traversée a comme
			-- `item_index' l'item que `current' doit trouver, l' `item_index' est mis à 0 et
			-- `item_found_number' est incrémenté de 1.
		require
			has_path: not path.is_empty
		do
			approach_point (path [path_index].x + 23, path [path_index].y, 3)
			if ((x = path [path_index].x + 23) and (y = path [path_index].y)) then
				if (item_found_number < items_to_find.count) then
					if (path [path_index].item_index = items_to_find[item_found_number + 1]) then
						path [path_index].item_index := 0
						item_found_number := item_found_number + 1
					end
				end
				path_index := path_index + 1
				if path_index > path.count then
					change_animation (animations [1], 22, 5)
					path.wipe_out
					path_index := 1
				elseif (path [path_index].x > x) then
					change_animation (animations [4], 6, 3)
				elseif (path [path_index].x < x - 23) then
					change_animation (animations [5], 6, 3)
				elseif (path [path_index].y > y) then
					change_animation (animations [2], 6, 3)
				elseif (path [path_index].y < y) then
					change_animation (animations [3], 6, 3)
				end
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
