/datum/computer_file/program/science
	filename = "experi_track"
	filedesc = "HUB de recherche de Nanotrasen"
	category = PROGRAM_CATEGORY_SCI
	program_icon_state = "research"
	extended_desc = "Ce programme se connecte au serveur de recherche interne pour aider les efforts de recherche de la station."
	requires_ntnet = TRUE
	size = 10
	tgui_id = "NtosTechweb"
	program_icon = "atom"
	required_access = list(ACCESS_COMMAND, ACCESS_RESEARCH)
	transfer_access = list(ACCESS_RESEARCH)
	/// Reference to global science techweb
	var/datum/techweb/stored_research
	/// Access needed to lock/unlock the console
	var/lock_access = ACCESS_RESEARCH
	/// Determines if the console is locked, and consequently if actions can be performed with it
	var/locked = FALSE
	/// Used for compressing data sent to the UI via static_data as payload size is of concern
	var/id_cache = list()
	/// Sequence var for the id cache
	var/id_cache_seq = 1

/datum/computer_file/program/science/on_start(mob/living/user)
	. = ..()
	if(!CONFIG_GET(flag/no_default_techweb_link) && !stored_research)
		stored_research = SSresearch.science_tech

/datum/computer_file/program/science/application_attackby(obj/item/attacking_item, mob/living/user)
	if(!istype(attacking_item, /obj/item/multitool))
		return FALSE
	var/obj/item/multitool/attacking_tool = attacking_item
	if(!QDELETED(attacking_tool.buffer) && istype(attacking_tool.buffer, /datum/techweb))
		stored_research = attacking_tool.buffer
	return TRUE

/datum/computer_file/program/science/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/research_designs)
	)

// heavy data from this proc should be moved to static data when possible
/datum/computer_file/program/science/ui_data(mob/user)
	var/list/data = list()
	data["stored_research"] = !!stored_research
	if(!stored_research) //lack of a research node is all we care about.
		return data
	data += list(
		"nodes" = list(),
		"experiments" = list(),
		"researched_designs" = stored_research.researched_designs,
		"points" = stored_research.research_points,
		"points_last_tick" = stored_research.last_bitcoins,
		"web_org" = stored_research.organization,
		"sec_protocols" = !(computer.obj_flags & EMAGGED),
		"t_disk" = null, //Not doing disk operations on the app, use the console for that.
		"d_disk" = null, //See above.
		"locked" = locked,
	)

	// Serialize all nodes to display
	for(var/tier in stored_research.tiers)
		var/datum/techweb_node/node = SSresearch.techweb_node_by_id(tier)

		// Ensure node is supposed to be visible
		if (stored_research.hidden_nodes[tier])
			continue

		data["nodes"] += list(list(
			"id" = node.id,
			"can_unlock" = stored_research.can_unlock_node(node),
			"tier" = stored_research.tiers[node.id]
		))

	// Get experiments and serialize them
	var/list/exp_to_process = stored_research.available_experiments.Copy()
	for (var/comp_experi in stored_research.completed_experiments)
		exp_to_process += stored_research.completed_experiments[comp_experi]
	for (var/process_experi in exp_to_process)
		var/datum/experiment/unf_experi = process_experi
		data["experiments"][unf_experi.type] = list(
			"name" = unf_experi.name,
			"description" = unf_experi.description,
			"tag" = unf_experi.exp_tag,
			"progress" = unf_experi.check_progress(),
			"completed" = unf_experi.completed,
			"performance_hint" = unf_experi.performance_hint
		)
	return data

/datum/computer_file/program/science/ui_act(action, list/params)
	// Check if the console is locked to block any actions occuring
	if (locked && action != "toggleLock")
		computer.say("L'ordinateur est vérouillé. Aucune action possible.")
		return TRUE

	switch (action)
		if ("toggleLock")
			if(computer.obj_flags & EMAGGED)
				to_chat(usr, span_boldwarning("Erreur du protocole de sécurité : Incapable d'accéder au vérouillage."))
				return TRUE
			if(lock_access in computer?.computer_id_slot?.access)
				locked = !locked
			else
				to_chat(usr, span_boldwarning("Accès interdit. Veuillez insérer un ID du département scientifique."))
			return TRUE
		if ("researchNode")
			research_node(params["node_id"], usr)
			return TRUE

