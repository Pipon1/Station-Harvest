/* Tables and Racks
 * Contains:
 * Tables
 * Glass Tables
 * Wooden Tables
 * Reinforced Tables
 * Racks
 * Rack Parts
 */

/*
 * Tables
 */

/obj/structure/table
	name = "table"
	desc = "Une pièce rectangulaire de fer tenant debout avec 4 pieds. Elle ne peut pas bouger."
	icon = 'icons/obj/smooth_structures/table.dmi'
	icon_state = "table-0"
	base_icon_state = "table"
	density = TRUE
	anchored = TRUE
	pass_flags_self = PASSTABLE | LETPASSTHROW
	layer = TABLE_LAYER
	obj_flags = CAN_BE_HIT | IGNORE_DENSITY
	var/frame = /obj/structure/table_frame
	var/framestack = /obj/item/stack/rods
	var/glass_shard_type = /obj/item/shard
	var/buildstack = /obj/item/stack/sheet/iron
	var/busy = FALSE
	var/buildstackamount = 1
	var/framestackamount = 2
	var/deconstruction_ready = 1
	custom_materials = list(/datum/material/iron = 2000)
	max_integrity = 100
	integrity_failure = 0.33
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TABLES
	canSmoothWith = SMOOTH_GROUP_TABLES

/obj/structure/table/Initialize(mapload, _buildstack)
	. = ..()
	if(_buildstack)
		buildstack = _buildstack
	AddElement(/datum/element/climbable)

	var/static/list/loc_connections = list(
		COMSIG_CARBON_DISARM_COLLIDE = PROC_REF(table_carbon),
	)

	AddElement(/datum/element/connect_loc, loc_connections)
	register_context()

/obj/structure/table/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if(isnull(held_item))
		return NONE

	if(istype(held_item, /obj/item/toy/cards/deck))
		var/obj/item/toy/cards/deck/dealer_deck = held_item
		if(dealer_deck.wielded)
			context[SCREENTIP_CONTEXT_LMB] = "Distribuer les cartes"
			context[SCREENTIP_CONTEXT_RMB] = "Distribuer les cartes face contre le haut"
			. = CONTEXTUAL_SCREENTIP_SET

	if(!(flags_1 & NODECONSTRUCT_1) && deconstruction_ready)
		if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
			context[SCREENTIP_CONTEXT_RMB] = "Désassembler"
			. = CONTEXTUAL_SCREENTIP_SET
		if(held_item.tool_behaviour == TOOL_WRENCH)
			context[SCREENTIP_CONTEXT_RMB] = "Déconstruire"
			. = CONTEXTUAL_SCREENTIP_SET

	return . || NONE

/obj/structure/table/examine(mob/user)
	. = ..()
	. += deconstruction_hints(user)

/obj/structure/table/proc/deconstruction_hints(mob/user)
	return span_notice("Le dessus est <b>vissé</b>, mais les <b>écrous</b> principaux sont visible.")

/obj/structure/table/update_icon(updates=ALL)
	. = ..()
	if((updates & UPDATE_SMOOTHING) && (smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK)))
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

/obj/structure/table/narsie_act()
	var/atom/A = loc
	qdel(src)
	new /obj/structure/table/wood(A)

/obj/structure/table/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/table/attack_hand(mob/living/user, list/modifiers)
	if(Adjacent(user) && user.pulling)
		if(isliving(user.pulling))
			var/mob/living/pushed_mob = user.pulling
			if(pushed_mob.buckled)
				to_chat(user, span_warning("[pushed_mob] est attaché sur la [pushed_mob.buckled] !"))
				return
			if(user.combat_mode)
				switch(user.grab_state)
					if(GRAB_PASSIVE)
						to_chat(user, span_warning("Vous avez besoin de mieux tenir !"))
						return
					if(GRAB_AGGRESSIVE)
						tablepush(user, pushed_mob)
					if(GRAB_NECK to GRAB_KILL)
						tablelimbsmash(user, pushed_mob)
			else
				pushed_mob.visible_message(span_notice("[user] commence à placer [pushed_mob] sur la [src]..."), \
									span_userdanger("[user] commencer à placer [pushed_mob] sur la [src]..."))
				if(do_after(user, 3.5 SECONDS, target = pushed_mob))
					tableplace(user, pushed_mob)
				else
					return
			user.stop_pulling()
		else if(user.pulling.pass_flags & PASSTABLE)
			user.Move_Pulled(src)
			if (user.pulling.loc == loc)
				user.visible_message(span_notice("[user] place [user.pulling] sur la [src]."),
					span_notice("Vous placez [user.pulling] sur la [src]."))
				user.stop_pulling()
	return ..()

