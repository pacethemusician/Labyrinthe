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

	make
		local
			l_temp_img:ANIMATION
			l_path_img_type1:ANIMATION
			l_path_img_type2:ANIMATION
			l_path_img_type3:ANIMATION
--			l_temp_path_card:PATH_CARD
--			l_temp_path_card_list:LIST[PATH_CARD]

		do
			-- Image de fond:

			create l_temp_img.make("Images/back_board.png", 1, 1)
			create l_path_img_type1.make ("", 1, 1)
			create l_path_img_type2.make ("", 1, 1)
			create l_path_img_type3.make ("", 1, 1)
			make_sprite(l_temp_img)
			set_x(10)
			set_y(10)

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
