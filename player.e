note
	description: "Pion d'un joueur et ses informations"
	author: "Pascal Belisle et Charles Lemay"
	date: "18 février 2016"
	revision: "0.1"

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

	make (a_surfaces: LIST[GAME_SURFACE]; a_x, a_y:INTEGER_32)
		-- Initialisation de `current' avec `a_default_surface' à la position (`a_x', `a_y').
		do
			animations := a_surfaces
			make_animated_sprite (a_surfaces[1], 22, 5, a_x, a_y)
			create path.make
			path_index := 1
		end

feature {GAME_ENGINE} -- Implementation

	animations : LIST[GAME_SURFACE]
		-- Liste des animations du joueur.

	path: LINKED_LIST[PATH_CARD] assign set_path
		-- Le chemin que `current' peut suivre avec `follow_path'.

	path_index: INTEGER
		-- L'index du PATH dans `current_path' vers lequel `current' se déplace.

	set_path(a_path_list: LINKED_LIST[PATH_CARD])
			-- Assigne `a_path_list' à `path'.
		do
			path := a_path_list
		end

	follow_path
			-- Fait suivre `path' à `current'. Si `current' arrive à destination, `path'
			-- est vidé. L'animation de `current' est changée selon sa position relative à la destination.
			-- La destination est `path[path_index]'.
		require
			has_path: not path.is_empty
		do
			approach_point (path[path_index].x + 23, path[path_index].y, 3)
			if (x = path[path_index].x + 23 and y = path[path_index].y) then
				path_index := path_index + 1
				if path_index > path.count then
					change_animation (animations[1], 22, 5)
					path.wipe_out
					path_index := 1
				elseif (path[path_index].x > x) then
					change_animation (animations[4], 6, 3)
				elseif (path[path_index].x < x - 23) then
					change_animation (animations[5], 6, 3)
				elseif (path[path_index].y > y) then
					change_animation (animations[2], 6, 3)
				elseif (path[path_index].y < y) then
					change_animation (animations[3], 6, 3)
				end
			end

		end

end
