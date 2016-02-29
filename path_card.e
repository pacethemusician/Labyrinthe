note
	description: "Représentation objet de chaque carte chemin sur le plateau {PATH_CARD}."
	author: "Pascal Belisle"
	date: "15 Février 2016"
	revision: "0.1"

class
	PATH_CARD

inherit
	SPRITE
		rename
			make as make_sprite
		end

create
	make_down_left,
	make_up_down,
	make_up_down_left

feature {NONE}

	make_down_left
		local
			l_animation:ANIMATION
		do
			create l_animation.make ("path_down_left.png", 1, 1)
			make_sprite(l_animation)
			angle := 0.0
		end

	make_up_down
		local
			l_animation:ANIMATION
		do
			create l_animation.make ("path_up_down.png", 1, 1)
			make_sprite(l_animation)
			angle := 0.0
		end

	make_up_down_left
		local
			l_animation:ANIMATION
		do
			create l_animation.make ("path_up_down_left.png", 1, 1)
			make_sprite(l_animation)
			angle := 0.0
		end

--	make_random
--		do
--			random(1..3)
--			if 1 then
--				make_down_left
--			elseif 2 then
--				make_up_down
--			elseif 3 then
--				make_up_down_left
--			end

--			random(1..20)
--			from i
--			until <
--			loop
--				rotate_left
--			end
--		end

feature
	rotate_random
		do

		end

	rotate_left
		local
			l_surface:GAME_SURFACE_ROTATE_ZOOM
		do
			angle := angle - 90.0
			create l_surface.make_rotate (current_animation.frames, -90, a_smooth: BOOLEAN)
			l_surface

		end

	rotate_right
		do

		end

	angle:REAL_64

feature {NONE}

	is_walkable (a_direction: INTEGER): BOOLEAN
		do
		end

	draw_self
		do
				-- "DRAW_ROTATED(`rotation' * 90)"
		end

feature {NONE} -- Attributs

	type: INTEGER

	rotation: INTEGER

	-- path_table: LIST[NATURAL_8]

	-- items_on_top: LIST[ITEM]

end
