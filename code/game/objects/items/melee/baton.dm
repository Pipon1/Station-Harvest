/obj/item/melee/baton
	name = "bâton de police"
	desc = "Un bâton en bois pour tabasser les criminels."
	desc_controls = "Clique gauche pour paralyser, clique droit pour blesser."
	icon = 'icons/obj/weapons/baton.dmi'
	icon_state = "classic_baton"
	inhand_icon_state = "classic_baton"
	worn_icon_state = "classic_baton"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 12 //9 hit crit
	w_class = WEIGHT_CLASS_NORMAL
	wound_bonus = 15

	/// Whether this baton is active or not
	var/active = TRUE
	/// Used interally, you don't want to modify
	var/cooldown_check = 0
	/// Default wait time until can stun again.
	var/cooldown = (4 SECONDS)
	/// The length of the knockdown applied to a struck living, non-cyborg mob.
	var/knockdown_time = (1.5 SECONDS)
	/// If affect_cyborg is TRUE, this is how long we stun cyborgs for on a hit.
	var/stun_time_cyborg = (5 SECONDS)
	/// The length of the knockdown applied to the user on clumsy_check()
	var/clumsy_knockdown_time = 18 SECONDS
	/// How much stamina damage we deal on a successful hit against a living, non-cyborg mob.
	var/stamina_damage = 55
	/// Chance of causing force_say() when stunning a human mob
	var/force_say_chance = 33
	/// Can we stun cyborgs?
	var/affect_cyborg = FALSE
	/// The path of the default sound to play when we stun something.
	var/on_stun_sound = 'sound/effects/woodhit.ogg'
	/// The volume of the above.
	var/on_stun_volume = 75
	/// Do we animate the "hit" when stunning something?
	var/stun_animation = TRUE
	/// Whether the stun attack is logged. Only relevant for abductor batons, which have different modes.
	var/log_stun_attack = TRUE
	/// Boolean on whether people with chunky fingers can use this baton.
	var/chunky_finger_usable = FALSE

	/// The context to show when the baton is active and targetting a living thing
	var/context_living_target_active = "Stun"

	/// The context to show when the baton is active and targetting a living thing in combat mode
	var/context_living_target_active_combat_mode = "Stun"

	/// The context to show when the baton is inactive and targetting a living thing
	var/context_living_target_inactive = "Prod"

	/// The context to show when the baton is inactive and targetting a living thing in combat mode
	var/context_living_target_inactive_combat_mode = "Attack"

	/// The RMB context to show when the baton is active and targetting a living thing
	var/context_living_rmb_active = "Attack"

	/// The RMB context to show when the baton is inactive and targetting a living thing
	var/context_living_rmb_inactive = "Attack"

/obj/item/melee/baton/Initialize(mapload)
	. = ..()
	// Adding an extra break for the sake of presentation
	if(stamina_damage != 0)
		offensive_notes = "Il faudra taper [span_warning("[CEILING(100 / stamina_damage, 1)] fois")] pour paralyser un ennemi."

	register_item_context()

/**
 * Ok, think of baton attacks like a melee attack chain:
 *
 * [/baton_attack()] comes first. It checks if the user is clumsy, if the target parried the attack and handles some messages and sounds.
 * * Depending on its return value, it'll either do a normal attack, continue to the next step or stop the attack.
 *
 * [/finalize_baton_attack()] is then called. It handles logging stuff, sound effects and calls baton_effect().
 * * The proc is also called in other situations such as stunbatons right clicking or throw impact. Basically when baton_attack()
 * * checks are either redundant or unnecessary.
 *
 * [/baton_effect()] is third in the line. It knockdowns targets, along other effects called in additional_effects_cyborg() and
 * * additional_effects_non_cyborg().
 *
 * Last but not least [/set_batoned()], which gives the target the IWASBATONED trait with REF(user) as source and then removes it
 * * after a cooldown has passed. Basically, it stops users from cheesing the cooldowns by dual wielding batons.
 *
 * TL;DR: [/baton_attack()] -> [/finalize_baton_attack()] -> [/baton_effect()] -> [/set_batoned()]
 */