/datum/computer_file/program/science/ui_static_data(mob/user)
	. = list(
		"static_data" = list()
	)

	// Build node cache...
	// Note this looks a bit ugly but its to reduce the size of the JSON payload
	// by the greatest amount that we can, as larger JSON payloads result in
	// hanging when the user opens the UI
	var/node_cache = list()
	for (var/node_id in SSresearch.techweb_nodes)
		var/datum/techweb_node/node = SSresearch.techweb_nodes[node_id] || SSresearch.error_node
		var/compressed_id = "[compress_id(node.id)]"
		node_cache[compressed_id] = list(
			"name" = node.display_name,
			"description" = node.description
		)
		if (LAZYLEN(node.research_costs))
			node_cache[compressed_id]["costs"] = list()
			for (var/node_cost in node.research_costs)
				node_cache[compressed_id]["costs"]["[compress_id(node_cost)]"] = node.research_costs[node_cost]
		if (LAZYLEN(node.prereq_ids))
			node_cache[compressed_id]["prereq_ids"] = list()
			for (var/prerequisite_node in node.prereq_ids)
				node_cache[compressed_id]["prereq_ids"] += compress_id(prerequisite_node)
		if (LAZYLEN(node.design_ids))
			node_cache[compressed_id]["design_ids"] = list()
			for (var/unlocked_design in node.design_ids)
				node_cache[compressed_id]["design_ids"] += compress_id(unlocked_design)
		if (LAZYLEN(node.unlock_ids))
			node_cache[compressed_id]["unlock_ids"] = list()
			for (var/unlocked_node in node.unlock_ids)
				node_cache[compressed_id]["unlock_ids"] += compress_id(unlocked_node)
		if (LAZYLEN(node.required_experiments))
			node_cache[compressed_id]["required_experiments"] = node.required_experiments
		if (LAZYLEN(node.discount_experiments))
			node_cache[compressed_id]["discount_experiments"] = node.discount_experiments

	// Build design cache
	var/design_cache = list()
	var/datum/asset/spritesheet/research_designs/spritesheet = get_asset_datum(/datum/asset/spritesheet/research_designs)
	var/size32x32 = "[spritesheet.name]32x32"
	for (var/design_id in SSresearch.techweb_designs)
		var/datum/design/design = SSresearch.techweb_designs[design_id] || SSresearch.error_design
		var/compressed_id = "[compress_id(design.id)]"
		var/size = spritesheet.icon_size_id(design.id)
		design_cache[compressed_id] = list(
			design.name,
			"[size == size32x32 ? "" : "[size] "][design.id]"
		)

	// Ensure id cache is included for decompression
	var/flat_id_cache = list()
	for (var/id in id_cache)
		flat_id_cache += id

	.["static_data"] = list(
		"node_cache" = node_cache,
		"design_cache" = design_cache,
		"id_cache" = flat_id_cache
	)

/**
 * Compresses an ID to an integer representation using the id_cache, used for deduplication
 * in sent JSON payloads
 *
 * Arguments:
 * * id - the ID to compress
 */
/datum/computer_file/program/science/proc/compress_id(id)
	if (!id_cache[id])
		id_cache[id] = id_cache_seq
		id_cache_seq += 1
	return id_cache[id]

/datum/computer_file/program/science/proc/research_node(id, mob/user)
	if(!stored_research || !stored_research.available_nodes[id] || stored_research.researched_nodes[id])
		computer.say("Débloquage de la node échouée : Pas de connexion au réseau, le noeud est déjà recherché ou n'est pas disponible !")
		return FALSE
	var/datum/techweb_node/tech_node = SSresearch.techweb_node_by_id(id)
	if(!istype(tech_node))
		computer.say("Débloquage de la node échouée : Erreure inconnue.")
		return FALSE
	var/list/price = tech_node.get_price(stored_research)
	if(stored_research.can_afford(price))
		user.investigate_log("researched [id]([json_encode(price)]) on techweb id [stored_research.id] via [computer].", INVESTIGATE_RESEARCH)
		if(stored_research == SSresearch.science_tech)
			SSblackbox.record_feedback("associative", "science_techweb_unlock", 1, list("id" = "[id]", "name" = tech_node.display_name, "price" = "[json_encode(price)]", "time" = SQLtime()))
		if(stored_research.research_node_id(id))
			computer.say("Successfully researched [tech_node.display_name].")
			var/logname = "Unknown"
			if(isAI(user))
				logname = "AI [user.name]"
			if(iscyborg(user))
				logname = "CYBORG [user.name]"
			if(iscarbon(user))
				var/obj/item/card/id/idcard = user.get_active_held_item()
				if(istype(idcard))
					logname = "[idcard.registered_name]"
			if(ishuman(user))
				var/mob/living/carbon/human/human_user = user
				var/obj/item/worn = human_user.wear_id
				if(istype(worn))
					var/obj/item/card/id/id_card_of_human_user = worn.GetID()
					if(istype(id_card_of_human_user))
						logname = "[id_card_of_human_user.registered_name]"
			stored_research.research_logs += list(list(
				"node_name" = tech_node.display_name,
				"node_cost" = price["General Research"],
				"node_researcher" = logname,
				"node_research_location" = "[get_area(computer)] ([user.x],[user.y],[user.z])",
			))
			return TRUE
		else
			computer.say("Failed to research node: Internal database error!")
			return FALSE
	computer.say("Not enough research points...")
	return FALSE
