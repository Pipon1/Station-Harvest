
/datum/action/item_action/cult_dagger
	name = "Dessoiner une rune de sang"
	desc = "Utilise la dague rituelle pour créer une puissante rune de sang."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "draw"
	buttontooltipstyle = "cult"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	default_button_position = "6:157,4:-2"

/datum/action/item_action/cult_dagger/Grant(mob/grant_to)
	if(!IS_CULTIST(grant_to))
		return

	return ..()

/datum/action/item_action/cult_dagger/Trigger(trigger_flags)
	for(var/obj/item/held_item as anything in owner.held_items) // In case we were already holding a dagger
		if(istype(held_item, /obj/item/melee/cultblade/dagger))
			held_item.attack_self(owner)
			return
	var/obj/item/target_item = target
	if(owner.can_equip(target_item, ITEM_SLOT_HANDS))
		owner.temporarilyRemoveItemFromInventory(target_item)
		owner.put_in_hands(target_item)
		target_item.attack_self(owner)
		return

	if(!isliving(owner))
		to_chat(owner, span_warning("Vous n'avez pas assez de force vitale pour cette action."))
		return

	var/mob/living/living_owner = owner
	if (living_owner.usable_hands <= 0)
		to_chat(living_owner, span_warning("Vous n'avez pas de main utilisables!"))
	else
		to_chat(living_owner, span_warning("Vos mains sont pleines!"))
