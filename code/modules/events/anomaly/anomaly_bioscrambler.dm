/datum/round_event_control/anomaly/anomaly_bioscrambler
	name = "Anomalie : biobrouilleur"
	typepath = /datum/round_event/anomaly/anomaly_bioscrambler

	min_players = 10
	max_occurrences = 5
	weight = 20
	description = "Cette anomalie remplace les membres des gens aux alentours avec d'autres membres."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 2

/datum/round_event/anomaly/anomaly_bioscrambler
	start_when = ANOMALY_START_MEDIUM_TIME
	announce_when = ANOMALY_ANNOUNCE_MEDIUM_TIME
	anomaly_path = /obj/effect/anomaly/bioscrambler

/datum/round_event/anomaly/anomaly_bioscrambler/announce(fake)
	priority_announce("Agent remplaceur de membre détecté à [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name]. Portez des combinaisons HAZMAT pour prévenir les effets. Demie-vie calculée : %9£$T$%F3 ans.", "Alerte anomalie")
