note
	description: "Summary description for {MENU_JOIN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MENU_JOIN

inherit
	MENU
		redefine
			make
			-- check_btn
		end
create
	make

feature {NONE} -- Initialisation

	make (a_image_factory: IMAGE_FACTORY)
		do
			Precursor(a_image_factory)
			create background.make (image_factory.backgrounds[2])
		end

end
