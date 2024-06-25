/datum/antagonist/trapper
	name = "\improper The Trapper"
	roundend_category = "traitors"
	antagpanel_category = "Trappers"
	job_rank = ROLE_TRAP
	antag_hud_name = "traitor"
	ui_name = "AntagInfoMalf"
	///the name of the antag flavor this traitor has.
	var/employer
	///assoc list of strings set up after employer is given
	var/list/malfunction_flavor
	///bool for giving objectives
	var/give_objectives = TRUE
	///bool for giving codewords
	var/should_give_codewords = TRUE
	///since the module purchasing is built into the antag info, we need to keep track of its compact mode here
	var/module_picker_compactmode = FALSE