/obj/item/melee/baton/attack(mob/living/target, mob/living/user, params)
	add_fingerprint(user)
	var/list/modifiers = params2list(params)
	switch(baton_attack(target, user, modifiers))
		if(BATON_DO_NORMAL_ATTACK)
			return ..()
		if(BATON_ATTACKING)
			finalize_baton_attack(target, user, modifiers)

/obj/item/melee/baton/add_item_context(datum/source, list/context, atom/target, mob/living/user)
	if (isturf(target))
		return NONE

	if (isobj(target))
		context[SCREENTIP_CONTEXT_LMB] = "Attack"
	else
		if (active)
			context[SCREENTIP_CONTEXT_RMB] = context_living_rmb_active

			if (user.combat_mode)
				context[SCREENTIP_CONTEXT_LMB] = context_living_target_active_combat_mode
			else
				context[SCREENTIP_CONTEXT_LMB] = context_living_target_active
		else
			context[SCREENTIP_CONTEXT_RMB] = context_living_rmb_inactive

			if (user.combat_mode)
				context[SCREENTIP_CONTEXT_LMB] = context_living_target_inactive_combat_mode
			else
				context[SCREENTIP_CONTEXT_LMB] = context_living_target_inactive

	return CONTEXTUAL_SCREENTIP_SET

/obj/item/melee/baton/proc/baton_attack(mob/living/target, mob/living/user, modifiers)
	. = BATON_ATTACKING

	if(clumsy_check(user, target))
		return BATON_ATTACK_DONE

	if(!chunky_finger_usable && ishuman(user))
		var/mob/living/carbon/human/potential_chunky_finger_human = user
		if(potential_chunky_finger_human.check_chunky_fingers() && user.is_holding(src))
			balloon_alert(potential_chunky_finger_human, "Vos doigts sont trop gros !")
			return BATON_ATTACK_DONE

	if(!active || LAZYACCESS(modifiers, RIGHT_CLICK))
		return BATON_DO_NORMAL_ATTACK

	if(cooldown_check > world.time)
		var/wait_desc = get_wait_description()
		if (wait_desc)
			to_chat(user, wait_desc)
		return BATON_ATTACK_DONE

	if(check_parried(target, user))
		return BATON_ATTACK_DONE

	if(HAS_TRAIT_FROM(target, TRAIT_IWASBATONED, REF(user))) //no doublebaton abuse anon!
		to_chat(user, span_danger("Vous râter [target] !"))
		return BATON_ATTACK_DONE

	if(stun_animation)
		user.do_attack_animation(target)

	var/list/desc

	if(iscyborg(target))
		if(affect_cyborg)
			desc = get_cyborg_stun_description(target, user)
		else
			desc = get_unga_dunga_cyborg_stun_description(target, user)
			playsound(get_turf(src), 'sound/effects/bang.ogg', 10, TRUE) //bonk
			. = BATON_ATTACK_DONE
	else
		desc = get_stun_description(target, user)

	if(desc)
		target.visible_message(desc["visible"], desc["local"])

/obj/item/melee/baton/proc/check_parried(mob/living/carbon/human/human_target, mob/living/user)
	if(!ishuman(human_target))
		return
	if (human_target.check_shields(src, 0, "[user]'s [name]", MELEE_ATTACK))
		playsound(human_target, 'sound/weapons/genhit.ogg', 50, TRUE)
		return TRUE
	if(check_martial_counter(human_target, user))
		return TRUE

/obj/item/melee/baton/proc/finalize_baton_attack(mob/living/target, mob/living/user, modifiers, in_attack_chain = TRUE)
	if(!in_attack_chain && HAS_TRAIT_FROM(target, TRAIT_IWASBATONED, REF(user)))
		return BATON_ATTACK_DONE

	cooldown_check = world.time + cooldown
	if(on_stun_sound)
		playsound(get_turf(src), on_stun_sound, on_stun_volume, TRUE, -1)
	if(user)
		target.lastattacker = user.real_name
		target.lastattackerckey = user.ckey
		target.LAssailant = WEAKREF(user)
		if(log_stun_attack)
			log_combat(user, target, "stun attacked", src)
	if(baton_effect(target, user, modifiers) && user)
		set_batoned(target, user, cooldown)

