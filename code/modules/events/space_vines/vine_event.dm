/datum/round_event_control/spacevine
	name = "Vignes de l'espace"
	typepath = /datum/round_event/spacevine
	weight = 15
	max_occurrences = 3
	min_players = 10
	category = EVENT_CATEGORY_ENTITIES
	description = "De la vigne Kuzu ou Kudzu commence à envahir la station. Peut créer des pièges."
	min_wizard_trigger_potency = 4
	max_wizard_trigger_potency = 7
	admin_setup = list(
		/datum/event_admin_setup/set_location/spacevine,
		/datum/event_admin_setup/multiple_choice/spacevine,
		/datum/event_admin_setup/input_number/spacevine_potency,
		/datum/event_admin_setup/input_number/spacevine_production,
	)

/datum/round_event/spacevine
	fakeable = FALSE
	///Override location the vines will spawn in.
	var/turf/override_turf
	///used to confirm if admin selected mutations should be used or not.
	var/mutations_overridden = FALSE
	///Admin selected mutations that the kudzu will spawn with, can be set to none to act as mutationless kudzu.
	var/list/override_mutations = list()
	///Potency of the spawned kudzu.
	var/potency
	///Production value of the spawned kuduz.
	var/production

/datum/round_event/spacevine/start()
	var/list/turfs = list() //list of all the empty floor turfs in the hallway areas


	if(override_turf)
		turfs += override_turf
	else
		var/obj/structure/spacevine/vine = new()

		for(var/area/station/hallway/area in GLOB.areas)
			for(var/turf/open/floor in area.get_contained_turfs())
				if(floor.Enter(vine))
					turfs += floor

		qdel(vine)

	if(length(turfs)) //Pick a turf to spawn at if we can
		var/turf/floor = pick(turfs)
		var/list/selected_mutations = list()

		if(mutations_overridden == FALSE)
			selected_mutations = list(pick(subtypesof(/datum/spacevine_mutation)))
		else
			selected_mutations = override_mutations
		if(isnull(potency))
			potency = rand(50,100)
		if(isnull(production))
			production = rand(1, 4)

		new /datum/spacevine_controller(floor, selected_mutations, potency, production, src) //spawn a controller at turf with randomized stats and a single random mutation

/datum/event_admin_setup/set_location/spacevine
	input_text = "Faire apparaitre des vignes de l'espace à votre localisation actuelle ?"

/datum/event_admin_setup/set_location/spacevine/apply_to_event(datum/round_event/spacevine/event)
	event.override_turf = chosen_turf
	
/datum/event_admin_setup/multiple_choice/spacevine
	input_text = "Select starting mutations."
	min_choices = 0

/datum/event_admin_setup/multiple_choice/spacevine/prompt_admins()
	var/customize_mutations = tgui_alert(usr, "Choisir une mutation ?", event_control.name, list("Personnalisée", "Aléatoire", "Annuler"))
	switch(customize_mutations)
		if("Personnalisée")
			return ..()
		if("Aléatoire")
			choices = list("[pick(subtypesof(/datum/spacevine_mutation))]")
		else
			return ADMIN_CANCEL_EVENT

/datum/event_admin_setup/multiple_choice/spacevine/get_options()
	return subtypesof(/datum/spacevine_mutation/)

/datum/event_admin_setup/multiple_choice/spacevine/apply_to_event(datum/round_event/spacevine/event)
	var/list/type_choices = list()
	for(var/choice in choices)
		type_choices += text2path(choice)
	event.mutations_overridden = TRUE
	event.override_mutations = type_choices
	
/datum/event_admin_setup/input_number/spacevine_potency
	input_text = "Choisissez la puissance des vignes (fait varier la fréquence des mutations + la dangerosité maximale) (maximum de 100)."
	max_value = 100

/datum/event_admin_setup/input_number/spacevine_potency/prompt_admins()
	default_value = rand(50, 100)
	return ..()

/datum/event_admin_setup/input_number/spacevine_potency/apply_to_event(datum/round_event/spacevine/event)
	event.potency = chosen_value

/datum/event_admin_setup/input_number/spacevine_production
	input_text = "Choisissez la production des vignes (fait varier le maximum de propagation et vitesse de propagation) (1 est le plus lent, 10 est le plus rapide)"
	min_value = 1
	max_value = 10

/datum/event_admin_setup/input_number/spacevine_production/prompt_admins()
	default_value = rand(1, 4)
	return ..()

/datum/event_admin_setup/input_number/spacevine_production/apply_to_event(datum/round_event/spacevine/event)
	event.production = chosen_value
