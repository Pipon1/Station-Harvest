#define ZOOM_LOCK_AUTOZOOM_FREEMOVE 0
#define ZOOM_LOCK_AUTOZOOM_ANGLELOCK 1
#define ZOOM_LOCK_CENTER_VIEW 2
#define ZOOM_LOCK_OFF 3

#define AUTOZOOM_PIXEL_STEP_FACTOR 48

#define AIMING_BEAM_ANGLE_CHANGE_THRESHOLD 0.1

/obj/item/gun/energy/meltagun
	name = "Melta-Gun"
	desc = "A plasma-based anti-material heavy duty melta-gun, used to destroy exosuit, wall, door and people."
	desc_controls = "Hold down left click while scoped to aim, when weapon is fully aimed (Tracer goes from red to green as it charges), release to fire. Moving while aiming or changing where you're pointing at while aiming will delay the aiming process depending on how much you changed."
	icon = 'icons/obj/wall_melter.dmi'
	icon_state = "melta_base"
	inhand_icon_state = "melta_hand"
	worn_icon_state = "melta_backpack"
	fire_sound = 'sound/weapons/beam_sniper.ogg'
	slot_flags = ITEM_SLOT_BACK
	force = 15
	custom_materials = null
	recoil = 4
	ammo_x_offset = 3
	ammo_y_offset = 3
	modifystate = FALSE
	charge_sections = 1
	weapon_weight = WEAPON_HEAVY
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = list(/obj/item/ammo_casing/energy/meltagun/hitscan)
	actions_types = list(/datum/action/item_action/zoom_lock_action)
	cell_type = /obj/item/stock_parts/cell/beam_rifle
	canMouseDown = TRUE
	var/aiming = FALSE
	var/aiming_time = 24
	var/aiming_time_fire_threshold = 10
	var/aiming_time_left = 24
	var/aiming_time_increase_user_movement = 3
	var/scoped_slow = 1
	var/aiming_time_increase_angle_multiplier = 0.4
	var/last_process = 0

	var/lastangle = 0
	var/aiming_lastangle = 0
	var/mob/current_user = null
	var/list/obj/effect/projectile/tracer/current_tracers

	var/structure_piercing = 2 //Amount * 2. For some reason structures aren't respecting this unless you have it doubled. Probably with the objects in question's Bump() code instead of this but I'll deal with this later.
	var/structure_bleed_coeff = 0.7
	var/wall_pierce_amount = 1
	var/wall_devastate = 1000
	var/aoe_structure_range = 2
	var/aoe_structure_damage = 1000
	var/aoe_fire_range = 2
	var/aoe_fire_chance = 80
	var/aoe_mob_range = 2
	var/aoe_mob_damage = 100
	var/impact_structure_damage = 300
	var/projectile_damage = 300
	var/projectile_stun = 0
	var/projectile_setting_pierce = TRUE
	var/delay = 75
	var/lastfire = 0

	//ZOOMING
	var/zoom_current_view_increase = 0
	///The radius you want to zoom by
	var/zoom_target_view_increase = 9.5
	var/zooming = FALSE
	var/zoom_lock = ZOOM_LOCK_OFF
	var/zooming_angle
	var/current_zoom_x = 0
	var/current_zoom_y = 0

	var/mob/listeningTo

/obj/item/gun/energy/meltagun/debug
	delay = 0
	cell_type = /obj/item/stock_parts/cell/infinite
	aiming_time = 0
	recoil = 0
	pin = /obj/item/firing_pin

/obj/item/gun/energy/meltagun/equipped(mob/user)
	set_user(user)
	return ..()

/obj/item/gun/energy/meltagun/pickup(mob/user)
	set_user(user)
	return ..()

/obj/item/gun/energy/meltagun/dropped(mob/user)
	set_user()
	return ..()

