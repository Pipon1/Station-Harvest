/datum/action/item_action/berserk_mode
	name = "Rage"
	desc = "Augmente votre vitesse de déplacement et de mêlée tout en augmentant votre armure de mêlée pour une courte durée."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "berserk_mode"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

/datum/action/item_action/berserk_mode/Trigger(trigger_flags)
	if(istype(target, /obj/item/clothing/head/hooded/berserker))
		var/obj/item/clothing/head/hooded/berserker/berzerk = target
		if(berzerk.berserk_active)
			to_chat(owner, span_warning("Vous êtes déjà en rage!"))
			return
		if(berzerk.berserk_charge < 100)
			to_chat(owner, span_warning("Vous n'avez pas une charge pleine."))
			return
		berzerk.berserk_mode(owner)
		return
	return ..()
