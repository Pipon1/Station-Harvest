/datum/round_event_control/shuttle_catastrophe
	name = "Catastrophe de navette"
	typepath = /datum/round_event/shuttle_catastrophe
	weight = 10
	max_occurrences = 1
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "Remplace la navette d'urgence par une navette aléatoire."
	admin_setup = list(/datum/event_admin_setup/warn_admin/shuttle_catastrophe, /datum/event_admin_setup/listed_options/shuttle_catastrophe)

/datum/round_event_control/shuttle_catastrophe/can_spawn_event(players, allow_magic = FALSE)
	. = ..()
	if(!.)
		return .

	if(SSshuttle.shuttle_purchased == SHUTTLEPURCHASE_FORCED)
		return FALSE //don't do it if its already been done
	if(istype(SSshuttle.emergency, /obj/docking_port/mobile/emergency/shuttle_build))
		return FALSE //don't undo manual player engineering, it also would unload people and ghost them, there's just a lot of problems
	if(EMERGENCY_AT_LEAST_DOCKED)
		return FALSE //don't remove all players when its already on station or going to centcom
	return TRUE

/datum/round_event/shuttle_catastrophe
	var/datum/map_template/shuttle/new_shuttle

/datum/round_event/shuttle_catastrophe/announce(fake)
	var/cause = pick("a été attaquée par les agents du [syndicate_name()]", "a mystérieusement été téléportée", "n'a pas pu être ravitaillée car l'équipe en charge a organisé une mutinerie",
		"a été trouvée sans ses moteurs, qui ont été volés", "\[SUPPRIMÉ\]", "a volé vers le soleil couchant et a fondue", "a appris quelque chose d'une vache très sage, puis est partie de son propre chef",
		"est en cours d'inspection pour possession d'équipement de clonage illégal", "a été crashée par son pilote, qui a confondu la marche arrière et le frein à main")
	var/message = "Votre navette d'urgence [cause]. "

	if(SSshuttle.shuttle_insurance)
		message += "Heureusement, votre assurance a couvert les réparations !"
		if(SSeconomy.get_dep_account(ACCOUNT_CAR))
			message += " Votre investissement judicieux a été récompensé par le versement d'une prime de la part de [command_name()]."
	else
		message += "Votre navette de remplacement sera lae [new_shuttle.name] jusqu'à nouvel ordre."
	priority_announce(message, "Cordialement, Génie Spatial de [command_name()]")

/datum/round_event/shuttle_catastrophe/setup()
	if(SSshuttle.shuttle_insurance || !isnull(new_shuttle)) //If an admin has overridden it don't re-roll it
		return
	var/list/valid_shuttle_templates = list()
	for(var/shuttle_id in SSmapping.shuttle_templates)
		var/datum/map_template/shuttle/template = SSmapping.shuttle_templates[shuttle_id]
		if(!isnull(template.who_can_purchase) && template.credit_cost < INFINITY) //if we could get it from the communications console, it's cool for us to get it here
			valid_shuttle_templates += template
	new_shuttle = pick(valid_shuttle_templates)

/datum/round_event/shuttle_catastrophe/start()
	if(SSshuttle.shuttle_insurance)
		var/datum/bank_account/station_balance = SSeconomy.get_dep_account(ACCOUNT_CAR)
		station_balance?.adjust_money(8000)
		return
	SSshuttle.shuttle_purchased = SHUTTLEPURCHASE_FORCED
	SSshuttle.unload_preview()
	SSshuttle.existing_shuttle = SSshuttle.emergency
	SSshuttle.action_load(new_shuttle, replace = TRUE)
	log_shuttle("L'événement catastrophe de navette a changé la navette d'urgence pour : [new_shuttle.name].")

/datum/event_admin_setup/warn_admin/shuttle_catastrophe
	warning_text = "Cette action va unload la navette d'urgence actuellement stationnée et EFFACER TOUT ce qui est avec. Voulez vous continuer ?"
	snitch_text = "a forcé l'événement catastrophe de navette alors que la navette d'urgence était déjà stationnée."

/datum/event_admin_setup/warn_admin/shuttle_catastrophe/should_warn()
	return EMERGENCY_AT_LEAST_DOCKED || istype(SSshuttle.emergency, /obj/docking_port/mobile/emergency/shuttle_build)

/datum/event_admin_setup/listed_options/shuttle_catastrophe
	input_text = "Choisir une nouvelle navette d'urgence précise ?"
	normal_run_option = "Navette d'urgence aléatoire"

/datum/event_admin_setup/listed_options/shuttle_catastrophe/get_list()
	var/list/valid_shuttle_templates = list()
	for(var/shuttle_id in SSmapping.shuttle_templates)
		var/datum/map_template/shuttle/template = SSmapping.shuttle_templates[shuttle_id]
		if(!isnull(template.who_can_purchase) && template.credit_cost < INFINITY) //Even admins cannot force the cargo shuttle to act as an escape shuttle
			valid_shuttle_templates += template
	return valid_shuttle_templates

/datum/event_admin_setup/listed_options/shuttle_catastrophe/apply_to_event(datum/round_event/shuttle_catastrophe/event)
	event.new_shuttle = chosen
