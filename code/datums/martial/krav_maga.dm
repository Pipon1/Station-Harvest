/datum/martial_art/krav_maga
	name = "Krav Maga"
	id = MARTIALART_KRAVMAGA
	var/datum/action/neck_chop/neckchop = new/datum/action/neck_chop()
	var/datum/action/leg_sweep/legsweep = new/datum/action/leg_sweep()
	var/datum/action/lung_punch/lungpunch = new/datum/action/lung_punch()

/datum/action/neck_chop
	name = "Coup à la nuque - Blesse la nuque, empêchant la victime de parler pendant un certain temps."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "neckchop"

/datum/action/neck_chop/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("Vous ne pouvez pas utiliser le [name] pendant que vous êtes incapacité."))
		return
	if (owner.mind.martial_art.streak == "neck_chop")
		owner.visible_message(span_danger("[owner] prend une posture neutre."), "<b><i>Votre prochaine attaque sera normal.</i></b>")
		owner.mind.martial_art.streak = ""
	else
		owner.visible_message(span_danger("[owner] prend la position du coup à la nuque !"), "<b><i>Votre prochaine attaque sera un coup à la nuque.</i></b>")
		owner.mind.martial_art.streak = "neck_chop"

/datum/action/leg_sweep
	name = "Balayette - Fait trébucher la victime, la faisant tomber pendant un bref instant."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "legsweep"

/datum/action/leg_sweep/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("Vous ne pouvez pas utiliser la [name] pendant que vous êtes incapacité."))
		return
	if (owner.mind.martial_art.streak == "leg_sweep")
		owner.visible_message(span_danger("[owner] prend une posture neutre."), "<b><i>Votre prochaine attaque sera normal.</i></b>")
		owner.mind.martial_art.streak = ""
	else
		owner.visible_message(span_danger("[owner] prend une posture de balayette."), "<b><i>Votre prochaine attaque sera une balayette.</i></b>")
		owner.mind.martial_art.streak = "leg_sweep"

/datum/action/lung_punch//referred to internally as 'quick choke'
	name = "Coup au poumon - Donne un coup de poing fort juste au-dessus de l'abdomen de la victime, contraignant les poumons. La victime sera incapable de respirer pendant un court instant."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "lungpunch"

/datum/action/lung_punch/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("Vous ne pouvez pas utiliser le [name] pendant que vous êtes incapacité."))
		return
	if (owner.mind.martial_art.streak == "quick_choke")
		owner.visible_message(span_danger("[owner] prend une posture neutre."), "<b><i>Votre prochaine attaque sera normal.</i></b>")
		owner.mind.martial_art.streak = ""
	else
		owner.visible_message(span_danger("[owner] prend une posture de coup au poumon."), "<b><i>Votre prochaine attaque sera un coup au poumon.</i></b>")
		owner.mind.martial_art.streak = "quick_choke"//internal name for lung punch

/datum/martial_art/krav_maga/teach(mob/living/owner, make_temporary=FALSE)
	if(..())
		to_chat(owner, span_userdanger("Vous connaissez l'art du [name] !"))
		to_chat(owner, span_danger("Placez votre curseur sur un coup en haut de l'écran pour voir ce qu'il fait."))
		neckchop.Grant(owner)
		legsweep.Grant(owner)
		lungpunch.Grant(owner)

/datum/martial_art/krav_maga/on_remove(mob/living/owner)
	to_chat(owner, span_userdanger("Vous oubliez soudainement l'art du [name]..."))
	neckchop.Remove(owner)
	legsweep.Remove(owner)
	lungpunch.Remove(owner)

/datum/martial_art/krav_maga/proc/check_streak(mob/living/attacker, mob/living/defender)
	switch(streak)
		if("neck_chop")
			streak = ""
			neck_chop(attacker, defender)
			return TRUE
		if("leg_sweep")
			streak = ""
			leg_sweep(attacker, defender)
			return TRUE
		if("quick_choke")//is actually lung punch
			streak = ""
			quick_choke(attacker, defender)
			return TRUE
	return FALSE

