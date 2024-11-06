/datum/reagent/fuel/oil/expose_turf(turf/exposed_turf, reac_volume)//splash the fuel all over the place
	. = ..()
	if(!istype(exposed_turf) || isspaceturf(exposed_turf))
		return
	if(reac_volume < 3)
		return

	var/obj/effect/decal/cleanable/oil/bloodsplatter = locate() in exposed_turf //find some blood here
	if(!bloodsplatter)
		bloodsplatter = new(exposed_turf)
