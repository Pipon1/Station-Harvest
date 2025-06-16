//Not only meat, actually, but also snacks that are almost meat, such as fish meat or tofu


////////////////////////////////////////////FISH////////////////////////////////////////////

/obj/item/food/cubancarp
	name = "\improper Carpe cubaine"
	desc = "Un fantastique sandwich qui vous brûle la langue et vous laisse tout engourdi !"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "cubancarp"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/capsaicin = 1,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de poisson" = 4, "de pâte" = 1, "de piment" = 1)
	foodtypes = SEAFOOD | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fishmeat
	name = "filet de poisson"
	desc = "Un filet de viande de poisson."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "fishfillet"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	bite_consumption = 6
	tastes = list("de poisson" = 1)
	foodtypes = SEAFOOD
	eatverbs = list("bite", "chew", "gnaw", "swallow", "chomp")
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fishmeat/carp
	name = "filet de carpe"
	desc = "Un filet de viande de carpe de l'espace."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/toxin/carpotoxin = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	/// Cytology category you can swab the meat for.
	var/cell_line = CELL_LINE_TABLE_CARP

/obj/item/food/fishmeat/carp/Initialize(mapload)
	. = ..()
	if(cell_line)
		AddElement(/datum/element/swabable, cell_line, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/fishmeat/carp/imitation
	name = "imitation de filet de carpe"
	desc = "Presque tout comme le vrai truc... À peu près."
	cell_line = null

/obj/item/food/fishmeat/moonfish
	name = "filet de poisson lune"
	desc = "Un filet de poisson lune."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "moonfish_fillet"

/obj/item/food/fishmeat/moonfish/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/grilled_moonfish, rand(40 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/fishmeat/gunner_jellyfish
	name = "filet de méduse en boite"
	desc = "Une boite de conserve de méduses sans aiguillons. Légérement hallucinogène."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "jellyfish_fillet"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/toxin/mindbreaker = 2,
	)

/obj/item/food/fishmeat/armorfish
	name = "poisson cuirassé nettoyé"
	desc = "Un poisson cuirassé sans boyaux ni carapaces. Prêt à être cuisiné !"
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "armorfish_fillet"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)

/obj/item/food/fishmeat/donkfish
	name = "filetdonk"
	desc = "Le terrifiant filet de poisson donk. Aucune personne saine ne mangerai ça, et ça ne devient pas mieux quand on le cuisine."
	icon_state = "donkfillet"
	food_reagents = list(/datum/reagent/yuck = 3)

/obj/item/food/fishfingers
	name = "Batonnet de poisson"
	desc = "Un batonnet de poisson."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "fishfingers"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	bite_consumption = 1
	tastes = list("de poisson" = 1, "de chapelure" = 1)
	foodtypes = SEAFOOD | FRIED
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/fishandchips
	name = "fish-and-chips"
	desc = "Comment ça c'est des frites et pas des chips ? Comment ça le poisson en question vit dans l'espace ?!"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "fishandchips"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de poisson" = 1, "de frites" = 1)
	foodtypes = SEAFOOD | VEGETABLES | FRIED
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/fishfry
	name = "poisson pané"
	desc = "Tout ça et même pas de frites..."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "fishfry"
	food_reagents = list (
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de poisson" = 1, "de légumes poêlés" = 1)
	foodtypes = SEAFOOD | VEGETABLES | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/vegetariansushiroll
	name = "rouleau de sushi végétarien"
	desc = "Un simple rouleau de sushi végétarien avec du riz, des carottes et des pommes de terre. Découpable !"
	icon_state = "vegetariansushiroll"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de riz bouilli" = 4, "de carottes" = 2, "de patates" = 2)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/vegetariansushiroll/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/vegetariansushislice, 4, screentip_verb = "Chop")

/obj/item/food/vegetariansushislice
	name = "tranche de sushi végétarien"
	desc = "Une simple tranche de sushi végétarien avec du riz, des carottes et des pommes de terre."
	icon_state = "vegetariansushislice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de riz bouilli" = 4, "de carottes" = 2, "de patates" = 2)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/spicyfiletsushiroll
	name = "rouleau de sushi épicé"
	desc = "Un savoureux rouleau de sushi épicé, fait avec du poisson et des légumes. Découpable !"
	icon_state = "spicyfiletroll"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/capsaicin = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de riz bouilli" = 4, "de poisson" = 2, "de piquant" = 2)
	foodtypes = VEGETABLES | SEAFOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/spicyfiletsushiroll/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/spicyfiletsushislice, 4, screentip_verb = "Chop")