/obj/item/melee/baton/proc/baton_effect(mob/living/target, mob/living/user, modifiers, stun_override)
	var/trait_check = HAS_TRAIT(target, TRAIT_BATON_RESISTANCE)
	if(iscyborg(target))
		if(!affect_cyborg)
			return FALSE
		target.flash_act(affect_silicon = TRUE)
		target.Paralyze((isnull(stun_override) ? stun_time_cyborg : stun_override) * (trait_check ? 0.1 : 1))
		additional_effects_cyborg(target, user)
	else
		if(ishuman(target))
			var/mob/living/carbon/human/human_target = target
			if(prob(force_say_chance))
				human_target.force_say()
		target.apply_damage(stamina_damage, STAMINA)
		if(!trait_check)
			target.Knockdown((isnull(stun_override) ? knockdown_time : stun_override))
		additional_effects_non_cyborg(target, user)
	return TRUE

/// Description for trying to stun when still on cooldown.
/obj/item/melee/baton/proc/get_wait_description()
	return

/// Default message for stunning a living, non-cyborg mob.
/obj/item/melee/baton/proc/get_stun_description(mob/living/target, mob/living/user)
	. = list()

	.["visible"] = span_danger("[user] assomme [target] avec [src] !")
	.["local"] = span_userdanger("[user] vous assomme avec [src] !")

	return .

/// Default message for stunning a cyborg.
/obj/item/melee/baton/proc/get_cyborg_stun_description(mob/living/target, mob/living/user)
	. = list()

	.["visible"] = span_danger("[user] éléctrise les senseurs de [target] avec le bâton !")
	.["local"] = span_danger("Vous éléctrisez les senseurs de [target] avec le bâton !")

	return .

/// Default message for trying to stun a cyborg with a baton that can't stun cyborgs.
/obj/item/melee/baton/proc/get_unga_dunga_cyborg_stun_description(mob/living/target, mob/living/user)
	. = list()

	.["visible"] = span_danger("[user] essaye d'assommer [target] avec [src], et échoue de façon évidente !") //look at this duuuuuude
	.["local"] = span_userdanger("[user] essaye de... vous assommer avec [src] ?") //look at the top of his head!

	return .

/// Contains any special effects that we apply to living, non-cyborg mobs we stun. Does not include applying a knockdown, dealing stamina damage, etc.
/obj/item/melee/baton/proc/additional_effects_non_cyborg(mob/living/target, mob/living/user)
	return

/// Contains any special effects that we apply to cyborgs we stun. Does not include flashing the cyborg's screen, hardstunning them, etc.
/obj/item/melee/baton/proc/additional_effects_cyborg(mob/living/target, mob/living/user)
	return

/obj/item/melee/baton/proc/set_batoned(mob/living/target, mob/living/user, cooldown)
	if(!cooldown)
		return
	var/user_ref = REF(user) // avoids harddels.
	ADD_TRAIT(target, TRAIT_IWASBATONED, user_ref)
	addtimer(TRAIT_CALLBACK_REMOVE(target, TRAIT_IWASBATONED, user_ref), cooldown)

/obj/item/melee/baton/proc/clumsy_check(mob/living/user, mob/living/intented_target)
	if(!active || !HAS_TRAIT(user, TRAIT_CLUMSY) || prob(50))
		return FALSE
	user.visible_message(span_danger("[user] frappe  accidentellement [user.p_them()] sur la tête avec [src] ! Quel idiot !"), span_userdanger("Vous vous frappez sur la tête par accident [src] !"))

	if(iscyborg(user))
		if(affect_cyborg)
			user.flash_act(affect_silicon = TRUE)
			user.Paralyze(clumsy_knockdown_time)
			additional_effects_cyborg(user, user) // user is the target here
			if(on_stun_sound)
				playsound(get_turf(src), on_stun_sound, on_stun_volume, TRUE, -1)
		else
			playsound(get_turf(src), 'sound/effects/bang.ogg', 10, TRUE)
	else
		//straight up always force say for clumsy humans
		if(ishuman(user))
			var/mob/living/carbon/human/human_user = user
			human_user.force_say()
		user.Knockdown(clumsy_knockdown_time)
		user.apply_damage(stamina_damage, STAMINA)
		additional_effects_non_cyborg(user, user) // user is the target here
		if(on_stun_sound)
			playsound(get_turf(src), on_stun_sound, on_stun_volume, TRUE, -1)

	user.apply_damage(2*force, BRUTE, BODY_ZONE_HEAD)

	log_combat(user, user, "[user.p_them()] c'est accidentellement paralyser lui même en toute maladresse.", src)
	if(stun_animation)
		user.do_attack_animation(user)
	return

