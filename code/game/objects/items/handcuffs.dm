/**
 * # Generic restraints
 *
 * Parent class for handcuffs and handcuff accessories
 *
 * Functionality:
 * 1. A special suicide
 * 2. If a restraint is handcuffing/legcuffing a carbon while being deleted, it will remove the handcuff/legcuff status.
*/
/obj/item/restraints
	breakouttime = 1 MINUTES
	dye_color = DYE_PRISONER
	icon = 'icons/obj/restraints.dmi'

/obj/item/restraints/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] étrangle [user.p_them()] avec des [src] ! Il le semble que [user.p_theyre()] est entrain d'essayer de se suicider !"))
	return OXYLOSS

/**
 * # Handcuffs
 *
 * Stuff that makes humans unable to use hands
 *
 * Clicking people with those will cause an attempt at handcuffing them to occur
*/
/obj/item/restraints/handcuffs
	name = "Menottes"
	desc = "Utiliser ça pour garder les prisonniers sous contrôle."
	gender = PLURAL
	icon_state = "handcuff"
	worn_icon_state = "handcuff"
	inhand_icon_state = "handcuff"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_HANDCUFFED
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/iron=500)
	breakouttime = 1 MINUTES
	armor_type = /datum/armor/restraints_handcuffs
	custom_price = PAYCHECK_COMMAND * 0.35
	///Sound that plays when starting to put handcuffs on someone
	var/cuffsound = 'sound/weapons/handcuffs.ogg'
	///If set, handcuffs will be destroyed on application and leave behind whatever this is set to.
	var/trashtype = null

/datum/armor/restraints_handcuffs
	fire = 50
	acid = 50

/obj/item/restraints/handcuffs/attack(mob/living/carbon/C, mob/living/user)
	if(!istype(C))
		return

	SEND_SIGNAL(C, COMSIG_CARBON_CUFF_ATTEMPTED, user)

	if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))) //Clumsy people have a 50% chance to handcuff themselves instead of their target.
		to_chat(user, span_warning("Euh... comment ça marche ces trucs ?"))
		apply_cuffs(user,user)
		return

	if(!C.handcuffed)
		if(C.canBeHandcuffed())
			C.visible_message(span_danger("[user] essaye de mettre des [src] sur [C] !"), \
								span_userdanger("[user] essaye de vous mettre des [src] au poignet !"))
			if(C.is_blind())
				to_chat(C, span_userdanger("Alors que vous sentez quelqu'un votre attraper les poignets, les [src] commencent à vous mordre la chair !"))
			playsound(loc, cuffsound, 30, TRUE, -2)
			log_combat(user, C, "A tenté de menotter")
			if(do_after(user, 3 SECONDS, C, timed_action_flags = IGNORE_SLOWDOWNS) && C.canBeHandcuffed())
				if(iscyborg(user))
					apply_cuffs(C, user, TRUE)
				else
					apply_cuffs(C, user)
				C.visible_message(span_notice("[user] menotte [C]."), \
									span_userdanger("[user] vous menotte."))
				SSblackbox.record_feedback("tally", "handcuffs", 1, type)

				log_combat(user, C, "Menotté")
			else
				to_chat(user, span_warning("Vous n'avez pas réussi a menotter [C] !"))
				log_combat(user, C, "Echec du menottage")
		else
			to_chat(user, span_warning("[C] n'a pas deux poignets.."))

/**
 * This handles handcuffing people
 *
 * When called, this instantly puts handcuffs on someone (if possible)
 * Arguments:
 * * mob/living/carbon/target - Who is being handcuffed
 * * mob/user - Who or what is doing the handcuffing
 * * dispense - True if the cuffing should create a new item instead of using putting src on the mob, false otherwise. False by default.
*/
/obj/item/restraints/handcuffs/proc/apply_cuffs(mob/living/carbon/target, mob/user, dispense = FALSE)
	if(target.handcuffed)
		return

	if(!user.temporarilyRemoveItemFromInventory(src) && !dispense)
		return

	var/obj/item/restraints/handcuffs/cuffs = src
	if(trashtype)
		cuffs = new trashtype()
	else if(dispense)
		cuffs = new type()

	target.equip_to_slot(cuffs, ITEM_SLOT_HANDCUFFED)

	if(trashtype && !dispense)
		qdel(src)
	return

