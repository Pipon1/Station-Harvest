/datum/species/drone
	name = "Drone"
	id = SPECIES_DRONE
	species_traits = list(
		NO_DNA_COPY,
		NOTRANSSTING,
		EYECOLOR,
		HAIR,
		FACEHAIR,
		NO_UNDERWEAR,
	)
	inherent_traits = list(
		TRAIT_CAN_USE_FLIGHT_POTION,
		TRAIT_GENELESS,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NOBREATH,
		TRAIT_NOFIRE,
		TRAIT_NOHUNGER,
		TRAIT_NOMETABOLISM,
		TRAIT_EASILY_WOUNDED,
		TRAIT_PIERCEIMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHEAT,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_TOXIMMUNE,
	)

	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	mutanteyes = /obj/item/organ/internal/eyes/drone
	mutanttongue = /obj/item/organ/internal/tongue/robot
	mutantstomach = null
	mutantheart = null
	mutantliver = null
	mutantlungs = null
	exotic_blood = /datum/reagent/fuel //Liquid Electricity. fuck you think of something better gamer
	disliked_food = NONE
	liked_food = NONE
	wing_types = list(/obj/item/organ/external/wings/functional/robotic)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP
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

/datum/species/android/on_species_gain(mob/living/carbon/C)
	. = ..()
	// Androids don't eat, hunger or metabolise foods. Let's do some cleanup.
	C.set_safe_hunger_level()

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