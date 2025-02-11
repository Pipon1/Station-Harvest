/datum/round_event_control/wisdomcow
	name = "Vache sage"
	typepath = /datum/round_event/wisdomcow
	max_occurrences = 1
	weight = 20
	category = EVENT_CATEGORY_FRIENDLY
	description = "Une vache qui apparait pour vous dire des mots d'une grande sagesse."
	admin_setup = list(
		/datum/event_admin_setup/set_location/wisdom_cow,
		/datum/event_admin_setup/listed_options/wisdom_cow,
		/datum/event_admin_setup/input_number/wisdom_cow,
	)

/datum/round_event/wisdomcow
	///Location override that, if set causes the cow to spawn in a pre-determined locaction instead of randomly.
	var/turf/spawn_location
	///An override that, if set rigs the cow to spawn with a specific wisdow rather than a random one.
	var/selected_wisdom
	///An override that, if set modifies the amount of wisdow the cow will add/remove, if not set will default to 500.
	var/selected_experience

/datum/round_event/wisdomcow/announce(fake)
	priority_announce("Une vache d'une grande sagesse a été repérée par chez vous. Demandez lui conseil.", "Agence de ranch de vache de Nanotrasen")

/datum/round_event/wisdomcow/start()
	var/turf/targetloc
	if(spawn_location)
		targetloc = spawn_location
	else
		targetloc = get_safe_random_station_turf()
	var/mob/living/basic/cow/wisdom/wise = new(targetloc, selected_wisdom, selected_experience)
	do_smoke(1, holder = wise, location = targetloc)
	announce_to_ghosts(wise)

/datum/event_admin_setup/set_location/wisdom_cow
	input_text = "Spawn à votre localisation actuelle ?"

/datum/event_admin_setup/set_location/wisdom_cow/apply_to_event(datum/round_event/wisdomcow/event)
	event.spawn_location = chosen_turf

/datum/event_admin_setup/listed_options/wisdom_cow
	input_text = "Sélectionner une sagesse d'un certain type ?"
	normal_run_option = "Sagesse aléatoire"

/datum/event_admin_setup/listed_options/wisdom_cow/get_list()
	return subtypesof(/datum/skill)

/datum/event_admin_setup/listed_options/wisdom_cow/apply_to_event(datum/round_event/wisdomcow/event)
	event.selected_wisdom = chosen

/datum/event_admin_setup/input_number/wisdom_cow
	input_text = "Combien de points d'expérience voulez vous que cette vache donne ? (défaut : 500, min : -2500, max : 2500)"
	default_value = 500
	max_value = 2500
	min_value = -2500

/datum/event_admin_setup/input_number/wisdom_cow/apply_to_event(datum/round_event/wisdomcow/event)
	event.selected_experience = chosen_value
	
	
