/datum/mood_event/hug
	description = "Les calins c'est sympa."
	mood_change = 1
	timeout = 2 MINUTES

/datum/mood_event/bear_hug
	description = "Ce calin était un peu trop fort, mais c'était sympa."
	mood_change = 1
	timeout = 2 MINUTES

/datum/mood_event/betterhug
	description = "Quelqu'un a été très gentil.le avec moi."
	mood_change = 3
	timeout = 4 MINUTES

/datum/mood_event/betterhug/add_effects(mob/friend)
	description = "[friend.name] a été très gentil.le avec moi."

/datum/mood_event/besthug
	description = "Quelqu'un a été génial avec moi, cela me rend heureu.x.se !"
	mood_change = 5
	timeout = 4 MINUTES

/datum/mood_event/besthug/add_effects(mob/friend)
	description = "[friend.name] a été génial avec moi, iel me rend heureu.x.se !"

/datum/mood_event/warmhug
	description = "Les calins chauds et douillets, c'est les meilleurs !"
	mood_change = 1
	timeout = 2 MINUTES

/datum/mood_event/tailpulled
	description = "C'était très agréable !" //French's edit : NON je ne vais PAS traduire "J'aime quand on me caresse la queue". Au secours.
	mood_change = 1
	timeout = 2 MINUTES

/datum/mood_event/arcade
	description = "J'ai battu l'arcade !"
	mood_change = 3
	timeout = 8 MINUTES

/datum/mood_event/blessing
	description = "J'ai été béni.e."
	mood_change = 3
	timeout = 8 MINUTES

/datum/mood_event/maintenance_adaptation
	mood_change = 8

/datum/mood_event/maintenance_adaptation/add_effects()
	description = "[GLOB.deity] m'a aidé à m'adapter aux conduits de maintenance !"

/datum/mood_event/book_nerd
	description = "J'ai lu un livre récemment."
	mood_change = 1
	timeout = 5 MINUTES

/datum/mood_event/exercise
	description = "Faire du sport relache plein d'endorphines !"
	mood_change = 2
	timeout = 5 MINUTES

/datum/mood_event/pet_animal
	description = "Les animaux sont adorables ! Je ne peux pas m'arrêter de les papouiller !"
	mood_change = 2
	timeout = 5 MINUTES

/datum/mood_event/pet_animal/add_effects(mob/animal)
	description = "[animal.name] est adorable ! Je ne peux pas arrêter de lae papouiller [animal.p_them()]!"

/datum/mood_event/honk
	description = "Pouet pouet !"
	mood_change = 2
	timeout = 4 MINUTES
	special_screen_obj = "honked_nose"
	special_screen_replace = FALSE

/datum/mood_event/saved_life
	description = "J'ai sauvé la vie de quelqu'un."
	mood_change = 6
	timeout = 8 MINUTES

/datum/mood_event/oblivious
	description = "Quelle belle journée."
	mood_change = 3

/datum/mood_event/jolly
	description = "Je me sens enjoué.e sans aucune raison particulière."
	mood_change = 6
	timeout = 2 MINUTES

/datum/mood_event/focused
	description = "J'ai un but, et je l'atteindrait, peu importe ce qu'il en coute !" //Used for syndies, nukeops etc so they can focus on their goals
	mood_change = 4
	hidden = TRUE

/datum/mood_event/badass_antag
	description = "Je suis trader de badass et tout le monde autour de moi le sait. Regardez les, ils tremblent juste en pensant à moi."
	mood_change = 7
	hidden = TRUE
	special_screen_obj = "badass_sun"
	special_screen_replace = FALSE

/datum/mood_event/creeping
	description = "Les voix ont relachées la pression sur mon esprit ! Je me sens libre à nouveau !" //creeps get it when they are around their obsession
	mood_change = 18
	timeout = 3 SECONDS
	hidden = TRUE

/datum/mood_event/revolution
	description = "VIVE LA RÉVOLUTION !"
	mood_change = 3
	hidden = TRUE

/datum/mood_event/cult
	description = "J'ai vu la Vérité, loué soit le Tout Puissant !"
	mood_change = 10 //maybe being a cultist isn't that bad after all
	hidden = TRUE

/datum/mood_event/heretics
	description = "LE PLUS HAUT JE M'ÉLÈVE ET LE PLUS LOIN JE VOIS."
	mood_change = 10 //maybe being a cultist isnt that bad after all
	hidden = TRUE

