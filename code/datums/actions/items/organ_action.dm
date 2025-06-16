/datum/action/item_action/organ_action
	name = "Action d'organe"
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/item_action/organ_action/IsAvailable(feedback = FALSE)
	var/obj/item/organ/attached_organ = target
	if(!attached_organ.owner)
		return FALSE
	return ..()

/datum/action/item_action/organ_action/toggle
	name = "Activer/désasctiver l'organe"

/datum/action/item_action/organ_action/toggle/New(Target)
	..()
	var/obj/item/organ/organ_target = target
	name = "Activer/désasctiver [organ_target.name]"

/datum/action/item_action/organ_action/use
	name = "Utiliser l'organe"

/datum/action/item_action/organ_action/use/New(Target)
	..()
	var/obj/item/organ/organ_target = target
	name = "Utiliser [organ_target.name]"
