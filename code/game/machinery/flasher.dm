// It is a gizmo that flashes a small area

/obj/machinery/flasher
	name = "flash fixe"
	desc = "Un flash fixe monté au mur."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mflash1"
	base_icon_state = "mflash"
	max_integrity = 250
	integrity_failure = 0.4
	damage_deflection = 10
	///The contained flash. Mostly just handles the bulb burning out & needing placement.
	var/obj/item/assembly/flash/handheld/bulb
	var/id = null
	/// How far this flash reaches. Affects both proximity distance and the actual stun effect.
	var/flash_range = 2 //this is roughly the size of a brig cell.

	/// How strong Paralyze()'d targets are when flashed.
	var/strength = 10 SECONDS

	COOLDOWN_DECLARE(flash_cooldown)
	/// Duration of time between flashes.
	var/flash_cooldown_duration = 15 SECONDS

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/flasher, 26)

/obj/machinery/flasher/Initialize(mapload, ndir = 0, built = 0)
	. = ..() // ..() is EXTREMELY IMPORTANT, never forget to add it
	if(!built)
		bulb = new(src)

/obj/machinery/flasher/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, flash_cooldown_duration) && (COOLDOWN_TIMELEFT(src, flash_cooldown) > flash_cooldown_duration))
		COOLDOWN_START(src, flash_cooldown, flash_cooldown_duration)

