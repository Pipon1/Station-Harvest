/datum/round_event_control/space_dust
	name = "Poussière spatiale : mineure"
	typepath = /datum/round_event/space_dust
	weight = 200
	max_occurrences = 1000
	earliest_start = 0 MINUTES
	alert_observers = FALSE
	category = EVENT_CATEGORY_SPACE
	description = "Une unique poussière spatiale va être projetée sur la station."
	map_flags = EVENT_SPACE_ONLY

/datum/round_event/space_dust
	start_when = 1
	end_when = 2
	fakeable = FALSE

/datum/round_event/space_dust/start()
	spawn_meteors(1, GLOB.meteors_dust)

