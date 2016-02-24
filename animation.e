note
	description: "Summary description for {ANIMATION}."
	author: "Charles et Pascal"
	date: "22 février 2016"
	revision: NONE

class
	ANIMATION

inherit
	GAME_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialisation

	make(a_img_path:STRING; a_frame_number:NATURAL_8; a_speed:NATURAL_8)
		local
			l_image:IMG_IMAGE_FILE
		do
			speed := a_speed
			frame_number := a_frame_number
			create l_image.make (a_img_path)
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create frames.make_from_image (l_image)
				else
					create frames.make(1,1)
				end
			else
				create frames.make(1,1)
			end
		end

feature {SPRITE, GAME_ENGINE}

	frames:GAME_SURFACE

	speed:INTEGER
		-- Le temps en 'game loop' pendant lequel chaque frame de l'animation s'affiche

	frame_number:INTEGER

end
