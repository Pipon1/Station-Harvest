/// Max number of unanchored items that will be moved from a tile when attempting to add a window to a grille.
#define CLEAR_TILE_MOVE_LIMIT 20

/obj/structure/grille
	desc = "Un tas de barres de fer."
	name = "grille"
	icon = 'icons/obj/structures.dmi'
	icon_state = "grille"
	base_icon_state = "grille"
	density = TRUE
	anchored = TRUE
	pass_flags_self = PASSGRILLE
	flags_1 = CONDUCT_1
	obj_flags = CAN_BE_HIT | IGNORE_DENSITY
	pressure_resistance = 5*ONE_ATMOSPHERE
	armor_type = /datum/armor/structure_grille
	max_integrity = 50
	integrity_failure = 0.4
	var/rods_type = /obj/item/stack/rods
	var/rods_amount = 2

/datum/armor/structure_grille
	melee = 50
	bullet = 70
	laser = 70
	energy = 100
	bomb = 10

/obj/structure/grille/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/atmos_sensitive, mapload)

/obj/structure/grille/Destroy()
	update_cable_icons_on_turf(get_turf(src))
	return ..()

/obj/structure/grille/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	update_appearance()

/obj/structure/grille/update_appearance(updates)
	if(QDELETED(src) || broken)
		return

	. = ..()
	if((updates & UPDATE_SMOOTHING) && (smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK)))
		QUEUE_SMOOTH(src)

/obj/structure/grille/update_icon_state()
	icon_state = "[base_icon_state][((atom_integrity / max_integrity) <= 0.5) ? "50_[rand(0, 3)]" : null]"
	return ..()

/obj/structure/grille/examine(mob/user)
	. = ..()
	if(anchored)
		. += span_notice("La grille est fixée en place avec des <b>vis</b>. Les barres semblent pouvoir être <b>coupées</b>.")
	if(!anchored)
		. += span_notice("Les vis de fixation sont <i>dévissées</i>. Les barres semblent pouvoir être <b>coupées</b>.")

/obj/structure/grille/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 20, "cost" = 5)
		if(RCD_WINDOWGRILLE)
			var/cost = 0
			var/delay = 0
			if(the_rcd.window_type  == /obj/structure/window)
				cost = 6
				delay = 2 SECONDS
			else if(the_rcd.window_type  == /obj/structure/window/reinforced)
				cost = 9
				delay = 2.5 SECONDS
			else if(the_rcd.window_type  == /obj/structure/window/fulltile)
				cost = 12
				delay = 3 SECONDS
			else if(the_rcd.window_type  == /obj/structure/window/reinforced/fulltile)
				cost = 15
				delay = 4 SECONDS
			if(!cost)
				return FALSE

			return rcd_result_with_memory(
				list("mode" = RCD_WINDOWGRILLE, "delay" = delay, "cost" = cost),
				get_turf(src), RCD_MEMORY_WINDOWGRILLE,
			)
	return FALSE

/obj/structure/grille/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("Vous démontez la grille."))
			qdel(src)
			return TRUE
		if(RCD_WINDOWGRILLE)
			if(!isturf(loc))
				return FALSE
			var/turf/T = loc

			if(repair_grille())
				balloon_alert(user, "grille reconstruite")

			if(!clear_tile(user))
				return FALSE

			var/obj/structure/window/window_path = the_rcd.window_type
			if(!ispath(window_path))
				CRASH("Invalid window path type in RCD: [window_path]")
			if(!valid_build_direction(T, user.dir, is_fulltile = initial(window_path.fulltile)))
				balloon_alert(user, "Il y a déjà une fenêtre ici !")
				return FALSE
			var/obj/structure/window/WD = new the_rcd.window_type(T, user.dir)
			WD.set_anchored(TRUE)
			return TRUE
	return FALSE

