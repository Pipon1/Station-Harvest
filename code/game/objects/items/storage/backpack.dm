/* Backpacks
 * Contains:
 * Backpack
 * Backpack Types
 * Satchel Types
 */

/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "sac à dos"
	desc = "Portez-le sur votre dos et mettez des objets dedans."
	icon = 'icons/obj/storage/backpack.dmi'
	worn_icon = 'icons/mob/clothing/back/backpack.dmi'
	icon_state = "backpack"
	inhand_icon_state = "backpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK //ERROOOOO
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/backpack/Initialize(mapload)
	. = ..()
	create_storage(max_slots = 25, max_total_storage = 25)
	AddElement(/datum/element/attack_equip)

/*
 * Backpack Types
 */

/obj/item/storage/backpack/old/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 12

/obj/item/bag_of_holding_inert
	name = "sac sans fond inerte"
	desc = "Ce sac est actuellement un simple bloc de métal avec une fente prête à accepter un noyau d'anomalie de bluespace."
	icon = 'icons/obj/storage/backpack.dmi'
	worn_icon = 'icons/mob/clothing/back/backpack.dmi'
	icon_state = "bag_of_holding-inert"
	inhand_icon_state = "brokenpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION

/obj/item/storage/backpack/holding
	name = "sac sans fond"
	desc = "Un sac qui s'ouvre dans une poche de bluespace localisée."
	icon_state = "bag_of_holding"
	inhand_icon_state = "holdingpack"
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION
	armor_type = /datum/armor/backpack_holding

/datum/armor/backpack_holding
	fire = 60
	acid = 50

/obj/item/storage/backpack/holding/Initialize(mapload)
	. = ..()

	create_storage(max_specific_storage = WEIGHT_CLASS_GIGANTIC, max_total_storage = 35, max_slots = 30, storage_type = /datum/storage/bag_of_holding)
	atom_storage.allow_big_nesting = TRUE

/obj/item/storage/backpack/holding/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] essaye de sauter dans [src] ! Il semble que [user.p_theyre()] essaye de se suicider."))
	user.dropItemToGround(src, TRUE)
	user.Stun(100, ignore_canstun = TRUE)
	sleep(2 SECONDS)
	playsound(src, SFX_RUSTLE, 50, TRUE, -5)
	user.suicide_log()
	qdel(user)

/obj/item/storage/backpack/santabag
	name = "Sac à Cadeau Du Père-Noel"
	desc = "Le père noël de l'espace utilise se sac pour livre des cadeaux à tous les enfants sage ! Wowaw, il est grand !"
	icon_state = "giftbag0"
	inhand_icon_state = "giftbag"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/backpack/santabag/Initialize(mapload)
	. = ..()
	regenerate_presents()

/obj/item/storage/backpack/santabag/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_total_storage = 60

/obj/item/storage/backpack/santabag/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] met [src] par dessus la tête de [user.p_their()] et sert fort ! Il semble que [user.p_they()] [user.p_are()] n'est pas dans l'esprit de noel..."))
	return OXYLOSS

/obj/item/storage/backpack/santabag/proc/regenerate_presents()
	addtimer(CALLBACK(src, PROC_REF(regenerate_presents)), 30 SECONDS)

	var/mob/user = get(loc, /mob)
	if(!istype(user))
		return
	if(user.mind && HAS_TRAIT(user.mind, TRAIT_CANNOT_OPEN_PRESENTS))
		var/turf/floor = get_turf(src)
		var/obj/item/thing = new /obj/item/a_gift/anything(floor)
		if(!atom_storage.attempt_insert(thing, user, override = TRUE))
			qdel(thing)


/obj/item/storage/backpack/cultpack
	name = "sac à trophé"
	desc = "Utile pour porter de l'équipement en plus ainsi que pour déclarer votre folie"
	icon_state = "backpack-cult"
	inhand_icon_state = "backpack"
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER

/obj/item/storage/backpack/clown
	name = "Fou rire von Poueteurton"
	desc = "C'est un sac à dos fait par Honk! Co."
	icon_state = "backpack-clown"
	inhand_icon_state = "clownpack"

