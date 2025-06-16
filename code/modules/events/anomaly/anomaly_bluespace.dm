/datum/round_event_control/anomaly/anomaly_bluespace
	name = "Anomalie : Bluespace"
	typepath = /datum/round_event/anomaly/anomaly_bluespace

	max_occurrences = 1
	weight = 15
	description = "Cette anomalie téléporte tous les objets et êtres vivants d'une large zone à un autre endroit."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 2

/datum/round_event/anomaly/anomaly_bluespace
	start_when = ANOMALY_START_MEDIUM_TIME
	announce_when = ANOMALY_ANNOUNCE_MEDIUM_TIME
	anomaly_path = /obj/effect/anomaly/bluespace

/datum/round_event/anomaly/anomaly_bluespace/announce(fake)
	priority_announce("Instabilité Bluespace détectée [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name].", "Alerte anomalie")
