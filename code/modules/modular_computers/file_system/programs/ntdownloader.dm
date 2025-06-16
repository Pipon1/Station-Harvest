/datum/computer_file/program/ntnetdownload
	filename = "ntsoftwarehub"
	filedesc = "Centre de téléchargement de logiciels NTNet"
	program_icon_state = "generic"
	extended_desc = "Ce programme permet de télécharger des logiciels depuis les dépôts officiels de NT"
	undeletable = TRUE
	size = 4
	requires_ntnet = TRUE
	available_on_ntnet = FALSE
	ui_header = "downloader_finished.gif"
	tgui_id = "NtosNetDownloader"
	program_icon = "download"

	var/datum/computer_file/program/downloaded_file = null
	var/hacked_download = FALSE
	var/download_completion = FALSE //GQ of downloaded data.
	var/download_netspeed = 0
	var/downloaderror = ""
	var/list/main_repo
	var/list/antag_repo

	var/list/show_categories = list(
		PROGRAM_CATEGORY_CREW,
		PROGRAM_CATEGORY_ENGI,
		PROGRAM_CATEGORY_SCI,
		PROGRAM_CATEGORY_SUPL,
		PROGRAM_CATEGORY_MISC,
	)

/datum/computer_file/program/ntnetdownload/on_start()
	. = ..()
	main_repo = SSmodular_computers.available_station_software
	antag_repo = SSmodular_computers.available_antag_software

/datum/computer_file/program/ntnetdownload/proc/begin_file_download(filename)
	if(downloaded_file)
		return FALSE

	var/datum/computer_file/program/PRG = SSmodular_computers.find_ntnet_file_by_name(filename)

	if(!PRG || !istype(PRG))
		return FALSE

	// Attempting to download antag only program, but without having emagged/syndicate computer. No.
	if(PRG.available_on_syndinet && !(computer.obj_flags & EMAGGED))
		return FALSE

	if(!computer || !computer.can_store_file(PRG))
		return FALSE

	ui_header = "downloader_running.gif"

	if(PRG in main_repo)
		generate_network_log("Début du téléchargement de [PRG.filename].[PRG.filetype] depuis le base de donnée NTNet.")
		hacked_download = FALSE
	else if(PRG in antag_repo)
		generate_network_log("Début du téléchargement du fichier **ENCODE**.[PRG.filetype] depuis un serveur non-spécifié.")
		hacked_download = TRUE
	else
		generate_network_log("Début du téléchargement de [PRG.filename].[PRG.filetype] depuis un serveur non-spécifié.")
		hacked_download = FALSE

	downloaded_file = PRG.clone()

/datum/computer_file/program/ntnetdownload/proc/abort_file_download()
	if(!downloaded_file)
		return
	generate_network_log("Annulation du téléchargement de [hacked_download ? "**ENCODE**" : "[downloaded_file.filename].[downloaded_file.filetype]"].")
	downloaded_file = null
	download_completion = FALSE
	ui_header = "downloader_finished.gif"

/datum/computer_file/program/ntnetdownload/proc/complete_file_download()
	if(!downloaded_file)
		return
	generate_network_log("Téléchargement de [hacked_download ? "**ENCODE**" : "[downloaded_file.filename].[downloaded_file.filetype]"] finit.")
	if(!computer || !computer.store_file(downloaded_file))
		// The download failed
		downloaderror = "ERREUR I/O - Impossible de sauvegarder le fichier. Vérifiez que vous avez assez d'espace libre sur votre disque dur et que votre disque dur est correctement connecté. Si le problème persiste, contactez votre administrateur système pour obtenir de l'aide."
	downloaded_file = null
	download_completion = FALSE
	ui_header = "downloader_finished.gif"

/datum/computer_file/program/ntnetdownload/process_tick(seconds_per_tick)
	if(!downloaded_file)
		return
	if(download_completion >= downloaded_file.size)
		complete_file_download()
	// Download speed according to connectivity state. NTNet server is assumed to be on unlimited speed so we're limited by our local connectivity
	download_netspeed = 0
	// Speed defines are found in misc.dm
	switch(ntnet_status)
		if(1)
			download_netspeed = NTNETSPEED_LOWSIGNAL
		if(2)
			download_netspeed = NTNETSPEED_HIGHSIGNAL
		if(3)
			download_netspeed = NTNETSPEED_ETHERNET
	download_completion += download_netspeed

/datum/computer_file/program/ntnetdownload/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("PRG_downloadfile")
			if(!downloaded_file)
				begin_file_download(params["filename"])
			return TRUE
		if("PRG_reseterror")
			if(downloaderror)
				download_completion = FALSE
				download_netspeed = FALSE
				downloaded_file = null
				downloaderror = ""
			return TRUE
	return FALSE

/datum/computer_file/program/ntnetdownload/ui_data(mob/user)
	var/list/data = list()
	var/list/access = computer.GetAccess()

	data["downloading"] = !!downloaded_file
	data["error"] = downloaderror || FALSE

	// Download running. Wait please..
	if(downloaded_file)
		data["downloadname"] = downloaded_file.filename
		data["downloaddesc"] = downloaded_file.filedesc
		data["downloadsize"] = downloaded_file.size
		data["downloadspeed"] = download_netspeed
		data["downloadcompletion"] = round(download_completion, 0.1)

	data["disk_size"] = computer.max_capacity
	data["disk_used"] = computer.used_capacity
	data["emagged"] = (computer.obj_flags & EMAGGED)

	var/list/repo = antag_repo | main_repo
	var/list/program_categories = list()

	for(var/datum/computer_file/program/programs as anything in repo)
		if(!(programs.category in program_categories))
			program_categories.Add(programs.category)
		data["programs"] += list(list(
			"icon" = programs.program_icon,
			"filename" = programs.filename,
			"filedesc" = programs.filedesc,
			"fileinfo" = programs.extended_desc,
			"category" = programs.category,
			"installed" = !!computer.find_file_by_name(programs.filename),
			"compatible" = check_compatibility(programs),
			"size" = programs.size,
			"access" = (computer.obj_flags & EMAGGED) && programs.available_on_syndinet ? TRUE : programs.can_run(user, transfer = TRUE, access = access),
			"verifiedsource" = programs.available_on_ntnet,
		))

	data["categories"] = show_categories & program_categories

	return data

/datum/computer_file/program/ntnetdownload/proc/check_compatibility(datum/computer_file/program/P)
	var/hardflag = computer.hardware_flag

	if(P?.is_supported_by_hardware(hardware_flag = hardflag, loud = FALSE))
		return TRUE
	return FALSE

/datum/computer_file/program/ntnetdownload/kill_program(forced)
	abort_file_download()
	return ..()