/obj/item/storage/backpack/explorer
	name = "sac à dos d'explorateur"
	desc = "Un sac robuste pour cacher votre butin."
	icon_state = "backpack-explorer"
	inhand_icon_state = "explorerpack"

/obj/item/storage/backpack/mime
	name = "sac à dos silencieux"
	desc = "Un sac silencieux fait pour les travailleurs silencieux. Silence Co."
	icon_state = "backpack-mime"
	inhand_icon_state = "mimepack"

/obj/item/storage/backpack/medic
	name = "sac à dos médical"
	desc = "Ce sac à dos est spécialement conçu pour être utilisé dans un environnement stérile."
	icon_state = "backpack-medical"
	inhand_icon_state = "medicalpack"

/obj/item/storage/backpack/security
	name = "sac à dos de sécurité"
	desc = "C'est un sac à dos très robuste."
	icon_state = "backpack-security"
	inhand_icon_state = "securitypack"

/obj/item/storage/backpack/captain
	name = "sac à dos du capitaine"
	desc = "C'est un sac à dos spécial fait exclusivement pour les officiers de Nanotrasen."
	icon_state = "backpack-captain"
	inhand_icon_state = "captainpack"

/obj/item/storage/backpack/industrial
	name = "sac à dos industriel"
	desc = "C'est un sac à dos robuste pour la vie quotidienne sur la station."
	icon_state = "backpack-engineering"
	inhand_icon_state = "engiepack"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/botany
	name = "sac à dos de botanique"
	desc = "C'est un sac à dos fait de fibres naturelles."
	icon_state = "backpack-hydroponics"
	inhand_icon_state = "botpack"

/obj/item/storage/backpack/chemistry
	name = "sac à dos de chimie"
	desc = "C'est un sac à dos fait de fibres hypoallergéniques."
	icon_state = "backpack-chemistry"
	inhand_icon_state = "chempack"

/obj/item/storage/backpack/genetics
	name = "sac à dos de génétique"
	desc = "Ce sac à dos est conçu pour être super résistant, au cas où un Hulk vous attaque."
	icon_state = "backpack-genetics"
	inhand_icon_state = "genepack"

/obj/item/storage/backpack/science
	name = "sac à dos de scientifique"
	desc = "C'est un sac à dos conçu pour être super résistant au feu, il sent vaguement le plasma."
	icon_state = "backpack-science"
	inhand_icon_state = "scipack"

/obj/item/storage/backpack/virology
	name = "sac à dos de virologie"
	desc = "Un sac à dos fait de fibres hypoallergéniques. Il est conçu pour aider à prévenir la propagation des maladies. Ça sent le singe."
	icon_state = "backpack-virology"
	inhand_icon_state = "viropack"

/obj/item/storage/backpack/ert
	name = "sac à dos du commandant de l'équipe d'intervention d'urgence"
	desc = "Un sac à dos spacieux avec beaucoup de poches, porté par le commandant d'une équipe d'intervention d'urgence."
	icon_state = "ert_commander"
	inhand_icon_state = "securitypack"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/ert/security
	name = "sac à dos de sécurité de l'équipe d'intervention d'urgence"
	desc = "Un sac à dos spacieux avec beaucoup de poches, porté par les agents de sécurité des équipes d'intervention d'urgence."
	icon_state = "ert_security"

/obj/item/storage/backpack/ert/medical
	name = "sac à dos médical de l'équipe d'intervention d'urgence"
	desc = "Un sac à dos spacieux avec beaucoup de poches, porté par les médecins des équipes d'intervention d'urgence."
	icon_state = "ert_medical"

/obj/item/storage/backpack/ert/engineer
	name = "sac à dos d'ingénieur de l'équipe d'intervention d'urgence"
	desc = "Un sac à dos spacieux avec beaucoup de poches, porté par les ingénieurs des équipes d'intervention d'urgence."
	icon_state = "ert_engineering"

