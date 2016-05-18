note
	description: "Sprite éxécutant une liste de routine lors qu'on clique dessus."
	author: "Charles Lemay"
	date: "22 mars 2016"

class
	BUTTON

inherit

	SPRITE
		rename
			make as make_sprite
		redefine
			set_surface
		end

create
	make

feature -- Initialisation

	make (a_default_surface: GAME_SURFACE; a_x, a_y: INTEGER_32)
			-- Initialisation de `current' avec `a_default_surface' à la position (`a_x', `a_y').
		do
			enabledSurface := a_default_surface
			make_sprite (enabledSurface, a_x, a_y)
			enabled := true
			create on_click_actions.make
		ensure
			enabled = true
		end

feature -- implementation

	enabledSurface: GAME_SURFACE

	disabledSurface: detachable GAME_SURFACE

	enabled: BOOLEAN assign set_enabled
			-- Indique si le bouton peut être activé.

	on_click_actions: LINKED_LIST [ROUTINE [ANY, TUPLE]]
			-- Liste de procédures éxécutées par `current' quand on clique dessus.

	set_enabled (a_enabled: BOOLEAN)
			-- Assigne `a_enabled' à `enabled'.
		do
			enabled := a_enabled
			if enabled then
				current_surface := enabledSurface
			else
				if (not attached disabledSurface) then
					update_disabled_surface
				end
				if attached disabledSurface as la_disabledSurface then
					current_surface := la_disabledSurface
				end
			end
		ensure
			is_assign: enabled = a_enabled
		end

	set_surface (a_surface: GAME_SURFACE)
		do
			enabledSurface := a_surface
			if enabled then
				precursor (enabledSurface)
			else
				update_disabled_surface
				if attached disabledSurface as la_disabledSurface then
					precursor (la_disabledSurface)
				end
			end
		end

	update_disabled_surface
		local
			l_rectangle: GAME_SURFACE
		do
			create disabledSurface.make_from_other (enabledSurface)
			if attached disabledSurface as la_disabledSurface then
				create l_rectangle.make_for_pixel_format (la_disabledSurface.pixel_format,
					la_disabledSurface.width, la_disabledSurface.height)
				l_rectangle.draw_rectangle (create {GAME_COLOR}.make (0, 0, 0, 200),
					0, 0, la_disabledSurface.width, la_disabledSurface.height)
				la_disabledSurface.enable_alpha_blending
				la_disabledSurface.draw_surface (enabledSurface, 0, 0)
				la_disabledSurface.draw_surface (l_rectangle, 0, 0)
			end
		end

	execute_actions (a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Execute les routines de `on_click_actions' si la souris est au dessus de `current'.
		do
			if (a_mouse_state.x >= x) and (a_mouse_state.x < (x + current_surface.width)) and (a_mouse_state.y >= y) and (a_mouse_state.y < (y + current_surface.height)) then
				across
					on_click_actions as l_actions
				loop
					l_actions.item.call(a_mouse_state)
				end
			end
		end

invariant

note
	license: "WTFPL"
	source: "[
				Ce jeu a été fait dans le cadre du cours de programmation orientée object II au Cegep de Drummondville 2016
				Projet disponible au https://github.com/pacethemusician/Labyrinthe.git
			]"

end