/obj/structure/table/attack_tk(mob/user)
	return

/obj/structure/table/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return
	if(mover.throwing)
		return TRUE
	if(locate(/obj/structure/table) in get_turf(mover))
		return TRUE

/obj/structure/table/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller, no_id = FALSE)
	. = !density
	if(caller)
		. = . || (caller.pass_flags & PASSTABLE)

/obj/structure/table/proc/tableplace(mob/living/user, mob/living/pushed_mob)
	pushed_mob.forceMove(loc)
	pushed_mob.set_resting(TRUE, TRUE)
	pushed_mob.visible_message(span_notice("[user] place [pushed_mob] sur la [src]."), \
								span_notice("[user] place [pushed_mob] sur la [src]."))
	log_combat(user, pushed_mob, "places", null, "onto [src]")

/obj/structure/table/proc/tablepush(mob/living/user, mob/living/pushed_mob)
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_danger("Lancer [pushed_mob] sur la table pourrait les blesser !"))
		return
	var/added_passtable = FALSE
	if(!(pushed_mob.pass_flags & PASSTABLE))
		added_passtable = TRUE
		pushed_mob.pass_flags |= PASSTABLE
	for (var/obj/obj in user.loc.contents)
		if(!obj.CanAllowThrough(pushed_mob))
			return
	pushed_mob.Move(src.loc)
	if(added_passtable)
		pushed_mob.pass_flags &= ~PASSTABLE
	if(pushed_mob.loc != loc) //Something prevented the tabling
		return
	pushed_mob.Knockdown(30)
	pushed_mob.apply_damage(10, BRUTE)
	pushed_mob.apply_damage(40, STAMINA)
	if(user.mind?.martial_art.smashes_tables && user.mind?.martial_art.can_use(user))
		deconstruct(FALSE)
	playsound(pushed_mob, 'sound/effects/tableslam.ogg', 90, TRUE)
	pushed_mob.visible_message(span_danger("[user] pousse violemment [pushed_mob] sur la [src] !"), \
								span_userdanger("[user] vous pousse violemment sur la [src] !"))
	log_combat(user, pushed_mob, "tabled", null, "onto [src]")
	pushed_mob.add_mood_event("table", /datum/mood_event/table)

/obj/structure/table/proc/tablelimbsmash(mob/living/user, mob/living/pushed_mob)
	pushed_mob.Knockdown(30)
	var/obj/item/bodypart/banged_limb = pushed_mob.get_bodypart(user.zone_selected) || pushed_mob.get_bodypart(BODY_ZONE_HEAD)
	var/extra_wound = 0
	if(HAS_TRAIT(user, TRAIT_HULK))
		extra_wound = 20
	banged_limb?.receive_damage(30, wound_bonus = extra_wound)
	pushed_mob.apply_damage(60, STAMINA)
	take_damage(50)
	if(user.mind?.martial_art.smashes_tables && user.mind?.martial_art.can_use(user))
		deconstruct(FALSE)
	playsound(pushed_mob, 'sound/effects/bang.ogg', 90, TRUE)
	pushed_mob.visible_message(span_danger("[user] fracasse le/la [banged_limb.plaintext_zone] de [pushed_mob] sur la [src] !"),
								span_userdanger("[user] fracasse votre [banged_limb.plaintext_zone] sur la [src]"))
	log_combat(user, pushed_mob, "head slammed", null, "against [src]")
	pushed_mob.add_mood_event("table", /datum/mood_event/table_limbsmash, banged_limb)