/obj/item/storage/backpack/ert/janitor
	name = "sac à dos de concierge de l'équipe d'intervention d'urgence"
	desc = "Un sac à dos spacieux avec beaucoup de poches, porté par les concierges des équipes d'intervention d'urgence."
	icon_state = "ert_janitor"

/obj/item/storage/backpack/ert/clown
	name = "sac à dos de clown de l'équipe d'intervention d'urgence"
	desc = "Un sac à dos spacieux avec beaucoup de poches, porté par les clowns des équipes d'intervention d'urgence."
	icon_state = "ert_clown"

/obj/item/storage/backpack/saddlepack
	name = "sac à dos de mule"
	desc = "Un sac à dos conçu pour être sellé sur un monture ou porté sur votre dos, et passer de l'un à l'autre en un clin d'œil. Il est assez spacieux, au détriment de vous faire sentir comme un vrai mulet de bât."
	icon = 'icons/obj/storage/ethereal.dmi'
	worn_icon = 'icons/mob/clothing/back/ethereal.dmi'
	icon_state = "saddlepack"

/obj/item/storage/backpack/saddlepack/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 26

// MEAT MEAT MEAT MEAT MEAT

/obj/item/storage/backpack/meat
	name = "\improper VIANDE"
	desc = "VIANDE VIANDE VIANDE VIANDE VIANDE VIANDE"
	icon_state = "meatmeatmeat"
	inhand_icon_state = "meatmeatmeat"
	force = 15
	throwforce = 15
	attack_verb_continuous = list("VIANDES", "VIANDE VIANDES")
	attack_verb_simple = list("VIANDE", "VIANDE VIANDE")
	///Sounds used in the squeak component
	var/list/meat_sounds = list('sound/effects/blobattack.ogg' = 1)
	///Reagents added to the edible component, ingested when you EAT the MEAT
	var/list/meat_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	///The food types of the edible component
	var/foodtypes = MEAT | RAW
	///How our MEAT tastes. It tastes like MEAT
	var/list/tastes = list("VIANDE" = 1)
	///Eating verbs when consuming the MEAT
	var/list/eatverbs = list("VIANDE", "absorbe", "mord", "consomme")

/obj/item/storage/backpack/meat/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/edible,\
		initial_reagents = meat_reagents,\
		foodtypes = foodtypes,\
		tastes = tastes,\
		eatverbs = eatverbs,\
	)
	AddComponent(/datum/component/squeak, meat_sounds)

/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "sacoche"
	desc = "Une sacoche à la mode."
	icon_state = "satchel-norm"
	inhand_icon_state = "satchel-norm"

/obj/item/storage/backpack/satchel/leather
	name = "sacoche en cuir"
	desc = "Une sacoche en cuir très chic."
	icon_state = "satchel-leather"
	inhand_icon_state = "satchel"

/obj/item/storage/backpack/satchel/leather/withwallet/PopulateContents()
	new /obj/item/storage/wallet/random(src)

/obj/item/storage/backpack/satchel/fireproof
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/satchel/eng
	name = "sacoche industrielle"
	desc = "Un sacoche robuste avec des poches supplémentaires."
	icon_state = "satchel-engineering"
	inhand_icon_state = "satchel-eng"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/satchel/med
	name = "sacoche médicale"
	desc = "Une sacoche stérile utilisée dans les départements médicaux."
	icon_state = "satchel-medical"
	inhand_icon_state = "satchel-med"

/obj/item/storage/backpack/satchel/vir
	name = "sacoche de virologie"
	desc = "Une sacoche stérile avec des couleurs de virologiste."
	icon_state = "satchel-virology"
	inhand_icon_state = "satchel-vir"

/obj/item/storage/backpack/satchel/chem
	name = "sacoche de chimie"
	desc = "Une sacoche stérile avec des couleurs de chimiste."
	icon_state = "satchel-chemistry"
	inhand_icon_state = "satchel-chem"

/obj/item/storage/backpack/satchel/gen
	name = "sacoche de génétique"
	desc = "Une sacoche stérile avec des couleurs de généticien."
	icon_state = "satchel-genetics"
	inhand_icon_state = "satchel-gen"

