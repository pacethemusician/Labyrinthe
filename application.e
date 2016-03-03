note
	description: "Summary description for {APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED
	AUDIO_LIBRARY_SHARED
	IMG_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make
		local
			l_engine:detachable GAME_ENGINE

		do
			game_library.enable_video
			audio_library.enable_sound
			image_file_library.enable_image (true, false, false)
			create l_engine.make
			l_engine := Void
			audio_library.quit_library
			image_file_library.quit_library
			game_library.quit_library
		end

end
