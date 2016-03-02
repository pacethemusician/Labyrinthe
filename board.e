note
	description: "Classe responsable du plateau de jeu."
	author: "Charles et Pascal"
	date: "22 février 2016"
	revision: "0.1"

class
	BOARD

inherit
	SPRITE
	rename
		make as make_sprite
	end

create
	make

feature {NONE}
	make (a_surfaces:STRING_TABLE[GAME_SURFACE])
		do
			-- Image de fond:
			if attached a_surfaces["back_board"] as la_surface then
				make_sprite (la_surface)
			else
				make_sprite (create {GAME_SURFACE} .make (1, 1))
			end


			-- Position
			x := 10
			y := 10

			-- Grille de jeu

--			create l_temp_path_card.make(1)
--			l_temp_path_card_list.extend (l_temp_path_card)
--			path_card_grid.extend (l_temp_path_card_list)

		end

	rotate_column(column_id:NATURAL_8; add_on_top:BOOLEAN)
		do

		end

	rotate_row(row_id:NATURAL_8; add_on_right:BOOLEAN)
		do

		end
feature
--	path_card_grid:LIST[LIST[PATH_CARD]]

end
