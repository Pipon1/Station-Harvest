/datum/round_event_control/anomaly/anomaly_grav
	name = "Anomalie : gravitationnelle"
	typepath = /datum/round_event/anomaly/anomaly_grav

	max_occurrences = 5
	weight = 25
	description = "Cette anomalie fait voler les objets autour."
	min_wizard_trigger_potency = 1
	max_wizard_trigger_potency = 3

/datum/round_event/anomaly/anomaly_grav
	start_when = ANOMALY_START_HARMFUL_TIME
	announce_when = ANOMALY_ANNOUNCE_HARMFUL_TIME
	anomaly_path = /obj/effect/anomaly/grav

/datum/round_event_control/anomaly/anomaly_grav/high
	name = "Anomalie : gravitationnelle (Haute Intensité)"
	typepath = /datum/round_event/anomaly/anomaly_grav/high
	weight = 15
	max_occurrences = 1
	earliest_start = 20 MINUTES
	description = "Cette anomalie a un champ gravitationnell intense. Elle peut désactiver le générateur de gravité."

/datum/round_event/anomaly/anomaly_grav/high
	start_when = ANOMALY_START_HARMFUL_TIME
	announce_when = ANOMALY_ANNOUNCE_HARMFUL_TIME
	anomaly_path = /obj/effect/anomaly/grav/high

/datum/round_event/anomaly/anomaly_grav/announce(fake)
	priority_announce("Anomalie gravitationnelle détectée à [ANOMALY_ANNOUNCE_HARMFUL_TEXT] [impact_area.name].", "Alerte anomalie" , ANNOUNCER_GRANOMALIES)
