/* Pens!
 * Contains:
 * Pens
 * Sleepy Pens
 * Parapens
 * Edaggers
 */


/*
 * Pens
 */
/obj/item/pen
	desc = "C'est un stylo normal à l'encre noir."
	name = "stylo"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	inhand_icon_state = "pen"
	worn_icon_state = "pen"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_EARS
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=10)
	pressure_resistance = 2
	grind_results = list(/datum/reagent/iron = 2, /datum/reagent/iodine = 1)
	var/colour = "#000000" //what colour the ink is!
	var/degrees = 0
	var/font = PEN_FONT
	var/requires_gravity = TRUE // can you use this to write in zero-g
	embedding = list(embed_chance = 50)
	sharpness = SHARP_POINTY

/obj/item/pen/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] est entrain d'écrire des nombres sur leur corps avec [src] ! Il semble que [user.p_theyre()] essaie de faire un sudoku..."))
	return BRUTELOSS

/obj/item/pen/blue
	desc = "C'est un stylo normal à l'encre bleu."
	icon_state = "pen_blue"
	colour = "#0000FF"

/obj/item/pen/red
	desc = "C'est un stylo normal à l'encre rouge."
	icon_state = "pen_red"
	colour = "#FF0000"
	throw_speed = 4 // red ones go faster (in this case, fast enough to embed!)

/obj/item/pen/invisible
	desc = "C'est un stylo à l'encre invisible."
	icon_state = "pen"
	colour = "#FFFFFF"

/obj/item/pen/fourcolor
	desc = "C'est un stylo quatre couleur... Trop cool !"
	name = "four-color pen"
	icon_state = "pen_4color"
	colour = "#000000"

/obj/item/pen/fourcolor/attack_self(mob/living/carbon/user)
	. = ..()
	var/chosen_color = "noir"
	switch(colour)
		if("#000000")
			colour = "#FF0000"
			chosen_color = "rouge"
			throw_speed++
		if("#FF0000")
			colour = "#00FF00"
			chosen_color = "vert"
			throw_speed = initial(throw_speed)
		if("#00FF00")
			colour = "#0000FF"
			chosen_color = "bleu"
		else
			colour = "#000000"
	to_chat(user, span_notice("Le [src] écrira maintenant en [chosen_color]."))
	desc = "C'est un stylo quatre couleur... Trop cool ! Sa couleur actuelle est : [chosen_color]."

/obj/item/pen/fountain
	name = "stylo à plume"
	desc = "C'est un stylo à plume tout ce qu'il y'a de plus normal, avec un corps en faux bois. Il marche supposément en 0G."
	icon_state = "pen-fountain"
	font = FOUNTAIN_PEN_FONT
	requires_gravity = FALSE // fancy spess pens

/obj/item/pen/charcoal
	name = "stylet à charbon"
	desc = "C'est juste un petit baton avec des cendres compressé au bout. Mais au moins il peut écrire."
	icon_state = "pen-charcoal"
	colour = "#696969"
	font = CHARCOAL_FONT
	custom_materials = null
	grind_results = list(/datum/reagent/ash = 5, /datum/reagent/cellulose = 10)
	requires_gravity = FALSE // this is technically a pencil

/datum/crafting_recipe/charcoal_stylus
	name = "Stylet à charbon"
	result = /obj/item/pen/charcoal
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1, /datum/reagent/ash = 30)
	time = 3 SECONDS
	category = CAT_TOOLS

/obj/item/pen/fountain/captain
	name = "stylo à plume du capitaine"
	desc = "C'est un stylo à plume très cher, avec un corps en chêne. Le bout est vraiment tranchant."
	icon_state = "pen-fountain-o"
	force = 5
	throwforce = 5
	throw_speed = 4
	colour = "#DC143C"
	custom_materials = list(/datum/material/gold = 750)
	sharpness = SHARP_EDGED
	resistance_flags = FIRE_PROOF
	unique_reskin = list("chêne" = "pen-fountain-o",
						"or" = "pen-fountain-g",
						"palissandre" = "pen-fountain-r",
						"noir et argent" = "pen-fountain-b",
						"bleu de commande" = "pen-fountain-cb"
						)
	embedding = list("embed_chance" = 75)

/obj/item/pen/fountain/captain/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 20 SECONDS, \
	effectiveness = 115, \
	)
	//the pen is mightier than the sword

/obj/item/pen/fountain/captain/reskin_obj(mob/M)
	..()
	if(current_skin)
		desc = "C'est un stylo à plume très cher, avec un corps en [current_skin]. Le bout est vraiment tranchant."

/obj/item/pen/attack_self(mob/living/carbon/user)
	. = ..()
	if(.)
		return
	if(loc != user)
		to_chat(user, span_warning("Vous devez tenir le stylo pour continuer !"))
		return
	var/deg = tgui_input_number(user, "De combien de degré voulez vous tourner la tête du stylo ? (0-360)", "Tourner la tête du stylo", max_value = 360)
	if(isnull(deg) || QDELETED(user) || QDELETED(src) || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH) || loc != user)
		return
	degrees = deg
	to_chat(user, span_notice("Vous tournez la tête du stylo de [deg] degrés."))
	SEND_SIGNAL(src, COMSIG_PEN_ROTATED, deg, user)

