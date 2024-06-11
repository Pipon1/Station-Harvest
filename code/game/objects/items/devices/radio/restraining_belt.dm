/obj/item/restraining_belt
	name = "electropack"
	desc = "Dance my monkeys! DANCE!!!"
	icon = 'icons/obj/radio.dmi'
	icon_state = "electropack0"
	inhand_icon_state = "electropack"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	var/obj/item/radio/radio
	var/radio_key = /obj/item/encryptionkey/headset_sec
	var/subspace_transmission = FALSE
	COOLDOWN_DECLARE(sec_msg_belt_cooldown)
	var/menu = 1
	var/list/rArea = list()
	var/mob/living/imp_in = null

/obj/item/restraining_belt/Initialize(mapload)
	. = ..()
	radio = new(src)
	radio.name = "internal radio"
	radio.subspace_transmission = subspace_transmission
	radio.canhear_range = 0
	radio.set_listening(FALSE)
	if(radio_key)
		radio.keyslot = new radio_key

/obj/item/restraining_belt/attack_hand(mob/user, list/modifiers)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.back)
			to_chat(user, span_warning("You need help taking this off!"))
			return
	return ..()

/obj/item/restraining_belt/proc/on_moved_belt()
	SIGNAL_HANDLER

	imp_in = loc
	for (var/i = 1, i <= rArea.len, i++)
		if (get_area_name(imp_in, TRUE) == rArea[i])
			radio.set_frequency(FREQ_SECURITY)
			if(!COOLDOWN_FINISHED(src, sec_msg_belt_cooldown))
				return
			radio.talk_into(src, "[imp_in] has not respected their restraining order. They're in \the [get_area_name(imp_in, FALSE)].", FREQ_SECURITY)
			to_chat(imp_in, span_warning("You're currently in an unauthorized area, security has been called."))
			to_chat(imp_in, span_danger("You feel a sharp shock!"))
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, imp_in)
			s.start()
			imp_in.Paralyze(100)
			COOLDOWN_START(src, sec_msg_belt_cooldown, 15 SECONDS)


/obj/item/restraining_belt/attack_self(mob/user)
	var/list/areaList = list(
		"Bridge",
		"Security Lobby",
		"Medbay Lobby")
	var/list/tmpl = areaList
	areaList = tgui_input_checkboxes(user, "Please choose the areas to restrain.", "Restraining Implantinator", tmpl, 1, 10, 0)
	rArea = areaList

/obj/item/restraining_belt/attack_self_secondary(mob/user)
	if (menu == 1)
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved_belt))
		menu = 0
		to_chat(user, span_notice("Belt turned on."))
	else if (menu == 0)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		menu = 1
		to_chat(user, span_notice("Belt turned off."))