/datum/mood_event/family_heirloom
	description = "Mon objet de famille est en sécurité avec moi."
	mood_change = 1

/datum/mood_event/clown_enjoyer_pin
	description = "J'adore montrer mon badge de clown !"
	mood_change = 1

/datum/mood_event/mime_fan_pin
	description = "J'adore montrer mon badge de mime !"
	mood_change = 1

/datum/mood_event/goodmusic
	description = "Il y a quelque chose de réconfortant avec cette musique."
	mood_change = 3
	timeout = 60 SECONDS

/datum/mood_event/chemical_euphoria
	description = "Heh...hehehe...hehe..."
	mood_change = 4

/datum/mood_event/chemical_laughter
	description = "Le rire est vraiment le meilleur des médicaments ! Ou peut-être pas ?"
	mood_change = 4
	timeout = 3 MINUTES

/datum/mood_event/chemical_superlaughter
	description = "*WHEEZE*"
	mood_change = 12
	timeout = 3 MINUTES

/datum/mood_event/religiously_comforted
	description = "Je suis réconforté.e par la présence d'une personne sainte."
	mood_change = 3
	timeout = 5 MINUTES

/datum/mood_event/clownshoes
	description = "Ces chaussures sont l'héritage d'un clown, je ne voudrais jamais les enlever !"
	mood_change = 5

/datum/mood_event/sacrifice_good
	description = "Les dieux sont heureux de cette offrande !"
	mood_change = 5
	timeout = 3 MINUTES

/datum/mood_event/artok
	description = "C'est sympa de voir des personnes faire de l'art par ici."
	mood_change = 2
	timeout = 5 MINUTES

/datum/mood_event/artgood
	description = "Voilà une oeuvre d'art qui fait réfléchir ! Je m'en souviendrais pendant un moment."
	mood_change = 4
	timeout = 5 MINUTES

/datum/mood_event/artgreat
	description = "Ce travail artistique était tellement bien qu'il m'a fait croire en l'humanité. Ça veut dire beaucoup, dans un endroit comme ça."
	mood_change = 6
	timeout = 5 MINUTES

/datum/mood_event/pet_borg
	description = "J'aime juste nos amis robotiques !"
	mood_change = 3
	timeout = 5 MINUTES
	required_job = list(/datum/job/research_director, /datum/job/scientist, /datum/job/roboticist, /datum/job/geneticist)

/datum/mood_event/bottle_flip
	description = "Voir une bouteille d'eau atterir comme ça, c'était satisfaisant."
	mood_change = 2
	timeout = 3 MINUTES

/datum/mood_event/hope_lavaland
	description = "Quel emblème particulier. Il me donne de l'espoir pour mon futur."
	mood_change = 10

/datum/mood_event/confident_mane
	description = "Avec ma tête converte, je me sens confiant.e."
	mood_change = 2

/datum/mood_event/holy_consumption
	description = "C'était vraiment de la nourriture divine !"
	mood_change = 1 // 1 + 5 from it being liked food makes it as good as jolly
	timeout = 3 MINUTES

/datum/mood_event/high_five
	description = "J'adore faire des high fives !"
	mood_change = 2
	timeout = 45 SECONDS

/datum/mood_event/helped_up
	description = "Aider les gens, ça donne toujours un sentiment agréable !"
	mood_change = 2
	timeout = 45 SECONDS

/datum/mood_event/helped_up/add_effects(mob/other_person, helper)
	if(!other_person)
		return

	if(helper)
		description = "J'ai aidé [other_person] à se relever, c'est agréable d'être utile !"
	else
		description = "[other_person] m'a aidé à me relever, c'était sympa de sa part!"

/datum/mood_event/high_ten
	description = "TROP BIEN ! UN HIGH-TEN !"
	mood_change = 3
	timeout = 45 SECONDS

/datum/mood_event/down_low
	description = "AH ! Ça c'était pas sympa, iel n'a pas eu une seule chance..."
	mood_change = 4
	timeout = 90 SECONDS

/datum/mood_event/aquarium_positive
	description = "Regarder des poissons dans un aquarium, c'est relaxant."
	mood_change = 3
	timeout = 90 SECONDS

/datum/mood_event/gondola
	description = "Je me sens en paix et détendu.e."
	mood_change = 6