/**
 * # Alien handcuffs
 *
 * Abductor reskin of the handcuffs.
*/
/obj/item/restraints/handcuffs/alien
	icon_state = "handcuffAlien"

/**
 *
 * # Fake handcuffs
 *
 * Fake handcuffs that can be removed near-instantly.
*/
/obj/item/restraints/handcuffs/fake
	name = "Fausse menottes"
	desc = "Fausse menottes, pour faire des blagues."
	breakouttime = 1 SECONDS

/**
 * # Cable restraints
 *
 * Ghetto handcuffs. Removing those is faster.
*/
/obj/item/restraints/handcuffs/cable
	name = "Menottes improvisées"
	desc = "On dirait plusieurs câbles attachés ensemble. ça pourrait être utilisé pour attacher quelqu'un."
	icon_state = "cuff"
	inhand_icon_state = "coil_red"
	color = CABLE_HEX_COLOR_RED
	///for generating the correct icons based off the original cable's color.
	var/cable_color = CABLE_COLOR_RED
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	custom_materials = list(/datum/material/iron=150, /datum/material/glass=75)
	breakouttime = 30 SECONDS
	cuffsound = 'sound/weapons/cablecuff.ogg'

/obj/item/restraints/handcuffs/cable/Initialize(mapload, new_color)
	. = ..()

	var/static/list/hovering_item_typechecks = list(
		/obj/item/stack/rods = list(
			SCREENTIP_CONTEXT_LMB = "Créer une barre câblée",
		),

		/obj/item/stack/sheet/iron = list(
			SCREENTIP_CONTEXT_LMB = "Créer des bolas",
		),
	)

	AddElement(/datum/element/contextual_screentip_item_typechecks, hovering_item_typechecks)
	AddElement(/datum/element/update_icon_updates_onmob, (slot_flags|ITEM_SLOT_HANDCUFFED))

	if(new_color)
		set_cable_color(new_color)

/obj/item/restraints/handcuffs/cable/proc/set_cable_color(new_color)
	color = GLOB.cable_colors[new_color]
	cable_color = new_color
	update_appearance(UPDATE_ICON)

/obj/item/restraints/handcuffs/cable/vv_edit_var(vname, vval)
	if(vname == NAMEOF(src, cable_color))
		set_cable_color(vval)
		datum_flags |= DF_VAR_EDITED
		return TRUE
	return ..()

/obj/item/restraints/handcuffs/cable/update_icon_state()
	. = ..()
	if(cable_color)
		var/new_inhand_icon = "coil_[cable_color]"
		if(new_inhand_icon != inhand_icon_state)
			inhand_icon_state = new_inhand_icon //small memory optimization.

/**
 * # Sinew restraints
 *
 * Primal ghetto handcuffs
 *
 * Just cable restraints that look differently and can't be recycled.
*/
/obj/item/restraints/handcuffs/cable/sinew
	name = "Menottes improvisées à base de chair"
	desc = "Une paire de menottes faites de chair."
	icon_state = "sinewcuff"
	inhand_icon_state = null
	cable_color = null
	custom_materials = null
	color = null

/**
 * Red cable restraints
*/
/obj/item/restraints/handcuffs/cable/red
	color = CABLE_HEX_COLOR_RED
	cable_color = CABLE_COLOR_RED
	inhand_icon_state = "coil_red"

/**
 * Yellow cable restraints
*/
/obj/item/restraints/handcuffs/cable/yellow
	color = CABLE_HEX_COLOR_YELLOW
	cable_color = CABLE_COLOR_YELLOW
	inhand_icon_state = "coil_yellow"

/**
 * Blue cable restraints
*/
/obj/item/restraints/handcuffs/cable/blue
	color =CABLE_HEX_COLOR_BLUE
	cable_color = CABLE_COLOR_BLUE
	inhand_icon_state = "coil_blue"

/**
 * Green cable restraints
*/
/obj/item/restraints/handcuffs/cable/green
	color = CABLE_HEX_COLOR_GREEN
	cable_color = CABLE_COLOR_GREEN
	inhand_icon_state = "coil_green"

/**
 * Pink cable restraints
*/
/obj/item/restraints/handcuffs/cable/pink
	color = CABLE_HEX_COLOR_PINK
	cable_color = CABLE_COLOR_PINK
	inhand_icon_state = "coil_pink"

