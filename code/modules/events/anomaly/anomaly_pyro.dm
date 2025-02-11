/datum/round_event_control/anomaly/anomaly_pyro
	name = "Anomalie : Pyroclastique"
	typepath = /datum/round_event/anomaly/anomaly_pyro

	max_occurrences = 5
	weight = 20
	description = "Cette anomalie provoque un incendie puis crée un slime pyroclastique."
	min_wizard_trigger_potency = 1
	max_wizard_trigger_potency = 4

/datum/round_event/anomaly/anomaly_pyro
	start_when = ANOMALY_START_HARMFUL_TIME
	announce_when = ANOMALY_ANNOUNCE_HARMFUL_TIME
	anomaly_path = /obj/effect/anomaly/pyro

/datum/round_event/anomaly/anomaly_pyro/announce(fake)
	priority_announce("Anomalie pyroclastique détectée à [ANOMALY_ANNOUNCE_HARMFUL_TEXT] [impact_area.name].", "Alerte anomalie")