/obj/item/storage/backpack/satchel/science
	name = "sacoche de scientifique"
	desc = "Utilisé pour contenir des matériaux de recherche."
	icon_state = "satchel-science"
	inhand_icon_state = "satchel-sci"

/obj/item/storage/backpack/satchel/hyd
	name = "sacoche de botanique"
	desc = "Une sacoche faite de fibre naturelle."
	icon_state = "satchel-hydroponics"
	inhand_icon_state = "satchel-hyd"

/obj/item/storage/backpack/satchel/sec
	name = "sacoche de sécurité"
	desc = "Une sacoche robuste pour les besoins de la sécurité."
	icon_state = "satchel-security"
	inhand_icon_state = "satchel-sec"

/obj/item/storage/backpack/satchel/explorer
	name = "sacoche d'explorateur"
	desc = "Une sacoche robuste pour cacher votre butin."
	icon_state = "satchel-explorer"
	inhand_icon_state = "satchel-explorer"

/obj/item/storage/backpack/satchel/cap
	name = "sacoche du capitaine"
	desc = "Une sacoche exclusive pour les officiers de Nanotrasen."
	icon_state = "satchel-captain"
	inhand_icon_state = "satchel-cap"

/obj/item/storage/backpack/satchel/flat
	name = "sacoche de contrebande"
	desc = "Une sacoche très fine qui peut facilement s'insérer dans des espaces restreints."
	icon_state = "satchel-flat"
	inhand_icon_state = "satchel-flat"
	w_class = WEIGHT_CLASS_NORMAL //Can fit in backpacks itself.

/obj/item/storage/backpack/satchel/flat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE, INVISIBILITY_OBSERVER, use_anchor = TRUE)
	atom_storage.max_total_storage = 15
	atom_storage.set_holdable(cant_hold_list = list(/obj/item/storage/backpack/satchel/flat)) //muh recursive backpacks)

/obj/item/storage/backpack/satchel/flat/PopulateContents()
	var/datum/supply_pack/imports/contraband/smuggled_goods = new
	for(var/items in 1 to 2)
		var/smuggled_goods_type = pick(smuggled_goods.contains)
		new smuggled_goods_type(src)

	qdel(smuggled_goods)

/obj/item/storage/backpack/satchel/flat/with_tools/PopulateContents()
	new /obj/item/stack/tile/iron/base(src)
	new /obj/item/crowbar(src)

	..()

/obj/item/storage/backpack/satchel/flat/empty/PopulateContents()
	return

/obj/item/storage/backpack/duffelbag
	name = "sac de sport"
	desc = "Un large sac de sport pour contenir des choses supplémentaires."
	icon_state = "duffel"
	inhand_icon_state = "duffel"
	slowdown = 1

/obj/item/storage/backpack/duffelbag/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 30

/obj/item/storage/backpack/duffelbag/cursed
	name = "Sac de sport vivant"
	desc = "un sac de sport maudit qui a faim de nourriture de tout type. Un avertissement suggère qu'il mange la nourriture à l'intérieur. \
		Si la nourriture est un désastre horrible ou empoisonnée, ou pire si le chef l'a sortie du micro-ondes,, \
		alors peut être que ça aura des effets négatif sur le sac..."
	icon_state = "duffel-curse"
	inhand_icon_state = "duffel-curse"
	slowdown = 2
	max_integrity = 100

/obj/item/storage/backpack/duffelbag/cursed/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/curse_of_hunger, add_dropdel = TRUE)

/obj/item/storage/backpack/duffelbag/captain
	name = "sac de sport du capitaine"
	desc = "Un grand sac de sport pour contenir des choses supplémentaires."
	icon_state = "duffel-captain"
	inhand_icon_state = "duffel-captain"

/obj/item/storage/backpack/duffelbag/med
	name = "sac de sport médical"
	desc = "Un grand sac de sport pour contenir des choses supplémentaires."
	icon_state = "duffel-medical"
	inhand_icon_state = "duffel-med"

