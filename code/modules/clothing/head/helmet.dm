/obj/item/clothing/head/helmet
	name = "casque"
	desc = "Un casque de sécurité standard. Protège la tête des impacts."
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "helmet"
	inhand_icon_state = "helmet"
	armor_type = /datum/armor/head_helmet
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	strip_delay = 60
	clothing_flags = SNUG_FIT | PLASMAMAN_HELMET_EXEMPT
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEHAIR

	dog_fashion = /datum/dog_fashion/head/helmet

/datum/armor/head_helmet
	melee = 35
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/head/helmet/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob, ITEM_SLOT_HEAD)

/obj/item/clothing/head/helmet/sec

/obj/item/clothing/head/helmet/sec/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, light_icon_state = "flight")

/obj/item/clothing/head/helmet/sec/attackby(obj/item/attacking_item, mob/user, params)
	if(issignaler(attacking_item))
		var/obj/item/assembly/signaler/attached_signaler = attacking_item
		// There's a flashlight in us. Remove it first, or it'll be lost forever!
		var/obj/item/flashlight/seclite/blocking_us = locate() in src
		if(blocking_us)
			to_chat(user, span_warning("[blocking_us] est deja en place, il faut le retirer !"))
			return TRUE

		if(!attached_signaler.secured)
			to_chat(user, span_warning("Sécurisez le [attached_signaler] d'abord !"))
			return TRUE

		to_chat(user, span_notice("Vous ajoutez le [attached_signaler] au [src]."))

		qdel(attached_signaler)
		var/obj/item/bot_assembly/secbot/secbot_frame = new(loc)
		user.put_in_hands(secbot_frame)

		qdel(src)
		return TRUE

	return ..()

/obj/item/clothing/head/helmet/alt
	name = "casque pare-balles"
	desc = "Un casque de combat pare-balles qui excelle dans la protection du porteur contre les armes à projectiles traditionnelles et les explosifs dans une moindre mesure."
	icon_state = "helmetalt"
	inhand_icon_state = "helmet"
	armor_type = /datum/armor/helmet_alt
	dog_fashion = null

/datum/armor/helmet_alt
	melee = 15
	bullet = 60
	laser = 10
	energy = 10
	bomb = 40
	fire = 50
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, light_icon_state = "flight")

/obj/item/clothing/head/helmet/marine
	name = "casque de combat tactique"
	desc = "Un casque de combat tactique, scellé des dangers extérieurs avec une plaque de verre et pas grand chose d'autre."
	icon_state = "marine_command"
	inhand_icon_state = "marine_helmet"
	armor_type = /datum/armor/helmet_marine
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE | PLASMAMAN_HELMET_EXEMPT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = null

/datum/armor/helmet_marine
	melee = 50
	bullet = 50
	laser = 30
	energy = 25
	bomb = 50
	bio = 100
	fire = 40
	acid = 50
	wound = 20

/obj/item/clothing/head/helmet/marine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, starting_light = new /obj/item/flashlight/seclite(src), light_icon_state = "flight")

/obj/item/clothing/head/helmet/marine/security
	name = "casque lourd de marine"
	icon_state = "marine_security"

/obj/item/clothing/head/helmet/marine/engineer
	name = "casque de marine polyvalent"
	icon_state = "marine_engineer"

/obj/item/clothing/head/helmet/marine/medic
	name = "casque de marine médical"
	icon_state = "marine_medic"

/obj/item/clothing/head/helmet/old
	name = "casque dégradé"
	desc = "un casque de sécurité standard. En raison de la dégradation, le casque obstrue la vision du porteur."
	tint = 2

/obj/item/clothing/head/helmet/blueshirt
	name = "casque bleu"
	desc = "Un casque bleu fiable qui vous rappelle que vous devez <i>toujours</i> une bière à cet ingénieur."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift_helmet"
	custom_premium_price = PAYCHECK_COMMAND


/obj/item/clothing/head/helmet/toggleable
	dog_fashion = null
	///chat message when the visor is toggled down.
	var/toggle_message
	///chat message when the visor is toggled up.
	var/alt_toggle_message

/obj/item/clothing/head/helmet/toggleable/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(user.incapacitated() || !try_toggle())
		return
	up = !up
	flags_1 ^= visor_flags
	flags_inv ^= visor_flags_inv
	flags_cover ^= visor_flags_cover
	icon_state = "[initial(icon_state)][up ? "up" : ""]"
	to_chat(user, span_notice("[up ? alt_toggle_message : toggle_message] \the [src]."))

	user.update_worn_head()
	if(iscarbon(user))
		var/mob/living/carbon/carbon_user = user
		carbon_user.head_update(src, forced = TRUE)

///Attempt to toggle the visor. Returns true if it does the thing.
/obj/item/clothing/head/helmet/toggleable/proc/try_toggle()
	return TRUE

