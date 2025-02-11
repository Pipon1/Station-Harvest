/obj/item/food/cake
	icon = 'icons/obj/food/piecake.dmi'
	bite_consumption = 3
	max_volume = 80
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de gâteau" = 1)
	foodtypes = GRAIN | DAIRY
	/// type is spawned 5 at a time and replaces this cake when processed by cutting tool
	var/obj/item/food/cakeslice/slice_type
	/// changes yield of sliced cake, default for cake is 5
	var/yield = 5

/obj/item/food/cake/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/food_storage)

/obj/item/food/cake/make_processable()
	if (slice_type)
		AddElement(/datum/element/processable, TOOL_KNIFE, slice_type, yield, 3 SECONDS, table_required = TRUE, screentip_verb = "Slice")

/obj/item/food/cakeslice
	icon = 'icons/obj/food/piecake.dmi'
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de gâteau" = 1)
	foodtypes = GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cake/plain
	name = "Gâteau simple"
	desc = "Un gâteau simple. Ce n'est pas un mensonge."
	icon_state = "plaincake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 30,
		/datum/reagent/consumable/nutriment/vitamin = 7,
	)
	tastes = list("du sucre" = 2, "de gâteau" = 5)
	foodtypes = GRAIN | DAIRY | SUGAR
	burns_in_oven = TRUE
	slice_type = /obj/item/food/cakeslice/plain

/obj/item/food/cakeslice/plain
	name = "Tranche de gâteau simple"
	desc = "Juste une tranche de gâteau, cela suffit à la plupart des gens."
	icon_state = "plaincake_slice"
	tastes = list("du sucre" = 2, "de gâteau" = 5)
	foodtypes = GRAIN | DAIRY | SUGAR

/obj/item/food/cake/carrot
	name = "Gâteau à la carotte"
	desc = "Le dessert favoris d'un certain lapin de dessin animé. Ce n'est pas un mensonge."
	icon_state = "carrotcake"
	tastes = list("de gâteau" = 5, "du sucre" = 2, "de carotte" = 1)
	foodtypes = GRAIN | DAIRY | VEGETABLES | SUGAR
	venue_value = FOOD_PRICE_CHEAP
	slice_type = /obj/item/food/cakeslice/carrot

/obj/item/food/cakeslice/carrot
	name = "Tranche de gâteau à la carotte"
	desc = "Une tranche carottée de gâteau à la carotte, les carottes sont bonnes pour votre vue ! Ce n'est toujours pas un mensonge."
	icon_state = "carrotcake_slice"
	tastes = list("de gâteau" = 5, "du sucre" = 2, "de carotte" = 1)
	foodtypes = GRAIN | DAIRY | VEGETABLES | SUGAR

/obj/item/food/cake/brain
	name = "Gâteau-Cerveau"
	desc = "Une espèce de gâteau spongieux."
	icon_state = "braincake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/medicine/mannitol = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de gâteau" = 5, "du sucre" = 2, "de cerveaux" = 1)
	foodtypes = GRAIN | DAIRY | MEAT | GORE | SUGAR
	slice_type = /obj/item/food/cakeslice/brain

/obj/item/food/cakeslice/brain
	name = "Tranche de gâteau-cerveau"
	desc = "Laissez moi vous parler des prions : ILS SONT DÉLICIEUX."
	icon_state = "braincakeslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/medicine/mannitol = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de gâteau" = 5, "du sucre" = 2, "de cerveaux" = 1)
	foodtypes = GRAIN | DAIRY | MEAT | GORE | SUGAR

/obj/item/food/cake/cheese
	name = "Cheesecake"
	desc = "DANGEREUSEMENT tarte."
	icon_state = "cheesecake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 8,
		/datum/reagent/consumable/nutriment/protein = 5,
	)
	tastes = list("de gâteau" = 4, "de fromage frais" = 3)
	foodtypes = GRAIN | DAIRY
	venue_value = FOOD_PRICE_CHEAP
	slice_type = /obj/item/food/cakeslice/cheese

