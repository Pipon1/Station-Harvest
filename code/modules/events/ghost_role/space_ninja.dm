/datum/round_event_control/space_ninja
	name = "Spawn ninja de l'espace"
	typepath = /datum/round_event/ghost_role/space_ninja
	max_occurrences = 1
	weight = 10
	earliest_start = 20 MINUTES
	min_players = 20
	dynamic_should_hijack = TRUE
	category = EVENT_CATEGORY_INVASION
	description = "Un ninja de l'espace infiltrant la station."

/datum/round_event/ghost_role/space_ninja
	minimum_required = 1
	role_name = "Space Ninja"

/datum/round_event/ghost_role/space_ninja/spawn_role()
	var/spawn_location = find_space_spawn()
	if(isnull(spawn_location))
		return MAP_ERROR

	//selecting a candidate player
	var/list/candidates = get_candidates(ROLE_NINJA, ROLE_NINJA)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected_candidate = pick(candidates)
	var/key = selected_candidate.key

	//spawn the ninja and assign the candidate
	var/mob/living/carbon/human/ninja = create_space_ninja(spawn_location)
	ninja.key = key
	ninja.mind.add_antag_datum(/datum/antagonist/ninja)
	spawned_mobs += ninja
	message_admins("[ADMIN_LOOKUPFLW(ninja)] a été mis en tant que ninja de l'espace par un événement.")
	ninja.log_message("a été mis en tant que ninja de l'espace par un événement.", LOG_GAME)

	return SUCCESSFUL_SPAWN


//=======//NINJA CREATION PROCS//=======//

/proc/create_space_ninja(spawn_loc)
	var/mob/living/carbon/human/new_ninja = new(spawn_loc)
	new_ninja.randomize_human_appearance(~(RANDOMIZE_NAME|RANDOMIZE_SPECIES))
	var/new_name = "[pick(GLOB.ninja_titles)] [pick(GLOB.ninja_names)]"
	new_ninja.name = new_name
	new_ninja.real_name = new_name
	new_ninja.dna.update_dna_identity()
	return new_ninja