/**
 * Orange (the color) cable restraints
*/
/obj/item/restraints/handcuffs/cable/orange
	color = CABLE_HEX_COLOR_ORANGE
	cable_color = CABLE_COLOR_ORANGE
	inhand_icon_state = "coil_orange"

/**
 * Cyan cable restraints
*/
/obj/item/restraints/handcuffs/cable/cyan
	color = CABLE_HEX_COLOR_CYAN
	cable_color = CABLE_COLOR_CYAN
	inhand_icon_state = "coil_cyan"

/**
 * White cable restraints
*/
/obj/item/restraints/handcuffs/cable/white
	color = CABLE_HEX_COLOR_WHITE
	cable_color = CABLE_COLOR_WHITE
	inhand_icon_state = "coil_white"

/obj/item/restraints/handcuffs/cable/attackby(obj/item/I, mob/user, params) //Slapcrafting
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/wirerod/W = new /obj/item/wirerod
			remove_item_from_storage(user)
			user.put_in_hands(W)
			to_chat(user, span_notice("Vous enroulez [src] autours de [I]."))
			qdel(src)
		else
			to_chat(user, span_warning("Vous avez besoin d'une barre pour faire une barre câblée !"))
			return
	else if(istype(I, /obj/item/stack/sheet/iron))
		var/obj/item/stack/sheet/iron/M = I
		if(M.get_amount() < 6)
			to_chat(user, span_warning("Vous avez besoin d'au moins six plaques de fer pour le rendre assez lourd !"))
			return
		to_chat(user, span_notice("vous commencez à appliquer [I] sur [src]..."))
		if(do_after(user, 35, target = src))
			if(M.get_amount() < 6 || !M)
				return
			var/obj/item/restraints/legcuffs/bola/S = new /obj/item/restraints/legcuffs/bola
			M.use(6)
			user.put_in_hands(S)
			to_chat(user, span_notice("Vous fabriquez des poids à base de [I] et vous les attachez à [src]."))
			remove_item_from_storage(user)
			qdel(src)
	else
		return ..()

/**
 * # Zipties
 *
 * One-use handcuffs that take 45 seconds to resist out of instead of one minute. This turns into the used version when applied.
*/
/obj/item/restraints/handcuffs/cable/zipties
	name = "Serre-câbles"
	desc = "Plastique, serre-câbles jetables qui peuvent être utilisés pour restreindre temporairement mais sont détruits après utilisation."
	icon_state = "cuff"
	inhand_icon_state = "cuff_white"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	custom_materials = null
	breakouttime = 45 SECONDS
	trashtype = /obj/item/restraints/handcuffs/cable/zipties/used
	color = null
	cable_color = null

/**
 * # Used zipties
 *
 * What zipties turn into when applied. These can't be used to cuff people.
*/
/obj/item/restraints/handcuffs/cable/zipties/used
	desc = "Une paire de serre-câble détruite."
	icon_state = "cuff_used"

/obj/item/restraints/handcuffs/cable/zipties/used/attack()
	return

/**
 * # Fake Zipties
 *
 * One-use handcuffs that is very easy to break out of, meant as a one-use alternative to regular fake handcuffs.
 */
/obj/item/restraints/handcuffs/cable/zipties/fake
	name = "Faux serre-câbles"
	desc = "Faux serre-câble pour faire des blagues."
	breakouttime = 1 SECONDS

/obj/item/restraints/handcuffs/cable/zipties/fake/used
	desc = "Une paire de faux serre-câble détruite."
	icon_state = "cuff_used"

/**
 * # Generic leg cuffs
 *
 * Parent class for everything that can legcuff carbons. Can't legcuff anything itself.
*/
/obj/item/restraints/legcuffs
	name = "Menottes de jambe"
	desc = "Utiliser ça pour garder les prisonniers sous contrôle."
	gender = PLURAL
	icon_state = "handcuff"
	inhand_icon_state = "handcuff"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	flags_1 = CONDUCT_1
	throwforce = 0
	w_class = WEIGHT_CLASS_NORMAL
	slowdown = 7
	breakouttime = 30 SECONDS
	slot_flags = ITEM_SLOT_LEGCUFFED

/**
 * # Bear trap
 *
 * This opens, closes, and bites people's legs.
 */
/obj/item/restraints/legcuffs/beartrap
	name = "Piège à ours"
	throw_speed = 1
	throw_range = 1
	icon_state = "beartrap"
	desc = "Un piège utiliser pour attraper des ours ou toutes autres créatures possédant des jambes."
	///If true, the trap is "open" and can trigger.
	var/armed = FALSE
	///How much damage the trap deals when triggered.
	var/trap_damage = 40

