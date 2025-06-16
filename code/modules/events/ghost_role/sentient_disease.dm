/datum/round_event_control/sentient_disease
	name = "Spawn de maladie consciente"
	typepath = /datum/round_event/ghost_role/sentient_disease
	weight = 7
	max_occurrences = 1
	min_players = 25
	category = EVENT_CATEGORY_HEALTH
	description = "Spawn une maladie consciente, qui a pour but d'infecter le plus de personnes possible."
	min_wizard_trigger_potency = 4
	max_wizard_trigger_potency = 7

/datum/round_event/ghost_role/sentient_disease
	role_name = "sentient disease"

/datum/round_event/ghost_role/sentient_disease/spawn_role()
	var/list/candidates = get_candidates(ROLE_ALIEN, ROLE_ALIEN)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/observer/selected = pick_n_take(candidates)

	var/mob/camera/disease/virus = new /mob/camera/disease(SSmapping.get_station_center())
	virus.key = selected.key
	INVOKE_ASYNC(virus, TYPE_PROC_REF(/mob/camera/disease, pick_name))
	message_admins("[ADMIN_LOOKUPFLW(virus)] a été mis en maladie consciente par un événement.")
	virus.log_message("a été mis en maladie consciente par un événement.", LOG_GAME)
	spawned_mobs += virus
	return SUCCESSFUL_SPAWN
