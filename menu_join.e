note
	description: "Demande les informations de connection à l'usager pour une partie en réseau."
	author: "Pascal Belisle"
	date: "Session Hiver 2016"
	revision: "1.0"

class
	MENU_JOIN

inherit
	MENU
		redefine
			make
		end

create
	make

feature {NONE} -- Initialisation

	make (a_image_factory: IMAGE_FACTORY)
			-- <Precursor>
		do
			Precursor(a_image_factory)
			create background.make (image_factory.backgrounds[2], 0, 0)
			
			-- Section hard codé à refaire si le temps le permet

			ip := "127. 0. 0. 1"

			port := 40001

			ouvrir_socket

			is_done := True
			is_go_selected := True
		end

feature

	has_error: BOOLEAN
			-- `True' si une erreur est survenue dans le processus de création du socket

	is_go_selected: BOOLEAN assign set_is_go_selected
			-- `True' si l'usager à cliqué sur le {BOUTON} go

	socket_client: detachable SOCKET
			-- blabla

	set_is_go_selected (a_value: BOOLEAN)
			-- Assigne `a_value' à `is_go_selected'
		do
			is_go_selected := a_value
		end

	ip: STRING
			-- L'adresse IP en chaine de caractères. Pour l'instant, l'adresse local_host est hard-codé

	port: INTEGER
			-- Le port du serveur où on doit se connecter

	ouvrir_socket
			-- Créé et connecte le `socket_client'
			-- Merci Louis Marchand !!!
		local
			l_socket: NETWORK_STREAM_SOCKET
			l_adresse_factory:INET_ADDRESS_FACTORY
			l_adresse:STRING
			l_port:INTEGER
		do
			create l_adresse_factory
			l_adresse := ip
			l_port := port
			io.put_string ("Ouverture du client. Adresse: "+l_adresse+", port: "+l_port.out+".%N")
			if attached l_adresse_factory.create_from_name (l_adresse) as la_adresse then
				create l_socket.make_client_by_address_and_port (la_adresse, l_port)
				socket_client := l_socket
				if l_socket.invalid_address then
					io.put_string ("Ne peut pas se connecter a l'adresse " + l_adresse + ":" + l_port.out+".%N")
					has_error := True
				else
					l_socket.connect
					if not l_socket.is_connected then
						io.put_string ("Ne peut pas se connecter a l'adresse " + l_adresse + ":" + l_port.out+".%N")
						has_error := True
					end
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
