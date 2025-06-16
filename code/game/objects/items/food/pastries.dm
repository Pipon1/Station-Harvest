//Pastry is a food that is made from dough which is made from wheat or rye flour.
//This file contains pastries that don't fit any existing categories.
////////////////////////////////////////////MUFFINS////////////////////////////////////////////

/obj/item/food/muffin
	name = "muffin"
	desc = "Un délicieux petit gâteau spongieux."
	icon_state = "muffin"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de muffin" = 1)
	foodtypes = GRAIN | SUGAR | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/muffin/berry
	name = "muffin aux baies"
	icon_state = "berrymuffin"
	desc = "Un délicieux petit gâteau spongieux aux baies."
	tastes = list("de muffin" = 3, "de baies" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR | BREAKFAST
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/muffin/booberry
	name = "muffin boobaies"
	icon_state = "berrymuffin"
	alpha = 125
	desc = "Mon estomac est une tombe ! Rien ne peut étancher ma soif de sang !"
	tastes = list("de muffin" = 3, "de peurounette" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR | BREAKFAST

/obj/item/food/muffin/moffin
	name = "moffin"
	icon_state = "moffin_1"
	base_icon_state = "moffin"
	desc = "Un délicieux petit gâteau spongieux, avec une touche qui devrait plaire aux moths."
	tastes = list("muffin" = 3, "dust" = 1, "lint" = 1)
	foodtypes = CLOTH | GRAIN | SUGAR | BREAKFAST

/obj/item/food/muffin/moffin/Initialize(mapload)
	. = ..()
	icon_state = "[base_icon_state]_[rand(1, 3)]"

/obj/item/food/muffin/moffin/examine(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/moffin_observer = user
	if(moffin_observer.dna.species.liked_food & CLOTH)
		. += span_nicegreen("Ooh ! Il y a même un petit peu de tissu par dessus ! Super !")
	else
		. += span_warning("Vous n'êtes pas trop sûr.e de ce qu'il y a par dessus......")

////////////////////////////////////////////WAFFLES////////////////////////////////////////////

/obj/item/food/waffles
	name = "gaufres"
	desc = "Mmm, gaufres."
	icon_state = "waffles"
	trash_type = /obj/item/trash/waffles
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de gaufre" = 1)
	foodtypes = GRAIN | SUGAR | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soylentgreen
	name = "\improper Soleil Vert"
	desc = "Garanti sans humain." //Totally people.
	icon_state = "soylent_green"
	trash_type = /obj/item/trash/waffles
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 4,
	)
	tastes = list("de gaufre" = 7, "de gens" = 1)
	foodtypes = GRAIN | MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soylenviridians
	name = "\improper Soleil de Virdians"
	desc = "Garanti sans humain." //Actually honest for once.
	icon_state = "soylent_yellow"
	trash_type = /obj/item/trash/waffles
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("de gaufre" = 7, "de la couleur vert" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/rofflewaffles
	name = "gaufres roffle"
	desc = "Gaufres de Roffle. Co."
	icon_state = "rofflewaffles"
	trash_type = /obj/item/trash/waffles
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/drug/mushroomhallucinogen = 2,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de gaufre" = 1, "de champignon" = 1)
	foodtypes = GRAIN | VEGETABLES | SUGAR | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL

////////////////////////////////////////////OTHER////////////////////////////////////////////

/obj/item/food/cookie
	name = "cookie"
	desc = "COOKIE !!!"
	icon_state = "COOKIE!!!"
	bite_consumption = 1
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("de cookie" = 1)
	foodtypes = GRAIN | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cookie/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/cookie/sleepy
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/toxin/chloralhydrate = 10)

/obj/item/food/fortunecookie
	name = "fortune cookie"
	desc = "Une vraie prophétie dans chaque biscuit !"
	icon_state = "fortune_cookie"
	trash_type = /obj/item/paper/paperslip
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("de cookie" = 1, "de papier" = 1)
	foodtypes = GRAIN | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fortunecookie/proc/get_fortune()
	var/atom/drop_location = drop_location()

	var/obj/item/paper/fortune = locate(/obj/item/paper) in src
	// If a fortune exists, use that.
	if (fortune)
		fortune.forceMove(drop_location)
		return fortune

	// Otherwise, use a generic one
	var/obj/item/paper/paperslip/fortune_slip = new trash_type(drop_location)
	fortune_slip.name = "fortune slip"
	// if someone adds lottery tickets in the future, be sure to add random numbers to this
	fortune_slip.default_raw_text = pick(GLOB.wisdoms)

	return fortune_slip

/obj/item/food/fortunecookie/make_leave_trash()
	if(trash_type)
		AddElement(/datum/element/food_trash, trash_type, food_flags, TYPE_PROC_REF(/obj/item/food/fortunecookie, get_fortune))

/obj/item/food/cookie/sugar
	name = "cookie au sucre"
	desc = "Exactement comme ce que votre petit soeur arrive à faire."
	icon_state = "sugarcookie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/sugar = 6,
	)
	tastes = list("de sucré" = 1)
	foodtypes = GRAIN | JUNKFOOD | SUGAR

/obj/item/food/cookie/sugar/Initialize(mapload)
	. = ..()
	if(check_holidays(FESTIVE_SEASON))
		var/shape = pick("d'arbre", "d'ours", "de père noël", "de chaussette de noël", "de cadeau", "de sucre d'orge")
		desc = "Un cookie au sucre dans en forme [shape]. J'espère que le père noël va aimer !"
		icon_state = "sugarcookie_[shape]"

/obj/item/food/chococornet
	name = "cornet au chocolat"
	desc = "Vous commencez par quel côté, le grand côté ou le petit côté ?"
	icon_state = "chococornet"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de biscuit" = 3, "de chocolat" = 1)
	foodtypes = GRAIN | JUNKFOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cookie/oatmeal
	name = "cookie à l'avoine"
	desc = "Le meilleur du cookie et de l'avoine."
	icon_state = "oatmealcookie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de cookie" = 2, "d'avoine" = 1)
	foodtypes = GRAIN

