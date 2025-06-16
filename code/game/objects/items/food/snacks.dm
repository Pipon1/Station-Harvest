////////////////////////////////////////////SNACKS FROM VENDING MACHINES////////////////////////////////////////////
//in other words: junk food
//don't even bother looking for recipes for these

/obj/item/food/candy
	name = "bonbon"
	desc = "Du nougat, aimes ça, ou pas, c'est ta vie."
	icon_state = "candy"
	trash_type = /obj/item/trash/candy
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/sugar = 3,
	)
	junkiness = 25
	tastes = list("de bonbon" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/candy/bronx
	name = "\improper barre diététique"
	desc = "Perte de poids garantie ! Arôme Caramel Moka. Il y a aussi un truc par rapport à sa production, mais qui lit ça ?"
	icon_state = "bronx"
	inhand_icon_state = "candy"
	trash_type = /obj/item/trash/candy
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/sugar = 2,
		/datum/reagent/yuck = 1,
	)
	junkiness = 10
	bite_consumption = 10
	tastes = list("de bonbon" = 5, "de perte de poids" = 4, "de larve d'insecte" = 1)
	foodtypes = JUNKFOOD | RAW | BUGS
	custom_price = 80
	w_class = WEIGHT_CLASS_TINY
	var/revelation = FALSE

/obj/item/food/candy/bronx/make_edible()
	. = ..()
	AddComponent(/datum/component/edible, after_eat = CALLBACK(src, PROC_REF(after_eat)))

/obj/item/food/candy/bronx/proc/after_eat(mob/living/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/carl = eater
		var/datum/disease/disease = new /datum/disease/parasite()
		carl.ForceContractDisease(disease, make_copy = FALSE, del_on_fail = TRUE)

/obj/item/food/candy/bronx/examine(mob/user)
	. = ..()
	if(!revelation && !isobserver(user))
		. += span_notice("Eh be, vous devriez aller voir un ophtalmo. Regardez de plus prêt...")

		name = "\improper barre parasitiquee"
		desc = "Perte de poids garantie ! Goût Caramel Moka ! AVERTISSEMENT : PRODUIT IMPROPRE À LA CONSOMMATION HUMAINE. CONTIENT DES SPÉCIMENS VIVANTS DE DIAMPHIDIA."
		revelation = TRUE

/obj/item/food/sosjerky
	name = "\improper Boeuf séché de la réserve privée"
	icon_state = "sosjerky"
	desc = "Boeuf séché fait à partir des meilleures vaches de l'espace."
	trash_type = /obj/item/trash/sosjerky
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/sugar = 2,
		/datum/reagent/consumable/salt = 2,
	)
	junkiness = 25
	tastes = list("de viande séchée" = 1)
	w_class = WEIGHT_CLASS_SMALL
	foodtypes = JUNKFOOD | MEAT | SUGAR

/obj/item/food/sosjerky/healthy
	name = "Boeuf séché maison"
	desc = "Boeuf séché maison fait à partir des meilleures vaches de l'espace."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	junkiness = 0

/obj/item/food/chips
	name = "chips"
	desc = "On Lays adorent."
	icon_state = "chips"
	trash_type = /obj/item/trash/chips
	bite_consumption = 1
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/salt = 1,
	)
	junkiness = 20
	tastes = list("de sel" = 1, "de croustillants" = 1)
	foodtypes = JUNKFOOD | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/chips/make_leave_trash()
	if(trash_type)
		AddElement(/datum/element/food_trash, trash_type, FOOD_TRASH_POPABLE)

/obj/item/food/chips/shrimp
	name = "chips goût crevettes"
	desc = "Chips au goût de crevettes. La malbouffe préférée des connaisseurs de fruits de mer !"
	icon_state = "shrimp_chips"
	trash_type = /obj/item/trash/shrimp_chips
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/cooking_oil = 3,
		/datum/reagent/consumable/salt = 1,
	)
	tastes = list("de sel" = 1, "de crevette" = 1)
	foodtypes = JUNKFOOD | FRIED | SEAFOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/no_raisin
	name = "\improper 4no raisins"
	icon_state = "4no_raisins"
	desc = "Meilleurs raisins secs de l'univers. On ne sait même pas pourquoi."
	trash_type = /obj/item/trash/raisins
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/sugar = 4,
	)
	junkiness = 25
	tastes = list("de raisins secs" = 1)
	foodtypes = JUNKFOOD | FRUIT | SUGAR
	food_flags = FOOD_FINGER_FOOD
	custom_price = PAYCHECK_CREW * 0.7
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/no_raisin/healthy
	name = "raisins secs maison"
	desc = "Des raisins secs fait maison, les meilleures du secteur."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	junkiness = 0
	foodtypes = FRUIT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/spacetwinkie
	name = "\improper Twinkie de l'espace"
	icon_state = "space_twinkie"
	desc = "Cette barre vous survivera."
	food_reagents = list(/datum/reagent/consumable/sugar = 4)
	junkiness = 25
	foodtypes = JUNKFOOD | GRAIN | SUGAR
	food_flags = FOOD_FINGER_FOOD
	custom_price = PAYCHECK_LOWER
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/candy_trash
	name = "mégot de cigarette bonbon"
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "candybum"
	desc = " Les restes d'un bonbon-cigarette. C'est toujours comestible, je vous jure !"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 4,
		/datum/reagent/ash = 3,
	)
	junkiness = 10 //powergame trash food by buying candy cigs in bulk and eating them when they extinguish
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/candy_trash/nicotine
	desc = "Les restes d'un bonbon-cigarette. Il y a une petite odeur de nicotine, non ?"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 4,
		/datum/reagent/ash = 3,
		/datum/reagent/drug/nicotine = 1,
	)