/obj/item/food/spicyfiletsushislice
	name = "tranche de sushi épicé"
	desc = "Une savoureuse tranche de sushi épicé, faite avec du poisson et des légumes. À ne pas manger trop vite !"
	icon_state = "spicyfiletslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/capsaicin = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de riz bouilli" = 4, "de poisson" = 2, "de piquant" = 2)
	foodtypes = VEGETABLES | SEAFOOD
	w_class = WEIGHT_CLASS_SMALL

// empty sushi for custom sushi - French's edit : SUSHI PARTYYYYY
/obj/item/food/sushi/empty
	name = "sushi"
	foodtypes = NONE
	tastes = list()
	icon_state = "vegetariansushiroll"
	desc = "Un rouleau de sushi personnalisé."

/obj/item/food/sushi/empty/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/sushislice/empty, 4, screentip_verb = "Chop")

/obj/item/food/sushislice/empty
	name = "tranche de sushi"
	foodtypes = NONE
	tastes = list()
	icon_state = "vegetariansushislice"
	desc = "Une tranche de sushi personnalisé."

/obj/item/food/nigiri_sushi
	name = "nigiri"
	desc = "Un nigiri tout simple, composé d'une tranche de poisson sur du riz, entouré d'algue et accompagné d'un filet de sauce soja."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "nigiri_sushi"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/vitamin = 6, /datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("de riz bouilli" = 4, "de filet de poisson" = 2, "de sauce soja" = 2)
	foodtypes = SEAFOOD | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/meat_poke
	name = "poké bowl à la viande"
	desc = "Un simple poké bowl : Du riz en dessous, des légumes et de la viande au dessus. Droit être mélangé avant consommation."
	icon = 'icons/obj/food/soupsalad.dmi'
	icon_state = "pokemeat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	foodtypes = SEAFOOD | MEAT | VEGETABLES
	tastes = list("de riz et de viande" = 4, "de salade" = 2, "de sauce soja" = 2)
	trash_type = /obj/item/reagent_containers/cup/bowl
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fish_poke
	name = "poké bowl au poisson"
	desc = "Un simple poké bowl : Du riz en dessous, des légumes et du poisson au dessus. Doit être mélangé avant consommation."
	icon = 'icons/obj/food/soupsalad.dmi'
	icon_state = "pokefish"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	foodtypes = SEAFOOD | VEGETABLES
	tastes = list("de riz et de viande" = 4, "de salade" = 2, "de sauce soja" = 2)
	trash_type = /obj/item/reagent_containers/cup/bowl
	w_class = WEIGHT_CLASS_SMALL

////////////////////////////////////////////MEATS AND ALIKE////////////////////////////////////////////

/obj/item/food/tempeh
	name = "Bloc de tempé cru"
	desc = "Un gateau de soja fermenté avec un champignon special, chaud au touché."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "tempeh"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 8)
	tastes = list("de terre" = 3, "de noix" = 2, "d'ennui" = 1 )
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

// sliceable into 4xtempehslices
/obj/item/food/tempeh/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/tempehslice, 4, 5 SECONDS, table_required = TRUE, screentip_verb = "Slice")

//add an icon for slices - nevi's edit : C'est ici que j'ai compris comment était affiché les icons... Et comment certains n'en mettaient pas !
/obj/item/food/tempehslice
	name = "tranche de tempé"
	desc = "Une tranche de tempé, une tranche de krkrkr."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "tempehslice"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("de terre" = 3, "de noix" = 2, "d'ennui" = 1)
	foodtypes = VEGETABLES

//add an icon for blends
/obj/item/food/tempehstarter
	name = "base de tempé"
	desc = "Un mélange de soja et de champignon. C'est chaud... et ça bouge ?"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "tempehstarter"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("de noix" = 2, "d'ennui" = 2)
	foodtypes = VEGETABLES | GROSS

