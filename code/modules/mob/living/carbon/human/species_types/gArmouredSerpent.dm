/datum/species/gas
	name = "\improper Giant Armoured Serpentid"
	plural_form = "GAS'es"
	id = SPECIES_GAS
	max_bodypart_count = 6
	var/datum/action/innate/chameleon_gas/chameleon_gas
	no_equip_flags = ITEM_SLOT_FEET
	species_traits = list(
		MUTCOLORS,
		EYECOLOR,
		NO_UNDERWEAR,
	)
	inherent_traits = list(
		TRAIT_CAN_USE_FLIGHT_POTION,
		TRAIT_TACKLING_TAILED_DEFENDER,
		TRAIT_RESISTHEAT,
	)
	mutanteyes = /obj/item/organ/internal/eyes/gas
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC
	ass_image = 'icons/ass/assgrey.png'
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/gas,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/gas,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/gas,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/gas,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/gas,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/gas,
	)

/datum/species/gas/pre_equip_species_outfit(datum/job/job, mob/living/carbon/human/equipping, visuals_only = FALSE)
	if(job?.gas_outfit)
		equipping.equipOutfit(job.gas_outfit, visuals_only)

/datum/species/gas/on_species_gain(mob/living/carbon/new_gasperson, datum/species/old_species, pref_load)
	. = ..()
	if(ishuman(new_gasperson))
		chameleon_gas = new
		chameleon_gas.Grant(new_gasperson)
		new_gasperson.move_resist = MOVE_FORCE_VERY_STRONG

/datum/species/gas/on_species_loss(mob/living/carbon/former_gasperson, datum/species/new_species, pref_load)
	if(chameleon_gas)
		chameleon_gas.Remove(former_gasperson)
		former_gasperson.move_resist = MOVE_FORCE_DEFAULT

	return ..()

/datum/action/innate/chameleon_gas
	name = "Adaptive Camouflage"
	var/cloaked = FALSE
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "gas-cloak-1"
	button_icon = 'icons/mob/actions/actions_gas.dmi'

/datum/action/innate/chameleon_gas/IsAvailable(feedback = FALSE)
	. = ..()

/datum/action/innate/chameleon_gas/proc/did_moved()
	var/mob/living/carbon/human/H = owner
	button_icon_state = "gas-cloak-1"
	build_all_button_icons()
	H.update_icons()
	H.dna.remove_mutation(/datum/mutation/human/chameleon)
	cloaked = FALSE

/datum/action/innate/chameleon_gas/Activate()
	var/mob/living/carbon/human/H = owner
	RegisterSignal(H, COMSIG_MOVABLE_MOVED, PROC_REF(did_moved))
	if (cloaked == FALSE)
		button_icon_state = "gas-cloak-2"
		build_all_button_icons()
		H.update_icons()
		cloaked = TRUE
		H.dna.add_mutation(/datum/mutation/human/chameleon, MUT_EXTRA, 0)
	else if (cloaked == TRUE)
		button_icon_state = "gas-cloak-1"
		build_all_button_icons()
		H.update_icons()
		H.dna.remove_mutation(/datum/mutation/human/chameleon)
		cloaked = FALSE