/obj/item/food/cookie/raisin
	name = "cookie au raisin"
	desc = "Pourquoi vous voudriez mettre des raisons dans un cookie ?"
	icon_state = "raisincookie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de cookie" = 1, "de raisins" = 1)
	foodtypes = GRAIN | FRUIT

/obj/item/food/poppypretzel
	name = "bretzel au pavot"
	desc = "C'est tout entortillé !"
	icon_state = "poppypretzel"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de bretzel" = 1)
	foodtypes = GRAIN | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/plumphelmetbiscuit
	name = "chapeau rondouillet"
	desc = "Un biscuit finement préparé, à base de chapeaux rondouillets finement émincés cultivés par des nains."
	icon_state = "phelmbiscuit"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de champignon" = 1, "de biscuit" = 1)
	foodtypes = GRAIN | VEGETABLES
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/plumphelmetbiscuit/Initialize(mapload)
	var/fey = prob(10)
	if(fey)
		name = "chapeau rondouillet exeptionnel"
		desc = "Le micro-onde a été pris d'une humeur féérique !"
		food_reagents = list(
			/datum/reagent/medicine/omnizine = 5,
			/datum/reagent/consumable/nutriment = 1,
			/datum/reagent/consumable/nutriment/vitamin = 1,
		)
	. = ..()
	if(fey)
		reagents.add_reagent(/datum/reagent/medicine/omnizine, 5)

/obj/item/food/cracker
	name = "cracker"
	desc = "Un biscuit salé."
	icon_state = "cracker"
	bite_consumption = 1
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("de cracker" = 1)
	foodtypes = GRAIN
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/khachapuri
	name = "khachapuri"
	desc = "Du pain avec des oeufs et du fromage ?"
	icon_state = "khachapuri"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de pain" = 1, "d'oeuf" = 1, "de fromage" = 1)
	foodtypes = GRAIN | MEAT | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cherrycupcake
	name = "cupcake aux cerises"
	desc = "Un cupcake sucré avec des petits bouts de cerise."
	icon_state = "cherrycupcake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de gâteau" = 3, "de cerise" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cherrycupcake/blue
	name = "cupcake aux cerises bleues"
	desc = "Des bouts de cerises bleues dans un délicieux cupcake."
	icon_state = "bluecherrycupcake"
	tastes = list("de gâteau" = 3, "de cerise bleue" = 1)

/obj/item/food/honeybun
	name = "roulé au miel"
	desc = "Une patisserie collante avec un glaçage au miel."
	icon_state = "honeybun"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/honey = 6,
	)
	tastes = list("de patisserie" = 1, "de sucré" = 1)
	foodtypes = GRAIN | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cannoli
	name = "cannoli"
	desc = "Une friandise sicilienne, à donner à la sécurité."
	icon_state = "cannoli"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de patisserie" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	w_class = WEIGHT_CLASS_TINY
	venue_value = FOOD_PRICE_CHEAP // Pastry base, 3u of sugar and a single. fucking. unit. of. milk. really?

/obj/item/food/icecream
	name = "cornet de glace"
	desc = "Une délicieux cornet de glace, mais pas de glace :(."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "icecream_cone_waffle"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("de sucré" = 2, "de gaufre" = 1)
	bite_consumption = 4
	foodtypes = DAIRY | SUGAR
	food_flags = FOOD_FINGER_FOOD
	max_volume = 10 //The max volumes scales up with the number of scoops of ice cream served.
	/// These two variables are used by the ice cream vat. Latter is the one that shows on the UI.
	var/list/ingredients = list(
		/datum/reagent/consumable/flour,
		/datum/reagent/consumable/sugar,
	)
	var/ingredients_text
	/*
	 * Assoc list var used to prefill the cone with ice cream.
	 * Key is the flavour's name (use text defines; see __DEFINES/food.dm or ice_cream_holder.dm),
	 * assoc is the list of args that is going to be used in [flavour/add_flavour()]. Can as well be null for simple flavours.
	 */
	var/list/prefill_flavours

