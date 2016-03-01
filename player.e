note
	description: "Pion d'un joueur"
	author: "Pascal Belisle et Charles Lemay"
	date: "18 f�vrier 2016"
	revision: none

class
	PLAYER

inherit
	SPRITE
		rename
			make as make_sprite
		end

create
	make

feature {NONE} -- Initialisation

	make--(a_walk_up_path, a_walk_down_path, a_walk_left_path, a_walk_right_path, a_still_path:STRING)
			-- Cr�e un `current' ayant comme animations les images
			-- aux emplacements `a_walk_up_path', `a_walk_down_path',
			-- `a_walk_left_path', `a_walk_right_path' et `a_still_path'.
		do
			create walk_up_animation.make (a_walk_up_path, 6, 6)
			create walk_down_animation.make (a_walk_down_path, 6, 6)
			create walk_left_animation.make (a_walk_left_path, 6, 6)
			create walk_right_animation.make (a_walk_right_path, 6, 6)
			create still_animation.make (a_still_path, 22, 20)
			make_sprite(still_animation)
		end

feature {NONE} -- Attributs

	walk_up_animation:ANIMATION
		-- Animation de `current' lorsqu'il marche vers le haut.

	walk_down_animation:ANIMATION
		-- Animation de `current' lorsqu'il marche vers le bas.

	walk_left_animation:ANIMATION
		-- Animation de `current' lorsqu'il marche vers la gauche.

	walk_right_animation:ANIMATION
		-- Animation de `current' lorsqu'il marche vers la droite.

	still_animation:ANIMATION
		-- Animation de `current' lorsqu'il ne se d�place pas.

	a_walk_up_path: STRING = "Images/p1_walk_up.png"
	a_walk_down_path: STRING = "Images/p1_walk_down.png"
	a_walk_left_path: STRING = "Images/p1_walk_left.png"
	a_walk_right_path: STRING = "Images/p1_walk_right.png"
	a_still_path: STRING = "Images/p1_still.png"
end
