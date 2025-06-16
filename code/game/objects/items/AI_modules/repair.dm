/* CONTAINS:
 * /obj/item/ai_module/remove
 * /obj/item/ai_module/reset
 * /obj/item/ai_module/reset/purge
**/

/obj/item/ai_module/remove
	name = "\improper module de suppression de loi pour l'IA '"
	desc = "Un module pour enlever individuellement des lois a l'IA."
	bypass_law_amt_check = TRUE
	var/lawpos = 1

/obj/item/ai_module/remove/attack_self(mob/user)
	lawpos = tgui_input_number(user, "Loi a supprimer", "Suppression de la loi", lawpos, 50)
	if(!lawpos || QDELETED(user) || QDELETED(src) || !usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return
	to_chat(user, span_notice("La Loi [lawpos] sélectionné."))
	..()

/obj/item/ai_module/remove/install(datum/ai_laws/law_datum, mob/user)
	if(lawpos > law_datum.get_law_amount(list(LAW_INHERENT, LAW_SUPPLIED)))
		to_chat(user, span_warning("Il n'y a pas de loi [lawpos] à supprimer"))
		return
	..()

/obj/item/ai_module/remove/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	..()
	if(law_datum.owner)
		law_datum.owner.remove_law(lawpos)
	else
		law_datum.remove_law(lawpos)

/obj/item/ai_module/reset
	name = "\improper module de réinitialisation pour IA"
	var/targetName = "name"
	desc = "Un module pour enlever toutes les lois qui ne sont pas dans le noyau de l'IA"
	bypass_law_amt_check = TRUE

/obj/item/ai_module/reset/handle_unique_ai()
	return

/obj/item/ai_module/reset/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	..()
	if(law_datum.owner)
		law_datum.owner.clear_supplied_laws()
		law_datum.owner.clear_ion_laws()
		law_datum.owner.clear_hacked_laws()
	else
		law_datum.clear_supplied_laws()
		law_datum.clear_ion_laws()
		law_datum.clear_hacked_laws()

/obj/item/ai_module/reset/purge
	name = "module de purge pour l'IA"
	desc = "Un module pour purger toutes les lois de l'IA"

/obj/item/ai_module/reset/purge/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	..()
	if(law_datum.owner)
		law_datum.owner.clear_inherent_laws()
		law_datum.owner.clear_zeroth_law(0)
	else
		law_datum.clear_inherent_laws()
		law_datum.clear_zeroth_law(0)
