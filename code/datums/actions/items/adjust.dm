/datum/action/item_action/adjust
	name = "Ajuster l'objet"

/datum/action/item_action/adjust/New(Target)
	..()
	var/obj/item/item_target = target
	name = "Ajuste [item_target.name]"
