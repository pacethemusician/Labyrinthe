note
	description: "Repr�sentation objet de chaque carte chemin sur le plateau {PATH_CARD}."
	author: "Pascal Belisle"
	date: "15 F�vrier 2016"
	revision: none

class
	PATH_CARD

inherit
	SPRITE

create
	make

feature {NONE}
	x:NATURAL
	y:NATURAL
	img_file:REND

	make
			-- Constructeur
		do

		end
end
