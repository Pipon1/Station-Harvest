#define CONFUSION_STACK_MAX_MULTIPLIER 2

/obj/item/assembly/flash
	name = "flash"
	desc = "Un outil de sécurité standard, utilisé pour aveugler les agresseurs et les robots."
	icon_state = "flash"
	inhand_icon_state = "flashtool"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron = 300, /datum/material/glass = 300)
	light_system = MOVABLE_LIGHT //Used as a flash here.
	light_range = FLASH_LIGHT_RANGE
	light_color = COLOR_WHITE
	light_power = FLASH_LIGHT_POWER
	light_on = FALSE
	/// Whether we currently have the flashing overlay.
	var/flashing = FALSE
	/// The overlay we use for flashing.
	var/flashing_overlay = "flash-f"
	var/times_used = 0 //Number of times it's been used.
	var/burnt_out = FALSE     //Is the flash burnt out?
	var/burnout_resistance = 0
	var/last_used = 0 //last world.time it was used.
	var/cooldown = 0
	var/last_trigger = 0 //Last time it was successfully triggered.

/obj/item/assembly/flash/suicide_act(mob/living/user)
	if(burnt_out)
		user.visible_message(span_suicide("[user] lève le [src] au niveau des yeux de [user.p_their()] et l'active... mais l'ampoule est brûlée !"))
		return SHAME
	else if(user.is_blind())
		user.visible_message(span_suicide("[user] lève le [src] au niveau des yeux de [user.p_their()]  et l'active... mais [user.p_theyre()] est aveugle !"))
		return SHAME
	user.visible_message(span_suicide("[user] lève le [src] au niveau des yeux de [user.p_their()] et l'active ! Il semble que [user.p_theyre()] essaye de se suicider !"))
	attack(user,user)
	return FIRELOSS

/obj/item/assembly/flash/update_icon(updates=ALL, flash = FALSE)
	inhand_icon_state = "[burnt_out ? "flashtool_burnt" : "[initial(inhand_icon_state)]"]"
	flashing = flash
	. = ..()
	if(flash)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/, update_icon)), 5)
	holder?.update_icon(updates)

/obj/item/assembly/flash/update_overlays()
	attached_overlays = list()
	. = ..()
	if(burnt_out)
		. += "flashburnt"
		attached_overlays += "flashburnt"
	if(flashing)
		. += flashing_overlay
		attached_overlays += flashing_overlay

/obj/item/assembly/flash/update_name()
	name = "[burnt_out ? "burnt-out [initial(name)]" : "[initial(name)]"]"
	return ..()

