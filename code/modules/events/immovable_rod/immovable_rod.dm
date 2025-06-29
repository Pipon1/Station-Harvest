/// "What the fuck was that?!"
/obj/effect/immovablerod
	name = "barre inamovible"
	desc = "Putain mais qu'est-ce que c'est que ce truc ?"
	icon = 'icons/obj/objects.dmi'
	icon_state = "immrod"
	throwforce = 100
	move_force = INFINITY
	move_resist = INFINITY
	pull_force = INFINITY
	density = TRUE
	anchored = TRUE
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1
	movement_type = PHASING | FLYING
	/// The turf we're looking to coast to.
	var/turf/destination_turf
	/// Whether we notify ghosts.
	var/notify = TRUE
	///We can designate a specific target to aim for, in which case we'll try to snipe them rather than just flying in a random direction
	var/atom/special_target
	///How many mobs we've penetrated one way or another
	var/num_mobs_hit = 0
	///How many mobs we've hit with clients
	var/num_sentient_mobs_hit = 0
	///How many people we've hit with clients
	var/num_sentient_people_hit = 0
	/// The rod levels up with each kill, increasing in size and auto-renaming itself.
	var/dnd_style_level_up = TRUE
	/// Whether the rod can loop across other z-levels. The rod will still loop when the z-level is self-looping even if this is FALSE.
	var/loopy_rod = FALSE

/obj/effect/immovablerod/Initialize(mapload, atom/target_atom, atom/specific_target, force_looping = FALSE)
	. = ..()
	SSaugury.register_doom(src, 2000)

	var/turf/real_destination = get_turf(target_atom)
	destination_turf = real_destination
	special_target = specific_target
	loopy_rod ||= force_looping

	ADD_TRAIT(src, TRAIT_FREE_HYPERSPACE_MOVEMENT, INNATE_TRAIT)

	SSpoints_of_interest.make_point_of_interest(src)

	RegisterSignal(src, COMSIG_ATOM_ENTERING, PROC_REF(on_entering_atom))

	if(special_target)
		SSmove_manager.home_onto(src, special_target)
	else
		SSmove_manager.move_towards(src, real_destination)

/obj/effect/immovablerod/Destroy(force)
	UnregisterSignal(src, COMSIG_ATOM_ENTERING)
	SSaugury.unregister_doom(src)
	destination_turf = null
	special_target = null
	return ..()

/obj/effect/immovablerod/examine(mob/user)
	. = ..()
	if(!isobserver(user))
		return

	if(!num_mobs_hit)
		. += span_notice("Pour l'instant cette barre n'a touché aucune créature.")
		return

	. += "\t<span class='notice'>Pour l'instant cette barre a touché : \n\
		\t\t[num_mobs_hit] créature(s) au total, \n\
		\t\t[num_sentient_mobs_hit] étaient sentientes, et \n\
		\t\t[num_sentient_people_hit] étaient des personnes sentientes</span>"

