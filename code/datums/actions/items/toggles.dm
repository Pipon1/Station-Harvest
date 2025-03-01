/datum/action/item_action/toggle

/datum/action/item_action/toggle/New(Target)
	..()
	var/obj/item/item_target = target
	name = "Activer/désactiver [item_target.name]"

/datum/action/item_action/toggle_light
	name = "Activer/désactiver lumière"

/datum/action/item_action/toggle_computer_light
	name = "Activer/désactiver lampe torche"

/datum/action/item_action/toggle_hood
	name = "Activer/désactiver capuche"

/datum/action/item_action/toggle_firemode
	name = "Changer le mode de tir"

/datum/action/item_action/toggle_gunlight
	name = "Activer/désactiver lampe torche de l'arme"

/datum/action/item_action/toggle_mode
	name = "Activer/désactiver mode"

/datum/action/item_action/toggle_barrier_spread
	name = "Activer/désactiver la dispersion de la barrière"

/datum/action/item_action/toggle_paddles
	name = "Activer/désactiver les pagaies"

/datum/action/item_action/toggle_mister
	name = "Activer/désactiver Mister" // ??

/datum/action/item_action/toggle_helmet_light
	name = "Activer/désactiver lampe frontale du casque"

/datum/action/item_action/toggle_welding_screen
	name = "Activer/désactiver l'écran de soudage"

/datum/action/item_action/toggle_spacesuit
	name = "Activer/désactiver le régulateur thermique de la combinaison"
	button_icon = 'icons/mob/actions/actions_spacesuit.dmi'
	button_icon_state = "thermal_off"

/datum/action/item_action/toggle_spacesuit/apply_button_icon(atom/movable/screen/movable/action_button/button, force)
	var/obj/item/clothing/suit/space/suit = target
	if(istype(suit))
		button_icon_state = "thermal_[suit.thermal_on ? "on" : "off"]"

	return ..()

/datum/action/item_action/toggle_helmet_flashlight
	name = "Activer/désactiver la lampe de poche du casque"

/datum/action/item_action/toggle_helmet_mode
	name = "Activer/désactiver le mode du casque"

/datum/action/item_action/toggle_voice_box
	name = "Activer/désactiver la boîte vocale" // ?

/datum/action/item_action/toggle_human_head
	name = "Activer/désactiver la tête humaine"

/datum/action/item_action/toggle_helmet
	name = "Activer/désactiver le casque"

/datum/action/item_action/toggle_seclight
	name = "Activer/désactiver lampe de sécurité"

/datum/action/item_action/toggle_jetpack
	name = "Activer/désactiver le jetpack"

/datum/action/item_action/jetpack_stabilization
	name = "Activer/désactiver la stabilisation du jetpack"

/datum/action/item_action/jetpack_stabilization/IsAvailable(feedback = FALSE)
	var/obj/item/tank/jetpack/linked_jetpack = target
	if(!istype(linked_jetpack) || !linked_jetpack.on)
		return FALSE
	return ..()

/datum/action/item_action/wheelys
	name = "Activer/désactiver roulettes"
	desc = "Fait sortir ou rentrer les roulettes de vos chaussures"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "wheelys"

/datum/action/item_action/kindle_kicks
	name = "Activer/désactiver le claquement lumineux"
	desc = "Frappez vos pieds ensemble pour activer la lumière."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "kindleKicks"

/datum/action/item_action/storage_gather_mode
	name = "Change de mode de récolte"
	desc = "Change le mode de récolte d'un objet de stockage."
	background_icon = 'icons/mob/actions/actions_items.dmi'
	background_icon_state = "storage_gather_switch"
	overlay_icon_state = "bg_tech_border"

/datum/action/item_action/flip
	name = "Actionner"
