
//////////////////////////Poison stuff (Toxins & Acids)///////////////////////

/datum/reagent/toxin
	name = "Toxin"
	description = "A toxic chemical."
	color = "#CF3600" // rgb: 207, 54, 0
	taste_description = "bitterness"
	taste_mult = 1.2
	harmful = TRUE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	///The amount of toxin damage this will cause when metabolized (also used to calculate liver damage)
	var/toxpwr = 1.5
	///won't produce a pain message when processed by liver/life() if there isn't another non-silent toxin present if true
	var/silent_toxin = FALSE
	///The afflicted must be above this health value in order for the toxin to deal damage
	var/health_required = -100

// Are you a bad enough dude to poison your own plants?
/datum/reagent/toxin/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	if(!check_tray(chems, mytray))
		return

	mytray.adjust_toxic(round(chems.get_reagent_amount(type) * 2))

/datum/reagent/toxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(toxpwr && affected_mob.health > health_required)
		affected_mob.adjustToxLoss(toxpwr * REM * normalise_creation_purity() * seconds_per_tick, FALSE, required_biotype = affected_biotype)
		. = TRUE
	..()

/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 2.5
	taste_description = "mushroom"
	ph = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutagen
	name = "Unstable Mutagen"
	description = "Might cause unpredictable mutations. Keep away from children."
	color = "#00FF00"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	taste_description = "slime"
	taste_mult = 0.9
	ph = 2.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutagen/expose_mob(mob/living/carbon/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!exposed_mob.can_mutate())
		return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.
	if(((methods & VAPOR) && prob(min(33, reac_volume))) || (methods & (INGEST|PATCH|INJECT)))
		exposed_mob.random_mutate_unique_identity()
		exposed_mob.random_mutate_unique_features()
		if(prob(98))
			exposed_mob.easy_random_mutate(NEGATIVE+MINOR_NEGATIVE)
		else
			exposed_mob.easy_random_mutate(POSITIVE)
		exposed_mob.updateappearance()
		exposed_mob.domutcheck()

/datum/reagent/toxin/mutagen/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjustToxLoss(0.5 * seconds_per_tick * REM, required_biotype = affected_biotype)
	return ..()

/datum/reagent/toxin/mutagen/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	if(!check_tray(chems, mytray))
		return

	mytray.mutation_roll(user)

	mytray.adjust_toxic(3) //It is still toxic, mind you, but not to the same degree.

#define LIQUID_PLASMA_BP (50+T0C)
#define LIQUID_PLASMA_IG (325+T0C)

/datum/reagent/toxin/plasma
	name = "Plasma"
	description = "Plasma in its liquid form."
	taste_description = "bitterness"
	specific_heat = SPECIFIC_HEAT_PLASMA
	taste_mult = 1.5
	color = "#8228A0"
	toxpwr = 3
	material = /datum/material/plasma
	penetrates_skin = NONE
	ph = 4
	burning_temperature = 4500//plasma is hot!!
	burning_volume = 0.3//But burns fast
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/plasma/on_new(data)
	. = ..()
	RegisterSignal(holder, COMSIG_REAGENTS_TEMP_CHANGE, PROC_REF(on_temp_change))

/datum/reagent/toxin/plasma/Destroy()
	UnregisterSignal(holder, COMSIG_REAGENTS_TEMP_CHANGE)
	return ..()

/datum/reagent/toxin/plasma/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(holder.has_reagent(/datum/reagent/medicine/epinephrine))
		holder.remove_reagent(/datum/reagent/medicine/epinephrine, 2 * REM * seconds_per_tick)
	affected_mob.adjustPlasma(20 * REM * seconds_per_tick)
	return ..()

/datum/reagent/toxin/plasma/on_mob_metabolize(mob/living/carbon/affected_mob)
	if(HAS_TRAIT(affected_mob, TRAIT_PLASMA_LOVER_METABOLISM)) // sometimes mobs can temporarily metabolize plasma (e.g. plasma fixation disease symptom)
		toxpwr = 0

/datum/reagent/toxin/plasma/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	toxpwr = initial(toxpwr)

/// Handles plasma boiling.
/datum/reagent/toxin/plasma/proc/on_temp_change(datum/reagents/_holder, old_temp)
	SIGNAL_HANDLER
	if(holder.chem_temp < LIQUID_PLASMA_BP)
		return
	if(!holder.my_atom)
		return
	if((holder.flags & SEALED_CONTAINER) && (holder.chem_temp < LIQUID_PLASMA_IG))
		return
	var/atom/A = holder.my_atom
	A.atmos_spawn_air("plasma=[volume];TEMP=[holder.chem_temp]")
	holder.del_reagent(type)

/datum/reagent/toxin/plasma/expose_turf(turf/open/exposed_turf, reac_volume)
	if(!istype(exposed_turf))
		return
	var/temp = holder ? holder.chem_temp : T20C
	if(temp >= LIQUID_PLASMA_BP)
		exposed_turf.atmos_spawn_air("plasma=[reac_volume];TEMP=[temp]")
	return ..()

#undef LIQUID_PLASMA_BP
#undef LIQUID_PLASMA_IG

/datum/reagent/toxin/plasma/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people with plasma is stronger than fuel!
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.adjust_fire_stacks(reac_volume / 5)
		return

/datum/reagent/toxin/hot_ice
	name = "Hot Ice Slush"
	description = "Frozen plasma, worth its weight in gold, to the right people."
	reagent_state = SOLID
	color = "#724cb8" // rgb: 114, 76, 184
	taste_description = "thick and smokey"
	specific_heat = SPECIFIC_HEAT_PLASMA
	toxpwr = 3
	material = /datum/material/hot_ice
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/hot_ice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(holder.has_reagent(/datum/reagent/medicine/epinephrine))
		holder.remove_reagent(/datum/reagent/medicine/epinephrine, 2 * REM * seconds_per_tick)
	affected_mob.adjustPlasma(20 * REM * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-7 * TEMPERATURE_DAMAGE_COEFFICIENT * REM * seconds_per_tick, affected_mob.get_body_temp_normal())
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/humi = affected_mob
		humi.adjust_coretemperature(-7 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())
	return ..()