/obj/item/food/tofu
	name = "tofu"
	desc = "On aime tous le tofu."
	icon_state = "tofu"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("de tofu" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/tofu/prison
	name = "tofu mou"
	desc = "Vous refusez de manger ce tofu."
	tastes = list("d'eau saumatre" = 1)
	foodtypes = GROSS

/obj/item/food/spiderleg
	name = "patte d'araignée"
	desc = "Une patte tressayante d'araignée géante... Vous ne voulez pas manger ça, n'est ce pas ?"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "spiderleg"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/toxin = 2,
	)
	tastes = list("de toiles d'araignées" = 1)
	foodtypes = MEAT | TOXIC
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/spiderleg/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/boiledspiderleg, rand(50 SECONDS, 60 SECONDS), TRUE, TRUE)

/obj/item/food/cornedbeef
	name = "corned-beef au chou"
	desc = "Maintenant vous pouvez vous sentir comme un vrai touriste en Irlande."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "cornedbeef"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de viande" = 1, "de chou" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/bearsteak
	name = "Filet migrougrou"
	desc = "Parce que simplement manger de l'ours n'était pas assez viril."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "bearsteak"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 9,
		/datum/reagent/consumable/ethanol/manly_dorf = 5,
	)
	tastes = list("de viande" = 1, "de saumon" = 1)
	foodtypes = MEAT | ALCOHOL
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/raw_meatball
	name = "Boulette de viande crue"
	desc = "Un repas qui fait toujours plaisir. Pas un seul morceau de bois. Plutôt cru."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "raw_meatball"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("de viande" = 1)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_SMALL
	var/meatball_type = /obj/item/food/meatball
	var/patty_type = /obj/item/food/raw_patty

/obj/item/food/raw_meatball/make_grillable()
	AddComponent(/datum/component/grillable, meatball_type, rand(30 SECONDS, 40 SECONDS), TRUE)

/obj/item/food/raw_meatball/make_processable()
	AddElement(/datum/element/processable, TOOL_ROLLINGPIN, patty_type, 1, table_required = TRUE, screentip_verb = "Flatten")

/obj/item/food/raw_meatball/human
	name = "Boulette de viande étrange et crue"
	meatball_type = /obj/item/food/meatball/human
	patty_type = /obj/item/food/raw_patty/human

/obj/item/food/raw_meatball/corgi
	name = "Boulette de viande de corgi crue"
	meatball_type = /obj/item/food/meatball/corgi
	patty_type = /obj/item/food/raw_patty/corgi

/obj/item/food/raw_meatball/xeno
	name = "Boulette de viande de xéno crue"
	meatball_type = /obj/item/food/meatball/xeno
	patty_type = /obj/item/food/raw_patty/xeno

/obj/item/food/raw_meatball/bear
	name = "Boulette de viande d'ours crue"
	meatball_type = /obj/item/food/meatball/bear
	patty_type = /obj/item/food/raw_patty/bear

/obj/item/food/raw_meatball/chicken
	name = "Boulette de viande de poulet crue"
	meatball_type = /obj/item/food/meatball/chicken
	patty_type = /obj/item/food/raw_patty/chicken

/obj/item/food/meatball
	name = "boulette de viande"
	desc = "Un repas qui fait toujours plaisir. Pas un seul morceau de bois."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "meatball"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("de viande" = 1)
	foodtypes = MEAT
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/meatball/human
	name = "boulette de viande étrange"

/obj/item/food/meatball/corgi
	name = "boulette de viande de corgi"

/obj/item/food/meatball/bear
	name = "boulette de viande d'ours"
	tastes = list("de viande" = 1, "de saumon" = 1)

/obj/item/food/meatball/xeno
	name = "boulette de viande de xénomorphe"
	tastes = list("de viande" = 1, "d'acide" = 1)

/obj/item/food/meatball/chicken
	name = "boulette de viande de poulet"
	tastes = list("de poulet" = 1)
	icon_state = "chicken_meatball"

/obj/item/food/raw_patty
	name = "steak haché cru"
	desc = "Comme le pâté de crabe mais en non-végétarien."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "raw_patty"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("de viande" = 1)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_SMALL
	var/patty_type = /obj/item/food/patty/plain

/obj/item/food/raw_patty/make_grillable()
	AddComponent(/datum/component/grillable, patty_type, rand(30 SECONDS, 40 SECONDS), TRUE)

/obj/item/food/raw_patty/human
	name = "steak haché étrange et cru"
	patty_type = /obj/item/food/patty/human

/obj/item/food/raw_patty/corgi
	name = "steak haché de corgi cru"
	patty_type = /obj/item/food/patty/corgi