/obj/item/conversion_kit
	name = "kit de conversion"
	desc = "Une boîte étrange contenant des outils de menuiserie et un papier d'instruction pour transformer les bâtons de police en autre chose."
	icon = 'icons/obj/storage/box.dmi'
	icon_state = "uk"
	custom_price = PAYCHECK_COMMAND * 4.5

/obj/item/melee/baton/telescopic
	name = "bâton téléscopique"
	desc = "Une arme de défense personnelle compacte mais robuste. Peut être dissimulée lorsqu'elle est repliée."
	icon = 'icons/obj/weapons/baton.dmi'
	icon_state = "telebaton"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	inhand_icon_state = null
	attack_verb_continuous = list("hits", "pokes")
	attack_verb_simple = list("hit", "poke")
	worn_icon_state = "tele_baton"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NONE
	force = 0
	bare_wound_bonus = 5
	clumsy_knockdown_time = 15 SECONDS
	active = FALSE

	/// The sound effecte played when our baton is extended.
	var/on_sound = 'sound/weapons/batonextend.ogg'
	/// The inhand iconstate used when our baton is extended.
	var/on_inhand_icon_state = "nullrod"
	/// The force on extension.
	var/active_force = 10

/obj/item/melee/baton/telescopic/Initialize(mapload)
	. = ..()
	AddComponent(
		/datum/component/transforming, \
		force_on = active_force, \
		hitsound_on = hitsound, \
		w_class_on = WEIGHT_CLASS_NORMAL, \
		clumsy_check = FALSE, \
		attack_verb_continuous_on = list("frappe", "tappe", "fracasse", "tabasse"), \
		attack_verb_simple_on = list("frapper", "tapper", "fracasser", "tabasser"), \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/melee/baton/telescopic/suicide_act(mob/living/user)
	var/mob/living/carbon/human/human_user = user
	var/obj/item/organ/internal/brain/our_brain = human_user.get_organ_by_type(/obj/item/organ/internal/brain)

	user.visible_message(span_suicide("[user] enfonce [src] dans le nez de [user.p_their()] et appuie sur le bouton \"étendre\", il semble que [user.p_theyre()] essaye de vider l'esprit de [user.p_their()]."))
	if(active)
		playsound(src, on_sound, 50, TRUE)
		add_fingerprint(user)
	else
		attack_self(user)

	sleep(0.3 SECONDS)
	if (QDELETED(human_user))
		return
	if(!QDELETED(our_brain))
		human_user.organs -= our_brain
		qdel(our_brain)
	new /obj/effect/gibspawner/generic(human_user.drop_location(), human_user)
	return BRUTELOSS

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Gives feedback to the user and makes it show up inhand.
 */
/obj/item/melee/baton/telescopic/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	src.active = active
	inhand_icon_state = active ? on_inhand_icon_state : null // When inactive, there is no inhand icon_state.
	balloon_alert(user, active ? "étendu" : "rangée")
	playsound(user ? user : src, on_sound, 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/melee/baton/telescopic/contractor_baton
	name = "bâton de contracteur"
	desc = "Un bâton compact et spécialisé assigné aux contracteurs du syndicat. Applique des chocs électriques légers aux cibles."
	icon = 'icons/obj/weapons/baton.dmi'
	icon_state = "contractor_baton"
	worn_icon_state = "contractor_baton"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NONE
	force = 5
	cooldown = 2.5 SECONDS
	force_say_chance = 80 //very high force say chance because it's funny
	stamina_damage = 85
	clumsy_knockdown_time = 24 SECONDS
	affect_cyborg = TRUE
	on_stun_sound = 'sound/effects/contractorbatonhit.ogg'

	on_inhand_icon_state = "contractor_baton_on"
	on_sound = 'sound/weapons/contractorbatonextend.ogg'
	active_force = 16

/obj/item/melee/baton/telescopic/contractor_baton/get_wait_description()
	return span_danger("The baton is still charging!")

/obj/item/melee/baton/telescopic/contractor_baton/additional_effects_non_cyborg(mob/living/target, mob/living/user)
	target.set_jitter_if_lower(40 SECONDS)
	target.set_stutter_if_lower(40 SECONDS)

/obj/item/melee/baton/security
	name = "bâton électrique"
	desc = "Un bâton électrique pour neutraliser les gens."
	desc_controls = "Clique gauche pour paralyser, clique droit pour blesser."
	icon = 'icons/obj/weapons/baton.dmi'
	icon_state = "stunbaton"
	inhand_icon_state = "baton"
	worn_icon_state = "baton"
	force = 10
	wound_bonus = 0
	attack_verb_continuous = list("beats")
	attack_verb_simple = list("beat")
	armor_type = /datum/armor/baton_security
	throwforce = 7
	force_say_chance = 50
	stamina_damage = 60
	knockdown_time = 5 SECONDS
	clumsy_knockdown_time = 15 SECONDS
	cooldown = 2.5 SECONDS
	on_stun_sound = 'sound/weapons/egloves.ogg'
	on_stun_volume = 50
	active = FALSE
	context_living_rmb_active = "Harmful Stun"

	var/throw_stun_chance = 35
	var/obj/item/stock_parts/cell/cell
	var/preload_cell_type //if not empty the baton starts with this type of cell
	var/cell_hit_cost = 1000
	var/can_remove_cell = TRUE
	var/convertible = TRUE //if it can be converted with a conversion kit

/datum/armor/baton_security
	bomb = 50
	fire = 80
	acid = 80

/obj/item/melee/baton/security/Initialize(mapload)
	. = ..()
	if(preload_cell_type)
		if(!ispath(preload_cell_type, /obj/item/stock_parts/cell))
			log_mapping("[src] at [AREACOORD(src)] had an invalid preload_cell_type: [preload_cell_type].")
		else
			cell = new preload_cell_type(src)
	RegisterSignal(src, COMSIG_PARENT_ATTACKBY, PROC_REF(convert))
	update_appearance()

/obj/item/melee/baton/security/get_cell()
	return cell

/obj/item/melee/baton/security/suicide_act(mob/living/user)
	if(cell?.charge && active)
		user.visible_message(span_suicide("[user] place le [name] allumé dans la bouche de [user.p_their()] ! Il semble que [user.p_theyre()] essaye de se suicider !"))
		attack(user, user)
		return FIRELOSS
	else
		user.visible_message(span_suicide("[user] enfonce le [name] dans sa gorge ! Il semble que [user.p_theyre()] essaye de se suicider !"))
		return OXYLOSS

/obj/item/melee/baton/security/Destroy()
	if(cell)
		QDEL_NULL(cell)
	UnregisterSignal(src, COMSIG_PARENT_ATTACKBY)
	return ..()

/obj/item/melee/baton/security/proc/convert(datum/source, obj/item/item, mob/user)
	SIGNAL_HANDLER

	if(!istype(item, /obj/item/conversion_kit) || !convertible)
		return
	var/turf/source_turf = get_turf(src)
	var/obj/item/melee/baton/baton = new (source_turf)
	baton.alpha = 20
	playsound(source_turf, 'sound/items/drill_use.ogg', 80, TRUE, -1)
	animate(src, alpha = 0, time = 1 SECONDS)
	animate(baton, alpha = 255, time = 1 SECONDS)
	qdel(item)
	qdel(src)

/obj/item/melee/baton/security/Exited(atom/movable/mov_content)
	. = ..()
	if(mov_content == cell)
		cell.update_appearance()
		cell = null
		active = FALSE
		update_appearance()

/obj/item/melee/baton/security/update_icon_state()
	if(active)
		icon_state = "[initial(icon_state)]_active"
		return ..()
	if(!cell)
		icon_state = "[initial(icon_state)]_nocell"
		return ..()
	icon_state = "[initial(icon_state)]"
	return ..()

/obj/item/melee/baton/security/examine(mob/user)
	. = ..()
	if(cell)
		. += span_notice("\The [src] a [round(cell.percent())]% de charge.")
	else
		. += span_warning("\The [src] n'a pas de batterie installée.")

/obj/item/melee/baton/security/screwdriver_act(mob/living/user, obj/item/tool)
	if(tryremovecell(user))
		tool.play_tool_sound(src)
	return TRUE

/obj/item/melee/baton/security/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/stock_parts/cell))
		var/obj/item/stock_parts/cell/active_cell = item
		if(cell)
			to_chat(user, span_warning("[src] a déja une batterie !"))
		else
			if(active_cell.maxcharge < cell_hit_cost)
				to_chat(user, span_notice("[src] nécessite une batterie à plus haute capacité."))
				return
			if(!user.transferItemToLoc(item, src))
				return
			cell = item
			to_chat(user, span_notice("Vous installez une batterie dans [src]."))
			update_appearance()
	else
		return ..()

