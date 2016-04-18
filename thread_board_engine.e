note
	description: "{THREAD} qui s'occupe de mettre la {GAME_WINDOW_SURFACED} avec les données du {BOARD_ENGINE}."
	author: "Charles Lemay"
	date: "2016-04-18"
	revision: "1.0"

class
	THREAD_BOARD_ENGINE

inherit

	THREAD
		rename
			make as make_thread
		end

create
	make

feature {BOARD_ENGINE, GAME_ENGINE} -- Implementation

	engine: BOARD_ENGINE
			-- Le {BOARD_ENGINE} lié à `current'.

	game_window: GAME_WINDOW_SURFACED
			-- La {GAME_WINDOW_SURFACED} sur laquelle afficher le {BOARD_ENGINE}.

	must_stop: BOOLEAN assign set_must_stop
			-- Indique si `current' doit s'arrêter.

	set_must_stop (a_must_stop: BOOLEAN)
			-- Assigne `a_must_stop' à `must_stop'.
		do
			must_stop := a_must_stop
		ensure
			must_stop = a_must_stop
		end

	make (a_board_engine: BOARD_ENGINE; a_game_window: GAME_WINDOW_SURFACED)
			-- Initialisation de `current'.
		do
			make_thread
			engine := a_board_engine
			game_window := a_game_window
		end

	execute
			-- Exécution du {THREAD}
		do
			from
				must_stop := false
			until
				must_stop
			loop
				across
					engine.on_screen_sprites as l_sprites
				loop
					l_sprites.item.draw_self (game_window.surface)
				end
				if engine.has_to_move then
					engine.btn_ok.draw_self (game_window.surface)
					engine.circle_btn_ok.draw_self (game_window.surface)
				end
				engine.circle_player.draw_self (game_window.surface)
				across
					engine.players as la_players
				loop
					la_players.item.draw_self (game_window.surface)
				end
				game_window.update
			end
		end

invariant

end
