
////////////////////////////////////////////EGGS////////////////////////////////////////////

/obj/item/food/chocolateegg
	name = "Oeuf en chocolat"
	desc = "Tellement gras et sucré."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "chocolateegg"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/coco = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("de chocolat" = 4, "de sucre" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/// Counter for number of chicks hatched by throwing eggs, minecraft style. Chicks will not emerge from thrown eggs if this value exceeds the MAX_CHICKENS define.
GLOBAL_VAR_INIT(chicks_from_eggs, 0)

/obj/item/food/egg
	name = "Oeuf"
	desc = "Un oeuf !"
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "egg"
	inhand_icon_state = "egg"
	food_reagents = list(/datum/reagent/consumable/eggyolk = 2, /datum/reagent/consumable/eggwhite = 4)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_TINY
	ant_attracting = FALSE
	decomp_type = /obj/item/food/egg/rotten
	decomp_req_handle = TRUE //so laid eggs can actually become chickens
	var/chick_throw_prob = 13

/obj/item/food/egg/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/boiledegg, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/egg/make_microwaveable()
	AddElement(/datum/element/microwavable, /obj/item/food/boiledegg)

/obj/item/food/egg/rotten
	food_reagents = list(/datum/reagent/consumable/eggrot = 10, /datum/reagent/consumable/mold = 10)
	foodtypes = GROSS
	preserved_food = TRUE

/obj/item/food/egg/rotten/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/boiledegg/rotten, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/egg/rotten/make_microwaveable()
	AddElement(/datum/element/microwavable, /obj/item/food/boiledegg/rotten)

/obj/item/food/egg/gland
	desc = "Un oeuf ! Il a l'air bizarre..."

/obj/item/food/egg/gland/Initialize(mapload)
	. = ..()
	reagents.add_reagent(get_random_reagent_id(), 15)

	var/color = mix_color_from_reagents(reagents.reagent_list)
	add_atom_colour(color, FIXED_COLOUR_PRIORITY)

/obj/item/food/egg/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if (..()) // was it caught by a mob?
		return

	var/turf/hit_turf = get_turf(hit_atom)
	new /obj/effect/decal/cleanable/food/egg_smudge(hit_turf)
	//Chicken code uses this MAX_CHICKENS variable, so I figured that I'd use it again here. Even this check and the check in chicken code both use the MAX_CHICKENS variable, they use independent counter variables and thus are independent of each other.
	if(GLOB.chicks_from_eggs < MAX_CHICKENS) //Roughly a 1/8 (12.5%) chance to make a chick, as in Minecraft, with a 1/256 (~0.39%) chance to make four chicks instead.
		var/chance = rand(0, 255)
		switch(chance)
			if(0 to 30)
				new /mob/living/simple_animal/chick(hit_turf)
				GLOB.chicks_from_eggs++
				visible_message(span_notice("Un poussin est sorti de l'oeuf !"))
			if(31)
				var/spawned_chickens = min(4, MAX_CHICKENS - GLOB.chicks_from_eggs) // We don't want to go over the limit
				visible_message(span_notice("[spawned_chickens] poussins sont sortis de l'oeuf ! Jackpot !"))
				for(var/i in 1 to spawned_chickens)
					new /mob/living/simple_animal/chick(hit_turf)
					GLOB.chicks_from_eggs++

	reagents.expose(hit_atom, TOUCH)
	qdel(src)

/obj/item/food/egg/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/toy/crayon))
		var/obj/item/toy/crayon/crayon = item
		var/clr = crayon.crayon_color

		if(!(clr in list("blue", "green", "mime", "orange", "purple", "rainbow", "red", "yellow")))
			to_chat(usr, span_notice("[src] refuse de se laisser colorer avec cette couleur !"))
			return

		to_chat(usr, span_notice("Vous colorez l'[src] avec le [item]."))
		icon_state = "egg-[clr]"

	else if(istype(item, /obj/item/stamp/clown))
		var/clowntype = pick("grock", "grimaldi", "rainbow", "chaos", "joker", "sexy", "standard", "bobble",
			"krusty", "bozo", "pennywise", "ronald", "jacobs", "kelly", "popov", "cluwne")
		icon_state = "egg-clown-[clowntype]"
		desc = "Un oeuf a été décoré avec un grotesque visage de clown. "
		to_chat(usr, span_notice("Vous décorez l'[src] avec le [item] et créez un maquillage artistique (et pas du tout horrifiant) de clown."))

	else if(is_reagent_container(item))
		var/obj/item/reagent_containers/dunk_test_container = item
		if (!dunk_test_container.is_drainable() || !dunk_test_container.reagents.has_reagent(/datum/reagent/water))
			return

		to_chat(user, span_notice("Vous vérifiez que l'[src] n'est pas périmé."))
		if(istype(src, /obj/item/food/egg/rotten))
			to_chat(user, span_warning("L'[src] flotte dans le [dunk_test_container]!"))
		else
			to_chat(user, span_notice("L'[src] coule dans le [dunk_test_container]!"))
	else
		..()