/datum/reagent/toxin/hot_ice/on_mob_metabolize(mob/living/carbon/affected_mob)
	if(HAS_TRAIT(affected_mob, TRAIT_PLASMA_LOVER_METABOLISM))
		toxpwr = 0

/datum/reagent/toxin/hot_ice/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	toxpwr = initial(toxpwr)

/datum/reagent/toxin/lexorin
	name = "Lexorin"
	description = "A powerful poison used to stop respiration."
	color = "#7DC3A0"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	taste_description = "acid"
	ph = 1.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/lexorin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = TRUE

	if(HAS_TRAIT(affected_mob, TRAIT_NOBREATH))
		. = FALSE

	if(.)
		affected_mob.adjustOxyLoss(5 * REM * normalise_creation_purity() * seconds_per_tick, FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
		affected_mob.losebreath += 2 * REM * normalise_creation_purity() * seconds_per_tick
		if(SPT_PROB(10, seconds_per_tick))
			affected_mob.emote("gasp")
	..()

/datum/reagent/toxin/lexorin/on_mob_metabolize(mob/living/affected_mob)
	RegisterSignal(affected_mob, COMSIG_CARBON_ATTEMPT_BREATHE, PROC_REF(block_breath))

/datum/reagent/toxin/lexorin/on_mob_end_metabolize(mob/living/affected_mob)
	UnregisterSignal(affected_mob, COMSIG_CARBON_ATTEMPT_BREATHE, PROC_REF(block_breath))

/datum/reagent/toxin/lexorin/proc/block_breath(mob/living/source)
	SIGNAL_HANDLER
	return COMSIG_CARBON_BLOCK_BREATH

/datum/reagent/toxin/slimejelly
	name = "Slime Jelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	color = "#801E28" // rgb: 128, 30, 40
	toxpwr = 0
	taste_description = "slime"
	taste_mult = 1.3
	ph = 10
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/slimejelly/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(SPT_PROB(5, seconds_per_tick))
		to_chat(affected_mob, span_danger("Your insides are burning!"))
		affected_mob.adjustToxLoss(rand(20, 60), FALSE, required_biotype = affected_biotype)
		. = TRUE
	else if(SPT_PROB(23, seconds_per_tick))
		affected_mob.heal_bodypart_damage(5)
		. = TRUE
	..()

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded spess carp."
	silent_toxin = TRUE
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 1
	taste_description = "fish"
	ph = 12
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	silent_toxin = TRUE
	reagent_state = SOLID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5
	taste_description = "death"
	penetrates_skin = NONE
	ph = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/zombiepowder/on_mob_metabolize(mob/living/holder_mob)
	. = ..()
	holder_mob.adjustOxyLoss(0.5*REM, FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	if(data?["method"] & INGEST)
		holder_mob.fakedeath(type)

/datum/reagent/toxin/zombiepowder/on_mob_end_metabolize(mob/living/holder_mob)
	holder_mob.cure_fakedeath(type)
	return ..()

/datum/reagent/toxin/zombiepowder/on_transfer(atom/target_atom, methods, trans_volume)
	. = ..()
	var/datum/reagent/zombiepowder = target_atom.reagents.has_reagent(/datum/reagent/toxin/zombiepowder)
	if(!zombiepowder || !(methods & INGEST))
		return
	LAZYINITLIST(zombiepowder.data)
	zombiepowder.data["method"] |= INGEST

/datum/reagent/toxin/zombiepowder/on_mob_life(mob/living/affected_mob, seconds_per_tick, times_fired)
	if(HAS_TRAIT(affected_mob, TRAIT_FAKEDEATH) && HAS_TRAIT(affected_mob, TRAIT_DEATHCOMA))
		..()
		return TRUE
	switch(current_cycle)
		if(1 to 5)
			affected_mob.adjust_confusion(1 SECONDS * REM * seconds_per_tick)
			affected_mob.adjust_drowsiness(2 SECONDS * REM * seconds_per_tick)
			affected_mob.adjust_slurring(6 SECONDS * REM * seconds_per_tick)
		if(5 to 8)
			affected_mob.adjustStaminaLoss(40 * REM * seconds_per_tick, 0)
		if(9 to INFINITY)
			affected_mob.fakedeath(type)
	..()
	return TRUE

/datum/reagent/toxin/ghoulpowder
	name = "Ghoul Powder"
	description = "A strong neurotoxin that slows metabolism to a death-like state, while keeping the patient fully active. Causes toxin buildup if used too long."
	reagent_state = SOLID
	color = "#664700" // rgb: 102, 71, 0
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0.8
	taste_description = "death"
	ph = 14.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/ghoulpowder/on_mob_metabolize(mob/living/affected_mob)
	..()
	ADD_TRAIT(affected_mob, TRAIT_FAKEDEATH, type)

/datum/reagent/toxin/ghoulpowder/on_mob_end_metabolize(mob/living/affected_mob)
	REMOVE_TRAIT(affected_mob, TRAIT_FAKEDEATH, type)
	..()

/datum/reagent/toxin/ghoulpowder/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjustOxyLoss(1 * REM * seconds_per_tick, FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	..()
	. = TRUE

/datum/reagent/toxin/mindbreaker
	name = "Mindbreaker Toxin"
	description = "A powerful hallucinogen. Not a thing to be messed with. For some mental patients. it counteracts their symptoms and anchors them to reality."
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0
	taste_description = "sourness"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	ph = 11
	inverse_chem = /datum/reagent/impurity/rosenol
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/hallucinogens = 18)  //7.2 per 2 seconds


/datum/reagent/toxin/mindbreaker/on_mob_metabolize(mob/living/metabolizer)
	. = ..()
	ADD_TRAIT(metabolizer, TRAIT_RDS_SUPPRESSED, type)

/datum/reagent/toxin/mindbreaker/on_mob_end_metabolize(mob/living/metabolizer)
	. = ..()
	REMOVE_TRAIT(metabolizer, TRAIT_RDS_SUPPRESSED, type)

/datum/reagent/toxin/mindbreaker/on_mob_life(mob/living/carbon/metabolizer, seconds_per_tick, times_fired)
	// mindbreaker toxin assuages hallucinations in those plagued with it, mentally
	if(metabolizer.has_trauma_type(/datum/brain_trauma/mild/hallucinations))
		metabolizer.remove_status_effect(/datum/status_effect/hallucination)

	// otherwise it creates hallucinations. truly a miracle medicine.
	else
		metabolizer.adjust_hallucinations(10 SECONDS * REM * seconds_per_tick)

	return ..()

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	color = "#49002E" // rgb: 73, 0, 46
	toxpwr = 1
	taste_mult = 1
	penetrates_skin = NONE
	ph = 2.7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

	// Plant-B-Gone is just as bad
/datum/reagent/toxin/plantbgone/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	if(!check_tray(chems, mytray))
		return

	mytray.adjust_plant_health(-round(chems.get_reagent_amount(type) * 10))
	mytray.adjust_toxic(round(chems.get_reagent_amount(type) * 6))
	mytray.adjust_weedlevel(-rand(4,8))

/datum/reagent/toxin/plantbgone/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(istype(exposed_obj, /obj/structure/alien/weeds))
		var/obj/structure/alien/weeds/alien_weeds = exposed_obj
		alien_weeds.take_damage(rand(15, 35), BRUTE, 0) // Kills alien weeds pretty fast
	if(istype(exposed_obj, /obj/structure/alien/resin/flower_bud))
		var/obj/structure/alien/resin/flower_bud/flower = exposed_obj
		flower.take_damage(rand(30, 50), BRUTE, 0)
	else if(istype(exposed_obj, /obj/structure/glowshroom)) //even a small amount is enough to kill it
		qdel(exposed_obj)
	else if(istype(exposed_obj, /obj/structure/spacevine))
		var/obj/structure/spacevine/SV = exposed_obj
		SV.on_chem_effect(src)

/datum/reagent/toxin/plantbgone/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume)
	. = ..()
	var/damage = min(round(0.4 * reac_volume, 0.1), 10)
	if(exposed_mob.mob_biotypes & MOB_PLANT)
		// spray bottle emits 5u so it's dealing ~15 dmg per spray
		exposed_mob.adjustToxLoss(damage * 20, required_biotype = affected_biotype)
		return

	if(!(methods & VAPOR) || !iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	if(!exposed_carbon.wear_mask)
		exposed_carbon.adjustToxLoss(damage, required_biotype = affected_biotype)

/datum/reagent/toxin/plantbgone/weedkiller
	name = "Weed Killer"
	description = "A harmful toxic mixture to kill weeds. Do not ingest!"
	color = "#4B004B" // rgb: 75, 0, 75
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

	//Weed Spray
/datum/reagent/toxin/plantbgone/weedkiller/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	if(!check_tray(chems, mytray))
		return

	mytray.adjust_toxic(round(chems.get_reagent_amount(type) * 0.5))
	mytray.adjust_weedlevel(-rand(1,2))

/datum/reagent/toxin/pestkiller
	name = "Pest Killer"
	description = "A harmful toxic mixture to kill pests. Do not ingest!"
	color = "#4B004B" // rgb: 75, 0, 75
	toxpwr = 1
	ph = 3.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//Pest Spray
/datum/reagent/toxin/pestkiller/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	if(!check_tray(chems, mytray))
		return

	mytray.adjust_toxic(round(chems.get_reagent_amount(type)))
	mytray.adjust_pestlevel(-rand(1,2))

/datum/reagent/toxin/pestkiller/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(exposed_mob.mob_biotypes & MOB_BUG)
		var/damage = min(round(0.4*reac_volume, 0.1),10)
		exposed_mob.adjustToxLoss(damage, required_biotype = affected_biotype)

/datum/reagent/toxin/pestkiller/organic
	name = "Natural Pest Killer"
	description = "An organic mixture used to kill pests, with less of the side effects. Do not ingest!"
	color = "#4b2400" // rgb: 75, 0, 75
	toxpwr = 1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

//Pest Spray
/datum/reagent/toxin/pestkiller/organic/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	if(!check_tray(chems, mytray))
		return

	mytray.adjust_toxic(round(chems.get_reagent_amount(type) * 0.1))
	mytray.adjust_pestlevel(-rand(1,2))

/datum/reagent/toxin/spore
	name = "Spore Toxin"
	description = "A natural toxin produced by blob spores that inhibits vision when ingested."
	color = "#9ACD32"
	toxpwr = 1
	ph = 11
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/spore/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.damageoverlaytemp = 60
	affected_mob.update_damage_hud()
	affected_mob.set_eye_blur_if_lower(6 SECONDS * REM * seconds_per_tick)
	return ..()

/datum/reagent/toxin/spore_burning
	name = "Burning Spore Toxin"
	description = "A natural toxin produced by blob spores that induces combustion in its victim."
	color = "#9ACD32"
	toxpwr = 0.5
	taste_description = "burning"
	ph = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/spore_burning/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjust_fire_stacks(2 * REM * seconds_per_tick)
	affected_mob.ignite_mob()
	return ..()

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	description = "A powerful sedative that induces confusion and drowsiness before putting its target to sleep."
	silent_toxin = TRUE
	reagent_state = SOLID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	ph = 11
	inverse_chem = /datum/reagent/impurity/chloralax
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/chloralhydrate/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	switch(current_cycle)
		if(1 to 2)
			affected_mob.adjust_confusion(2 SECONDS * REM * normalise_creation_purity() * seconds_per_tick)
			affected_mob.adjust_drowsiness(4 SECONDS * REM * normalise_creation_purity() * seconds_per_tick)
		if(2 to 75)
			affected_mob.Sleeping(40 * REM * normalise_creation_purity() * seconds_per_tick)
			. = TRUE
		if(75 to INFINITY)
			affected_mob.Sleeping(40 * REM * normalise_creation_purity() * seconds_per_tick)
			affected_mob.adjustToxLoss(1 * (current_cycle - 75) * REM * normalise_creation_purity() * seconds_per_tick, FALSE, required_biotype = affected_biotype)
			. = TRUE
	..()

/datum/reagent/toxin/fakebeer //disguised as normal beer for use by emagged brobots
	name = "B33r"
	description = "A specially-engineered sedative disguised as beer. It induces instant sleep in its target."
	color = "#664300" // rgb: 102, 67, 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "piss water"
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/glass_style/drinking_glass/fakebeer
	required_drink_type = /datum/reagent/toxin/fakebeer

/datum/glass_style/drinking_glass/fakebeer/New()
	. = ..()
	// Copy styles from the beer drinking glass datum
	var/datum/glass_style/copy_from = /datum/glass_style/drinking_glass/beer
	name = initial(copy_from.name)
	desc = initial(copy_from.desc)
	icon = initial(copy_from.icon)
	icon_state = initial(copy_from.icon_state)

/datum/reagent/toxin/fakebeer/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	switch(current_cycle)
		if(1 to 50)
			affected_mob.Sleeping(40 * REM * seconds_per_tick)
		if(51 to INFINITY)
			affected_mob.Sleeping(40 * REM * seconds_per_tick)
			affected_mob.adjustToxLoss(1 * (current_cycle - 50) * REM * seconds_per_tick, FALSE, required_biotype = affected_biotype)
	return ..()

/datum/reagent/toxin/coffeepowder
	name = "Coffee Grounds"
	description = "Finely ground coffee beans, used to make coffee."
	reagent_state = SOLID
	color = "#5B2E0D" // rgb: 91, 46, 13
	toxpwr = 0.5
	ph = 4.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/teapowder
	name = "Ground Tea Leaves"
	description = "Finely shredded tea leaves, used for making tea."
	reagent_state = SOLID
	color = "#7F8400" // rgb: 127, 132, 0
	toxpwr = 0.1
	taste_description = "green tea"
	ph = 4.9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mushroom_powder
	name = "Mushroom Powder"
	description = "Finely ground polypore mushrooms, ready to be steeped in water to make mushroom tea."
	reagent_state = SOLID
	color = "#67423A" // rgb: 127, 132, 0
	toxpwr = 0.1
	taste_description = "mushrooms"
	ph = 8.0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutetoxin //the new zombie powder.
	name = "Mute Toxin"
	description = "A nonlethal poison that inhibits speech in its victim."
	silent_toxin = TRUE
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#F0F8FF" // rgb: 240, 248, 255
	toxpwr = 0
	taste_description = "silence"
	ph = 12.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mutetoxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	// Gain approximately 12 seconds * creation purity seconds of silence every metabolism tick.
	affected_mob.set_silence_if_lower(6 SECONDS * REM * normalise_creation_purity() * seconds_per_tick)
	..()

/datum/reagent/toxin/staminatoxin
	name = "Tirizene"
	description = "A nonlethal poison that causes extreme fatigue and weakness in its victim."
	silent_toxin = TRUE
	color = "#6E2828"
	data = 15
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/staminatoxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjustStaminaLoss(data * REM * seconds_per_tick, 0)
	data = max(data - 1, 3)
	..()
	. = TRUE

/datum/reagent/toxin/polonium
	name = "Polonium"
	description = "An extremely radioactive material in liquid form. Ingestion results in fatal irradiation."
	reagent_state = LIQUID
	color = "#787878"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/polonium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if (!HAS_TRAIT(affected_mob, TRAIT_IRRADIATED) && SSradiation.can_irradiate_basic(affected_mob))
		affected_mob.AddComponent(/datum/component/irradiated)
	else
		affected_mob.adjustToxLoss(1 * REM * seconds_per_tick, required_biotype = affected_biotype)

	..()

/datum/reagent/toxin/histamine
	name = "Histamine"
	description = "Histamine's effects become more dangerous depending on the dosage amount. They range from mildly annoying to incredibly lethal."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#FA6464"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/histamine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(SPT_PROB(30, seconds_per_tick))
		switch(pick(1, 2, 3, 4))
			if(1)
				to_chat(affected_mob, span_danger("You can barely see!"))
				affected_mob.set_eye_blur_if_lower(6 SECONDS)
			if(2)
				affected_mob.emote("cough")
			if(3)
				affected_mob.emote("sneeze")
			if(4)
				if(prob(75))
					to_chat(affected_mob, span_danger("You scratch at an itch."))
					affected_mob.adjustBruteLoss(2*REM, FALSE, required_bodytype = affected_bodytype)
					. = TRUE
	..()

/datum/reagent/toxin/histamine/overdose_process(mob/living/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjustOxyLoss(2 * REM * seconds_per_tick, FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	affected_mob.adjustBruteLoss(2 * REM * seconds_per_tick, FALSE, FALSE, BODYTYPE_ORGANIC)
	affected_mob.adjustToxLoss(2 * REM * seconds_per_tick, FALSE, required_biotype = affected_biotype)
	..()
	. = TRUE

/datum/reagent/toxin/formaldehyde
	name = "Formaldehyde"
	description = "Formaldehyde, on its own, is a fairly weak toxin. It contains trace amounts of Histamine, very rarely making it decay into Histamine."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#B4004B"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 1
	ph = 2.0
	inverse_chem = /datum/reagent/impurity/methanol
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/formaldehyde/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(SPT_PROB(2.5, seconds_per_tick))
		holder.add_reagent(/datum/reagent/toxin/histamine, pick(5,15))
		holder.remove_reagent(/datum/reagent/toxin/formaldehyde, 1.2)
	else
		return ..()

/datum/reagent/toxin/venom
	name = "Venom"
	description = "An exotic poison extracted from highly toxic fauna. Causes scaling amounts of toxin damage and bruising depending and dosage. Often decays into Histamine."
	reagent_state = LIQUID
	color = "#F0FFF0"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	///Mob Size of the current mob sprite.
	var/current_size = RESIZE_DEFAULT_SIZE

/datum/reagent/toxin/venom/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	var/newsize = 1.1 * RESIZE_DEFAULT_SIZE
	affected_mob.resize = newsize/current_size
	current_size = newsize
	affected_mob.update_transform()

	toxpwr = 0.1 * volume
	affected_mob.adjustBruteLoss((0.3 * volume) * REM * seconds_per_tick, FALSE, required_bodytype = affected_bodytype)
	. = TRUE
	if(SPT_PROB(8, seconds_per_tick))
		holder.add_reagent(/datum/reagent/toxin/histamine, pick(5, 10))
		holder.remove_reagent(/datum/reagent/toxin/venom, 1.1)
	else
		..()

/datum/reagent/toxin/venom/on_mob_end_metabolize(mob/living/affected_mob)
	affected_mob.resize = RESIZE_DEFAULT_SIZE/current_size
	current_size = RESIZE_DEFAULT_SIZE
	affected_mob.update_transform()
	..()

/datum/reagent/toxin/fentanyl
	name = "Fentanyl"
	description = "Fentanyl will inhibit brain function and cause toxin damage before eventually knocking out its victim."
	reagent_state = LIQUID
	color = "#64916E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	ph = 9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/opioids = 25)

/datum/reagent/toxin/fentanyl/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3 * REM * normalise_creation_purity() * seconds_per_tick, 150)
	if(affected_mob.toxloss <= 60)
		affected_mob.adjustToxLoss(1 * REM * normalise_creation_purity() * seconds_per_tick, FALSE, required_biotype = affected_biotype)
	if(current_cycle >= 4)
		affected_mob.add_mood_event("smacked out", /datum/mood_event/narcotic_heavy, name)
	if(current_cycle >= 18)
		affected_mob.Sleeping(40 * REM * normalise_creation_purity() * seconds_per_tick)
	..()
	return TRUE

/datum/reagent/toxin/cyanide
	name = "Cyanide"
	description = "An infamous poison known for its use in assassination. Causes small amounts of toxin damage with a small chance of oxygen damage or a stun."
	reagent_state = LIQUID
	color = "#00B4FF"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1.25
	ph = 9.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/cyanide/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(SPT_PROB(2.5, seconds_per_tick))
		affected_mob.losebreath += 1
	if(SPT_PROB(4, seconds_per_tick))
		to_chat(affected_mob, span_danger("You feel horrendously weak!"))
		affected_mob.Stun(40)
		affected_mob.adjustToxLoss(2*REM * normalise_creation_purity(), FALSE, required_biotype = affected_biotype)
	return ..()

/datum/reagent/toxin/bad_food
	name = "Bad Food"
	description = "The result of some abomination of cookery, food so bad it's toxic."
	reagent_state = LIQUID
	color = "#d6d6d8"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0.5
	taste_description = "bad cooking"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/itching_powder
	name = "Itching Powder"
	description = "A powder that induces itching upon contact with the skin. Causes the victim to scratch at their itches and has a very low chance to decay into Histamine."
	silent_toxin = TRUE
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#C8C8C8"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	toxpwr = 0
	ph = 7
	penetrates_skin = TOUCH|VAPOR
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/itching_powder/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(SPT_PROB(8, seconds_per_tick))
		to_chat(affected_mob, span_danger("You scratch at your head."))
		affected_mob.adjustBruteLoss(0.2*REM, FALSE, required_bodytype = affected_bodytype)
		. = TRUE
	if(SPT_PROB(8, seconds_per_tick))
		to_chat(affected_mob, span_danger("You scratch at your leg."))
		affected_mob.adjustBruteLoss(0.2*REM, FALSE, required_bodytype = affected_bodytype)
		. = TRUE
	if(SPT_PROB(8, seconds_per_tick))
		to_chat(affected_mob, span_danger("You scratch at your arm."))
		affected_mob.adjustBruteLoss(0.2*REM, FALSE, required_bodytype = affected_bodytype)
		. = TRUE
	if(SPT_PROB(1.5, seconds_per_tick))
		holder.add_reagent(/datum/reagent/toxin/histamine,rand(1,3))
		holder.remove_reagent(/datum/reagent/toxin/itching_powder,1.2)
		return
	..()

/datum/reagent/toxin/initropidril
	name = "Initropidril"
	description = "A powerful poison with insidious effects. It can cause stuns, lethal breathing failure, and cardiac arrest."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#7F10C0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 2.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/initropidril/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(SPT_PROB(13, seconds_per_tick))
		var/picked_option = rand(1,3)
		switch(picked_option)
			if(1)
				affected_mob.Paralyze(60)
				. = TRUE
			if(2)
				affected_mob.losebreath += 10
				affected_mob.adjustOxyLoss(rand(5,25), FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
				. = TRUE
			if(3)
				if(!affected_mob.undergoing_cardiac_arrest() && affected_mob.can_heartattack())
					affected_mob.set_heartattack(TRUE)
					if(affected_mob.stat == CONSCIOUS)
						affected_mob.visible_message(span_userdanger("[affected_mob] clutches at [affected_mob.p_their()] chest as if [affected_mob.p_their()] heart stopped!"))
				else
					affected_mob.losebreath += 10
					affected_mob.adjustOxyLoss(rand(5,25), FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
					. = TRUE
	return ..() || .

/datum/reagent/toxin/pancuronium
	name = "Pancuronium"
	description = "An undetectable toxin that swiftly incapacitates its victim. May also cause breathing failure."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#195096"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_mult = 0 // undetectable, I guess?
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/pancuronium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(current_cycle >= 10)
		affected_mob.Stun(40 * REM * seconds_per_tick)
		. = TRUE
	if(SPT_PROB(10, seconds_per_tick))
		affected_mob.losebreath += 4
	..()

/datum/reagent/toxin/sodium_thiopental
	name = "Sodium Thiopental"
	description = "Sodium Thiopental induces heavy weakness in its target as well as unconsciousness."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#6496FA"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/sodium_thiopental/on_mob_add(mob/living/affected_mob, amount)
	. = ..()
	ADD_TRAIT(affected_mob, TRAIT_ANTICONVULSANT, name)

/datum/reagent/toxin/sodium_thiopental/on_mob_delete(mob/living/affected_mob)
	. = ..()
	REMOVE_TRAIT(affected_mob, TRAIT_ANTICONVULSANT, name)

/datum/reagent/toxin/sodium_thiopental/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(current_cycle >= 10)
		affected_mob.Sleeping(40 * REM * seconds_per_tick)
	affected_mob.adjustStaminaLoss(10 * REM * seconds_per_tick, 0)
	..()
	return TRUE

/datum/reagent/toxin/sulfonal
	name = "Sulfonal"
	description = "A stealthy poison that deals minor toxin damage and eventually puts the target to sleep."
	silent_toxin = TRUE
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#7DC3A0"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0.5
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/sulfonal/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(current_cycle >= 22)
		affected_mob.Sleeping(40 * REM * normalise_creation_purity() * seconds_per_tick)
	return ..()

/datum/reagent/toxin/amanitin
	name = "Amanitin"
	description = "A very powerful delayed toxin. Upon full metabolization, a massive amount of toxin damage will be dealt depending on how long it has been in the victim's bloodstream."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#FFFFFF"
	toxpwr = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/delayed_toxin_damage = 0

/datum/reagent/toxin/amanitin/on_mob_life(mob/living/affected_mob, seconds_per_tick, times_fired)
	delayed_toxin_damage += (seconds_per_tick * 3)
	. = ..()

/datum/reagent/toxin/amanitin/on_mob_delete(mob/living/affected_mob)
	affected_mob.log_message("has taken [delayed_toxin_damage] toxin damage from amanitin toxin", LOG_ATTACK)
	affected_mob.adjustToxLoss(delayed_toxin_damage, required_biotype = affected_biotype)
	. = ..()

/datum/reagent/toxin/lipolicide
	name = "Lipolicide"
	description = "A powerful toxin that will destroy fat cells, massively reducing body weight in a short time. Deadly to those without nutriment in their body."
	silent_toxin = TRUE
	taste_description = "mothballs"
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#F0FFF0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0
	ph = 6
	inverse_chem = /datum/reagent/impurity/ipecacide
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/lipolicide/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(affected_mob.nutrition <= NUTRITION_LEVEL_STARVING)
		affected_mob.adjustToxLoss(1 * REM * seconds_per_tick, FALSE, required_biotype = affected_biotype)
	affected_mob.adjust_nutrition(-3 * REM * normalise_creation_purity() * seconds_per_tick) // making the chef more valuable, one meme trap at a time
	affected_mob.overeatduration = 0
	return ..()

/datum/reagent/toxin/coniine
	name = "Coniine"
	description = "Coniine metabolizes extremely slowly, but deals high amounts of toxin damage and stops breathing."
	reagent_state = LIQUID
	color = "#7DC3A0"
	metabolization_rate = 0.06 * REAGENTS_METABOLISM
	toxpwr = 1.75
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/coniine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(affected_mob.losebreath < 5)
		affected_mob.losebreath = min(affected_mob.losebreath + 5 * REM * seconds_per_tick, 5)
	return ..()

/datum/reagent/toxin/spewium
	name = "Spewium"
	description = "A powerful emetic, causes uncontrollable vomiting.  May result in vomiting organs at high doses."
	reagent_state = LIQUID
	color = "#2f6617" //A sickly green color
	metabolization_rate = REAGENTS_METABOLISM
	overdose_threshold = 29
	toxpwr = 0
	taste_description = "vomit"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/spewium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	.=..()
	if(current_cycle >= 11 && SPT_PROB(min(30, current_cycle), seconds_per_tick))
		affected_mob.vomit(10, prob(10), prob(50), rand(0,4), TRUE)
		for(var/datum/reagent/toxin/R in affected_mob.reagents.reagent_list)
			if(R != src)
				affected_mob.reagents.remove_reagent(R.type,1)

/datum/reagent/toxin/spewium/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(current_cycle >= 33 && SPT_PROB(7.5, seconds_per_tick))
		affected_mob.spew_organ()
		affected_mob.vomit(0, TRUE, TRUE, 4)
		to_chat(affected_mob, span_userdanger("You feel something lumpy come up as you vomit."))

/datum/reagent/toxin/curare
	name = "Curare"
	description = "Causes slight toxin damage followed by chain-stunning and oxygen damage."
	reagent_state = LIQUID
	color = "#191919"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/curare/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(current_cycle >= 11)
		affected_mob.Paralyze(60 * REM * seconds_per_tick)
	affected_mob.adjustOxyLoss(0.5*REM*seconds_per_tick, FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	. = TRUE
	..()

/datum/reagent/toxin/heparin //Based on a real-life anticoagulant. I'm not a doctor, so this won't be realistic.
	name = "Heparin"
	description = "A powerful anticoagulant. All open cut wounds on the victim will open up and bleed much faster. It directly purges sanguirite, a coagulant."
	silent_toxin = TRUE
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#C8C8C8" //RGB: 200, 200, 200
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	toxpwr = 0
	ph = 11.6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/heparin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(holder.has_reagent(/datum/reagent/medicine/coagulant)) //Directly purges coagulants from the system. Get rid of the heparin BEFORE attempting to use coagulants.
		holder.remove_reagent(/datum/reagent/medicine/coagulant, 2 * REM * seconds_per_tick)
	return ..()

/datum/reagent/toxin/heparin/on_mob_metabolize(mob/living/affected_mob)
	ADD_TRAIT(affected_mob, TRAIT_BLOODY_MESS, /datum/reagent/toxin/heparin)
	return ..()

/datum/reagent/toxin/heparin/on_mob_end_metabolize(mob/living/affected_mob)
	REMOVE_TRAIT(affected_mob, TRAIT_BLOODY_MESS, /datum/reagent/toxin/heparin)
	return ..()

/datum/reagent/toxin/rotatium //Rotatium. Fucks up your rotation and is hilarious
	name = "Rotatium"
	description = "A constantly swirling, oddly colourful fluid. Causes the consumer's sense of direction and hand-eye coordination to become wild."
	silent_toxin = TRUE
	reagent_state = LIQUID
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#AC88CA" //RGB: 172, 136, 202
	metabolization_rate = 0.6 * REAGENTS_METABOLISM
	toxpwr = 0.5
	ph = 6.2
	taste_description = "spinning"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/rotatium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(affected_mob.hud_used)
		if(current_cycle >= 20 && (current_cycle % 20) == 0)
			var/atom/movable/plane_master_controller/pm_controller = affected_mob.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

			var/rotation = min(round(current_cycle/20), 89) // By this point the player is probably puking and quitting anyway
			for(var/atom/movable/screen/plane_master/plane as anything in pm_controller.get_planes())
				animate(plane, transform = matrix(rotation, MATRIX_ROTATE), time = 5, easing = QUAD_EASING, loop = -1)
				animate(transform = matrix(-rotation, MATRIX_ROTATE), time = 5, easing = QUAD_EASING)
	return ..()

/datum/reagent/toxin/rotatium/on_mob_end_metabolize(mob/living/affected_mob)
	if(affected_mob?.hud_used)
		var/atom/movable/plane_master_controller/pm_controller = affected_mob.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
		for(var/atom/movable/screen/plane_master/plane as anything in pm_controller.get_planes())
			animate(plane, transform = matrix(), time = 5, easing = QUAD_EASING)
	..()

/datum/reagent/toxin/anacea
	name = "Anacea"
	description = "A toxin that quickly purges medicines and metabolizes very slowly."
	reagent_state = LIQUID
	color = "#3C5133"
	metabolization_rate = 0.08 * REAGENTS_METABOLISM
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0.15
	ph = 8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/anacea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	var/remove_amt = 5
	if(holder.has_reagent(/datum/reagent/medicine/calomel) || holder.has_reagent(/datum/reagent/medicine/pen_acid))
		remove_amt = 0.5
	for(var/datum/reagent/medicine/R in affected_mob.reagents.reagent_list)
		affected_mob.reagents.remove_reagent(R.type, remove_amt * REM * normalise_creation_purity() * seconds_per_tick)
	return ..()

//ACID


/datum/reagent/toxin/acid
	name = "Sulfuric Acid"
	description = "A strong mineral acid with the molecular formula H2SO4."
	color = "#00FF32"
	toxpwr = 1
	var/acidpwr = 10 //the amount of protection removed from the armour
	taste_description = "acid"
	self_consuming = TRUE
	ph = 2.75
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// ...Why? I mean, clearly someone had to have done this and thought, well, acid doesn't hurt plants, but what brought us here, to this point?
/datum/reagent/toxin/acid/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	if(!check_tray(chems, mytray))
		return

	mytray.adjust_plant_health(-round(chems.get_reagent_amount(type)))
	mytray.adjust_toxic(round(chems.get_reagent_amount(type) * 1.5))
	mytray.adjust_weedlevel(-rand(1,2))

/datum/reagent/toxin/acid/expose_mob(mob/living/carbon/exposed_carbon, methods=TOUCH, reac_volume)
	. = ..()
	if(!istype(exposed_carbon))
		return
	reac_volume = round(reac_volume,0.1)
	if(methods & INGEST)
		exposed_carbon.adjustBruteLoss(min(6*toxpwr, reac_volume * toxpwr), required_bodytype = affected_bodytype)
		return
	if(methods & INJECT)
		exposed_carbon.adjustBruteLoss(1.5 * min(6*toxpwr, reac_volume * toxpwr), required_bodytype = affected_bodytype)
		return
	exposed_carbon.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(ismob(exposed_obj.loc)) //handled in human acid_act()
		return
	reac_volume = round(reac_volume,0.1)
	exposed_obj.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if (!istype(exposed_turf))
		return
	reac_volume = round(reac_volume,0.1)
	exposed_turf.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/fluacid
	name = "Fluorosulfuric Acid"
	description = "Fluorosulfuric acid is an extremely corrosive chemical substance."
	color = "#5050FF"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 2
	acidpwr = 42.0
	ph = 0.0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// SERIOUSLY
/datum/reagent/toxin/acid/fluacid/on_hydroponics_apply(obj/item/seeds/myseed, datum/reagents/chems, obj/machinery/hydroponics/mytray, mob/user)
	if(!check_tray(chems, mytray))
		return

	mytray.adjust_plant_health(-round(chems.get_reagent_amount(type) * 2))
	mytray.adjust_toxic(round(chems.get_reagent_amount(type) * 3))
	mytray.adjust_weedlevel(-rand(1,4))

/datum/reagent/toxin/acid/fluacid/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjustFireLoss((current_cycle/15) * REM * normalise_creation_purity() * seconds_per_tick, FALSE, required_bodytype = affected_bodytype)
	. = TRUE
	..()

/datum/reagent/toxin/acid/nitracid
	name = "Nitric Acid"
	description = "Nitric acid is an extremely corrosive chemical substance that violently reacts with living organic tissue."
	color = "#5050FF"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 3
	acidpwr = 5.0
	ph = 1.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/acid/nitracid/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjustFireLoss((volume/10) * REM * normalise_creation_purity() * seconds_per_tick, FALSE, required_bodytype = affected_bodytype) //here you go nervar
	. = TRUE
	..()

/datum/reagent/toxin/delayed
	name = "Toxin Microcapsules"
	description = "Causes heavy toxin damage after a brief time of inactivity."
	reagent_state = LIQUID
	metabolization_rate = 0 //stays in the system until active.
	var/actual_metaboliztion_rate = REAGENTS_METABOLISM
	toxpwr = 0
	var/actual_toxpwr = 5
	var/delay = 30
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/delayed/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(current_cycle > delay)
		holder.remove_reagent(type, actual_metaboliztion_rate * affected_mob.metabolism_efficiency * seconds_per_tick)
		affected_mob.adjustToxLoss(actual_toxpwr * REM * seconds_per_tick, FALSE, required_biotype = affected_biotype)
		if(SPT_PROB(5, seconds_per_tick))
			affected_mob.Paralyze(20)
		. = TRUE
	..()

/datum/reagent/toxin/mimesbane
	name = "Mime's Bane"
	description = "A nonlethal neurotoxin that interferes with the victim's ability to gesture."
	silent_toxin = TRUE
	color = "#F0F8FF" // rgb: 240, 248, 255
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	ph = 1.7
	taste_description = "stillness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/mimesbane/on_mob_metabolize(mob/living/affected_mob)
	ADD_TRAIT(affected_mob, TRAIT_EMOTEMUTE, type)

/datum/reagent/toxin/mimesbane/on_mob_end_metabolize(mob/living/affected_mob)
	REMOVE_TRAIT(affected_mob, TRAIT_EMOTEMUTE, type)

/datum/reagent/toxin/bonehurtingjuice //oof ouch
	name = "Bone Hurting Juice"
	description = "A strange substance that looks a lot like water. Drinking it is oddly tempting. Oof ouch."
	silent_toxin = TRUE //no point spamming them even more.
	color = "#AAAAAA77" //RGBA: 170, 170, 170, 77
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	ph = 3.1
	taste_description = "bone hurting"
	overdose_threshold = 50
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/bonehurtingjuice/on_mob_add(mob/living/carbon/affected_mob)
	affected_mob.say("oof ouch my bones", forced = /datum/reagent/toxin/bonehurtingjuice)
	return ..()

/datum/reagent/toxin/bonehurtingjuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjustStaminaLoss(7.5 * REM * seconds_per_tick, 0)
	if(SPT_PROB(10, seconds_per_tick))
		switch(rand(1, 3))
			if(1)
				affected_mob.say(pick("oof.", "ouch.", "my bones.", "oof ouch.", "oof ouch my bones."), forced = /datum/reagent/toxin/bonehurtingjuice)
			if(2)
				affected_mob.manual_emote(pick("oofs silently.", "looks like [affected_mob.p_their()] bones hurt.", "grimaces, as though [affected_mob.p_their()] bones hurt."))
			if(3)
				to_chat(affected_mob, span_warning("Your bones hurt!"))
	return ..()

/datum/reagent/toxin/bonehurtingjuice/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	if(SPT_PROB(2, seconds_per_tick) && iscarbon(affected_mob)) //big oof
		var/selected_part = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) //God help you if the same limb gets picked twice quickly.
		var/obj/item/bodypart/BP = affected_mob.get_bodypart(selected_part)
		if(BP)
			playsound(affected_mob, get_sfx(SFX_DESECRATION), 50, TRUE, -1)
			affected_mob.visible_message(span_warning("[affected_mob]'s bones hurt too much!!"), span_danger("Your bones hurt too much!!"))
			affected_mob.say("OOF!!", forced = /datum/reagent/toxin/bonehurtingjuice)
			BP.receive_damage(20, 0, 200, wound_bonus = rand(30, 130))
		else //SUCH A LUST FOR REVENGE!!!
			to_chat(affected_mob, span_warning("A phantom limb hurts!"))
			affected_mob.say("Why are we still here, just to suffer?", forced = /datum/reagent/toxin/bonehurtingjuice)
	return ..()

/datum/reagent/toxin/bungotoxin
	name = "Bungotoxin"
	description = "A horrible cardiotoxin that protects the humble bungo pit."
	silent_toxin = TRUE
	color = "#EBFF8E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_description = "tannin"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/bungotoxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjustOrganLoss(ORGAN_SLOT_HEART, 3 * REM * seconds_per_tick)

	// If our mob's currently dizzy from anything else, we will also gain confusion
	var/mob_dizziness = affected_mob.get_timed_status_effect_duration(/datum/status_effect/confusion)
	if(mob_dizziness > 0)
		// Gain confusion equal to about half the duration of our current dizziness
		affected_mob.set_confusion(mob_dizziness / 2)

	if(current_cycle >= 12 && SPT_PROB(4, seconds_per_tick))
		var/tox_message = pick("You feel your heart spasm in your chest.", "You feel faint.","You feel you need to catch your breath.","You feel a prickle of pain in your chest.")
		to_chat(affected_mob, span_notice("[tox_message]"))
	. = TRUE
	..()

/datum/reagent/toxin/leadacetate
	name = "Lead Acetate"
	description = "Used hundreds of years ago as a sweetener, before it was realized that it's incredibly poisonous."
	reagent_state = SOLID
	color = "#2b2b2b" // rgb: 127, 132, 0
	toxpwr = 0.5
	taste_mult = 1.3
	taste_description = "sugary sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/leadacetate/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjustOrganLoss(ORGAN_SLOT_EARS, 1 * REM * seconds_per_tick)
	affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1 * REM * seconds_per_tick)
	if(SPT_PROB(0.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("Ah, what was that? You thought you heard something..."))
		affected_mob.adjust_confusion(5 SECONDS)
	return ..()

/datum/reagent/toxin/hunterspider
	name = "Spider Toxin"
	description = "A toxic chemical produced by spiders to weaken prey."
	health_required = 40

/datum/reagent/toxin/viperspider
	name = "Viper Spider Toxin"
	toxpwr = 5
	description = "An extremely toxic chemical produced by the rare viper spider. Brings their prey to the brink of death and causes hallucinations."
	health_required = 10

/datum/reagent/toxin/viperspider/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjust_hallucinations(10 SECONDS * REM * seconds_per_tick)
	return ..()