/obj/item/food/cakeslice/cheese
	name = "Tranche de cheesecake"
	desc = "Une tranche de pure fromagisfaction."
	icon_state = "cheesecake_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1.3,
	)
	tastes = list("de gâteau" = 4, "de fromage frais" = 3)
	foodtypes = GRAIN | DAIRY

/obj/item/food/cake/orange
	name = "Gâteau à l'orange"
	desc = "Un gâteau avec de l'orange."
	icon_state = "orangecake"
	tastes = list("de gâteau" = 5, "du sucre" = 2, "d'oranges" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR | ORANGES
	venue_value = FOOD_PRICE_CHEAP
	slice_type = /obj/item/food/cakeslice/orange

/obj/item/food/cakeslice/orange
	name = "Tranche de gâteau à l'orange"
	desc = "Juste une tranche de gâteau à l'orange, cela suffit à la plupart des gens."
	icon_state = "orangecake_slice"
	tastes = list("de gâteau" = 5, "du sucre" = 2, "d'oranges" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR | ORANGES

/obj/item/food/cake/lime
	name = "Gâteau au citron vert"
	desc = "Un gâteau avec du citron vert."
	icon_state = "limecake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("de gâteau" = 5, "du sucre" = 2, "d'un citron d'une acidité insoutenable" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	venue_value = FOOD_PRICE_CHEAP
	slice_type = /obj/item/food/cakeslice/lime

/obj/item/food/cakeslice/lime
	name = "Tranche de gâteau au citron vert"
	desc = "Juste une tranche de gâteau au citron vert, cela suffit à la plupart des gens."
	icon_state = "limecake_slice"
	tastes = list("de gâteau" = 5, "du sucre" = 2, "d'un citron d'une acidité insoutenable" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/lemon
	name = "Gâteau au citron"
	desc = "Un gâteau avec du citron."
	icon_state = "lemoncake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("de gâteau" = 5, "du sucre" = 2, "d'un citron acide" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	venue_value = FOOD_PRICE_CHEAP
	slice_type = /obj/item/food/cakeslice/lemon

/obj/item/food/cakeslice/lemon
	name = "Tranche de gâteau au citron"
	desc = "Juste une tranche de gâteau au citron, cela suffit à la plupart des gens."
	icon_state = "lemoncake_slice"
	tastes = list("de gâteau" = 5, "du sucre" = 2, "d'un citron acide" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/chocolate
	name = "Gâteau au chocolat"
	desc = "Un gâteau avec du chocolat."
	icon_state = "chocolatecake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("de gâteau" = 5, "du sucre" = 1, "de chocolat" = 4)
	foodtypes = GRAIN | DAIRY | JUNKFOOD | SUGAR
	venue_value = FOOD_PRICE_CHEAP
	slice_type = /obj/item/food/cakeslice/chocolate

/obj/item/food/cakeslice/chocolate
	name = "Tranche de gâteau au chocolat"
	desc = "Juste une tranche de gâteau au chocolat, cela suffit à la plupart des gens."
	icon_state = "chocolatecake_slice"
	tastes = list("de gâteau" = 5, "du sucre" = 1, "de chocolate" = 4)
	foodtypes = GRAIN | DAIRY | JUNKFOOD | SUGAR

/obj/item/food/cake/birthday
	name = "Gâteau d'anniversaire"
	desc = "Joyeux anniversaire Ponpon !"
	icon_state = "birthdaycake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/sprinkles = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de gâteau" = 5, "du sucre" = 1)
	foodtypes = GRAIN | DAIRY | JUNKFOOD | SUGAR
	slice_type = /obj/item/food/cakeslice/birthday

/obj/item/food/cake/birthday/make_microwaveable() // super sekrit club
	AddElement(/datum/element/microwavable, /obj/item/clothing/head/utility/hardhat/cakehat)

/obj/item/food/cakeslice/birthday
	name = "Tranche de gâteau d'anniversaire"
	desc = "Une part de votre anniversaire."
	icon_state = "birthdaycakeslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/sprinkles = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de gâteau" = 5, "du sucre" = 1)
	foodtypes = GRAIN | DAIRY | JUNKFOOD | SUGAR

/obj/item/food/cake/birthday/energy
	name = "Gâteau énergétique"
	desc = "Juste assez de calories pour une équipe d'agents nucléaires."
	icon_state = "energycake"
	force = 5
	hitsound = 'sound/weapons/blade1.ogg'
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/sprinkles = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/pwr_game = 10,
		/datum/reagent/consumable/liquidelectricity/enriched = 10,
	)
	tastes = list("de gâteau" = 3, "de vodka et de mauvais humour" = 1)
	slice_type = /obj/item/food/cakeslice/birthday/energy

/obj/item/food/cake/birthday/energy/make_microwaveable() //super sekriter club
	AddElement(/datum/element/microwavable, /obj/item/clothing/head/utility/hardhat/cakehat/energycake)

/obj/item/food/cake/birthday/energy/proc/energy_bite(mob/living/user)
	to_chat(user, "<font color='red' size='5'>En mangeant le gâteau, vous vous blessez accidentellement avec une épée énergétique cachée.</font>")
	user.apply_damage(30, BRUTE, BODY_ZONE_HEAD)
	playsound(user, 'sound/weapons/blade1.ogg', 5, TRUE)

/obj/item/food/cake/birthday/energy/attack(mob/living/target_mob, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM) && target_mob != user) //Prevents pacifists from attacking others directly
		return
	energy_bite(target_mob, user)

