/datum/traitor_objective_category/sleeper_protocol
	name = "Sleeper Protocol"
	objectives = list(
		/datum/traitor_objective/sleeper_protocol = 1,
		/datum/traitor_objective/sleeper_protocol/everybody = 1,
	)

/datum/traitor_objective/sleeper_protocol
	name = "Opérez un membre d'équipage pour en faire un agent dormant"
	description = "Utilisez le bouton pour matérialiser un disque content une opération dans votre main, vous pourrez l'utiliser pour apprendre l'opératio de création d'agent dormant. Si le disque est détruit, l'objetif sera considéré comme échoué. L'opération ne fonctionne que sur des êtres vivants."

	progression_minimum = 0 MINUTES

	progression_reward = list(8 MINUTES, 15 MINUTES)
	telecrystal_reward = 1

	var/list/limited_to = list(
		JOB_CHIEF_MEDICAL_OFFICER,
		JOB_MEDICAL_DOCTOR,
		JOB_PARAMEDIC,
		JOB_VIROLOGIST,
		JOB_ROBOTICIST,
	)

	var/obj/item/disk/surgery/sleeper_protocol/disk

	var/mob/living/current_registered_mob

	var/inverted_limitation = FALSE

/datum/traitor_objective/sleeper_protocol/generate_ui_buttons(mob/user)
	var/list/buttons = list()
	if(!disk)
		buttons += add_ui_button("", "Cliquez sur ce bouton pour matérialiser le disque d'opération dans votre main", "save", "summon_disk")
	return buttons

/datum/traitor_objective/sleeper_protocol/ui_perform_action(mob/living/user, action)
	switch(action)
		if("summon_disk")
			if(disk)
				return
			disk = new(user.drop_location())
			user.put_in_hands(disk)
			AddComponent(/datum/component/traitor_objective_register, disk, \
				fail_signals = list(COMSIG_PARENT_QDELETING))

/datum/traitor_objective/sleeper_protocol/proc/on_surgery_success(datum/source, datum/surgery_step/step, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	SIGNAL_HANDLER
	if(istype(step, /datum/surgery_step/brainwash/sleeper_agent))
		succeed_objective()

/datum/traitor_objective/sleeper_protocol/can_generate_objective(datum/mind/generating_for, list/possible_duplicates)
	var/datum/job/job = generating_for.assigned_role
	if(!(job.title in limited_to) && !inverted_limitation)
		return FALSE
	if((job.title in limited_to) && inverted_limitation)
		return FALSE
	if(length(possible_duplicates) > 0)
		return FALSE
	return TRUE

/datum/traitor_objective/sleeper_protocol/generate_objective(datum/mind/generating_for, list/possible_duplicates)
	AddComponent(/datum/component/traitor_objective_mind_tracker, generating_for, \
		signals = list(COMSIG_MOB_SURGERY_STEP_SUCCESS = PROC_REF(on_surgery_success)))
	return TRUE

/datum/traitor_objective/sleeper_protocol/ungenerate_objective()
	disk = null
/obj/item/disk/surgery/sleeper_protocol
	name = "Un disque d'opération suspicieux"
	desc = "Ce disque vous donne toutes les connaissances nécessaire pour effectuer une opération de création d'agent dormant."
	surgeries = list(/datum/surgery/advanced/brainwashing_sleeper)

/datum/surgery/advanced/brainwashing_sleeper
	name = "Opération de création d'agent dormant"
	desc = "Une opération qui modifie le cerveau du patient pour le transformer en agent dormant. Cela peut être annuler avec un implant de protection de l'esprit."
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/brainwash/sleeper_agent,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/brainwashing_sleeper/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/organ/internal/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!target_brain)
		return FALSE
	return TRUE

/datum/surgery_step/brainwash/sleeper_agent
	time = 25 SECONDS
	var/static/list/possible_objectives = list(
		"Vous aimez le syndicat.",
		"Vous ne devez pas croire Nanotrasen.",
		"Le capitaine est un homme lézard.",
		"Nanotrasen n'est pas réel.",
		"Il ont mit quelque chose dans la nourriture pour vous faire oublier.",
		"Vous êtes la seule personne réelle sur la station.",
		"Les sols non-standard sont vos ennemis.",
		"Votre coeur n'est pas le votre.",
		"Vous êtes un clone."
	)

/datum/surgery_step/brainwash/sleeper_agent/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	objective = pick(possible_objectives)
	display_results(
		user,
		target,
		span_notice("Vous commencer à laver l'esprit de [target]..."),
		span_notice("[user] soigne le cerveau de [target]."),
		span_notice("[user] commence à opérer le cerveau de [target]."),
	)
	display_pain(target, "Vous avez une migraine insupportable !") // Same message as other brain surgeries

/datum/surgery_step/brainwash/sleeper_agent/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(target.stat == DEAD)
		to_chat(user, span_warning("Ils doivent être en vie pour être opérer !"))
		return FALSE
	. = ..()
	if(!.)
		return
	target.gain_trauma(new /datum/brain_trauma/mild/phobia/conspiracies(), TRAUMA_RESILIENCE_LOBOTOMY)

/datum/traitor_objective/sleeper_protocol/everybody //Much harder for non-med and non-robo
	progression_minimum = 30 MINUTES
	progression_reward = list(8 MINUTES, 15 MINUTES)
	telecrystal_reward = 1

	inverted_limitation = TRUE
