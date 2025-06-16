/datum/round_event_control/gravity_generator_blackout
	name = "Blackout du générateur de gravité"
	typepath = /datum/round_event/gravity_generator_blackout
	weight = 30
	category = EVENT_CATEGORY_ENGINEERING
	description = "Éteint le générateur de gravité."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 4

/datum/round_event_control/gravity_generator_blackout/can_spawn_event(players_amt, allow_magic = FALSE)
	. = ..()
	if(!.)
		return .

	var/station_generator_exists = FALSE
	for(var/obj/machinery/gravity_generator/main/the_generator in GLOB.machines)
		if(is_station_level(the_generator.z))
			station_generator_exists = TRUE

	if(!station_generator_exists)
		return FALSE

/datum/round_event/gravity_generator_blackout
	announce_when = 1
	start_when = 1
	announce_chance = 33

/datum/round_event/gravity_generator_blackout/announce(fake)
	priority_announce("Anomalies gravmosphériques détectées près de [station_name()]. Redémarrage manuel du générateur nécessaire.", "Alerte anomalie", ANNOUNCER_GRANOMALIES)

/datum/round_event/gravity_generator_blackout/start()
	for(var/obj/machinery/gravity_generator/main/the_generator in GLOB.machines)
		if(is_station_level(the_generator.z))
			the_generator.blackout()
