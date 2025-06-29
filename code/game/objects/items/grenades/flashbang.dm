/obj/item/grenade/flashbang
	name = "grenade à saturation sensoriel"
	icon_state = "flashbang"
	inhand_icon_state = "flashbang"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	var/flashbang_range = 7 //how many tiles away the mob will be stunned.

/obj/item/grenade/flashbang/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return

	update_mob()
	var/flashbang_turf = get_turf(src)
	if(!flashbang_turf)
		return
	do_sparks(rand(5, 9), FALSE, src)
	playsound(flashbang_turf, 'sound/weapons/flashbang.ogg', 100, TRUE, 8, 0.9)
	new /obj/effect/dummy/lighting_obj (flashbang_turf, flashbang_range + 2, 4, COLOR_WHITE, 2)
	for(var/mob/living/living_mob in get_hearers_in_view(flashbang_range, flashbang_turf))
		bang(get_turf(living_mob), living_mob)
	qdel(src)

/obj/item/grenade/flashbang/proc/bang(turf/turf, mob/living/living_mob)
	if(living_mob.stat == DEAD) //They're dead!
		return
	living_mob.show_message(span_warning("BANG"), MSG_AUDIBLE)
	var/distance = max(0, get_dist(get_turf(src), turf))

//Flash
	if(living_mob.flash_act(affect_silicon = 1))
		living_mob.Paralyze(max(20/max(1, distance), 5))
		living_mob.Knockdown(max(200/max(1, distance), 60))

//Bang
	if(!distance || loc == living_mob || loc == living_mob.loc) //Stop allahu akbarring rooms with this.
		living_mob.Paralyze(20)
		living_mob.Knockdown(200)
		living_mob.soundbang_act(1, 200, 10, 15)
	else
		if(distance <= 1) // Adds more stun as to not prime n' pull (#45381)
			living_mob.Paralyze(5)
			living_mob.Knockdown(30)
		living_mob.soundbang_act(1, max(200 / max(1, distance), 60), rand(0, 5))

/obj/item/grenade/stingbang
	name = "pique-bang"
	icon_state = "timeg"
	inhand_icon_state = "flashbang"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	var/flashbang_range = 1 //how many tiles away the mob will be stunned.
	shrapnel_type = /obj/projectile/bullet/pellet/stingball
	shrapnel_radius = 5
	custom_premium_price = PAYCHECK_COMMAND * 3.5 // mostly gotten through cargo, but throw in one for the sec vendor ;)

/obj/item/grenade/stingbang/mega
	name = "mega pique-bang"
	shrapnel_type = /obj/projectile/bullet/pellet/stingball/mega
	shrapnel_radius = 12

/obj/item/grenade/stingbang/detonate(mob/living/lanced_by)
	if(dud_flags)
		active = FALSE
		update_appearance()
		return FALSE

	if(iscarbon(loc))
		var/mob/living/carbon/user = loc
		var/obj/item/bodypart/bodypart = user.get_holding_bodypart_of_item(src)
		if(bodypart)
			forceMove(get_turf(user))
			user.visible_message("<b>[span_danger("[src] explose dans la main de [user], réduisant le [bodypart.plaintext_zone] de [user.p_their()] en charpie !")]</b>", span_userdanger("[src] explose dans votre main, réduisant votre [bodypart.plaintext_zone] en charpie !"))
			bodypart.dismember()

	. = ..()
	if(!.)
		return


	update_mob()
	var/flashbang_turf = get_turf(src)
	if(!flashbang_turf)
		return
	do_sparks(rand(5, 9), FALSE, src)
	playsound(flashbang_turf, 'sound/weapons/flashbang.ogg', 50, TRUE, 8, 0.9)
	new /obj/effect/dummy/lighting_obj (flashbang_turf, flashbang_range + 2, 2, COLOR_WHITE, 1)
	for(var/mob/living/living_mob in get_hearers_in_view(flashbang_range, flashbang_turf))
		pop(get_turf(living_mob), living_mob)
	qdel(src)

/obj/item/grenade/stingbang/proc/pop(turf/turf, mob/living/living_mob)
	if(living_mob.stat == DEAD) //They're dead!
		return
	living_mob.show_message(span_warning("POP"), MSG_AUDIBLE)
	var/distance = max(0, get_dist(get_turf(src), turf))
//Flash
	if(living_mob.flash_act(affect_silicon = 1))
		living_mob.Paralyze(max(10/max(1, distance), 5))
		living_mob.Knockdown(max(100/max(1, distance), 60))

//Bang
	if(!distance || loc == living_mob || loc == living_mob.loc)
		living_mob.Paralyze(20)
		living_mob.Knockdown(200)
		living_mob.soundbang_act(1, 200, 10, 15)
		if(living_mob.apply_damages(10, 10))
			to_chat(living_mob, span_userdanger("L'explosion de [src] vous blesse et vous brûle !"))

	// only checking if they're on top of the tile, cause being one tile over will be its own punishment

// Grenade that releases more shrapnel the more times you use it in hand between priming and detonation (sorta like the 9bang from MW3), for admin goofs
/obj/item/grenade/primer
	name = "grenade à fragmentation rotative"
	desc = "Une grenade qui génère plus de shrapnel plus vous la faites tourner dans votre main après avoir retiré la goupille. Celle-ci libère des éclats de shrapnel."
	icon_state = "timeg"
	inhand_icon_state = "flashbang"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	var/rots_per_mag = 3 /// how many times we need to "rotate" the charge in hand per extra tile of magnitude
	shrapnel_type = /obj/projectile/bullet/shrapnel
	var/rots = 1 /// how many times we've "rotated" the charge

/obj/item/grenade/primer/attack_self(mob/user)
	. = ..()
	if(active)
		user.playsound_local(user, 'sound/misc/box_deploy.ogg', 50, TRUE)
		rots++
		user.changeNext_move(CLICK_CD_RAPID)

/obj/item/grenade/primer/detonate(mob/living/lanced_by)
	shrapnel_radius = round(rots / rots_per_mag)
	. = ..()
	if(!.)
		return

	qdel(src)

/obj/item/grenade/primer/stingbang
	name = "grenade pique-bang rotative"
	desc = "Une grenade qui génère plus de shrapnel plus vous la faites tourner dans votre main après avoir retiré la goupille. Celle-ci libère des éclats de pique-boules."
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	rots_per_mag = 2
	shrapnel_type = /obj/projectile/bullet/pellet/stingball
