/obj/item/gun/grenadelauncher
	name = "lance grenade"
	desc = "Une arme terrible, terrible. C'est vraiment affreux!"
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "riotgun"
	inhand_icon_state = "riotgun"
	w_class = WEIGHT_CLASS_BULKY
	throw_speed = 2
	throw_range = 7
	force = 5
	var/list/grenades = new/list()
	var/max_grenades = 3
	custom_materials = list(/datum/material/iron=2000)

/obj/item/gun/grenadelauncher/examine(mob/user)
	. = ..()
	. += "il y'a [grenades.len] / [max_grenades] chargées."

/obj/item/gun/grenadelauncher/attackby(obj/item/I, mob/user, params)

	if(istype(I, /obj/item/grenade/c4))
		return
	if((isgrenade(I)))
		if(grenades.len < max_grenades)
			if(!user.transferItemToLoc(I, src))
				return
			grenades += I
			balloon_alert(user, "vous avez chargez [grenades.len] / [max_grenades] grenades.")
		else
			balloon_alert(user, "le chargeur est plein !")

/obj/item/gun/grenadelauncher/can_shoot()
	return grenades.len

/obj/item/gun/grenadelauncher/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	user.visible_message(span_danger("[user] a tiré une grenade !"), \
						span_danger("Vous faites feu avec le lance grenade !"))
	var/obj/item/grenade/F = grenades[1] //Now with less copypasta!
	grenades -= F
	F.forceMove(user.loc)
	F.throw_at(target, 30, 2, user)
	message_admins("[ADMIN_LOOKUPFLW(user)] a tiré une grenade ([F.name]) depuis un lance grenade ([src]) depuis [AREACOORD(user)] contre [target] [AREACOORD(target)].")
	user.log_message("a tiré une grenade ([F.name]) depuis un lance grenade ([src]) depuis [AREACOORD(user)] contre [target] [AREACOORD(target)].", LOG_GAME)
	user.log_message("a tiré une grenade ([F.name]) depuis un lance grenade([src]) depuis [AREACOORD(user)] contre [target] [AREACOORD(target)].", LOG_ATTACK, log_globally = FALSE)
	F.active = 1
	F.icon_state = initial(F.icon_state) + "_active"
	playsound(user.loc, 'sound/weapons/armbomb.ogg', 75, TRUE, -3)
	addtimer(CALLBACK(F, TYPE_PROC_REF(/obj/item/grenade, detonate)), 15)