/obj/structure/table/screwdriver_act_secondary(mob/living/user, obj/item/tool)
	if(flags_1 & NODECONSTRUCT_1 || !deconstruction_ready)
		return FALSE
	to_chat(user, span_notice("Vous commencez à désassembler la [src]..."))
	if(tool.use_tool(src, user, 2 SECONDS, volume=50))
		deconstruct(TRUE)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/table/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(flags_1 & NODECONSTRUCT_1 || !deconstruction_ready)
		return FALSE
	to_chat(user, span_notice("Vous commencez à déconstruire la [src]..."))
	if(tool.use_tool(src, user, 4 SECONDS, volume=50))
		playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		deconstruct(TRUE, 1)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/table/attackby(obj/item/I, mob/living/user, params)
	var/list/modifiers = params2list(params)

	if(istype(I, /obj/item/storage/bag/tray))
		var/obj/item/storage/bag/tray/T = I
		if(T.contents.len > 0) // If the tray isn't empty
			for(var/x in T.contents)
				var/obj/item/item = x
				AfterPutItemOnTable(item, user)
			I.atom_storage.remove_all(drop_location())
			user.visible_message(span_notice("[user] vide [I] sur la [src]."))
			return
		// If the tray IS empty, continue on (tray will be placed on the table like other items)

	if(istype(I, /obj/item/toy/cards/deck))
		var/obj/item/toy/cards/deck/dealer_deck = I
		if(dealer_deck.wielded) // deal a card facedown on the table
			var/obj/item/toy/singlecard/card = dealer_deck.draw(user)
			if(card)
				attackby(card, user, params)
			return

	if(istype(I, /obj/item/riding_offhand))
		var/obj/item/riding_offhand/riding_item = I
		var/mob/living/carried_mob = riding_item.rider
		if(carried_mob == user) //Piggyback user.
			return
		if(user.combat_mode)
			user.unbuckle_mob(carried_mob)
			tablelimbsmash(user, carried_mob)
		else
			var/tableplace_delay = 3.5 SECONDS
			var/skills_space = ""
			if(HAS_TRAIT(user, TRAIT_QUICKER_CARRY))
				tableplace_delay = 2 SECONDS
				skills_space = " avec expertise"
			else if(HAS_TRAIT(user, TRAIT_QUICK_CARRY))
				tableplace_delay = 2.75 SECONDS
				skills_space = " rapidement"
			carried_mob.visible_message(span_notice("[user] commence a placer [carried_mob][skills_space] sur la [src]..."),
				span_userdanger("[user] commence a placer [carried_mob][skills_space] sur la [src]..."))
			if(do_after(user, tableplace_delay, target = carried_mob))
				user.unbuckle_mob(carried_mob)
				tableplace(user, carried_mob)
		return TRUE

	if(!user.combat_mode && !(I.item_flags & ABSTRACT))
		if(user.transferItemToLoc(I, drop_location(), silent = FALSE))
			//Center the icon where the user clicked.
			if(!LAZYACCESS(modifiers, ICON_X) || !LAZYACCESS(modifiers, ICON_Y))
				return
			//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
			I.pixel_x = clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -(world.icon_size/2), world.icon_size/2)
			I.pixel_y = clamp(text2num(LAZYACCESS(modifiers, ICON_Y)) - 16, -(world.icon_size/2), world.icon_size/2)
			AfterPutItemOnTable(I, user)
			return TRUE
	else
		return ..()

/obj/structure/table/attackby_secondary(obj/item/weapon, mob/user, params)
	if(istype(weapon, /obj/item/toy/cards/deck))
		var/obj/item/toy/cards/deck/dealer_deck = weapon
		if(dealer_deck.wielded) // deal a card faceup on the table
			var/obj/item/toy/singlecard/card = dealer_deck.draw(user)
			if(card)
				card.Flip()
				attackby(card, user, params)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	..()
	return SECONDARY_ATTACK_CONTINUE_CHAIN

/obj/structure/table/proc/AfterPutItemOnTable(obj/item/I, mob/living/user)
	return

/obj/structure/table/deconstruct(disassembled = TRUE, wrench_disassembly = 0)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/turf/T = get_turf(src)
		if(buildstack)
			new buildstack(T, buildstackamount)
		else
			for(var/i in custom_materials)
				var/datum/material/M = i
				new M.sheet_type(T, FLOOR(custom_materials[M] / MINERAL_MATERIAL_AMOUNT, 1))
		if(!wrench_disassembly)
			new frame(T)
		else
			new framestack(T, framestackamount)
	qdel(src)

/obj/structure/table/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 24, "cost" = 16)
	return FALSE

/obj/structure/table/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("Vous déconstruisez la table."))
			qdel(src)
			return TRUE
	return FALSE

