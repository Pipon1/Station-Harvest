/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * Beds
 * Roller beds
 */

/*
 * Beds
 */
/obj/structure/bed
	name = "lit"
	desc = "C'est lit est utilisé pour se coucher, pour dormir ou pour s'attacher." //kinky
	icon_state = "bed"
	icon = 'icons/obj/objects.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	resistance_flags = FLAMMABLE
	max_integrity = 100
	integrity_failure = 0.35
	var/buildstacktype = /obj/item/stack/sheet/iron
	var/buildstackamount = 2
	var/bolts = TRUE

/obj/structure/bed/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/soft_landing)

/obj/structure/bed/examine(mob/user)
	. = ..()
	if(bolts)
		. += span_notice("Ce lit tient grace à quelques <b>écrous</b>.")

/obj/structure/bed/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
	..()

/obj/structure/bed/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/bed/wrench_act_secondary(mob/living/user, obj/item/weapon)
	if(flags_1&NODECONSTRUCT_1)
		return TRUE
	..()
	weapon.play_tool_sound(src)
	deconstruct(disassembled = TRUE)
	return TRUE

/*
 * Roller beds
 */
/obj/structure/bed/roller
	name = "lit à roulette"
	icon = 'icons/obj/medical/rollerbed.dmi'
	icon_state = "down"
	anchored = FALSE
	resistance_flags = NONE
	///The item it spawns when it's folded up.
	var/foldabletype = /obj/item/roller

/obj/structure/bed/roller/Initialize(mapload)
	. = ..()
	AddElement( \
		/datum/element/contextual_screentip_bare_hands, \
		rmb_text = "Plier", \
	)

/obj/structure/bed/roller/examine(mob/user)
	. = ..()
	. += span_notice("Vous pouvez le plier avec le clique-droit.")

/obj/structure/bed/roller/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/roller/robo))
		var/obj/item/roller/robo/R = W
		if(R.loaded)
			to_chat(user, span_warning("Vous déja un lit à roulette de parquer !"))
			return

		if(has_buckled_mobs())
			if(buckled_mobs.len > 1)
				unbuckle_all_mobs()
				user.visible_message(span_notice("[user] détache toutes les créatures attachées au [src]."))
			else
				user_unbuckle_mob(buckled_mobs[1],user)
		else
			R.loaded = src
			forceMove(R)
			user.visible_message(span_notice("[user] ramasse le [src]."), span_notice("Vous ramassez le [src]."))
		return 1
	else
		return ..()

/obj/structure/bed/roller/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!ishuman(user) || !user.can_perform_action(src))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(has_buckled_mobs())
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	user.visible_message(span_notice("[user] plie le [src]."), span_notice("Vous pliez le [src]."))
	var/obj/structure/bed/roller/folding_bed = new foldabletype(get_turf(src))
	user.put_in_hands(folding_bed)
	qdel(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/bed/roller/post_buckle_mob(mob/living/M)
	set_density(TRUE)
	icon_state = "up"
	//Push them up from the normal lying position
	M.pixel_y = M.base_pixel_y

/obj/structure/bed/roller/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(has_gravity())
		playsound(src, 'sound/effects/roll.ogg', 100, TRUE)


/obj/structure/bed/roller/post_unbuckle_mob(mob/living/M)
	set_density(FALSE)
	icon_state = "down"
	//Set them back down to the normal lying position
	M.pixel_y = M.base_pixel_y + M.body_position_pixel_y_offset


/obj/item/roller
	name = "lit à roulette"
	desc = "Un lit à roulette plié qui peut être porté."
	icon = 'icons/obj/medical/rollerbed.dmi'
	icon_state = "folded"
	w_class = WEIGHT_CLASS_NORMAL // No more excuses, stop getting blood everywhere

/obj/item/roller/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/roller/robo))
		var/obj/item/roller/robo/R = I
		if(R.loaded)
			to_chat(user, span_warning("[R] a déja un lit à roulette de charger !"))
			return
		user.visible_message(span_notice("[user] charge le [src]."), span_notice("Vous chargez le [src] dans [R]."))
		R.loaded = new/obj/structure/bed/roller(R)
		qdel(src) //"Load"
		return
	else
		return ..()

/obj/item/roller/attack_self(mob/user)
	deploy_roller(user, user.loc)

/obj/item/roller/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(isopenturf(target))
		deploy_roller(user, target)

/obj/item/roller/proc/deploy_roller(mob/user, atom/location)
	var/obj/structure/bed/roller/R = new /obj/structure/bed/roller(location)
	R.add_fingerprint(user)
	qdel(src)

