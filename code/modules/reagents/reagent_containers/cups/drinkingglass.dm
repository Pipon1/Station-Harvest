/obj/item/reagent_containers/cup/glass/drinkingglass
	name = "Verre à boire"
	desc = "Un verre à boire tout ce qu'il y'a de plus standard."
	icon_state = "glass_empty"
	base_icon_state = "glass_empty"
	amount_per_transfer_from_this = 10
	fill_icon_thresholds = list(0)
	fill_icon_state = "drinking_glass"
	volume = 50
	custom_materials = list(/datum/material/glass=500)
	max_integrity = 20
	spillable = TRUE
	resistance_flags = ACID_PROOF
	obj_flags = UNIQUE_RENAME
	drop_sound = 'sound/items/handling/drinkglass_drop.ogg'
	pickup_sound = 'sound/items/handling/drinkglass_pickup.ogg'
	custom_price = PAYCHECK_LOWER
	//the screwdriver cocktail can make a drinking glass into the world's worst screwdriver. beautiful.
	toolspeed = 25

	/// The type to compare to glass_style.required_container type, or null to use class type.
	/// This allows subtypes to utilize parent styles.
	var/base_container_type = null

/obj/item/reagent_containers/cup/glass/drinkingglass/Initialize(mapload, vol)
	. = ..()
	AddComponent( \
		/datum/component/takes_reagent_appearance, \
		CALLBACK(src, PROC_REF(on_cup_change)), \
		CALLBACK(src, PROC_REF(on_cup_reset)), \
		base_container_type = base_container_type, \
	)

/obj/item/reagent_containers/cup/glass/drinkingglass/on_reagent_change(datum/reagents/holder, ...)
	. = ..()
	if(!length(reagents.reagent_list))
		renamedByPlayer = FALSE //so new drinks can rename the glass

// Having our icon state change removes fill thresholds
/obj/item/reagent_containers/cup/glass/drinkingglass/on_cup_change(datum/glass_style/style)
	. = ..()
	fill_icon_thresholds = null

// And having our icon reset restores our fill thresholds
/obj/item/reagent_containers/cup/glass/drinkingglass/on_cup_reset()
	. = ..()
	fill_icon_thresholds ||= list(0)

//Shot glasses!//
//  This lets us add shots in here instead of lumping them in with drinks because >logic  //
//  The format for shots is the exact same as iconstates for the drinking glass, except you use a shot glass instead.  //
//  If it's a new drink, remember to add it to Chemistry-Reagents.dm  and Chemistry-Recipes.dm as well.  //
//  You can only mix the ported-over drinks in shot glasses for now (they'll mix in a shaker, but the sprite won't change for glasses). //
//  This is on a case-by-case basis, and you can even make a separate sprite for shot glasses if you want. //

/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass
	name = "Verre à shot"
	desc = "Un verre à shot - Le symbole universel des mauvaises décisions."
	icon = 'icons/obj/drinks/shot_glasses.dmi'
	icon_state = "shotglass"
	base_icon_state = "shotglass"
	gulp_size = 15
	amount_per_transfer_from_this = 15
	possible_transfer_amounts = list(15)
	fill_icon_state = "shot_glass"
	volume = 15
	custom_materials = list(/datum/material/glass=100)
	custom_price = PAYCHECK_CREW * 0.4

/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass/update_name(updates)
	if(renamedByPlayer)
		return
	. = ..()
	name = "[length(reagents.reagent_list) ? "remplie " : ""]verre à shot"

/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass/update_desc(updates)
	if(renamedByPlayer)
		return
	. = ..()
	if(length(reagents.reagent_list))
		desc = "Le défis est d'en boire autant que vous pouvez, mais vous devez deviner ce que c'est avant de vous évanouir."
	else
		desc = "Un verre à shot - Le symbole universel des mauvaises décisions."

/obj/item/reagent_containers/cup/glass/drinkingglass/filled
	base_container_type = /obj/item/reagent_containers/cup/glass/drinkingglass

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/Initialize(mapload, vol)
	. = ..()
	update_appearance()

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/soda
	name = "Eau gazeuse"
	list_reagents = list(/datum/reagent/consumable/sodawater = 50)

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/cola
	name = "Cola de l'espace"
	list_reagents = list(/datum/reagent/consumable/space_cola = 50)

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/nuka_cola
	name = "Nuka Cola"
	list_reagents = list(/datum/reagent/consumable/nuka_cola = 50)
