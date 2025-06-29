GLOBAL_LIST_INIT(high_priority_sentience, typecacheof(list(
	/mob/living/simple_animal/pet,
	/mob/living/simple_animal/parrot,
	/mob/living/simple_animal/hostile/lizard,
	/mob/living/simple_animal/sloth,
	/mob/living/simple_animal/hostile/retaliate/goat,
	/mob/living/simple_animal/chicken,
	/mob/living/basic/bat,
	/mob/living/simple_animal/butterfly,
	/mob/living/simple_animal/hostile/retaliate/snake,
	/mob/living/simple_animal/hostile/retaliate/goose/vomit,
	/mob/living/simple_animal/bot/mulebot,
	/mob/living/simple_animal/bot/secbot/beepsky,
	/mob/living/basic/carp/pet/cayenne,
	/mob/living/basic/cow,
	/mob/living/basic/pet,
	/mob/living/basic/pig,
	/mob/living/basic/rabbit,
	/mob/living/basic/giant_spider/sgt_araneus,
	/mob/living/basic/sheep,
	/mob/living/basic/mouse/brown/tom,
)))

/datum/round_event_control/sentience
	name = "Intelligence humaine aléatoire"
	typepath = /datum/round_event/ghost_role/sentience
	weight = 10
	category = EVENT_CATEGORY_FRIENDLY
	description = "Un animal ou un robot devient sentient !"
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 7


/datum/round_event/ghost_role/sentience
	minimum_required = 1
	role_name = "random animal"
	var/animals = 1
	var/one = "one"
	fakeable = TRUE

/datum/round_event/ghost_role/sentience/announce(fake)
	var/sentience_report = ""

	var/data = pick("un scan de nos senseurs longue-porté", "nos modèles statistiques sophistiqués", "notre omnipotence", "le traffic de communication de votre station", "les émissions d'énergie que nous détectons", "\[CENSURÉ\]")
	var/pets = pick(" des animaux/bots", " des bots/animaux", " des animaux de compagnie", " des animaux", "e des formes de vie inférieures", " \[CENSURÉ\]")
	var/strength = pick("d'un humain", "modéré", "d'un lézard", "bas", "très bas", "\[CENSURÉ\]")

	sentience_report += "Selon [data], nous pensons que [one][pets] de la station a développé l'intelligence au niveau [strength], ainsi que la possibilité de communiquer."

	priority_announce(sentience_report,"[command_name()] Rapport de priorité modérée")

/datum/round_event/ghost_role/sentience/spawn_role()
	var/list/mob/dead/observer/candidates
	candidates = get_candidates(ROLE_SENTIENCE, ROLE_SENTIENCE)

	// find our chosen mob to breathe life into
	// Mobs have to be simple animals, mindless, on station, and NOT holograms.
	// prioritize starter animals that people will recognise


	var/list/potential = list()

	var/list/hi_pri = list()
	var/list/low_pri = list()

	for(var/mob/living/simple_animal/check_mob in GLOB.alive_mob_list)
		set_mob_priority(check_mob, hi_pri, low_pri)
	for(var/mob/living/basic/check_mob in GLOB.alive_mob_list)
		set_mob_priority(check_mob, hi_pri, low_pri)

	shuffle_inplace(hi_pri)
	shuffle_inplace(low_pri)

	potential = hi_pri + low_pri

	if(!potential.len)
		return WAITING_FOR_SOMETHING
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/spawned_animals = 0
	while(spawned_animals < animals && candidates.len && potential.len)
		var/mob/living/selected = popleft(potential)
		var/mob/dead/observer/picked_candidate = pick_n_take(candidates)

		spawned_animals++

		selected.key = picked_candidate.key

		selected.grant_all_languages(TRUE, FALSE, FALSE)

		if (isanimal(selected))
			var/mob/living/simple_animal/animal_selected = selected
			animal_selected.sentience_act()
			animal_selected.del_on_death = FALSE
		else if	(isbasicmob(selected))
			var/mob/living/basic/animal_selected = selected
			animal_selected.basic_mob_flags &= ~DEL_ON_DEATH

		selected.maxHealth = max(selected.maxHealth, 200)
		selected.health = selected.maxHealth
		spawned_mobs += selected

		to_chat(selected, span_userdanger("Bonjour le monde!"))
		to_chat(selected, "<span class='warning'>A cause de sévères radiations et/ou de produits chimiques \
			et/ou une grande chance, vosu avez gagné le niveau d'intelligence d'un humain \
			et la capacité de parler et de comprendre le language humain !</span>")

	return SUCCESSFUL_SPAWN

/// Adds a mob to either the high or low priority event list
/datum/round_event/ghost_role/sentience/proc/set_mob_priority(mob/living/checked_mob, list/high, list/low)
	var/turf/mob_turf = get_turf(checked_mob)
	if(!mob_turf || !is_station_level(mob_turf.z))
		return
	if((checked_mob in GLOB.player_list) || checked_mob.mind || (checked_mob.flags_1 & HOLOGRAM_1))
		return
	if(is_type_in_typecache(checked_mob, GLOB.high_priority_sentience))
		high += checked_mob
	else
		low += checked_mob

/datum/round_event_control/sentience/all
	name = "Intelligence humaine généralisée"
	typepath = /datum/round_event/ghost_role/sentience/all
	weight = 0
	category = EVENT_CATEGORY_FRIENDLY
	description = "TOUS les animaux et robots deviennent sentient, tant qu'il y a assez de fantôme."

/datum/round_event/ghost_role/sentience/all
	one = "all"
	animals = INFINITY // as many as there are ghosts and animals
	// cockroach pride, station wide