/obj/item/food/icecream/Initialize(mapload, list/prefill_flavours)
	if(prefill_flavours)
		src.prefill_flavours = prefill_flavours
	return ..()

/obj/item/food/icecream/make_edible()
	. = ..()
	AddComponent(/datum/component/ice_cream_holder, filled_name = "glace", change_desc = TRUE, prefill_flavours = prefill_flavours)

/obj/item/food/icecream/chocolate
	name = "cornet au chocolat"
	desc = "Un délciieux cornet de glace au chocolat, mais pas de glace."
	icon_state = "icecream_cone_chocolate"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/coco = 1,
	)
	ingredients = list(
		/datum/reagent/consumable/flour,
		/datum/reagent/consumable/sugar,
		/datum/reagent/consumable/coco,
	)

/obj/item/food/cookie/peanut_butter
	name = "cookie au beurre de cacahuète"
	desc = "Un cookie au beurre de cacahuète."
	icon_state = "peanut_butter_cookie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/peanut_butter = 5,
	)
	tastes = list("de beurre de cacahuète" = 2, "de cookie" = 1)
	foodtypes = GRAIN | JUNKFOOD | NUTS

/obj/item/food/raw_brownie_batter
	name = "pâte à brownie crue"
	desc = "Une mixture collante semblant être de la pâte à brownie et qui n'attend que d'être cuite dans un four."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "raw_brownie_batter"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de pâte à brownie crue" = 1)
	foodtypes = GRAIN | JUNKFOOD | SUGAR | BREAKFAST

/obj/item/food/raw_brownie_batter/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/brownie_sheet, rand(20 SECONDS, 30 SECONDS), TRUE, TRUE)

/obj/item/food/brownie_sheet
	name = "plaque de brownie"
	desc = "Une plaque de brownie qui n'a pas été coupée. Utilisez un couteau pour vous en couper une part !"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "brownie_sheet"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/sugar = 12,
	)
	tastes = list("de brownie" = 1, "de chocolat" = 1)
	foodtypes = GRAIN | JUNKFOOD | SUGAR
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/brownie_sheet/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/brownie, 4, 3 SECONDS, table_required = TRUE,  screentip_verb = "Couper")

/obj/item/food/brownie
	name = "brownie"
	desc = "Un délicieux carré de brownie."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "brownie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/sugar = 3,
	)
	tastes = list("de brownie" = 1, "de chocolat" = 1)
	foodtypes = GRAIN | JUNKFOOD | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/peanut_butter_brownie_batter
	name = "pâte à brownie au beurre cacahuète crue"
	desc = "Une mixture collante semblant être de la pâte à brownie au beurre de cacahuète et qui n'attend que d'être cuite dans un four."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "peanut_butter_brownie_batter"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/peanut_butter = 4,
	)
	tastes = list("de pâte à brownie crue" = 1)
	foodtypes = GRAIN | JUNKFOOD | SUGAR | NUTS

/obj/item/food/peanut_butter_brownie_batter/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/peanut_butter_brownie_sheet, rand(20 SECONDS, 30 SECONDS), TRUE, TRUE)

/obj/item/food/peanut_butter_brownie_sheet
	name = "plaque de brownie au buerre de cacahuète"
	desc = "Une plaque de brownie au beurre de cacahuète qui n'a pas été coupée. Utilisez un couteau pour vous en couper une part !"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "peanut_butter_brownie_sheet"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 24,
		/datum/reagent/consumable/sugar = 16,
		/datum/reagent/consumable/peanut_butter = 20,
	)
	tastes = list("de brownie" = 1, "de chocolat" = 1, "de beurre de cacahuète" = 1)
	foodtypes = GRAIN | JUNKFOOD | SUGAR | NUTS
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/peanut_butter_brownie_sheet/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/peanut_butter_brownie, 4, 3 SECONDS, table_required = TRUE,  screentip_verb = "Slice")

/obj/item/food/peanut_butter_brownie
	name = "brownie au beurre de cacahuète"
	desc = "Un délicieux carré de brownie au beurre de cacahuète."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "peanut_butter_brownie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/sugar = 4,
		/datum/reagent/consumable/peanut_butter = 5,
	)
	tastes = list("de brownie" = 1, "de chocolat" = 1, "de beurre de cacahuète" = 1)
	foodtypes = GRAIN | JUNKFOOD | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/crunchy_peanut_butter_tart
	name = "tarte croustillante au beurre de cacahuète"
	desc = "Une petite tarte avec une garniture au beurre de cacahuète et un glaçage à la crème, soupoudré de cacahuètes."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "crunchy_peanut_butter_tart"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/sugar = 6,
		/datum/reagent/consumable/peanut_butter = 5,
	)
	tastes = list("de beurre de cacahuète" = 1, "de cacahuète" = 1, "de crème" = 1)
	foodtypes = GRAIN | JUNKFOOD | SUGAR | NUTS
	w_class = WEIGHT_CLASS_SMALL