/obj/item/food/cheesiehonkers
	name = "\improper Honkers au fromage"
	desc = "Des en-cas au fromage à croquer qui vous mettront l'eau à la bouche."
	icon_state = "cheesie_honkers"
	trash_type = /obj/item/trash/cheesie
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/sugar = 3,
	)
	junkiness = 25
	tastes = list("de fromage" = 5, "de croustillant" = 2)
	foodtypes = JUNKFOOD | DAIRY | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/syndicake
	name = "\improper syndi-gât'"
	icon_state = "syndi_cakes"
	desc = "Un petit gâteau extrêmement moelleux qui est tout aussi bon après avoir été atomisé."
	trash_type = /obj/item/trash/syndi_cakes
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/doctor_delight = 5,
	)
	tastes = list("de douceur" = 3, "de gâteau" = 1)
	foodtypes = GRAIN | FRUIT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/energybar
	name = "\improper barre énergétique à haute performance"
	icon_state = "energybar"
	desc = "Une barre énergétique avec beaucoup de puissance, que vous ne devriez probablement pas manger si vous n'êtes pas un Éthéré."
	trash_type = /obj/item/trash/energybar
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/liquidelectricity/enriched = 3,
	)
	tastes = list("d'électricité pure" = 3, "de forme" = 2)
	foodtypes = TOXIC
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/peanuts
	name = "\improper cacahuète de Rachel"
	desc = "Un classique pour les personnes qui méritent ce qui leur arrive. N'est-ce pas, Rachel ?!"
	icon_state = "peanuts"
	trash_type = /obj/item/trash/peanuts
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("cacahuètes" = 4, "colère" = 1)
	foodtypes = JUNKFOOD | NUTS
	custom_price = PAYCHECK_CREW * 0.8 //nuts are expensive in real life, and this is the best food in the vendor.
	junkiness = 10 //less junky than other options, since peanuts are a decently healthy snack option
	w_class = WEIGHT_CLASS_SMALL
	grind_results = list(/datum/reagent/consumable/peanut_butter = 5, /datum/reagent/consumable/cooking_oil = 2)
	var/safe_for_consumption = TRUE

/obj/item/food/peanuts/salted
	name = "\improper cacahuètes salés de réserve de Rachel"
	desc = "Quelque peu salé."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/salt = 1,
	)
	tastes = list("de cacahuètes" = 3, "de sel" = 1, "de tension artérielle élevée" = 1)

/obj/item/food/peanuts/wasabi
	name = "\improper cacahuètes au wasabi de Rachel"
	desc = "C'est tout ce que tu mérites, Rachel."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/capsaicin = 1,
	)
	tastes = list("de cacahuètes" = 3, "de wasabi" = 1, "de rage" = 1)

/obj/item/food/peanuts/honey_roasted
	name = "\improper cacahuètes 'déni de sucre' de Rachel"
	desc = "Curieusement amère pour une friandise sucrée. Un peu comme toi, Rachel !"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/sugar = 1,
	)
	tastes = list("de cacahuète" = 3, "de miel" = 1, "d'amertume" = 1)

/obj/item/food/peanuts/barbecue
	name = "\improper cacahuètes barbecue de Rachel"
	desc = "Là où il y a de la fumée, il n'y a pas nécessairement de feu - parfois, il s'agit simplement de sauce barbecue. Sauf quand Rachel est dans le coin."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/bbqsauce = 1,
	)
	tastes = list("de cacahuète" = 3, "de sauce barbecue" = 1, "d'engueulade" = 1)

