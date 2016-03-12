note
	description: "Pion d'un joueur et ses informations"
	author: "Pascal Belisle et Charles Lemay"
	date: "18 f�vrier 2016"
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
		-- Les `a_type' sont 1= explorateur 2= magicien
		do
			animations := a_surfaces
			make_animated_sprite (a_surfaces[1], 22, 5, a_x, a_y)
			create current_path.make
			path_index := 1
		end

feature {GAME_ENGINE} -- Implementation

	animations : LIST[GAME_SURFACE]
		-- Liste des animations du joueur.

	current_path: LINKED_LIST[PATH_CARD] assign set_current_path
		-- Le chemin que `current' peut suivre avec `follow_path'.

	path_index: INTEGER
		-- L'index du PATH dans `current_path' vers lequel `current' se d�place.

	set_current_path(a_path_list: LINKED_LIST[PATH_CARD])
		do
			current_path := a_path_list
		end

	follow_path
			-- Fait suivre `current_path' � `current'. Si `current' arrive � destination, `current_path'
			-- est vid�. L'animation de `current' est chang�e selon sa position relative � la destination.
			-- La destination est `current_path[path_index]'.
		require
			has_path: not current_path.is_empty
		do
			approach_point (current_path[path_index].x + 79, current_path[path_index].y + 56, 3)
			if (x = current_path[path_index].x + 79 and y = current_path[path_index].y + 56) then
				path_index := path_index + 1
				if path_index > current_path.count then
					change_animation (animations[1], 22, 5)
					current_path.wipe_out
					path_index := 1
				elseif (current_path[path_index].x + 56 > x) then
					change_animation (animations[4], 6, 3)
				elseif (current_path[path_index].x + 56 < x - 23) then
					change_animation (animations[5], 6, 3)
				elseif (current_path[path_index].y + 56 > y) then
					change_animation (animations[2], 6, 3)
				elseif (current_path[path_index].y + 56 < y) then
					change_animation (animations[3], 6, 3)
				end
			end

		end

end
