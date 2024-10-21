/obj/item/restraining_belt
	name = "Restraining Belt"
	desc = "Restrain the clown... or the engineer... or whoever you don't like."
	icon = 'icons/obj/radio.dmi'
	icon_state = "restraining_belt"
	inhand_icon_state = "restraining_belt"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_HUGE
	custom_materials = list(/datum/material/iron=10000, /datum/material/glass=2500)
	var/obj/item/radio/radio
	var/radio_key = /obj/item/encryptionkey/headset_sec
	var/subspace_transmission = FALSE
	var/list/rArea = list("Bridge")
	var/mob/living/imp_in = null;
	var/dto = FALSE
	COOLDOWN_DECLARE(sec_msg_cooldown_belt)

/obj/item/restraining_belt/Initialize(mapload)
	. = ..()
	radio = new(src)
	radio.name = "internal radio"
	radio.subspace_transmission = subspace_transmission
	radio.canhear_range = 0
	radio.set_listening(FALSE)
	if(radio_key)
		radio.keyslot = new radio_key

/obj/item/restraining_belt/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] hooks [user.p_them()]self to the restraining belt and spams the trigger! It looks like [user.p_theyre()] trying to commit suicide!"))
	return FIRELOSS


//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/restraining_belt/attack_hand(mob/user, list/modifiers)
	if(iscarbon(user))
		if(dto == TRUE)
			to_chat(user, span_warning("You need help taking this off!"))
			return
	return ..()

/obj/item/restraining_belt/proc/on_moved_belt()
	SIGNAL_HANDLER

	for (var/i = 1, i <= rArea.len, i++)
		if (get_area_name(imp_in, TRUE) == rArea[i])
			radio.set_frequency(FREQ_SECURITY)
			if(!COOLDOWN_FINISHED(src, sec_msg_cooldown_belt))
				return
			else
				step(imp_in, pick(GLOB.cardinals))
				radio.talk_into(src, "[imp_in] has not respected their restraining order. They're in \the [get_area_name(imp_in, FALSE)].", FREQ_SECURITY)
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(3, 1, imp_in)
				s.start()
				imp_in.Paralyze(100)
				COOLDOWN_START(src, sec_msg_cooldown_belt, 15 SECONDS)

/obj/item/restraining_belt/attackby(obj/item/W, mob/user, params)
	if (istype(W, /obj/item/screwdriver) && dto == FALSE)
		var/list/areaList = list()
		var/list/tmpl = list()
		areaList = list(
			"Bridge",
			"Heads of Staff Meeting Room",
			"Teleporter Room",
			"Telecomms Control Room",
			"Bar Lounge",
			"Cafeteria",
			"Kitchen",
			"Bar",
			"Theater",
			"Library",
			"Chapel",
			"Custodial Closet",
			"Hydroponics",
			"Engineering Lobby",
			"Supermatter Engine Room",
			"Medbay Lobby",
			"Medical Cold Room",
			"Virology",
			"Morgue",
			"Pharmacy",
			"Chemistry",
			"Security Lobby",
			"Security Locker Room",
			"Delivery Office",
			"Warehouse",
			"Cargo Office",
			"Cargo Bay",
			"Cargo Lobby",
			"Mining Dock",
			"Research and Development",
			"Xenobiology Lab",
			"Ordnance Lab",
			"Genetics Lab",
			"Robotics Lab",
			"Mech Bay",
			"Augmentation Theater"
			)
		tmpl = areaList
		areaList = tgui_input_checkboxes(user, "Please choose the areas to restrain.", "Restraining Implantinator", tmpl, 1, 10, 0)
		rArea = areaList
	else
		to_chat(user, span_notice("You need a screwdriver to modify this!"))

/obj/item/restraining_belt/equipped(mob/M, slot)
	. = ..()
	if (slot & ITEM_SLOT_BELT)
		imp_in = M
		RegisterSignal(M, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved_belt))
		dto = TRUE


/obj/item/restraining_belt/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOVABLE_MOVED)
	dto = FALSE