/obj/item/food/cakeslice/birthday/energy
	name = "energy cake slice"
	desc = "Pour un traitre, à emporter."
	icon_state = "energycakeslice"
	force = 2
	hitsound = 'sound/weapons/blade1.ogg'
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/sprinkles = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/pwr_game = 2,
		/datum/reagent/consumable/liquidelectricity/enriched = 2,
	)
	tastes = list("de gâteau" = 3, "de vodka et de mauvais humour" = 1)

/obj/item/food/cakeslice/birthday/energy/proc/energy_bite(mob/living/user)
	to_chat(user, "<font color='red' size='5'>En mangeant le gâteau, vous vous blessez accidentellement avec une dague énergétique cachée.</font>")
	user.apply_damage(18, BRUTE, BODY_ZONE_HEAD)
	playsound(user, 'sound/weapons/blade1.ogg', 5, TRUE)

/obj/item/food/cakeslice/birthday/energy/attack(mob/living/target_mob, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM) && target_mob != user) //Prevents pacifists from attacking others directly
		return
	energy_bite(target_mob, user)

/obj/item/food/cake/apple
	name = "Gâteau à la pomme"
	desc = "Un gâteau centré sur la pomme."
	icon_state = "applecake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("de gâteau" = 5, "du sucre" = 1, "de pomme" = 1)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	venue_value = FOOD_PRICE_CHEAP
	slice_type = /obj/item/food/cakeslice/apple

