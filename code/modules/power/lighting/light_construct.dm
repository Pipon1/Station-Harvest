/obj/structure/light_construct
	name = "monture de lampe"
	desc = "Une monture de lampe encours de construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = TRUE
	layer = WALL_OBJ_LAYER
	plane = GAME_PLANE_UPPER
	max_integrity = 200
	armor_type = /datum/armor/structure_light_construct

	///Light construction stage (LIGHT_CONSTRUCT_EMPTY, LIGHT_CONSTRUCT_WIRED, LIGHT_CONSTRUCT_CLOSED)
	var/stage = LIGHT_CONSTRUCT_EMPTY
	///Type of fixture for icon state
	var/fixture_type = "tube"
	///Amount of sheets gained on deconstruction
	var/sheets_refunded = 2
	///Reference for light object
	var/obj/machinery/light/new_light = null
	///Reference for the internal cell
	var/obj/item/stock_parts/cell/cell
	///Can we support a cell?
	var/cell_connectors = TRUE

/datum/armor/structure_light_construct
	melee = 50
	bullet = 10
	laser = 10
	fire = 80
	acid = 50

/obj/structure/light_construct/Initialize(mapload, ndir, building)
	. = ..()
	if(building)
		setDir(ndir)

/obj/structure/light_construct/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/structure/light_construct/get_cell()
	return cell

/obj/structure/light_construct/examine(mob/user)
	. = ..()
	switch(stage)
		if(LIGHT_CONSTRUCT_EMPTY)
			. += "C'est une monture vide."
		if(LIGHT_CONSTRUCT_WIRED)
			. += "Elle est câblée."
		if(LIGHT_CONSTRUCT_CLOSED)
			. += "La monture est complète."
	if(cell_connectors)
		if(cell)
			. += "Vous voyez une [cell] dans la monture."
		else
			. += "La monture n'a pas de batterie de secours."
	else
		. += span_danger("Cette monture ne peut pas accepter de batterie de secours.")

/obj/structure/light_construct/attack_hand(mob/user, list/modifiers)
	if(!cell)
		return
	user.visible_message(span_notice("[user] retire la [cell] de la [src] !"), span_notice("Vous retirez la [cell]."))
	user.put_in_hands(cell)
	cell.update_appearance()
	cell = null
	add_fingerprint(user)

/obj/structure/light_construct/attack_tk(mob/user)
	if(!cell)
		return
	to_chat(user, span_notice("Vous retirez avec votre télékinésie la [cell]."))
	var/obj/item/stock_parts/cell/cell_reference = cell
	cell = null
	cell_reference.forceMove(drop_location())
	return cell_reference.attack_tk(user)

/obj/structure/light_construct/attackby(obj/item/tool, mob/user, params)
	add_fingerprint(user)
	if(istype(tool, /obj/item/stock_parts/cell))
		if(!cell_connectors)
			to_chat(user, span_warning("Cette [name] ne peut pas accepter de batterie de secours."))
			return
		if(HAS_TRAIT(tool, TRAIT_NODROP))
			to_chat(user, span_warning("[tool] semble être coller à votre main !"))
			return
		if(cell)
			to_chat(user, span_warning("Il y'a déja une batterie de secours !"))
			return
		if(user.temporarilyRemoveItemFromInventory(tool))
			user.visible_message(span_notice("[user] connecte lae [tool] à la [src]."), \
			span_notice("Vous ajoutez lae [tool] à la [src]."))
			playsound(src, 'sound/machines/click.ogg', 50, TRUE)
			tool.forceMove(src)
			cell = tool
			add_fingerprint(user)
			return
	if(istype(tool, /obj/item/light))
		to_chat(user, span_warning("Cette [name] n'est pas complètement construite !"))
		return

	switch(stage)
		if(LIGHT_CONSTRUCT_EMPTY)
			if(tool.tool_behaviour == TOOL_WRENCH)
				if(cell)
					to_chat(user, span_warning("Vous devez retirer la batterie de secours en premier !"))
					return
				to_chat(user, span_notice("Vous commencez à déconstruire la [src]..."))
				if (tool.use_tool(src, user, 30, volume=50))
					new /obj/item/stack/sheet/iron(drop_location(), sheets_refunded)
					user.visible_message(span_notice("[user.name] déconstruit la [src]."), \
						span_notice("Vous déconstruisez la [src]."), span_hear("Vous entendez une clée à molette."))
					playsound(src, 'sound/items/deconstruct.ogg', 75, TRUE)
					qdel(src)
				return

			if(istype(tool, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/coil = tool
				if(coil.use(1))
					icon_state = "[fixture_type]-construct-stage2"
					stage = LIGHT_CONSTRUCT_WIRED
					user.visible_message(span_notice("[user.name] ajoute des câbles dans la [src]."), \
						span_notice("Vous ajoutez des câbles dans la [src]."))
				else
					to_chat(user, span_warning("Vous besoin d'au moins un câble pour câbler la [src] !"))
				return
		if(LIGHT_CONSTRUCT_WIRED)
			if(tool.tool_behaviour == TOOL_WRENCH)
				to_chat(usr, span_warning("Vous devez retirer le câblage !"))
				return

			if(tool.tool_behaviour == TOOL_WIRECUTTER)
				stage = LIGHT_CONSTRUCT_EMPTY
				icon_state = "[fixture_type]-construct-stage1"
				new /obj/item/stack/cable_coil(drop_location(), 1, "red")
				user.visible_message(span_notice("[user.name] retire le câblage de la [src]."), \
					span_notice("Vous retirez le câblage de la [src]."), span_hear("Vous entendez un cliquetement."))
				tool.play_tool_sound(src, 100)
				return

			if(tool.tool_behaviour == TOOL_SCREWDRIVER)
				user.visible_message(span_notice("[user.name] ferme le compartiment interne de la [src]."), \
					span_notice("Vous fermez le compartiment interne de la [src]."), span_hear("Vous entendez un tournevis."))
				tool.play_tool_sound(src, 75)
				switch(fixture_type)
					if("tube")
						new_light = new /obj/machinery/light/built(loc)
					if("bulb")
						new_light = new /obj/machinery/light/small/built(loc)
				new_light.setDir(dir)
				transfer_fingerprints_to(new_light)
				if(!QDELETED(cell))
					new_light.cell = cell
					cell.forceMove(new_light)
					cell = null
				qdel(src)
				return
	return ..()

/obj/structure/light_construct/blob_act(obj/structure/blob/attacking_blob)
	if(attacking_blob && attacking_blob.loc == loc)
		qdel(src)

/obj/structure/light_construct/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/iron(loc, sheets_refunded)
	qdel(src)

/obj/structure/light_construct/small
	name = "petite monture de lampe"
	icon_state = "bulb-construct-stage1"
	fixture_type = "bulb"
	sheets_refunded = 1
