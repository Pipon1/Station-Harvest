/obj/item/clothing/suit/armor
	icon = 'icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'icons/mob/clothing/suits/armor.dmi'
	allowed = null
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 250
	resistance_flags = NONE
	armor_type = /datum/armor/suit_armor

/datum/armor/suit_armor
	melee = 35
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/suit/armor/Initialize(mapload)
	. = ..()
	if(!allowed)
		allowed = GLOB.security_vest_allowed

/obj/item/clothing/suit/armor/vest
	name = "gilet pare-balles"
	desc = "Un gilet pare-balles de type I qui offre une protection décente contre la plupart des types de dégâts."
	icon_state = "armoralt"
	inhand_icon_state = "armor"
	blood_overlay_type = "armor"
	dog_fashion = /datum/dog_fashion/back/armorvest

/obj/item/clothing/suit/armor/vest/alt
	desc = "Un gillet pare-balles de type I qui offre une protection décente contre la plupart des types de dégâts."
	icon_state = "armor"
	inhand_icon_state = "armor"

/obj/item/clothing/suit/armor/vest/alt/sec
	icon_state = "armor_sec"

/obj/item/clothing/suit/armor/vest/marine
	name = "un gilet pare-balles tactique"
	desc = "Un set de plaques d'armure en plastacier estampé, contenant une unité de protection environnementale pour enfoncer les portes dans toutes les conditions."
	icon_state = "marine_command"
	inhand_icon_state = "armor"
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/vest_marine
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT_OFF
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	resistance_flags = FIRE_PROOF | ACID_PROOF

/datum/armor/vest_marine
	melee = 50
	bullet = 50
	laser = 30
	energy = 25
	bomb = 50
	bio = 100
	fire = 40
	acid = 50
	wound = 20

/obj/item/clothing/suit/armor/vest/marine/security
	name = "gillet pare-balles tactique large"
	icon_state = "marine_security"

/obj/item/clothing/suit/armor/vest/marine/engineer
	name = "gillet pare-balles tactique polyvalent"
	icon_state = "marine_engineer"

/obj/item/clothing/suit/armor/vest/marine/medic
	name = "gillet pare-balles tactique médical"
	icon_state = "marine_medic"
	body_parts_covered = CHEST|GROIN

/obj/item/clothing/suit/armor/vest/old
	name = "gillet pare-balles dégradé"
	desc = "Une plus vieille génération de gillet pare-balles de type I. En raison de la dégradation au fil du temps, le gillet est bien moins maniable."
	inhand_icon_state = "armor"
	slowdown = 1

/obj/item/clothing/suit/armor/vest/blueshirt
	name = "gillet pare-balles large"
	desc = "Un gillet pare-balles large mais confortable qui vous protégera contre certaines menances."
	icon_state = "blueshift"
	inhand_icon_state = null
	custom_premium_price = PAYCHECK_COMMAND

/obj/item/clothing/suit/armor/vest/cuirass
	name = "cuirasse"
	desc = "Une armure légère qui vous protégera contre les flèches tout en vous permettant de bouger facikement."
	icon_state = "cuirass"
	inhand_icon_state = "armor"
	dog_fashion = null

/obj/item/clothing/suit/armor/hos
	name = "pardessus blindé"
	desc = "Un pardessus blindé pour ceux qui veulent ressembler à un commandent tout en étant protégé."
	icon_state = "hos"
	inhand_icon_state = "greatcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor_type = /datum/armor/armor_hos
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	strip_delay = 80

/datum/armor/armor_hos
	melee = 30
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 70
	acid = 90
	wound = 10

/obj/item/clothing/suit/armor/hos/trenchcoat
	name = "trenchcoat blindé"
	desc = "Un trenchcoat renforcé avec du kevlar léger. L'épitome de l'habillement tactique."
	icon_state = "hostrench"
	inhand_icon_state = "hostrench"
	flags_inv = 0
	strip_delay = 80

/obj/item/clothing/suit/armor/hos/trenchcoat/winter
	name = "tenchcoat d'hiver du chef de la sécurité"
	desc = "Un trenchcoat renforcé avec du kevlar léger, rembourré de laine sur le col et à l'intérieur. Vous vous sentez étrangement seul en portant ce manteau."
	icon_state = "hoswinter"
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT

