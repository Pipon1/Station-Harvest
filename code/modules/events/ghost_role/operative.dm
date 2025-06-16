/datum/round_event_control/operative
	name = "Agent solitaire"
	typepath = /datum/round_event/ghost_role/operative
	weight = 0 //its weight is relative to how much stationary and neglected the nuke disk is. See nuclearbomb.dm. Shouldn't be dynamic hijackable.
	max_occurrences = 1
	category = EVENT_CATEGORY_INVASION
	description = "Un agent solitaire qui a pour but de faire exploser la bombe nucléaire de la station."

/datum/round_event/ghost_role/operative
	minimum_required = 1
	role_name = "lone operative"
	fakeable = FALSE

/datum/round_event/ghost_role/operative/spawn_role()
	var/list/candidates = get_candidates(ROLE_OPERATIVE, ROLE_LONE_OPERATIVE)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick_n_take(candidates)

	var/spawn_location = find_space_spawn()
	if(isnull(spawn_location))
		return MAP_ERROR

	var/mob/living/carbon/human/operative = new(spawn_location)
	operative.randomize_human_appearance(~RANDOMIZE_SPECIES)
	operative.dna.update_dna_identity()
	var/datum/mind/Mind = new /datum/mind(selected.key)
	Mind.set_assigned_role(SSjob.GetJobType(/datum/job/lone_operative))
	Mind.special_role = ROLE_LONE_OPERATIVE
	Mind.active = TRUE
	Mind.transfer_to(operative)
	Mind.add_antag_datum(/datum/antagonist/nukeop/lone)

	message_admins("[ADMIN_LOOKUPFLW(operative)] a été mis en tant qu'agent solitaire par un événement.")
	operative.log_message("a été mis en tant qu'agent solitaire par un événement.", LOG_GAME)
	spawned_mobs += operative
	return SUCCESSFUL_SPAWN