/obj/item/assembly/flash/proc/clown_check(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
		flash_carbon(user, user, confusion_duration = 15 SECONDS, targeted = FALSE)
		return FALSE
	return TRUE

/obj/item/assembly/flash/proc/burn_out() //Made so you can override it if you want to have an invincible flash from R&D or something.
	if(!burnt_out)
		burnt_out = TRUE
		loc?.visible_message(span_danger("[src] a l'ampoule brulée !"),span_userdanger("[src] a l'ampoule brulée !"))
		update_appearance()

/obj/item/assembly/flash/proc/flash_recharge(interval = 10)
	var/deciseconds_passed = world.time - last_used
	for(var/seconds = deciseconds_passed / 10, seconds >= interval, seconds -= interval) //get 1 charge every interval
		times_used--
	last_used = world.time
	times_used = max(0, times_used) //sanity
	if(max(0, prob(times_used * 3) - burnout_resistance)) //The more often it's used in a short span of time the more likely it will burn out
		burn_out()
		return FALSE
	return TRUE

//BYPASS CHECKS ALSO PREVENTS BURNOUT!
/obj/item/assembly/flash/proc/AOE_flash(bypass_checks = FALSE, range = 3, confusion_duration = 5 SECONDS, mob/user)
	if(!bypass_checks && !try_use_flash())
		return FALSE
	var/list/mob/targets = get_flash_targets(get_turf(src), range, FALSE)
	if(user)
		targets -= user
		to_chat(user, span_danger("[src] brille d'une lumière vive !"))
	for(var/mob/living/carbon/nearby_carbon in targets)
		flash_carbon(nearby_carbon, user, confusion_duration, targeted = FALSE, generic_message = TRUE)
	return TRUE

/obj/item/assembly/flash/proc/get_flash_targets(atom/target_loc, range = 3, override_vision_checks = FALSE)
	if(!target_loc)
		target_loc = loc
	if(override_vision_checks)
		return get_hearers_in_view(range, get_turf(target_loc))
	if(isturf(target_loc) || (ismob(target_loc) && isturf(target_loc.loc)))
		return viewers(range, get_turf(target_loc))
	else
		return typecache_filter_list(target_loc.get_all_contents(), GLOB.typecache_living)

/obj/item/assembly/flash/proc/try_use_flash(mob/user = null)
	if(burnt_out || (world.time < last_trigger + cooldown))
		return FALSE
	last_trigger = world.time
	playsound(src, 'sound/weapons/flash.ogg', 100, TRUE)
	set_light_on(TRUE)
	addtimer(CALLBACK(src, PROC_REF(flash_end)), FLASH_LIGHT_DURATION, TIMER_OVERRIDE|TIMER_UNIQUE)
	times_used++
	if(!flash_recharge())
		return FALSE
	update_icon(ALL, TRUE)
	update_name(ALL) //so if burnt_out was somehow reverted to 0 the name changes back to flash
	if(user && !clown_check(user))
		return FALSE
	return TRUE


/obj/item/assembly/flash/proc/flash_end()
	set_light_on(FALSE)

/**
 * Handles actual flashing part of the attack
 *
 * This proc is awful in every sense of the way, someone should definately refactor this whole code.
 * Arguments:
 * * M - Victim
 * * user - Attacker
 * * confusion_duration - handles the amount of confusion it gives you
 * * targeted - determines if it was aoe or targeted
 * * generic_message - checks if it should display default message.
 */
/obj/item/assembly/flash/proc/flash_carbon(mob/living/carbon/flashed, mob/user, confusion_duration = 15 SECONDS, targeted = TRUE, generic_message = FALSE)
	if(!istype(flashed))
		return
	if(user)
		log_combat(user, flashed, "[targeted? "flashed(targeted)" : "flashed(AOE)"]", src)
	else //caused by emp/remote signal
		flashed.log_message("was [targeted? "flashed(targeted)" : "flashed(AOE)"]", LOG_ATTACK)

	if(generic_message && flashed != user)
		to_chat(flashed, span_danger("[src] brille d'une lumière vive !"))

	var/deviation = calculate_deviation(flashed, user || src)

	if(user)
		var/sigreturn = SEND_SIGNAL(user, COMSIG_MOB_PRE_FLASHED_CARBON, flashed, src, deviation)
		if(sigreturn & STOP_FLASH)
			return

		if(sigreturn & DEVIATION_OVERRIDE_FULL)
			deviation = DEVIATION_FULL
		else if(sigreturn & DEVIATION_OVERRIDE_PARTIAL)
			deviation = DEVIATION_PARTIAL
		else if(sigreturn & DEVIATION_OVERRIDE_NONE)
			deviation = DEVIATION_NONE

	//If you face away from someone they shouldnt notice any effects.
	if(deviation == DEVIATION_FULL)
		return

	if(targeted)
		if(flashed.flash_act(1, 1))
			flashed.set_confusion_if_lower(confusion_duration * CONFUSION_STACK_MAX_MULTIPLIER)
			visible_message(span_danger("[user] aveugle [flashed] avec un flash !"), span_userdanger("[user] vous aveugle avec un flash !"))
			//easy way to make sure that you can only long stun someone who is facing in your direction
			flashed.adjustStaminaLoss(rand(80, 120) * (1 - (deviation * 0.5)))
			flashed.Paralyze(rand(25, 50) * (1 - (deviation * 0.5)))
			SEND_SIGNAL(user, COMSIG_MOB_SUCCESSFUL_FLASHED_CARBON, flashed, src, deviation)

		else if(user)
			visible_message(span_warning("[user] n'arrive pas à aveugler [flashed] avec le flash !"), span_danger("[user] échoue a vous aveugler avec un flash !"))
		else
			to_chat(flashed, span_danger("[src] échoue à vous aveugler !"))
	else
		if(flashed.flash_act())
			flashed.set_confusion_if_lower(confusion_duration * CONFUSION_STACK_MAX_MULTIPLIER)

/**
 * Handles the directionality of the attack
 *
 * Returns the amount of 'deviation', 0 being facing eachother, 1 being sideways, 2 being facing away from eachother.
 * Arguments:
 * * victim - Victim
 * * attacker - Attacker
 */
/obj/item/assembly/flash/proc/calculate_deviation(mob/victim, atom/attacker)
	// Tactical combat emote-spinning should not counter intended gameplay mechanics.
	// This trumps same-loc checks to discourage floor spinning in general to counter flashes.
	// In short, combat spinning is silly and you should feel silly for doing it.
	if(victim.flags_1 & IS_SPINNING_1)
		return DEVIATION_NONE

	if(iscarbon(victim))
		var/mob/living/carbon/carbon_victim = victim
		if(carbon_victim.get_eye_protection() < FLASH_PROTECTION_SENSITIVE) // If we have really bad flash sensitivity, usually due to really sensitive eyes, we get flashed from all directions
			return DEVIATION_NONE

	// Are they on the same tile? We'll return partial deviation. This may be someone flashing while lying down
	// or flashing someone they're stood on the same turf as, or a borg flashing someone buckled to them.
	if(victim.loc == attacker.loc)
		return DEVIATION_PARTIAL

	// If the victim was looking at the attacker, this is the direction they'd have to be facing.
	var/victim_to_attacker = get_dir(victim, attacker)
	// The victim's dir is necessarily a cardinal value.
	var/victim_dir = victim.dir

	// - - -
	// - V - Victim facing south
	// # # #
	// Attacker within 45 degrees of where the victim is facing.
	if(victim_dir & victim_to_attacker)
		return DEVIATION_NONE

	// # # #
	// - V - Victim facing south
	// - - -
	// Attacker at 135 or more degrees of where the victim is facing.
	if(victim_dir & REVERSE_DIR(victim_to_attacker))
		return DEVIATION_FULL

	// - - -
	// # V # Victim facing south
	// - - -
	// Attacker lateral to the victim.
	return DEVIATION_PARTIAL

/obj/item/assembly/flash/attack(mob/living/M, mob/user)
	if(!try_use_flash(user))
		return FALSE

	. = TRUE
	if(iscarbon(M))
		flash_carbon(M, user, confusion_duration = 5 SECONDS, targeted = TRUE)
		return
	if(issilicon(M))
		var/mob/living/silicon/robot/flashed_borgo = M
		log_combat(user, flashed_borgo, "flashed", src)
		update_icon(ALL, TRUE)
		if(!flashed_borgo.flash_act(affect_silicon = TRUE))
			user.visible_message(span_warning("[user] échoue à aveugler [flashed_borgo] avec un flash !"), span_warning("Vous échouez à aveugler [flashed_borgo] avec un flash !"))
			return
		flashed_borgo.Paralyze(rand(80,120))
		flashed_borgo.set_confusion_if_lower(5 SECONDS * CONFUSION_STACK_MAX_MULTIPLIER)
		user.visible_message(span_warning("[user] surcharge les senseurs de [flashed_borgo] avec un flash !"), span_danger("Vous surchargez les senseurs de [flashed_borgo] avec un flash !"))
		return

	user.visible_message(span_warning("[user] échoue a aveugler [M] avec un flash flash !"), span_warning("Vous échouez a aveugler [M] avec un flash !"))

/obj/item/assembly/flash/attack_self(mob/living/carbon/user, flag = 0, emp = 0)
	if(holder)
		return FALSE
	if(!AOE_flash(user = user))
		return FALSE

/obj/item/assembly/flash/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!AOE_flash())
		return
	burn_out()

