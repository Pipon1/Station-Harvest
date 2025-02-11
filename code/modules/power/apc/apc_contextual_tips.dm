/obj/machinery/power/apc/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if (isnull(held_item))
		if (opened == APC_COVER_CLOSED)
			context[SCREENTIP_CONTEXT_RMB] = locked ? "Vérouillé" : "Dévérouiller"
		else if (opened == APC_COVER_OPENED && cell)
			context[SCREENTIP_CONTEXT_LMB] = "Retirer la batterie"

	else if(held_item.tool_behaviour == TOOL_CROWBAR)
		if (opened == APC_COVER_CLOSED)
			context[SCREENTIP_CONTEXT_LMB] = "Ouvrir le couvercle"
		else if ((opened == APC_COVER_OPENED && has_electronics == APC_ELECTRONICS_SECURED) && !(machine_stat & BROKEN))
			context[SCREENTIP_CONTEXT_LMB] = "Fermer et vérouiller"
		else if (machine_stat & BROKEN|(machine_stat & EMAGGED| malfhack))
			context[SCREENTIP_CONTEXT_LMB] = "Retirer la carte mère endommagée"
		else
			context[SCREENTIP_CONTEXT_LMB] = "Retirer la carte mère"

	else if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
		if (opened == APC_COVER_CLOSED)
			context[SCREENTIP_CONTEXT_LMB] = panel_open ? "Cacher les câbles" : "Exposer les câbles"
		else if (cell && opened == APC_COVER_OPENED)
			context[SCREENTIP_CONTEXT_LMB] = "Retirer la batterie"
		else if (has_electronics == APC_ELECTRONICS_INSTALLED)
			context[SCREENTIP_CONTEXT_LMB] = "Attacher la carte mère"
		else if (has_electronics == APC_ELECTRONICS_SECURED)
			context[SCREENTIP_CONTEXT_LMB] = "Détacher la carte mère"

	else if(held_item.tool_behaviour == TOOL_WIRECUTTER)
		if (terminal && opened == APC_COVER_OPENED)
			context[SCREENTIP_CONTEXT_LMB] = "Arracher les câbles du terminal"

	else if(held_item.tool_behaviour == TOOL_WELDER)
		if (opened == APC_COVER_OPENED && !has_electronics)
			context[SCREENTIP_CONTEXT_LMB] = "Désassembler le CEL"

	else if(istype(held_item, /obj/item/stock_parts/cell) && opened == APC_COVER_OPENED)
		context[SCREENTIP_CONTEXT_LMB] = "Insérer la batterie"

	else if(istype(held_item, /obj/item/stack/cable_coil) && opened == APC_COVER_OPENED)
		context[SCREENTIP_CONTEXT_LMB] = "Attacher les câbles au terminal"

	else if(istype(held_item, /obj/item/electronics/apc) && opened == APC_COVER_OPENED)
		context[SCREENTIP_CONTEXT_LMB] = "Insérer la carte mère"

	else if(istype(held_item, /obj/item/electroadaptive_pseudocircuit) && opened == APC_COVER_OPENED)
		if (!has_electronics)
			context[SCREENTIP_CONTEXT_LMB] = "Insérer une carte mère de CEL"
		else if(!cell)
			context[SCREENTIP_CONTEXT_LMB] = "Insérer une batterie"

	else if(istype(held_item, /obj/item/wallframe/apc))
		context[SCREENTIP_CONTEXT_LMB] = "Remplacer la coque endommagée"

	return CONTEXTUAL_SCREENTIP_SET
