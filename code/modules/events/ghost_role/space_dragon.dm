/datum/round_event_control/space_dragon
	name = "Spawn de dragon de l'espace"
	typepath = /datum/round_event/ghost_role/space_dragon
	weight = 7
	max_occurrences = 1
	min_players = 20
	dynamic_should_hijack = TRUE
	category = EVENT_CATEGORY_ENTITIES
	description = "Spawn un dragon de l'espace, qui va essayer de renversation la station."
	min_wizard_trigger_potency = 6
	max_wizard_trigger_potency = 7

/datum/round_event/ghost_role/space_dragon
	minimum_required = 1
	role_name = "Space Dragon"
	announce_when = 10

/datum/round_event/ghost_role/space_dragon/announce(fake)
	priority_announce("Un large flux d'énergie organique a été enregistré près de [station_name()], restez vigilant.", "Alerte signe de vie")

/datum/round_event/ghost_role/space_dragon/spawn_role()

	var/list/candidates = get_candidates(ROLE_SPACE_DRAGON, ROLE_SPACE_DRAGON)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick(candidates)
	var/key = selected.key

	var/spawn_location = find_space_spawn()
	if(isnull(spawn_location))
		return MAP_ERROR

	var/mob/living/simple_animal/hostile/space_dragon/dragon = new (spawn_location)
	dragon.key = key
	dragon.mind.set_assigned_role(SSjob.GetJobType(/datum/job/space_dragon))
	dragon.mind.special_role = ROLE_SPACE_DRAGON
	dragon.mind.add_antag_datum(/datum/antagonist/space_dragon)
	playsound(dragon, 'sound/magic/ethereal_exit.ogg', 50, TRUE, -1)
	message_admins("[ADMIN_LOOKUPFLW(dragon)] a été mis en tant que dragon de l'espace par un événement.")
	dragon.log_message("a été mis en tant que dragon de l'espace par un événement.", LOG_GAME)
	spawned_mobs += dragon
	return SUCCESSFUL_SPAWN
