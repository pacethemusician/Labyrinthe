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
		-- Les `a_type' sont 1= explorateur 2= magicien
		do
			is_walking := false
			animations := a_surfaces
			make_animated_sprite (a_surfaces[1], 22, 5, a_x, a_y)
		end

feature {GAME_ENGINE} -- Implementation

	animations : LIST[GAME_SURFACE]
	approach_point (a_x, a_y, a_speed:INTEGER_32)
			-- Approche `current' du point (`a_x', `a_y') d'un maximum de
			-- `a_speed' verticalement et horizontalement.
		require
			speed_over_zero: a_speed > 0
		do
			x := x + (a_speed.min ((x - a_x).abs) * a_x.three_way_comparison (x))
			y := y + (a_speed.min ((y - a_y).abs) * a_y.three_way_comparison (y))
			if (a_x = x) and (a_y = y) then
				is_walking := false
				change_animation (animations[1], 22, 5)
			end
		end

	is_walking: BOOLEAN assign set_is_walking

	set_is_walking (a_state:BOOLEAN)
		do
			is_walking := a_state
		end

end
