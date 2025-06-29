GLOBAL_LIST_EMPTY(all_wormholes) // So we can pick wormholes to teleport to

/datum/round_event_control/wormholes
	name = "Trou de ver"
	typepath = /datum/round_event/wormholes
	max_occurrences = 3
	weight = 2
	min_players = 2
	category = EVENT_CATEGORY_SPACE
	description = "Anomalie dans l'espace-temps apparaissent dans la station, téléportant aléatoirement les personnes qui marchent dedans."
	min_wizard_trigger_potency = 3
	max_wizard_trigger_potency = 7

/datum/round_event/wormholes
	announce_when = 10
	end_when = 60

	var/list/pick_turfs = list()
	var/list/wormholes = list()
	var/shift_frequency = 3
	var/number_of_wormholes = 400

/datum/round_event/wormholes/setup()
	announce_when = rand(0, 20)
	end_when = rand(40, 80)

/datum/round_event/wormholes/start()
	for(var/turf/open/floor/T in world)
		if(is_station_level(T.z))
			pick_turfs += T

	for(var/i in 1 to number_of_wormholes)
		var/turf/T = pick(pick_turfs)
		wormholes += new /obj/effect/portal/wormhole(T, 0, null, FALSE)

/datum/round_event/wormholes/announce(fake)
	priority_announce("Anomalie dans l'espace-temps détectées près de la station. Aucune donnée additionnelle.", "Alerte anomalie", ANNOUNCER_SPANOMALIES)

/datum/round_event/wormholes/tick()
	if(activeFor % shift_frequency == 0)
		for(var/obj/effect/portal/wormhole/O in wormholes)
			var/turf/T = pick(pick_turfs)
			if(T)
				O.forceMove(T)

/datum/round_event/wormholes/end()
	QDEL_LIST(wormholes)
	wormholes = null

/obj/effect/portal/wormhole
	name = "trou de ver"
	desc = "Ça a l'air très instable, ça pourrait se fermer à tout moment."
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
	mech_sized = TRUE


/obj/effect/portal/wormhole/Initialize(mapload, _creator, _lifespan = 0, obj/effect/portal/_linked, automatic_link = FALSE, turf/hard_target_override)
	. = ..()
	GLOB.all_wormholes += src

/obj/effect/portal/wormhole/Destroy()
	. = ..()
	GLOB.all_wormholes -= src

/obj/effect/portal/wormhole/teleport(atom/movable/M)
	if(iseffect(M)) //sparks don't teleport
		return
	if(M.anchored)
		if(!(ismecha(M) && mech_sized))
			return

	if(ismovable(M))
		if(GLOB.all_wormholes.len)
			var/obj/effect/portal/wormhole/P = pick(GLOB.all_wormholes)
			if(P && isturf(P.loc))
				hard_target = P.loc
		if(!hard_target)
			return
		do_teleport(M, hard_target, 1, null, null, channel = TELEPORT_CHANNEL_WORMHOLE) ///You will appear adjacent to the beacon
