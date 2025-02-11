/*
CONTAINS:
/obj/item/ai_module/core/full/damaged
/obj/item/ai_module/toy_ai
*/

/obj/item/ai_module/core/full/damaged
		name = "module endommagé pour loi du noyau de l'ia"
		desc = "Un module pour programmer des loi à l'IA. Il a l'air légèrement âbimé."

/obj/item/ai_module/core/full/damaged/install(datum/ai_laws/law_datum, mob/user)
	laws += generate_ion_law()
	while (prob(75))
		laws += generate_ion_law()
	..()
	laws = list()

/obj/item/ai_module/toy_ai // -- Incoming //No actual reason to inherit from ion boards here, either. *sigh* ~Miauw
	name = "jouet module pour loi de l'IA"
	desc = "Un petit jouet de module de loi pour l'IA avec un vrai potentiel de téléversement de loi !" //Note: subtle tell
	icon = 'icons/obj/toys/toy.dmi'
	icon_state = "AI"
	laws = list("")

/obj/item/ai_module/toy_ai/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	if(law_datum.owner)
		to_chat(law_datum.owner, span_warning("BZZZZT"))
		if(!overflow)
			law_datum.owner.add_ion_law(laws[1])
		else
			law_datum.owner.replace_random_law(laws[1], list(LAW_ION, LAW_INHERENT, LAW_SUPPLIED), LAW_ION)
	else
		if(!overflow)
			law_datum.add_ion_law(laws[1])
		else
			law_datum.replace_random_law(laws[1], list(LAW_ION, LAW_INHERENT, LAW_SUPPLIED), LAW_ION)
	return laws[1]

/obj/item/ai_module/toy_ai/attack_self(mob/user)
	laws[1] = generate_ion_law()
	to_chat(user, span_notice("Vous appuyez sur le bouton de [src]."))
	playsound(user, 'sound/machines/click.ogg', 20, TRUE)
	src.loc.visible_message(span_warning("[icon2html(src, viewers(loc))] [laws[1]]"))
