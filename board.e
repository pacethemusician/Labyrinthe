note
	description: "Classe responsable du plateau de jeu."
	author: "Pascal"
	date: "22 f�vrier 2016"
	revision: "0.1"

class
	BOARD

inherit

create
	make

feature {NONE}
	make (a_surfaces:STRING_TABLE[GAME_SURFACE])
		do
			-- Grille de jeu
			-- "� faire..."

		end

	rotate_column(column_id:NATURAL_8; add_on_top:BOOLEAN)
		do

		end

	rotate_row(row_id:NATURAL_8; add_on_right:BOOLEAN)
		do

		end

end