/obj/item/gun/energy/meltagun/ui_action_click(mob/user, actiontype)
	if(istype(actiontype, /datum/action/item_action/zoom_lock_action))
		zoom_lock++
		if(zoom_lock > 3)
			zoom_lock = 0
		switch(zoom_lock)
			if(ZOOM_LOCK_AUTOZOOM_FREEMOVE)
				to_chat(user, span_boldnotice("You switch [src]'s zooming processor to free directional."))
			if(ZOOM_LOCK_AUTOZOOM_ANGLELOCK)
				to_chat(user, span_boldnotice("You switch [src]'s zooming processor to locked directional."))
			if(ZOOM_LOCK_CENTER_VIEW)
				to_chat(user, span_boldnotice("You switch [src]'s zooming processor to center mode."))
			if(ZOOM_LOCK_OFF)
				to_chat(user, span_boldnotice("You disable [src]'s zooming system."))
		reset_zooming()
		return

	return ..()

/obj/item/gun/energy/meltagun/proc/set_autozoom_pixel_offsets_immediate(current_angle)
	if(zoom_lock == ZOOM_LOCK_CENTER_VIEW || zoom_lock == ZOOM_LOCK_OFF)
		return
	current_zoom_x = sin(current_angle) + sin(current_angle) * AUTOZOOM_PIXEL_STEP_FACTOR * zoom_current_view_increase
	current_zoom_y = cos(current_angle) + cos(current_angle) * AUTOZOOM_PIXEL_STEP_FACTOR * zoom_current_view_increase

/obj/item/gun/energy/meltagun/proc/handle_zooming()
	if(!zooming || !check_user())
		return
	current_user.client.view_size.setTo(zoom_target_view_increase)
	zoom_current_view_increase = zoom_target_view_increase
	set_autozoom_pixel_offsets_immediate(zooming_angle)

/obj/item/gun/energy/meltagun/proc/start_zooming()
	if(zoom_lock == ZOOM_LOCK_OFF)
		return
	zooming = TRUE

/obj/item/gun/energy/meltagun/proc/stop_zooming(mob/user)
	if(zooming)
		zooming = FALSE
		reset_zooming(user)

/obj/item/gun/energy/meltagun/proc/reset_zooming(mob/user)
	if(!user)
		user = current_user
	if(!user || !user.client)
		return FALSE
	user.client.view_size.zoomIn()
	zoom_current_view_increase = 0
	zooming_angle = 0
	current_zoom_x = 0
	current_zoom_y = 0

/obj/item/gun/energy/meltagun/attack_self(mob/user)
	projectile_setting_pierce = !projectile_setting_pierce
	balloon_alert(user, "switched to [projectile_setting_pierce ? "pierce":"impact"] mode")
	aiming_beam()

/obj/item/gun/energy/meltagun/proc/update_slowdown()
	if(aiming)
		slowdown = scoped_slow
	else
		slowdown = initial(slowdown)

/obj/item/gun/energy/meltagun/Initialize(mapload)
	. = ..()
	fire_delay = delay
	current_tracers = list()
	START_PROCESSING(SSfastprocess, src)

/obj/item/gun/energy/meltagun/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	set_user(null)
	QDEL_LIST(current_tracers)
	listeningTo = null
	return ..()

/obj/item/gun/energy/meltagun/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chambered = null
	recharge_newshot()

/obj/item/gun/energy/meltagun/proc/aiming_beam(force_update = FALSE)
	var/diff = abs(aiming_lastangle - lastangle)
	if(!check_user())
		return
	if(diff < AIMING_BEAM_ANGLE_CHANGE_THRESHOLD && !force_update)
		return
	aiming_lastangle = lastangle
	var/obj/projectile/beam/meltagun/hitscan/aiming_beam/P = new
	P.gun = src
	P.wall_pierce_amount = wall_pierce_amount
	P.structure_pierce_amount = structure_piercing
	P.do_pierce = projectile_setting_pierce
	if(aiming_time)
		var/percent = ((100/aiming_time)*aiming_time_left)
		P.color = rgb(255 * percent,255 * ((100 - percent) / 100),0)
	else
		P.color = rgb(0, 255, 0)
	var/turf/curloc = get_turf(src)

	var/atom/target_atom = current_user.client.mouse_object_ref?.resolve()
	var/turf/targloc = get_turf(target_atom)
	if(!istype(targloc))
		if(!istype(curloc))
			return
		targloc = get_turf_in_angle(lastangle, curloc, 10)
	var/mouse_modifiers = params2list(current_user.client.mouseParams)
	P.preparePixelProjectile(targloc, current_user, mouse_modifiers, 0)
	P.fire(lastangle)

