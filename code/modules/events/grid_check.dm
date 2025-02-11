/datum/round_event_control/grid_check
	name = "Vérification du réseau"
	typepath = /datum/round_event/grid_check
	weight = 10
	max_occurrences = 3
	category = EVENT_CATEGORY_ENGINEERING
	description = "Éteint temporairement toutes les APC. Elles peuvent être rallumées manuellement."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 4
	/// Cooldown for the announement associated with this event.
	/// Necessary due to the fact that this event is player triggerable.
	COOLDOWN_DECLARE(announcement_spam_protection)

/datum/round_event/grid_check
	announce_when = 1
	start_when = 1

/datum/round_event/grid_check/announce(fake)
	var/datum/round_event_control/grid_check/controller = control
	if(!COOLDOWN_FINISHED(controller, announcement_spam_protection) && !fake)
		return
	priority_announce("Activité anormale détectée dans le réseau d'énergie de [station_name()]. Les redistributeurs d'énergie vont être éteint pour une durée indéterminée par mesure de précaution.", "Problème de courant critique", ANNOUNCER_POWEROFF)
	if(!fake) // Only start the CD if we're real
		COOLDOWN_START(controller, announcement_spam_protection, 30 SECONDS)

/datum/round_event/grid_check/start()
	power_fail(30, 120)
