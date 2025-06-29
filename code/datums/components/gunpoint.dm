/// How long it takes from the gunpoint is initiated to reach stage 2
#define GUNPOINT_DELAY_STAGE_2 (2.5 SECONDS)
/// How long it takes from stage 2 starting to move up to stage 3
#define GUNPOINT_DELAY_STAGE_3 (7.5 SECONDS)
/// If the projectile doesn't have a wound_bonus of CANT_WOUND, we add (this * the stage mult) to their wound_bonus and bare_wound_bonus upon triggering
#define GUNPOINT_BASE_WOUND_BONUS 5
/// How much the damage and wound bonus mod is multiplied when you're on stage 1
#define GUNPOINT_MULT_STAGE_1 1.25
/// As above, for stage 2
#define GUNPOINT_MULT_STAGE_2 2
/// As above, for stage 3
#define GUNPOINT_MULT_STAGE_3 2.5


/datum/component/gunpoint
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// Who we're holding up
	var/mob/living/target
	/// The gun we're holding them up with
	var/obj/item/gun/weapon

	/// Which stage we're on
	var/stage = 1
	/// How much the damage and wound values will be multiplied by
	var/damage_mult = GUNPOINT_MULT_STAGE_1
	/// If TRUE, we're committed to firing the shot, for async purposes
	var/point_of_no_return = FALSE

// *extremely bad russian accent* no!
/datum/component/gunpoint/Initialize(mob/living/targ, obj/item/gun/wep)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/shooter = parent
	target = targ
	weapon = wep

	RegisterSignals(targ, list(COMSIG_MOB_ATTACK_HAND, COMSIG_MOB_ITEM_ATTACK, COMSIG_MOVABLE_MOVED, COMSIG_MOB_FIRED_GUN), PROC_REF(trigger_reaction))
	RegisterSignals(weapon, list(COMSIG_ITEM_DROPPED, COMSIG_ITEM_EQUIPPED), PROC_REF(cancel))

	var/distance = min(get_dist(shooter, target), 1) // treat 0 distance as adjacent
	var/distance_description = (distance <= 5 ? "point blank " : "")

	shooter.visible_message(span_danger("[shooter] aims [weapon] [distance_description]at [target]!"),
		span_danger("You aim [weapon] [distance_description]at [target]!"), ignored_mobs = target)
	to_chat(target, span_userdanger("[shooter] aims [weapon] [distance_description]at you!"))

	shooter.Immobilize(0.75 SECONDS / distance)
	if(!HAS_TRAIT(target, TRAIT_NOFEAR_HOLDUPS))
		target.Immobilize(0.75 SECONDS / distance)
		target.emote("gaspshock", intentional = FALSE)
		add_memory_in_range(target, 7, /datum/memory/held_at_gunpoint, protagonist = target, deuteragonist = shooter, antagonist = weapon)

	shooter.apply_status_effect(/datum/status_effect/holdup, shooter)
	target.apply_status_effect(/datum/status_effect/grouped/heldup, REF(shooter))
	target.do_alert_animation()
	target.playsound_local(target.loc, 'sound/machines/chime.ogg', 50, TRUE)
	target.add_mood_event("gunpoint", /datum/mood_event/gunpoint)

	if(istype(weapon, /obj/item/gun/ballistic/rocketlauncher) && weapon.chambered)
		if(target.stat == CONSCIOUS && IS_NUKE_OP(shooter) && !IS_NUKE_OP(target) && (locate(/obj/item/disk/nuclear) in target.get_contents()) && shooter.client)
			shooter.client.give_award(/datum/award/achievement/misc/rocket_holdup, shooter)

	addtimer(CALLBACK(src, PROC_REF(update_stage), 2), GUNPOINT_DELAY_STAGE_2)

/datum/component/gunpoint/Destroy(force, silent)
	var/mob/living/shooter = parent
	shooter.remove_status_effect(/datum/status_effect/holdup)
	target.remove_status_effect(/datum/status_effect/grouped/heldup, REF(shooter))
	target.clear_mood_event("gunpoint")
	return ..()

/datum/component/gunpoint/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(check_deescalate))
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(flinch))
	RegisterSignal(parent, COMSIG_MOB_ATTACK_HAND, PROC_REF(check_shove))
	RegisterSignal(parent, COMSIG_MOB_UPDATE_SIGHT, PROC_REF(check_deescalate))
	RegisterSignals(parent, list(COMSIG_LIVING_START_PULL, COMSIG_MOVABLE_BUMP), PROC_REF(check_bump))

/datum/component/gunpoint/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(parent, COMSIG_MOB_APPLY_DAMAGE)
	UnregisterSignal(parent, COMSIG_MOB_UPDATE_SIGHT)
	UnregisterSignal(parent, COMSIG_MOB_ATTACK_HAND)
	UnregisterSignal(parent, list(COMSIG_LIVING_START_PULL, COMSIG_MOVABLE_BUMP))

///If the shooter bumps the target, cancel the holdup to avoid cheesing and forcing the charged shot
/datum/component/gunpoint/proc/check_bump(atom/B, atom/A)
	SIGNAL_HANDLER

	if(A != target)
		return
	var/mob/living/shooter = parent
	shooter.visible_message(span_danger("[shooter] bumps into [target] and fumbles [shooter.p_their()] aim!"), \
		span_danger("You bump into [target] and fumble your aim!"), ignored_mobs = target)
	to_chat(target, span_userdanger("[shooter] bumps into you and fumbles [shooter.p_their()] aim!"))
	qdel(src)

