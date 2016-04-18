note
	description: "Summary description for {THREAD_BOARD_ENGINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	THREAD_BOARD_ENGINE

inherit
	THREAD
		rename
			make as make_thread
		end

create
	make

feature -- Implementation

	engine: BOARD_ENGINE
	game_window: GAME_WINDOW_SURFACED

	make (a_board_engine: BOARD_ENGINE; a_game_window: GAME_WINDOW_SURFACED)
		do
			make_thread
			game_window := a_game_window
			engine := a_board_engine
		end

	must_stop: BOOLEAN assign set_must_stop
			-- `Current' doit arrêter

	set_must_stop (a_must_stop: BOOLEAN)
		do
			must_stop := a_must_stop
		end

	execute
			-- Exécution du {THREAD}
		do
			from
				must_stop := false
			until
				must_stop
			loop
				across engine.on_screen_sprites as l_sprites loop
					l_sprites.item.draw_self (game_window.surface)
	            end
	            if engine.has_to_move then
	            	engine.btn_ok.draw_self (game_window.surface)
	            	engine.circle_btn_ok.draw_self (game_window.surface)
	            end
				engine.circle_player.draw_self (game_window.surface)
	            across engine.players as la_players loop
					la_players.item.draw_self (game_window.surface)
	            end
	            game_window.update
			end
		end

invariant

end
