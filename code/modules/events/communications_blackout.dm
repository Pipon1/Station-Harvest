/datum/round_event_control/communications_blackout
	name = "Blackout des communications"
	typepath = /datum/round_event/communications_blackout
	weight = 30
	category = EVENT_CATEGORY_ENGINEERING
	description = "EMP toutes les machines de télécommunications, bloquant toutes les communications pour un moment."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 3

/datum/round_event/communications_blackout
	announce_when = 1

/datum/round_event/communications_blackout/announce(fake)
	var/alert = pick( "Anomalies ionosphériques détectées. Problèmes temporaires de télécommunication imminents. Contactez votr*%fj00)`5vc-BZZT",
		"Anomalies ionosphériques détectées. Problèmes temporaires de télécomm*3mga;b4;'1v¬-BZZZT",
		"Anomalies ionosphériques détectées. Problèmes temp#MCi46:5.;@63-BZZZZT",
		"Anomalies ionosphériques dét'fZ\\kg5_0-BZZZZZT",
		"Anomali:%£ MCayj^j<.3-BZZZZZZT",
		"#4nd%;f4y6,>£%-BZZZZZZZT",
	)

	for(var/mob/living/silicon/ai/A in GLOB.ai_list) //AIs are always aware of communication blackouts.
		to_chat(A, "<br>[span_warning("<b>[alert]</b>")]<br>")

	if(prob(30) || fake) //most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		priority_announce(alert)


/datum/round_event/communications_blackout/start()
	for(var/obj/machinery/telecomms/T in GLOB.telecomms_list)
		T.emp_act(EMP_HEAVY)
