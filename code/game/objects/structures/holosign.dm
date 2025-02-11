
//holographic signs and barriers

/obj/structure/holosign
	name = "affiche holographique"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	max_integrity = 1
	armor_type = /datum/armor/structure_holosign
	// How can you freeze a trick of the light?
	resistance_flags = FREEZE_PROOF
	var/obj/item/holosign_creator/projector
	var/use_vis_overlay = TRUE

/datum/armor/structure_holosign
	bullet = 50
	laser = 50
	energy = 50
	fire = 20
	acid = 20

/obj/structure/holosign/Initialize(mapload, source_projector)
	. = ..()
	var/turf/our_turf = get_turf(src)
	if(use_vis_overlay)
		alpha = 0
		SSvis_overlays.add_vis_overlay(src, icon, icon_state, ABOVE_MOB_LAYER, MUTATE_PLANE(GAME_PLANE_UPPER, our_turf), dir, add_appearance_flags = RESET_ALPHA) //you see mobs under it, but you hit them like they are above it
	if(source_projector)
		projector = source_projector
		LAZYADD(projector.signs, src)

/obj/structure/holosign/Destroy()
	if(projector)
		LAZYREMOVE(projector.signs, src)
		projector = null
	return ..()

/obj/structure/holosign/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	attack_holosign(user, modifiers)

/obj/structure/holosign/proc/attack_holosign(mob/living/user, list/modifiers)
	user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
	user.changeNext_move(CLICK_CD_MELEE)
	take_damage(5 , BRUTE, MELEE, 1)

/obj/structure/holosign/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(loc, 'sound/weapons/egloves.ogg', 80, TRUE)
		if(BURN)
			playsound(loc, 'sound/weapons/egloves.ogg', 80, TRUE)

/obj/structure/holosign/wetsign
	name = "affiche de sol mouillé"
	desc = "Les mots clignotent comme s'ils ne signifiaient rien."
	icon = 'icons/effects/effects.dmi'
	icon_state = "holosign"

/obj/structure/holosign/barrier
	name = "barrière holographique"
	desc = "Une barrière holographique courte qui ne peut être franchie qu'en marchant."
	icon_state = "holosign_sec"
	pass_flags_self = PASSTABLE | PASSGRILLE | PASSGLASS | LETPASSTHROW
	density = TRUE
	max_integrity = 20
	var/allow_walk = TRUE //can we pass through it on walk intent

/obj/structure/holosign/barrier/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return
	if(iscarbon(mover))
		var/mob/living/carbon/C = mover
		if(C.stat) // Lets not prevent dragging unconscious/dead people.
			return TRUE
		if(allow_walk && C.m_intent == MOVE_INTENT_WALK)
			return TRUE

/obj/structure/holosign/barrier/wetsign
	name = "holobarrièr de sol mouillé"
	desc = "Quand elle dit de marcher, vous marchez."
	icon = 'icons/effects/effects.dmi'
	icon_state = "holosign"

/obj/structure/holosign/barrier/wetsign/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(iscarbon(mover))
		var/mob/living/carbon/C = mover
		if(C.stat) // Lets not prevent dragging unconscious/dead people.
			return TRUE
		if(allow_walk && C.m_intent != MOVE_INTENT_WALK)
			return FALSE

/obj/structure/holosign/barrier/engineering
	icon_state = "holosign_engi"
	rad_insulation = RAD_LIGHT_INSULATION

/obj/structure/holosign/barrier/atmos
	name = "porte anti-feu holographique"
	desc = "Une barrière holographique ressemblant à une porte anti-feu. Bien qu'elle n'empêche pas les objets solides de passer, le gaz est maintenu à l'extérieur."
	icon_state = "holo_firelock"
	density = FALSE
	anchored = TRUE
	can_atmos_pass = ATMOS_PASS_NO
	alpha = 150
	rad_insulation = RAD_LIGHT_INSULATION
	resistance_flags = FIRE_PROOF | FREEZE_PROOF

/obj/structure/holosign/barrier/atmos/sturdy
	name = "porte anti-feu holographique solide"
	max_integrity = 150

/obj/structure/holosign/barrier/atmos/tram
	name = "barrière de tram atmosphérique"
	max_integrity = 150
	icon_state = "holo_tram"

/obj/structure/holosign/barrier/atmos/Initialize(mapload)
	. = ..()
	air_update_turf(TRUE, TRUE)
	AddElement(/datum/element/trait_loc, TRAIT_FIREDOOR_STOP)

