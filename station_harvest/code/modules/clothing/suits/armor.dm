/obj/item/clothing/suit/armor/advanced_police
	name = "Advanced Security Armor"
	desc = "A tactical suit of armor originally intended for police use, but Nanotrasen uses it for security purpose."
	icon_state = "heavy_sec"
	icon = 'station_harvest/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'station_harvest/icons/mob/clothing/suits/armor.dmi'
	inhand_icon_state = "swat_suit"
	armor_type = /datum/armor/advanced_police
	strip_delay = 120
	resistance_flags = FIRE_PROOF | ACID_PROOF
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT_OFF
	heat_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	slowdown = 0.1
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/datum/armor/advanced_police
	melee = 90
	bullet = 90
	laser = 20
	energy = 30
	bomb = 100
	bio = 100
	fire = 100
	acid = 100
	wound = 25
