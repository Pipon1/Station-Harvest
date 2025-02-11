/obj/item/retractor
	name = "rétracteur"
	desc = "Rétracte des trucs."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "retractor"
	inhand_icon_state = "retractor"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = 6000, /datum/material/glass = 3000)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	tool_behaviour = TOOL_RETRACTOR
	toolspeed = 1

/obj/item/retractor/augment
	desc = "Micro-manipulateur méchanique pour rétracter des trucs."
	toolspeed = 0.5


/obj/item/hemostat
	name = "pince hémostatique"
	desc = "Vous pensez avoir déja vu cette objet."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "hemostat"
	inhand_icon_state = "hemostat"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = 5000, /datum/material/glass = 2500)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("attacks", "pinches")
	attack_verb_simple = list("attack", "pinch")
	tool_behaviour = TOOL_HEMOSTAT
	toolspeed = 1

/obj/item/hemostat/augment
	desc = "Des petits servo-moteurs permettent à une pince de stoper les saignements."
	toolspeed = 0.5


/obj/item/cautery
	name = "torche de cautérisation"
	desc = "Cet outil arrête les saignements."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "cautery"
	inhand_icon_state = "cautery"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = 2500, /datum/material/glass = 750)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("burns")
	attack_verb_simple = list("burn")
	tool_behaviour = TOOL_CAUTERY
	toolspeed = 1

/obj/item/cautery/ignition_effect(atom/ignitable_atom, mob/user)
	. = span_notice("[user] pour le bout de [src] sur lae [ignitable_atom], l'allumant soudainement.")

/obj/item/cautery/augment
	desc = "Un élément brulant pour cautériser les blessures."
	toolspeed = 0.5

/obj/item/cautery/advanced
	name = "outil de saisie"
	desc = "Cet outil projette un puissant laser. A utiliser uniquement à but médical."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "e_cautery"
	inhand_icon_state = "e_cautery"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = 4000, /datum/material/glass = 2000, /datum/material/plasma = 2000, /datum/material/uranium = 3000, /datum/material/titanium = 3000)
	hitsound = 'sound/items/welder.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.7
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_color = COLOR_SOFT_RED

/obj/item/cautery/advanced/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between drill and cautery and gives feedback to the user.
 */
/obj/item/cautery/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = (active ? TOOL_DRILL : TOOL_CAUTERY)
	balloon_alert(user, "Les lentilles sont en mode [active ? "destruction" : "reconstruction"]")
	playsound(user ? user : src, 'sound/weapons/tap.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/cautery/advanced/examine()
	. = ..()
	. += span_notice("L'outil est en mode [tool_behaviour == TOOL_CAUTERY ? "reconstruction" : "destruction"].")

/obj/item/surgicaldrill
	name = "perceuse médicale"
	desc = "Vous pouvez percer avec cet objet. Vous creusez ?"
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "drill"
	inhand_icon_state = "drill"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	hitsound = 'sound/weapons/circsawhit.ogg'
	custom_materials = list(/datum/material/iron = 10000, /datum/material/glass = 6000)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	force = 15
	demolition_mod = 0.5
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("Perce")
	attack_verb_simple = list("Perce")
	tool_behaviour = TOOL_DRILL
	toolspeed = 1
	sharpness = SHARP_POINTY
	wound_bonus = 10
	bare_wound_bonus = 10

/obj/item/surgicaldrill/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/eyestab)

/obj/item/surgicaldrill/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] enfonce [src] dans le torse de [user.p_their()] ! Il semble que [user.p_theyre()] essaie de se suicider."))
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon, gib), null, null, TRUE, TRUE), 25)
	user.SpinAnimation(3, 10)
	playsound(user, 'sound/machines/juicer.ogg', 20, TRUE)
	return MANUAL_SUICIDE

/obj/item/surgicaldrill/augment
	desc = "En pratique une petite perceuse éléctrique contenue dans votre bras. Peut être capable de percer le paradis."
	hitsound = 'sound/weapons/circsawhit.ogg'
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 0.5

/obj/item/scalpel
	name = "scalpel"
	desc = "Coupe, coupe et une fois de plus, coupe."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "scalpel"
	inhand_icon_state = "scalpel"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	force = 10
	demolition_mod = 0.25
	w_class = WEIGHT_CLASS_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/iron = 4000, /datum/material/glass = 1000)
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts") //A trad après, trop de synonyme de mort
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_SCALPEL
	toolspeed = 1
	wound_bonus = 10
	bare_wound_bonus = 15

