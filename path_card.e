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

	make (a_type:NATURAL)
	-- Le `a_type' peut être soit 1='╗' 2='║'  3='╣'

		local
			l_image_path:STRING
			l_image:ANIMATION

		do
			can_go_right := FALSE
			can_go_down := TRUE
			l_image_path := "Images/path_type1.png"
			if a_type = 1 then
				can_go_up := FALSE
				can_go_left := TRUE
			elseif a_type = 2 then
				can_go_up := TRUE
				can_go_left := FALSE
				l_image_path := "Images/path_type2.png"
			elseif a_type = 3 then
				can_go_up := TRUE
				can_go_left := TRUE
				l_image_path := "Images/path_type3.png"
			end
			create l_image.make (l_image_path, 1, 1)
			make_sprite(l_image)
		end

feature {BOARD, GAME_ENGINE}

	rotate(a_angle:REAL_64) -- Rotate Clock Wise
		local
			l_surface_temp:GAME_SURFACE_ROTATE_ZOOM
			l_surface:GAME_SURFACE
		do
			--create l_surface.make (84, 84)
			--l_surface.draw_sub_surface (a_other: GAME_SURFACE, a_x_source, a_y_source, a_width, a_height, a_x_destination, a_y_destination: INTEGER_32)
			create l_surface_temp.make_rotate(current_animation.frames, a_angle, False)
			current_animation.frames := l_surface
		end

feature {NONE}
	can_go_up, can_go_right, can_go_left, can_go_down: BOOLEAN

end
