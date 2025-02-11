/datum/computer_file/program/crew_manifest
	filename = "plexagoncrew"
	filedesc = "Registre d'équipage de Plexagon"
	category = PROGRAM_CATEGORY_CREW
	program_icon_state = "id"
	extended_desc = "Un programme pour voir et imprimer la liste d'équipage de Plexagon."
	transfer_access = list(ACCESS_COMMAND)
	requires_ntnet = TRUE
	size = 4
	tgui_id = "NtosCrewManifest"
	program_icon = "clipboard-list"
	detomatix_resistance = DETOMATIX_RESIST_MAJOR

/datum/computer_file/program/crew_manifest/ui_static_data(mob/user)
	var/list/data = list()
	data["manifest"] = GLOB.manifest.get_manifest()
	return data

/datum/computer_file/program/crew_manifest/ui_act(action, params, datum/tgui/ui)
	switch(action)
		if("PRG_print")
			if(computer) //This option should never be called if there is no printer
				var/contents = {"<h4>Registre de l'équipage</h4>
								<br>
								[GLOB.manifest ? GLOB.manifest.get_html(0) : ""]
								"}
				if(!computer.print_text(contents,text("registre de l'équipage ([])", station_time_timestamp())))
					to_chat(usr, span_notice("L'imprimante n'a plus de papier."))
					return
				else
					computer.visible_message(span_notice("Le [computer] imprime un papier."))