/obj/item/pen/attack(mob/living/M, mob/user, params)
	if(force) // If the pen has a force value, call the normal attack procs. Used for e-daggers and captain's pen mostly.
		return ..()
	if(!M.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
		return FALSE
	to_chat(user, span_warning("Vous poignardez [M] avec le stylo."))
	to_chat(M, span_danger("Vous sentez une petite piqure !"))
	log_combat(user, M, "stabbed", src)
	return TRUE

/obj/item/pen/afterattack(obj/O, mob/living/user, proximity)
	. = ..()

	if (!proximity)
		return .

	. |= AFTERATTACK_PROCESSED_ITEM

	//Changing name/description of items. Only works if they have the UNIQUE_RENAME object flag set
	if(isobj(O) && (O.obj_flags & UNIQUE_RENAME))
		var/penchoice = tgui_input_list(user, "Que voulez vous éditer ?", "Options du stylo", list("Renommer", "Description", "Annuler"))
		if(QDELETED(O) || !user.can_perform_action(O))
			return
		if(penchoice == "Renommer")
			var/input = tgui_input_text(user, "Quel est le nouveau nom de [O] ?", "Nom de l'objet", "[O.name]", MAX_NAME_LEN)
			var/oldname = O.name
			if(QDELETED(O) || !user.can_perform_action(O))
				return
			if(input == oldname || !input)
				to_chat(user, span_notice("Vous avez changé [O] par... euh... et bien... [O]."))
			else
				O.AddComponent(/datum/component/rename, input, O.desc)
				var/datum/component/label/label = O.GetComponent(/datum/component/label)
				if(label)
					label.remove_label()
					label.apply_label()
				to_chat(user, span_notice("Vous avez renommé avec succès [oldname] en [O]."))
				O.renamedByPlayer = TRUE

		if(penchoice == "Description")
			var/input = tgui_input_text(user, "Décrit [O]", "Description", "[O.desc]", 140)
			var/olddesc = O.desc
			if(QDELETED(O) || !user.can_perform_action(O))
				return
			if(input == olddesc || !input)
				to_chat(user, span_notice("Vous décidez de ne pas changer la description de [O]."))
			else
				O.AddComponent(/datum/component/rename, O.name, input)
				to_chat(user, span_notice("Vous avez chez la description de [O] avec succèsl."))
				O.renamedByPlayer = TRUE

		if(penchoice == "Annuler")
			if(QDELETED(O) || !user.can_perform_action(O))
				return

			qdel(O.GetComponent(/datum/component/rename))

			//reapply any label to name
			var/datum/component/label/label = O.GetComponent(/datum/component/label)
			if(label)
				label.remove_label()
				label.apply_label()

			to_chat(user, span_notice("Vous avez annulé les changements de la description et du nom de [O]."))
			O.renamedByPlayer = FALSE

/obj/item/pen/get_writing_implement_details()
	return list(
		interaction_mode = MODE_WRITING,
		font = font,
		color = colour,
		use_bold = FALSE,
	)

/*
 * Sleepypens
 */

/obj/item/pen/sleepy/attack(mob/living/M, mob/user, params)
	. = ..()
	if(!.)
		return
	if(!reagents.total_volume)
		return
	if(!M.reagents)
		return
	reagents.trans_to(M, reagents.total_volume, transfered_by = user, methods = INJECT)


/obj/item/pen/sleepy/Initialize(mapload)
	. = ..()
	create_reagents(45, OPENCONTAINER)
	reagents.add_reagent(/datum/reagent/toxin/chloralhydrate, 20)
	reagents.add_reagent(/datum/reagent/toxin/mutetoxin, 15)
	reagents.add_reagent(/datum/reagent/toxin/staminatoxin, 10)

/*
 * (Alan) Edaggers
 */
/obj/item/pen/edagger
	attack_verb_continuous = list("slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts") //these won't show up if the pen is off
	attack_verb_simple = list("slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	sharpness = SHARP_POINTY
	armour_penetration = 20
	bare_wound_bonus = 10
	item_flags = NO_BLOOD_ON_ITEM
	light_system = MOVABLE_LIGHT
	light_range = 1.5
	light_power = 0.75
	light_color = COLOR_SOFT_RED
	light_on = FALSE
	/// The real name of our item when extended.
	var/hidden_name = "dague énergétique"
	/// The real desc of our item when extended.
	var/hidden_desc = "C'est un stylo à encre noi- Attend. Ce truc est utilisé pour poignardé des gens !"
	/// The real icons used when extended.
	var/hidden_icon = "edagger"
	/// Whether or pen is extended
	var/extended = FALSE

/obj/item/pen/edagger/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 6 SECONDS, \
	butcher_sound = 'sound/weapons/blade1.ogg', \
	)
	AddComponent(/datum/component/transforming, \
		force_on = 18, \
		throwforce_on = 35, \
		throw_speed_on = 4, \
		sharpness_on = SHARP_EDGED, \
		w_class_on = WEIGHT_CLASS_NORMAL, \
		inhand_icon_change = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))
	RegisterSignal(src, COMSIG_DETECTIVE_SCANNED, PROC_REF(on_scan))