/obj/item/assembly/flash/activate()//AOE flash on signal received
	if(!..())
		return
	AOE_flash()

/obj/item/assembly/flash/cyborg

/obj/item/assembly/flash/cyborg/attack(mob/living/M, mob/user)
	..()
	new /obj/effect/temp_visual/borgflash(get_turf(src))

/obj/item/assembly/flash/cyborg/attack_self(mob/user)
	..()
	new /obj/effect/temp_visual/borgflash(get_turf(src))

/obj/item/assembly/flash/cyborg/attackby(obj/item/W, mob/user, params)
	return
/obj/item/assembly/flash/cyborg/screwdriver_act(mob/living/user, obj/item/I)
	return

/obj/item/assembly/flash/memorizer
	name = "memoriseur"
	desc = "Si vous voyez ceci, vous n'êtes pas susceptible de vous en souvenir de sitôt."
	icon = 'icons/obj/device.dmi'
	icon_state = "memorizer"
	inhand_icon_state = "nullrod"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'

/obj/item/assembly/flash/handheld //this is now the regular pocket flashes

/obj/item/assembly/flash/armimplant
	name = "projecteur à photons"
	desc = "Un projecteur à photon à haute puissance normalement utilisé à des fins d'éclairage, mais sert également de flash. Les protocoles d'auto-réparation réparent l'ampoule si elle brûle."
	var/flashcd = 20
	var/overheat = 0
	//Wearef to our arm
	var/datum/weakref/arm