/obj/item/food/cakeslice/apple
	name = "Tranche de gâteau à la pomme"
	desc = "Une tranche d'un délicieux gâteau."
	icon_state = "applecakeslice"
	tastes = list("de gâteau" = 5, "du sucre" = 1, "de pomme" = 1)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/slimecake
	name = "Gâteau au slime"
	desc = "Un gâteau fait de slime. Probablement pas électrifié."
	icon_state = "slimecake"
	tastes = list("de gâteau" = 5, "du sucre" = 1, "de slime" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	slice_type = /obj/item/food/cakeslice/slimecake

/obj/item/food/cakeslice/slimecake
	name = "Tranche de gâteau au slime"
	desc = "Une tranche de gâteau au slime."
	icon_state = "slimecake_slice"
	tastes = list("de gâteau" = 5, "du sucre" = 1, "de slime" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR

/obj/item/food/cake/pumpkinspice
	name = "Gâteau à la citrouille"
	desc = "Un gâteau évidé fait avec de la vraie citrouille."
	icon_state = "pumpkinspicecake"
	tastes = list("de gâteau" = 5, "du sucre" = 1, "de citrouille" = 1)
	foodtypes = GRAIN | DAIRY | VEGETABLES | SUGAR
	venue_value = FOOD_PRICE_CHEAP
	slice_type = /obj/item/food/cakeslice/pumpkinspice

/obj/item/food/cakeslice/pumpkinspice
	name = "Tranche de gâteau à la citrouille"
	desc = "Une tranche pleine de toutes les bonnes choses contenues dans une citrouille."
	icon_state = "pumpkinspicecakeslice"
	tastes = list("de gâteau" = 5, "du sucre" = 1, "de citrouille" = 1)
	foodtypes = GRAIN | DAIRY | VEGETABLES | SUGAR

/obj/item/food/cake/bsvc // blackberry strawberries vanilla cake
	name = "Gâteau aux baies"
	desc = "Un simple gâteau, agrémenté d'un assortiment de mûres et de fraises vanillées !"
	icon_state = "blackbarry_strawberries_cake_vanilla_cake"
	tastes = list("de mûres" = 2, "de fraises" = 2, "de vanille" = 2, "du sucre" = 2, "de gâteau" = 3)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	slice_type = /obj/item/food/cakeslice/bsvc

/obj/item/food/cakeslice/bsvc
	name = "Tranche de gâteaux aux baies"
	desc = "Une simple tranche de gâteau agrémenté aux mûres et fraises vanillées !"
	icon_state = "blackbarry_strawberries_cake_vanilla_slice"
	tastes = list("de mûres" = 2, "de " = 2, "de vanilles" = 2, "du sucre" = 2, "de gâteau" = 3)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/bscc // blackbarry strawberries chocolate cake <- this is a relic from before resprite
	name = "Gâteau chocolat-fraise"
	desc = "Un gâteau au chocolat avec cinq fraises sur le dessus. Pour une raison inconnue, cette présentation plait particulièrement aux IA."
	icon_state = "liars_cake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/coco = 5,
	)
	tastes = list("de mûres" = 2, "de fraises" = 2, "de chocolat" = 2, "du sucre" = 2, "de gâteau" = 3)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	slice_type = /obj/item/food/cakeslice/bscc

/obj/item/food/cakeslice/bscc
	name = "Tranche de gâteau chocolat-fraise"
	desc = "Juste une tranche de gâteau au chocolat. Si vous avez de la chance, il y a une fraise sur le dessus. \
		Pour une raison inconnue, cette présentation plait particulièrement aux IA."
	icon_state = "liars_slice"
	tastes = list("de fraises" = 2, "de chocolat" = 2, "du sucre" = 2, "de gâteau" = 3)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/holy_cake
	name = "Gâteau angélique"
	desc = "Un gâteau pour les anges et les chapelains ! Contient de l'eau bénite."
	icon_state = "holy_cake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/vitamin = 3,
		/datum/reagent/water/holywater = 10,
	)
	tastes = list("de gâteau" = 5, "du sucre" = 1, "de nuages" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	slice_type = /obj/item/food/cakeslice/holy_cake_slice

/obj/item/food/cakeslice/holy_cake_slice
	name = "Tranche de gâteau angélique"
	desc = "Une tranche au petit goût de paradis."
	icon_state = "holy_cake_slice"
	tastes = list("de gâteau" = 5, "du sucre" = 1, "de nuages" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR

/obj/item/food/cake/pound_cake
	name = "Quatre-quarts"
	desc = "Un gâteau très dense, fait pour rassasier les gens rapidement."
	icon_state = "pound_cake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 60,
		/datum/reagent/consumable/nutriment/vitamin = 20,
	)
	tastes = list("de gâteau" = 5, "du sucre" = 5, "de pâte" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR | JUNKFOOD
	venue_value = FOOD_PRICE_CHEAP
	slice_type = /obj/item/food/cakeslice/pound_cake_slice
	yield = 7

/obj/item/food/cakeslice/pound_cake_slice
	name = "Tranche de quatre-quarts"
	desc = "Une tranche d'un gâteau très dense, fait pour rassasier les gens rapidement."
	icon_state = "pound_cake_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 9,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de gâteau" = 5, "du sucre" = 5, "de pâte" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR | JUNKFOOD

/obj/item/food/cake/hardware_cake
	name = "Gâteau électronique"
	desc = "Un \"gâteau\" qui a été fait à partir de cartes mères et de fuites d'acides..."
	icon_state = "hardware_cake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/toxin/acid = 15,
		/datum/reagent/fuel/oil = 15,
	)
	tastes = list("d'acide" = 3, "de métal" = 4, "de verre" = 5)
	foodtypes = GRAIN | GROSS
	slice_type = /obj/item/food/cakeslice/hardware_cake_slice

/obj/item/food/cakeslice/hardware_cake_slice
	name = "Tranche de gâteau électronique"
	desc = "Une tranche de cartes mères et d'acide."
	icon_state = "hardware_cake_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/toxin/acid = 3,
		/datum/reagent/fuel/oil = 3,
	)
	tastes = list("d'acide" = 3, "de métal" = 4, "de verre" = 5)
	foodtypes = GRAIN | GROSS

