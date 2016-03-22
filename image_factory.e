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

feature {GAME_ENGINE} -- Initialisation

	make
		do
			path_card_surfaces := init_path_card_surfaces
			player_surfaces := init_player_surfaces
			button_surfaces := init_button_surfaces
			item_surfaces := init_item_surfaces
			corner_surfaces := init_corner_surfaces
			background_surfaces := init_background_surfaces
			create arcade_font_36.make ("ARCADECLASSIC.ttf", 36)
			if arcade_font_36.is_openable then
				arcade_font_36.open
				create {TEXT_SURFACE_BLENDED} text_image.make ("Player 1", arcade_font_36, create {GAME_COLOR} .make_rgb (255, 255, 255))
			else
				create text_image.make (1, 1)
			end
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

	init_corner_surfaces:ARRAYED_LIST[GAME_SURFACE]

		do
			create Result.make(4)
			Result.extend (img_to_surface ("Images/corner_up_left.png"))
			Result.extend (img_to_surface ("Images/corner_up_right.png"))
			Result.extend (img_to_surface ("Images/corner_down_left.png"))
			Result.extend (img_to_surface ("Images/corner_down_right.png"))
		end

	init_button_surfaces:ARRAYED_LIST[GAME_SURFACE]

		do
			create Result.make(10)
			Result.extend (img_to_surface ("Images/btn_rotate_left.png"))
			Result.extend (img_to_surface ("Images/btn_rotate_right.png"))
			Result.extend (img_to_surface ("Images/btn_back.png"))
		end

	init_background_surfaces:ARRAYED_LIST[GAME_SURFACE]
		do
			create Result.make(10)
			Result.extend (img_to_surface("Images/back_main.png"))
			Result.extend (img_to_surface("Images/back_titlescreen.png"))
		end

	init_item_surfaces:ARRAYED_LIST[GAME_SURFACE]

		local
			i:INTEGER
		do
			create Result.make(24)
			from
				i := 1
			until
				i = 25
			loop
				Result.extend (img_to_surface ("Images/item" + i.out + ".png"))
				i := i + 1
			end
		end

feature {GAME_ENGINE} -- Attributs

	path_card_surfaces: ARRAYED_LIST[LIST[GAME_SURFACE]]
	player_surfaces: ARRAYED_LIST[LIST[GAME_SURFACE]]
	button_surfaces: ARRAYED_LIST[GAME_SURFACE]
	item_surfaces: ARRAYED_LIST[GAME_SURFACE]
	corner_surfaces: ARRAYED_LIST[GAME_SURFACE]
	background_surfaces: ARRAYED_LIST[GAME_SURFACE]

feature {NONE} -- Private

	arcade_font_36: TEXT_FONT
	text_image:GAME_SURFACE

end