/obj/item/gun/energy/meltagun/process()
	if(!aiming)
		last_process = world.time
		return
	check_user()
	handle_zooming()
	aiming_time_left = max(0, aiming_time_left - (world.time - last_process))
	aiming_beam(TRUE)
	last_process = world.time

/obj/item/gun/energy/meltagun/proc/check_user(automatic_cleanup = TRUE)
	if(!istype(current_user) || !isturf(current_user.loc) || !(src in current_user.held_items) || current_user.incapacitated()) //Doesn't work if you're not holding it!
		if(automatic_cleanup)
			stop_aiming()
			set_user(null)
		return FALSE
	return TRUE

/obj/item/gun/energy/meltagun/proc/process_aim()
	if(istype(current_user) && current_user.client && current_user.client.mouseParams)
		var/angle = mouse_angle_from_client(current_user.client)
		current_user.setDir(angle2dir_cardinal(angle))
		var/difference = abs(closer_angle_difference(lastangle, angle))
		delay_penalty(difference * aiming_time_increase_angle_multiplier)
		lastangle = angle

/obj/item/gun/energy/meltagun/proc/on_mob_move()
	SIGNAL_HANDLER
	check_user()
	if(aiming)
		delay_penalty(aiming_time_increase_user_movement)
		process_aim()
		INVOKE_ASYNC(src, PROC_REF(aiming_beam), TRUE)

/obj/item/gun/energy/meltagun/proc/start_aiming()
	aiming_time_left = aiming_time
	aiming = TRUE
	process_aim()
	aiming_beam(TRUE)
	zooming_angle = lastangle
	start_zooming()

/obj/item/gun/energy/meltagun/proc/stop_aiming(mob/user)
	set waitfor = FALSE
	aiming_time_left = aiming_time
	aiming = FALSE
	QDEL_LIST(current_tracers)
	stop_zooming(user)

/obj/item/gun/energy/meltagun/proc/set_user(mob/user)
	if(user == current_user)
		return
	stop_aiming(current_user)
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
		listeningTo = null
	if(istype(current_user))
		current_user = null
	if(istype(user))
		current_user = user
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_mob_move))
		listeningTo = user

/obj/item/gun/energy/meltagun/onMouseDrag(src_object, over_object, src_location, over_location, params, mob)
	if(aiming)
		process_aim()
		aiming_beam()
		if(zoom_lock == ZOOM_LOCK_AUTOZOOM_FREEMOVE)
			zooming_angle = lastangle
			set_autozoom_pixel_offsets_immediate(zooming_angle)
	return ..()

/obj/item/gun/energy/meltagun/onMouseDown(object, location, params, mob/mob)
	if(istype(mob))
		set_user(mob)
	if(istype(object, /atom/movable/screen) && !istype(object, /atom/movable/screen/click_catcher))
		return
	if((object in mob.contents) || (object == mob))
		return
	start_aiming()
	return ..()

/obj/item/gun/energy/meltagun/onMouseUp(object, location, params, mob/M)
	if(istype(object, /atom/movable/screen) && !istype(object, /atom/movable/screen/click_catcher))
		return
	process_aim()
	if(aiming_time_left <= aiming_time_fire_threshold && check_user())
		sync_ammo()
		var/atom/target = M.client.mouse_object_ref?.resolve()
		if(target)
			afterattack(target, M, FALSE, M.client.mouseParams, passthrough = TRUE)
	stop_aiming()
	QDEL_LIST(current_tracers)
	return ..()