/obj/item/scalpel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 8 SECONDS * toolspeed, \
	effectiveness = 100, \
	bonus_modifier = 0, \
	)
	AddElement(/datum/element/eyestab)

/obj/item/scalpel/augment
	desc = "Une lame extrêmement tranchante attachée directement à vos os pour plus de précision."
	toolspeed = 0.5

/obj/item/scalpel/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] se tranche [user.p_their()] [pick("poignets", "gorge", "estomac")] avec [src] ! Il semble que [user.p_theyre()] essaie de se suicider."))
	return BRUTELOSS

/obj/item/circular_saw
	name = "scie circulaire"
	desc = "Pour des découpages complexes."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "saw"
	inhand_icon_state = "saw"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	hitsound = 'sound/weapons/circsawhit.ogg'
	mob_throw_hit_sound = 'sound/weapons/pierce.ogg'
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	force = 15
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 9
	throw_speed = 2
	throw_range = 5
	custom_materials = list(/datum/material/iron = 10000, /datum/material/glass = 6000)
	attack_verb_continuous = list("attacks", "slashes", "saws", "cuts") //A trad après, trop de synonyme de mort
	attack_verb_simple = list("attack", "slash", "saw", "cut")
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_SAW
	toolspeed = 1
	wound_bonus = 15
	bare_wound_bonus = 10

/obj/item/circular_saw/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 4 SECONDS * toolspeed, \
	effectiveness = 100, \
	bonus_modifier = 5, \
	butcher_sound = 'sound/weapons/circsawhit.ogg', \
	)
	//saws are very accurate and fast at butchering

/obj/item/circular_saw/augment
	desc = "Une petite scie très rapide. A utiliser pour protéger des lapins."
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 0.5


/obj/item/surgical_drapes
	name = "draps chiruchicaux"
	desc = "Draps chiruchicaux de marque Nanotrasen."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "surgical_drapes"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	inhand_icon_state = "drapes"
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("slaps")
	attack_verb_simple = list("slap")

/obj/item/surgical_drapes/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/surgery_initiator)

/obj/item/surgical_processor //allows medical cyborgs to scan and initiate advanced surgeries
	name = "processeur chirugicale"
	desc = "Un outil pour scanner et commencer des chirugies avancées."
	icon = 'icons/obj/device.dmi'
	icon_state = "spectrometer"
	item_flags = NOBLUDGEON
	var/list/loaded_surgeries = list()

/obj/item/surgical_processor/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/surgery_initiator)

/obj/item/surgical_processor/examine(mob/user)
	. = ..()
	. += span_notice("Equipez le processeur dans un de vos modules pour accéder au chirugies avancées.")
	. += span_boldnotice("Chirugie avancées disponible : ")
	//list of downloaded surgeries' names
	var/list/surgeries_names = list()
	for(var/datum/surgery/downloaded_surgery as anything in loaded_surgeries)
		if(initial(downloaded_surgery.replaced_by) in loaded_surgeries) //if a surgery has a better version replacing it, we don't include it in the list
			continue
		surgeries_names += "[initial(downloaded_surgery.name)]"
	. += span_notice("[english_list(surgeries_names)]")

/obj/item/surgical_processor/equipped(mob/user, slot, initial)
	. = ..()
	if(!(slot & ITEM_SLOT_HANDS))
		UnregisterSignal(user, COMSIG_SURGERY_STARTING)
		return
	RegisterSignal(user, COMSIG_SURGERY_STARTING, PROC_REF(check_surgery))

/obj/item/surgical_processor/dropped(mob/user, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_SURGERY_STARTING)

/obj/item/surgical_processor/cyborg_unequip(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_SURGERY_STARTING)

/obj/item/surgical_processor/afterattack(atom/design_holder, mob/user, proximity)
	if(!proximity)
		return ..()
	if(!istype(design_holder, /obj/item/disk/surgery) && !istype(design_holder, /obj/machinery/computer/operating))
		return ..()
	balloon_alert(user, "Copiage des designs...")
	playsound(src, 'sound/machines/terminal_processing.ogg', 25, TRUE)
	if(do_after(user, 1 SECONDS, target = design_holder))
		if(istype(design_holder, /obj/item/disk/surgery))
			var/obj/item/disk/surgery/surgery_disk = design_holder
			loaded_surgeries |= surgery_disk.surgeries
		else
			var/obj/machinery/computer/operating/surgery_computer = design_holder
			loaded_surgeries |= surgery_computer.advanced_surgeries
		playsound(src, 'sound/machines/terminal_success.ogg', 25, TRUE)
	return TRUE