///If the shooter shoves or grabs the target, cancel the holdup to avoid cheesing and forcing the charged shot
/datum/component/gunpoint/proc/check_shove(mob/living/carbon/shooter, mob/shooter_again, mob/living/T, datum/martial_art/attacker_style, modifiers)
	SIGNAL_HANDLER

	if(T != target || LAZYACCESS(modifiers, RIGHT_CLICK))
		return
	shooter.visible_message(span_danger("[shooter] bumps into [target] and fumbles [shooter.p_their()] aim!"), \
		span_danger("You bump into [target] and fumble your aim!"), ignored_mobs = target)
	to_chat(target, span_userdanger("[shooter] bumps into you and fumbles [shooter.p_their()] aim!"))
	qdel(src)

///Update the damage multiplier for whatever stage we're entering into
/datum/component/gunpoint/proc/update_stage(new_stage)
	if(check_deescalate())
		return
	stage = new_stage
	if(stage == 2)
		to_chat(parent, span_danger("You steady [weapon] on [target]."))
		to_chat(target, span_userdanger("[parent] has steadied [weapon] on you!"))
		damage_mult = GUNPOINT_MULT_STAGE_2
		addtimer(CALLBACK(src, PROC_REF(update_stage), 3), GUNPOINT_DELAY_STAGE_3)
	else if(stage == 3)
		to_chat(parent, span_danger("You have fully steadied [weapon] on [target]."))
		to_chat(target, span_userdanger("[parent] has fully steadied [weapon] on you!"))
		damage_mult = GUNPOINT_MULT_STAGE_3

///Cancel the holdup if the shooter moves out of sight or out of range of the target
/datum/component/gunpoint/proc/check_deescalate()
	SIGNAL_HANDLER

	if(!can_see(parent, target, GUNPOINT_SHOOTER_STRAY_RANGE))
		cancel()
		return TRUE

///Bang bang, we're firing a charged shot off
/datum/component/gunpoint/proc/trigger_reaction()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(async_trigger_reaction))

/datum/component/gunpoint/proc/async_trigger_reaction()
	var/mob/living/shooter = parent
	shooter.remove_status_effect(/datum/status_effect/holdup) // try doing these before the trigger gets pulled since the target (or shooter even) may not exist after pulling the trigger, dig?
	target.remove_status_effect(/datum/status_effect/grouped/heldup, REF(shooter))
	target.clear_mood_event("gunpoint")

	if(point_of_no_return)
		return
	point_of_no_return = TRUE

	if(weapon.chambered && weapon.chambered.loaded_projectile)
		weapon.chambered.loaded_projectile.damage *= damage_mult
		if(weapon.chambered.loaded_projectile.wound_bonus != CANT_WOUND)
			weapon.chambered.loaded_projectile.wound_bonus += damage_mult * GUNPOINT_BASE_WOUND_BONUS
			weapon.chambered.loaded_projectile.bare_wound_bonus += damage_mult * GUNPOINT_BASE_WOUND_BONUS

	var/fired = weapon.fire_gun(target, shooter)
	if(!fired && weapon.chambered?.loaded_projectile)
		weapon.chambered.loaded_projectile.damage /= damage_mult
		if(weapon.chambered.loaded_projectile.wound_bonus != CANT_WOUND)
			weapon.chambered.loaded_projectile.wound_bonus -= damage_mult * GUNPOINT_BASE_WOUND_BONUS
			weapon.chambered.loaded_projectile.bare_wound_bonus -= damage_mult * GUNPOINT_BASE_WOUND_BONUS

	qdel(src)

///Shooter canceled their shot, either by dropping/equipping their weapon, leaving sight/range, or clicking on the alert
/datum/component/gunpoint/proc/cancel()
	SIGNAL_HANDLER

	var/mob/living/shooter = parent
	shooter.visible_message(span_danger("[shooter] breaks [shooter.p_their()] aim on [target]!"), \
		span_danger("You are no longer aiming [weapon] at [target]."), ignored_mobs = target)
	to_chat(target, span_userdanger("[shooter] breaks [shooter.p_their()] aim on you!"))
	qdel(src)

///If the shooter is hit by an attack, they have a 50% chance to flinch and fire. If it hit the arm holding the trigger, it's an 80% chance to fire instead
/datum/component/gunpoint/proc/flinch(attacker, damage, damagetype, def_zone)
	SIGNAL_HANDLER

	var/mob/living/shooter = parent
	if(attacker == shooter)
		return // somehow this wasn't checked for months but no one tried punching themselves to initiate the shot, amazing

	var/flinch_chance = 50
	var/gun_hand = LEFT_HANDS

	if(shooter.held_items[RIGHT_HANDS] == weapon)
		gun_hand = RIGHT_HANDS

	if((def_zone == BODY_ZONE_L_ARM && gun_hand == LEFT_HANDS) || (def_zone == BODY_ZONE_R_ARM && gun_hand == RIGHT_HANDS))
		flinch_chance = 80

	if(prob(flinch_chance))
		shooter.visible_message(span_danger("[shooter] flinches!"), \
			span_danger("You flinch!"))
		INVOKE_ASYNC(src, PROC_REF(trigger_reaction))

#undef GUNPOINT_DELAY_STAGE_2
#undef GUNPOINT_DELAY_STAGE_3
#undef GUNPOINT_BASE_WOUND_BONUS
#undef GUNPOINT_MULT_STAGE_1
#undef GUNPOINT_MULT_STAGE_2
#undef GUNPOINT_MULT_STAGE_3