/obj/machinery/flasher/connect_to_shuttle(mapload, obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	id = "[port.shuttle_id]_[id]"

/obj/machinery/flasher/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	if(istype(arrived, /obj/item/assembly/flash/handheld))
		bulb = arrived
	return ..()

/obj/machinery/flasher/Exited(atom/movable/gone, direction)
	if(gone == bulb)
		bulb = null
	return ..()

/obj/machinery/flasher/Destroy()
	QDEL_NULL(bulb)
	return ..()

/obj/machinery/flasher/powered()
	if(!anchored || !bulb)
		return FALSE
	return ..()

/obj/machinery/flasher/update_icon_state()
	icon_state = "[base_icon_state]1[(bulb?.burnt_out || !powered()) ? "-p" : null]"
	return ..()

//Don't want to render prison breaks impossible
/obj/machinery/flasher/attackby(obj/item/attacking_item, mob/user, params)
	add_fingerprint(user)
	if (attacking_item.tool_behaviour == TOOL_WIRECUTTER)
		if (bulb)
			user.visible_message(span_notice("[user] commence à dévisser l'ampoule du [src]."), span_notice("Vous commencez à dévisser l'ampoule du [src]..."))
			if(attacking_item.use_tool(src, user, 30, volume=50) && bulb)
				user.visible_message(span_notice("[user] a dévissé l'ampoule du [src] !"), span_notice("Vous avez dévissé l'ampoule du [src]."))
				bulb.forceMove(loc)
				power_change()

	else if (istype(attacking_item, /obj/item/assembly/flash/handheld))
		if (!bulb)
			if(!user.transferItemToLoc(attacking_item, src))
				return
			user.visible_message(span_notice("[user] installe [attacking_item] dans [src]."), span_notice("Vous installez [attacking_item] dans [src]."))
			power_change()
		else
			to_chat(user, span_warning("Une ampoule est deja installé dans [src] !"))

	else if (attacking_item.tool_behaviour == TOOL_WRENCH)
		if(!bulb)
			to_chat(user, span_notice("Vous commencez à dé-installez le flash..."))
			if(attacking_item.use_tool(src, user, 40, volume=50))
				to_chat(user, span_notice("Vous dé-installez le flash."))
				deconstruct(TRUE)
		else
			to_chat(user, span_warning("Retirez l'ampoule de [src] d'abord !"))
	else
		return ..()

//Let the AI trigger them directly.
/obj/machinery/flasher/attack_ai()
	if (anchored)
		return flash()

/obj/machinery/flasher/proc/flash()
	if (!powered() || !bulb)
		return

	if (bulb.burnt_out || !COOLDOWN_FINISHED(src, flash_cooldown))
		return

	if(!bulb.flash_recharge(30)) //Bulb can burn out if it's used too often too fast
		power_change()
		return

	playsound(src, 'sound/weapons/flash.ogg', 100, TRUE)
	flick("[base_icon_state]_flash", src)
	flash_lighting_fx()

	COOLDOWN_START(src, flash_cooldown, flash_cooldown_duration)
	use_power(1000)

	var/flashed = FALSE
	for(var/mob/living/living_mob in viewers(src, null))
		if (get_dist(src, living_mob) > flash_range)
			continue

		if(living_mob.flash_act(affect_silicon = TRUE))
			living_mob.log_message("was AOE flashed by an automated portable flasher", LOG_ATTACK)
			living_mob.Paralyze(strength)
			flashed = TRUE

	if(flashed)
		bulb.times_used++

	return TRUE

/obj/machinery/flasher/emp_act(severity)
	. = ..()
	if(!(machine_stat & (BROKEN|NOPOWER)) && !(. & EMP_PROTECT_SELF))
		if(bulb && prob(75/severity))
			flash()
			bulb.burn_out()
			power_change()

/obj/machinery/flasher/atom_break(damage_flag)
	. = ..()
	if(. && bulb)
		bulb.burn_out()
		power_change()

/obj/machinery/flasher/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(bulb)
			bulb.forceMove(loc)
		if(disassembled)
			var/obj/item/wallframe/flasher/flasher_obj = new(get_turf(src))
			transfer_fingerprints_to(flasher_obj)
			flasher_obj.id = id
			playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		else
			new /obj/item/stack/sheet/iron (loc, 2)
	qdel(src)

/obj/machinery/flasher/portable //Portable version of the flasher. Only flashes when anchored
	name = "flash mobile"
	desc = "Un flash portable. Utilisez une clé à molette pour l'activer et le désactiver. Ne détecte pas les mouvements lents."
	icon_state = "pflash1-p"
	base_icon_state = "pflash"
	strength = 8 SECONDS
	anchored = FALSE
	density = TRUE
	///Proximity monitor associated with this atom, needed for proximity checks.
	var/datum/proximity_monitor/proximity_monitor

/obj/machinery/flasher/portable/Initialize(mapload)
	. = ..()
	proximity_monitor = new(src, 0)

/obj/machinery/flasher/portable/HasProximity(atom/movable/proximity_check_mob)
	if(!COOLDOWN_FINISHED(src, flash_cooldown))
		return

	if(iscarbon(proximity_check_mob))
		var/mob/living/carbon/proximity_carbon = proximity_check_mob
		if (proximity_carbon.m_intent != MOVE_INTENT_WALK && anchored)
			flash()

/obj/machinery/flasher/portable/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, flash_range))
		proximity_monitor?.set_range(flash_range)

/obj/machinery/flasher/portable/attackby(obj/item/attacking_item, mob/user, params)
	if (attacking_item.tool_behaviour == TOOL_WRENCH)
		attacking_item.play_tool_sound(src, 100)

		if (!anchored && !isinspace())
			to_chat(user, span_notice("[src] est maintenant fixé."))
			add_overlay("[base_icon_state]-s")
			set_anchored(TRUE)
			power_change()
			proximity_monitor.set_range(flash_range)
		else
			to_chat(user, span_notice("[src] peut être maintenant bougé."))
			cut_overlays()
			set_anchored(FALSE)
			power_change()
			proximity_monitor.set_range(0)

	else
		return ..()

/obj/item/wallframe/flasher
	name = "chassis de flash fixe"
	desc = "Utilisé pour construire des flashs fixe."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mflash_frame"
	result_path = /obj/machinery/flasher
	var/id = null
	pixel_shift = 28

/obj/item/wallframe/flasher/examine(mob/user)
	. = ..()
	. += span_notice("Son identifiant de cannal est '[id]'.")

/obj/item/wallframe/flasher/after_attach(obj/attached_to)
	..()
	var/obj/machinery/flasher/flasher_obj = attached_to
	flasher_obj.id = id