/obj/item/surgical_processor/proc/check_surgery(mob/user, datum/surgery/surgery, mob/patient)
	SIGNAL_HANDLER

	if(surgery.replaced_by in loaded_surgeries)
		return COMPONENT_CANCEL_SURGERY
	if(surgery.type in loaded_surgeries)
		return COMPONENT_FORCE_SURGERY

/obj/item/scalpel/advanced
	name = "scalpel laser"
	desc = "Un scalpel avancé qui utilise une technologie de laser avancé pour trancher."
	icon_state = "e_scalpel"
	inhand_icon_state = "e_scalpel"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = 6000, /datum/material/glass = 1500, /datum/material/silver = 2000, /datum/material/gold = 1500, /datum/material/diamond = 200, /datum/material/titanium = 4000)
	hitsound = 'sound/weapons/blade1.ogg'
	force = 16
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.7
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_color = LIGHT_COLOR_BLUE
	sharpness = SHARP_EDGED

/obj/item/scalpel/advanced/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = force + 1, \
		throwforce_on = throwforce, \
		throw_speed_on = throw_speed, \
		sharpness_on = sharpness, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between saw and scalpel and updates the light / gives feedback to the user.
 */
/obj/item/scalpel/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(active)
		tool_behaviour = TOOL_SAW
		set_light_range(2)
	else
		tool_behaviour = TOOL_SCALPEL
		set_light_range(1)

	balloon_alert(user, "[active ? "activation du mode" : "désactivation du mode"] découpage d'os")
	playsound(user ? user : src, 'sound/machines/click.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/scalpel/advanced/examine()
	. = ..()
	. += span_notice("Le mode : [tool_behaviour == TOOL_SCALPEL ? "scalpel" : "scie"] est actif.")

/obj/item/retractor/advanced
	name = "pinces méchanique"
	desc = "Un tas de tige et de rouage."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	custom_materials = list(/datum/material/iron = 12000, /datum/material/glass = 4000, /datum/material/silver = 4000, /datum/material/titanium = 5000)
	icon_state = "adv_retractor"
	inhand_icon_state = "adv_retractor"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.7

/obj/item/retractor/advanced/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between retractor and hemostat and gives feedback to the user.
 */
/obj/item/retractor/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = (active ? TOOL_HEMOSTAT : TOOL_RETRACTOR)
	balloon_alert(user, "Les rouages sont en positon : [active ? "pince" : "retracteur"].")
	playsound(user ? user : src, 'sound/items/change_drill.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/retractor/advanced/examine()
	. = ..()
	. += span_notice("ça ressemble à [tool_behaviour == TOOL_RETRACTOR ? " un rétracteur" : "une pince hémostatique"].")

/obj/item/shears
	name = "cisaille à amputation"
	desc = "Un type de cisaille médical utilisée pour amputer des membres. Garder le patient immobile pendant l'amputation est impératif."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "shears"
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	toolspeed = 1
	force = 12
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 6
	throw_speed = 2
	throw_range = 5
	custom_materials = list(/datum/material/iron=8000, /datum/material/titanium=6000)
	attack_verb_continuous = list("shears", "snips")
	attack_verb_simple = list("shear", "snip")
	sharpness = SHARP_EDGED
	custom_premium_price = PAYCHECK_CREW * 14

/obj/item/shears/attack(mob/living/amputee, mob/living/user)
	if(!iscarbon(amputee) || user.combat_mode)
		return ..()

	if(user.zone_selected == BODY_ZONE_CHEST)
		return ..()

	var/mob/living/carbon/patient = amputee

	if(HAS_TRAIT(patient, TRAIT_NODISMEMBER))
		to_chat(user, span_warning("Les membres du patients semblent trop solide pour être amputés."))
		return

	var/candidate_name
	var/obj/item/organ/external/tail_snip_candidate
	var/obj/item/bodypart/limb_snip_candidate

	if(user.zone_selected == BODY_ZONE_PRECISE_GROIN)
		tail_snip_candidate = patient.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
		if(!tail_snip_candidate)
			to_chat(user, span_warning("[patient] n'a pas de queue."))
			return
		candidate_name = tail_snip_candidate.name

	else
		limb_snip_candidate = patient.get_bodypart(check_zone(user.zone_selected))
		if(!limb_snip_candidate)
			to_chat(user, span_warning("[patient] n'a deja plus ce membre... Que voulez vous de plus ?"))
			return
		candidate_name = limb_snip_candidate.name

	var/amputation_speed_mod = 1

	patient.visible_message(span_danger("[user] commence à sécuriser la [src] autours du [candidate_name] de [patient.]"), span_userdanger("[user] commence à sécuriser [src ] autour de la partie du corps nommée \"[candidate_name]\""))
	playsound(get_turf(patient), 'sound/items/ratchet.ogg', 20, TRUE)
	if(patient.stat >= UNCONSCIOUS || HAS_TRAIT(patient, TRAIT_INCAPACITATED)) //if you're incapacitated (due to paralysis, a stun, being in staminacrit, etc.), critted, unconscious, or dead, it's much easier to properly line up a snip
		amputation_speed_mod *= 0.5
	if(patient.stat != DEAD && patient.has_status_effect(/datum/status_effect/jitter)) //jittering will make it harder to secure the shears, even if you can't otherwise move
		amputation_speed_mod *= 1.5 //15*0.5*1.5=11.25, so staminacritting someone who's jittering (from, say, a stun baton) won't give you enough time to snip their head off, but staminacritting someone who isn't jittering will

	if(do_after(user,  toolspeed * 15 SECONDS * amputation_speed_mod, target = patient))
		playsound(get_turf(patient), 'sound/weapons/bladeslice.ogg', 250, TRUE)
		if(user.zone_selected == BODY_ZONE_PRECISE_GROIN) //OwO
			tail_snip_candidate.Remove(patient)
			tail_snip_candidate.forceMove(get_turf(patient))
		else
			limb_snip_candidate.dismember()
		user.visible_message(span_danger("[src] se ferme violement, amputant le membre de [patient]."), span_notice("Vous amputez le membre de [patient] avec [src]."))

/obj/item/shears/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] est entrain de pincer [user] avec la [src] ! Il semble que [user] essaie de se suicider !"))
	var/timer = 1 SECONDS
	for(var/obj/item/bodypart/thing in user.bodyparts)
		if(thing.body_part == CHEST)
			continue
		addtimer(CALLBACK(thing, TYPE_PROC_REF(/obj/item/bodypart/, dismember)), timer)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), user, 'sound/weapons/bladeslice.ogg', 70), timer)
		timer += 1 SECONDS
	sleep(timer)
	return BRUTELOSS