/obj/item/clothing/head/helmet/toggleable/riot
	name = "casque anti-émeute"
	desc = "C'est un casque spécialement conçu pour protéger contre les attaques de mélées."
	icon_state = "riot"
	inhand_icon_state = "riot_helmet"
	toggle_message = "Vous baissez la visière"
	alt_toggle_message = "Vous levez la visière"
	armor_type = /datum/armor/toggleable_riot
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	strip_delay = 80
	actions_types = list(/datum/action/item_action/toggle)
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF

/datum/armor/toggleable_riot
	melee = 50
	bullet = 10
	laser = 10
	energy = 10
	fire = 80
	acid = 80
	wound = 15

/obj/item/clothing/head/helmet/toggleable/justice
	name = "casque de la justice"
	desc = "WEEEEOOO. WEEEEEOOO. WEEEEOOOO."
	icon_state = "justice"
	inhand_icon_state = "justice_helmet"
	toggle_message = "Vous allumez les lumières"
	alt_toggle_message = "Vous éteignez les lumières"
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	///Cooldown for toggling the visor.
	COOLDOWN_DECLARE(visor_toggle_cooldown)
	///Looping sound datum for the siren helmet
	var/datum/looping_sound/siren/weewooloop

/obj/item/clothing/head/helmet/toggleable/justice/try_toggle()
	if(!COOLDOWN_FINISHED(src, visor_toggle_cooldown))
		return FALSE
	COOLDOWN_START(src, visor_toggle_cooldown, 2 SECONDS)
	return TRUE

/obj/item/clothing/head/helmet/toggleable/justice/Initialize(mapload)
	. = ..()
	weewooloop = new(src, FALSE, FALSE)

/obj/item/clothing/head/helmet/toggleable/justice/Destroy()
	QDEL_NULL(weewooloop)
	return ..()

/obj/item/clothing/head/helmet/toggleable/justice/attack_self(mob/user)
	. = ..()
	if(up)
		weewooloop.start()
	else
		weewooloop.stop()

/obj/item/clothing/head/helmet/toggleable/justice/escape
	name = "casque d'alarme"
	desc = "WEEEEOOO. WEEEEEOOO. ARRÊTE CA LE SINGE. WEEEOOOO."
	icon_state = "justice2"

/obj/item/clothing/head/helmet/swat
	name = "\improper casque du SWAT"
	desc = "Un casque extrêmement robuste, adapté à l'espace, dans un motif de rayures rouge et noir."
	icon_state = "swatsyndie"
	inhand_icon_state = "swatsyndie_helmet"
	armor_type = /datum/armor/helmet_swat
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE | PLASMAMAN_HELMET_EXEMPT
	strip_delay = 80
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = null

/datum/armor/helmet_swat
	melee = 40
	bullet = 30
	laser = 30
	energy = 40
	bomb = 50
	bio = 90
	fire = 100
	acid = 100
	wound = 15

/obj/item/clothing/head/helmet/swat/nanotrasen
	name = "\improper casque du SWAT"
	desc = "Un casque extrêmement robuste, adapté à l'espace, avec le logo de Nanotrasen sur le dessus."
	icon_state = "swat"
	inhand_icon_state = "swat_helmet"
	clothing_flags = PLASMAMAN_HELMET_EXEMPT
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF


/obj/item/clothing/head/helmet/thunderdome
	name = "\improper casque du Thunderdome"
	desc = "<i>'que le combat commence!'</i>"
	flags_inv = HIDEEARS|HIDEHAIR
	icon_state = "thunderdome"
	inhand_icon_state = "thunderdome_helmet"
	armor_type = /datum/armor/helmet_thunderdome
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	strip_delay = 80
	dog_fashion = null

/datum/armor/helmet_thunderdome
	melee = 80
	bullet = 80
	laser = 50
	energy = 50
	bomb = 100
	bio = 100
	fire = 90
	acid = 90

/obj/item/clothing/head/helmet/thunderdome/holosuit
	cold_protection = null
	heat_protection = null
	armor_type = /datum/armor/thunderdome_holosuit

/datum/armor/thunderdome_holosuit
	melee = 10
	bullet = 10

/obj/item/clothing/head/helmet/roman
	name = "\improper casque Romain"
	desc = "Un ancien casque en bronze et cuir."
	flags_inv = HIDEEARS|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	armor_type = /datum/armor/helmet_roman
	resistance_flags = FIRE_PROOF
	icon_state = "roman"
	inhand_icon_state = "roman_helmet"
	strip_delay = 100
	dog_fashion = null

/datum/armor/helmet_roman
	melee = 25
	laser = 25
	energy = 10
	bomb = 10
	fire = 100
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/roman/fake
	desc = "Un ancien casque en plastique et cuir."
	armor_type = /datum/armor/none

/obj/item/clothing/head/helmet/roman/legionnaire
	name = "\improper Casque de légionnaire Romain"
	desc = "Un ancien casque en bronze et cuir. Il a une crête rouge sur le dessus."
	icon_state = "roman_c"

/obj/item/clothing/head/helmet/roman/legionnaire/fake
	desc = "Un ancien casque en plastique et cuir. Il a une crête rouge sur le dessus."
	armor_type = /datum/armor/none