/obj/item/clothing/suit/armor/hos/hos_formal
	name = "\improper Vêtement de parade du chef de la sécurité"
	desc = "For when an armoured vest isn't fashionable enough."
	icon_state = "hosformal"
	inhand_icon_state = "hostrench"
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/suit/armor/hos/hos_formal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/armor/vest/warden
	name = "tenue du gardien"
	desc = "Une tenue de couleur bleu marine avec des épaulettes bleues et '/Gardien/' brodé sur une des poches de poitrine."
	icon_state = "warden_alt"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS|HANDS
	heat_protection = CHEST|GROIN|ARMS|HANDS
	strip_delay = 70
	resistance_flags = FLAMMABLE
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/warden/alt
	name = "tenue blindée du gardien"
	desc = "Une tenue de couleur rouge avec des épaulettes argentées et une armure corporelle par dessus."
	icon_state = "warden_jacket"

/obj/item/clothing/suit/armor/vest/leather
	name = "pardessus de sécurité"
	desc = "Un pardessus légèrement blindé pour les officiers de haut rang. Porte le symbole de la sécurité de Nanotrasen."
	icon_state = "leathercoat-sec"
	inhand_icon_state = "hostrench"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/capcarapace
	name = "carapace du capitaine"
	desc = "Une carapace blindée ignifugée renforcée avec des plaques de céramique et des épaulières en plastacier pour fournir une protection supplémentaire tout en offrant une mobilité et une flexibilité maximales. Émis uniquement aux meilleurs de la station, bien que cela vous irrite les tétons."
	icon_state = "capcarapace"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN
	armor_type = /datum/armor/vest_capcarapace
	dog_fashion = null
	resistance_flags = FIRE_PROOF

/datum/armor/vest_capcarapace
	melee = 50
	bullet = 40
	laser = 50
	energy = 50
	bomb = 25
	fire = 100
	acid = 90
	wound = 10

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	name = "tenue de capitaine du syndicat"
	desc = "Une tenue sinistre avec une armure avancée portée par dessus une veste ignifugée noire et rouge. Le col et les épaules dorés indiquent que cela appartient à un officier de haut rang du syndicat."
	icon_state = "syndievest"

/obj/item/clothing/suit/armor/vest/capcarapace/captains_formal
	name = "pardessus de parade du capitaine"
	desc = "Pour quand un gilet pare-balles n'est pas assez élégant."
	icon_state = "capformal"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/suit/armor/vest/capcarapace/captains_formal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/armor/riot
	name = "armure anti-émeute"
	desc = "Une armure semi-flexible en polycarbonate avec des renforts pour protéger contre les attaques au corps à corps. Aide le porteur à résister aux bousculades dans les espaces restreints."
	icon_state = "riot"
	inhand_icon_state = "swat_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/armor_riot
	clothing_flags = BLOCKS_SHOVE_KNOCKDOWN
	strip_delay = 80
	equip_delay_other = 60

/datum/armor/armor_riot
	melee = 50
	bullet = 10
	laser = 10
	energy = 10
	fire = 80
	acid = 80
	wound = 20

/obj/item/clothing/suit/armor/bone
	name = "armure en os"
	desc = "Une armure tribale, fabriquée à partir d'os d'animaux."
	icon_state = "bonearmor"
	inhand_icon_state = null
	blood_overlay_type = "armor"
	armor_type = /datum/armor/armor_bone
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS

/datum/armor/armor_bone
	melee = 35
	bullet = 25
	laser = 25
	energy = 35
	bomb = 25
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/suit/armor/bulletproof
	name = "gillette pare-balles lourd"
	desc = "Un gillet pare-balles lourd de type III qui excelle dans la protection contre les armes à projectiles traditionnelles et les explosifs dans une moindre mesure."
	icon_state = "bulletproof"
	inhand_icon_state = "armor"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/armor_bulletproof
	strip_delay = 70
	equip_delay_other = 50

