// /program/ files are executable programs that do things.
/datum/computer_file/program
	filetype = "PRG"
	/// File name. FILE NAME MUST BE UNIQUE IF YOU WANT THE PROGRAM TO BE DOWNLOADABLE FROM NTNET!
	filename = "UnknownProgram"
	/// List of required accesses to *run* the program. Any match will do.
	var/list/required_access = list()
	/// List of required access to download or file host the program. Any match will do.
	var/list/transfer_access = list()
	/// PROGRAM_STATE_KILLED or PROGRAM_STATE_BACKGROUND or PROGRAM_STATE_ACTIVE - specifies whether this program is running.
	var/program_state = PROGRAM_STATE_KILLED
	/// User-friendly name of this program.
	var/filedesc = "Programme inconnu"
	/// Short description of this program's function.
	var/extended_desc = "N/A"
	/// Category in the NTDownloader.
	var/category = PROGRAM_CATEGORY_MISC
	/// Program-specific screen icon state
	var/program_icon_state = null
	///Boolean on whether the program will appear at the top on PDA menus, or in the app list with everything else.
	var/header_program = FALSE
	/// Set to 1 for program to require nonstop NTNet connection to run. If NTNet connection is lost program crashes.
	var/requires_ntnet = FALSE
	/// NTNet status, updated every tick by computer running this program. Don't use this for checks if NTNet works, computers do that. Use this for calculations, etc.
	var/ntnet_status = 1
	/// Bitflags (PROGRAM_CONSOLE, PROGRAM_LAPTOP, PROGRAM_TABLET combination) or PROGRAM_ALL
	var/usage_flags = PROGRAM_ALL
	/// Whether the program can be downloaded from NTNet. Set to FALSE to disable.
	var/available_on_ntnet = TRUE
	/// Whether the program can be downloaded from SyndiNet (accessible via emagging the computer). Set to TRUE to enable.
	var/available_on_syndinet = FALSE
	/// Name of the tgui interface
	var/tgui_id
	/// Example: "something.gif" - a header image that will be rendered in computer's UI when this program is running at background. Images must also be inserted into /datum/asset/simple/headers.
	var/ui_header = null
	/// Font Awesome icon to use as this program's icon in the modular computer main menu. Defaults to a basic program maximize window icon if not overridden.
	var/program_icon = "window-maximize-o"
	/// Whether this program can send alerts while minimized or closed. Used to show a mute button per program in the file manager
	var/alert_able = FALSE
	/// Whether the user has muted this program's ability to send alerts.
	var/alert_silenced = FALSE
	/// Whether to highlight our program in the main screen. Intended for alerts, but loosely available for any need to notify of changed conditions. Think Windows task bar highlighting. Available even if alerts are muted.
	var/alert_pending = FALSE
	/// How well this program will help combat detomatix viruses.
	var/detomatix_resistance = NONE

/datum/computer_file/program/clone()
	var/datum/computer_file/program/temp = ..()
	temp.required_access = required_access
	temp.filedesc = filedesc
	temp.program_icon_state = program_icon_state
	temp.requires_ntnet = requires_ntnet
	temp.usage_flags = usage_flags
	return temp

///We are not calling parent as it's handled by the computer itself, this is only called after.
/datum/computer_file/program/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	SHOULD_CALL_PARENT(FALSE)

// Relays icon update to the computer.
/datum/computer_file/program/proc/update_computer_icon()
	if(computer)
		computer.update_appearance()

///Attempts to generate an Ntnet log, returns the log on success, FALSE otherwise.
/datum/computer_file/program/proc/generate_network_log(text)
	if(computer)
		return computer.add_log(text)
	return FALSE

/**
 *Runs when the device is used to attack an atom in non-combat mode using right click (secondary).
 *
 *Simulates using the device to read or scan something. Tap is called by the computer during pre_attack
 *and sends us all of the related info. If we return TRUE, the computer will stop the attack process
 *there. What we do with the info is up to us, but we should only return TRUE if we actually perform
 *an action of some sort.
 *Arguments:
 *A is the atom being tapped
 *user is the person making the attack action
 *params is anything the pre_attack() proc had in the same-named variable.
*/
/datum/computer_file/program/proc/tap(atom/tapped_atom, mob/living/user, params)
	return FALSE

