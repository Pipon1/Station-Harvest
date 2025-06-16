// Normal strength

/datum/round_event_control/meteor_wave
	name = "Vague de météores : Normale"
	typepath = /datum/round_event/meteor_wave
	weight = 4
	min_players = 15
	max_occurrences = 3
	earliest_start = 25 MINUTES
	category = EVENT_CATEGORY_SPACE
	description = "A regular meteor wave."
	map_flags = EVENT_SPACE_ONLY

/datum/round_event/meteor_wave
	start_when = 6
	end_when = 66
	announce_when = 1
	var/list/wave_type
	var/wave_name = "normal"

/datum/round_event/meteor_wave/New()
	..()
	if(!wave_type)
		determine_wave_type()

/datum/round_event/meteor_wave/proc/determine_wave_type()
	if(!wave_name)
		wave_name = pick_weight(list(
			"normal" = 50,
			"threatening" = 40,
			"catastrophic" = 10))
	switch(wave_name)
		if("normal")
			wave_type = GLOB.meteors_normal
		if("threatening")
			wave_type = GLOB.meteors_threatening
		if("catastrophic")
			if(check_holidays(HALLOWEEN))
				wave_type = GLOB.meteorsSPOOKY
			else
				wave_type = GLOB.meteors_catastrophic
		if("meaty")
			wave_type = GLOB.meateors
		if("space dust")
			wave_type = GLOB.meteors_dust
		if("halloween")
			wave_type = GLOB.meteorsSPOOKY
		else
			WARNING("Wave name of [wave_name] not recognised.")
			kill()

/datum/round_event/meteor_wave/announce(fake)
	priority_announce("Des météores ont été détectés sur une trajectoire de collision avec la station.", "Alerte collision", ANNOUNCER_METEORS)

/datum/round_event/meteor_wave/tick()
	if(ISMULTIPLE(activeFor, 3))
		spawn_meteors(5, wave_type) //meteor list types defined in gamemode/meteor/meteors.dm

/datum/round_event_control/meteor_wave/threatening
	name = "Vague de météores : Dangereuse"
	typepath = /datum/round_event/meteor_wave/threatening
	weight = 5
	min_players = 20
	max_occurrences = 3
	earliest_start = 35 MINUTES
	description = "Une vague de météores avec plus de gros météores."

/datum/round_event/meteor_wave/threatening
	wave_name = "threatening"

/datum/round_event_control/meteor_wave/catastrophic
	name = "Vague de météores : Catastrophique"
	typepath = /datum/round_event/meteor_wave/catastrophic
	weight = 7
	min_players = 25
	max_occurrences = 3
	earliest_start = 45 MINUTES
	description = "Une vague de météroe qui peut contenir un météore de classe toungouska."

/datum/round_event/meteor_wave/catastrophic
	wave_name = "catastrophic"

/datum/round_event_control/meteor_wave/meaty
	name = "Vague de météores : Viandarde"
	typepath = /datum/round_event/meteor_wave/meaty
	weight = 2
	max_occurrences = 1
	description = "Une vague de météores faites de viande."

/datum/round_event/meteor_wave/meaty
	wave_name = "meaty"

/datum/round_event/meteor_wave/meaty/announce(fake)
	priority_announce("De la viande a été détectée sur une trajectoire de collision avec la station.", "Oh merde, allez chercher la serpillère.", ANNOUNCER_METEORS)

/datum/round_event_control/meteor_wave/dust_storm
	name = "Poussières spatiales : Majeur"
	typepath = /datum/round_event/meteor_wave/dust_storm
	weight = 14
	description = "La station est bombardée par du sable."
	earliest_start = 15 MINUTES
	min_wizard_trigger_potency = 4
	max_wizard_trigger_potency = 7

/datum/round_event/meteor_wave/dust_storm
	announce_chance = 85
	wave_name = "space dust"

/datum/round_event/meteor_wave/dust_storm/announce(fake)
	var/list/reasons = list()

	reasons += "[station_name()] passe par un nuage de débris. Dommages mineures attendus \
		aux équipements et installations extérieurs."

	reasons += "La Division des Superarmes de Nanotrasen teste un nouveau prototype de\
		[pick("canon","artillerie","tank","croiseur","\[SUPPRIMÉ\]")], \
		[pick("de terrain","à projection","nova","super-percutant","réactif")] \
		quelques débris épars sont attendus."

	reasons += "Une station voisine est en train de vous envoyer des cailloux dessus. (Peut-être qu'ils ont en marre de \
		vos messages.)"

	reasons += "L'orbite de [station_name()] passe à travers un nuage des reste d'un astéroide de minage. \
		Dommages mineures à la coque attendus."

	reasons += "Un large météore était sur une trajectoire de collision avec [station_name()], il a été démoli. \
		Des débris résiduels peuvent heurter l'extérieur de votre station."

	reasons += "[station_name()] a atteint une partie de l'espace particulièrement encombrée. \
		Veuillez faire attention à toute turbulence ou dommages causés par les débris."

	priority_announce(pick(reasons), "Alerte collision")