/obj/structure/grille/proc/clear_tile(mob/user)
	var/at_users_feet = get_turf(user)

	var/unanchored_items_on_tile
	var/obj/item/last_item_moved
	for(var/obj/item/item_to_move in loc.contents)
		if(!item_to_move.anchored)
			if(unanchored_items_on_tile <= CLEAR_TILE_MOVE_LIMIT)
				item_to_move.forceMove(at_users_feet)
				last_item_moved = item_to_move
			unanchored_items_on_tile++

	if(!unanchored_items_on_tile)
		return TRUE

	to_chat(user, span_notice("Vous déplacez [unanchored_items_on_tile == 1 ? "[last_item_moved]" : "quelque chose"] hors du chemin."))

	if(unanchored_items_on_tile - CLEAR_TILE_MOVE_LIMIT > 0)
		to_chat(user, span_warning("Il y a encore trop de choses sur le chemin !"))
		return FALSE

	return TRUE

/obj/structure/grille/Bumped(atom/movable/AM)
	if(!ismob(AM))
		return
	var/mob/M = AM
	shock(M, 70)

/obj/structure/grille/attack_animal(mob/user, list/modifiers)
	. = ..()
	if(!.)
		return
	if(!shock(user, 70) && !QDELETED(src)) //Last hit still shocks but shouldn't deal damage to the grille
		take_damage(rand(5,10), BRUTE, MELEE, 1)

/obj/structure/grille/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/grille/hulk_damage()
	return 60

/obj/structure/grille/attack_hulk(mob/living/carbon/human/user)
	if(shock(user, 70))
		return
	. = ..()

/obj/structure/grille/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src, ATTACK_EFFECT_KICK)
	user.visible_message(span_warning("[user] frappe [src]."), null, null, COMBAT_MESSAGE_RANGE)
	log_combat(user, src, "hit")
	if(!shock(user, 70))
		take_damage(rand(5,10), BRUTE, MELEE, 1)

/obj/structure/grille/attack_alien(mob/living/user, list/modifiers)
	user.do_attack_animation(src)
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message(span_warning("[user] ammoche [src]."), null, null, COMBAT_MESSAGE_RANGE)
	if(!shock(user, 70))
		take_damage(20, BRUTE, MELEE, 1)

/obj/structure/grille/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!. && isprojectile(mover))
		return prob(30)

/obj/structure/grille/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller, no_id = FALSE)
	. = !density
	if(caller)
		. = . || (caller.pass_flags & PASSGRILLE)