/obj/item/gun/energy/meltagun/afterattack(atom/target, mob/living/user, flag, params, passthrough = FALSE)
	. |= AFTERATTACK_PROCESSED_ITEM
	if(flag) //It's adjacent, is the user, or is on the user's person
		if(target in user.contents) //can't shoot stuff inside us.
			return
		if(!ismob(target) || user.combat_mode) //melee attack
			return
		if(target == user && user.zone_selected != BODY_ZONE_PRECISE_MOUTH) //so we can't shoot ourselves (unless mouth selected)
			return
	if(!passthrough && (aiming_time > aiming_time_fire_threshold))
		return
	if(lastfire > world.time + delay)
		return
	lastfire = world.time
	. = ..()
	stop_aiming()

/obj/item/gun/energy/meltagun/proc/sync_ammo()
	for(var/obj/item/ammo_casing/energy/meltagun/AC in contents)
		AC.sync_stats()

/obj/item/gun/energy/meltagun/proc/delay_penalty(amount)
	aiming_time_left = clamp(aiming_time_left + amount, 0, aiming_time)

/obj/item/ammo_casing/energy/meltagun
	name = "particle acceleration lens"
	desc = "Don't look into barrel!"
	var/wall_pierce_amount = 1
	var/wall_devastate = 1000
	var/aoe_structure_range = 2
	var/aoe_structure_damage = 1000
	var/aoe_fire_range = 2
	var/aoe_fire_chance = 80
	var/aoe_mob_range = 2
	var/aoe_mob_damage = 300
	var/impact_structure_damage = 1000
	var/projectile_damage = 300
	var/projectile_stun = 0
	var/structure_piercing = 2
	var/structure_bleed_coeff = 0.7
	var/do_pierce = TRUE
	var/obj/item/gun/energy/meltagun/host

/obj/item/ammo_casing/energy/meltagun/proc/sync_stats()
	var/obj/item/gun/energy/meltagun/BR = loc
	if(!istype(BR))
		stack_trace("Beam rifle syncing error")
	host = BR
	do_pierce = BR.projectile_setting_pierce
	wall_pierce_amount = BR.wall_pierce_amount
	wall_devastate = BR.wall_devastate
	aoe_structure_range = BR.aoe_structure_range
	aoe_structure_damage = BR.aoe_structure_damage
	aoe_fire_range = BR.aoe_fire_range
	aoe_fire_chance = BR.aoe_fire_chance
	aoe_mob_range = BR.aoe_mob_range
	aoe_mob_damage = BR.aoe_mob_damage
	impact_structure_damage = BR.impact_structure_damage
	projectile_damage = BR.projectile_damage
	projectile_stun = BR.projectile_stun
	delay = BR.delay
	structure_piercing = BR.structure_piercing
	structure_bleed_coeff = BR.structure_bleed_coeff

/obj/item/ammo_casing/energy/meltagun/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	. = ..()
	var/obj/projectile/beam/meltagun/hitscan/HS_BB = loaded_projectile
	if(!istype(HS_BB))
		return
	HS_BB.impact_direct_damage = projectile_damage
	HS_BB.stun = projectile_stun
	HS_BB.impact_structure_damage = impact_structure_damage
	HS_BB.aoe_mob_damage = aoe_mob_damage
	HS_BB.aoe_mob_range = clamp(aoe_mob_range, 0, 15) //Badmin safety lock
	HS_BB.aoe_fire_chance = aoe_fire_chance
	HS_BB.aoe_fire_range = aoe_fire_range
	HS_BB.aoe_structure_damage = aoe_structure_damage
	HS_BB.aoe_structure_range = clamp(aoe_structure_range, 0, 15) //Badmin safety lock
	HS_BB.wall_devastate = wall_devastate
	HS_BB.wall_pierce_amount = wall_pierce_amount
	HS_BB.structure_pierce_amount = structure_piercing
	HS_BB.structure_bleed_coeff = structure_bleed_coeff
	HS_BB.do_pierce = do_pierce
	HS_BB.gun = host