/obj/structure/table/proc/table_carbon(datum/source, mob/living/carbon/shover, mob/living/carbon/target, shove_blocked)
	SIGNAL_HANDLER
	if(!shove_blocked)
		return
	target.Knockdown(SHOVE_KNOCKDOWN_TABLE)
	target.visible_message(span_danger("[shover.name] pousse [target.name] sur la [src] !"),
		span_userdanger("Vous êtes poussé sur la [src] par [shover.name] !"), span_hear("Vous entendez un bruit de bagarre suivit d'un gros \"BOUM\" !"), COMBAT_MESSAGE_RANGE, src)
	to_chat(shover, span_danger("You shove [target.name] onto \the [src]!"))
	target.throw_at(src, 1, 1, null, FALSE) //1 speed throws with no spin are basically just forcemoves with a hard collision check
	log_combat(src, target, "shoved", "onto [src] (table)")
	return COMSIG_CARBON_SHOVE_HANDLED

/obj/structure/table/greyscale
	icon = 'icons/obj/smooth_structures/table_greyscale.dmi'
	icon_state = "table_greyscale-0"
	base_icon_state = "table_greyscale"
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	buildstack = null //No buildstack, so generate from mat datums

/obj/structure/table/greyscale/set_custom_materials(list/materials, multiplier)
	. = ..()
	var/list/materials_list = list()
	for(var/custom_material in custom_materials)
		var/datum/material/current_material = GET_MATERIAL_REF(custom_material)
		materials_list += "[current_material.name]"
	desc = "Une [(materials_list.len > 1) ? "amalgamation" : "pièce"] réctangulaire de [english_list(materials_list)] sur quatre pieds. Elle ne peut pas bouger."

///Table on wheels
/obj/structure/table/rolling
	name = "table roulante"
	desc = "Une table roulante \"Roullante Bougeante\"de marque NT. Elle peut bouger et elle le fera."
	anchored = FALSE
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null
	icon = 'icons/obj/smooth_structures/rollingtable.dmi'
	icon_state = "rollingtable"
	var/list/attached_items = list()

/obj/structure/table/rolling/AfterPutItemOnTable(obj/item/I, mob/living/user)
	. = ..()
	attached_items += I
	RegisterSignal(I, COMSIG_MOVABLE_MOVED, PROC_REF(RemoveItemFromTable)) //Listen for the pickup event, unregister on pick-up so we aren't moved

/obj/structure/table/rolling/proc/RemoveItemFromTable(datum/source, newloc, dir)
	SIGNAL_HANDLER

	if(newloc != loc) //Did we not move with the table? because that shit's ok
		return FALSE
	attached_items -= source
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)

/obj/structure/table/rolling/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(!loc)
		return
	for(var/mob/living/living_mob in old_loc.contents)//Kidnap everyone on top
		living_mob.forceMove(loc)
	for(var/atom/movable/attached_movable as anything in attached_items)
		if(!attached_movable.Move(loc))
			RemoveItemFromTable(attached_movable, attached_movable.loc)

/obj/structure/table/rolling/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(has_gravity())
		playsound(src, 'sound/effects/roll.ogg', 100, TRUE)
/*
 * Glass tables
 */
/obj/structure/table/glass
	name = "table en verre"
	desc = "Qu'est-ce que j'ai dit à propos de s'appuyer sur des tables en verre ? Maintenant t'as besoin de passer sur une table de chirugien..."
	icon = 'icons/obj/smooth_structures/glass_table.dmi'
	icon_state = "glass_table-0"
	base_icon_state = "glass_table"
	custom_materials = list(/datum/material/glass = 2000)
	buildstack = /obj/item/stack/sheet/glass
	smoothing_groups = SMOOTH_GROUP_GLASS_TABLES
	canSmoothWith = SMOOTH_GROUP_GLASS_TABLES
	max_integrity = 70
	resistance_flags = ACID_PROOF
	armor_type = /datum/armor/table_glass

/datum/armor/table_glass
	fire = 80
	acid = 100

/obj/structure/table/glass/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/table/glass/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(flags_1 & NODECONSTRUCT_1)
		return
	if(!isliving(AM))
		return
	// Don't break if they're just flying past
	if(AM.throwing)
		addtimer(CALLBACK(src, PROC_REF(throw_check), AM), 5)
	else
		check_break(AM)

/obj/structure/table/glass/proc/throw_check(mob/living/M)
	if(M.loc == get_turf(src))
		check_break(M)

/obj/structure/table/glass/proc/check_break(mob/living/M)
	if(M.has_gravity() && M.mob_size > MOB_SIZE_SMALL && !(M.movement_type & FLYING))
		table_shatter(M)

