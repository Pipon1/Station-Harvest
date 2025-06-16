/obj/item/clothing/shoes/combat //basic syndicate combat boots for nuke ops and mob corpses
	name = "bottes de combat"
	desc = "Des bottes de combat à haute vitesse et à faible traînée."
	icon_state = "jackboots"
	inhand_icon_state = "jackboots"
	armor_type = /datum/armor/shoes_combat
	strip_delay = 40
	resistance_flags = NONE
	lace_time = 12 SECONDS

/datum/armor/shoes_combat
	melee = 25
	bullet = 25
	laser = 25
	energy = 25
	bomb = 50
	bio = 90
	fire = 70
	acid = 50

/obj/item/clothing/shoes/combat/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/combat/swat //overpowered boots for death squads
	name = "\improper bottes du SWAT"
	desc = "Des bottes de combat à haute vitesse et à faible traînée."
	clothing_traits = list(TRAIT_NO_SLIP_WATER)
	armor_type = /datum/armor/combat_swat

/datum/armor/combat_swat
	melee = 40
	bullet = 30
	laser = 25
	energy = 25
	bomb = 50
	bio = 100
	fire = 90
	acid = 50

/obj/item/clothing/shoes/jackboots
	name = "bottes de combat sécurisées"
	desc = "Des bottes de combat de sécurité standard de Nanotrasen pour les situations de combat ou les situations de combat. Tout le combat, tout le temps."
	icon_state = "jackboots"
	inhand_icon_state = "jackboots"
	strip_delay = 30
	equip_delay_other = 50
	resistance_flags = NONE
	armor_type = /datum/armor/shoes_jackboots
	can_be_tied = FALSE

/datum/armor/shoes_jackboots
	bio = 90

/obj/item/clothing/shoes/jackboots/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/jackboots/fast
	slowdown = -1

/obj/item/clothing/shoes/jackboots/sec
	icon_state = "jackboots_sec"

/obj/item/clothing/shoes/winterboots
	name = "bottes d'hiver"
	desc = "Des bottes doublées de fourrure animale 'synthétique'."
	icon_state = "winterboots"
	inhand_icon_state = null
	armor_type = /datum/armor/shoes_winterboots
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	lace_time = 8 SECONDS

/datum/armor/shoes_winterboots
	bio = 80

/obj/item/clothing/shoes/winterboots/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/winterboots/ice_boots
	name = "bottes de randonnée sur glace"
	desc = "Une paire de bottes d'hiver avec des crampons spéciaux en bas, conçus pour éviter de glisser sur les surfaces gelées."
	icon_state = "iceboots"
	inhand_icon_state = null
	clothing_traits = list(TRAIT_NO_SLIP_ICE, TRAIT_NO_SLIP_SLIDE)

// A pair of ice boots intended for general crew EVA use - see EVA winter coat for comparison.
/obj/item/clothing/shoes/winterboots/ice_boots/eva
	name = "\proper bottes de randonnée Endotherm"
	desc = "Une paire de bottes de randonnée lourdes avec des crampons appliqués au bas pour garder le porteur vertical en marchant dans des conditions de gel."
	icon_state = "iceboots_eva"
	w_class = WEIGHT_CLASS_BULKY
	slowdown = 0.25
	armor_type = /datum/armor/ice_boots_eva
	strip_delay = 4 SECONDS
	equip_delay_other = 4 SECONDS
	clothing_flags = THICKMATERIAL
	resistance_flags = NONE

/datum/armor/ice_boots_eva
	melee = 10
	laser = 10
	energy = 10
	bio = 50
	fire = 50
	acid = 10

/obj/item/clothing/shoes/workboots
	name = "bottes de travail"
	desc = "Bottes de travail à lacets standard de Nanotrasen pour les travailleurs manuels."
	icon_state = "workboots"
	inhand_icon_state = "jackboots"
	armor_type = /datum/armor/shoes_workboots
	strip_delay = 20
	equip_delay_other = 40
	lace_time = 8 SECONDS
	species_exception = list(/datum/species/golem/uranium)

/datum/armor/shoes_workboots
	bio = 80

/obj/item/clothing/shoes/workboots/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/workboots/mining
	name = "bottes de minage"
	desc = "Bottes de minage à bout d'acier pour le minage dans des environnements dangereux. Très bon pour garder les orteils intacts."
	icon_state = "explorer"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/shoes/russian
	name = "bottes russes"
	desc = "Des bottes confortables."
	icon_state = "rus_shoes"
	inhand_icon_state = null
	lace_time = 8 SECONDS

/obj/item/clothing/shoes/russian/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/discoshoes
	name = "chaussures en peau de lézard vert"
	desc = "Elles ont peut-être perdu une partie de leur éclat au fil des ans, mais ces chaussures en peau de lézard vert vous vont parfaitement."
	icon_state = "lizardskin_shoes"
	inhand_icon_state = null

/obj/item/clothing/shoes/kim
	name = "bottes aérostatiques"
	desc = "Une paire de bottes aérostatiques pour les longues heures de travail sur le terrain."
	icon_state = "aerostatic_boots"
	inhand_icon_state = null