/obj/item/food/cake/vanilla_cake
	name = "Gâteau à la vanille"
	desc = "Un gâteau à la vanille avec du glaçage dessus."
	icon_state = "vanillacake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/sugar = 15,
		/datum/reagent/consumable/vanilla = 15,
	)
	tastes = list("de gâteau" = 1, "du sucre" = 1, "de vanille" = 10)
	foodtypes = GRAIN | SUGAR | DAIRY
	slice_type = /obj/item/food/cakeslice/vanilla_slice

/obj/item/food/cakeslice/vanilla_slice
	name = "Tranche de gâteau à la vanille"
	desc = "Une tranche de gâteau à la vanille recouvert de glaçage."
	icon_state = "vanillacake_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/vanilla = 3,
	)
	tastes = list("de gâteau" = 1, "de sucre" = 1, "de vanille" = 10)
	foodtypes = GRAIN | SUGAR | DAIRY

/obj/item/food/cake/clown_cake
	name = "Gâteau clownesque"
	desc = "Un drôle de gâteau avec une tête de clown dessinée dessus."
	icon_state = "clowncake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/banana = 15,
	)
	tastes = list("de gâteau" = 1, "de sucre" = 1, "de joie" = 10)
	foodtypes = GRAIN | SUGAR | DAIRY
	slice_type = /obj/item/food/cakeslice/clown_slice

/obj/item/food/cakeslice/clown_slice
	name = "Tranche de gâteau au clown"
	desc = "Une tranche de mauvaises blagues et d'accessoires stupides."
	icon_state = "clowncake_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/banana = 3,
	)
	tastes = list("de gâteau" = 1, "du sucre" = 1, "de joie" = 10)
	foodtypes = GRAIN | SUGAR | DAIRY

