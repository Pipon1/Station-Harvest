//KEEP IN MIND: These are different from gun/grenadelauncher. These are designed to shoot premade rocket and grenade projectiles, not flashbangs or chemistry casings etc.
//Put handheld rocket launchers here if someone ever decides to make something so hilarious ~Paprika

/obj/item/gun/ballistic/revolver/grenadelauncher//this is only used for underbarrel grenade launchers at the moment, but admins can still spawn it if they feel like being assholes
	desc = "Un lance grenade un coup."
	name = "lance grenade"
	icon_state = "dshotgun_sawn"
	inhand_icon_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/internal/grenadelauncher
	fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	pin = /obj/item/firing_pin/implant/pindicate
	bolt_type = BOLT_TYPE_NO_BOLT

/obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/revolver/grenadelauncher/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/ammo_box) || isammocasing(A))
		chamber_round()

/obj/item/gun/ballistic/revolver/grenadelauncher/cyborg
	desc = "Lance grenade à 6 coups."
	name = "lance grenade multi coup"
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_grenadelnchr"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/grenademulti
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/revolver/grenadelauncher/cyborg/attack_self()
	return

/obj/item/gun/ballistic/automatic/gyropistol
	name = "pistolet gyrojet"
	desc = "Un pistolet expérimental conçu pour tirer des roquettes auto-propulsées."
	icon_state = "gyropistol"
	fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	mag_type = /obj/item/ammo_box/magazine/m75
	burst_size = 1
	fire_delay = 0
	actions_types = list()
	casing_ejector = FALSE

/obj/item/gun/ballistic/rocketlauncher
	name = "\improper PML-9"
	desc = "Un lance-roquettes réutilisable. Les mots \"NT par ici\" et une flèche ont été écrits près du canon. \
	Un autocollant près de la crosse indique \"ASSUREZ-VOUS QUE LA ZONE DERRIÈRE EST DÉGAGÉE AVANT DE TIRER\""
	icon_state = "rocketlauncher"
	inhand_icon_state = "rocketlauncher"
	mag_type = /obj/item/ammo_box/magazine/internal/rocketlauncher
	fire_sound = 'sound/weapons/gun/general/rocket_launch.ogg'
	w_class = WEIGHT_CLASS_BULKY
	can_suppress = FALSE
	pin = /obj/item/firing_pin/implant/pindicate
	burst_size = 1
	fire_delay = 0
	casing_ejector = FALSE
	weapon_weight = WEAPON_HEAVY
	bolt_type = BOLT_TYPE_NO_BOLT
	internal_magazine = TRUE
	cartridge_wording = "rocket"
	empty_indicator = TRUE
	tac_reloads = FALSE
	/// Do we shit flames behind us when we fire?
	var/backblast = TRUE

/obj/item/gun/ballistic/rocketlauncher/Initialize(mapload)
	. = ..()
	if(backblast)
		AddElement(/datum/element/backblast)

/obj/item/gun/ballistic/rocketlauncher/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/rocketlauncher/nobackblast
	name = "PML-11 sans-flamme"
	desc = "Un lance-roquettes réutilissable. Il a été modifié avec un refroidisseur spécial pour éviter des morts embarassante à cause du retour de flamme."
	backblast = FALSE

/obj/item/gun/ballistic/rocketlauncher/afterattack()
	. = ..()
	magazine.get_round(FALSE) //Hack to clear the mag after it's fired

/obj/item/gun/ballistic/rocketlauncher/attack_self_tk(mob/user)
	return //too difficult to remove the rocket with TK

/obj/item/gun/ballistic/rocketlauncher/suicide_act(mob/living/user)
	user.visible_message(span_warning("[user] pointe le [src] vers le sol ! Il semble que [user.p_theyre()] a l'attention de faire un saut aidé par roquette !"), \
		span_userdanger("Vous visez le sol avec le [src] pour faire un saut aidé par roquette..."))
	if(can_shoot())
		user.notransform = TRUE
		playsound(src, 'sound/vehicles/rocketlaunch.ogg', 80, TRUE, 5)
		animate(user, pixel_z = 300, time = 30, easing = LINEAR_EASING)
		sleep(7 SECONDS)
		animate(user, pixel_z = 0, time = 5, easing = LINEAR_EASING)
		sleep(0.5 SECONDS)
		user.notransform = FALSE
		process_fire(user, user, TRUE)
		if(!QDELETED(user)) //if they weren't gibbed by the explosion, take care of them for good.
			user.gib()
		return MANUAL_SUICIDE
	else
		sleep(0.5 SECONDS)
		shoot_with_empty_chamber(user)
		sleep(2 SECONDS)
		user.visible_message(span_warning("[user] regarde la pièce et se rend compte que [user.p_theyre()] est toujours ici. [user.p_they(TRUE)] commence à enfoncer le canon du [src] dans sa gorge et s'étouffe avec !"), \
			span_userdanger("Vous regardez autours de vous et vous vous rendez compte que vous êtes toujours là, vous commencez à vous étouffer avec le [src] !"))
		sleep(2 SECONDS)
		return OXYLOSS