/obj/item/restraints/legcuffs/beartrap/prearmed
	armed = TRUE

/obj/item/restraints/legcuffs/beartrap/Initialize(mapload)
	. = ..()
	update_appearance()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(spring_trap),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/restraints/legcuffs/beartrap/update_icon_state()
	icon_state = "[initial(icon_state)][armed]"
	return ..()

/obj/item/restraints/legcuffs/beartrap/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] place la tête de [user.p_their()] dans le [src.name] ! Il semble que [user.p_theyre()] essaye de se suicider !"))
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, TRUE, -1)
	return BRUTELOSS

/obj/item/restraints/legcuffs/beartrap/attack_self(mob/user)
	. = ..()
	if(!ishuman(user) || user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return
	armed = !armed
	update_appearance()
	to_chat(user, span_notice("[src] est maintenant [armed ? "armé" : "desarmé"]"))

/**
 * Closes a bear trap
 *
 * Closes a bear trap.
 * Arguments:
 */
/obj/item/restraints/legcuffs/beartrap/proc/close_trap()
	armed = FALSE
	update_appearance()
	playsound(src, 'sound/effects/snap.ogg', 50, TRUE)

/obj/item/restraints/legcuffs/beartrap/proc/spring_trap(datum/source, atom/movable/target, thrown_at = FALSE)
	SIGNAL_HANDLER
	if(!armed || !isturf(loc) || !isliving(target))
		return
	var/mob/living/victim = target
	if(istype(victim.buckled, /obj/vehicle))
		var/obj/vehicle/ridden_vehicle = victim.buckled
		if(!ridden_vehicle.are_legs_exposed) //close the trap without injuring/trapping the rider if their legs are inside the vehicle at all times.
			close_trap()
			ridden_vehicle.visible_message(span_danger("[ridden_vehicle] active le [src]."))
			return

	//don't close the trap if they're as small as a mouse, or not touching the ground
	if(victim.mob_size <= MOB_SIZE_TINY || (!thrown_at && victim.movement_type & (FLYING|FLOATING)))
		return

	close_trap()
	if(thrown_at)
		victim.visible_message(span_danger("le [src] piège [victim] !"), \
				span_userdanger("le [src] vous piège !"))
	else
		victim.visible_message(span_danger("[victim] active le [src]."), \
				span_userdanger("vous activez le [src] !"))
	var/def_zone = BODY_ZONE_CHEST
	if(iscarbon(victim) && victim.body_position == STANDING_UP)
		var/mob/living/carbon/carbon_victim = victim
		def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
		if(!carbon_victim.legcuffed && carbon_victim.num_legs >= 2) //beartrap can't cuff your leg if there's already a beartrap or legcuffs, or you don't have two legs.
			INVOKE_ASYNC(carbon_victim, TYPE_PROC_REF(/mob/living/carbon, equip_to_slot), src, ITEM_SLOT_LEGCUFFED)
			SSblackbox.record_feedback("tally", "handcuffs", 1, type)

	victim.apply_damage(trap_damage, BRUTE, def_zone)

/**
 * # Energy snare
 *
 * This closes on people's legs.
 *
 * A weaker version of the bear trap that can be resisted out of faster and disappears
 */
/obj/item/restraints/legcuffs/beartrap/energy
	name = "Piège a énergie"
	armed = 1
	icon_state = "e_snare"
	trap_damage = 0
	breakouttime = 3 SECONDS
	item_flags = DROPDEL
	flags_1 = NONE

/obj/item/restraints/legcuffs/beartrap/energy/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(dissipate)), 100)

/**
 * Handles energy snares disappearing
 *
 * If the snare isn't closed on anyone, it will disappear in a shower of sparks.
 * Arguments:
 */
/obj/item/restraints/legcuffs/beartrap/energy/proc/dissipate()
	if(!ismob(loc))
		do_sparks(1, TRUE, src)
		qdel(src)

/obj/item/restraints/legcuffs/beartrap/energy/attack_hand(mob/user, list/modifiers)
	spring_trap(null, user)
	return ..()

/obj/item/restraints/legcuffs/beartrap/energy/cyborg
	breakouttime = 2 SECONDS // Cyborgs shouldn't have a strong restraint

