GLOBAL_LIST_EMPTY(announcement_systems)

/obj/machinery/announcement_system
	density = TRUE
	name = "Système d'annonce automatique"
	desc = "An automated announcement system that handles minor announcements over the radio."
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "AAS_On"
	base_icon_state = "AAS"

	verb_say = "énonce calmement"
	verb_ask = "demande"
	verb_exclaim = "alarme"

	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.05

	circuit = /obj/item/circuitboard/machine/announcement_system

	var/obj/item/radio/headset/radio
	var/arrival = "%PERSON s'est enrôlé.e en tant que %RANK"
	var/arrivalToggle = 1
	var/newhead = "%PERSON, %RANK, est à la tête du département."
	var/newheadToggle = 1

	var/greenlight = "Light_Green"
	var/pinklight = "Light_Pink"
	var/errorlight = "Error_Red"

/obj/machinery/announcement_system/Initialize(mapload)
	. = ..()
	GLOB.announcement_systems += src
	radio = new /obj/item/radio/headset/silicon/ai(src)
	update_appearance()

/obj/machinery/announcement_system/update_icon_state()
	icon_state = "[base_icon_state]_[is_operational ? "On" : "Off"][panel_open ? "_Open" : null]"
	return ..()

/obj/machinery/announcement_system/update_overlays()
	. = ..()
	if(arrivalToggle)
		. += greenlight

	if(newheadToggle)
		. += pinklight

	if(machine_stat & BROKEN)
		. += errorlight

/obj/machinery/announcement_system/Destroy()
	QDEL_NULL(radio)
	GLOB.announcement_systems -= src //"OH GOD WHY ARE THERE 100,000 LISTED ANNOUNCEMENT SYSTEMS?!!"
	return ..()

/obj/machinery/announcement_system/screwdriver_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	toggle_panel_open()
	to_chat(user, span_notice("Vous [panel_open ? "ouvrez" : "fermez"] la trap de maintenance de [src]."))
	update_appearance()
	return TRUE

/obj/machinery/announcement_system/crowbar_act(mob/living/user, obj/item/tool)
	if(default_deconstruction_crowbar(tool))
		return TRUE

/obj/machinery/announcement_system/multitool_act(mob/living/user, obj/item/tool)
	if(!panel_open || !(machine_stat & BROKEN))
		return FALSE
	to_chat(user, span_notice("Vous réinitialisez le logiciel de [src]."))
	set_machine_stat(machine_stat & ~BROKEN)
	update_appearance()

/obj/machinery/announcement_system/proc/CompileText(str, user, rank) //replaces user-given variables with actual thingies.
	str = replacetext(str, "%PERSON", "[user]")
	str = replacetext(str, "%RANK", "[rank]")
	return str

/obj/machinery/announcement_system/proc/announce(message_type, user, rank, list/channels)
	if(!is_operational)
		return

	var/message

	if(message_type == "ARRIVAL" && arrivalToggle)
		message = CompileText(arrival, user, rank)
	else if(message_type == "NEWHEAD" && newheadToggle)
		message = CompileText(newhead, user, rank)
	else if(message_type == "ARRIVALS_BROKEN")
		message = "La navette d'arrivée à été endomagée. Arrimage pour réparations..."

	broadcast(message, channels)

/// Announces a new security officer joining over the radio
/obj/machinery/announcement_system/proc/announce_officer(mob/officer, department)
	if (!is_operational)
		return

	broadcast("L'officer [officer.real_name] a été assigné au département [department].", list(RADIO_CHANNEL_SECURITY))

/// Sends a message to the appropriate channels.
/obj/machinery/announcement_system/proc/broadcast(message, list/channels)
	use_power(active_power_usage)
	if(channels.len == 0)
		radio.talk_into(src, message, null)
	else
		for(var/channel in channels)
			radio.talk_into(src, message, channel)

/obj/machinery/announcement_system/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AutomatedAnnouncement")
		ui.open()

/obj/machinery/announcement_system/ui_data()
	var/list/data = list()
	data["arrival"] = arrival
	data["arrivalToggle"] = arrivalToggle
	data["newhead"] = newhead
	data["newheadToggle"] = newheadToggle
	return data

/obj/machinery/announcement_system/ui_act(action, param)
	. = ..()
	if(.)
		return
	if(!usr.can_perform_action(src, ALLOW_SILICON_REACH))
		return
	if(machine_stat & BROKEN)
		visible_message(span_warning("[src] bourdonne."), span_hear("Vous entendez un bourdonnement sourd."))
		playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, TRUE)
		return
	switch(action)
		if("ArrivalText")
			var/NewMessage = trim(html_encode(param["newText"]), MAX_MESSAGE_LEN)
			if(!usr.can_perform_action(src, ALLOW_SILICON_REACH))
				return
			if(NewMessage)
				arrival = NewMessage
				usr.log_message("Le message d'arrivée a été mis à jour pour :: [NewMessage]", LOG_GAME)
		if("NewheadText")
			var/NewMessage = trim(html_encode(param["newText"]), MAX_MESSAGE_LEN)
			if(!usr.can_perform_action(src, ALLOW_SILICON_REACH))
				return
			if(NewMessage)
				newhead = NewMessage
				usr.log_message("Le message de nomination d'un chef de département a été mis à jour pour : [NewMessage]", LOG_GAME)
		if("NewheadToggle")
			newheadToggle = !newheadToggle
			update_appearance()
		if("ArrivalToggle")
			arrivalToggle = !arrivalToggle
			update_appearance()
	add_fingerprint(usr)

/obj/machinery/announcement_system/attack_robot(mob/living/silicon/user)
	. = attack_ai(user)

/obj/machinery/announcement_system/attack_ai(mob/user)
	if(!user.can_perform_action(src, ALLOW_SILICON_REACH))
		return
	if(machine_stat & BROKEN)
		to_chat(user, span_warning("Le logiciel de [src] a l'air de dysfonctionner !"))
		return
	interact(user)

/obj/machinery/announcement_system/proc/act_up() //does funny breakage stuff
	if(!atom_break()) // if badmins flag this unbreakable or its already broken
		return

	arrival = pick("#!@%ERR-34%2 IMPOSSIBLE DE L@=CALISER LE FICHIE#% DE PROFESSION!", "ERREUR CRITIQUE 99.", "ERR)#R: BASE DE DONN2ES NON TROUVE")
	newhead = pick("SURCH@ARG#: \[INCONNU??\] DET*#CT2!", "ER)#R - B*@ TEXTE TRO_V%", "AAS.exe ne répond pas. NanoOS recherche une solution au problème.")

/obj/machinery/announcement_system/emp_act(severity)
	. = ..()
	if(!(machine_stat & (NOPOWER|BROKEN)) && !(. & EMP_PROTECT_SELF))
		act_up()

/obj/machinery/announcement_system/emag_act()
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	act_up()
