/datum/round_event_control/slaughter
	name = "Spawn d'un démon de sang"
	typepath = /datum/round_event/ghost_role/slaughter
	weight = 1 //Very rare
	max_occurrences = 1
	earliest_start = 1 HOURS
	min_players = 20
	dynamic_should_hijack = TRUE
	category = EVENT_CATEGORY_ENTITIES
	description = "Spawn un démon de sang, qui chasse en voyageant de flaque de sang à flaque de sang."
	min_wizard_trigger_potency = 6
	max_wizard_trigger_potency = 7

/datum/round_event/ghost_role/slaughter
	minimum_required = 1
	role_name = "slaughter demon"

/datum/round_event/ghost_role/slaughter/spawn_role()
	var/list/candidates = get_candidates(ROLE_ALIEN, ROLE_ALIEN)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick_n_take(candidates)

	var/datum/mind/player_mind = new /datum/mind(selected.key)
	player_mind.active = TRUE

	var/spawn_location = find_space_spawn()
	if(!spawn_location)
		return MAP_ERROR //This sends an error message further up.
	var/mob/living/simple_animal/hostile/imp/slaughter/S = new(spawn_location)
	new /obj/effect/dummy/phased_mob(spawn_location, S)

	player_mind.transfer_to(S)
	player_mind.set_assigned_role(SSjob.GetJobType(/datum/job/slaughter_demon))
	player_mind.special_role = ROLE_SLAUGHTER_DEMON
	player_mind.add_antag_datum(/datum/antagonist/slaughter)
	to_chat(S, span_bold("Vous n'êtes pas dans le même plan d'existence que la station. \
		Utilisez votre capacité à nager dans le sang pour vous manifester et semer la dévastation."))
	SEND_SOUND(S, 'sound/magic/demon_dies.ogg')
	message_admins("[ADMIN_LOOKUPFLW(S)] a été mis en tant que démon de sang par un événement.")
	S.log_message("a été mis en tant que démon de sang par un événement.", LOG_GAME)
	spawned_mobs += S
	return SUCCESSFUL_SPAWN