/obj/item/restraints/legcuffs/bola
	name = "bolas"
	desc = "Un outils de capture conçu pour être lancé sur la cible. Une fois connecté à la cible, il s'enroulera autour de ses jambes, rendant difficile pour elle de se déplacer rapidement."
	icon_state = "bola"
	icon_state_preview = "bola_preview"
	inhand_icon_state = "bola"
	lefthand_file = 'icons/mob/inhands/weapons/thrown_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/thrown_righthand.dmi'
	breakouttime = 3.5 SECONDS//easy to apply, easy to break out of
	gender = NEUTER
	///Amount of time to knock the target down for once it's hit in deciseconds.
	var/knockdown = 0

/obj/item/restraints/legcuffs/bola/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, gentle = FALSE, quickstart = TRUE)
	if(!..())
		return
	playsound(src.loc,'sound/weapons/bolathrow.ogg', 75, TRUE)

/obj/item/restraints/legcuffs/bola/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(..() || !iscarbon(hit_atom))//if it gets caught or the target can't be cuffed,
		return//abort
	ensnare(hit_atom)

/**
 * Attempts to legcuff someone with the bola
 *
 * Arguments:
 * * C - the carbon that we will try to ensnare
 */
/obj/item/restraints/legcuffs/bola/proc/ensnare(mob/living/carbon/C)
	if(!C.legcuffed && C.num_legs >= 2)
		visible_message(span_danger("les [src] capture [C]!"), span_userdanger("les [src] vous capture !"))
		C.equip_to_slot(src, ITEM_SLOT_LEGCUFFED)
		SSblackbox.record_feedback("tally", "handcuffs", 1, type)
		C.Knockdown(knockdown)
		playsound(src, 'sound/effects/snap.ogg', 50, TRUE)

/**
 * A traitor variant of the bola.
 *
 * It knocks people down and is harder to remove.
 */
/obj/item/restraints/legcuffs/bola/tactical
	name = "bolas tactique"
	desc = "Des bolas solide, fait avec une longue chaine en acier. C'est assez lourd pour faire tomber quelqu'un."
	icon_state = "bola_r"
	inhand_icon_state = "bola_r"
	breakouttime = 7 SECONDS
	knockdown = 3.5 SECONDS

/**
 * A security variant of the bola.
 *
 * It's harder to remove, smaller and has a defined price.
 */
/obj/item/restraints/legcuffs/bola/energy
	name = "bolas à énergie"
	desc = "Des bolas spécialisées à base de lumière solide conçues pour capturer les criminels en fuite et aider aux arrestations."
	icon_state = "ebola"
	inhand_icon_state = "ebola"
	hitsound = 'sound/weapons/taserhit.ogg'
	w_class = WEIGHT_CLASS_SMALL
	breakouttime = 6 SECONDS
	custom_price = PAYCHECK_COMMAND * 0.35

/obj/item/restraints/legcuffs/bola/energy/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_UNCATCHABLE, TRAIT_GENERIC) // People said energy bolas being uncatchable is a feature.

/obj/item/restraints/legcuffs/bola/energy/ensnare(atom/hit_atom)
	var/obj/item/restraints/legcuffs/beartrap/energy/cyborg/B = new (get_turf(hit_atom))
	B.spring_trap(null, hit_atom, TRUE)
	qdel(src)

/**
 * A pacifying variant of the bola.
 *
 * It's much harder to remove, doesn't cause a slowdown and gives people /datum/status_effect/gonbola_pacify.
 */
/obj/item/restraints/legcuffs/bola/gonbola
	name = "gonbolas"
	desc = "Hey, si tu dois te faire câliner les jambes par quoique ce soit, autant que ce soit ce petit mec."
	icon_state = "gonbola"
	icon_state_preview = "gonbola_preview"
	inhand_icon_state = "bola_r"
	breakouttime = 30 SECONDS
	slowdown = 0
	var/datum/status_effect/gonbola_pacify/effectReference

/obj/item/restraints/legcuffs/bola/gonbola/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(iscarbon(hit_atom))
		var/mob/living/carbon/C = hit_atom
		effectReference = C.apply_status_effect(/datum/status_effect/gonbola_pacify)

/obj/item/restraints/legcuffs/bola/gonbola/dropped(mob/user)
	. = ..()
	if(effectReference)
		QDEL_NULL(effectReference)
