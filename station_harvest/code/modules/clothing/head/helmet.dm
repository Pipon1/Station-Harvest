/obj/item/clothing/head/helmet/advanced_police
	name = "Advanced Security Armor Helmet"
	desc = "An extremely robust helmet."
	icon_state = "adv_police"
	icon = 'station_harvest/icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'station_harvest/icons/mob/clothing/head/helmet.dmi'
	inhand_icon_state = "swatsyndie_helmet"
	armor_type = /datum/armor/helmet_swat
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE | PLASMAMAN_HELMET_EXEMPT
	strip_delay = 120
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = null

/datum/armor/helmet_swat
	melee = 90
	bullet = 90
	laser = 20
	energy = 30
	bomb = 100
	bio = 100
	fire = 100
	acid = 100
	wound = 25
