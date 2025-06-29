/datum/round_event_control/anomaly/anomaly_flux
	name = "Anomalie : flux hyper-énergétique"
	typepath = /datum/round_event/anomaly/anomaly_flux

	min_players = 10
	max_occurrences = 5
	weight = 20
	description = "Cette anomalie This anomaly shocks and explodes."
	min_wizard_trigger_potency = 1
	max_wizard_trigger_potency = 4

/datum/round_event/anomaly/anomaly_flux
	start_when = ANOMALY_START_DANGEROUS_TIME
	announce_when = ANOMALY_ANNOUNCE_DANGEROUS_TIME
	anomaly_path = /obj/effect/anomaly/flux

/datum/round_event/anomaly/anomaly_flux/announce(fake)
	priority_announce("Flux hyper-énergétique anormal détecté à [ANOMALY_ANNOUNCE_DANGEROUS_TEXT]. [impact_area.name].", "Alerte anomalie")