/obj/item/food/raw_patty/bear
	name = "steak haché d'ours cru"
	tastes = list("de viande" = 1, "de saumon" = 1)
	patty_type = /obj/item/food/patty/bear

/obj/item/food/raw_patty/xeno
	name = "steak haché de xénomorphe cru"
	tastes = list("de viande" = 1, "d'acide" = 1)
	patty_type = /obj/item/food/patty/xeno

/obj/item/food/raw_patty/chicken
	name = "steak haché de poulet cru"
	tastes = list("de poulet" = 1)
	patty_type = /obj/item/food/patty/chicken

/obj/item/food/patty
	name = "steak haché"
	desc = "Le steak haché de Nanotrasen, pour toi, plus moi, plus tous ceux qui le veulent !"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "patty"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("de viande" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

///Exists purely for the crafting recipe (because itll take subtypes)
/obj/item/food/patty/plain

/obj/item/food/patty/human
	name = "steak haché étrange"

/obj/item/food/patty/corgi
	name = "steak haché de corgi"

/obj/item/food/patty/bear
	name = "steak haché d'ours"
	tastes = list("de viande" = 1, "de saumon" = 1)

/obj/item/food/patty/xeno
	name = "steak haché de xénomorphe"
	tastes = list("de viande" = 1, "d'acide" = 1)

/obj/item/food/patty/chicken
	name = "steak haché de poulet"
	tastes = list("de poulet" = 1)
	icon_state = "chicken_patty"

/obj/item/food/raw_sausage
	name = "saucisse crue"
	desc = "De la viande crue mixée sous forme longue."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "raw_sausage"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de viande" = 1)
	foodtypes = MEAT | RAW
	eatverbs = list("bite", "chew", "nibble", "deep throat", "gobble", "chomp")
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_sausage/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/sausage, rand(60 SECONDS, 75 SECONDS), TRUE)

/obj/item/food/sausage
	name = "saucisse"
	desc = "De la viande mixée sous forme longue."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "sausage"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de viande" = 1)
	foodtypes = MEAT | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	eatverbs = list("bite", "chew", "nibble", "deep throat", "gobble", "chomp")
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/sausage/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/salami, 6, 3 SECONDS, table_required = TRUE,  screentip_verb = "Slice")
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/sausage/american, 1, 3 SECONDS, table_required = TRUE,  screentip_verb = "Slice")

/obj/item/food/sausage/american
	name = "Saucisse américaine"
	desc = "Quelle belle découpe."
	icon_state = "american_sausage"

/obj/item/food/sausage/american/make_processable()
	return

/obj/item/food/salami
	name = "salami"
	desc = "Une tranche de salami."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "salami"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 1)
	tastes = list("de viande" = 1, "de fumée" = 1)
	foodtypes = MEAT
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/rawkhinkali
	name = "khinkali cru"
	desc = "Des raviolis mais originaires de Géorgie sur la Vieille Terre, et avec du jus."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "khinkali"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/garlic = 1,
	)
	tastes = list("de viande" = 1, "d'onions" = 1, "d'ail" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/rawkhinkali/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/khinkali, rand(50 SECONDS, 60 SECONDS), TRUE)

