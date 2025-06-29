/datum/round_event_control/nightmare
	name = "Spawn de cauchemar"
	typepath = /datum/round_event/ghost_role/nightmare
	max_occurrences = 1
	min_players = 20
	dynamic_should_hijack = TRUE
	category = EVENT_CATEGORY_ENTITIES
	description = "Spawn un cauchemar voulant amener les ténèbres dans la station."
	min_wizard_trigger_potency = 6
	max_wizard_trigger_potency = 7

/datum/round_event/ghost_role/nightmare
	minimum_required = 1
	role_name = "nightmare"
	fakeable = FALSE

/datum/round_event/ghost_role/nightmare/spawn_role()
	var/list/candidates = get_candidates(ROLE_ALIEN, ROLE_NIGHTMARE)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick(candidates)

	var/datum/mind/player_mind = new /datum/mind(selected.key)
	player_mind.active = TRUE

	var/turf/spawn_loc = find_maintenance_spawn(atmos_sensitive = TRUE, require_darkness = TRUE)
	if(isnull(spawn_loc))
		return MAP_ERROR

	var/mob/living/carbon/human/S = new (spawn_loc)
	player_mind.transfer_to(S)
	player_mind.set_assigned_role(SSjob.GetJobType(/datum/job/nightmare))
	player_mind.special_role = ROLE_NIGHTMARE
	player_mind.add_antag_datum(/datum/antagonist/nightmare)
	S.set_species(/datum/species/shadow/nightmare)
	playsound(S, 'sound/magic/ethereal_exit.ogg', 50, TRUE, -1)
	message_admins("[ADMIN_LOOKUPFLW(S)] a été mis en tant que cauchemar par un événement.")
	S.log_message("a été mis en tant que cauchemar par un événement.", LOG_GAME)
	spawned_mobs += S
	return SUCCESSFUL_SPAWN
