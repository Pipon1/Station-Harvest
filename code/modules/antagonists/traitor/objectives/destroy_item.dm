/datum/traitor_objective/destroy_item
	name = "Steal %ITEM% and destroy it"
	description = "Trouvez lae %ITEM% et détruisez lae à tout prix. Nous ne pouvons pas laisser l'équipage posséder un.e %ITEM% car iel rentre en conflit avec nos intêrets."

	var/list/possible_items = list()
	/// The current target item that we are stealing.
	var/datum/objective_item/steal/target_item
	/// Any special equipment that may be needed
	var/list/special_equipment
	/// Items that are currently tracked and will succeed this objective when destroyed.
	var/list/tracked_items = list()

	abstract_type = /datum/traitor_objective/destroy_item

/datum/traitor_objective/destroy_item/low_risk
	progression_minimum = 10 MINUTES
	progression_maximum = 35 MINUTES
	progression_reward = list(5 MINUTES, 10 MINUTES)
	telecrystal_reward = 1

	possible_items = list(
		/datum/objective_item/steal/traitor/bartender_shotgun,
		/datum/objective_item/steal/traitor/fireaxe,
		/datum/objective_item/steal/traitor/nullrod,
		/datum/objective_item/steal/traitor/big_crowbar,
	)

/datum/traitor_objective/destroy_item/very_risky
	progression_minimum = 40 MINUTES
	progression_reward = 15 MINUTES
	telecrystal_reward = list(6, 9)

	possible_items = list(
		/datum/objective_item/steal/blackbox,
	)

/datum/traitor_objective/destroy_item/generate_objective(datum/mind/generating_for, list/possible_duplicates)
	for(var/datum/traitor_objective/destroy_item/objective as anything in possible_duplicates)
		possible_items -= objective.target_item.type
	while(length(possible_items))
		var/datum/objective_item/steal/target = pick_n_take(possible_items)
		target = new target()
		if(!target.valid_objective_for(list(generating_for), require_owner = TRUE))
			qdel(target)
			continue
		target_item = target
		break
	if(!target_item)
		return FALSE
	if(target_item.exists_on_map)
		var/list/items = GLOB.steal_item_handler.objectives_by_path[target_item.targetitem]
		for(var/obj/item/item as anything in items)
			AddComponent(/datum/component/traitor_objective_register, item, succeed_signals = list(COMSIG_PARENT_QDELETING))
			tracked_items += item
	if(length(target_item.special_equipment))
		special_equipment = target_item.special_equipment
	replace_in_name("%ITEM%", target_item.name)
	AddComponent(/datum/component/traitor_objective_mind_tracker, generating_for, \
		signals = list(COMSIG_MOB_EQUIPPED_ITEM = PROC_REF(on_item_pickup)))
	return TRUE

/datum/traitor_objective/destroy_item/generate_ui_buttons(mob/user)
	var/list/buttons = list()
	if(special_equipment)
		buttons += add_ui_button("", "Pressez ce buton pour matérialiser de l'équipement dont vous pourriez avoir besoin pour cette opération.", "tools", "summon_gear")
	return buttons

/datum/traitor_objective/destroy_item/ui_perform_action(mob/living/user, action)
	. = ..()
	switch(action)
		if("summon_gear")
			if(!special_equipment)
				return
			for(var/item in special_equipment)
				var/obj/item/new_item = new item(user.drop_location())
				user.put_in_hands(new_item)
			user.balloon_alert(user, "L'objet se matérialise dans votre main.")
			special_equipment = null

/datum/traitor_objective/destroy_item/proc/on_item_pickup(datum/source, obj/item/item, slot)
	SIGNAL_HANDLER
	if(istype(item, target_item.targetitem) && !(item in tracked_items))
		AddComponent(/datum/component/traitor_objective_register, item, succeed_signals = list(COMSIG_PARENT_QDELETING))
		tracked_items += item

/datum/traitor_objective/destroy_item/ungenerate_objective()
	tracked_items.Cut()
	return ..()