/obj/item/pen/edagger/suicide_act(mob/living/user)
	if(extended)
		user.visible_message(span_suicide("[user] enfonce violemment le stylo dans leur bouche !"))
	else
		user.visible_message(span_suicide("[user] maintient un stylo dans sa bouche ! Il semble que [user.p_theyre()] essaie de se suicider !"))
		attack_self(user)
	return BRUTELOSS

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Handles swapping their icon files to edagger related icon files -
 * as they're supposed to look like a normal pen.
 */
/obj/item/pen/edagger/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	extended = active
	if(active)
		name = hidden_name
		desc = hidden_desc
		icon_state = hidden_icon
		inhand_icon_state = hidden_icon
		lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
		righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
		embedding = list(embed_chance = 100) // Rule of cool
	else
		name = initial(name)
		desc = initial(desc)
		icon_state = initial(icon_state)
		inhand_icon_state = initial(inhand_icon_state)
		lefthand_file = initial(lefthand_file)
		righthand_file = initial(righthand_file)
		embedding = list(embed_chance = EMBED_CHANCE)

	updateEmbedding()
	balloon_alert(user, "[hidden_name] [active ? "actif":"caché"]")
	playsound(user ? user : src, active ? 'sound/weapons/saberon.ogg' : 'sound/weapons/saberoff.ogg', 5, TRUE)
	set_light_on(active)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/pen/edagger/proc/on_scan(datum/source, mob/user, list/extra_data)
	SIGNAL_HANDLER
	LAZYADD(extra_data[DETSCAN_CATEGORY_ILLEGAL], "Générateur de lumière-solide détécté.")

/obj/item/pen/survival
	name = "stylo de survie"
	desc = "La dernière nouveautée en technologie de survie. Ce stylo est une pioche en diamant miniature."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "digging_pen"
	inhand_icon_state = "pen"
	worn_icon_state = "pen"
	force = 3
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron=10, /datum/material/diamond=100, /datum/material/titanium = 10)
	pressure_resistance = 2
	grind_results = list(/datum/reagent/iron = 2, /datum/reagent/iodine = 1)
	tool_behaviour = TOOL_MINING //For the classic "digging out of prison with a spoon but you're in space so this analogy doesn't work" situation.
	toolspeed = 10 //You will never willingly choose to use one of these over a shovel.
	font = FOUNTAIN_PEN_FONT
	colour = "#0000FF"

/obj/item/pen/destroyer
	name = "stylo à bout pointu"
	desc = "Un stylo avec un bout infiniment tranchant. Capable de frapper le point faible de n'importe quel robot ou structure, les détruisant instantanément. Pas mauvais pour faire des trous dans des gens."
	force = 5
	wound_bonus = 100
	demolition_mod = 9000

// screwdriver pen!

/obj/item/pen/screwdriver
	desc = "Un stylo avec un bout de tournevis. Celui ci à un capuchon jaune."
	icon_state = "pendriver"
	toolspeed = 1.2  // gotta have some downside
	/// whether the pen is extended
	var/extended = FALSE

/obj/item/pen/screwdriver/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		throwforce_on = 5, \
		w_class_on = WEIGHT_CLASS_SMALL, \
		sharpness_on = TRUE, \
		inhand_icon_change = FALSE, \
	)

	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(toggle_screwdriver))
	AddElement(/datum/element/update_icon_updates_onmob)


/obj/item/pen/screwdriver/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, extended))
		if(var_value != extended)
			var/datum/component/transforming/transforming_comp = GetComponent(/datum/component/transforming)
			transforming_comp.on_attack_self(src)
			datum_flags |= DF_VAR_EDITED
			return
	return ..()

/obj/item/pen/screwdriver/proc/toggle_screwdriver(obj/item/source, mob/user, active)
	SIGNAL_HANDLER
	extended = active
	if(user)
		balloon_alert(user, "[extended ? "extended" : "retracted"]")
	playsound(src, 'sound/weapons/batonextend.ogg', 50, TRUE)

	if(!extended)
		tool_behaviour = initial(tool_behaviour)
		RemoveElement(/datum/element/eyestab)
	else
		tool_behaviour = TOOL_SCREWDRIVER
		AddElement(/datum/element/eyestab)

	update_appearance(UPDATE_ICON)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/pen/screwdriver/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][extended ? "_out":null]"
	inhand_icon_state = initial(inhand_icon_state) //since transforming component switches the icon.
