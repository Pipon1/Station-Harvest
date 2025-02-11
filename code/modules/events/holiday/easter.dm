/datum/round_event_control/easter
	name = "Chasse aux oeufs de Pâques"
	holidayID = EASTER
	typepath = /datum/round_event/easter
	weight = -1
	max_occurrences = 1
	earliest_start = 0 MINUTES
	category = EVENT_CATEGORY_HOLIDAY
	description = "Cache des oeufs rempli de surprise dans les maintenances."

/datum/round_event/easter/announce(fake)
	priority_announce(pick("La chasse aux oeufs est lancée !","Celui qui gagne récupère un chapeau de paille!","Aujourd'hui est le jour interespèce de la chasse aux oeufs.","Soyez sympa avec eux, donnez leur un oeuf !"))


/datum/round_event_control/rabbitrelease
	name = "Libérez les lapins!"
	holidayID = EASTER
	typepath = /datum/round_event/rabbitrelease
	weight = 5
	max_occurrences = 10
	category = EVENT_CATEGORY_HOLIDAY
	description = "Invoque une vague de lapins tout mignons."

/datum/round_event/rabbitrelease/announce(fake)
	priority_announce("Objets pelucheux non-identités detectés à bord de [station_name()]. Attention aux crises de mignonitude.", "Alerte pelucheuse", ANNOUNCER_ALIENS)


/datum/round_event/rabbitrelease/start()
	for(var/obj/effect/landmark/R in GLOB.landmarks_list)
		if(R.name != "blobspawn")
			if(prob(35))
				if(isspaceturf(R.loc))
					new /mob/living/basic/rabbit/easter/space(R.loc)
				else
					new /mob/living/basic/rabbit/easter(R.loc)

//Easter Baskets
/obj/item/storage/basket/easter
	name = "panier à oeufs"

/obj/item/storage/basket/easter/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(list(/obj/item/food/egg, /obj/item/food/chocolateegg, /obj/item/food/boiledegg, /obj/item/surprise_egg))

/obj/item/storage/basket/easter/proc/countEggs()
	cut_overlays()
	add_overlay("basket-grass")
	add_overlay("basket-egg[min(contents.len, 5)]")

/obj/item/storage/basket/easter/Exited(atom/movable/gone, direction)
	. = ..()
	countEggs()

/obj/item/storage/basket/easter/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	countEggs()

//Bunny Suit
/obj/item/clothing/head/costume/bunnyhead
	name = "tête de costume de lapin de pâques"
	icon_state = "bunnyhead"
	inhand_icon_state = null
	desc = "Ces petites oreilles vont vous faire gagner ce concours de mignonitude."
	slowdown = -0.3
	clothing_flags = THICKMATERIAL | SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/suit/costume/bunnysuit
	name = "costume de lapin de pâques"
	desc = "Hop Hop Hop !"
	icon_state = "bunnysuit"
	icon = 'icons/obj/clothing/suits/costume.dmi'
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	inhand_icon_state = null
	slowdown = -0.3
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

//Bunny bag!
/obj/item/storage/backpack/satchel/bunnysatchel
	name = "sacoque de lapin de pâques"
	desc = "Bon pour vos yeux."
	icon_state = "satchel_carrot"
	inhand_icon_state = null

//Egg prizes and egg spawns!
/obj/item/surprise_egg
	name = "oeuf surprise"
	desc = "Un oeuf en chocolat contenant un petit quelque chose. Déballez le et amusez-vous !"
	icon_state = "egg"
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/food/egg.dmi'
	lefthand_file = 'icons/mob/inhands/items/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/food_righthand.dmi'
	obj_flags = UNIQUE_RENAME

/obj/item/surprise_egg/Initialize(mapload)
	. = ..()
	var/eggcolor = pick("blue","green","mime","orange","purple","rainbow","red","yellow")
	icon_state = "egg-[eggcolor]"

/obj/item/surprise_egg/proc/dispensePrize(turf/where)
	var/static/list/prize_list = list(/obj/item/clothing/head/costume/bunnyhead,
		/obj/item/clothing/suit/costume/bunnysuit,
		/obj/item/storage/backpack/satchel/bunnysatchel,
		/obj/item/food/grown/carrot,
		/obj/item/toy/balloon,
		/obj/item/toy/gun,
		/obj/item/toy/sword,
		/obj/item/toy/talking/ai,
		/obj/item/toy/talking/owl,
		/obj/item/toy/talking/griffin,
		/obj/item/toy/minimeteor,
		/obj/item/toy/clockwork_watch,
		/obj/item/toy/toy_xeno,
		/obj/item/toy/foamblade,
		/obj/item/toy/plush/carpplushie,
		/obj/item/toy/redbutton,
		/obj/item/toy/windup_toolbox,
		/obj/item/clothing/head/collectable/rabbitears
		) + subtypesof(/obj/item/toy/mecha)
	var/won = pick(prize_list)
	new won(where)
	new/obj/item/food/chocolateegg(where)

/obj/item/surprise_egg/attack_self(mob/user)
	..()
	to_chat(user, span_notice("Vous déballez l'[src] et trouvez un prix à l'intérieur !"))
	dispensePrize(get_turf(src))
	qdel(src)

//Easter Recipes + food
/obj/item/food/hotcrossbun
	name = "petits pains anglais de pâques"
	desc = "La croix représente les assistants morts pour vos péchés."
	icon_state = "hotcrossbun"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/sugar = 1)
	foodtypes = SUGAR | GRAIN | BREAKFAST
	tastes = list("de patisserie" = 1, "de sucre" = 1)
	bite_consumption = 2

/datum/crafting_recipe/food/hotcrossbun
	name = "petits pains anglais de pâques"
	reqs = list(
		/obj/item/food/breadslice/plain = 1,
		/datum/reagent/consumable/sugar = 1
	)
	result = /obj/item/food/hotcrossbun

	category = CAT_BREAD

/datum/crafting_recipe/food/briochecake
	name = "brioche"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/cake/brioche
	category = CAT_MISCFOOD

/obj/item/food/scotchegg
	name = "scotch egg"
	desc = "Un oeuf cuit, enveloppé de viande hachée assaisonnée."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "scotchegg"
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)

/datum/crafting_recipe/food/scotchegg
	name = "scotch egg"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/blackpepper = 1,
		/obj/item/food/boiledegg = 1,
		/obj/item/food/meatball = 1
	)
	result = /obj/item/food/scotchegg
	category = CAT_EGG

/datum/crafting_recipe/food/mammi
	name = "mammi"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/milk = 5
	)
	result = /obj/item/food/bowled/mammi
	category = CAT_MISCFOOD

/obj/item/food/chocolatebunny
	name = "lapin en chocolat"
	desc = "Contient moins de 10% de lapin !"
	icon_state = "chocolatebunny"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/coco = 2, /datum/reagent/consumable/nutriment/vitamin = 1)

/datum/crafting_recipe/food/chocolatebunny
	name = "lapin en chocolat"
	reqs = list(
		/datum/reagent/consumable/sugar = 2,
		/obj/item/food/chocolatebar = 1
	)
	result = /obj/item/food/chocolatebunny
	category = CAT_MISCFOOD