/obj/item/food/egg/afterattack_secondary(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(!istype(target, /obj/machinery/griddle))
		return SECONDARY_ATTACK_CALL_NORMAL

	var/atom/broken_egg = new /obj/item/food/rawegg(target.loc)
	broken_egg.pixel_x = pixel_x
	broken_egg.pixel_y = pixel_y
	playsound(get_turf(user), 'sound/items/sheath.ogg', 40, TRUE)
	reagents.copy_to(broken_egg,reagents.total_volume)

	var/obj/machinery/griddle/hit_griddle = target
	hit_griddle.AddToGrill(broken_egg, user)
	target.balloon_alert(user, "cracks [src] open")

	qdel(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/food/egg/blue
	icon_state = "egg-blue"
	inhand_icon_state = "egg-blue"
/obj/item/food/egg/green
	icon_state = "egg-green"
	inhand_icon_state = "egg-green"
/obj/item/food/egg/mime
	icon_state = "egg-mime"
	inhand_icon_state = "egg-mime"
/obj/item/food/egg/orange
	icon_state = "egg-orange"
	inhand_icon_state = "egg-orange"

/obj/item/food/egg/purple
	icon_state = "egg-purple"
	inhand_icon_state = "egg-purple"

/obj/item/food/egg/rainbow
	icon_state = "egg-rainbow"
	inhand_icon_state = "egg-rainbow"

/obj/item/food/egg/red
	icon_state = "egg-red"
	inhand_icon_state = "egg-red"

/obj/item/food/egg/yellow
	icon_state = "egg-yellow"
	inhand_icon_state = "egg-yellow"

/obj/item/food/egg/fertile
	name = "Oeuf fertilisé"
	desc = "Un oeuf ! Il a l'air fertilisé.\nLa façon dont vous pouvez le dire juste en le regardant est un mystère."
	chick_throw_prob = 100

/obj/item/food/egg/fertile/Initialize(mapload, loc)
	. = ..()

	AddComponent(/datum/component/fertile_egg,\
		embryo_type = /mob/living/simple_animal/chick,\
		minimum_growth_rate = 1,\
		maximum_growth_rate = 2,\
		total_growth_required = 200,\
		current_growth = 0,\
		location_allowlist = typecacheof(list(/turf)),\
		spoilable = FALSE,\
	)

/obj/item/food/friedegg
	name = "Oeuf frit"
	desc = "Un oeuf frit. Se marie bien avec du sel et du poivre."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "friedegg"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/eggyolk = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	bite_consumption = 1
	tastes = list("d'oeuf" = 4)
	foodtypes = MEAT | FRIED | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/rawegg
	name = "Oeuf cru"
	desc = "Supposément bon pour vous, si votre estomac peut le supporter. Meilleur frit."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "rawegg"
	food_reagents = list() //Recieves all reagents from its whole egg counterpart
	bite_consumption = 1
	tastes = list("d'oeuf cru" = 6, "de viscosité" = 1)
	eatverbs = list("gulp down")
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/rawegg/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/friedegg, rand(20 SECONDS, 35 SECONDS), TRUE, FALSE)

/obj/item/food/boiledegg
	name = "Oeuf dur"
	desc = "Un oeuf dur."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "egg"
	inhand_icon_state = "egg"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("d'oeuf" = 1)
	foodtypes = MEAT | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	ant_attracting = FALSE
	decomp_type = /obj/item/food/boiledegg/rotten

/obj/item/food/eggsausage
	name = "Oeuf avec une saucisse"
	desc = "Un bon oeuf accompagné d'une saucisse."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "eggsausage"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/nutriment = 4)
	foodtypes = MEAT | FRIED | BREAKFAST
	tastes = list("d'oeuf" = 4, "de viande" = 4)
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/boiledegg/rotten
	food_reagents = list(/datum/reagent/consumable/eggrot = 10)
	tastes = list("d'oeuf pourri" = 1)
	foodtypes = GROSS
	preserved_food = TRUE

/obj/item/food/omelette //FUCK THIS
	name = "Omelette au fromage"
	desc = "C'est tout ce que tu sais dire !"
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "omelette"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	bite_consumption = 1
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("d'oeuf" = 1, "de fromage" = 1)
	foodtypes = MEAT | BREAKFAST | DAIRY
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/omelette/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/kitchen/fork))
		var/obj/item/kitchen/fork/fork = item
		if(fork.forkload)
			to_chat(user, span_warning("Vous avez déjà une omellette sur votre fourchette !"))
		else
			fork.icon_state = "forkloaded"
			user.visible_message(span_notice("[user] prend un morceau d'omelette avec la fourchette de [user.p_their()] !"), \
				span_notice("Vous prenez un morceau d'omelette avec votre fourchette."))

			var/datum/reagent/reagent = pick(reagents.reagent_list)
			reagents.remove_reagent(reagent.type, 1)
			fork.forkload = reagent
			if(reagents.total_volume <= 0)
				qdel(src)
		return
	..()

/obj/item/food/benedict
	name = "Oeuf bénédicte"
	desc = "Il y a seulement un oeuf, quelle déception."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "benedict"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment = 3,
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("d'oeuf" = 1, "de bacon" = 1, "de petit pain" = 1)
	foodtypes = MEAT | BREAKFAST | GRAIN
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/eggwrap
	name = "Wrap d'oeuf"
	desc = "Le précurseur des cochons dans des couvertures." //OUI la traduction littérale est fait exprès
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "eggwrap"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("d'oeuf" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/chawanmushi
	name = "Chawanmushi"
	desc = "Une crème aux œufs légendaire qui fait des amis des ennemis. Probablement trop chaude pour qu'un chat la mange."
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "chawanmushi"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de crème aux oeufs" = 1)
	foodtypes = MEAT | VEGETABLES