/obj/item/assembly/flash/armimplant/burn_out()
	var/obj/item/organ/internal/cyberimp/arm/flash/real_arm = arm.resolve()
	if(real_arm?.owner)
		to_chat(real_arm.owner, span_warning("Votre implant de projecteur à photons surchauffe et se désactive !"))
		real_arm.Retract()
	overheat = TRUE
	addtimer(CALLBACK(src, PROC_REF(cooldown)), flashcd * 2)

/obj/item/assembly/flash/armimplant/try_use_flash(mob/user = null)
	if(overheat)
		var/obj/item/organ/internal/cyberimp/arm/flash/real_arm = arm.resolve()
		if(real_arm?.owner)
			to_chat(real_arm.owner, span_warning("Votre projecteur à photons est trop chaud pour être utilisé à nouveau si rapidement !"))
		return FALSE
	overheat = TRUE
	addtimer(CALLBACK(src, PROC_REF(cooldown)), flashcd)
	playsound(src, 'sound/weapons/flash.ogg', 100, TRUE)
	update_icon(ALL, TRUE)
	return TRUE


/obj/item/assembly/flash/armimplant/proc/cooldown()
	overheat = FALSE

/obj/item/assembly/flash/armimplant/screwdriver_act(mob/living/user, obj/item/I)
	to_chat(user, span_notice("[src] est un implant ! Il ne peut être dévissé !"))
	add_fingerprint(user)

/obj/item/assembly/flash/hypnotic
	desc = "Un flash modifié, programmé pour émettre une séquence de flashs subliminaux qui peuvent envoyer une cible vulnérable dans une transe hypnotique."
	flashing_overlay = "flash-hypno"
	light_color = LIGHT_COLOR_PINK
	cooldown = 20

/obj/item/assembly/flash/hypnotic/burn_out()
	return

/obj/item/assembly/flash/hypnotic/flash_carbon(mob/living/carbon/M, mob/user, confusion_duration = 15, targeted = TRUE, generic_message = FALSE)
	if(!istype(M))
		return
	if(user)
		log_combat(user, M, "[targeted? "hypno-flashed(targeted)" : "hypno-flashed(AOE)"]", src)
	else //caused by emp/remote signal
		M.log_message("was [targeted? "hypno-flashed(targeted)" : "hypno-flashed(AOE)"]", LOG_ATTACK)
	if(generic_message && M != user)
		to_chat(M, span_notice("[src] brille d'une lumière agréable..."))
	if(targeted)
		if(M.flash_act(1, 1))
			var/hypnosis = FALSE
			if(M.hypnosis_vulnerable())
				hypnosis = TRUE
			if(user)
				user.visible_message(span_danger("[user] aveugle [M] avec un flash !"), span_danger("Vous hypnotisez [M] avec un flash !"))

			if(!hypnosis)
				to_chat(M, span_hypnophrase("La lumière est agréable..."))
				M.adjust_confusion_up_to(10 SECONDS, 20 SECONDS)
				M.adjust_dizzy_up_to(20 SECONDS, 40 SECONDS)
				M.adjust_drowsiness_up_to(20 SECONDS, 40 SECONDS)
				M.adjust_pacifism(10 SECONDS)
			else
				M.apply_status_effect(/datum/status_effect/trance, 200, TRUE)

		else if(user)
			user.visible_message(span_warning("[user] échoue a vous aveugler [M] avec le flash !"), span_warning("Vous n'arrivez pas à hypnotiser [M] avec un flash !"))
		else
			to_chat(M, span_danger("[src] échoue a vous aveugler !"))

	else if(M.flash_act())
		to_chat(M, span_notice("Une lumière si jolie..."))
		M.adjust_confusion_up_to(4 SECONDS, 20 SECONDS)
		M.adjust_dizzy_up_to(8 SECONDS, 40 SECONDS)
		M.adjust_drowsiness_up_to(8 SECONDS, 40 SECONDS)
		M.adjust_pacifism(4 SECONDS)

#undef CONFUSION_STACK_MAX_MULTIPLIER