/obj/item/clothing/head/helmet/gladiator
	name = "casque de gladiateur"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	inhand_icon_state = "gladiator_helmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	dog_fashion = null

/obj/item/clothing/head/helmet/redtaghelm
	name = "casque de lasertag rouge"
	desc = "Ils ont choisi leur propre fin."
	icon_state = "redtaghelm"
	flags_cover = HEADCOVERSEYES
	inhand_icon_state = "redtag_helmet"
	armor_type = /datum/armor/helmet_redtaghelm
	// Offer about the same protection as a hardhat.
	dog_fashion = null

/datum/armor/helmet_redtaghelm
	melee = 15
	bullet = 10
	laser = 20
	energy = 10
	bomb = 20
	acid = 50

/obj/item/clothing/head/helmet/bluetaghelm
	name = "casque de lasertag bleu"
	desc = "Il leur faudra plus d'hommes."
	icon_state = "bluetaghelm"
	flags_cover = HEADCOVERSEYES
	inhand_icon_state = "bluetag_helmet"
	armor_type = /datum/armor/helmet_bluetaghelm
	// Offer about the same protection as a hardhat.
	dog_fashion = null

/datum/armor/helmet_bluetaghelm
	melee = 15
	bullet = 10
	laser = 20
	energy = 10
	bomb = 20
	acid = 50

/obj/item/clothing/head/helmet/knight
	name = "casque médiéval"
	desc = "Un casque en métal classique."
	icon_state = "knight_green"
	inhand_icon_state = "knight_helmet"
	armor_type = /datum/armor/helmet_knight
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	strip_delay = 80
	dog_fashion = null

/datum/armor/helmet_knight
	melee = 50
	bullet = 10
	laser = 10
	energy = 10
	fire = 80
	acid = 80

/obj/item/clothing/head/helmet/knight/blue
	icon_state = "knight_blue"

/obj/item/clothing/head/helmet/knight/yellow
	icon_state = "knight_yellow"

/obj/item/clothing/head/helmet/knight/red
	icon_state = "knight_red"

/obj/item/clothing/head/helmet/knight/greyscale
	name = "casque de chevalier"
	desc = "Un casque médiéval classique, si vous le tenez à l'envers, vous pourriez voir que c'est en fait un seau."
	icon_state = "knight_greyscale"
	inhand_icon_state = null
	armor_type = /datum/armor/knight_greyscale
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS //Can change color and add prefix

/datum/armor/knight_greyscale
	melee = 35
	bullet = 10
	laser = 10
	energy = 10
	bomb = 10
	bio = 10
	fire = 40
	acid = 40

/obj/item/clothing/head/helmet/skull
	name = "casque crâne"
	desc = "Un casque tribal intimidant, il n'a pas l'air très confortable."
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES
	armor_type = /datum/armor/helmet_skull
	icon_state = "skull"
	inhand_icon_state = null
	strip_delay = 100

/datum/armor/helmet_skull
	melee = 35
	bullet = 25
	laser = 25
	energy = 35
	bomb = 25
	fire = 50
	acid = 50

/obj/item/clothing/head/helmet/durathread
	name = "casque en Fildurable"
	desc = "Un casque fait de Fildurable et de cuir."
	icon_state = "durathread"
	inhand_icon_state = "durathread_helmet"
	resistance_flags = FLAMMABLE
	armor_type = /datum/armor/helmet_durathread
	strip_delay = 60

/datum/armor/helmet_durathread
	melee = 20
	bullet = 10
	laser = 30
	energy = 40
	bomb = 15
	fire = 40
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/rus_helmet
	name = "casque russe"
	desc = "Il peut contenir une bouteille de vodka."
	icon_state = "rus_helmet"
	inhand_icon_state = "rus_helmet"
	armor_type = /datum/armor/helmet_rus_helmet

/datum/armor/helmet_rus_helmet
	melee = 25
	bullet = 30
	energy = 10
	bomb = 10
	fire = 20
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/rus_helmet/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/helmet)

/obj/item/clothing/head/helmet/rus_ushanka
	name = "ushanka de combat"
	desc = "100% ours."
	icon_state = "rus_ushanka"
	inhand_icon_state = "rus_ushanka"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	armor_type = /datum/armor/helmet_rus_ushanka

/datum/armor/helmet_rus_ushanka
	melee = 25
	bullet = 20
	laser = 20
	energy = 30
	bomb = 20
	bio = 50
	fire = -10
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/elder_atmosian
	name = "\improper Casque d'Ancien Atmosien"
	desc = "Ce superbe casque est fait avec les matériaux les plus résistants et les plus rares disponibles à l'homme."
	icon_state = "h2helmet"
	inhand_icon_state = "h2_helmet"
	armor_type = /datum/armor/helmet_elder_atmosian
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS //Can change color and add prefix
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/datum/armor/helmet_elder_atmosian
	melee = 25
	bullet = 20
	laser = 30
	energy = 30
	bomb = 85
	bio = 10
	fire = 65
	acid = 40
	wound = 15
