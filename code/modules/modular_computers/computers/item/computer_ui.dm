/**
 * update_tablet_open_uis
 *
 * Will search the user to see if they have the tablet open.
 * If they don't, we'll open a new UI depending on the tab the tablet is meant to be on.
 * If they do, we'll update the interface and title, then update all static data and re-send assets.
 *
 * This is best called when you're actually changing the app, as we don't check
 * if we're swapping to the current UI repeatedly.
 * Args:
 * user - The person whose UI we're updating.
 */
/obj/item/modular_computer/proc/update_tablet_open_uis(mob/user)
	var/datum/tgui/active_ui = SStgui.get_open_ui(user, src)
	if(!active_ui)
		if(active_program)
			active_ui = new(user, src, active_program.tgui_id, active_program.filedesc)
		else
			active_ui = new(user, src, "NtosMain")
		return active_ui.open()

	if(active_program)
		active_ui.interface = active_program.tgui_id
		active_ui.title = active_program.filedesc
	else
		active_ui.interface = "NtosMain"

	update_static_data(user, active_ui)
	active_ui.send_assets()

/obj/item/modular_computer/interact(mob/user)
	if(enabled)
		ui_interact(user)
	else
		turn_on(user)

// Operates TGUI
/obj/item/modular_computer/ui_interact(mob/user, datum/tgui/ui)
	if(!enabled || !user.can_read(src, READING_CHECK_LITERACY) || !use_power())
		if(ui)
			ui.close()
		return

	// Robots don't really need to see the screen, their wireless connection works as long as computer is on.
	if(!screen_on && !issilicon(user))
		if(ui)
			ui.close()
		return

	if(honkvirus_amount > 0) // EXTRA annoying, huh!
		honkvirus_amount--
		playsound(src, 'sound/items/bikehorn.ogg', 30, TRUE)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		update_tablet_open_uis(user)

/obj/item/modular_computer/ui_assets(mob/user)
	var/list/data = list()
	data += get_asset_datum(/datum/asset/simple/headers)
	if(active_program)
		data += active_program.ui_assets(user)
	return data

/obj/item/modular_computer/ui_static_data(mob/user)
	var/list/data = list()
	if(active_program)
		data += active_program.ui_static_data(user)
		return data

	data["show_imprint"] = istype(src, /obj/item/modular_computer/pda)
	return data

/obj/item/modular_computer/ui_data(mob/user)
	var/list/data = get_header_data()
	if(active_program)
		data += active_program.ui_data(user)
		return data

	data["pai"] = inserted_pai
	data["has_light"] = has_light
	data["light_on"] = light_on
	data["comp_light_color"] = comp_light_color

	data["login"] = list(
		IDName = saved_identification || "Unknown",
		IDJob = saved_job || "Unknown",
	)

	data["proposed_login"] = list(
		IDName = computer_id_slot?.registered_name,
		IDJob = computer_id_slot?.assignment,
	)

	data["removable_media"] = list()
	if(inserted_disk)
		data["removable_media"] += "Eject Disk"
	var/datum/computer_file/program/ai_restorer/airestore_app = locate() in stored_files
	if(airestore_app?.stored_card)
		data["removable_media"] += "intelliCard"

	data["programs"] = list()
	for(var/datum/computer_file/program/program in stored_files)
		data["programs"] += list(list(
			"name" = program.filename,
			"desc" = program.filedesc,
			"header_program" = program.header_program,
			"running" = !!(program in idle_threads),
			"icon" = program.program_icon,
			"alert" = program.alert_pending,
		))

	return data

// Handles user's GUI input
/obj/item/modular_computer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(ishuman(usr) && !allow_chunky)
		var/mob/living/carbon/human/human_user = usr
		if(human_user.check_chunky_fingers())
			balloon_alert(human_user, "vos doigts sont trop gros !")
			return TRUE

	switch(action)
		if("PC_exit")
			kill_program()
			return TRUE
		if("PC_shutdown")
			shutdown_computer()
			return TRUE
		if("PC_minimize")
			if(!active_program)
				return
			//header programs can't be minimized.
			if(active_program.header_program)
				kill_program()
				return TRUE

			idle_threads.Add(active_program)
			active_program.program_state = PROGRAM_STATE_BACKGROUND // Should close any existing UIs

			active_program = null
			update_appearance()
			return TRUE

		if("PC_killprogram")
			var/prog = params["name"]
			var/datum/computer_file/program/killed_program = find_file_by_name(prog)

			if(!istype(killed_program) || killed_program.program_state == PROGRAM_STATE_KILLED)
				return

			killed_program.kill_program(forced = TRUE)
			to_chat(usr, span_notice("Le programme [killed_program.filename].[killed_program.filetype] associé au PID [rand(100,999)] a été tué."))
			return TRUE

		if("PC_runprogram")
			open_program(usr, find_file_by_name(params["name"]))
			return TRUE

		if("PC_toggle_light")
			toggle_flashlight()
			return TRUE

		if("PC_light_color")
			var/mob/user = usr
			var/new_color
			while(!new_color)
				new_color = input(user, "Choisisez une nouvelle couleur pour la lampe de poche de [src].", "Light Color",light_color) as color|null
				if(!new_color)
					return
				if(is_color_dark(new_color, 50) ) //Colors too dark are rejected
					to_chat(user, span_warning("Cette couleur est trop sombre ! Choisissez-en une plus claire."))
					new_color = null
			set_flashlight_color(new_color)
			return TRUE

		if("PC_Eject_Disk")
			var/param = params["name"]
			var/mob/user = usr
			switch(param)
				if("Eject Disk")
					if(!inserted_disk)
						return

					user.put_in_hands(inserted_disk)
					inserted_disk = null
					playsound(src, 'sound/machines/card_slide.ogg', 50)
					return TRUE

				if("intelliCard")
					var/datum/computer_file/program/ai_restorer/airestore_app = locate() in stored_files
					if(!airestore_app)
						return

					if(airestore_app.try_eject(user))
						playsound(src, 'sound/machines/card_slide.ogg', 50)
						return TRUE

				if("ID")
					if(RemoveID(user))
						playsound(src, 'sound/machines/card_slide.ogg', 50)
						return TRUE

		if("PC_Imprint_ID")
			saved_identification = computer_id_slot.registered_name
			saved_job = computer_id_slot.assignment
			UpdateDisplay()
			playsound(src, 'sound/machines/terminal_processing.ogg', 15, TRUE)

		if("PC_Pai_Interact")
			switch(params["option"])
				if("eject")
					usr.put_in_hands(inserted_pai)
					to_chat(usr, span_notice("Vous enlevez [inserted_pai] de votre [name]."))
					inserted_pai = null
					update_appearance(UPDATE_ICON)
				if("interact")
					inserted_pai.attack_self(usr)
			return TRUE

	if(active_program)
		return active_program.ui_act(action, params, ui, state)

/obj/item/modular_computer/ui_host()
	if(physical)
		return physical
	return src
