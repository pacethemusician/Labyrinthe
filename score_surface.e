note
	description: "On dessine le nombre d'items trouvés sur `Current'."
	author: "Pascal Belisle"
	date: "Session Hiver 2016"
	revision: "1.0"

class
	SCORE_SURFACE

inherit
	SPRITE
		rename
			make as make_sprite
		end

create
	make

feature {NONE} -- Initialization

	make (a_default_surface: GAME_SURFACE; a_x, a_y, a_count: INTEGER_32; a_image_factory: IMAGE_FACTORY)
			-- Surface sur laquelle on inscrit le nombre d'item trouvé
		do
			make_sprite (a_default_surface, a_x, a_y)
			image_factory := a_image_factory
			number_to_find := a_count
		end

feature

	number_to_find: INTEGER
			-- Le nombre d'item total à trouver

	image_factory: IMAGE_FACTORY
			-- Contient les images {GAME_SURFACE} du jeux

	update (a_found: INTEGER)
			-- Mise à jour de `current_surface' pour qu'il affiche `item_to_find' le nombre d'items à trouver
		local
			l_new_surface: GAME_SURFACE
			l_temp_x: INTEGER
			l_pixel_format:GAME_PIXEL_FORMAT
		do
			create l_pixel_format.default_create
			l_pixel_format.set_argb8888
			create l_new_surface.make_for_pixel_format (l_pixel_format, 70, 14)
			l_new_surface.enable_alpha_blending
			l_new_surface.draw_rectangle (create {GAME_COLOR}.make (100, 100, 0, 0), 0, 0, 70, 14)
			across a_found.out as la_string loop
				l_new_surface.draw_surface (image_factory.chars[la_string.item.out.to_integer_8 + 1], l_temp_x, 0)
				l_temp_x := l_temp_x + 14
			end
			l_new_surface.draw_surface (image_factory.chars[11], l_temp_x, 0)
			l_temp_x := l_temp_x + 14
			across number_to_find.out as la_string loop
				l_new_surface.draw_surface (image_factory.chars[la_string.item.out.to_integer_8 + 1], l_temp_x, 0)
				l_temp_x := l_temp_x + 14
			end
			current_surface := l_new_surface
		end

end
