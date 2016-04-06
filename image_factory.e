note
	description: "Summary description for {IMAGE_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IMAGE_FACTORY

inherit
	GAME_LIBRARY_SHARED
	IMG_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make
			-- Initialisation de `current'
		do
			-- create arcade_font_36.make ("ARCADECLASSIC.ttf", 36)
			path_cards := init_path_card_surfaces
			players := init_player_surfaces
			buttons := init_button_surfaces
			items := init_item_surfaces
			backgrounds := init_background_surfaces
			player_choice_menu := init_player_choice_menu_surfaces

		end

feature {NONE} -- Implementation

	img_to_surface (a_img_path:STRING):GAME_SURFACE
			-- Charge un fichier image et le converti en GAME_SURFACE
		local
			l_image:IMG_IMAGE_FILE
			l_surface:GAME_SURFACE
		do
			create l_image.make (a_img_path)
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create l_surface.make_from_image (l_image)
				else
					create l_surface.make(1,1)
				end
			else
				create l_surface.make(1,1)
			end
			Result := l_surface
		end

	init_path_card_surfaces:ARRAYED_LIST[LIST[GAME_SURFACE]]
			-- Retournes les {GAME_SURFACE} des {PATH_CARD}
		do
			create Result.make (3)
			Result.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(4))
			Result.at (1) .extend(img_to_surface("Images/path_type1a.png"))
			Result.at (1) .extend(img_to_surface("Images/path_type1b.png"))
			Result.at (1) .extend(img_to_surface("Images/path_type1c.png"))
			Result.at (1) .extend(img_to_surface("Images/path_type1d.png"))
			Result.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(4))
			Result.at (2) .extend(img_to_surface("Images/path_type2a.png"))
			Result.at (2) .extend(img_to_surface("Images/path_type2b.png"))
			Result.at (2) .extend(img_to_surface("Images/path_type2c.png"))
			Result.at (2) .extend(img_to_surface("Images/path_type2d.png"))
			Result.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(4))
			Result.at (3) .extend(img_to_surface("Images/path_type3a.png"))
			Result.at (3) .extend(img_to_surface("Images/path_type3b.png"))
			Result.at (3) .extend(img_to_surface("Images/path_type3c.png"))
			Result.at (3) .extend(img_to_surface("Images/path_type3d.png"))
		end

	init_player_surfaces:ARRAYED_LIST[LIST[GAME_SURFACE]]
			-- Retournes les {GAME_SURFACE} des personnages.
		do
			create Result.make (4)
			Result.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(5))
			Result.at (1) .extend(img_to_surface("Images/p1_still.png"))
			Result.at (1) .extend(img_to_surface("Images/p1_walk_down.png"))
			Result.at (1) .extend(img_to_surface("Images/p1_walk_up.png"))
			Result.at (1) .extend(img_to_surface("Images/p1_walk_right.png"))
			Result.at (1) .extend(img_to_surface("Images/p1_walk_left.png"))
			Result.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(5))
			Result.at (2) .extend(img_to_surface("Images/p2_still.png"))
			Result.at (2) .extend(img_to_surface("Images/p2_walk_down.png"))
			Result.at (2) .extend(img_to_surface("Images/p2_walk_up.png"))
			Result.at (2) .extend(img_to_surface("Images/p2_walk_right.png"))
			Result.at (2) .extend(img_to_surface("Images/p2_walk_left.png"))
			Result.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(5))
			Result.at (3) .extend(img_to_surface("Images/p3_still.png"))
			Result.at (3) .extend(img_to_surface("Images/p3_walk_down.png"))
			Result.at (3) .extend(img_to_surface("Images/p3_walk_up.png"))
			Result.at (3) .extend(img_to_surface("Images/p3_walk_right.png"))
			Result.at (3) .extend(img_to_surface("Images/p3_walk_left.png"))
			Result.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(5))
			Result.at (4) .extend(img_to_surface("Images/p4_still.png"))
			Result.at (4) .extend(img_to_surface("Images/p4_walk_down.png"))
			Result.at (4) .extend(img_to_surface("Images/p4_walk_up.png"))
			Result.at (4) .extend(img_to_surface("Images/p4_walk_right.png"))
			Result.at (4) .extend(img_to_surface("Images/p4_walk_left.png"))
			Result.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(5))
			Result.at (5) .extend(img_to_surface("Images/p5_still.png"))
			Result.at (5) .extend(img_to_surface("Images/p5_walk_down.png"))
			Result.at (5) .extend(img_to_surface("Images/p5_walk_up.png"))
			Result.at (5) .extend(img_to_surface("Images/p5_walk_right.png"))
			Result.at (5) .extend(img_to_surface("Images/p5_walk_left.png"))
		end

	init_button_surfaces:ARRAYED_LIST[GAME_SURFACE]
			-- Retournes les {GAME_SURFACE} des boutons.
		do
			create Result.make(15)
			Result.extend (img_to_surface ("Images/btn_rotate_left.png"))
			Result.extend (img_to_surface ("Images/btn_rotate_right.png"))
			Result.extend (img_to_surface ("Images/btn_new_game.png"))
			Result.extend (img_to_surface ("Images/btn_join_game.png"))
			Result.extend (img_to_surface ("Images/arrow_choice_left.png"))
			Result.extend (img_to_surface ("Images/arrow_choice_right.png"))
			Result.extend (img_to_surface ("Images/btn_add_local.png"))
			Result.extend (img_to_surface ("Images/btn_add_net.png"))
			Result.extend (img_to_surface ("Images/btn_cancel.png"))
			Result.extend (img_to_surface ("Images/btn_go.png"))
		end

	init_background_surfaces:ARRAYED_LIST[GAME_SURFACE]
			-- Retournes les {GAME_SURFACE} des backgrounds.
		do
			create Result.make(10)
			Result.extend (img_to_surface("Images/back_main.png"))
			Result.extend (img_to_surface("Images/back_titlescreen.png"))
		end

	init_item_surfaces:ARRAYED_LIST[GAME_SURFACE]
			-- Retournes les {GAME_SURFACE} des items.
		do
			create Result.make(24)
			across 1 |..| 25 as la_index loop
				Result.extend (img_to_surface ("Images/item" + la_index.item.out + ".png"))
			end
		end

	init_player_choice_menu_surfaces:ARRAYED_LIST[GAME_SURFACE]
			-- Retournes les {GAME_SURFACE} n�cessaire aux {PLAYER_SELECT_SUBMENU}
		do
			create Result.make(15)
			Result.extend (img_to_surface ("Images/back_player1.png"))
			Result.extend (img_to_surface ("Images/back_player2.png"))
			Result.extend (img_to_surface ("Images/back_player3.png"))
			Result.extend (img_to_surface ("Images/back_player4.png"))
			Result.extend (img_to_surface ("Images/back_connexion_choice.png"))
			Result.extend (img_to_surface ("Images/back_local.png"))
			Result.extend (img_to_surface ("Images/back_network.png"))
		end

feature

	path_cards: ARRAYED_LIST[LIST[GAME_SURFACE]]
	players: ARRAYED_LIST[LIST[GAME_SURFACE]]
	buttons: ARRAYED_LIST[GAME_SURFACE]
	items: ARRAYED_LIST[GAME_SURFACE]
	backgrounds: ARRAYED_LIST[GAME_SURFACE]
	player_choice_menu: ARRAYED_LIST[GAME_SURFACE]
	-- arcade_font_36: TEXT_FONT

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a �t� fait dans le cadre du cours de programmation orient�e object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
