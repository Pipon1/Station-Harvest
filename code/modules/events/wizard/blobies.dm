/datum/round_event_control/wizard/blobies //avast!
	name = "Épidémie de zombie"
	weight = 3
	typepath = /datum/round_event/wizard/blobies
	max_occurrences = 3
	description = "Spawn un spore de zombie sur tous les cadavres."
	min_wizard_trigger_potency = 3
	max_wizard_trigger_potency = 7

/datum/round_event/wizard/blobies/start()

	for(var/mob/living/carbon/human/H in GLOB.dead_mob_list)
		new /mob/living/simple_animal/hostile/blob/blobspore(H.loc)