/obj/item/food/peanuts/ban_appeal
	name = "\improper cacahuètes 'appel au ban' de Rachel"
	desc = "Une malheureuse tentative de mélange, interdit dans 6 secteurs. Les pressions exercées chaque année pour faire annuler cette interdiction sont fortes mais rien n'y fait. Pas parce que les pommes sont toxiques, comme l'est Rachel, mais parce que trop de personnes continuent d'essayer de contourner l'interdit."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/toxin/cyanide = 1,
	) //uses dried poison apples
	tastes = list("de cacahuète" = 3, "de pomme" = 1, "de regrets" = 1)
	safe_for_consumption = FALSE

/obj/item/food/peanuts/random
	name = "\improper cacahuètes tous goûts de Rachel"
	desc = "Sur quelle saveur allez-vous tomber ? Attention, la saveur Rachel est toxique pour la majorité des êtres vivants, un peu comme elle, d'ailleurs."
	icon_state = "peanuts"
	safe_for_consumption = FALSE

GLOBAL_LIST_INIT(safe_peanut_types, populate_safe_peanut_types())

/proc/populate_safe_peanut_types()
	. = list()
	for(var/obj/item/food/peanuts/peanut_type as anything in subtypesof(/obj/item/food/peanuts))
		if(!initial(peanut_type.safe_for_consumption))
			continue
		. += peanut_type

/obj/item/food/peanuts/random/Initialize(mapload)
	// Generate a sample p
	var/peanut_type = pick(GLOB.safe_peanut_types)
	var/obj/item/food/sample = new peanut_type(loc)

	name = sample.name
	desc = sample.desc
	food_reagents = sample.food_reagents
	tastes = sample.tastes

	qdel(sample)

	. = ..()

/obj/item/food/cnds
	name = "\improper C&Ds"
	desc = "Légalement, on ne peut pas dire que cela fera fondre vos mains."
	icon_state = "cnds"
	trash_type = /obj/item/trash/cnds
	food_reagents = list(
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/coco = 1,
	)
	tastes = list("de bonbon au chocolat" = 3)
	junkiness = 25
	foodtypes = JUNKFOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cnds/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] laisse les [src] fondre dans ses mains ! On dirait que [user.p_theyre()] essaye de se suicider !"))
	return TOXLOSS

/obj/item/food/cnds/caramel
	name = "C&Ds caramel"
	desc = "Farcies de caramel sucré, elles sont le pire cauchemar des diabétiques."
	food_reagents = list(
		/datum/reagent/consumable/sugar = 2,
		/datum/reagent/consumable/coco = 1,
		/datum/reagent/consumable/caramel = 1,
	)
	tastes = list("de bonbon au chocolat" = 2, "de caramel" = 1)

/obj/item/food/cnds/pretzel
	name = "C&Ds bretzel"
	desc = "Eine köstliche Begleitung zu Ihrem Lieblingsbier."
	food_reagents = list(
		/datum/reagent/consumable/sugar = 2,
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/coco = 1,
	)
	tastes = list("de bonbon au chocolat" = 2, "de bretzel" = 1)
	foodtypes = JUNKFOOD | GRAIN

/obj/item/food/cnds/peanut_butter
	name = "C&Ds beurre de cacahuète"
	desc = "Apprécié des petits enfants et des extraterrestres."
	food_reagents = list(
		/datum/reagent/consumable/sugar = 2,
		/datum/reagent/consumable/coco = 1,
		/datum/reagent/consumable/peanut_butter = 1,
	)
	tastes = list("de bonbon au chocolat" = 2, "de beurre de cacahuètes" = 1)

/obj/item/food/cnds/banana_honk
	name = "C&Ds banane"
	desc = "Le bonbon officiel des clowns. Pouet Pouet !"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 2,
		/datum/reagent/consumable/coco = 1,
		/datum/reagent/consumable/banana = 1,
	)
	tastes = list("de bonbon au chocolat" = 2, "de banane" = 1)

/obj/item/food/cnds/random
	name = "C&Ds mystère"
	desc = "Rempli de l'un des quatre délicieux parfums !"

/obj/item/food/cnds/random/Initialize(mapload)
	var/random_flavour = pick(subtypesof(/obj/item/food/cnds) - /obj/item/food/cnds/random)
	var/obj/item/food/sample = new random_flavour(loc)
	name = sample.name
	desc = sample.desc
	food_reagents = sample.food_reagents
	tastes = sample.tastes

	qdel(sample)

	. = ..()

/obj/item/food/pistachios
	name = "\improper pistaches Zack"
	desc = "Un paquet de pistaches de qualité supérieure de la marque Zack."
	icon_state = "pistachio"
	trash_type = /obj/item/trash/pistachios
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	) //a healthy but expensive snack
	tastes = list("de pistache" = 4, "de douceur subtile" = 1)
	foodtypes = JUNKFOOD | NUTS
	custom_price = PAYCHECK_CREW//pistachios are even more expensive.
	junkiness = 10 //on par with peanuts
	w_class = WEIGHT_CLASS_SMALL
	grind_results = list(/datum/reagent/consumable/peanut_butter = 5, /datum/reagent/consumable/cooking_oil = 2)