/obj/effect/immovablerod/Topic(href, href_list)
	if(href_list["orbit"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			ghost.ManualFollow(src)

/obj/effect/immovablerod/proc/on_entered_over_movable(datum/source, atom/movable/atom_crossed_over)
	SIGNAL_HANDLER
	if((atom_crossed_over.density || isliving(atom_crossed_over)) && !QDELETED(atom_crossed_over))
		Bump(atom_crossed_over)

/obj/effect/immovablerod/proc/on_entering_atom(datum/source, atom/destination, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(destination.density && isturf(destination))
		Bump(destination)

/obj/effect/immovablerod/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	if(!loc)
		return ..()

	for(var/atom/movable/to_bump in loc)
		if((to_bump != src) && !QDELETED(to_bump) && (to_bump.density || isliving(to_bump)))
			Bump(to_bump)

	// If we have a special target, we should definitely make an effort to go find them.
	if(special_target)
		var/turf/target_turf = get_turf(special_target)

		// Did they escape the z-level? Let's see if we can chase them down!
		var/z_diff = target_turf.z - z

		if(z_diff)
			var/direction = z_diff > 0 ? UP : DOWN
			var/turf/target_z_turf = get_step_multiz(src, direction)

			visible_message(span_danger("[src] sort de cette réalité."))

			if(!do_teleport(src, target_z_turf))
				// We failed to teleport. Might as well admit defeat.
				qdel(src)
				return

			visible_message(span_danger("[src] apparait dans cette réalité."))
			SSmove_manager.home_onto(src, special_target)

		if(loc == target_turf)
			complete_trajectory()

		return ..()

	// If we have a destination turf, let's make sure it's also still valid.
	if(destination_turf)

		// If the rod is a loopy_rod, run complete_trajectory() to get a new edge turf to fly to.
		// Otherwise, qdel the rod.
		if(destination_turf.z != z)
			if(loopy_rod)
				complete_trajectory()
				return ..()

			qdel(src)
			return

		// Did we reach our destination? We're probably on Icebox. Let's get rid of ourselves.
		// Ordinarily this won't happen as the average destination is the edge of the map and
		// the rod will auto transition to a new z-level.
		if(loc == destination_turf)
			qdel(src)
			return

	return ..()

/obj/effect/immovablerod/proc/complete_trajectory()
	// We hit what we wanted to hit, time to go.
	special_target = null
	walk_in_direction(dir)

/obj/effect/immovablerod/singularity_act()
	return

/obj/effect/immovablerod/singularity_pull()
	return

/obj/effect/immovablerod/Process_Spacemove(movement_dir = 0, continuous_move = FALSE)
	return TRUE

/obj/effect/immovablerod/Bump(atom/clong)
	if(prob(10))
		playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
		audible_message(span_danger("Vous entendez un CLAN !"))

	if(special_target && clong == special_target)
		complete_trajectory()

	// If rod meets rod, they collapse into a singularity. Yes, this means that if two wizard rods collide,
	// they ALSO collapse into a singulo.
	if(istype(clong, /obj/effect/immovablerod))
		visible_message(span_danger("[src] se fracasse avec un [clong] ! Ça ne peut pas bien finir."))
		var/datum/effect_system/fluid_spread/smoke/smoke = new
		smoke.set_up(2, holder = src, location = get_turf(src))
		smoke.start()
		var/obj/singularity/bad_luck = new(get_turf(src))
		bad_luck.energy = 800
		qdel(clong)
		qdel(src)
		return

	// If we Bump into a turf, turf go boom.
	if(isturf(clong))
		SSexplosions.highturf += clong
		return ..()

	if(isobj(clong))
		var/obj/clong_obj = clong
		clong_obj.take_damage(INFINITY, BRUTE, NONE, TRUE, dir, INFINITY)
		return ..()

	// If we Bump into a living thing, living thing goes splat.
	if(isliving(clong))
		penetrate(clong)
		return ..()

	// If we Bump into anything else, anything goes boom.
	if(isatom(clong))
		SSexplosions.high_mov_atom += clong
		return ..()

	CRASH("[src] Bump()ed into non-atom thing [clong] ([clong.type])")

/obj/effect/immovablerod/proc/penetrate(mob/living/smeared_mob)
	smeared_mob.visible_message(span_danger("[smeared_mob] est transpercé par une barre inamovible !") , span_userdanger("La barre vous transperse !") , span_danger("Vous entendez un CLANG!"))

	if(smeared_mob.stat != DEAD)
		num_mobs_hit++
		if(smeared_mob.client)
			num_sentient_mobs_hit++
			if(iscarbon(smeared_mob))
				num_sentient_people_hit++
			if(dnd_style_level_up)
				transform = transform.Scale(1.005, 1.005)
				name = "[initial(name)] of sentient slaying +[num_sentient_mobs_hit]"

	if(iscarbon(smeared_mob))
		var/mob/living/carbon/smeared_carbon = smeared_mob
		smeared_carbon.adjustBruteLoss(100)
		var/obj/item/bodypart/penetrated_chest = smeared_carbon.get_bodypart(BODY_ZONE_CHEST)
		penetrated_chest?.receive_damage(60, wound_bonus = 20, sharpness=SHARP_POINTY)

	if(smeared_mob.density || prob(10))
		EX_ACT(smeared_mob, EXPLODE_HEAVY)

/obj/effect/immovablerod/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(!(HAS_TRAIT(user, TRAIT_ROD_SUPLEX) || (user.mind && HAS_TRAIT(user.mind, TRAIT_ROD_SUPLEX))))
		return

	playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
	for(var/mob/living/nearby_mob in urange(8, src))
		if(nearby_mob.stat != CONSCIOUS)
			continue
		shake_camera(nearby_mob, 2, 3)

	return suplex_rod(user)

/**
 * Called when someone manages to suplex the rod.
 *
 * Arguments
 * * strongman - the suplexer of the rod.
 */
/obj/effect/immovablerod/proc/suplex_rod(mob/living/strongman)
	strongman.client?.give_award(/datum/award/achievement/misc/feat_of_strength, strongman)
	strongman.visible_message(
		span_boldwarning("[strongman] suplexe la [src] dans le sol !"),
		span_warning("Vous suplexez la [src] dans le sol !")
		)
	new /obj/structure/festivus/anchored(drop_location())
	new /obj/effect/anomaly/flux(drop_location())
	qdel(src)
	return TRUE

/* Below are a couple of admin helper procs when dealing with immovable rod memes. */
/**
 * Stops your rod's automated movement. Sit... Stay... Good rod!
 */
/obj/effect/immovablerod/proc/sit_stay_good_rod()
	SSmove_manager.stop_looping(src)

/**
 * Allows your rod to release restraint level zero and go for a walk.
 *
 * If walkies_location is set, rod will move towards the location, chasing it across z-levels if necessary.
 * If walkies_location is not set, rod will call complete_trajectory() and follow the logic from that proc.
 *
 * Arguments:
 * * walkies_location - Any atom that the immovable rod will now chase down as a special target.
 */
/obj/effect/immovablerod/proc/go_for_a_walk(walkies_location = null)
	if(walkies_location)
		special_target = walkies_location
		SSmove_manager.home_onto(src, special_target)
		return

	complete_trajectory()

/obj/effect/immovablerod/deadchat_plays(mode = DEMOCRACY_MODE, cooldown = 6 SECONDS)
	return AddComponent(/datum/component/deadchat_control/immovable_rod, mode, list(), cooldown)

/**
 * Rod will walk towards edge turf in the specified direction.
 *
 * Arguments:
 * * direction - The direction to walk the rod towards: NORTH, SOUTH, EAST, WEST.
 */
/obj/effect/immovablerod/proc/walk_in_direction(direction)
	destination_turf = get_edge_target_turf(src, direction)
	SSmove_manager.move_towards(src, destination_turf)