/datum/martial_art/krav_maga/proc/leg_sweep(mob/living/attacker, mob/living/defender)
	if(defender.stat || defender.IsParalyzed())
		return FALSE
	defender.visible_message(span_warning("[attacker] fait une balayettee à [defender] !"), \
					span_userdanger("Vous vous faites balayez par  [attacker] !"), span_hear("Vous entendez le sons dégoutant d'un membre contre un membre !"), null, attacker)
	to_chat(attacker, span_danger("You leg sweep [defender]!"))
	playsound(get_turf(attacker), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	defender.apply_damage(5, BRUTE, BODY_ZONE_CHEST)
	defender.Knockdown(6 SECONDS)
	log_combat(attacker, defender, "leg sweeped")
	return TRUE

/datum/martial_art/krav_maga/proc/quick_choke(mob/living/attacker, mob/living/defender)//is actually lung punch
	defender.visible_message(span_warning("[attacker] frappe [defender] sur le torse !"), \
					span_userdanger("Votre torse est frappé par [attacker] ! Vous ne pouvez plus respirer !"), span_hear("Vous entendez le sons dégoutant d'un membre contre un membre !"), COMBAT_MESSAGE_RANGE, attacker)
	to_chat(attacker, span_danger("Vous frappez [defender] sur le torse !"))
	playsound(get_turf(attacker), 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	if(defender.losebreath <= 10)
		defender.losebreath = clamp(defender.losebreath + 5, 0, 10)
	defender.adjustOxyLoss(10)
	log_combat(attacker, defender, "quickchoked")
	return TRUE

/datum/martial_art/krav_maga/proc/neck_chop(mob/living/attacker, mob/living/defender)
	defender.visible_message(span_warning("[attacker] frappe la nuque de [defender] !"), \
					span_userdanger("Votre nuque est frappé par [attacker], vous empêchant de parler !"), span_hear("Vous entendez le sons dégoutant d'un membre contre un membre !"), COMBAT_MESSAGE_RANGE, attacker)
	to_chat(attacker, span_danger("Vous frappez la nuque de [defender], empêchant [defender.p_them()] de parler !"))
	playsound(get_turf(attacker), 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	defender.apply_damage(10, attacker.get_attack_type(), BODY_ZONE_HEAD)
	defender.adjust_silence_up_to(20 SECONDS, 20 SECONDS)
	log_combat(attacker, defender, "neck chopped")
	return TRUE

/datum/martial_art/krav_maga/grab_act(mob/living/attacker, mob/living/defender)
	if(check_streak(attacker, defender))
		return TRUE
	log_combat(attacker, defender, "grabbed (Krav Maga)")
	..()

/datum/martial_art/krav_maga/harm_act(mob/living/attacker, mob/living/defender)
	if(check_streak(attacker, defender))
		return TRUE
	log_combat(attacker, defender, "punched")
	var/obj/item/bodypart/affecting = defender.get_bodypart(defender.get_random_valid_zone(attacker.zone_selected))
	var/picked_hit_type = pick("punch", "kick")
	var/bonus_damage = 0
	if(defender.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = "stomp"
	defender.apply_damage(10 + bonus_damage, attacker.get_attack_type(), affecting)
	if(picked_hit_type == "kick" || picked_hit_type == "stomp")
		attacker.do_attack_animation(defender, ATTACK_EFFECT_KICK)
		playsound(get_turf(defender), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	else
		attacker.do_attack_animation(defender, ATTACK_EFFECT_PUNCH)
		playsound(get_turf(defender), 'sound/effects/hit_punch.ogg', 50, TRUE, -1)
	defender.visible_message(span_danger("[attacker] [picked_hit_type]s [defender]!"), \
					span_userdanger("You're [picked_hit_type]ed by [attacker]!"), span_hear("Vous entendez le sons dégoutant d'un membre contre un membre !"), COMBAT_MESSAGE_RANGE, attacker)
	to_chat(attacker, span_danger("You [picked_hit_type] [defender]!"))
	log_combat(attacker, defender, "[picked_hit_type] with [name]")
	return TRUE

/datum/martial_art/krav_maga/disarm_act(mob/living/attacker, mob/living/defender)
	if(check_streak(attacker, defender))
		return TRUE
	var/obj/item/stuff_in_hand = null
	stuff_in_hand = defender.get_active_held_item()
	if(prob(60) && stuff_in_hand)
		if(defender.temporarilyRemoveItemFromInventory(stuff_in_hand))
			attacker.put_in_hands(stuff_in_hand)
			defender.visible_message("<span class='danger'>[attacker] désarme [defender] !</span>", \
				"<span class='userdanger'>Vous êtes désarmé par [attacker] !</span>", "<span class='hear'>Vous entendez un son aggressif !</span>", COMBAT_MESSAGE_RANGE, attacker)
			to_chat(attacker, "<span class='danger'>Vous désarmez [defender] !</span>")
			playsound(defender, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
	log_combat(attacker, defender, "shoved (Krav Maga)", "[stuff_in_hand ? " removing \the [stuff_in_hand]" : ""]")
	return FALSE

//Krav Maga Gloves

/obj/item/clothing/gloves/krav_maga
	var/datum/martial_art/krav_maga/style = new

/obj/item/clothing/gloves/krav_maga/equipped(mob/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_GLOVES)
		style.teach(user, TRUE)

/obj/item/clothing/gloves/krav_maga/dropped(mob/user)
	. = ..()
	if(user.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
		style.remove(user)

/obj/item/clothing/gloves/krav_maga/sec//more obviously named, given to sec
	name = "gants de krav maga"
	desc = "Ces gants vous apprendront l'art du Krav Maga grâce à des nano puces."
	icon_state = "fightgloves"
	greyscale_colors = "#c41e0d"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE

/obj/item/clothing/gloves/krav_maga/combatglovesplus
	name = "gants de combat amélioré"
	desc = "Ces gants tactiques sont ignifuges et isolés électriquement, et grâce à la technologie de nano puces, ils vous apprendront l'art martial du krav maga."
	icon_state = "black"
	greyscale_colors = "#2f2e31"
	siemens_coefficient = 0
	strip_delay = 80
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor_type = /datum/armor/krav_maga_combatglovesplus

/datum/armor/krav_maga_combatglovesplus
	bio = 90
	fire = 80
	acid = 50
