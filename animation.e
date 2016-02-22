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
	make(a_img_path:STRING; a_frame_number:NATURAL_8)
		do

		end

feature {NONE}
	-- frames:GAME_SURFACE
	speed:INTEGER
	frame_number:INTEGER

end
