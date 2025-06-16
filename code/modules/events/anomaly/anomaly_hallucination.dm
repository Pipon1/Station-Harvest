/datum/round_event_control/anomaly/anomaly_hallucination
	name = "Anomalie : hallucinations"
	typepath = /datum/round_event/anomaly/anomaly_hallucination

	min_players = 10
	max_occurrences = 5
	weight = 20
	description = "Cette anomalie cause des hallucinations."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 2

/datum/round_event/anomaly/anomaly_hallucination
	start_when = ANOMALY_START_MEDIUM_TIME
	announce_when = ANOMALY_ANNOUNCE_MEDIUM_TIME
	anomaly_path = /obj/effect/anomaly/hallucination

/datum/round_event/anomaly/anomaly_hallucination/announce(fake)
	priority_announce("Évènement hallucinatoire à [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name].", "Alerte anomalie")