/datum/armor/armor_bulletproof
	melee = 15
	bullet = 60
	laser = 10
	energy = 10
	bomb = 40
	fire = 50
	acid = 50
	wound = 20

/obj/item/clothing/suit/armor/laserproof
	name = "veste réflectrice"
	desc = "Une veste qui excelle dans la protection contre les projectiles énergétiques, ainsi que dans leur réflexion occasionnelle."
	icon_state = "armor_reflec"
	inhand_icon_state = "armor_reflec"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	heat_protection = CHEST|GROIN|ARMS
	armor_type = /datum/armor/armor_laserproof
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/hit_reflect_chance = 50

/datum/armor/armor_laserproof
	melee = 10
	bullet = 10
	laser = 60
	energy = 60
	fire = 100
	acid = 100

/obj/item/clothing/suit/armor/laserproof/IsReflect(def_zone)
	if(!(def_zone in list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return FALSE
	if (prob(hit_reflect_chance))
		return TRUE

/obj/item/clothing/suit/armor/vest/det_suit
	name = "gillet pare-balles du détective"
	desc = "Un gillet pare-balles avec un badge de détective dessus."
	icon_state = "detective-armor"
	resistance_flags = FLAMMABLE
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/det_suit/Initialize(mapload)
	. = ..()
	allowed = GLOB.detective_vest_allowed

/obj/item/clothing/suit/armor/swat
	name = "Tenue du SWAT MK.I"
	desc = "Une tenue tactique développée en 2321 par l'IS-ERI et Nanotrasen pour les opérations militaires. Elle ralentit légèrement le porteur, mais offre une protection décente."
	icon_state = "heavy"
	inhand_icon_state = "swat_suit"
	armor_type = /datum/armor/armor_swat
	strip_delay = 120
	resistance_flags = FIRE_PROOF | ACID_PROOF
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT_OFF
	heat_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	slowdown = 0.7
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

//All of the armor below is mostly unused

/datum/armor/armor_swat
	melee = 40
	bullet = 30
	laser = 30
	energy = 40
	bomb = 50
	bio = 90
	fire = 100
	acid = 100
	wound = 15

/obj/item/clothing/suit/armor/heavy
	name = "armure lourde"
	desc = "Une armure lourde qui protège contre les dégâts modérés."
	icon_state = "heavy"
	inhand_icon_state = "swat_suit"
	w_class = WEIGHT_CLASS_BULKY
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 3
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor_type = /datum/armor/armor_heavy

/datum/armor/armor_heavy
	melee = 80
	bullet = 80
	laser = 50
	energy = 50
	bomb = 100
	bio = 100
	fire = 90
	acid = 90

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/armor_tdome

/datum/armor/armor_tdome
	melee = 80
	bullet = 80
	laser = 50
	energy = 50
	bomb = 100
	bio = 100
	fire = 90
	acid = 90

/obj/item/clothing/suit/armor/tdome/red
	name = "tenue du thunderdome"
	desc = "Une armure rougeâtre."
	icon_state = "tdred"
	inhand_icon_state = "tdred"

/obj/item/clothing/suit/armor/tdome/green
	name = "tenue du thunderdome"
	desc = "Armure couleur vomit." //classy.
	icon_state = "tdgreen"
	inhand_icon_state = "tdgreen"

/obj/item/clothing/suit/armor/tdome/holosuit
	name = "tenue du thunderdome"
	armor_type = /datum/armor/tdome_holosuit
	cold_protection = null
	heat_protection = null

/datum/armor/tdome_holosuit
	melee = 10
	bullet = 10

/obj/item/clothing/suit/armor/tdome/holosuit/red
	desc = "Une armure rougeâtre."
	icon_state = "tdred"
	inhand_icon_state = "tdred"

/obj/item/clothing/suit/armor/tdome/holosuit/green
	desc = "Une armure couleur vomit." //classy.
	icon_state = "tdgreen"
	inhand_icon_state = "tdgreen"

/obj/item/clothing/suit/armor/riot/knight
	name = "armure de plate"
	desc = "Une armure classique, très efficace pour arrêter les attaques au corps à corps."
	icon_state = "knight_green"
	inhand_icon_state = null
	allowed = list(
		/obj/item/banner,
		/obj/item/claymore,
		/obj/item/nullrod,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		)

/obj/item/clothing/suit/armor/riot/knight/yellow
	icon_state = "knight_yellow"
	inhand_icon_state = null

/obj/item/clothing/suit/armor/riot/knight/blue
	icon_state = "knight_blue"
	inhand_icon_state = null

/obj/item/clothing/suit/armor/riot/knight/red
	icon_state = "knight_red"
	inhand_icon_state = null

/obj/item/clothing/suit/armor/riot/knight/greyscale
	name = "armure de chevalier"
	desc = "Une armure classique, très efficace pour arrêter les attaques au corps à corps. Peut être fabriquée à partir de nombreux matériaux différents."
	icon_state = "knight_greyscale"
	inhand_icon_state = null
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS//Can change color and add prefix
	armor_type = /datum/armor/knight_greyscale

/obj/item/clothing/suit/armor/vest/durathread
	name = "gilet en Fildurable"
	desc = "Un gillet en Fildurable avec des bandes de cuir agissant comme des plaques de protection."
	icon_state = "durathread"
	inhand_icon_state = null
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 200
	resistance_flags = FLAMMABLE
	armor_type = /datum/armor/vest_durathread
	dog_fashion = null

/datum/armor/vest_durathread
	melee = 20
	bullet = 10
	laser = 30
	energy = 40
	bomb = 15
	fire = 40
	acid = 50

/obj/item/clothing/suit/armor/vest/russian
	name = "gillet russe"
	desc = "Un gilet pare-balles avec un camouflage forestier. Heureusement qu'il y a plein de forêts où se cacher par ici, non ?"
	icon_state = "rus_armor"
	inhand_icon_state = null
	armor_type = /datum/armor/vest_russian
	dog_fashion = null

/datum/armor/vest_russian
	melee = 25
	bullet = 30
	energy = 10
	bomb = 10
	fire = 20
	acid = 50
	wound = 10

/obj/item/clothing/suit/armor/vest/russian_coat
	name = "manteau de combat russe"
	desc = "Utilisé dans les fronts extrêmement froids, fabriqué à partir de vrais ours."
	icon_state = "rus_coat"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	armor_type = /datum/armor/vest_russian_coat
	dog_fashion = null

/datum/armor/vest_russian_coat
	melee = 25
	bullet = 20
	laser = 20
	energy = 30
	bomb = 20
	bio = 50
	fire = -10
	acid = 50
	wound = 10

/obj/item/clothing/suit/armor/elder_atmosian
	name = "\improper Armure d'Ancien Atmosien"
	desc = "Une superbe armure faite avec les matériaux les plus durs et les plus rares disponibles à l'homme."
	icon_state = "h2armor"
	inhand_icon_state = null
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS//Can change color and add prefix
	armor_type = /datum/armor/armor_elder_atmosian
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/elder_atmosian/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/fireaxe/metal_h2_axe,
	)

/datum/armor/armor_elder_atmosian
	melee = 25
	bullet = 20
	laser = 30
	energy = 30
	bomb = 85
	bio = 10
	fire = 65
	acid = 40
	wound = 15

/obj/item/clothing/suit/armor/centcom_formal
	name = "\improper manteau formel de CentCom"
	desc = "Un manteau élégant donné au commandant de CentCom. Parfait pour envoyer l'ERT en mission suicide avec style."
	icon_state = "centcom_formal"
	inhand_icon_state = "centcom"
	body_parts_covered = CHEST|GROIN|ARMS
	armor_type = /datum/armor/armor_centcom_formal

/datum/armor/armor_centcom_formal
	melee = 35
	bullet = 40
	laser = 40
	energy = 50
	bomb = 35
	bio = 10
	fire = 10
	acid = 60

/obj/item/clothing/suit/armor/centcom_formal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/armor/vest/hop
	name = "manteau du chef du personnel"
	desc = "Un manteau élégant donné au chef du personnel. Parfait pour usurper le capitaine."
	icon_state = "hop_coat"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dog_fashion = null