/obj/structure/table/glass/proc/table_shatter(mob/living/victim)
	visible_message(span_warning("[src] se brise !"),
		span_danger("Vous entendez du verre se briser."))

	playsound(loc, SFX_SHATTER, 50, TRUE)

	new frame(loc)

	var/obj/item/shard/shard = new glass_shard_type(loc)
	shard.throw_impact(victim)

	victim.Paralyze(100)
	qdel(src)

/obj/structure/table/glass/deconstruct(disassembled = TRUE, wrench_disassembly = 0)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(disassembled)
			..()
			return
		else
			var/turf/T = get_turf(src)
			playsound(T, SFX_SHATTER, 50, TRUE)

			new frame(loc)
			new glass_shard_type(loc)

	qdel(src)

/obj/structure/table/glass/narsie_act()
	color = NARSIE_WINDOW_COLOUR

/obj/structure/table/glass/plasmaglass
	name = "table en verre de plasma"
	desc = "Quelqu'un a pensé que c'était une bonne idée."
	icon = 'icons/obj/smooth_structures/plasmaglass_table.dmi'
	icon_state = "plasmaglass_table-0"
	base_icon_state = "plasmaglass_table"
	custom_materials = list(/datum/material/alloy/plasmaglass = 2000)
	buildstack = /obj/item/stack/sheet/plasmaglass
	glass_shard_type = /obj/item/shard/plasma
	max_integrity = 100

/*
 * Wooden tables
 */

/obj/structure/table/wood
	name = "table en bois"
	desc = "Ne pas utiliser des choses en feu dessus. La rumeur dit que elle brule facilement." //Yes, the floor is made out of floor
	icon = 'icons/obj/smooth_structures/wood_table.dmi'
	icon_state = "wood_table-0"
	base_icon_state = "wood_table"
	frame = /obj/structure/table_frame/wood
	framestack = /obj/item/stack/sheet/mineral/wood
	buildstack = /obj/item/stack/sheet/mineral/wood
	resistance_flags = FLAMMABLE
	max_integrity = 70
	smoothing_groups = SMOOTH_GROUP_WOOD_TABLES //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = SMOOTH_GROUP_WOOD_TABLES

/obj/structure/table/wood/narsie_act(total_override = TRUE)
	if(!total_override)
		..()

/obj/structure/table/wood/poker //No specialties, Just a mapping object.
	name = "table de paris"
	desc = "Une table louche pour des activitées louche dans des endroits louche"
	icon = 'icons/obj/smooth_structures/poker_table.dmi'
	icon_state = "poker_table-0"
	base_icon_state = "poker_table"
	buildstack = /obj/item/stack/tile/carpet

/obj/structure/table/wood/poker/narsie_act()
	..(FALSE)

/obj/structure/table/wood/fancy
	name = "table classieuse"
	desc = "Une table en métal standard recouverte par une nappe en tissus incroyablement classieuse."
	icon = 'icons/obj/structures.dmi'
	icon_state = "fancy_table"
	base_icon_state = "fancy_table"
	frame = /obj/structure/table_frame
	framestack = /obj/item/stack/rods
	buildstack = /obj/item/stack/tile/carpet
	smoothing_groups = SMOOTH_GROUP_FANCY_WOOD_TABLES //Don't smooth with SMOOTH_GROUP_TABLES or SMOOTH_GROUP_WOOD_TABLES
	canSmoothWith = SMOOTH_GROUP_FANCY_WOOD_TABLES
	var/smooth_icon = 'icons/obj/smooth_structures/fancy_table.dmi' // see Initialize()

/obj/structure/table/wood/fancy/Initialize(mapload)
	. = ..()
	// Needs to be set dynamically because table smooth sprites are 32x34,
	// which the editor treats as a two-tile-tall object. The sprites are that
	// size so that the north/south corners look nice - examine the detail on
	// the sprites in the editor to see why.
	icon = smooth_icon

/obj/structure/table/wood/fancy/black
	icon_state = "fancy_table_black"
	base_icon_state = "fancy_table_black"
	buildstack = /obj/item/stack/tile/carpet/black
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_black.dmi'

/obj/structure/table/wood/fancy/blue
	icon_state = "fancy_table_blue"
	base_icon_state = "fancy_table_blue"
	buildstack = /obj/item/stack/tile/carpet/blue
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_blue.dmi'

/obj/structure/table/wood/fancy/cyan
	icon_state = "fancy_table_cyan"
	base_icon_state = "fancy_table_cyan"
	buildstack = /obj/item/stack/tile/carpet/cyan
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_cyan.dmi'

