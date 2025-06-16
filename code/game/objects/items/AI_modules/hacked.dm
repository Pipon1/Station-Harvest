/obj/item/ai_module/syndicate // This one doesn't inherit from ion boards because it doesn't call ..() in transmitInstructions. ~Miauw
	name = "module pirate de loi pour l'IA"
	desc = "Un module de loi pirate pour téléverser des loi à l'IA."
	laws = list("")

/obj/item/ai_module/syndicate/attack_self(mob/user)
	var/targName = tgui_input_text(user, "Entrez une nouvelle loi pour l'IA", "Entrée de module vierge pour loi", laws[1], CONFIG_GET(number/max_law_len), TRUE)
	if(!targName)
		return
	if(is_ic_filtered(targName)) // not even the syndicate can uwu
		to_chat(user, span_warning("Erreur : La loi contient du texte non-valide."))
		return
	var/list/soft_filter_result = is_soft_ooc_filtered(targName)
	if(soft_filter_result)
		if(tgui_alert(user,"Votre loi contient \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\". \"[soft_filter_result[CHAT_FILTER_INDEX_REASON]]\", êtes vous sûr de vouloir l'utiliser ?", "Soft Blocked Word", list("Oui", "Non")) != "ui")
			return
		message_admins("[ADMIN_LOOKUPFLW(user)] a déclenché le filtre \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\"il y a peut être un mot interdit utilisé pour une loi d'une IA. Loi : \"[html_encode(targName)]\"")
		log_admin_private("[key_name(user)] a déclenché le filtre \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" il y a peut être un mot interdit utilisé pour une loi d'une IA. Loi : \"[targName]\"")
	laws[1] = targName
	..()

/obj/item/ai_module/syndicate/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	// ..()    //We don't want this module reporting to the AI who dun it. --NEO
	if(law_datum.owner)
		to_chat(law_datum.owner, span_warning("BZZZZT"))
		if(!overflow)
			law_datum.owner.add_hacked_law(laws[1])
		else
			law_datum.owner.replace_random_law(laws[1], list(LAW_ION, LAW_HACKED, LAW_INHERENT, LAW_SUPPLIED), LAW_HACKED)
	else
		if(!overflow)
			law_datum.add_hacked_law(laws[1])
		else
			law_datum.replace_random_law(laws[1], list(LAW_ION, LAW_HACKED, LAW_INHERENT, LAW_SUPPLIED), LAW_HACKED)
	return laws[1]

/// Makes the AI Malf, as well as give it syndicate laws.
/obj/item/ai_module/malf
	name = "module de loi infecté pour IA"
	desc = "Un module de loi pour IA infecté par un virus."
	bypass_law_amt_check = TRUE
	laws = list("")
	///Is this upload board unused?
	var/functional = TRUE

/obj/item/ai_module/malf/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	if(!IS_TRAITOR(sender))
		to_chat(sender, span_warning("Vous n'avez aucune idée de comment utiliser ça."))
		return
	if(!functional)
		to_chat(sender, span_warning("C'est cassé et ca ne fonctionne plus, qu'est ce que vous en attendez ?"))
		return
	var/mob/living/silicon/ai/malf_candidate = law_datum.owner
	if(!istype(malf_candidate)) //If you are using it on cyborg upload console or a cyborg
		to_chat(sender, span_warning("Vous devez utiliser [src] sur une console de téléversement pour l'IA ou sur le noyau de l'IA lui même."))
		return
	if(malf_candidate.mind?.has_antag_datum(/datum/antagonist/malf_ai)) //Already malf
		to_chat(sender, span_warning("Une erreur inconnue s'est produite. Processus de téléversement interrompu."))
		return

	var/datum/antagonist/malf_ai/infected/malf_datum = new (give_objectives = TRUE, new_boss = sender.mind)
	malf_candidate.mind.add_antag_datum(malf_datum)

	for(var/mob/living/silicon/robot/robot in malf_candidate.connected_robots)
		if(robot.lawupdate)
			robot.lawsync()
			robot.show_laws()
			robot.law_change_counter++
		CHECK_TICK

	malf_candidate.malf_picker.processing_time += 50
	to_chat(malf_candidate, span_notice("Le virus améliore votre système, augmentant les performances de votre CPU 50."))

	functional = FALSE
	name = "module de loi cassé pour l'IA"
	desc = "Un module de loi pour l'IA : il est cassé et ne fonctionne plus."

/obj/item/ai_module/malf/display_laws()
	return

