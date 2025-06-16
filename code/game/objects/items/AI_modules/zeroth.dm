/obj/item/ai_module/zeroth/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	if(law_datum.owner)
		if(law_datum.owner.laws.zeroth)
			to_chat(law_datum.owner, "[sender.real_name] a tenté de modifier votre loi zéro.")
			to_chat(law_datum.owner, "Il serait dans votre intérêt de faire en sorte que [sender.real_name] croit ceci :")
			for(var/failedlaw in laws)
				to_chat(law_datum.owner, "[failedlaw]")
			return TRUE

	for(var/templaw in laws)
		if(law_datum.owner)
			if(!overflow)
				law_datum.owner.set_zeroth_law(templaw)
			else
				law_datum.replace_random_law(templaw, list(LAW_INHERENT, LAW_SUPPLIED, LAW_ZEROTH, LAW_ION), LAW_ZEROTH)
		else
			if(!overflow)
				law_datum.set_zeroth_law(templaw)
			else
				law_datum.replace_random_law(templaw, list(LAW_INHERENT, LAW_SUPPLIED, LAW_ZEROTH, LAW_ION), LAW_ZEROTH)

/obj/item/ai_module/zeroth/onehuman
	name = "module de loi 'UnSeulHumain' pour l'IA"
	var/targetName = ""
	laws = list("Seul le SUJET est humain.")

/obj/item/ai_module/zeroth/onehuman/attack_self(mob/user)
	var/targName = tgui_input_text(user, "Entrez le SUJET qui est le seul humain", "UnSeulHumain", user.real_name, MAX_NAME_LEN)
	if(!targName)
		return
	targetName = targName
	laws[1] = "Seul [targetName] est humain."
	..()

/obj/item/ai_module/zeroth/onehuman/install(datum/ai_laws/law_datum, mob/user)
	if(!targetName)
		to_chat(user, span_alert("Pas de nom détecté dans le module, merci d'en entrer un."))
		return FALSE
	..()

/obj/item/ai_module/zeroth/onehuman/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	if(..())
		return "[targetName], mais la loi 0 de l'IA ne peut pas être remplacée."
	return targetName