/obj/structure/table/wood/fancy/green
	icon_state = "fancy_table_green"
	base_icon_state = "fancy_table_green"
	buildstack = /obj/item/stack/tile/carpet/green
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_green.dmi'

/obj/structure/table/wood/fancy/orange
	icon_state = "fancy_table_orange"
	base_icon_state = "fancy_table_orange"
	buildstack = /obj/item/stack/tile/carpet/orange
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_orange.dmi'

/obj/structure/table/wood/fancy/purple
	icon_state = "fancy_table_purple"
	base_icon_state = "fancy_table_purple"
	buildstack = /obj/item/stack/tile/carpet/purple
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_purple.dmi'

/obj/structure/table/wood/fancy/red
	icon_state = "fancy_table_red"
	base_icon_state = "fancy_table_red"
	buildstack = /obj/item/stack/tile/carpet/red
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_red.dmi'

/obj/structure/table/wood/fancy/royalblack
	icon_state = "fancy_table_royalblack"
	base_icon_state = "fancy_table_royalblack"
	buildstack = /obj/item/stack/tile/carpet/royalblack
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_royalblack.dmi'

/obj/structure/table/wood/fancy/royalblue
	icon_state = "fancy_table_royalblue"
	base_icon_state = "fancy_table_royalblue"
	buildstack = /obj/item/stack/tile/carpet/royalblue
	smooth_icon = 'icons/obj/smooth_structures/fancy_table_royalblue.dmi'

/*
 * Reinforced tables
 */
/obj/structure/table/reinforced
	name = "table renforcée"
	desc = "Une version renforcée de la table à quatre pieds."
	icon = 'icons/obj/smooth_structures/reinforced_table.dmi'
	icon_state = "reinforced_table-0"
	base_icon_state = "reinforced_table"
	deconstruction_ready = 0
	buildstack = /obj/item/stack/sheet/plasteel
	max_integrity = 200
	integrity_failure = 0.25
	armor_type = /datum/armor/table_reinforced

/datum/armor/table_reinforced
	melee = 10
	bullet = 30
	laser = 30
	energy = 100
	bomb = 20
	fire = 80
	acid = 70

/obj/structure/table/reinforced/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if(isnull(held_item))
		return NONE

	if(held_item.tool_behaviour == TOOL_WELDER)
		context[SCREENTIP_CONTEXT_RMB] = deconstruction_ready ? "Renforcer" : "Affaiblir"
		. = CONTEXTUAL_SCREENTIP_SET

	return . || NONE

/obj/structure/table/reinforced/deconstruction_hints(mob/user)
	if(deconstruction_ready)
		return span_notice("Le dessus a été <b>désoudé</b> et les <b>écrous</b> principaux sont visible.")
	else
		return span_notice("Le dessus est solidement <b>soudé</b>.")

/obj/structure/table/reinforced/attackby_secondary(obj/item/weapon, mob/user, params)
	if(weapon.tool_behaviour == TOOL_WELDER)
		if(weapon.tool_start_check(user, amount = 0))
			if(deconstruction_ready)
				to_chat(user, span_notice("Vous commencer à renforcer la table renforcée..."))
				if (weapon.use_tool(src, user, 50, volume = 50))
					to_chat(user, span_notice("Vous avez renforcé la table."))
					deconstruction_ready = FALSE
			else
				to_chat(user, span_notice("Vous commencez à affaiblir la table renforcée..."))
				if (weapon.use_tool(src, user, 50, volume = 50))
					to_chat(user, span_notice("Vous avez affaibli la table."))
					deconstruction_ready = TRUE
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	else
		. = ..()

/obj/structure/table/bronze
	name = "table en bronze"
	desc = "Une table solide fait de bronze."
	icon = 'icons/obj/smooth_structures/brass_table.dmi'
	icon_state = "brass_table-0"
	base_icon_state = "brass_table"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	buildstack = /obj/item/stack/sheet/bronze
	smoothing_groups = SMOOTH_GROUP_BRONZE_TABLES //Don't smooth with SMOOTH_GROUP_TABLES
	canSmoothWith = SMOOTH_GROUP_BRONZE_TABLES

/obj/structure/table/bronze/tablepush(mob/living/user, mob/living/pushed_mob)
	..()
	playsound(src, 'sound/magic/clockwork/fellowship_armory.ogg', 50, TRUE)

