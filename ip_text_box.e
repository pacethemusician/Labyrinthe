note
	description: "Boîte de texte qui permet d'entrer une adresse IPv4."
	author: "Charles Lemay"
	date: "2016-05-10"
	revision: "1.0"

class
	IP_TEXT_BOX

inherit

	SPRITE
		rename
			make as make_sprite
		redefine
			draw_self
		end

create
	make

feature {NONE} -- Initialisation

	make (a_background: GAME_SURFACE; a_digit_surfaces: LIST [GAME_SURFACE]; a_x, a_y, a_text_x_offset, a_text_y_offset: INTEGER_32)
			-- Initialisation de `current'. `a_background' est la surface qui est affichée derière le texte. Le texte
			-- est affiché à la coordonnée (`a_text_x_offset', `a_text_y_offset') relative à la position de l'image de fond.
			-- `a_digit_surfaces' sont les images représentant les 10 chiffres.
		require
			digit_surfaces_count_valid: a_digit_surfaces.count = 10
		do
			make_sprite (a_background, a_x, a_y)
			digit_surfaces := a_digit_surfaces
			text_x_offset := a_text_x_offset
			text_y_offset := a_text_y_offset
			create digit_list.make (digit_limit)
		end

feature {NONE} -- Implementation

	text_x_offset: INTEGER
		-- Distance du texte par rapport à `x'.

	text_y_offset: INTEGER
		-- Distance du texte par rapport à `y'.

	digit_surfaces: LIST [GAME_SURFACE]
		-- Liste des surfaces représentant tous les chiffres.

	digit_list: ARRAYED_LIST [INTEGER]
		-- Liste des chiffres entrés dans `current'.

	digit_limit: INTEGER = 12
		-- La limite des chiffres qui peuvent être entrés.

	space_width: INTEGER = 12
		-- Taille en pixels entre les groupes de trois chiffres lorsqu'ils sont affichés.

	update (a_key_state: GAME_KEY_STATE)
			-- Mets à jour l'état de `current' selon `a_key_state'. Si la touche "backspace" est
			-- entrée, un chiffre est supprimé de `digit_list'. Si un chiffre est entré et que `digit_list'
			-- n'est pas plein, il est ajouté à `digit_list'.
		do
			if (a_key_state.is_backspace) then
				digit_list.move (digit_list.count)
				digit_list.remove
			elseif (a_key_state.virtual_code >= 48 and a_key_state.virtual_code <= 57 and not digit_list.full) then
				digit_list.extend (a_key_state.virtual_code - 48)
			end
		end

	draw_self (a_destination_surface: GAME_SURFACE)
			-- Dessiner `current_surface' sur `destination_surface', ainsi que
			-- les chiffres contenus dans `digit_list'.
		local
			l_text_length: INTEGER
		do
			l_text_length := 0
			precursor (a_destination_surface)
			across
				digit_list as la_digit
			loop
				a_destination_surface.draw_surface (digit_surfaces [la_digit.item - 1], x + text_x_offset + l_text_length, y + text_y_offset)
				l_text_length := l_text_length + digit_surfaces [la_digit.item - 1].width
				if ((la_digit.cursor_index \\ 3) = 0 and not la_digit.is_last) then
					l_text_length := l_text_length + space_width
				end
			end
		end

	get_ip: STRING
			-- Retourne le contenu de `digit_list' dans un {STRING} sous la forme d'une adresse IP.
		require
			digit_list_full: digit_list.full
		do
			result := ""
			across
				digit_list as la_digit
			loop
				result := result + la_digit.item.out
				if ((la_digit.cursor_index \\ 3) = 0 and not la_digit.is_last) then
					result := result + "."
				end
			end
		end

invariant
	digit_surfaces_count_valid: digit_surfaces.count = 10
	digit_capacity_valid: digit_list.capacity <= digit_limit

end
