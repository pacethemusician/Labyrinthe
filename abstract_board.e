note
	description: "{BOARD} qui génère toujours les mêmes {PATH_CARDS} utilisé pour les tests."
	author: "Charles Lemay"
	date: "2016-05-23"
	revision: "1.0"

deferred class
	ABSTRACT_BOARD

inherit

	BOARD
		redefine
			init_row,
			distribute_items,
			make
		end

feature

	make (a_image_factory: IMAGE_FACTORY; a_players: LIST[PLAYER])
		do
			create rng.make_with_seed (23)
			precursor (a_image_factory, a_players)
		end

	init_row (a_row_index: INTEGER; a_sticky_cards: ARRAYED_LIST [PATH_CARD]; a_type_amount: ARRAYED_LIST [INTEGER]; a_rng: GAME_RANDOM)
		do
			precursor (a_row_index, a_sticky_cards, a_type_amount, rng)
		end

	distribute_items (a_items: LIST [GAME_SURFACE]; a_rng: GAME_RANDOM)
		do
			precursor (a_items, rng)
		end

	rng: GAME_RANDOM

end
