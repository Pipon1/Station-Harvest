/datum/round_event_control/brain_trauma
	name = "Spontaneous Brain Trauma"
	typepath = /datum/round_event/brain_trauma
	weight = 25
	category = EVENT_CATEGORY_HEALTH
	description = "Un membre de l'équipage gagne un traumatisme crânien aléatoire."
	min_wizard_trigger_potency = 2
	max_wizard_trigger_potency = 6

/datum/round_event/brain_trauma
	fakeable = FALSE

/datum/round_event/brain_trauma/start()
	for(var/mob/living/carbon/human/H in shuffle(GLOB.alive_mob_list))
		if(!H.client)
			continue
		if(H.stat == DEAD) // What are you doing in this list
			continue
		if(!H.get_organ_by_type(/obj/item/organ/internal/brain)) // If only I had a brain
			continue
		if(!(H.mind.assigned_role.job_flags & JOB_CREW_MEMBER)) //please stop giving my centcom admin gimmicks full body paralysis
			continue
		traumatize(H)
		announce_to_ghosts(H)
		break

/datum/round_event/brain_trauma/proc/traumatize(mob/living/carbon/human/H)
	var/resistance = pick(
		50;TRAUMA_RESILIENCE_BASIC,
		30;TRAUMA_RESILIENCE_SURGERY,
		15;TRAUMA_RESILIENCE_LOBOTOMY,
		5;TRAUMA_RESILIENCE_MAGIC)

	var/trauma_type = pick_weight(list(
		BRAIN_TRAUMA_MILD = 60,
		BRAIN_TRAUMA_SEVERE = 30,
		BRAIN_TRAUMA_SPECIAL = 10
	))

	H.gain_trauma_type(trauma_type, resistance)