/obj/item/ammo_casing/energy/meltagun/throw_proj(atom/target, turf/targloc, mob/living/user, params, spread, atom/fired_from)
	var/turf/curloc = get_turf(user)
	if(!istype(curloc) || !loaded_projectile)
		return FALSE
	var/obj/item/gun/energy/meltagun/gun = loc
	if(!targloc && gun)
		targloc = get_turf_in_angle(gun.lastangle, curloc, 10)
	else if(!targloc)
		return FALSE
	var/firing_dir
	if(loaded_projectile.firer)
		firing_dir = loaded_projectile.firer.dir
	if(!loaded_projectile.suppressed && firing_effect_type)
		new firing_effect_type(get_turf(src), firing_dir)
	var/modifiers = params2list(params)
	loaded_projectile.preparePixelProjectile(target, user, modifiers, spread)
	loaded_projectile.fire(gun? gun.lastangle : null, null)
	loaded_projectile = null
	return TRUE

/obj/item/ammo_casing/energy/meltagun/hitscan
	projectile_type = /obj/projectile/beam/meltagun/hitscan
	select_name = "beam"
	e_cost = 10000
	fire_sound = 'sound/weapons/beam_sniper.ogg'

/obj/projectile/beam/meltagun
	name = "particle beam"
	icon = null
	hitsound = 'sound/effects/explosion3.ogg'
	damage = 0 //Handled manually.
	damage_type = BURN
	armor_flag = ENERGY
	range = 150
	jitter = 20 SECONDS
	var/obj/item/gun/energy/meltagun/gun
	var/structure_pierce_amount = 0 //All set to 0 so the gun can manually set them during firing.
	var/structure_bleed_coeff = 0
	var/structure_pierce = 0
	var/do_pierce = TRUE
	var/wall_pierce_amount = 0
	var/wall_pierce = 0
	var/wall_devastate = 0
	var/aoe_structure_range = 0
	var/aoe_structure_damage = 0
	var/aoe_fire_range = 0
	var/aoe_fire_chance = 0
	var/aoe_mob_range = 0
	var/aoe_mob_damage = 0
	var/impact_structure_damage = 0
	var/impact_direct_damage = 0
	var/list/pierced = list()

/obj/projectile/beam/meltagun/proc/AOE(turf/epicenter)
	if(!epicenter)
		return
	new /obj/effect/temp_visual/explosion/fast(epicenter)
	for(var/mob/living/L in range(aoe_mob_range, epicenter)) //handle aoe mob damage
		L.adjustFireLoss(aoe_mob_damage)
		to_chat(L, span_userdanger("\The [src] sears you!"))
	for(var/turf/T in RANGE_TURFS(aoe_fire_range, epicenter)) //handle aoe fire
		if(prob(aoe_fire_chance))
			new /obj/effect/hotspot(T)
	for(var/obj/O in range(aoe_structure_range, epicenter))
		if(!isitem(O))
			O.take_damage(aoe_structure_damage * get_damage_coeff(O), BURN, LASER, FALSE)

/obj/projectile/beam/meltagun/prehit_pierce(atom/A)
	if(isclosedturf(A) && (wall_pierce < wall_pierce_amount))
		if(prob(wall_devastate))
			if(iswallturf(A))
				var/turf/closed/wall/W = A
				W.dismantle_wall(TRUE, TRUE)
			else
				SSexplosions.medturf += A
		++wall_pierce
		return PROJECTILE_PIERCE_PHASE // yeah this gun is a snowflakey piece of garbage
	if(isobj(A) && (structure_pierce < structure_pierce_amount))
		++structure_pierce
		var/obj/O = A
		O.take_damage((impact_structure_damage + aoe_structure_damage) * structure_bleed_coeff * get_damage_coeff(A), BURN, ENERGY, FALSE)
		return PROJECTILE_PIERCE_PHASE // ditto and this could be refactored to on_hit honestly
	return ..()