/obj/item/melee/baton/security/proc/tryremovecell(mob/user)
	if(cell && can_remove_cell)
		cell.forceMove(drop_location())
		to_chat(user, span_notice("Vous retirez une batterie de [src]."))
		return TRUE
	return FALSE

/obj/item/melee/baton/security/attack_self(mob/user)
	if(cell?.charge >= cell_hit_cost)
		active = !active
		balloon_alert(user, "appuie sur [active ? "on" : "off"]")
		playsound(src, SFX_SPARKS, 75, TRUE, -1)
	else
		active = FALSE
		if(!cell)
			balloon_alert(user, "aucune batterie !")
		else
			balloon_alert(user, "plus de batterie !")
	update_appearance()
	add_fingerprint(user)

/obj/item/melee/baton/security/proc/deductcharge(deducted_charge)
	if(!cell)
		return
	//Note this value returned is significant, as it will determine
	//if a stun is applied or not
	. = cell.use(deducted_charge)
	if(active && cell.charge < cell_hit_cost)
		//we're below minimum, turn off
		active = FALSE
		update_appearance()
		playsound(src, SFX_SPARKS, 75, TRUE, -1)

/obj/item/melee/baton/security/clumsy_check(mob/living/carbon/human/user)
	. = ..()
	if(.)
		SEND_SIGNAL(user, COMSIG_LIVING_MINOR_SHOCK)
		deductcharge(cell_hit_cost)