/obj/item/bonesetter
	name = "fixeur d'os"
	desc = "Pour fixer les choses là où elles doivent être."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "bonesetter"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron = 5000,  /datum/material/glass = 2500, /datum/material/silver = 2500)
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("corrects", "properly sets")
	attack_verb_simple = list("correct", "properly set")
	tool_behaviour = TOOL_BONESET
	toolspeed = 1

/obj/item/blood_filter
	name = "filtreur"
	desc = "Filtre le sang."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "bloodfilter"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	custom_materials = list(/datum/material/iron=2000, /datum/material/glass=1500, /datum/material/silver=500)
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("pumps", "siphons")
	attack_verb_simple = list("pump", "siphon")
	tool_behaviour = TOOL_BLOODFILTER
	toolspeed = 1
	/// Assoc list of chem ids to names, used for deciding which chems to filter when used for surgery
	var/list/whitelist = list()

/obj/item/blood_filter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BloodFilter", name)
		ui.open()

/obj/item/blood_filter/ui_data(mob/user)
	var/list/data = list()
	var/list/chem_names = list()
	for(var/key in whitelist)
		chem_names += whitelist[key]
	data["whitelist"] = chem_names
	return data

/obj/item/blood_filter/ui_act(action, params)
	. = ..()
	if(.)
		return
	. = TRUE
	switch(action)
		if("add")
			var/selected_reagent = tgui_input_list(usr, "Séléctionnez un produit chimique à filtrer", "autoriser des produits chimiques", GLOB.chemical_name_list)
			if(!selected_reagent)
				return TRUE

			var/chem_id = get_chem_id(selected_reagent)
			if(!chem_id)
				return TRUE

			if(!(chem_id in whitelist))
				whitelist[chem_id] = selected_reagent



		if("remove")
			var/chem_name = params["reagent"]
			var/chem_id = get_chem_id(chem_name)
			whitelist -= chem_id
