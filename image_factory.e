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

		end

feature {NONE} -- Implementation

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

	path_card_surfaces:LIST[LIST[GAME_SURFACE]]
		local
			l_surfaces: LIST[LIST[GAME_SURFACE]]
		do
			create {ARRAYED_LIST[LIST[GAME_SURFACE]]} l_surfaces.make (3)
			l_surfaces.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(4))
			l_surfaces.at (1) .extend(img_to_surface("Images/path_type1a.png"))
			l_surfaces.at (1) .extend(img_to_surface("Images/path_type1b.png"))
			l_surfaces.at (1) .extend(img_to_surface("Images/path_type1c.png"))
			l_surfaces.at (1) .extend(img_to_surface("Images/path_type1d.png"))
			l_surfaces.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(4))
			l_surfaces.at (2) .extend(img_to_surface("Images/path_type2a.png"))
			l_surfaces.at (2) .extend(img_to_surface("Images/path_type2b.png"))
			l_surfaces.at (2) .extend(img_to_surface("Images/path_type2c.png"))
			l_surfaces.at (2) .extend(img_to_surface("Images/path_type2d.png"))
			l_surfaces.extend (create {ARRAYED_LIST[GAME_SURFACE]}.make(4))
			l_surfaces.at (3) .extend(img_to_surface("Images/path_type3a.png"))
			l_surfaces.at (3) .extend(img_to_surface("Images/path_type3b.png"))
			l_surfaces.at (3) .extend(img_to_surface("Images/path_type3c.png"))
			l_surfaces.at (3) .extend(img_to_surface("Images/path_type3d.png"))
			Result := l_surfaces
		end

	player_type_1
	
		do
			surfaces.put(img_to_surface("Images/p1_still.png"), "p1_still")
			surfaces.put(img_to_surface("Images/p1_walk_down.png"), "p1_walk_down")
			surfaces.put(img_to_surface("Images/p1_walk_up.png"), "p1_walk_up")
			surfaces.put(img_to_surface("Images/p1_walk_right.png"), "p1_walk_right")
			surfaces.put(img_to_surface("Images/p1_walk_left.png"), "p1_walk_left")
		end
end
