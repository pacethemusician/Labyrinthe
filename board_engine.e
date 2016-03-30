note
	description: "Classe qui contrôle le gameplay."
	author: "Pascal Belisle, Charles Lemay"
	date: "Mars 2016"
	revision: ""

class
	BOARD_ENGINE

inherit
	ENGINE
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_image_factory: IMAGE_FACTORY)
			-- Initialisation de `current'
		do
			Precursor (a_image_factory)
			create {LINKED_LIST[SPRITE]} on_screen_sprites.make
			create spare_card.make(3, image_factory.path_cards[3], 801, 144, 1, image_factory.items)
			create board.make (image_factory.path_cards, image_factory.items)
			create {ARRAYED_LIST[PLAYER]} players.make (4)
			create background.make(image_factory.backgrounds[1])
			create current_player.make (image_factory.players[1], 0, 0)
			create btn_rotate_left.make (image_factory.buttons[1], 745, 159)
			create btn_rotate_right.make (image_factory.buttons[2], 904, 159)
			create {ARRAYED_LIST[SPRITE]} on_screen_sprites.make(70)
			on_screen_sprites.extend (background)
			on_screen_sprites.extend (btn_rotate_left)
			on_screen_sprites.extend (btn_rotate_right)
			on_screen_sprites.extend (spare_card)
			across board.board_paths as l_rows loop
				across l_rows.item as l_cards loop
					on_screen_sprites.extend (l_cards.item)
				end
			end
			is_dragging := False

		end

feature {NONE} -- Implementation

	background: BACKGROUND
		-- Image de fond
	board: BOARD
		--
	btn_rotate_left, btn_rotate_right: BUTTON
		-- Les boutons qui tourne la `spare_card'
	is_dragging: BOOLEAN
		-- True si le joueur déplace la `spare_card'

	spare_card: PATH_CARD
		-- La carte que le joueur doit placer

	current_player: PLAYER

	players: LIST[PLAYER]
		-- La liste de tous les joueurs actifs

	check_btn(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
		-- déclanche l'action des boutons s'il y a click
		do
		end

	rotate_spare_card(a_steps: INTEGER)
			-- Méthode qui se déclenche lorsq'on clique sur
			-- btn_rotate_left ou btn_rotate_right.
		require
			a_steps.abs <= 4
		do
			spare_card.rotate (a_steps)
			spare_card.play_rotate_sfx
		end
		
	on_mouse_move(a_mouse_state: GAME_MOUSE_MOTION_STATE)
			-- Routine de mise à jour du drag and drop
		do
			if a_mouse_state.is_left_button_pressed and is_dragging then
				spare_card.x := a_mouse_state.x - spare_card.x_offset
				spare_card.y := a_mouse_state.y - spare_card.y_offset
			end
		end
end