/obj/item/food/khinkali
	name = "khinkali"
	desc = "Des raviolis mais originaire de Géorgie sur la Vieille Terre, et avec du jus."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "khinkali"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/garlic = 2,
	)
	bite_consumption = 3
	tastes = list("de viande" = 1, "d'onions" = 1, "d'ail" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/meatbun
	name = "bun à la viande"
	desc = "Un peu trop bon pour jouer de la pétanque avec."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "meatbun"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 7,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de bun" = 3, "de viande" = 2)
	foodtypes = GRAIN | MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/stewedsoymeat
	name = "viande de soja mijotée"
	desc = "Même les non-végétariens vont ADORER ça !"
	icon_state = "stewedsoymeat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de soja" = 1, "de légumes" = 1)
	eatverbs = list("slurp", "sip", "inhale", "drink")
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/boiledspiderleg
	name = "patte d'araignée bouillie"
	desc = "Une énorme patte d'araignée qui continue de tressailler même après avoir été cuit. Dégueu !"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "spiderlegcooked"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/capsaicin = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de piment" = 1, "de toile d'araignée" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/spidereggsham
	name = "oeufs verts au jambon"
	desc = "Voudriez-vous en manger dans un train ? Voudriez-vous en manger dans un avion ? Voudriez-vous en manger sur une station spatiale mortelle ?"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "spidereggsham"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	bite_consumption = 4
	tastes = list("de viande" = 1, "de la couleur vert" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/sashimi
	name = "sashimi de carpe"
	desc = "Célébrez votre survie à une attaque de méchants aliens. Vous espérez que celui qui a fait ça est qualifié."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "sashimi"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/capsaicin = 9,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de poisson" = 1, "de piment" = 1)
	foodtypes = SEAFOOD
	w_class = WEIGHT_CLASS_TINY
	//total price of this dish is 20 and a small amount more for soy sauce, all of which are available at the orders console
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/sashimi/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CARP, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/nugget
	name = "nugget de poulet"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	icon = 'icons/obj/food/meat.dmi'
	/// Default nugget icon for recipes that need any nugget
	icon_state = "nugget_lump"
	tastes = list("\"de poulet\"" = 1)
	foodtypes = MEAT
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/nugget/Initialize(mapload)
	. = ..()
	var/shape = pick("lump", "star", "lizard", "corgi")
	desc = "Une nugget de \"poulet\" qui ressemble vaguement à un.e [shape]."
	icon_state = "nugget_[shape]"

/obj/item/food/pigblanket
	name = "feuilleté à la saucisse"
	desc = "Une petite saucisse enroulée dans de la pâte feuilleté. Libérez cette saucisse de sa prison, mangez la."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "pigblanket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de viande" = 1, "de beurre" = 1)
	foodtypes = MEAT | DAIRY | GRAIN
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/bbqribs
	name = "côtelette sauce barbecue"
	desc = "Des cotelettes, sainement recouverte de sauce barbecue. Le plat le moins végan n'ayant jamais existé."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "ribs"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 3,
		/datum/reagent/consumable/bbqsauce = 10,
	)
	tastes = list("de viande" = 3, "de sauce bbq" = 1)
	foodtypes = MEAT | SUGAR

/obj/item/food/meatclown
	name = "viande clownesque"
	desc = "Un délicieux morceau de viande clownesque. Terrifiant."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "meatclown"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/banana = 2,
	)
	tastes = list("de viande" = 5, "de clowns" = 3, "de seize tesla (?)" = 1)
	w_class = WEIGHT_CLASS_SMALL
	foodtypes = MEAT | FRUIT

/obj/item/food/meatclown/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 3 SECONDS)

/obj/item/food/lasagna
	name = "Lasagne"
	desc = "Une part de lasagne. Parfait pour les lundi après-midi."
	icon_state = "lasagna"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/tomatojuice = 10,
	)
	tastes = list("de viande" = 3, "de pâtes" = 3, "de tomate" = 2, "de fromage" = 2)
	foodtypes = MEAT | DAIRY | GRAIN
	venue_value = FOOD_PRICE_NORMAL

//////////////////////////////////////////// KEBABS AND OTHER SKEWERS ////////////////////////////////////////////

/obj/item/food/kebab
	trash_type = /obj/item/stack/rods
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "kebab"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 14)
	tastes = list("de viande" = 3, "de métal" = 1)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/kebab/human
	name = "kebab à l'humain"
	desc = "De la viande humaine. Sur un baton."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 16,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de viande tendre" = 3, "de metal" = 1)
	foodtypes = MEAT | GORE
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/kebab/monkey
	name = "kebab au singe"
	desc = "De la viande delicieuse. Sur un baton."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 16,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de viande" = 3, "de metal" = 1)
	foodtypes = MEAT
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/kebab/tofu
	name = "kebab au tofu"
	desc = "De la viande vegan. Sur un baton."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 15)
	tastes = list("de tofu" = 3, "de metal" = 1)
	foodtypes = VEGETABLES
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/kebab/tail
	name = "kebab à la queue de lézard"
	desc = "Des morceaux d'une queue de lézard. Sur un baton."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 30,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de viande" = 8, "de metal" = 4, "d'écailles" = 1)
	foodtypes = MEAT | GORE

/obj/item/food/kebab/rat
	name = "kebab au rat"
	desc = "Des la viande pas si déclieuse. Sur un baton."
	icon_state = "ratkebab"
	w_class = WEIGHT_CLASS_NORMAL
	trash_type = null
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de viande de rat" = 1, "de metal" = 1)
	foodtypes = MEAT | GORE
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/kebab/rat/double
	name = "kebab aux deux rats"
	icon_state = "doubleratkebab"
	tastes = list("de viande de rat" = 2, "de metal" = 1)
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 20,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/iron = 2,
	)