/obj/item/food/cake/trumpet
	name = "Gâteau de l'astronaute"
	desc = "Un gâteau recouvert de glaçage à la trompette de l'astronaute."
	icon_state = "trumpetcake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/berryjuice = 5,
	)
	tastes = list("de gâteau" = 4, "de violettes" = 2, "de confiture" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	slice_type = /obj/item/food/cakeslice/trumpet

/obj/item/food/cakeslice/trumpet
	name = "Tranche de gâteau de l'astronaute"
	desc = "Une tranche de gâteau recouvert de glaçage à la trompette de l'astronaute."
	icon_state = "trumpetcakeslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/cream = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/berryjuice = 1,
	)
	tastes = list("de gâteau" = 4, "de violettes" = 2, "de confiture" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/brioche
	name = "Gâteau brioche"
	desc = "Un anneau de douces brioches dorées."
	icon_state = "briochecake"
	tastes = list("de gâteau" = 4, "de beurre" = 2, "de crème" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	slice_type = /obj/item/food/cakeslice/brioche
	yield = 6

/obj/item/food/cakeslice/brioche
	name = "Tranche de gâteau brioche"
	desc = "Un délicieux pain sucré. Qui aurait besoin de quoi que ce soit d'autre ?"
	icon_state = "briochecake_slice"
	tastes = list("de gâteau" = 4, "de beurre" = 2, "de crème" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR

/obj/item/food/cake/pavlova
	name = "Pavlova"
	desc = "Un gâteau aux baies sucrées. Inventée en Nouvelle Zélande mais nomée d'après une ballerine russe... Prouvé scientifiquement comme étant le meilleur dessert pour un dîner !"
	icon_state = "pavlova"
	tastes = list("de meringue" = 5, "de crème" = 1, "de baies" = 1)
	foodtypes = DAIRY | FRUIT | SUGAR
	slice_type = /obj/item/food/cakeslice/pavlova

/obj/item/food/cake/pavlova/nuts
	name = "Pavlova avec des noix"
	foodtypes = NUTS | FRUIT | SUGAR
	slice_type = /obj/item/food/cakeslice/pavlova/nuts

/obj/item/food/cakeslice/pavlova
	name = "Tranche de Pavlova"
	desc = "Une tranche de Pavlova, les baies sont dans un équilibre précaires ! \
		Vos calculs diaboliques ont été intenses, pour trouver la façon de couper qui vous donnera le plus de baies."
	icon_state = "pavlova_slice"
	tastes = list("de meringue" = 5, "de crème" = 1, "de baies" = 1)
	foodtypes = DAIRY | FRUIT | SUGAR

/obj/item/food/cakeslice/pavlova/nuts
	foodtypes = NUTS | FRUIT | SUGAR

/obj/item/food/cake/fruit
	name = "Cake anglais"
	desc = "Un vrai bon gâteau, non ?"
	icon_state = "fruitcake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/sugar = 10,
		/datum/reagent/consumable/cherryjelly = 5,
	)
	tastes = list("de fruits secs" = 5, "de mélasse" = 2, "de Noël" = 2)
	force = 7
	throwforce = 7
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	slice_type = /obj/item/food/cakeslice/fruit

/obj/item/food/cakeslice/fruit
	name = "Tranche de cake anglais"
	desc = "Une vraie bonne tranche, non ?"
	icon_state = "fruitcake_slice1"
	base_icon_state = "fruitcake_slice"
	tastes = list("de fruits secs" = 5, "de mélasse" = 2, "de Noël" = 2)
	force = 2
	throwforce = 2
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cakeslice/fruit/Initialize(mapload)
	. = ..()
	icon_state = "[base_icon_state][rand(1,3)]"

/obj/item/food/cake/plum
	name = "Gâteau aux prunes"
	desc = "Un gâteau centré sur les prunes."
	icon_state = "plumcake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/impurity/rosenol = 8,
	)
	tastes = list("de gâteau" = 5, "du sucre" = 1, "de prune" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	venue_value = FOOD_PRICE_CHEAP
	slice_type = /obj/item/food/cakeslice/plum

/obj/item/food/cakeslice/plum
	name = "Tranche de gâteau aux prunes"
	desc = "Une tranche de gâteau aux prunes."
	icon_state = "plumcakeslice"
	tastes = list("de gâteau" = 5, "du sucre" = 1, "de prune" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
