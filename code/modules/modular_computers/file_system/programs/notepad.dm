/datum/computer_file/program/notepad
	filename = "notepad"
	filedesc = "Bloc-Notes"
	category = PROGRAM_CATEGORY_MISC
	program_icon_state = "generic"
	extended_desc = "Ecrivez rapidement vos pensées en accord avec NanoTrasen."
	size = 2
	tgui_id = "NtosNotepad"
	program_icon = "book"
	usage_flags = PROGRAM_TABLET

	var/written_note = "Félécitations pour la mise à jour de votre station vers le nouvel effort de collaboration basé sur NtOS et Thinktronic, \
		vous apportant le meilleur de l'électronique et des logiciels depuis 2467 !"

/datum/computer_file/program/notepad/ui_act(action, list/params, datum/tgui/ui)
	switch(action)
		if("UpdateNote")
			written_note = params["newnote"]
			return TRUE

/datum/computer_file/program/notepad/ui_data(mob/user)
	var/list/data = list()

	data["note"] = written_note

	return data