/obj/projectile/beam/meltagun/proc/get_damage_coeff(atom/target)
	if(istype(target, /obj/machinery/door))
		return 0.4
	if(istype(target, /obj/structure/window))
		return 0.5
	return 1

/obj/projectile/beam/meltagun/proc/handle_impact(atom/target)
	if(isobj(target))
		var/obj/O = target
		O.take_damage(impact_structure_damage * get_damage_coeff(target), BURN, LASER, FALSE)
	if(isliving(target))
		var/mob/living/L = target
		L.adjustFireLoss(impact_direct_damage)
		L.emote("scream")

/obj/projectile/beam/meltagun/proc/handle_hit(atom/target, piercing_hit = FALSE)
	set waitfor = FALSE
	if(!is_hostile_projectile())
		return FALSE
	playsound(src, 'sound/effects/explosion3.ogg', 100, TRUE)
	if(!do_pierce)
		AOE(get_turf(target) || get_turf(src))
	if(!QDELETED(target))
		handle_impact(target)

/obj/projectile/beam/meltagun/on_hit(atom/target, blocked = FALSE, piercing_hit = FALSE)
	handle_hit(target, piercing_hit)
	return ..()

/obj/projectile/beam/meltagun/is_hostile_projectile()
	return TRUE // on hit = boom fire

/obj/projectile/beam/meltagun/hitscan
	icon_state = ""
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/tracer/beam_rifle
	var/constant_tracer = FALSE

/obj/projectile/beam/meltagun/hitscan/generate_hitscan_tracers(cleanup = TRUE, duration = 5, impacting = TRUE, highlander)
	set waitfor = FALSE
	if(isnull(highlander))
		highlander = constant_tracer
	if(highlander && istype(gun))
		QDEL_LIST(gun.current_tracers)
		for(var/datum/point/p in beam_segments)
			gun.current_tracers += generate_tracer_between_points(p, beam_segments[p], tracer_type, color, 0, hitscan_light_range, hitscan_light_color_override, hitscan_light_intensity)
	else
		for(var/datum/point/p in beam_segments)
			generate_tracer_between_points(p, beam_segments[p], tracer_type, color, duration, hitscan_light_range, hitscan_light_color_override, hitscan_light_intensity)
	if(cleanup)
		QDEL_LIST(beam_segments)
		beam_segments = null
		QDEL_NULL(beam_index)

/obj/projectile/beam/meltagun/hitscan/aiming_beam
	tracer_type = /obj/effect/projectile/tracer/tracer/aiming
	name = "aiming beam"
	hitsound = null
	hitsound_wall = null
	damage = 0
	constant_tracer = TRUE
	hitscan_light_range = 0
	hitscan_light_intensity = 0
	hitscan_light_color_override = "#99ff99"
	reflectable = REFLECT_FAKEPROJECTILE

/obj/projectile/beam/meltagun/hitscan/aiming_beam/is_hostile_projectile()
	return FALSE // just an aiming reticle

/obj/projectile/beam/meltagun/hitscan/aiming_beam/prehit_pierce(atom/target)
	return PROJECTILE_DELETE_WITHOUT_HITTING

/obj/projectile/beam/meltagun/hitscan/aiming_beam/on_hit()
	qdel(src)
	return BULLET_ACT_BLOCK

#undef AIMING_BEAM_ANGLE_CHANGE_THRESHOLD
#undef AUTOZOOM_PIXEL_STEP_FACTOR
#undef ZOOM_LOCK_AUTOZOOM_ANGLELOCK
#undef ZOOM_LOCK_AUTOZOOM_FREEMOVE
#undef ZOOM_LOCK_CENTER_VIEW
#undef ZOOM_LOCK_OFF
