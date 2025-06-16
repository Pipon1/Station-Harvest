/datum/round_event_control/blob
	name = "Blob"
	typepath = /datum/round_event/ghost_role/blob
	weight = 10
	max_occurrences = 1

	min_players = 20

	dynamic_should_hijack = TRUE
	category = EVENT_CATEGORY_ENTITIES
	description = "Créer un nouveau blob."

/datum/round_event_control/blob/can_spawn_event(players, allow_magic = FALSE)
	if(EMERGENCY_PAST_POINT_OF_NO_RETURN) // no blobs if the shuttle is past the point of no return
		return FALSE

	return ..()

/datum/round_event/ghost_role/blob
	announce_chance = 0
	role_name = "blob overmind"
	fakeable = TRUE

/datum/round_event/ghost_role/blob/announce(fake)
	if(!fake)
		return //the mob itself handles this.
	priority_announce("Brèche de confinement de niveau 5 - danger biologique à bord de  [station_name()]. L'ensemble du personnel doit contenir la menace.", "Alerte biologique", ANNOUNCER_OUTBREAK5)

/datum/round_event/ghost_role/blob/spawn_role()
	if(!GLOB.blobstart.len)
		return MAP_ERROR
	var/list/candidates = get_candidates(ROLE_BLOB, ROLE_BLOB)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS
	var/mob/dead/observer/new_blob = pick(candidates)
	var/mob/camera/blob/BC = new_blob.become_overmind()
	spawned_mobs += BC
	message_admins("[ADMIN_LOOKUPFLW(BC)] a été mis dans l'esprit d'un blob par un événement.")
	BC.log_message("a été spawné en tant que blob par un événement.", LOG_GAME)
	return SUCCESSFUL_SPAWN