/datum/mood_event/kiss
	description = "Quelqu'un m'a envoyé un baiser, iel doit vraiment m'apprécier !"
	mood_change = 1.5
	timeout = 2 MINUTES

/datum/mood_event/kiss/add_effects(mob/beau, direct)
	if(!beau)
		return
	if(direct)
		description = "[beau.name] m'a fait un bisou, ahh !!"
	else
		description = "[beau.name] m'a envoyé un baiseau, iel doit vraiment m'apprécier !"

/datum/mood_event/honorbound
	description = "Suivre mon code d'honneur m'épanouit vraiment !"
	mood_change = 4

/datum/mood_event/et_pieces
	description = "Mmm... J'aime le beurre de cacahuète..."
	mood_change = 50
	timeout = 10 MINUTES

/datum/mood_event/memories_of_home
	description = "Ce goût me rempli curieusement de nostalgie..."
	mood_change = 3
	timeout = 5 MINUTES

/datum/mood_event/observed_soda_spill
	description = "Ahahah ! C'est toujours drôle de voir quelqu'un se mettre du soda partout."
	mood_change = 2
	timeout = 30 SECONDS

/datum/mood_event/observed_soda_spill/add_effects(mob/spilled_mob, atom/soda_can)
	if(!spilled_mob)
		return

	description = "Ahahah ! [spilled_mob] a renversé.e son [soda_can ? soda_can.name : "soda"] sur ellui ! Un classique."

/datum/mood_event/gaming
	description = "J'adore jouer aux jeux vidéos !"
	mood_change = 2
	timeout = 30 SECONDS

/datum/mood_event/gamer_won
	description = "J'adore gagner aux jeux vidéos !"
	mood_change = 10
	timeout = 5 MINUTES

/datum/mood_event/love_reagent
	description = "Ce plat me rappelle le bon vieux temps."
	mood_change = 5

/datum/mood_event/love_reagent/add_effects(duration)
	if(isnum(duration))
		timeout = duration

/datum/mood_event/won_52_card_pickup
	description = "AH ! Iel va mettre du temps à ramasser toutes ces cartes !"
	mood_change = 3
	timeout = 3 MINUTES

/datum/mood_event/playing_cards
	description = "J'aime jouer aux cartes avec d'autres personnes !"
	mood_change = 2
	timeout = 3 MINUTES

/datum/mood_event/playing_cards/add_effects(param)
	var/card_players = 1
	for(var/mob/living/carbon/player in viewers(COMBAT_MESSAGE_RANGE, owner))
		var/player_has_cards = player.is_holding(/obj/item/toy/singlecard) || player.is_holding_item_of_type(/obj/item/toy/cards)
		if(player_has_cards)
			card_players++
			if(card_players > 5)
				break

	mood_change *= card_players
	return ..()

/datum/mood_event/garland
	description = "Ces fleurs sont plutôt apaisantes."
	mood_change = 1

/datum/mood_event/russian_roulette_win
	description = "J'ai joué avec ma vie et j'ai gagné ! Je suis chanceu.x.se..."
	mood_change = 2
	timeout = 5 MINUTES

/datum/mood_event/russian_roulette_win/add_effects(loaded_rounds)
	mood_change = 2 ** loaded_rounds

/datum/mood_event/fishing
	description = "Pêcher est relaxant."
	mood_change = 5
	timeout = 3 MINUTES

/datum/mood_event/kobun
	description = "L'univers t'aime. Je ne suis pas seul.e et tu ne l'est pas non plus."
	mood_change = 14
	timeout = 10 SECONDS

/datum/mood_event/sabrage_success
	description = "J'ai sabré le champagne ! Des fois ça fait du bien de frimer un peu."
	mood_change = 2
	timeout = 4 MINUTES

/datum/mood_event/sabrage_witness
	description = "J'ai vu quelqu'un sabrer le champagne comme dans les films."
	mood_change = 1
	timeout = 2 MINUTES

/datum/mood_event/birthday
	description = "C'est mon anniversaire !"
	mood_change = 2
	special_screen_obj = "birthday"
	special_screen_replace = FALSE

/datum/mood_event/basketball_score
	description = "*Sifflement approbateur* ! Panier parfait."
	mood_change = 2
	timeout = 5 MINUTES
	
/datum/mood_event/basketball_dunk
	description = "Slam dunk ! Boom, shakalaka !"
	mood_change = 2
	timeout = 5 MINUTES
