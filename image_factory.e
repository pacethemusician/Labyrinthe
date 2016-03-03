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

feature {GAME_ENGINE}
	make
		-- Stock en mémoire tous les fichiers images convertis en `GAME_SURFACE'
		do
			create surfaces.make(20)
			surfaces.put(img_to_surface("Images/path_type1a.png"), "path_card_1_1")
			surfaces.put(img_to_surface("Images/path_type1b.png"), "path_card_1_2")
			surfaces.put(img_to_surface("Images/path_type1c.png"), "path_card_1_3")
			surfaces.put(img_to_surface("Images/path_type1d.png"), "path_card_1_4")
			surfaces.put(img_to_surface("Images/path_type2a.png"), "path_card_2_1")
			surfaces.put(img_to_surface("Images/path_type2b.png"), "path_card_2_2")
			surfaces.put(img_to_surface("Images/path_type2c.png"), "path_card_2_3")
			surfaces.put(img_to_surface("Images/path_type2d.png"), "path_card_2_4")
			surfaces.put(img_to_surface("Images/path_type3a.png"), "path_card_3_1")
			surfaces.put(img_to_surface("Images/path_type3b.png"), "path_card_3_2")
			surfaces.put(img_to_surface("Images/path_type3c.png"), "path_card_3_3")
			surfaces.put(img_to_surface("Images/path_type3d.png"), "path_card_3_4")
			surfaces.put(img_to_surface("Images/p1_still.png"), "p1_still")
			surfaces.put(img_to_surface("Images/p1_walk_down.png"), "p1_walk_down")
			surfaces.put(img_to_surface("Images/p1_walk_up.png"), "p1_walk_up")
			surfaces.put(img_to_surface("Images/p1_walk_right.png"), "p1_walk_right")
			surfaces.put(img_to_surface("Images/p1_walk_left.png"), "p1_walk_left")
			surfaces.put(img_to_surface("Images/back_main.png"), "back_main")
			surfaces.put(img_to_surface("Images/arrow_off.png"), "arrow_off")
			surfaces.put(img_to_surface("Images/arrow_on.png"), "arrow_on")
			surfaces.put(img_to_surface("Images/arrow_on_g.png"), "arrow_on_g")
			surfaces.put(img_to_surface("Images/btn_rotate_left.png"), "btn_rotate_left")
			surfaces.put(img_to_surface("Images/btn_rotate_right.png"), "btn_rotate_left")
			-- surfaces.put(img_to_surface("Images/.png"), "")
		end

	img_to_surface (a_img_path:STRING):GAME_SURFACE
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

	surfaces : STRING_TABLE[GAME_SURFACE]

end