/obj/item/storage/backpack/duffelbag/med/surgery
	name = "sac de sport chirurgical"
	desc = "Un sac de sport pour contenir des choses supplémentaires - celui-ci semble être conçu pour contenir des outils chirurgicaux."

/obj/item/storage/backpack/duffelbag/explorer
	name = "sac de sport d'explorateur"
	desc = "Un large sac de sport pour contenir des trésors exotiques."
	icon_state = "duffel-explorer"
	inhand_icon_state = "duffel-explorer"

/obj/item/storage/backpack/duffelbag/hydroponics
	name = "sac de sport d'hydroponique"
	desc = "Un grand sac de sport pour contenir des outils de jardinage supplémentaires."
	icon_state = "duffel-hydroponics"
	inhand_icon_state = "duffel-hydroponics"

/obj/item/storage/backpack/duffelbag/chemistry
	name = "sac de sport de chimie"
	desc = "Un grand sac de sport pour contenir des substances chimiques supplémentaires."
	icon_state = "duffel-chemistry"
	inhand_icon_state = "duffel-chemistry"

/obj/item/storage/backpack/duffelbag/genetics
	name = "un sac de sport de génétique"
	desc = "Un grand sac de sport pour contenir des mutations génétiques supplémentaires."
	icon_state = "duffel-genetics"
	inhand_icon_state = "duffel-genetics"

/obj/item/storage/backpack/duffelbag/science
	name = "sac de sport de scientifique"
	desc = "Un grand sac de sport pour contenir des composants scientifiques supplémentaires."
	icon_state = "duffel-science"
	inhand_icon_state = "duffel-sci"

/obj/item/storage/backpack/duffelbag/virology
	name = "sac de sport de virologie"
	desc = "Un grand sac de sport pour contenir des bouteilles virales supplémentaires."
	icon_state = "duffel-virology"
	inhand_icon_state = "duffel-virology"



/obj/item/storage/backpack/duffelbag/med/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/razor(src)
	new /obj/item/blood_filter(src)

/obj/item/storage/backpack/duffelbag/sec
	name = "sac de sport de sécurité"
	desc = "Un grand sac de sport pour contenir des fournitures de sécurité supplémentaires et des munitions."
	icon_state = "duffel-security"
	inhand_icon_state = "duffel-sec"

/obj/item/storage/backpack/duffelbag/sec/surgery
	name = "sac de sport chirurgical"
	desc = "Un grand sac de sport pour contenir des choses en plus - celui ci contient plusieurs outils coupant."

/obj/item/storage/backpack/duffelbag/sec/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/blood_filter(src)

/obj/item/storage/backpack/duffelbag/engineering
	name = "sac de sport industriel"
	desc = "Un grand sac de sport pour contenir des outils et des fournitures supplémentaires."
	icon_state = "duffel-engineering"
	inhand_icon_state = "duffel-eng"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/drone
	name = "sac de sport de drone"
	desc = "Un grand sac de sport pour contenir des outils et des chapeaux."
	icon_state = "duffel-drone"
	inhand_icon_state = "duffel-drone"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/drone/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)

/obj/item/storage/backpack/duffelbag/clown
	name = "sac de sport de clown"
	desc = "Un grand sac de sport pour contenir des blagues amusantes."
	icon_state = "duffel-clown"
	inhand_icon_state = "duffel-clown"

/obj/item/storage/backpack/duffelbag/clown/cream_pie/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/food/pie/cream(src)

/obj/item/storage/backpack/fireproof
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/syndie
	name = "sac de sport suspicieux"
	desc = "Un grand sac de sport pour contenir des fournitures tactiques supplémentaires."
	icon_state = "duffel-syndie"
	inhand_icon_state = "duffel-syndieammo"
	slowdown = 0
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/syndie/Initialize(mapload)
	. = ..()
	atom_storage.silent = TRUE

/obj/item/storage/backpack/duffelbag/syndie/hitman
	desc = "Un large sac de sport pour contenir des fournitures tactiques supplémentaires. Le logo de Nanotrasen est visible."
	icon_state = "duffel-syndieammo"
	inhand_icon_state = "duffel-syndieammo"

