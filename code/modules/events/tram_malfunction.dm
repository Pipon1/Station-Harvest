#define TRAM_MALFUNCTION_TIME_UPPER 210
#define TRAM_MALFUNCTION_TIME_LOWER 120

/datum/round_event_control/tram_malfunction
	name = "Défaillance de tram"
	typepath = /datum/round_event/tram_malfunction
	weight = 40
	max_occurrences = 4
	earliest_start = 15 MINUTES
	category = EVENT_CATEGORY_ENGINEERING
	description = "Défaillance des feu de croisement des trams, la probabilité de collision des trams est augmentée."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 3

//Check if there's a tram we can cause to malfunction.
/datum/round_event_control/tram_malfunction/can_spawn_event(players_amt, allow_magic = FALSE)
	. = ..()
	if (!.)
		return FALSE

	for(var/tram_id in GLOB.active_lifts_by_type)
		var/datum/lift_master/tram_ref = GLOB.active_lifts_by_type[tram_id][1]
		if(tram_ref.specific_lift_id == MAIN_STATION_TRAM)
			return .

	return FALSE

/datum/round_event/tram_malfunction
	announce_when = 1
	end_when = TRAM_MALFUNCTION_TIME_LOWER
	var/specific_lift_id = MAIN_STATION_TRAM
	var/original_lethality

/datum/round_event/tram_malfunction/setup()
	end_when = rand(TRAM_MALFUNCTION_TIME_LOWER, TRAM_MALFUNCTION_TIME_UPPER)

/datum/round_event/tram_malfunction/announce()
	priority_announce("Notre système de controle automatique a perdu contact avec les ordinateurs à bord du tram. Merci de prendre les précautions nécessaire lors de vos déplacements durant la durée de notre intervention. Les signaux et les freins d'urgence peuvent ne plus être disponibles pendant cette période.", "Division d'ingénierie de CentCom")

/datum/round_event/tram_malfunction/start()
	for(var/obj/machinery/crossing_signal/signal as anything in GLOB.tram_signals)
		signal.start_malfunction()

	for(var/obj/machinery/door/window/tram/door as anything in GLOB.tram_doors)
		door.start_malfunction()

	for(var/obj/machinery/destination_sign/sign as anything in GLOB.tram_signs)
		sign.malfunctioning = TRUE

	for(var/obj/structure/industrial_lift/tram as anything in GLOB.lifts)
		original_lethality = tram.collision_lethality
		tram.collision_lethality = original_lethality * 1.25

/datum/round_event/tram_malfunction/end()
	for(var/obj/machinery/crossing_signal/signal as anything in GLOB.tram_signals)
		signal.end_malfunction()

	for(var/obj/machinery/door/window/tram/door as anything in GLOB.tram_doors)
		door.end_malfunction()

	for(var/obj/machinery/destination_sign/sign as anything in GLOB.tram_signs)
		sign.malfunctioning = FALSE

	for(var/obj/structure/industrial_lift/tram as anything in GLOB.lifts)
		tram.collision_lethality = original_lethality

	priority_announce("Le logiciel du tram a été redémarré avec succès, fonctionnement standard revenu. Nous nous excusons pour tout désagrément.", "Division d'ingénierie de CentCom")

#undef TRAM_MALFUNCTION_TIME_UPPER
#undef TRAM_MALFUNCTION_TIME_LOWER
