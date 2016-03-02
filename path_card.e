note
	description: "Représentation objet de chaque carte chemin sur le plateau {PATH_CARD}."
	author: "Pascal Belisle"
	date: "15 Février 2016"
	revision: "0.2"

class
	PATH_CARD

inherit
	GAME_LIBRARY_SHARED
	SPRITE
		rename
			make as make_sprite
		end

create
	make

feature {NONE}

	make (a_type:NATURAL; a_surfaces: STRING_TABLE[GAME_SURFACE])
	-- Le `a_type' peut être soit 1='╗' 2='║'  3='╣'
		require
			a_type > 0
			a_type < 4

		local
			l_image_path:STRING

		do
			l_image_path := "path_card_" + a_type.out + "a"
			print(l_image_path)
			if attached a_surfaces[l_image_path] as la_surface then
				make_sprite (la_surface)
			else
				make_sprite (create {GAME_SURFACE} .make (1, 1))
			end
			can_go_right := FALSE
			can_go_down := TRUE
			if a_type = 1 then
				can_go_up := FALSE
				can_go_left := TRUE
			elseif a_type = 2 then
				can_go_up := TRUE
				can_go_left := FALSE
			elseif a_type = 3 then
				can_go_up := TRUE
				can_go_left := TRUE
			end
		end

feature {BOARD, GAME_ENGINE}

	rotate(a_angle:REAL_64) -- Rotate Clock Wise
		local
--			l_surface_temp:GAME_SURFACE_ROTATE_ZOOM
--			l_surface:GAME_SURFACE
		do
			--create l_surface.make (84, 84)
			--l_surface.draw_sub_surface (a_other: GAME_SURFACE, a_x_source, a_y_source, a_width, a_height, a_x_destination, a_y_destination: INTEGER_32)
--			create l_surface_temp.make_rotate(current_animation.frames, a_angle, False)
--			current_animation.frames := l_surface
		end

feature {NONE}
	can_go_up, can_go_right, can_go_left, can_go_down: BOOLEAN

end