/obj/structure/table/reinforced/rglass
	name = "table en verre renforcée"
	desc = "Une version renforcée de la table en verre."
	icon = 'icons/obj/smooth_structures/rglass_table.dmi'
	icon_state = "rglass_table-0"
	base_icon_state = "rglass_table"
	custom_materials = list(/datum/material/glass = 2000, /datum/material/iron = 2000)
	buildstack = /obj/item/stack/sheet/rglass
	max_integrity = 150

/obj/structure/table/reinforced/plasmarglass
	name = "table en verre plasma renforcée"
	desc = "Une version renforcée de la table en verre plasma."
	icon = 'icons/obj/smooth_structures/rplasmaglass_table.dmi'
	icon_state = "rplasmaglass_table-0"
	base_icon_state = "rplasmaglass_table"
	custom_materials = list(/datum/material/alloy/plasmaglass = 2000, /datum/material/iron = 2000)
	buildstack = /obj/item/stack/sheet/plasmarglass

/obj/structure/table/reinforced/titaniumglass
	name = "table en verre titane"
	desc = "Une table en verre titane renforcée, le tout est présenté avec une couche de peinture blanche NT."
	icon = 'icons/obj/smooth_structures/titaniumglass_table.dmi'
	icon_state = "titaniumglass_table-0"
	base_icon_state = "titaniumglass_table"
	custom_materials = list(/datum/material/alloy/titaniumglass = 2000)
	buildstack = /obj/item/stack/sheet/titaniumglass
	max_integrity = 250

/obj/structure/table/reinforced/plastitaniumglass
	name = "table en verre plastitane"
	desc = "Une table fait d'un alliage de titane et composite silice-plasma renforcé. Aussi solide qu'elle en a l'air."
	icon = 'icons/obj/smooth_structures/plastitaniumglass_table.dmi'
	icon_state = "plastitaniumglass_table-0"
	base_icon_state = "plastitaniumglass_table"
	custom_materials = list(/datum/material/alloy/plastitaniumglass = 2000)
	buildstack = /obj/item/stack/sheet/plastitaniumglass
	max_integrity = 300

/*
 * Surgery Tables
 */

/obj/structure/table/optable
	name = "table d'opération"
	desc = "Utilisée pour des procédures médicales."
	icon = 'icons/obj/medical/surgery_table.dmi'
	icon_state = "surgery_table"
	buildstack = /obj/item/stack/sheet/mineral/silver
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null
	can_buckle = 1
	buckle_lying = NO_BUCKLE_LYING
	buckle_requires_restraints = TRUE
	custom_materials = list(/datum/material/silver = 2000)
	var/mob/living/carbon/patient = null
	var/obj/machinery/computer/operating/computer = null

/obj/structure/table/optable/Initialize(mapload)
	. = ..()
	for(var/direction in GLOB.alldirs)
		computer = locate(/obj/machinery/computer/operating) in get_step(src, direction)
		if(computer)
			computer.table = src
			break
	RegisterSignal(loc, COMSIG_ATOM_ENTERED, PROC_REF(mark_patient))
	RegisterSignal(loc, COMSIG_ATOM_EXITED, PROC_REF(unmark_patient))

/obj/structure/table/optable/Destroy()
	if(computer && computer.table == src)
		computer.table = null
	patient = null
	UnregisterSignal(loc, COMSIG_ATOM_ENTERED)
	UnregisterSignal(loc, COMSIG_ATOM_EXITED)
	return ..()

/obj/structure/table/optable/tablepush(mob/living/user, mob/living/pushed_mob)
	pushed_mob.forceMove(loc)
	pushed_mob.set_resting(TRUE, TRUE)
	visible_message(span_notice("[user] couche [pushed_mob] sur la [src]."))

/// Any mob that enters our tile will be marked as a potential patient. They will be turned into a patient if they lie down.
/obj/structure/table/optable/proc/mark_patient(datum/source, mob/living/carbon/potential_patient)
	SIGNAL_HANDLER
	if(!istype(potential_patient))
		return
	RegisterSignal(potential_patient, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(recheck_patient))
	recheck_patient(potential_patient) // In case the mob is already lying down before they entered.

/// Unmark the potential patient.
/obj/structure/table/optable/proc/unmark_patient(datum/source, mob/living/carbon/potential_patient)
	SIGNAL_HANDLER
	if(!istype(potential_patient))
		return
	if(potential_patient == patient)
		recheck_patient(patient) // Can just set patient to null, but doing the recheck lets us find a replacement patient.
	UnregisterSignal(potential_patient, COMSIG_LIVING_SET_BODY_POSITION)

