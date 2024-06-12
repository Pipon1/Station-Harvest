/obj/item/implant/restraining
	name = "restraining implant"
	desc = "Allow the interdiction of certain areas."
	actions_types = null
	var/obj/item/radio/radio
	var/radio_key = /obj/item/encryptionkey/headset_sec
	var/subspace_transmission = FALSE
	COOLDOWN_DECLARE(sec_msg_cooldown)

/obj/item/implant/restraining/proc/on_moved()
	SIGNAL_HANDLER


	for (var/i = 1, i <= rArea.len, i++)
		if (get_area_name(imp_in, TRUE) == rArea[i])
			radio.set_frequency(FREQ_SECURITY)
			if(!COOLDOWN_FINISHED(src, sec_msg_cooldown))
				return
			radio.talk_into(src, "[imp_in] has not respected their restraining order. They're in \the [get_area_name(imp_in, FALSE)].", FREQ_SECURITY)
			to_chat(imp_in, span_warning("You're currently in an unauthorized area, security has been called."))
			COOLDOWN_START(src, sec_msg_cooldown, 10 SECONDS)

/obj/item/implant/restraining/Initialize(mapload)
	. = ..()
	radio = new(src)
	radio.name = "internal radio"
	radio.subspace_transmission = subspace_transmission
	radio.canhear_range = 0
	radio.set_listening(FALSE)
	if(radio_key)
		radio.keyslot = new radio_key

/obj/item/implant/restraining/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	. = ..()
	if (.)
		RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/obj/item/implant/restraining/removed(mob/target, silent = FALSE, special = FALSE)
	. = ..()
	if(.)
		UnregisterSignal(target, COMSIG_MOVABLE_MOVED)

/obj/item/implanter/restraining
	name = "implanter (restraining)"
	imp_type = /obj/item/implant/restraining

/obj/item/implantcase/restraining
	name = "implant case - 'Restraining'"
	desc = "A glass case containing an restraining implant."
	imp_type = /obj/item/implant/restraining
	var/list/areaList = list()
	var/list/tmpl = list()

/obj/item/implantcase/restraining/attack_self(mob/user)
	if (istype(imp, /obj/item/implant/restraining))
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
		imp.rArea = areaList
	else
		to_chat(user, span_warning("There's no implant in this case!"))
