note
	description: "Représentation objet de chaque carte chemin sur le plateau {PATH_CARD}."
	author: "Pascal Belisle"
	date: "15 Février 2016"
	revision: "0.2"

class
	PATH_CARD

inherit
	GAME_LIBRARY_SHARED
	GAME_SURFACE_ROTATE_ZOOM
		rename
			make as make_rotate_zoom
		end
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

	rotate_CW -- Rotate Clock Wise
		local
			l_surface:GAME_SURFACE_ROTATE_ZOOM
		do
			create l_surface.make_rotate (current_animation.frames, 90, true)
			set_animation(l_surface)
		end

	rotate_CCW -- Rotate Counter Clock Wise
		local
			l_surface:GAME_SURFACE
			l_surface_rotated:GAME_SURFACE_ROTATE_ZOOM
		do
			create l_surface_rotated.make_rotate (current_animation.frames, -90, true)
			l_surface := l_surface_rotated
			set_animation(l_surface)
		end


feature {NONE}

	can_go_up, can_go_right, can_go_left, can_go_down: BOOLEAN

end