/// Handles prodding targets with turned off stunbatons and right clicking stun'n'bash
/obj/item/melee/baton/security/baton_attack(mob/living/target, mob/living/user, modifiers)
	. = ..()
	if(. != BATON_DO_NORMAL_ATTACK)
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(active && cooldown_check <= world.time && !check_parried(target, user))
			finalize_baton_attack(target, user, modifiers, in_attack_chain = FALSE)
	else if(!user.combat_mode)
		target.visible_message(span_warning("[user] tapote [target] avec [src]. Heuresement il était éteint."), \
			span_warning("[user] vous tapote avec [src]. Heuresement il était éteint."))
		return BATON_ATTACK_DONE

/obj/item/melee/baton/security/baton_effect(mob/living/target, mob/living/user, modifiers, stun_override)
	if(iscyborg(loc))
		var/mob/living/silicon/robot/robot = loc
		if(!robot || !robot.cell || !robot.cell.use(cell_hit_cost))
			return FALSE
	else if(!deductcharge(cell_hit_cost))
		return FALSE
	stun_override = 0 //Avoids knocking people down prematurely.
	return ..()

/*
 * After a target is hit, we apply some status effects.
 * After a period of time, we then check to see what stun duration we give.
 */
/obj/item/melee/baton/security/additional_effects_non_cyborg(mob/living/target, mob/living/user)
	target.set_jitter_if_lower(40 SECONDS)
	target.set_confusion_if_lower(10 SECONDS)
	target.set_stutter_if_lower(16 SECONDS)

	SEND_SIGNAL(target, COMSIG_LIVING_MINOR_SHOCK)
	addtimer(CALLBACK(src, PROC_REF(apply_stun_effect_end), target), 2 SECONDS)

/// After the initial stun period, we check to see if the target needs to have the stun applied.
/obj/item/melee/baton/security/proc/apply_stun_effect_end(mob/living/target)
	var/trait_check = HAS_TRAIT(target, TRAIT_BATON_RESISTANCE) //var since we check it in out to_chat as well as determine stun duration
	if(!target.IsKnockdown())
		to_chat(target, span_warning("Vos muscles se paralysent, vous faisant tomber à terre[trait_check ? ", mais vous vous en remettez rapidement..." : " !"]"))

	if(!trait_check)
		target.Knockdown(knockdown_time)