/obj/item/storage/backpack/duffelbag/syndie/hitman/PopulateContents()
	new /obj/item/clothing/under/suit/black(src)
	new /obj/item/clothing/neck/tie/red/hitman(src)
	new /obj/item/clothing/accessory/waistcoat(src)
	new /obj/item/clothing/suit/toggle/lawyer/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/head/fedora(src)

/obj/item/storage/backpack/duffelbag/syndie/med
	name = "sac de sport médical"
	desc = "Un grand sac de sport suspicieux pour contenir des fournitures médicales tactiques supplémentaires."
	icon_state = "duffel-syndiemed"
	inhand_icon_state = "duffel-syndiemed"

/obj/item/storage/backpack/duffelbag/syndie/surgery
	name = "sac de sport chirurgical"
	desc = "Un grand sac de sport suspicieux pour contenir des fournitures chirurgicales tactiques supplémentaires."
	icon_state = "duffel-syndiemed"
	inhand_icon_state = "duffel-syndiemed"

/obj/item/storage/backpack/duffelbag/syndie/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/suit/jacket/straight_jacket(src)
	new /obj/item/clothing/mask/muzzle(src)
	new /obj/item/mmi/syndie(src)
	new /obj/item/blood_filter(src)
	new /obj/item/stack/medical/bone_gel(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo
	name = "sac de sport à munitions"
	desc = "Un grand sac de sport pour contenir des munitions et des fournitures supplémentaires."
	icon_state = "duffel-syndieammo"
	inhand_icon_state = "duffel-syndieammo"

/obj/item/storage/backpack/duffelbag/syndie/ammo/shotgun
	desc = "Un grand sac de sport remplie de munitions de Bulldog."

/obj/item/storage/backpack/duffelbag/syndie/ammo/shotgun/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/ammo_box/magazine/m12g/slug(src)
	new /obj/item/ammo_box/magazine/m12g/slug(src)
	new /obj/item/ammo_box/magazine/m12g/dragon(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/smg
	desc = "Un grand sac de sport remplie de munitions de C-20r."

/obj/item/storage/backpack/duffelbag/syndie/ammo/smg/PopulateContents()
	for(var/i in 1 to 9)
		new /obj/item/ammo_box/magazine/smgm45(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/mech
	desc = "Un grand sac de sport remplie de munitions pour exosquelette."

/obj/item/storage/backpack/duffelbag/syndie/ammo/mech/PopulateContents()
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/storage/belt/utility/syndicate(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/mauler
	desc = "Un grand sac de sport remplie de munitions pour exosquelette."

/obj/item/storage/backpack/duffelbag/syndie/ammo/mauler/PopulateContents()
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/missiles_srm(src)
	new /obj/item/mecha_ammo/missiles_srm(src)
	new /obj/item/mecha_ammo/missiles_srm(src)

/obj/item/storage/backpack/duffelbag/syndie/c20rbundle
	desc = "Un grand sac de sport contenant un C-20r, des chargeurs et un silencieux bon marché."

/obj/item/storage/backpack/duffelbag/syndie/c20rbundle/PopulateContents()
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/gun/ballistic/automatic/c20r(src)
	new /obj/item/suppressor(src)

/obj/item/storage/backpack/duffelbag/syndie/bulldogbundle
	desc = "Un grand sac de sport contenant un Bulldog, des chargeurs et une paire de lunettes thermiques."

/obj/item/storage/backpack/duffelbag/syndie/bulldogbundle/PopulateContents()
	new /obj/item/gun/ballistic/shotgun/bulldog(src)
	new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/clothing/glasses/thermal/syndi(src)

/obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle
	desc = "Un large sac de sport contenant un équipement médical, un LMG Donksoft, une grande boîte de fléchettes anti-émeute et de botte magnétique d'armureMOD."

/obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle/PopulateContents()
	new /obj/item/mod/module/magboot(src)
	new /obj/item/storage/medkit/tactical(src)
	new /obj/item/gun/ballistic/automatic/l6_saw/toy(src)
	new /obj/item/ammo_box/foambox/riot(src)

/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle
	desc = "Un large sac de sport contenant des produits chimiques mortels, un pulvérisateur chimique portatif, une grenade à mousse bioletale, un pistolet à seringue et un C-20r jouet."

/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle/PopulateContents()
	new /obj/item/reagent_containers/spray/chemsprayer/bioterror(src)
	new /obj/item/storage/box/syndie_kit/chemical(src)
	new /obj/item/gun/syringe/syndicate(src)
	new /obj/item/gun/ballistic/automatic/c20r/toy(src)
	new /obj/item/storage/box/syringes(src)
	new /obj/item/ammo_box/foambox/riot(src)
	new /obj/item/grenade/chem_grenade/bioterrorfoam(src)
	if(prob(5))
		new /obj/item/food/pizza/pineapple(src)

/obj/item/storage/backpack/duffelbag/syndie/c4/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/grenade/c4(src)

/obj/item/storage/backpack/duffelbag/syndie/x4/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/grenade/c4/x4(src)

/obj/item/storage/backpack/duffelbag/syndie/firestarter
	desc = "Un grand sac de sport contenant un pulvérisateur pyro, une armureMOD élite, un pistolet Stechkin APS, une minibombe, des munitions et d'autres équipements."

/obj/item/storage/backpack/duffelbag/syndie/firestarter/PopulateContents()
	new /obj/item/clothing/under/syndicate/soviet(src)
	new /obj/item/mod/control/pre_equipped/elite/flamethrower(src)
	new /obj/item/gun/ballistic/automatic/pistol/aps(src)
	new /obj/item/ammo_box/magazine/m9mm_aps/fire(src)
	new /obj/item/ammo_box/magazine/m9mm_aps/fire(src)
	new /obj/item/reagent_containers/cup/glass/bottle/vodka/badminka(src)
	new /obj/item/reagent_containers/hypospray/medipen/stimulants(src)
	new /obj/item/grenade/syndieminibomb(src)

// For ClownOps.
/obj/item/storage/backpack/duffelbag/clown/syndie/Initialize(mapload)
	. = ..()
	slowdown = 0
	atom_storage.silent = TRUE

/obj/item/storage/backpack/duffelbag/clown/syndie/PopulateContents()
	new /obj/item/modular_computer/pda/clown(src)
	new /obj/item/clothing/under/rank/civilian/clown(src)
	new /obj/item/clothing/shoes/clown_shoes(src)
	new /obj/item/clothing/mask/gas/clown_hat(src)
	new /obj/item/bikehorn(src)
	new /obj/item/implanter/sad_trombone(src)

/obj/item/storage/backpack/henchmen
	name = "ailes"
	desc = "Donné aux hommes de main qui le méritent. Cela ne vous inclut probablement pas."
	icon_state = "henchmen"
	inhand_icon_state = null

/obj/item/storage/backpack/duffelbag/cops
	name = "sac de police"
	desc = "Un large sac pour contenir des équipements de police supplémentaires."
	slowdown = 0

/obj/item/storage/backpack/duffelbag/mining_conscript
	name = "kit de conscription minière"
	desc = "Un kit contenant tout ce dont un membre d'équipage a besoin pour soutenir un mineur de fond en pleine nature."
	icon_state = "duffel-explorer"
	inhand_icon_state = "duffel-explorer"

/obj/item/storage/backpack/duffelbag/mining_conscript/PopulateContents()
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/t_scanner/adv_mining_scanner/lesser(src)
	new /obj/item/storage/bag/ore(src)
	new /obj/item/clothing/suit/hooded/explorer(src)
	new /obj/item/encryptionkey/headset_mining(src)
	new /obj/item/clothing/mask/gas/explorer(src)
	new /obj/item/card/id/advanced/mining(src)
	new /obj/item/gun/energy/recharge/kinetic_accelerator(src)
	new /obj/item/knife/combat/survival(src)
	new /obj/item/flashlight/seclite(src)
