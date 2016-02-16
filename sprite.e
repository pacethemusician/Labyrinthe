note
	description: "Classe pour objet ayant une image et coordonnées x, y {SPRITE}."
	author: "Pascal Belisle"
	date: "15 Février 2016"
	revision: None

class
	SPRITE

inherit
	GAME_TEXTURE
		rename
			make as make_texture
		end
create
	make

feature {NONE}	-- Initialisation
	x, y : NATURAL
	make(a_renderer:GAME_RENDERER)
			-- Initialisation de `Current'
		local
			l_image:IMG_IMAGE_FILE
		do
			has_error := False
			create l_image.make ("/images/.png")
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					make_from_image (a_renderer, l_image)
					if not has_error then
						sub_image_width := width // 3
						sub_image_height := height
					end
				else
					has_error := False
				end
			else
				has_error := False
			end
			initialize_animation_coordinate
		end
end