///Makes sure a program can run on this hardware (for apps limited to tablets/computers/laptops)
/datum/computer_file/program/proc/is_supported_by_hardware(hardware_flag = NONE, loud = FALSE, mob/user)
	if(!(hardware_flag & usage_flags))
		if(loud && computer && user)
			to_chat(user, span_danger("Le [computer] affiche \"ERREUR MATERIEL - programme incompatible\" attention."))
		return FALSE
	return TRUE

// Called by Process() on device that runs us, once every tick.
/datum/computer_file/program/proc/process_tick(seconds_per_tick)
	return TRUE

/**
 *Check if the user can run program. Only humans and silicons can operate computer. Automatically called in on_start()
 *ID must be inserted into a card slot to be read. If the program is not currently installed (as is the case when
 *NT Software Hub is checking available software), a list can be given to be used instead.
 *Arguments:
 *user is a ref of the mob using the device.
 *loud is a bool deciding if this proc should use to_chats
 *access_to_check is an access level that will be checked against the ID
 *transfer, if TRUE and access_to_check is null, will tell this proc to use the program's transfer_access in place of access_to_check
 *access can contain a list of access numbers to check against. If access is not empty, it will be used istead of checking any inserted ID.
*/
/datum/computer_file/program/proc/can_run(mob/user, loud = FALSE, access_to_check, transfer = FALSE, list/access)
	if(issilicon(user))
		return TRUE

	if(isAdminGhostAI(user))
		return TRUE

	if(!transfer && computer && (computer.obj_flags & EMAGGED)) //emags can bypass the execution locks but not the download ones.
		return TRUE

	// Defaults to required_access
	if(!access_to_check)
		if(transfer && length(transfer_access))
			access_to_check = transfer_access
		else
			access_to_check = required_access
	if(!length(access_to_check)) // No required_access, allow it.
		return TRUE

	if(!length(access))
		var/obj/item/card/id/accesscard
		if(computer)
			accesscard = computer.computer_id_slot?.GetID()

		if(!accesscard)
			if(loud)
				to_chat(user, span_danger("Le [computer] affiche \"ERREUR RFID - impossible de scanner l'ID\" attention."))
			return FALSE
		access = accesscard.GetAccess()

	for(var/singular_access in access_to_check)
		if(singular_access in access) //For loop checks every individual access entry in the access list. If the user's ID has access to any entry, then we're good.
			return TRUE

	if(loud)
		to_chat(user, span_danger("Le [computer] affiche \"Accès non-autorisé\" attention."))
	return FALSE

/**
 * Called on program startup.
 *
 * May be overridden to add extra logic. Remember to include ..() call. Return 1 on success, 0 on failure.
 * When implementing new program based device, use this to run the program.
 * Arguments:
 * * user - The mob that started the program
 **/
/datum/computer_file/program/proc/on_start(mob/living/user)
	SHOULD_CALL_PARENT(TRUE)
	if(can_run(user, loud = TRUE))
		if(requires_ntnet)
			var/obj/item/card/id/ID = computer.computer_id_slot?.GetID()
			generate_network_log("Connexion ouverte -- ID du programme : [filename] Utilisateur : [ID?"[ID.registered_name]":"None"]")
		program_state = PROGRAM_STATE_ACTIVE
		return TRUE
	return FALSE

/**
 * Kills the running program
 *
 * Use this proc to kill the program. Designed to be implemented by each program if it requires on-quit logic, such as the NTNRC client.
 * Arguments:
 * * forced - Boolean to determine if this was a forced close. Should be TRUE if the user did not willingly close the program.
 **/
/datum/computer_file/program/proc/kill_program(forced = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	program_state = PROGRAM_STATE_KILLED
	if(src in computer.idle_threads)
		computer.idle_threads.Remove(src)
	if(requires_ntnet)
		var/obj/item/card/id/ID = computer.computer_id_slot?.GetID()
		generate_network_log("Connexion fermée -- ID du programme : [filename] Utilisateur : [ID ? "[ID.registered_name]" : "None"]")
	return TRUE
