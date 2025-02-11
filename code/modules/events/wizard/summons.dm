/datum/round_event_control/wizard/summonguns //The Classic
	name = "Invocation d'armes à feu"
	weight = 1
	typepath = /datum/round_event/wizard/summonguns
	max_occurrences = 1
	earliest_start = 0 MINUTES
	description = "Invoque un flingue pour tout le monde. Peut rendre les gens survivaliste."

/datum/round_event_control/wizard/summonguns/New()
	if(CONFIG_GET(flag/no_summon_guns))
		weight = 0
	return ..()

/datum/round_event/wizard/summonguns/start()
	summon_guns(survivor_probability = 10)

/datum/round_event_control/wizard/summonmagic //The Somewhat Less Classic
	name = "Invocation d'objet magique"
	weight = 1
	typepath = /datum/round_event/wizard/summonmagic
	max_occurrences = 1
	earliest_start = 0 MINUTES
	description = "Invoque un objet magique pour tout le monde. Peut rendre les gens survivaliste"

/datum/round_event_control/wizard/summonmagic/New()
	if(CONFIG_GET(flag/no_summon_magic))
		weight = 0
	return ..()

/datum/round_event/wizard/summonmagic/start()
	summon_magic(survivor_probability = 10)
