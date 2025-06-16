/obj/item/gun/energy/e_gun
	name = "fusil à énergie"
	desc = "Un fusil à énergie hybride avec deux réglages : paralyser et tuer."
	icon_state = "energy"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = null //so the human update icon uses the icon_state instead.
	ammo_type = list(/obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser)
	modifystate = TRUE
	ammo_x_offset = 3
	dual_wield_spread = 60

/obj/item/gun/energy/e_gun/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 15, \
		overlay_y = 10)

/obj/item/gun/energy/e_gun/mini
	name = "petit fusil à énergie"
	desc = "un petit fusil à énergie, il a environ la taille d'un pistolet et il a une lampe de poche intégré. Il possède deux réglages : paralyser et tuer."
	icon_state = "mini"
	inhand_icon_state = "gun"
	w_class = WEIGHT_CLASS_SMALL
	cell_type = /obj/item/stock_parts/cell/mini_egun
	ammo_x_offset = 2
	charge_sections = 3
	single_shot_type_overlay = FALSE

/obj/item/gun/energy/e_gun/mini/add_seclight_point()
	// The mini energy gun's light comes attached but is unremovable.
	AddComponent(/datum/component/seclite_attachable, \
		starting_light = new /obj/item/flashlight/seclite(src), \
		is_light_removable = FALSE, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "mini-light", \
		overlay_x = 19, \
		overlay_y = 13)

/obj/item/gun/energy/e_gun/stun
	name = "fusil à énergie tactique"
	desc = "Un fusil à énergie militaire, capable de tirer des balles paralysantes."
	icon_state = "energytac"
	ammo_x_offset = 2
	ammo_type = list(/obj/item/ammo_casing/energy/electrode/spec, /obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser)

/obj/item/gun/energy/e_gun/old
	name = "prototype de fusil à énergie"
	desc = "Le prototype NT-P:01 est un fusil à énergie unique en son genre, il est capable de modifier la forme du projectile qu'il tire."
	icon_state = "protolaser"
	ammo_x_offset = 2
	ammo_type = list(/obj/item/ammo_casing/energy/laser, /obj/item/ammo_casing/energy/electrode/old)

/obj/item/gun/energy/e_gun/mini/practice_phaser
	name = "phaseur d'entraînement"
	desc = "Une version modifiée du phaseur de base, celui-ci tire des rayons d'énergie moins concentrés conçus pour l'entraînement."
	ammo_type = list(/obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser/practice)
	icon_state = "decloner"
	//You have no icons for energy types, you're a decloner
	modifystate = FALSE
	gun_flags = NOT_A_REAL_GUN

/obj/item/gun/energy/e_gun/hos
	name = "\improper Fusil à énergie X-01 MultiPhase"
	desc = "Une réplique moderne et coûteuse d'un antique fusil à énergie. Ce fusil possède plusieurs modes de tir uniques, mais il ne peut pas se recharger sans l'aide d'une source extérieur."
	cell_type = /obj/item/stock_parts/cell/hos_gun
	icon_state = "hoslaser"
	w_class = WEIGHT_CLASS_NORMAL
	force = 10
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/hos, /obj/item/ammo_casing/energy/laser/hos, /obj/item/ammo_casing/energy/ion/hos)
	ammo_x_offset = 4
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1

/obj/item/gun/energy/e_gun/dragnet
	name = "\improper RALENTITfilet"
	desc = "Un filet énergétique qui ralentit les cibles ou téléporte les cibles."
	icon_state = "dragnet"
	inhand_icon_state = "dragnet"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/net, /obj/item/ammo_casing/energy/trap)
	modifystate = FALSE
	w_class = WEIGHT_CLASS_NORMAL
	ammo_x_offset = 1

/obj/item/gun/energy/e_gun/dragnet/add_seclight_point()
	return

/obj/item/gun/energy/e_gun/dragnet/snare
	name = "Lanceur de bolas énergétiques"
	desc = "Lance un bola énergétique qui ralentit la cible."
	ammo_type = list(/obj/item/ammo_casing/energy/trap)

/obj/item/gun/energy/e_gun/turret
	name = "tourelle hybride"
	desc = "Un canon hybride lourd avec deux réglages : paralyser et tuer."
	icon_state = "turretlaser"
	inhand_icon_state = "turretlaser"
	slot_flags = null
	w_class = WEIGHT_CLASS_HUGE
	ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/laser)
	weapon_weight = WEAPON_HEAVY
	trigger_guard = TRIGGER_GUARD_NONE
	ammo_x_offset = 2

/obj/item/gun/energy/e_gun/turret/add_seclight_point()
	return

/obj/item/gun/energy/e_gun/nuclear
	name = "fusil à énergie avancé"
	desc = "Un fusil à énergie avec un réacteur nucléaire miniaturisé expérimental qui charge automatiquement la cellule d'énergie interne."
	icon_state = "nucgun"
	inhand_icon_state = "nucgun"
	charge_delay = 10
	can_charge = FALSE
	ammo_x_offset = 1
	ammo_type = list(/obj/item/ammo_casing/energy/laser, /obj/item/ammo_casing/energy/disabler)
	selfcharge = 1
	var/reactor_overloaded
	var/fail_tick = 0
	var/fail_chance = 0

/obj/item/gun/energy/e_gun/nuclear/process(seconds_per_tick)
	if(fail_tick > 0)
		fail_tick -= seconds_per_tick * 0.5
	..()

/obj/item/gun/energy/e_gun/nuclear/shoot_live_shot(mob/living/user, pointblank = 0, atom/pbtarget = null, message = 1)
	failcheck()
	update_appearance()
	..()

/obj/item/gun/energy/e_gun/nuclear/proc/failcheck()
	if(prob(fail_chance) && isliving(loc))
		var/mob/living/M = loc
		switch(fail_tick)
			if(0 to 200)
				fail_tick += (2*(fail_chance))
				M.adjustFireLoss(3)
				to_chat(M, span_userdanger("Votre [name] semble plus chaud."))
			if(201 to INFINITY)
				SSobj.processing.Remove(src)
				M.adjustFireLoss(10)
				reactor_overloaded = TRUE
				to_chat(M, span_userdanger("Le réacteur de votre [name] est surchargé !"))

/obj/item/gun/energy/e_gun/nuclear/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	fail_chance = min(fail_chance + round(15/severity), 100)

/obj/item/gun/energy/e_gun/nuclear/update_overlays()
	. = ..()
	if(reactor_overloaded)
		. += "[icon_state]_fail_3"
		return

	switch(fail_tick)
		if(0)
			. += "[icon_state]_fail_0"
		if(1 to 150)
			. += "[icon_state]_fail_1"
		if(151 to INFINITY)
			. += "[icon_state]_fail_2"

/obj/item/gun/energy/e_gun/lethal
	ammo_type = list(/obj/item/ammo_casing/energy/laser, /obj/item/ammo_casing/energy/disabler)
