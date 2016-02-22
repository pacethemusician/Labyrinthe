note
	description: "Classe responsable du plateau de jeu."
	author: "Charles et Pascal"
	date: "22 février 2016"
	revision: NONE

class
	BOARD

feature {NONE}

	path_card_map:ARRAY[ARRAY[PATH_CARD]]
	path_table:ARRAY[NATURAL_8]
	spare_card:PATH_CARD

	rotate_column(column_id:NATURAL_8; add_on_top:BOOLEAN)
		do

		end

	rotate_row(row_id:NATURAL_8; add_on_right:BOOLEAN)
		do

		end

	get_path_to_destination(start:TUPLE[x, y:INTEGER]; destination:TUPLE[x, y:INTEGER]):ARRAY[TUPLE[x, y:INTEGER]]
		do
			Result := [[0, 0]]
		end

end