/obj/item/roller/robo //ROLLER ROBO DA!
	name = "port pour lit à roulette"
	desc = "Un lit à roulette plié qui peut être éjecté pour des urgences."
	var/obj/structure/bed/roller/loaded = null

/obj/item/roller/robo/Initialize(mapload)
	. = ..()
	loaded = new(src)

/obj/item/roller/robo/examine(mob/user)
	. = ..()
	. += "Le port est [loaded ? "remplie" : "vide"]."

/obj/item/roller/robo/deploy_roller(mob/user, atom/location)
	if(loaded)
		loaded.forceMove(location)
		user.visible_message(span_notice("[user] déploie le [loaded]."), span_notice("Vous déployez le [loaded]."))
		loaded = null
	else
		to_chat(user, span_warning("Le port est vide !"))

//Dog bed

/obj/structure/bed/dogbed
	name = "coussin pour chien"
	icon_state = "dogbed"
	desc = "Un coussin pour chien qui à l'air vraiment comfortable. Vous pouvez même y attacher vos animaux de compagnie, dans le cas où la gravité artificielle s'éteindrait."
	anchored = FALSE
	buildstacktype = /obj/item/stack/sheet/mineral/wood
	buildstackamount = 10
	var/owned = FALSE

/obj/structure/bed/dogbed/ian
	desc = "Le lit de Ian ! Il a l'air comfortable."
	name = "lit de Ian"
	anchored = TRUE

/obj/structure/bed/dogbed/cayenne
	desc = "Il semble avoir anguille sous-roche..."
	name = "lit de Cayenne"
	anchored = TRUE

/obj/structure/bed/dogbed/lia
	desc = "Il semble avoir anguille sous-roche..."
	name = "lit de Lia"
	anchored = TRUE

/obj/structure/bed/dogbed/renault
	desc = "Le lit de Renault ! Il a l'air comfortable. Une personne sournoise à besoin d'un animal sournois."
	name = "lit de Renault"
	anchored = TRUE

/obj/structure/bed/dogbed/mcgriff
	desc = "Le lit de McGriff, car même les combatants du crime ont besoin de temps en temps d'une sieste."
	name = "lit de McGriff"

/obj/structure/bed/dogbed/runtime
	desc = "Un coussin pour chat qui à l'air comfortable. Vous pouvez même y attacher vos animaux de compagnie, dans le cas où la gravité artificielle s'éteindrait."
	name = "lit de Runtime"
	anchored = TRUE

///Used to set the owner of a dogbed, returns FALSE if called on an owned bed or an invalid one, TRUE if the possesion succeeds
/obj/structure/bed/dogbed/proc/update_owner(mob/living/M)
	if(owned || type != /obj/structure/bed/dogbed) //Only marked beds work, this is hacky but I'm a hacky man
		return FALSE //Failed
	owned = TRUE
	name = "lit de [M]"
	desc = "Le lit de [M] ! Il à l'air comfortable."
	return TRUE //Let any callers know that this bed is ours now

/obj/structure/bed/dogbed/buckle_mob(mob/living/M, force, check_loc)
	. = ..()
	update_owner(M)

/obj/structure/bed/maint
	name = "matelas sale"
	desc = "Un vieux matelas sale. Vous essayez de pas trop penser à ce qui a pu faire ces tâches."
	icon_state = "dirty_mattress"

/obj/structure/bed/maint/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOLD, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 25)

//Double Beds, for luxurious sleeping, i.e. the captain and maybe heads- if people use this for ERP, send them to skyrat
/obj/structure/bed/double
	name = "lit double"
	desc = "Un lit double luxieux, pour ceux trop important pour avoir des petits rêves."
	icon_state = "bed_double"
	buildstackamount = 4
	max_buckled_mobs = 2
	///The mob who buckled to this bed second, to avoid other mobs getting pixel-shifted before he unbuckles.
	var/mob/living/goldilocks

/obj/structure/bed/double/post_buckle_mob(mob/living/target)
	if(buckled_mobs.len > 1 && !goldilocks) //Push the second buckled mob a bit higher from the normal lying position
		target.pixel_y = target.base_pixel_y + 6
		goldilocks = target

/obj/structure/bed/double/post_unbuckle_mob(mob/living/target)
	target.pixel_y = target.base_pixel_y + target.body_position_pixel_y_offset
	if(target == goldilocks)
		goldilocks = null