/obj/item/food/kebab/fiesta
	name = "brochette de fête"
	icon_state = "fiestaskewer"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 12,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/capsaicin = 3,
	)
	tastes = list("de cuisine tex-mex" = 3, "de cumin" = 2)
	foodtypes = MEAT | VEGETABLES

/obj/item/food/fried_chicken
	name = "poulet frit"
	desc = "Un gros morceau de poulet moelleux, frit à la perfection."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "fried_chicken1"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("de poulet" = 3, "de pâte frite" = 1)
	foodtypes = MEAT | FRIED
	junkiness = 25
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fried_chicken/Initialize(mapload)
	. = ..()
	if(prob(50))
		icon_state = "fried_chicken2"

/obj/item/food/beef_stroganoff
	name = "boeuf stroganoff"
	desc = "Un plat russe, populaire au Japon. Ou en tous cas, c'est ce que les animés laissent penser. Ils disent aussi que les garçons ne savent pas en faire."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "beefstroganoff"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 16,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de boeuf" = 3, "de crème fraiche" = 1, "de sel" = 1, "de poivre" = 1)
	foodtypes = MEAT | VEGETABLES | DAIRY

	w_class = WEIGHT_CLASS_SMALL
	//basic ingredients, but a lot of them. just covering costs here
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/beef_wellington
	name = "boeuf wellington"
	desc = "Une généreuse miche de boeuf, enrobée de duxelles de champignons et de pancetta, puis enroulé de pâte."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "beef_wellington"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 21,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de boeuf" = 3, "de champignon" = 1, "de pancetta" = 1)
	foodtypes = MEAT | VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_NORMAL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/beef_wellington/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/beef_wellington_slice, 3, 3 SECONDS, table_required = TRUE,  screentip_verb = "Cut")

/obj/item/food/beef_wellington_slice
	name = "tranche de boeuf wellington"
	desc = "Une tranche de boeuf wellington, avec une sauce riche. Tout simplement délicieux."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "beef_wellington_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de boeuf" = 3, "de champignons" = 1, "de pancetta" = 1)
	foodtypes = MEAT | VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/full_english
	name = "Petit déjeuner anglais"
	desc = "Une chaleureuse assiette garnie, le pinacle de l'art du petit déjeuner."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "full_english"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de saucisse" = 1, "de bacon" = 1, "d'oeuf" = 1, "de tomate" = 1, "de champignon" = 1, "de pain" = 1, "d'haricot" = 1)
	foodtypes = MEAT | VEGETABLES | GRAIN | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/raw_meatloaf
	name = "miche de viande crue"
	desc = "Une lourde 'miche' de viande émincée, d'onions et d'ails. À cuire au four !"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "raw_meatloaf"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 40,
		/datum/reagent/consumable/nutriment/vitamin = 32,
		/datum/reagent/consumable/nutriment = 32,
	)
	tastes = list("de viande crue" = 3, "d'onions" = 1)
	foodtypes = MEAT | RAW | VEGETABLES
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/food/raw_meatloaf/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/meatloaf, rand(30 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/meatloaf
	name = "miche de viande"
	desc = "Un mélange de viande, d'onions et d'ail de la forme d'une miche et cuit au four. Généreusement couvert de ketchup. Utilisez un couteau pour la couper en tranches !"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "meatloaf"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 40,
		/datum/reagent/consumable/nutriment/vitamin = 32,
		/datum/reagent/consumable/nutriment = 32,
	)
	tastes = list("de viande juteuse" = 3, "d'onions" = 1, "d'ail" = 1, "de ketchup" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_NORMAL
	burns_in_oven = TRUE

/obj/item/food/meatloaf/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/meatloaf_slice, 4, 3 SECONDS, table_required = TRUE,  screentip_verb = "Cut")

/obj/item/food/meatloaf_slice
	name = "tranche de miche de viande"
	desc = "Une tranche d'une délicieuse miche de viande avec du ketchup."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "meatloaf_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 8,
		/datum/reagent/consumable/nutriment = 8,
	)
	tastes = list("de viande juteuse" = 3, "d'onions" = 1, "d'ail" = 1, "de ketchup" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
