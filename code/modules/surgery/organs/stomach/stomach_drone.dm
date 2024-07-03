/obj/item/organ/internal/stomach/drone
	name = "High power cell"
	icon = 'icons/obj/power.dmi'
	icon_state = "hcell"
	desc = "A power cell with a slightly higher capacity than normal!"
	organ_traits = list(TRAIT_NOHUNGER) // We have our own hunger mechanic.
	///basically satiety but drone
	var/crystal_charge = DRONE_CHARGE_FULL
	///used to keep drone from spam draining power sources
	var/drain_time = 0

/obj/item/organ/internal/stomach/drone/on_life(seconds_per_tick, times_fired)
	. = ..()
	adjust_charge(-DRONE_CHARGE_FACTOR * seconds_per_tick)
	handle_charge(owner, seconds_per_tick, times_fired)

/obj/item/organ/internal/stomach/drone/on_insert(mob/living/carbon/stomach_owner)
	. = ..()
	RegisterSignal(stomach_owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, PROC_REF(charge))
	RegisterSignal(stomach_owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))

/obj/item/organ/internal/stomach/drone/on_remove(mob/living/carbon/stomach_owner)
	. = ..()
	UnregisterSignal(stomach_owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT)
	UnregisterSignal(stomach_owner, COMSIG_LIVING_ELECTROCUTE_ACT)
	stomach_owner.clear_mood_event("charge")
	stomach_owner.clear_alert(ALERT_DRONE_CHARGE)
	stomach_owner.clear_alert(ALERT_DRONE_OVERCHARGE)

/obj/item/organ/internal/stomach/drone/handle_hunger_slowdown(mob/living/carbon/human/human)
	human.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/hunger, multiplicative_slowdown = (1.5 * (1 - crystal_charge / 100)))

/obj/item/organ/internal/stomach/drone/proc/charge(datum/source, amount, repairs)
	SIGNAL_HANDLER
	adjust_charge(amount / 3.5)

/obj/item/organ/internal/stomach/drone/proc/on_electrocute(datum/source, shock_damage, siemens_coeff = 1, flags = NONE)
	SIGNAL_HANDLER
	if(flags & SHOCK_ILLUSION)
		return
	adjust_charge(shock_damage * siemens_coeff * 2)
	to_chat(owner, span_notice("You absorb some of the shock into your body!"))

/obj/item/organ/internal/stomach/drone/proc/adjust_charge(amount)
	crystal_charge = clamp(crystal_charge + amount, DRONE_CHARGE_NONE, DRONE_CHARGE_DANGEROUS)

/obj/item/organ/internal/stomach/drone/proc/handle_charge(mob/living/carbon/carbon, seconds_per_tick, times_fired)
	switch(crystal_charge)
		if(-INFINITY to DRONE_CHARGE_NONE)
			carbon.add_mood_event("charge", /datum/mood_event/decharged)
			carbon.throw_alert(ALERT_DRONE_CHARGE, /atom/movable/screen/alert/emptycell/drone)
			if(carbon.health > 10.5)
				carbon.apply_damage(0.65, BURN, null, null, carbon)
		if(DRONE_CHARGE_NONE to DRONE_CHARGE_LOWPOWER)
			carbon.add_mood_event("charge", /datum/mood_event/decharged)
			carbon.throw_alert(ALERT_DRONE_CHARGE, /atom/movable/screen/alert/lowcell/drone, 3)
			if(carbon.health > 10.5)
				carbon.apply_damage(0.325 * seconds_per_tick, BURN, null, null, carbon)
		if(DRONE_CHARGE_LOWPOWER to DRONE_CHARGE_NORMAL)
			carbon.add_mood_event("charge", /datum/mood_event/lowpower)
			carbon.throw_alert(ALERT_DRONE_CHARGE, /atom/movable/screen/alert/lowcell/drone, 2)
		if(DRONE_CHARGE_ALMOSTFULL to DRONE_CHARGE_FULL)
			carbon.add_mood_event("charge", /datum/mood_event/charged)
		if(DRONE_CHARGE_FULL to DRONE_CHARGE_OVERLOAD)
			carbon.add_mood_event("charge", /datum/mood_event/overcharged)
			carbon.throw_alert(ALERT_DRONE_OVERCHARGE, /atom/movable/screen/alert/drone_overcharge, 1)
			carbon.apply_damage(0.2, BURN, null, null, carbon)
		if(DRONE_CHARGE_OVERLOAD to DRONE_CHARGE_DANGEROUS)
			carbon.add_mood_event("charge", /datum/mood_event/supercharged)
			carbon.throw_alert(ALERT_DRONE_OVERCHARGE, /atom/movable/screen/alert/drone_overcharge, 2)
			carbon.apply_damage(0.325 * seconds_per_tick, BURN, null, null, carbon)
			if(SPT_PROB(5, seconds_per_tick)) // 5% each seacond for drones to explosively release excess energy if it reaches dangerous levels
				discharge_process(carbon)
		else
			owner.clear_mood_event("charge")
			carbon.clear_alert(ALERT_DRONE_CHARGE)
			carbon.clear_alert(ALERT_DRONE_OVERCHARGE)

/obj/item/organ/internal/stomach/drone/proc/discharge_process(mob/living/carbon/carbon)
	to_chat(carbon, span_warning("You begin to lose control over your charge!"))
	carbon.visible_message(span_danger("[carbon] begins to spark violently!"))

	var/static/mutable_appearance/overcharge //shameless copycode from lightning spell
	overcharge = overcharge || mutable_appearance('icons/effects/effects.dmi', "electricity", EFFECTS_LAYER)
	carbon.add_overlay(overcharge)

	if(do_after(carbon, 5 SECONDS, timed_action_flags = (IGNORE_USER_LOC_CHANGE|IGNORE_HELD_ITEM|IGNORE_INCAPACITATED)))
		if(ishuman(carbon))
			var/mob/living/carbon/human/human = carbon
			if(human.dna?.species)
				//fixed_mut_color is also drone color (for some reason)
				carbon.flash_lighting_fx(5, 7, human.dna.species.fixed_mut_color ? human.dna.species.fixed_mut_color : human.dna.features["mcolor"])

		playsound(carbon, 'sound/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
		carbon.cut_overlay(overcharge)
		tesla_zap(carbon, 2, crystal_charge*2.5, ZAP_OBJ_DAMAGE | ZAP_LOW_POWER_GEN | ZAP_ALLOW_DUPLICATES)
		adjust_charge(DRONE_CHARGE_FULL - crystal_charge)
		carbon.visible_message(span_danger("[carbon] violently discharges energy!"), span_warning("You violently discharge energy!"))

		if(prob(10)) //chance of developing heart disease to dissuade overcharging oneself
			var/datum/disease/D = new /datum/disease/heart_failure
			carbon.ForceContractDisease(D)
			to_chat(carbon, span_userdanger("You're pretty sure you just felt your heart stop for a second there.."))
			carbon.playsound_local(carbon, 'sound/effects/singlebeat.ogg', 100, 0)

		carbon.Paralyze(100)
