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
		TRAIT_NOCLONELOSS,
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
		TRAIT_NOBLOOD,
	)

	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	mutanteyes = /obj/item/organ/internal/eyes/drone
	mutanttongue = /obj/item/organ/internal/tongue/robot
	mutantstomach = null
	mutantheart = null
	mutantliver = null
	mutantlungs = null
	wing_types = list(/obj/item/organ/external/wings/functional/robotic)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	payday_modifier = 0.5

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/drone,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/drone,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/drone,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/drone,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/drone,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/drone,
	)
	examine_limb_id = SPECIES_HUMAN

/datum/species/android/on_species_gain(mob/living/carbon/C)
	. = ..()
	// Androids don't eat, hunger or metabolise foods. Let's do some cleanup.
	C.set_safe_hunger_level()
