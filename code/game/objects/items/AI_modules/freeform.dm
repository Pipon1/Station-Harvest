/* CONTAINS:
 * /obj/item/ai_module/core/freeformcore
 * /obj/item/ai_module/supplied/freeform
**/

/obj/item/ai_module/core/freeformcore
	name = "module vierge pour loi du noyau de l'IA"
	laws = list("")

/obj/item/ai_module/core/freeformcore/attack_self(mob/user)
	var/targName = tgui_input_text(user, "Entrez une nouvelle loi de noyau pour l'IA.", "Entrée du module vierge pour loi du noyau de l'IA", laws[1], CONFIG_GET(number/max_law_len), TRUE)
	if(!targName)
		return
	if(is_ic_filtered(targName))
		to_chat(user, span_warning("ERREUR: La loi contient du texte non-valide."))
		return
	var/list/soft_filter_result = is_soft_ooc_filtered(targName)
	if(soft_filter_result)
		if(tgui_alert(user,"Votre loi contient \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\". \"[soft_filter_result[CHAT_FILTER_INDEX_REASON]]\", êtes vous sûr de vouloir l'utiliser ?", "Soft Blocked Word", list("Oui", "Non")) != "Oui")
			return
		message_admins("[ADMIN_LOOKUPFLW(user)] a déclenché le filtre \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\", il y a peut être un terme non autorisé utilisé dans la loi pour l'IA. Loi: \"[html_encode(targName)]\"")
		log_admin_private("[key_name(user)] a déclenché le filtre \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\", il y a peut être un terme non autorisé utilisé dans la loi pour l'IA. Loi: \"[targName]\"")
	laws[1] = targName
	..()

/obj/item/ai_module/core/freeformcore/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	..()
	return laws[1]

/obj/item/ai_module/supplied/freeform
	name = "module vierge pour loi du noyau de l'IA"
	lawpos = 15
	laws = list("")

/obj/item/ai_module/supplied/freeform/attack_self(mob/user)
	var/newpos = tgui_input_number(user, "Merci d'entrer la priorité pour votre nouvelle loi. Can only write to law sectors 15 and above.", "Priorité pour la loi", lawpos, 50, 15)
	if(!newpos || QDELETED(user) || QDELETED(src) || !usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return
	lawpos = newpos
	var/targName = tgui_input_text(user, "Entrez une nouvelle loi pour l'IA.", "Entrée du module vierge pour loi de l'IA", laws[1], CONFIG_GET(number/max_law_len), TRUE)
	if(!targName)
		return
	if(is_ic_filtered(targName))
		to_chat(user, span_warning("ERREUR: La loi contient du texte non-valide.")) // AI LAW 2 SAY U W U WITHOUT THE SPACES
		return
	var/list/soft_filter_result = is_soft_ooc_filtered(targName)
	if(soft_filter_result)
		if(tgui_alert(user,"Votre loi contient \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\". \"[soft_filter_result[CHAT_FILTER_INDEX_REASON]]\", êtes vous sûr de vouloir l'utiliser ?", "Soft Blocked Word", list("Oui", "Non")) != "Oui")
			return
		message_admins("[ADMIN_LOOKUPFLW(user)] a déclenché le filtre \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" , il y a peut être un terme non autorisé utilisé dans la loi pour l'IA. Loi: \"[html_encode(targName)]\"")
		log_admin_private("[key_name(user)] a déclenché le filtre \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" , il y a peut être un terme non autorisé utilisé dans la loi pour l'IA. Loi: \"[targName]\"")
	laws[1] = targName
	..()

/obj/item/ai_module/supplied/freeform/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	if(!overflow)
		..()
	else if(law_datum.owner)
		law_datum.owner.replace_random_law(laws[1], list(LAW_SUPPLIED), LAW_SUPPLIED)
	else
		law_datum.replace_random_law(laws[1], list(LAW_SUPPLIED), LAW_SUPPLIED)
	return laws[1]

/obj/item/ai_module/supplied/freeform/install(datum/ai_laws/law_datum, mob/user)
	if(laws[1] == "")
		to_chat(user, span_alert("Aucune loi détectée sur le module, merci d'en crée une."))
		return 0
	..()