/obj/item/food/semki
	name = "\improper graines de tournesol Semki"
	desc = "Un paquet de graines de tournesol grillées."
	icon_state = "semki"
	trash_type = /obj/item/trash/semki
	food_reagents = list(
		/datum/reagent/consumable/cornoil = 1,
		/datum/reagent/consumable/salt = 6,
	) //1 cornoil is equal to 1.33 nutriment
	tastes = list("de tournesol" = 5)
	foodtypes = JUNKFOOD | NUTS
	custom_price = PAYCHECK_LOWER * 0.4 //sunflowers are cheap in real life.
	bite_consumption = 1
	junkiness = 25
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/semki/healthy
	name = "graines de tournesol grillés"
	desc = "Graines de tournesol grillées maison dans un gobelet en papier. Un en-cas sain et rassasiant à grignoter en regardant les gens passer."
	icon_state = "sunseeds"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/iron = 2,
	)
	junkiness = 5 //Homemade or not, sunflower seets are always kinda junky
	foodtypes = JUNKFOOD | NUTS
	trash_type = /obj/item/trash/semki/healthy

/obj/item/food/cornchips
	name = "\improper doritos"
	desc = "Des chips de maïs triangulaires. Elles semblent un peu fades, mais se marieraient probablement bien avec une sauce."
	icon_state = "boritos"
	trash_type = /obj/item/trash/boritos
	bite_consumption = 2
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/cooking_oil = 2,
		/datum/reagent/consumable/salt = 3,
	)
	junkiness = 20
	custom_price = PAYCHECK_LOWER * 0.8  //we are filled to the brim with flavor
	tastes = list("de maïs frit" = 1)
	foodtypes = JUNKFOOD | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cornchips/make_leave_trash()
	AddElement(/datum/element/food_trash, trash_type, FOOD_TRASH_POPABLE)

/obj/item/food/cornchips/blue
	name = "\improper doritos les plus cools"
	desc = "Et maintenant, on est cool ?"
	icon_state = "boritos"
	trash_type = /obj/item/trash/boritos
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/cooking_oil = 2,
		/datum/reagent/consumable/salt = 3,
		/datum/reagent/consumable/yoghurt = 1,
		/datum/reagent/consumable/garlic = 1,
	)
	tastes = list("de maïs frit" = 1, "de Cool" = 3)

/obj/item/food/cornchips/green
	name = "\improper doritos goût salsa"
	desc = "La salsa y est incorporée, il n'est donc pas nécessaire de la tremper."
	icon_state = "boritosgreen"
	trash_type = /obj/item/trash/boritos/green
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/cooking_oil = 2,
		/datum/reagent/consumable/salt = 3,
		/datum/reagent/consumable/astrotame = 1,
		/datum/reagent/consumable/blackpepper = 1,
	)
	tastes = list("de maïs frit" = 1, "de salsa de l'espace" = 3)

/obj/item/food/cornchips/red
	name = "\improper doritos au fromage"
	desc = "Réputé pour aider à recouvrir tout ce que vous touchez de poussière de fromage orange."
	icon_state = "boritosred"
	trash_type = /obj/item/trash/boritos/red
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/cooking_oil = 2,
		/datum/reagent/consumable/salt = 3,
		/datum/reagent/consumable/astrotame = 1,
		/datum/reagent/consumable/cornmeal = 1,
	)
	tastes = list("de maïs frit" = 1, "de fromage nacho" = 3)

/obj/item/food/cornchips/purple
	name = "\improper doritos chilly"
	desc = "Le seul arôme qui ait vraiment le goût épicé."
	icon_state = "boritospurple"
	trash_type = /obj/item/trash/boritos/purple
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/cooking_oil = 2,
		/datum/reagent/consumable/salt = 3,
		/datum/reagent/consumable/capsaicin = 1,
		/datum/reagent/consumable/sugar = 1,
	)
	tastes = list("de maïs frit" = 1, "de chili épicé et sucré" = 3)

/obj/item/food/cornchips/random
	name = "\improper doritos"
	desc = "Rempli de l'un des quatre délicieux parfums !"

/obj/item/food/cornchips/random/Initialize(mapload)
	var/random_flavour = pick(subtypesof(/obj/item/food/cornchips) - /obj/item/food/cornchips/random)

	var/obj/item/food/sample = new random_flavour(loc)

	name = sample.name
	desc = sample.desc
	food_reagents = sample.food_reagents
	icon_state = sample.icon_state
	trash_type = sample.trash_type
	tastes = sample.tastes

	qdel(sample)

	. = ..()