/obj/structure/holosign/barrier/atmos/block_superconductivity() //Didn't used to do this, but it's "normal", and will help ease heat flow transitions with the players.
	return TRUE

/obj/structure/holosign/barrier/atmos/Destroy()
	air_update_turf(TRUE, FALSE)
	return ..()

/obj/structure/holosign/barrier/cyborg
	name = "champ d'énergie"
	desc = "Un champ d'énergie fragile qui bloque le mouvement. Excellent pour bloquer les projectiles mortels."
	density = TRUE
	max_integrity = 10
	allow_walk = FALSE

/obj/structure/holosign/barrier/cyborg/bullet_act(obj/projectile/P)
	take_damage((P.damage / 5) , BRUTE, MELEE, 1) //Doesn't really matter what damage flag it is.
	if(istype(P, /obj/projectile/energy/electrode))
		take_damage(10, BRUTE, MELEE, 1) //Tasers aren't harmful.
	if(istype(P, /obj/projectile/beam/disabler))
		take_damage(5, BRUTE, MELEE, 1) //Disablers aren't harmful.
	return BULLET_ACT_HIT

/obj/structure/holosign/barrier/medical
	name = "\improper barrière holographique LUMISTYLO"
	desc = "Une barrière holographique qui utilise la biométrie pour détecter les virus humains. Refuse le passage au personnel avec des virus malveillants facilement détectables. Bon pour les quarantaines."
	icon_state = "holo_medical"
	alpha = 125 //lazy :)
	var/force_allaccess = FALSE
	var/buzzcd = 0

/obj/structure/holosign/barrier/medical/examine(mob/user)
	. = ..()
	. += span_notice("Le statut de scanneur biométrique est : <b>[force_allaccess ? "off" : "on"]</b>.")

/obj/structure/holosign/barrier/medical/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(force_allaccess)
		return TRUE
	if(istype(mover, /obj/vehicle/ridden))
		for(var/M in mover.buckled_mobs)
			if(ishuman(M))
				if(!CheckHuman(M))
					return FALSE
	if(ishuman(mover))
		return CheckHuman(mover)
	return TRUE

/obj/structure/holosign/barrier/medical/Bumped(atom/movable/AM)
	. = ..()
	icon_state = "holo_medical"
	if(ishuman(AM) && !CheckHuman(AM))
		if(buzzcd < world.time)
			playsound(get_turf(src),'sound/machines/buzz-sigh.ogg',65,TRUE,4)
			buzzcd = (world.time + 60)
		icon_state = "holo_medical-deny"

/obj/structure/holosign/barrier/medical/proc/CheckHuman(mob/living/carbon/human/sickboi)
	var/threat = sickboi.check_virus()
	if(get_disease_severity_value(threat) > get_disease_severity_value(DISEASE_SEVERITY_MINOR))
		return FALSE
	return TRUE

/obj/structure/holosign/barrier/medical/attack_hand(mob/living/user, list/modifiers)
	if(!user.combat_mode && CanPass(user, get_dir(src, user)))
		force_allaccess = !force_allaccess
		to_chat(user, span_warning("Vous [force_allaccess ? "désactivez" : "activatez"] le scanneur biométrique.")) //warning spans because you can make the station sick!
	else
		return ..()

/obj/structure/holosign/barrier/cyborg/hacked
	name = "champ d'énergie chargé"
	desc = "Un champ d'énergie puissant qui bloque le mouvement. De l'énergie en jaillit."
	max_integrity = 20
	var/shockcd = 0

/obj/structure/holosign/barrier/cyborg/hacked/bullet_act(obj/projectile/P)
	take_damage(P.damage, BRUTE, MELEE, 1) //Yeah no this doesn't get projectile resistance.
	return BULLET_ACT_HIT

/obj/structure/holosign/barrier/cyborg/hacked/proc/cooldown()
	shockcd = FALSE

/obj/structure/holosign/barrier/cyborg/hacked/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!shockcd)
		if(ismob(user))
			var/mob/living/M = user
			M.electrocute_act(15,"Barrière d'énergie")
			shockcd = TRUE
			addtimer(CALLBACK(src, PROC_REF(cooldown)), 5)

/obj/structure/holosign/barrier/cyborg/hacked/Bumped(atom/movable/AM)
	if(shockcd)
		return

	if(!ismob(AM))
		return

	var/mob/living/M = AM
	M.electrocute_act(15,"Barrière d'énergie")
	shockcd = TRUE
	addtimer(CALLBACK(src, PROC_REF(cooldown)), 5)
