/datum/round_event_control/wizard/invincible //Boolet Proof
	name = "Invincibilité"
	weight = 3
	typepath = /datum/round_event/wizard/invincible
	max_occurrences = 5
	earliest_start = 0 MINUTES
	description = "Tout le monde est invincible pendant un court moment."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 7

/datum/round_event/wizard/invincible/start()

	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		H.reagents.add_reagent(/datum/reagent/medicine/adminordrazine, 40) //100 ticks of absolute invinciblity (barring gibs)
		to_chat(H, span_notice("Vous vous sentez invincible, rien ne peut vous faire du mal !"))
