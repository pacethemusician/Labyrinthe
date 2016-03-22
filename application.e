note
	description: "Summary description for {APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED
	TEXT_LIBRARY_SHARED
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
			text_library.enable_text
			image_file_library.enable_image (true, false, false)
			create l_engine.make
			l_engine := Void
			text_library.quit_library
			audio_library.quit_library
			image_file_library.quit_library
			game_library.quit_library
		end

end
