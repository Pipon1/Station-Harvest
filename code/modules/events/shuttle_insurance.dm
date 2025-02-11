

/datum/round_event_control/shuttle_insurance
	name = "Assurance pour navette"
	typepath = /datum/round_event/shuttle_insurance
	max_occurrences = 1
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "Une offre d'assurance louche mais réglo."

/datum/round_event_control/shuttle_insurance/can_spawn_event(players, allow_magic = FALSE)
	. = ..()
	if(!.)
		return .

	if(!SSeconomy.get_dep_account(ACCOUNT_CAR))
		return FALSE //They can't pay?
	if(SSshuttle.shuttle_purchased == SHUTTLEPURCHASE_FORCED)
		return FALSE //don't do it if there's nothing to insure
	if(istype(SSshuttle.emergency, /obj/docking_port/mobile/emergency/shuttle_build))
		return FALSE //this shuttle prevents the catastrophe event from happening making this event effectively useless
	if(EMERGENCY_AT_LEAST_DOCKED)
		return FALSE //catastrophes won't trigger so no point
	return TRUE

/datum/round_event/shuttle_insurance
	var/ship_name = "\"In the Unlikely Event\""
	var/datum/comm_message/insurance_message
	var/insurance_evaluation = 0

/datum/round_event/shuttle_insurance/announce(fake)
	priority_announce("Communication sousespace entrante. Salon sécurisé ouvert sur toutes les consoles de communication.", "Message entrant", SSstation.announcer.get_rand_report_sound())

/datum/round_event/shuttle_insurance/setup()
	ship_name = pick(strings(PIRATE_NAMES_FILE, "rogue_names"))
	for(var/shuttle_id in SSmapping.shuttle_templates)
		var/datum/map_template/shuttle/template = SSmapping.shuttle_templates[shuttle_id]
		if(template.name == SSshuttle.emergency.name) //found you slackin
			insurance_evaluation = template.credit_cost/2
			break
	if(!insurance_evaluation)
		insurance_evaluation = 5000 //gee i dunno

/datum/round_event/shuttle_insurance/start()
	insurance_message = new("Assurance pour navette", "Salut les gars ! Ici le [ship_name], on a pas pu s'empêcher de remarquer que vous évacuez avec une navette bancale et pas ouf SANS ASSURANCE ! Dingue. Et si quelque chose arrivait, hein ?! On a fait un évaluation rapide des tarifs dans le secteur et on vous propose[insurance_evaluation] pour assurer votre navette, en cas de problème.", list("Souscrire à l'assurance.","Rejeter l'offre."))
	insurance_message.answer_callback = CALLBACK(src, PROC_REF(answered))
	SScommunications.send_message(insurance_message, unique = TRUE)

/datum/round_event/shuttle_insurance/proc/answered()
	if(EMERGENCY_AT_LEAST_DOCKED)
		priority_announce("Il est beaucoup trop tard pour souscrire à notre assurance, les gars. Nos agents ne travaillent pas directement sur place.",sender_override = ship_name)
		return
	if(insurance_message && insurance_message.answered == 1)
		var/datum/bank_account/station_balance = SSeconomy.get_dep_account(ACCOUNT_CAR)
		if(!station_balance?.adjust_money(-insurance_evaluation))
			priority_announce("Vous ne nous avez pas envoyé assez l'argent pour l'assurance de la navette. Et ça, en terme juridique la loi spatiale, c'est une arnaque. On garde votre thune, bande d'escrocs !",sender_override = ship_name)
			return
		priority_announce("Merci d'avoir souscrit à notre assurance pour navette !",sender_override = ship_name)
		SSshuttle.shuttle_insurance = TRUE
