/obj/item/restraining_belt
	name = "Restraining Belt"
	desc = "Dance my monkeys! DANCE!!!"
	icon = 'icons/obj/radio.dmi'
	icon_state = "electropack0"
	inhand_icon_state = "electropack"
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
	user.visible_message(span_suicide("[user] hooks [user.p_them()]self to the electropack and spams the trigger! It looks like [user.p_theyre()] trying to commit suicide!"))
	return FIRELOSS


//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/restraining_belt/attack_hand(mob/user, list/modifiers)
	if(iscarbon(user))
		if(src.item_action_slot_check(ITEM_SLOT_BELT, user))
			to_chat(user, span_warning("You need help taking this off!"))
			return
	return ..()

obj/item/restraining_belt/proc/on_moved_belt()
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
	if (istype(W, /obj/item/screwdriver))
		var/list/areaList = list()
		var/list/tmpl = list()
		areaList = list(
			"Bridge",
			"Security Lobby",
			"Medbay Lobby")
		tmpl = areaList
		areaList = tgui_input_checkboxes(user, "Please choose the areas to restrain.", "Restraining Implantinator", tmpl, 1, 10, 0)
		rArea = areaList
	else
		to_chat(user, span_notice("You need a screwdriver to modify this!"))

/obj/item/restraining_belt/equipped(mob/M, slot)
	if (slot & ITEM_SLOT_BELT)
		imp_in = M
		RegisterSignal(M, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved_belt))

/obj/item/restraining_belt/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOVABLE_MOVED)

/*/obj/item/electropack/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/clothing/head/helmet))
		var/obj/item/assembly/shock_kit/A = new /obj/item/assembly/shock_kit(user)
		A.icon = 'icons/obj/assemblies/assemblies.dmi'

		if(!user.transferItemToLoc(W, A))
			to_chat(user, span_warning("[W] is stuck to your hand, you cannot attach it to [src]!"))
			return
		W.master = A
		A.helmet_part = W

		user.transferItemToLoc(src, A, TRUE)
		master = A
		A.electropack_part = src

		user.put_in_hands(A)
		A.add_fingerprint(user)
	else
		return ..()

/obj/item/electropack/receive_signal(datum/signal/signal)
	if(!signal || signal.data["code"] != code)
		return
	if(isliving(loc) && on)
		if(shock_cooldown)
			return
		shock_cooldown = TRUE
		addtimer(VARSET_CALLBACK(src, shock_cooldown, FALSE), 100)
		var/mob/living/L = loc
		step(L, pick(GLOB.cardinals))

		to_chat(L, span_danger("You feel a sharp shock!"))
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, L)
		s.start()

		L.Paralyze(100)

	if(master)
		if(isassembly(master))
			var/obj/item/assembly/master_as_assembly = master
			master_as_assembly.pulsed()
		master.receive_signal()

/obj/item/electropack/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	SSradio.add_object(src, frequency, RADIO_SIGNALER)

/obj/item/electropack/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/electropack/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Electropack", name)
		ui.open()

/obj/item/electropack/ui_data(mob/user)
	var/list/data = list()
	data["power"] = on
	data["frequency"] = frequency
	data["code"] = code
	data["minFrequency"] = MIN_FREE_FREQ
	data["maxFrequency"] = MAX_FREE_FREQ
	return data

/obj/item/electropack/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("power")
			on = !on
			icon_state = "electropack[on]"
			. = TRUE
		if("freq")
			var/value = unformat_frequency(params["freq"])
			if(value)
				frequency = sanitize_frequency(value, TRUE)
				set_frequency(frequency)
				. = TRUE
		if("code")
			var/value = text2num(params["code"])
			if(value)
				value = round(value)
				code = clamp(value, 1, 100)
				. = TRUE
		if("reset")
			if(params["reset"] == "freq")
				frequency = initial(frequency)
				. = TRUE
			else if(params["reset"] == "code")
				code = initial(code)
				. = TRUE*/
