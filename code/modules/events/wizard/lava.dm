/datum/round_event_control/wizard/lava //THE LEGEND NEVER DIES
	name = "The floor is LAVA !"
	weight = 2
	typepath = /datum/round_event/wizard/lava
	max_occurrences = 3
	earliest_start = 0 MINUTES
	description = "Change le sol en lave chaude."
	min_wizard_trigger_potency = 5
	max_wizard_trigger_potency = 7

/datum/round_event/wizard/lava
	end_when = 0
	var/started = FALSE

/datum/round_event/wizard/lava/start()
	if(!started)
		started = TRUE
		SSweather.run_weather(/datum/weather/floor_is_lava)