/obj/structure/grille/wirecutter_act(mob/living/user, obj/item/tool)
	add_fingerprint(user)
	if(shock(user, 100))
		return
	tool.play_tool_sound(src, 100)
	deconstruct()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/grille/screwdriver_act(mob/living/user, obj/item/tool)
	if(!isturf(loc))
		return FALSE
	add_fingerprint(user)
	if(shock(user, 90))
		return FALSE
	if(!tool.use_tool(src, user, 0, volume=100))
		return FALSE
	set_anchored(!anchored)
	user.visible_message(span_notice("[user] [anchored ? "serre" : "déssere"] [src]."), \
		span_notice("You [anchored ? "serre [src] contre le" : "déssere [src] du"] sol."))
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/grille/attackby(obj/item/W, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	if(istype(W, /obj/item/stack/rods) && broken && do_after(user, 1 SECONDS, target = src))
		if(shock(user, 90))
			return
		var/obj/item/stack/rods/R = W
		user.visible_message(span_notice("[user] reconstruit la grille cassée."), \
			span_notice("Vous reconstruisez la grille cassée."))
		repair_grille()
		R.use(1)
		return TRUE

//window placing begin
	else if(is_glass_sheet(W) || istype(W, /obj/item/stack/sheet/bronze))
		if (!broken)
			var/obj/item/stack/ST = W
			if (ST.get_amount() < 2)
				to_chat(user, span_warning("Vous avez besoin d'au moins deux feuilles de verre pour cela !"))
				return
			var/dir_to_set = SOUTHWEST
			if(!anchored)
				to_chat(user, span_warning("Vous devez d'abord fixer [src] au sol !"))
				return
			for(var/obj/structure/window/WINDOW in loc)
				to_chat(user, span_warning("Il y a déjà une fenêtre ici !"))
				return
			if(!clear_tile(user))
				return
			to_chat(user, span_notice("Vous commencez à placer la fenêtre..."))
			if(do_after(user,20, target = src))
				if(!src.loc || !anchored) //Grille broken or unanchored while waiting
					return
				for(var/obj/structure/window/WINDOW in loc) //Another window already installed on grille
					return
				if(!clear_tile(user))
					return
				var/obj/structure/window/WD
				if(istype(W, /obj/item/stack/sheet/plasmarglass))
					WD = new/obj/structure/window/reinforced/plasma/fulltile(drop_location()) //reinforced plasma window
				else if(istype(W, /obj/item/stack/sheet/plasmaglass))
					WD = new/obj/structure/window/plasma/fulltile(drop_location()) //plasma window
				else if(istype(W, /obj/item/stack/sheet/rglass))
					WD = new/obj/structure/window/reinforced/fulltile(drop_location()) //reinforced window
				else if(istype(W, /obj/item/stack/sheet/titaniumglass))
					WD = new/obj/structure/window/reinforced/shuttle(drop_location())
				else if(istype(W, /obj/item/stack/sheet/plastitaniumglass))
					WD = new/obj/structure/window/reinforced/plasma/plastitanium(drop_location())
				else if(istype(W, /obj/item/stack/sheet/bronze))
					WD = new/obj/structure/window/bronze/fulltile(drop_location())
				else
					WD = new/obj/structure/window/fulltile(drop_location()) //normal window
				WD.setDir(dir_to_set)
				WD.set_anchored(FALSE)
				WD.state = 0
				ST.use(2)
				to_chat(user, span_notice("Vous placez[WD] sur [src]."))
			return
//window placing end

	else if((W.flags_1 & CONDUCT_1) && shock(user, 70))
		return

	return ..()

/obj/structure/grille/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src, 'sound/effects/grillehit.ogg', 80, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(src, 'sound/items/welder.ogg', 80, TRUE)


/obj/structure/grille/deconstruct(disassembled = TRUE)
	if(!loc) //if already qdel'd somehow, we do nothing
		return
	if(!(flags_1&NODECONSTRUCT_1))
		var/obj/R = new rods_type(drop_location(), rods_amount)
		transfer_fingerprints_to(R)
		qdel(src)
	..()

/obj/structure/grille/atom_break()
	. = ..()
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		icon_state = "brokengrille"
		set_density(FALSE)
		atom_integrity = 20
		broken = TRUE
		rods_amount = 1
		var/obj/item/dropped_rods = new rods_type(drop_location(), rods_amount)
		transfer_fingerprints_to(dropped_rods)

/obj/structure/grille/proc/repair_grille()
	if(broken)
		icon_state = "grille"
		set_density(TRUE)
		atom_integrity = max_integrity
		broken = FALSE
		rods_amount = 2
		return TRUE
	return FALSE

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user, prb)
	if(!anchored || broken) // anchored/broken grilles are never connected
		return FALSE
	if(!prob(prb))
		return FALSE
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return FALSE
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src, 1, TRUE))
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			return TRUE
		else
			return FALSE
	return FALSE

/obj/structure/grille/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return exposed_temperature > T0C + 1500 && !broken

/obj/structure/grille/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	take_damage(1, BURN, 0, 0)

/obj/structure/grille/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(isobj(AM))
		if(prob(50) && anchored && !broken)
			var/obj/O = AM
			if(O.throwforce != 0)//don't want to let people spam tesla bolts, this way it will break after time
				var/turf/T = get_turf(src)
				var/obj/structure/cable/C = T.get_cable_node()
				if(C)
					playsound(src, 'sound/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
					tesla_zap(src, 3, C.newavail() * 0.01, ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE | ZAP_MOB_STUN | ZAP_LOW_POWER_GEN | ZAP_ALLOW_DUPLICATES) //Zap for 1/100 of the amount of power. At a million watts in the grid, it will be as powerful as a tesla revolver shot.
					C.add_delayedload(C.newavail() * 0.0375) // you can gain up to 3.5 via the 4x upgrades power is halved by the pole so thats 2x then 1X then .5X for 3.5x the 3 bounces shock.
	return ..()

/obj/structure/grille/get_dumping_location()
	return null

/obj/structure/grille/broken // Pre-broken grilles for map placement
	icon_state = "brokengrille"
	density = FALSE
	broken = TRUE
	rods_amount = 1

/obj/structure/grille/broken/Initialize(mapload)
	. = ..()
	take_damage(max_integrity * 0.6)

#undef CLEAR_TILE_MOVE_LIMIT
