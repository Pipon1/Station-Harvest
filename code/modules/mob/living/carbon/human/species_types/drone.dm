/datum/species/drone
	name = "Drone"
	id = SPECIES_DRONE
	species_traits = list(
		NO_DNA_COPY,
		EYECOLOR,
		HAIR,
		FACEHAIR,
		NO_UNDERWEAR,
	)
	inherent_traits = list(
		TRAIT_CAN_USE_FLIGHT_POTION,
		TRAIT_GENELESS,
		TRAIT_EASYDISMEMBER,
		TRAIT_NOBREATH,
		TRAIT_NOFIRE,
		TRAIT_EASILY_WOUNDED,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHEAT,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_TOXIMMUNE,
	)

	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	meat = null
	mutanteyes = /obj/item/organ/internal/eyes/drone
	mutanttongue = /obj/item/organ/internal/tongue/robot
	mutantstomach = /obj/item/organ/internal/stomach/drone
	mutantheart = /obj/item/organ/internal/heart/cybernetic
	mutantliver = /obj/item/organ/internal/liver/cybernetic
	mutantlungs = /obj/item/organ/internal/lungs/cybernetic
	exotic_blood = /datum/reagent/fuel/oil //À voir entre ça ou welding fuel
	exotic_bloodtype = "AAA"
	disliked_food = NONE
	liked_food = NONE
	wing_types = list(/obj/item/organ/external/wings/functional/robotic)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP
	siemens_coeff = 1.5 //They're vulnerable to energy
	brutemod = 1.25 //They're weak to punches
	payday_modifier = 0.5

	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/drone,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/drone,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/drone,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/drone,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/drone,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/drone,
	)
	examine_limb_id = SPECIES_DRONE

/datum/species/drone/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "bolt",
			SPECIES_PERK_NAME = "Shockingly Tasty",
			SPECIES_PERK_DESC = "Drones can feed on electricity from APCs, and do not otherwise need to eat.",
		),
	)

	return to_add

/datum/species/drone/get_species_description()
	return "A drone, or an android, what you prefer \
		They are mainly here for manual labor, they are fragile and mass-produced."

/datum/species/drone/get_species_lore()
	return list(
		"Drones were created to make what humans didn't wanted to. \
		They were clearly manufactured to do most of the dirty jobs or manual labor. \
		Those who worked those positions hated them for taking their jobs, \
		and the others just saw them as nothing but repleacable cheap tools."
	)