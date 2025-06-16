/datum/round_event_control/wizard/greentext //Gotta have it!
	name = "Textevert"
	weight = 4
	typepath = /datum/round_event/wizard/greentext
	max_occurrences = 1
	earliest_start = 0 MINUTES
	description = "Le Texte Vert apparait sur la station, charmant tout le monde pour qu'ils essayent de l'attraper."
	min_wizard_trigger_potency = 5
	max_wizard_trigger_potency = 7

/datum/round_event/wizard/greentext/start()

	var/list/holder_canadates = GLOB.player_list.Copy()
	for(var/mob/M in holder_canadates)
		if(!ishuman(M))
			holder_canadates -= M
	if(!holder_canadates) //Very unlikely, but just in case
		return FALSE

	var/mob/living/carbon/human/H = pick(holder_canadates)
	new /obj/item/greentext(H.loc)
	to_chat(H, "<font color='green'>Le Textevert mythique apparait à vos pieds ! Prenez-le si vous osez...</font>")


/obj/item/greentext
	name = "Textevert"
	desc = "Personne ne sait ce que ce volume massif fait, mais il est vraiment <i><font color='green'>attirant</font></i>..."
	w_class = WEIGHT_CLASS_BULKY
	icon = 'icons/obj/wizard.dmi'
	icon_state = "greentext"
	resistance_flags = FIRE_PROOF | ACID_PROOF | INDESTRUCTIBLE
	///The last person to touch the greentext, used for failures.
	var/mob/living/last_holder
	///The current holder of the greentext.
	var/mob/living/new_holder
	///Every person who has touched the greentext, having their colors changed by it.
	var/list/color_altered_mobs = list()
	///The callback at the end of a round to check if the greentext has been completed.
	var/datum/callback/roundend_callback
	///Boolean on whether to announce the greentext's destruction to all mobs.
	var/quiet = FALSE

/obj/item/greentext/quiet
	quiet = TRUE

/obj/item/greentext/Initialize(mapload)
	. = ..()
	SSpoints_of_interest.make_point_of_interest(src)
	roundend_callback = CALLBACK(src, PROC_REF(check_winner))
	SSticker.OnRoundend(roundend_callback)

/obj/item/greentext/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	to_chat(user, span_green("Tant que vous pouvez quitter cet endroit avec le Textevert entre vos mains, vous serez heureux..."))
	var/list/other_objectives = user.mind.get_all_objectives()
	if(user.mind && other_objectives.len > 0)
		to_chat(user, span_warning("... Du moins tant que vous remplissez vos autres objectifs également !"))
	new_holder = user
	if(!last_holder)
		last_holder = user
	if(!(user in color_altered_mobs))
		color_altered_mobs |= user
	user.add_atom_colour("#00FF00", ADMIN_COLOUR_PRIORITY)
	START_PROCESSING(SSobj, src)

/obj/item/greentext/dropped(mob/user, silent = FALSE)
	if(user in color_altered_mobs)
		to_chat(user, span_warning("Une soudaine vague d'échec déferle sur vous..."))
		user.add_atom_colour("#FF0000", ADMIN_COLOUR_PRIORITY) //ya blew it
	STOP_PROCESSING(SSobj, src)
	last_holder = null
	new_holder = null
	return ..()

/obj/item/greentext/process()
	if(last_holder && last_holder != new_holder) //Somehow it was swiped without ever getting dropped
		to_chat(last_holder, span_warning("Une soudaine vague d'échec déferle sur vous..."))
		last_holder.add_atom_colour("#FF0000", ADMIN_COLOUR_PRIORITY)
		last_holder = new_holder //long live the king

/obj/item/greentext/Destroy(force)
	LAZYREMOVE(SSticker.round_end_events, roundend_callback)
	QDEL_NULL(roundend_callback) //This ought to free the callback datum, and prevent us from harddeling
	for(var/mob/all_player_mobs as anything in GLOB.player_list)
		var/message = "<span class='warning'>Une sombre tentation a quitté ce monde"
		if(all_player_mobs in color_altered_mobs)
			message += " et vous pouvez enfin vous pardonner."
			if(all_player_mobs.color == "#FF0000" || all_player_mobs.color == "#00FF00")
				all_player_mobs.remove_atom_colour(ADMIN_COLOUR_PRIORITY)
		message += "...</span>"
		if(!quiet)
			to_chat(all_player_mobs, message)
	return ..()

/obj/item/greentext/proc/check_winner()
	if(!new_holder)
		return
	if(!is_centcom_level(new_holder.z)) //you're winner!
		return

	to_chat(new_holder, "<font color='green'>Enfin la victoire vous est assurée !</font>")
	new_holder.mind.add_antag_datum(/datum/antagonist/greentext)
	new_holder.log_message("a gagné avec le Textevert !!!", LOG_ATTACK, color = "green")
	color_altered_mobs -= new_holder
	resistance_flags |= ON_FIRE
	qdel(src)
