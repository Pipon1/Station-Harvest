/datum/round_event_control/morph
	name = "Spawn de morph"
	typepath = /datum/round_event/ghost_role/morph
	weight = 0
	max_occurrences = 1
	category = EVENT_CATEGORY_ENTITIES
	description = "Spawn un blob métamorphe affamé."
	min_wizard_trigger_potency = 4
	max_wizard_trigger_potency = 7

/datum/round_event/ghost_role/morph
	minimum_required = 1
	role_name = "morphling"

/datum/round_event/ghost_role/morph/spawn_role()
	var/list/candidates = get_candidates(ROLE_ALIEN, ROLE_ALIEN)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick_n_take(candidates)

	var/datum/mind/player_mind = new /datum/mind(selected.key)
	player_mind.active = TRUE

	var/turf/spawn_loc = find_maintenance_spawn(atmos_sensitive = TRUE, require_darkness = FALSE)
	if(isnull(spawn_loc))
		return MAP_ERROR

	var/mob/living/simple_animal/hostile/morph/S = new /mob/living/simple_animal/hostile/morph(spawn_loc)
	player_mind.transfer_to(S)
	player_mind.set_assigned_role(SSjob.GetJobType(/datum/job/morph))
	player_mind.special_role = ROLE_MORPH
	player_mind.add_antag_datum(/datum/antagonist/morph)
	SEND_SOUND(S, sound('sound/magic/mutate.ogg'))
	message_admins("[ADMIN_LOOKUPFLW(S)] est devenu un morph grâce à un événement.")
	S.log_message("est devenu un morph grâce à un événement.", LOG_GAME)
	spawned_mobs += S
	return SUCCESSFUL_SPAWN