/obj/item/melee/baton/security/get_wait_description()
	return span_danger("Le bâton se recharge toujours !")

/obj/item/melee/baton/security/get_stun_description(mob/living/target, mob/living/user)
	. = list()

	.["visible"] = span_danger("[user] paralyse [target] avec [src] !")
	.["local"] = span_userdanger("[user] vous paralyse avec [src] !")

/obj/item/melee/baton/security/get_unga_dunga_cyborg_stun_description(mob/living/target, mob/living/user)
	. = list()

	.["visible"] = span_danger("[user] essaye de paralyser [target] avec [src], et échoue de façon évidente !")
	.["local"] = span_userdanger("[target] tries to... stun you with [src]?")

/obj/item/melee/baton/security/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(active && prob(throw_stun_chance) && isliving(hit_atom))
		finalize_baton_attack(hit_atom, thrownby?.resolve(), in_attack_chain = FALSE)

/obj/item/melee/baton/security/emp_act(severity)
	. = ..()
	if (!cell)
		return
	if (!(. & EMP_PROTECT_SELF))
		deductcharge(1000 / severity)
	if (cell.charge >= cell_hit_cost)
		var/scramble_time
		scramble_mode()
		for(var/loops in 1 to rand(6, 12))
			scramble_time = rand(5, 15) / (1 SECONDS)
			addtimer(CALLBACK(src, PROC_REF(scramble_mode)), scramble_time*loops * (1 SECONDS))

/obj/item/melee/baton/security/proc/scramble_mode()
	if (!cell || cell.charge < cell_hit_cost)
		return
	active = !active
	playsound(src, SFX_SPARKS, 75, TRUE, -1)
	update_appearance()

/obj/item/melee/baton/security/loaded //this one starts with a cell pre-installed.
	preload_cell_type = /obj/item/stock_parts/cell/high

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/melee/baton/security/cattleprod
	name = "bâton électrique improvisé"
	desc = "Un bâtôn électrique improvisé pour neutraliser les gens."
	desc_controls = "Clique gauche pour paralyser, clique droit pour blesser."
	icon = 'icons/obj/weapons/spear.dmi'
	icon_state = "stunprod"
	inhand_icon_state = "prod"
	worn_icon_state = null
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	force = 3
	throwforce = 5
	cell_hit_cost = 2000
	throw_stun_chance = 10
	slot_flags = ITEM_SLOT_BACK
	convertible = FALSE
	var/obj/item/assembly/igniter/sparkler
	///Determines whether or not we can improve the cattleprod into a new type. Prevents turning the cattleprod subtypes into different subtypes, or wasting materials on making it....another version of itself.
	var/can_upgrade = TRUE

/obj/item/melee/baton/security/cattleprod/Initialize(mapload)
	. = ..()
	sparkler = new (src)

/obj/item/melee/baton/security/cattleprod/attackby(obj/item/item, mob/user, params)//handles sticking a crystal onto a stunprod to make an improved cattleprod
	if(!istype(item, /obj/item/stack))
		return ..()

	if(!can_upgrade)
		user.visible_message(span_warning("Ce bâton est déja amélioré !"))
		return ..()

	if(cell)
		user.visible_message(span_warning("Vous ne pouvez pas mettre le cristal dans le bâton tant qu'il a une batterie installée !"))
		return ..()

	var/our_prod
	if(istype(item, /obj/item/stack/ore/bluespace_crystal))
		var/obj/item/stack/ore/bluespace_crystal/our_crystal = item
		our_crystal.use(1)
		our_prod = /obj/item/melee/baton/security/cattleprod/teleprod

	else if(istype(item, /obj/item/stack/telecrystal))
		var/obj/item/stack/telecrystal/our_crystal = item
		our_crystal.use(1)
		our_prod = /obj/item/melee/baton/security/cattleprod/telecrystalprod
	else
		to_chat(user, span_notice("Vous ne pensez pas que [item.name] puisse servir à améliorer [src]."))
		return ..()

	to_chat(user, span_notice("Vous placez [item.name] dans l'allumeur."))
	remove_item_from_storage(user)
	qdel(src)
	var/obj/item/melee/baton/security/cattleprod/brand_new_prod = new our_prod(user.loc)
	user.put_in_hands(brand_new_prod)