/// Someone on our tile just lied down, got up, moved in, or moved out.
/// potential_patient is the mob that had one of those four things change.
/// The check is a bit broad so we can find a replacement patient.
/obj/structure/table/optable/proc/recheck_patient(mob/living/carbon/potential_patient)
	SIGNAL_HANDLER
	if(patient && patient != potential_patient)
		return

	if(potential_patient.body_position == LYING_DOWN && potential_patient.loc == loc)
		patient = potential_patient
		return

	// Find another lying mob as a replacement.
	for (var/mob/living/carbon/replacement_patient in loc.contents)
		if(replacement_patient.body_position == LYING_DOWN)
			patient = replacement_patient
			return
	patient = null

/*
 * Racks
 */
/obj/structure/rack
	name = "rack"
	desc = "Différent de sa version moyen-ageuse."
	icon = 'icons/obj/structures.dmi'
	icon_state = "rack"
	layer = TABLE_LAYER
	density = TRUE
	anchored = TRUE
	pass_flags_self = LETPASSTHROW //You can throw objects over this, despite it's density.
	max_integrity = 20

/obj/structure/rack/examine(mob/user)
	. = ..()
	. += span_notice("Elle tient debout grace à quelques <b>écrous</b>.")

/obj/structure/rack/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return
	if(istype(mover) && (mover.pass_flags & PASSTABLE))
		return TRUE

/obj/structure/rack/MouseDrop_T(obj/O, mob/user)
	. = ..()
	if ((!( isitem(O) ) || user.get_active_held_item() != O))
		return
	if(!user.dropItemToGround(O))
		return
	if(O.loc != src.loc)
		step(O, get_dir(O, src))

/obj/structure/rack/attackby(obj/item/W, mob/living/user, params)
	var/list/modifiers = params2list(params)
	if (W.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1) && LAZYACCESS(modifiers, RIGHT_CLICK))
		W.play_tool_sound(src)
		deconstruct(TRUE)
		return
	if(user.combat_mode)
		return ..()
	if(user.transferItemToLoc(W, drop_location()))
		return 1

/obj/structure/rack/attack_paw(mob/living/user, list/modifiers)
	attack_hand(user, modifiers)

/obj/structure/rack/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.body_position == LYING_DOWN || user.usable_legs < 2)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src, ATTACK_EFFECT_KICK)
	user.visible_message(span_danger("[user] kicks [src]."), null, null, COMBAT_MESSAGE_RANGE)
	take_damage(rand(4,8), BRUTE, MELEE, 1)

/obj/structure/rack/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(loc, 'sound/items/dodgeball.ogg', 80, TRUE)
			else
				playsound(loc, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(loc, 'sound/items/welder.ogg', 40, TRUE)

/*
 * Rack destruction
 */

/obj/structure/rack/deconstruct(disassembled = TRUE)
	if(!(flags_1&NODECONSTRUCT_1))
		set_density(FALSE)
		var/obj/item/rack_parts/newparts = new(loc)
		transfer_fingerprints_to(newparts)
	qdel(src)


/*
 * Rack Parts
 */

/obj/item/rack_parts
	name = "morceaux de rack"
	desc = "Morceau d'un rack."
	icon = 'icons/obj/structures.dmi'
	icon_state = "rack_parts"
	inhand_icon_state = "rack_parts"
	flags_1 = CONDUCT_1
	custom_materials = list(/datum/material/iron=2000)
	var/building = FALSE

/obj/item/rack_parts/attackby(obj/item/W, mob/user, params)
	if (W.tool_behaviour == TOOL_WRENCH)
		new /obj/item/stack/sheet/iron(user.loc)
		qdel(src)
	else
		. = ..()

/obj/item/rack_parts/attack_self(mob/user)
	if(building)
		return
	building = TRUE
	to_chat(user, span_notice("Vous commencez à construire un rack..."))
	if(do_after(user, 50, target = user, progress=TRUE))
		if(!user.temporarilyRemoveItemFromInventory(src))
			return
		var/obj/structure/rack/R = new /obj/structure/rack(get_turf(src))
		user.visible_message("<span class='notice'>[user] assemble un [R].\
			</span>", span_notice("Vous assemblez un [R]."))
		R.add_fingerprint(user)
		qdel(src)
	building = FALSE

