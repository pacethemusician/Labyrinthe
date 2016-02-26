note
	description: "Summary description for {ANIMATION}."
	author: "Charles et Pascal"
	date: "22 f�vrier 2016"
	revision: NONE

class
	ANIMATION

inherit
	GAME_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialisation

	make(a_img_path:STRING; a_frame_number:NATURAL_8; a_delay:NATURAL_8)
		require
			a_frame_number > 0
			a_delay > 0
		local
			l_image:IMG_IMAGE_FILE
		do
			delay := a_delay
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
		-- Surface contenant les 'frames' de l'animation plac�es � la suite horizontalement.

	delay:INTEGER
		-- Le temps en 'game loop' pendant lequel chaque frame de l'animation s'affiche.

	frame_number:INTEGER
		-- Le nombre de 'frames' dans l'animation.

end
