/datum/crafting_recipe/durathread_vest
	name = "Veste en Fildurable"
	result = /obj/item/clothing/suit/armor/vest/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 5,
				/obj/item/stack/sheet/leather = 4)
	time = 5 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_helmet
	name = "Casque en Fildurable"
	result = /obj/item/clothing/head/helmet/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 4,
				/obj/item/stack/sheet/leather = 5)
	time = 4 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/fannypack
	name = "Banane"
	result = /obj/item/storage/belt/fannypack
	reqs = list(/obj/item/stack/sheet/cloth = 2,
				/obj/item/stack/sheet/leather = 1)
	time = 2 SECONDS
	category = CAT_CONTAINERS

/datum/crafting_recipe/hudsunsec
	name = "Lunettes de soleil ATH de sécurité"
	result = /obj/item/clothing/glasses/hud/security/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/security = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/hudsunsecremoval
	name = "Supprimeur d'ATH de sécurité"
	result = /obj/item/clothing/glasses/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/security/sunglasses = 1)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/hudsunmed
	name = "Lunettes de soleil ATH médicales"
	result = /obj/item/clothing/glasses/hud/health/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/health = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/hudsunmedremoval
	name = "Supprimeur d'ATH médical"
	result = /obj/item/clothing/glasses/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/health/sunglasses = 1)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/hudsundiag
	name = "Lunettes de soleil ATH de diagnostic"
	result = /obj/item/clothing/glasses/hud/diagnostic/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/diagnostic = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/hudsundiagremoval
	name = "Supprimeur d'ATH de diagnostic"
	result = /obj/item/clothing/glasses/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/diagnostic/sunglasses = 1)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/scienceglasses
	name = "Lunettes de science"
	result = /obj/item/clothing/glasses/sunglasses/chemical
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/science = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/scienceglassesremoval
	name = "Supprimeur de scanneur chimique"
	result = /obj/item/clothing/glasses/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/sunglasses/chemical = 1)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/ghostsheet
	name = "Déguisement de fantôme"
	result = /obj/item/clothing/suit/costume/ghost_sheet
	time = 0.5 SECONDS
	tool_behaviors = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/bedsheet = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/lizardboots
	name = "Botte en peau de lézard"
	result = /obj/effect/spawner/random/clothing/lizardboots
	reqs = list(/obj/item/stack/sheet/animalhide/lizard = 1, /obj/item/stack/sheet/leather = 1)
	time = 6 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/prisonsuit
	name = "Uniforme de prisonnier (combinaison)"
	result = /obj/item/clothing/under/rank/prisoner
	reqs = list(/obj/item/stack/sheet/cloth = 3, /obj/item/stack/license_plates = 1)
	time = 2 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/prisonskirt
	name = "Uniforme de prisonnier (jupe)"
	result = /obj/item/clothing/under/rank/prisoner/skirt
	reqs = list(/obj/item/stack/sheet/cloth = 3, /obj/item/stack/license_plates = 1)
	time = 2 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/prisonshoes
	name = "Chaussures de prisonnier orange"
	result = /obj/item/clothing/shoes/sneakers/orange
	reqs = list(/obj/item/stack/sheet/cloth = 2, /obj/item/stack/license_plates = 1)
	time = 1 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/tv_helmet
	name = "Casque de Télévision"
	result = /obj/item/clothing/head/costume/tv_head
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_CROWBAR)
	reqs = list(/obj/item/wallframe/status_display = 1)
	time = 2 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/lizardhat
	name = "Casque de Lézard"
	result = /obj/item/clothing/head/costume/lizard
	time = 1 SECONDS
	reqs = list(/obj/item/organ/external/tail/lizard = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/lizardhat_alternate
	name = "Chapeau de Lézard"
	result = /obj/item/clothing/head/costume/lizard
	time = 1 SECONDS
	reqs = list(/obj/item/stack/sheet/animalhide/lizard = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/kittyears
	name = "Oreilles de chat"
	result = /obj/item/clothing/head/costume/kitty/genuine
	time = 1 SECONDS
	reqs = list(
		/obj/item/organ/external/tail/cat = 1,
		/obj/item/organ/internal/ears/cat = 1,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/bonearmor
	name = "Armure d'os"
	result = /obj/item/clothing/suit/armor/bone
	time = 3 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 6)
	category = CAT_CLOTHING

/datum/crafting_recipe/bonetalisman
	name = "Talisman d'os"
	result = /obj/item/clothing/accessory/talisman
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sheet/bone = 2,
		/obj/item/stack/sheet/sinew = 1,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/bonecodpiece
	name = "Indice de crâne"
	result = /obj/item/clothing/accessory/skullcodpiece
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sheet/bone = 2,
		/obj/item/stack/sheet/animalhide/goliath_hide = 1,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/skilt
	name = "Kilt en tendon"
	result = /obj/item/clothing/accessory/skilt
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sheet/bone = 1,
		/obj/item/stack/sheet/sinew = 2,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/bracers
	name = "Bracelets d'os"
	result = /obj/item/clothing/gloves/bracer
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sheet/bone = 2,
		/obj/item/stack/sheet/sinew = 1,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/skullhelm
	name = "Casque en Crâne"
	result = /obj/item/clothing/head/helmet/skull
	time = 3 SECONDS
	reqs = list(/obj/item/stack/sheet/bone = 4)
	category = CAT_CLOTHING

/datum/crafting_recipe/goliathcloak
	name = "Cape de Goliath"
	result = /obj/item/clothing/suit/hooded/cloak/goliath
	time = 5 SECONDS
	reqs = list(
		/obj/item/stack/sheet/leather = 2,
		/obj/item/stack/sheet/sinew = 2,
		/obj/item/stack/sheet/animalhide/goliath_hide = 2,
	) //it takes 4 goliaths to make 1 cloak if the plates are skinned
	category = CAT_CLOTHING

/datum/crafting_recipe/drakecloak
	name = "Cape de Drake de Cendre"
	result = /obj/item/clothing/suit/hooded/cloak/drake
	time = 6 SECONDS
	reqs = list(
		/obj/item/stack/sheet/bone = 10,
		/obj/item/stack/sheet/sinew = 2,
		/obj/item/stack/sheet/animalhide/ashdrake = 5,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/godslayer
	name = "Armure de Tueur de Dieu"
	result = /obj/item/clothing/suit/hooded/cloak/godslayer
	time = 6 SECONDS
	reqs = list(
		/obj/item/ice_energy_crystal = 1,
		/obj/item/wendigo_skull = 1,
		/obj/item/clockwork_alloy = 1,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/mummy
	name = "Bandages de Mummification (Masque)"
	result = /obj/item/clothing/mask/mummy
	time = 1 SECONDS
	tool_paths = list(/obj/item/nullrod/egyptian)
	reqs = list(/obj/item/stack/sheet/cloth = 2)
	category = CAT_CLOTHING

/datum/crafting_recipe/mummy/body
	name = "Bandages de Mummification (Corps)"
	result = /obj/item/clothing/under/costume/mummy
	reqs = list(/obj/item/stack/sheet/cloth = 5)

/datum/crafting_recipe/chaplain_hood
	name = "Sweat à capuche de Fidèle"
	result = /obj/item/clothing/suit/hooded/chaplain_hoodie
	time = 1 SECONDS
	tool_paths = list(
		/obj/item/clothing/suit/hooded/chaplain_hoodie,
		/obj/item/storage/book/bible,
	)
	reqs = list(/obj/item/stack/sheet/cloth = 4)
	category = CAT_CLOTHING

/datum/crafting_recipe/flower_garland
	name = "Fleur de Garland"
	result = /obj/item/clothing/head/costume/garland
	time = 1 SECONDS
	reqs = list(
		/obj/item/food/grown/poppy = 4,
		/obj/item/food/grown/harebell = 4,
		/obj/item/food/grown/rose = 4,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/pillow_suit
	name = "Combinaison d'oreiller"
	result = /obj/item/clothing/suit/pillow_suit
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sticky_tape = 10,
		/obj/item/pillow = 5,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/pillow_hood
	name = "Capuche d'oreiller"
	result = /obj/item/clothing/head/pillow_hood
	tool_behaviors = list(TOOL_WIRECUTTER, TOOL_KNIFE)
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sticky_tape = 5,
		/obj/item/pillow = 1,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/sturdy_shako
	name = "Poignard solide"
	result = /obj/item/clothing/head/hats/hos/shako
	tool_behaviors = list(TOOL_WELDER, TOOL_KNIFE)
	time = 5 SECONDS
	reqs = list(
		/obj/item/clothing/head/hats/hos/cap = 1,
		/obj/item/stack/sheet/plasteel = 2, //Stout shako for two refined
		/obj/item/stack/sheet/mineral/gold = 2,
	)

	category = CAT_CLOTHING
