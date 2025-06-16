/obj/item/clothing/glasses/hud
	name = "ATH"
	desc = "Un affichage tête haute qui fournit des informations importantes en (presque) temps réel."
	flags_1 = null //doesn't protect eyes because it's a monocle, duh
	var/hud_type = null
	///Used for topic calls. Just because you have a HUD display doesn't mean you should be able to interact with stuff.
	var/hud_trait = null


/obj/item/clothing/glasses/hud/equipped(mob/living/carbon/human/user, slot)
	..()
	if(!(slot & ITEM_SLOT_EYES))
		return
	if(hud_type)
		var/datum/atom_hud/our_hud = GLOB.huds[hud_type]
		our_hud.show_to(user)
	if(hud_trait)
		ADD_TRAIT(user, hud_trait, GLASSES_TRAIT)

/obj/item/clothing/glasses/hud/dropped(mob/living/carbon/human/user)
	..()
	if(!istype(user) || user.glasses != src)
		return
	if(hud_type)
		var/datum/atom_hud/our_hud = GLOB.huds[hud_type]
		our_hud.hide_from(user)
	if(hud_trait)
		REMOVE_TRAIT(user, hud_trait, GLASSES_TRAIT)

/obj/item/clothing/glasses/hud/emp_act(severity)
	. = ..()
	if(obj_flags & EMAGGED || . & EMP_PROTECT_SELF)
		return
	obj_flags |= EMAGGED
	desc = "[desc] l'écran affiche beaucoup de parasite."

/obj/item/clothing/glasses/hud/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, span_warning("PZZTTPFFFT"))
	desc = "[desc] l'écran affiche beaucoup de parasite."

/obj/item/clothing/glasses/hud/suicide_act(mob/living/user)
	if(user.is_blind())
		return SHAME
	var/mob/living/living_user = user
	user.visible_message(span_suicide("[user] regarde au travers [src] et semble noyer dans les infos ! Il semble que [user.p_theyre()] essaye de se suicider !"))
	if(living_user.get_organ_loss(ORGAN_SLOT_BRAIN) >= BRAIN_DAMAGE_SEVERE)
		var/mob/thing = pick((/mob in view()) - user)
		if(thing)
			user.say("PERSONNE VALIDE EST VOULU, ARRÊTER LE !!!!")
			user.pointed(thing)
		else
			user.say("POURQUOI IL Y'A UNE BARRE SUR MA TÊTE ????")
	return OXYLOSS

/obj/item/clothing/glasses/hud/health
	name = "scanneur de santé ATH"
	desc = "Un affichage tête haute qui scan les humanoïdes dans le champs de vision et donne des données précises sur leur santé."
	icon_state = "healthhud"
	hud_type = DATA_HUD_MEDICAL_ADVANCED
	hud_trait = TRAIT_MEDICAL_HUD
	glass_colour_type = /datum/client_colour/glass_colour/lightblue

/obj/item/clothing/glasses/hud/health/night
	name = "scanneur de santé à vision nocturne ATH"
	desc = "Un affichage tête haute médical avancé qui permet aux médecins de trouver des patients dans l'obscurité complète."
	icon_state = "healthhudnight"
	inhand_icon_state = "glasses"
	flash_protect = FLASH_PROTECTION_SENSITIVE
	// Blue green, dark
	color_cutoffs = list(5, 15, 30)
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/hud/health/night/meson
	name = "scanneur de santé à vision nocturne meson ATH"
	desc = "Réellement prêt pour le combat."
	vision_flags = SEE_TURFS

/obj/item/clothing/glasses/hud/health/night/science
	name = "scanneur de santé à vision nocturne de la science médicale ATH"
	desc = "Un scanneur médical à vision nocturne clandestin, parfait pour trouver les \
		capitaines mourant et pour trouver le poison parfait pour les éliminer dans une complète obscurité."
	clothing_traits = list(TRAIT_REAGENT_SCANNER)

/obj/item/clothing/glasses/hud/health/sunglasses
	name = "lunettes de soleil ATH médicales"
	desc = "Lunettes de soleil avec un ATH médical."
	icon_state = "sunhudmed"
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/blue

/obj/item/clothing/glasses/hud/diagnostic
	name = "ATH de diagnostic"
	desc = "Un affichage tête haute capable d'analyser l'intégrité et le statut des robots et des exosquelettes."
	icon_state = "diagnostichud"
	hud_type = DATA_HUD_DIAGNOSTIC_BASIC
	hud_trait = TRAIT_DIAGNOSTIC_HUD
	glass_colour_type = /datum/client_colour/glass_colour/lightorange

/obj/item/clothing/glasses/hud/diagnostic/night
	name = "ATH de diagnostic à vision nocturne"
	desc = "Un ATH de diagnostic capable d'analyser l'intégrité et le statut des robots et des exosquelettes dans l'obscurité."
	icon_state = "diagnostichudnight"
	inhand_icon_state = "glasses"
	flash_protect = FLASH_PROTECTION_SENSITIVE
	// Pale yellow
	color_cutoffs = list(30, 20, 5)
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/hud/diagnostic/sunglasses
	name = "lunettes de soleil de diagnostic"
	desc = "Lunettes de soleil avec un ATH de diagnostic."
	icon_state = "sunhuddiag"
	inhand_icon_state = "glasses"
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1

/obj/item/clothing/glasses/hud/security
	name = "ATH de sécurité"
	desc = "Un affichage tête haute qui scanne les humanoïdes dans le champs de vision et donne des données précises sur leur identité et leur dossier de sécurité."
	icon_state = "securityhud"
	hud_type = DATA_HUD_SECURITY_ADVANCED
	hud_trait = TRAIT_SECURITY_HUD
	glass_colour_type = /datum/client_colour/glass_colour/red

