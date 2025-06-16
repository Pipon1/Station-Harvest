/datum/computer_file/program/maintenance/phys_scanner
	filename = "phys_scanner"
	filedesc = "Scanneur physique"
	category = PROGRAM_CATEGORY_MISC
	extended_desc = "Ce programme permet au tablette de scanner des objets physiques et d'afficher une sortie de données."
	size = 2
	usage_flags = PROGRAM_TABLET
	tgui_id = "NtosPhysScanner"
	program_icon = "barcode"
	/// Information from the last scanned person, to display on the app.
	var/last_record = ""

/datum/computer_file/program/maintenance/phys_scanner/tap(atom/tapped_atom, mob/living/user, params)
	. = ..()

	if(!iscarbon(tapped_atom))
		return
	var/mob/living/carbon/carbon = tapped_atom
	carbon.visible_message(span_notice("[user] analyse les vitaux [tapped_atom]."))
	last_record = healthscan(user, carbon, 1, tochat = FALSE)
	var/datum/tgui/active_ui = SStgui.get_open_ui(user, computer)
	if(active_ui)
		active_ui.send_full_update(force = TRUE)

/datum/computer_file/program/maintenance/phys_scanner/ui_static_data(mob/user)
	var/list/data = list()
	data["last_record"] = last_record
	return data
