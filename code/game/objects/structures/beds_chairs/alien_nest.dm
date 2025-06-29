//Alium nests. Essentially beds with an unbuckle delay that only aliums can buckle mobs to.

/obj/structure/bed/nest
	name = "nid d'extraterestre"
	desc = "C'est un tas dégoutant d'une épaisse résine, formée pour ressembler à un nid."
	icon = 'icons/obj/smooth_structures/alien/nest.dmi'
	icon_state = "nest-0"
	base_icon_state = "nest"
	max_integrity = 120
	can_be_unanchored = FALSE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_ALIEN_NEST
	canSmoothWith = SMOOTH_GROUP_ALIEN_NEST
	buildstacktype = null
	flags_1 = NODECONSTRUCT_1
	bolts = FALSE
	var/static/mutable_appearance/nest_overlay = mutable_appearance('icons/mob/nonhuman-player/alien.dmi', "nestoverlay", LYING_MOB_LAYER)

/obj/structure/bed/nest/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	if(has_buckled_mobs())
		for(var/buck in buckled_mobs) //breaking a nest releases all the buckled mobs, because the nest isn't holding them down anymore
			var/mob/living/M = buck

			if(user.get_organ_by_type(/obj/item/organ/internal/alien/plasmavessel))
				unbuckle_mob(M)
				add_fingerprint(user)
				return

			if(M != user)
				M.visible_message(span_notice("[user.name] libère [M.name] de l'emprise de la résine !"),\
					span_notice("[user.name] vous libère de l'emprise de la résine."),\
					span_hear("Vous entendez des bruits humide..."))
			else
				M.visible_message(span_warning("[M.name] se débat pour se libérer de la résine !"),\
					span_notice("Vous vous débatez pour vous libérer de la résine... (Ne bougez pas pour environ 1m30.)"),\
					span_hear("Vous entendez des bruits humide..."))
				if(!do_after(M, 100 SECONDS, target = src))
					if(M?.buckled)
						to_chat(M, span_warning("Vous n'avez pas réussi à vous libérer !"))
					return
				if(!M.buckled)
					return
				M.visible_message(span_warning("[M.name] se libère de la résine !"),\
					span_notice("Vous vous libérez de la résine !"),\
					span_hear("Vous entendez des bruits humide..."))


			unbuckle_mob(M)
			add_fingerprint(user)

/obj/structure/bed/nest/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.incapacitated() || M.buckled )
		return

	if(M.get_organ_by_type(/obj/item/organ/internal/alien/plasmavessel))
		return
	if(!user.get_organ_by_type(/obj/item/organ/internal/alien/plasmavessel))
		return

	if(has_buckled_mobs())
		unbuckle_all_mobs()

	if(buckle_mob(M))
		M.visible_message(span_notice("[user.name] sécrète un liquide épais et horrible, sécurisant [M.name] dans lae [src] !"),\
			span_danger("[user.name] vous couvre avec de la résine puante, vous coinçant dans lae [src] !"),\
			span_hear("Vous entendez des bruits humide..."))

/obj/structure/bed/nest/post_buckle_mob(mob/living/M)
	ADD_TRAIT(M, TRAIT_HANDS_BLOCKED, type)
	M.pixel_y = M.base_pixel_y
	M.pixel_x = M.base_pixel_x + 2
	M.layer = BELOW_MOB_LAYER
	add_overlay(nest_overlay)

	if(ishuman(M))
		var/mob/living/carbon/human/victim = M
		if(((victim.wear_mask && istype(victim.wear_mask, /obj/item/clothing/mask/facehugger)) || HAS_TRAIT(victim, TRAIT_XENO_HOST)) && victim.stat != DEAD) //If they're a host or have a facehugger currently infecting them. Must be alive.
			victim.apply_status_effect(/datum/status_effect/nest_sustenance)

/obj/structure/bed/nest/post_unbuckle_mob(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_HANDS_BLOCKED, type)
	M.pixel_x = M.base_pixel_x + M.body_position_pixel_x_offset
	M.pixel_y = M.base_pixel_y + M.body_position_pixel_y_offset
	M.layer = initial(M.layer)
	cut_overlay(nest_overlay)
	M.remove_status_effect(/datum/status_effect/nest_sustenance)

/obj/structure/bed/nest/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(loc, 'sound/effects/attackblob.ogg', 100, TRUE)
		if(BURN)
			playsound(loc, 'sound/items/welder.ogg', 100, TRUE)

/obj/structure/bed/nest/attack_alien(mob/living/carbon/alien/user, list/modifiers)
	if(!user.combat_mode)
		return attack_hand(user, modifiers)
	else
		return ..()