/obj/item/clothing/glasses/hud/security/chameleon
	name = "ATH de sécurité caméléon"
	desc = "Un ATH de sécurité volé intégré avec la technologie caméléon de Syndicate. Fournit une protection contre les flashs."
	flash_protect = FLASH_PROTECTION_FLASH

	// Yes this code is the same as normal chameleon glasses, but we don't
	// have multiple inheritance, okay?
	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/clothing/glasses/hud/security/chameleon/Initialize(mapload)
	. = ..()
	chameleon_action = new(src)
	chameleon_action.chameleon_type = /obj/item/clothing/glasses
	chameleon_action.chameleon_name = "Glasses"
	chameleon_action.chameleon_blacklist = typecacheof(/obj/item/clothing/glasses/changeling, only_root_path = TRUE)
	chameleon_action.initialize_disguises()
	add_item_action(chameleon_action)

/obj/item/clothing/glasses/hud/security/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()


/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	name = "ATH cache-oeil"
	desc = "Le cousin plus cool des lunettes ATH."
	icon_state = "hudpatch"
	base_icon_state = "hudpatch"
	actions_types = list(/datum/action/item_action/flip)

/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch/attack_self(mob/user, modifiers)
	. = ..()
	icon_state = (icon_state == base_icon_state) ? "[base_icon_state]_flipped" : base_icon_state
	user.update_worn_glasses()

/obj/item/clothing/glasses/hud/security/sunglasses
	name = "lunettes de soleil ATH de sécurité"
	desc = "Des lunettes de soleil avec un ATH de sécurité."
	icon_state = "sunhudsec"
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/darkred

/obj/item/clothing/glasses/hud/security/night
	name = "ATH de sécurité à vision nocturne"
	desc = "Un affichage tête haute avancé qui fournit des données d'identité et de vision dans l'obscurité complète."
	icon_state = "securityhudnight"
	flash_protect = FLASH_PROTECTION_SENSITIVE
	// Red with a tint of green
	color_cutoffs = list(35, 5, 5)
	glass_colour_type = /datum/client_colour/glass_colour/green

/obj/item/clothing/glasses/hud/security/sunglasses/gars
	name = "\improper lunettes gar ATH"
	desc = "Lunettes GAR avec un ATH."
	icon_state = "gar_sec"
	inhand_icon_state = "gar_black"
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	force = 10
	throwforce = 10
	throw_speed = 4
	attack_verb_continuous = list("slices")
	attack_verb_simple = list("slice")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED

/obj/item/clothing/glasses/hud/security/sunglasses/gars/giga
	name = "lunettes gar ATH giga"
	desc = "Lunettes GAR GIGA avec un ATH."
	icon_state = "gigagar_sec"
	force = 12
	throwforce = 12

/obj/item/clothing/glasses/hud/toggle
	name = "Allume ATH"
	desc = "Un affichage tête haute avec plusieurs fonctions."
	actions_types = list(/datum/action/item_action/switch_hud)

/obj/item/clothing/glasses/hud/toggle/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/wearer = user
	if (wearer.glasses != src)
		return

	if (hud_type)
		var/datum/atom_hud/our_hud = GLOB.huds[hud_type]
		our_hud.hide_from(user)

	if (hud_type == DATA_HUD_MEDICAL_ADVANCED)
		hud_type = null
	else if (hud_type == DATA_HUD_SECURITY_ADVANCED)
		hud_type = DATA_HUD_MEDICAL_ADVANCED
	else
		hud_type = DATA_HUD_SECURITY_ADVANCED

	if (hud_type)
		var/datum/atom_hud/our_hud = GLOB.huds[hud_type]
		our_hud.show_to(user)

/datum/action/item_action/switch_hud
	name = "Switch HUD"

/obj/item/clothing/glasses/hud/toggle/thermal
	name = "ATH avec vision thermique"
	desc = "Un affichage tête haute avec vision thermique."
	icon_state = "thermal"
	hud_type = DATA_HUD_SECURITY_ADVANCED
	vision_flags = SEE_MOBS
	color_cutoffs = list(25, 8, 5)
	glass_colour_type = /datum/client_colour/glass_colour/red

/obj/item/clothing/glasses/hud/toggle/thermal/attack_self(mob/user)
	..()
	switch (hud_type)
		if (DATA_HUD_MEDICAL_ADVANCED)
			icon_state = "meson"
			color_cutoffs = list(5, 15, 5)
			change_glass_color(user, /datum/client_colour/glass_colour/green)
		if (DATA_HUD_SECURITY_ADVANCED)
			icon_state = "thermal"
			color_cutoffs = list(25, 8, 5)
			change_glass_color(user, /datum/client_colour/glass_colour/red)
		else
			icon_state = "purple"
			color_cutoffs = list(15, 0, 25)
			change_glass_color(user, /datum/client_colour/glass_colour/purple)
	user.update_sight()
	user.update_worn_glasses()

/obj/item/clothing/glasses/hud/toggle/thermal/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	thermal_overload()

/obj/item/clothing/glasses/hud/spacecop
	name = "lunettes de soleil de flic"
	desc = "Pour penser que vous avez l'air cool tout en brutalisant les manifestants et les minorités."
	icon_state = "bigsunglasses"
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1
	glass_colour_type = /datum/client_colour/glass_colour/gray


/obj/item/clothing/glasses/hud/spacecop/hidden // for the undercover cop
	name = "lunettes de soleil"
	desc = "Ces lunettes de soleil sont spéciales, et vous permettent de voir les criminels potentiels."
	icon_state = "sun"
	inhand_icon_state = "sunglasses"
