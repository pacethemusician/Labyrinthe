note
	description: "Animation composé de plusieurs 'frames' et d'une vitesse"
	author: "Charles et Pascal"
	date: "22 février 2016"

class
	ANIMATION

inherit
	GAME_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialisation

	make(a_img_path:STRING; a_frame_number:NATURAL_8; a_delay:NATURAL_8)
			-- Créer un `current' avec l'image `a_img_path'.
			-- L'image contient les 'frames' de `current' alignées horizontalement.
			-- Le `current' créé a `a_frame_number' 'frames' à affiché une
			-- après l'autre avec un délais de `a_delay'.
		require
			Frame_over_zero: a_frame_number > 0
			Delay_over_zero: a_delay > 0
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

feature {SPRITE, GAME_ENGINE} -- Attributs

	frames:GAME_SURFACE assign set_frames
		-- Surface contenant les 'frames' de l'animation placées à la suite horizontalement.

	set_frames(l_frames: GAME_SURFACE)
		do
			frames:= l_frames
		end

	delay:INTEGER
		-- Le temps en 'game loop' pendant lequel chaque frame de l'animation s'affiche.

	frame_number:INTEGER
		-- Le nombre de 'frames' dans l'animation.

invariant
	Frame_over_zero: frame_number > 0
	Delay_over_zero: delay > 0

end
