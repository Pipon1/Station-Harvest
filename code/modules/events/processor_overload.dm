/datum/round_event_control/processor_overload
	name = "Surcharge des processeurs"
	typepath = /datum/round_event/processor_overload
	weight = 15
	min_players = 20
	category = EVENT_CATEGORY_ENGINEERING
	description = "EMP les processeurs des télécoms, brouillant les radios. Peut exploser un peu."

/datum/round_event/processor_overload
	announce_when = 1

/datum/round_event/processor_overload/announce(fake)
	var/alert = pick("Bulle exosphérique en approche. Surcharge des processeurs probable. Contactez votr*%xp25)`6cq-BZZT",
		"Bulle exosphérique en approche. Surcharge des processeurs pro*1eta;c5;'1v¬-BZZZT",
		"Bulle exosphérique en approche. Surcharg#MCi46:5.;@63-BZZZZT",
		"Bulle exosphérique e'Fz\\k55_@-BZZZZZT",
		"Bulle exo:%£ QCbyj^j</.3-BZZZZZZT",
		"!!hy%;f3l7e,<$^-BZZZZZZZT",
	)

	for(var/mob/living/silicon/ai/A in GLOB.ai_list)
	//AIs are always aware of processor overload
		to_chat(A, "<br>[span_warning("<b>[alert]</b>")]<br>")

	// Announce most of the time, but leave a little gap so people don't know
	// whether it's, say, a tesla zapping tcomms, or some selective
	// modification of the tcomms bus
	if(prob(80) || fake)
		priority_announce(alert)


/datum/round_event/processor_overload/start()
	for(var/obj/machinery/telecomms/processor/P in GLOB.telecomms_list)
		if(prob(10))
			announce_to_ghosts(P)
			// Damage the surrounding area to indicate that it popped
			explosion(P, light_impact_range = 2, explosion_cause = src)
			// Only a level 1 explosion actually damages the machine
			// at all
			SSexplosions.high_mov_atom += P
		else
			P.emp_act(EMP_HEAVY)