/obj/item/melee/baton/security/cattleprod/baton_effect()
	if(!sparkler.activate())
		return BATON_ATTACK_DONE
	return ..()

/obj/item/melee/baton/security/cattleprod/Destroy()
	if(sparkler)
		QDEL_NULL(sparkler)
	return ..()

/obj/item/melee/baton/security/boomerang
	name = "\improper Boomerang OZtek"
	desc = "Un objet inventé en 2486 pour la grande guerre des Émeus de l'espace par la confédération d'Australicus, ces boomerangs de haute technologie fonctionnent également exceptionnellement bien sur les membres d'équipage."
	throw_speed = 1
	icon = 'icons/obj/weapons/thrown.dmi'
	icon_state = "boomerang"
	inhand_icon_state = "boomerang"
	force = 5
	throwforce = 5
	throw_range = 5
	cell_hit_cost = 2000
	throw_stun_chance = 99  //Have you prayed today?
	convertible = FALSE
	custom_materials = list(/datum/material/iron = 10000, /datum/material/glass = 4000, /datum/material/silver = 10000, /datum/material/gold = 2000)

/obj/item/melee/baton/security/boomerang/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/boomerang, throw_range+2, TRUE)

/obj/item/melee/baton/security/boomerang/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!active)
		return ..()
	var/caught = hit_atom.hitby(src, skipcatch = FALSE, hitpush = FALSE, throwingdatum = throwingdatum)
	var/mob/thrown_by = thrownby?.resolve()
	if(isliving(hit_atom) && !iscyborg(hit_atom) && !caught && prob(throw_stun_chance))//if they are a living creature and they didn't catch it
		finalize_baton_attack(hit_atom, thrown_by, in_attack_chain = FALSE)

/obj/item/melee/baton/security/boomerang/loaded //Same as above, comes with a cell.
	preload_cell_type = /obj/item/stock_parts/cell/high

/obj/item/melee/baton/security/cattleprod/teleprod
	name = "bâton téléporteur"
	desc = "Un bâton téléporteur avec un cristal de bluespace à l'extrémité. Le cristal ne semble pas très amusant à toucher."
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "teleprod"
	inhand_icon_state = "teleprod"
	slot_flags = null
	can_upgrade = FALSE

/obj/item/melee/baton/security/cattleprod/teleprod/clumsy_check(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	do_teleport(user, get_turf(user), 50, channel = TELEPORT_CHANNEL_BLUESPACE)

/obj/item/melee/baton/security/cattleprod/teleprod/baton_effect(mob/living/target, mob/living/user, modifiers, stun_override)
	. = ..()
	if(!. || target.move_resist >= MOVE_FORCE_OVERPOWERING)
		return
	do_teleport(target, get_turf(target), 15, channel = TELEPORT_CHANNEL_BLUESPACE)

/obj/item/melee/baton/security/cattleprod/telecrystalprod
	name = "bâtonvoleur"
	desc = "Un bâton téléporteur avec un cristal de téléportation à l'extrémité. Il brille avec un désire pour l'arnaque et le vol."
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "telecrystalprod"
	inhand_icon_state = "telecrystalprod"
	slot_flags = null
	throw_stun_chance = 50 //I think it'd be funny
	can_upgrade = FALSE

/obj/item/melee/baton/security/cattleprod/telecrystalprod/clumsy_check(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	do_teleport(src, get_turf(user), 50, channel = TELEPORT_CHANNEL_BLUESPACE) //Wait, where did it go?

/obj/item/melee/baton/security/cattleprod/telecrystalprod/baton_effect(mob/living/target, mob/living/user, modifiers, stun_override)
	. = ..()
	if(!.)
		return
	var/obj/item/stuff_in_hand = target.get_active_held_item()
	if(stuff_in_hand && target.temporarilyRemoveItemFromInventory(stuff_in_hand))
		if(user.put_in_inactive_hand(stuff_in_hand))
			stuff_in_hand.loc.visible_message(span_warning("[stuff_in_hand] apparait soudainement dans la main de [user] !"))
		else
			stuff_in_hand.forceMove(user.drop_location())
			stuff_in_hand.loc.visible_message(span_warning("[stuff_in_hand] apparait soudainement !"))
