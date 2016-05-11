note
	description: "Un joueur connect� � distance."
	author: "Pascal Belisle"
	date: "Session hiver 2016"
	revision: "1.0"

class
	PLAYER_NETWORK

inherit
	PLAYER
		rename
			make as make_player
		end

create
	make

feature {NONE} -- Implementation

	make (a_surfaces: LIST [GAME_SURFACE]; a_x, a_y, a_index: INTEGER_32; a_score: SCORE_SURFACE; a_socket: SOCKET)
			-- Construction de `Current'
		do
			make_player (a_surfaces, a_x, a_y, a_index, a_score)
			socket := a_socket
		end

feature

	socket: SOCKET


end
