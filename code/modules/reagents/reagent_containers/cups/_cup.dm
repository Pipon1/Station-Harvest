/obj/item/reagent_containers/cup
	name = "glass"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50)
	volume = 50
	reagent_flags = OPENCONTAINER | DUNKABLE
	spillable = TRUE
	resistance_flags = ACID_PROOF

	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'

	///Like Edible's food type, what kind of drink is this?
	var/drink_type = NONE
	///The last time we have checked for taste.
	var/last_check_time
	///How much we drink at once, shot glasses drink more.
	var/gulp_size = 5
	///Whether the 'bottle' is made of glass or not so that milk cartons dont shatter when someone gets hit by it.
	var/isGlass = FALSE

/obj/item/reagent_containers/cup/examine(mob/user)
	. = ..()
	if(drink_type)
		var/list/types = bitfield_to_list(drink_type, FOOD_FLAGS)
		. += span_notice("It is [lowertext(english_list(types))].")

/obj/item/reagent_containers/cup/proc/checkLiked(fraction, mob/M)
	if(last_check_time + 50 >= world.time)
		return
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(HAS_TRAIT(H, TRAIT_AGEUSIA))
		if(drink_type & H.dna.species.toxic_food)
			to_chat(H, span_warning("Vous ne vous sentez pas bien..."))
			H.adjust_disgust(25 + 30 * fraction)
	else
		if(drink_type & H.dna.species.toxic_food)
			to_chat(H,span_warning("C'est quoi cette merde ?!"))
			H.adjust_disgust(25 + 30 * fraction)
			H.add_mood_event("toxic_food", /datum/mood_event/disgusting_food)
		else if(drink_type & H.dna.species.disliked_food)
			to_chat(H,span_notice("ça n'avait pas très bon gout..."))
			H.adjust_disgust(11 + 15 * fraction)
			H.add_mood_event("gross_food", /datum/mood_event/gross_food)
		else if(drink_type & H.dna.species.liked_food)
			to_chat(H,span_notice("J'adore ce gout !"))
			H.adjust_disgust(-5 + -2.5 * fraction)
			H.add_mood_event("fav_food", /datum/mood_event/favorite_food)

	if((drink_type & BREAKFAST) && world.time - SSticker.round_start_time < STOP_SERVING_BREAKFAST)
		H.add_mood_event("breakfast", /datum/mood_event/breakfast)
	last_check_time = world.time

/obj/item/reagent_containers/cup/attack(mob/living/target_mob, mob/living/user, obj/target)
	if(!canconsume(target_mob, user))
		return

	if(!spillable)
		return

	if(!reagents || !reagents.total_volume)
		to_chat(user, span_warning("[src] est vide !"))
		return

	if(!istype(target_mob))
		return

	if(target_mob != user)
		target_mob.visible_message(span_danger("[user] essaye de nourrir [target_mob] avec quelque chose venant de [src]."), \
					span_userdanger("[user] essaie de vous nourir avec quelque chose venant de [src]."))
		if(!do_after(user, 3 SECONDS, target_mob))
			return
		if(!reagents || !reagents.total_volume)
			return // The drink might be empty after the delay, such as by spam-feeding
		target_mob.visible_message(span_danger("[user] nourrit [target_mob] avec quelque chose venant de [src]."), \
					span_userdanger("[user] essaie de vous nourrir avec quelque chose venant de [src]."))
		log_combat(user, target_mob, "fed", reagents.get_reagent_log_string())
	else
		to_chat(user, span_notice("Vous avalez une grosse gorgée de [src]."))

	SEND_SIGNAL(src, COMSIG_GLASS_DRANK, target_mob, user)
	var/fraction = min(gulp_size/reagents.total_volume, 1)
	reagents.trans_to(target_mob, gulp_size, transfered_by = user, methods = INGEST)
	checkLiked(fraction, target_mob)
	playsound(target_mob.loc,'sound/items/drink.ogg', rand(10,50), TRUE)
	if(!iscarbon(target_mob))
		return
	var/mob/living/carbon/carbon_drinker = target_mob
	var/list/diseases = carbon_drinker.get_static_viruses()
	if(!LAZYLEN(diseases))
		return
	var/list/datum/disease/diseases_to_add = list()
	for(var/datum/disease/malady as anything in diseases)
		if(malady.spread_flags & DISEASE_SPREAD_CONTACT_FLUIDS)
			diseases_to_add += malady
	if(LAZYLEN(diseases_to_add))
		AddComponent(/datum/component/infective, diseases_to_add)

/obj/item/reagent_containers/cup/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return

	. |= AFTERATTACK_PROCESSED_ITEM

	if(!check_allowed_items(target, target_self = TRUE))
		return

	if(!spillable)
		return

	if(target.is_refillable()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, span_warning("[src] est vide !"))
			return

		if(target.reagents.holder_full())
			to_chat(user, span_warning("[target] est plein."))
			return

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, span_notice("Vous transférez [trans] unitées de la solution dans [target]."))

	else if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, span_warning("[target] est vide et ne peut pas être re-remplie !"))
			return

		if(reagents.holder_full())
			to_chat(user, span_warning("[src] est plein."))
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, span_notice("Vous remplissez [src] avec [trans] unitées de [target]."))

	target.update_appearance()

/obj/item/reagent_containers/cup/afterattack_secondary(atom/target, mob/user, proximity_flag, click_parameters)
	if((!proximity_flag) || !check_allowed_items(target, target_self = TRUE))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!spillable)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, span_warning("[target] est vide !"))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		if(reagents.holder_full())
			to_chat(user, span_warning("[src] est plein."))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, span_notice("Vous remplissez [src] avec [trans] unitées de [target]."))

	target.update_appearance()
	return SECONDARY_ATTACK_CONTINUE_CHAIN

/obj/item/reagent_containers/cup/attackby(obj/item/attacking_item, mob/user, params)
	var/hotness = attacking_item.get_temperature()
	if(hotness && reagents)
		reagents.expose_temperature(hotness)
		to_chat(user, span_notice("Vous chauffez [name] avec [attacking_item] !"))
		return

	//Cooling method
	if(istype(attacking_item, /obj/item/extinguisher))
		var/obj/item/extinguisher/extinguisher = attacking_item
		if(extinguisher.safety)
			return
		if (extinguisher.reagents.total_volume < 1)
			to_chat(user, span_warning("Lae [extinguisher] est vide !"))
			return
		var/cooling = (0 - reagents.chem_temp) * extinguisher.cooling_power * 2
		reagents.expose_temperature(cooling)
		to_chat(user, span_notice("Vous refroidissez [name] avec [attacking_item] !"))
		playsound(loc, 'sound/effects/extinguish.ogg', 75, TRUE, -3)
		extinguisher.reagents.remove_all(1)
		return

	if(istype(attacking_item, /obj/item/food/egg)) //breaking eggs
		var/obj/item/food/egg/attacking_egg = attacking_item
		if(!reagents)
			return
		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, span_notice("[src] est plein."))
		else
			to_chat(user, span_notice("Vous cassez [attacking_egg] dans [src]."))
			attacking_egg.reagents.trans_to(src, attacking_egg.reagents.total_volume, transfered_by = user)
			qdel(attacking_egg)
		return

	return ..()

/*
 * On accidental consumption, make sure the container is partially glass, and continue to the reagent_container proc
 */
/obj/item/reagent_containers/cup/on_accidental_consumption(mob/living/carbon/M, mob/living/carbon/user, obj/item/source_item, discover_after = TRUE)
	if(isGlass && !custom_materials)
		set_custom_materials(list(GET_MATERIAL_REF(/datum/material/glass) = 5))//sets it to glass so, later on, it gets picked up by the glass catch (hope it doesn't 'break' things lol)
	return ..()

/// Callback for [datum/component/takes_reagent_appearance] to inherent style footypes
/obj/item/reagent_containers/cup/proc/on_cup_change(datum/glass_style/has_foodtype/style)
	if(!istype(style))
		return
	drink_type = style.drink_type

/// Callback for [datum/component/takes_reagent_appearance] to reset to no foodtypes
/obj/item/reagent_containers/cup/proc/on_cup_reset()
	drink_type = NONE

/obj/item/reagent_containers/cup/beaker
	name = "bécher"
	desc = "Un bécher. Il peut contenir jusqu'à 50 unitées."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "beaker"
	inhand_icon_state = "beaker"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	worn_icon_state = "beaker"
	custom_materials = list(/datum/material/glass=500)
	fill_icon_thresholds = list(0, 1, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/cup/beaker/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/reagent_containers/cup/beaker/get_part_rating()
	return reagents.maximum_volume

/obj/item/reagent_containers/cup/beaker/jar
	name = "Un pot de miel"
	desc = "Un pot de miel. Il peut contenir du miel."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "vapour"

/obj/item/reagent_containers/cup/beaker/large
	name = "Bécher large"
	desc = "Un large bécher. Il peut contenir jusqu'à 100 unitées."
	icon_state = "beakerlarge"
	custom_materials = list(/datum/material/glass=2500)
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100)
	fill_icon_thresholds = list(0, 1, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/cup/beaker/plastic
	name = "Bécher extra-large"
	desc = "Un bécher extra-large. Il peut contenir jusqu'à 120 unitées."
	icon_state = "beakerwhite"
	custom_materials = list(/datum/material/glass=2500, /datum/material/plastic=3000)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,60,120)
	fill_icon_thresholds = list(0, 1, 10, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/cup/beaker/meta
	name = "Bécher métamatériel"
	desc = "Un large bécher. Il peut contenir jusqu'à 180 unitées."
	icon_state = "beakergold"
	custom_materials = list(/datum/material/glass=2500, /datum/material/plastic=3000, /datum/material/gold=1000, /datum/material/titanium=1000)
	volume = 180
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,60,120,180)
	fill_icon_thresholds = list(0, 1, 10, 25, 35, 50, 60, 80, 100)

/obj/item/reagent_containers/cup/beaker/noreact
	name = "Bécher de cryostas"
	desc = "Un bécher de cryostas qui permet de stocker des liquides sans réactions. \
		Il peut contenir jusqu'à 50 unitées."
	icon_state = "beakernoreact"
	custom_materials = list(/datum/material/iron=3000)
	reagent_flags = OPENCONTAINER | NO_REACT
	volume = 50
	amount_per_transfer_from_this = 10

/obj/item/reagent_containers/cup/beaker/bluespace
	name = "Bécher bluespace"
	desc = "Un bécher bluespace, fonctionnant grace à une technologie bluespace expérimentale. Il peut contenir jusqu'à 300 unitées."
	icon_state = "beakerbluespace"
	custom_materials = list(/datum/material/glass = 5000, /datum/material/plasma = 3000, /datum/material/diamond = 1000, /datum/material/bluespace = 1000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100,300)

/obj/item/reagent_containers/cup/beaker/meta/omnizine
	list_reagents = list(/datum/reagent/medicine/omnizine = 180)

/obj/item/reagent_containers/cup/beaker/meta/sal_acid
	list_reagents = list(/datum/reagent/medicine/sal_acid = 180)

/obj/item/reagent_containers/cup/beaker/meta/oxandrolone
	list_reagents = list(/datum/reagent/medicine/oxandrolone = 180)

/obj/item/reagent_containers/cup/beaker/meta/pen_acid
	list_reagents = list(/datum/reagent/medicine/pen_acid = 180)

/obj/item/reagent_containers/cup/beaker/meta/atropine
	list_reagents = list(/datum/reagent/medicine/atropine = 180)

/obj/item/reagent_containers/cup/beaker/meta/salbutamol
	list_reagents = list(/datum/reagent/medicine/salbutamol = 180)

/obj/item/reagent_containers/cup/beaker/meta/rezadone
	list_reagents = list(/datum/reagent/medicine/rezadone = 180)

/obj/item/reagent_containers/cup/beaker/cryoxadone
	list_reagents = list(/datum/reagent/medicine/cryoxadone = 30)

/obj/item/reagent_containers/cup/beaker/sulfuric
	list_reagents = list(/datum/reagent/toxin/acid = 50)

/obj/item/reagent_containers/cup/beaker/slime
	list_reagents = list(/datum/reagent/toxin/slimejelly = 50)

/obj/item/reagent_containers/cup/beaker/large/libital
	name = "Réservoir de libital (dilué)"
	list_reagents = list(/datum/reagent/medicine/c2/libital = 10,/datum/reagent/medicine/granibitaluri = 40)

/obj/item/reagent_containers/cup/beaker/large/aiuri
	name = "Réservoir de aiuri (dilué)"
	list_reagents = list(/datum/reagent/medicine/c2/aiuri = 10, /datum/reagent/medicine/granibitaluri = 40)

/obj/item/reagent_containers/cup/beaker/large/multiver
	name = "Réservoir de multiver (dilué)"
	list_reagents = list(/datum/reagent/medicine/c2/multiver = 10, /datum/reagent/medicine/granibitaluri = 40)

/obj/item/reagent_containers/cup/beaker/large/epinephrine
	name = "Réservoir d'épinéphrine (dilué)"
	list_reagents = list(/datum/reagent/medicine/epinephrine = 50)

/obj/item/reagent_containers/cup/beaker/synthflesh
	list_reagents = list(/datum/reagent/medicine/c2/synthflesh = 50)

/obj/item/reagent_containers/cup/bucket
	name = "Seau"
	desc = "C'est un seau."
	icon = 'icons/obj/janitor.dmi'
	worn_icon = 'icons/mob/clothing/head/utility.dmi'
	icon_state = "bucket"
	inhand_icon_state = "bucket"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	greyscale_colors = "#0085e5" //matches 1:1 with the original sprite color before gag-ification.
	greyscale_config = /datum/greyscale_config/buckets
	greyscale_config_worn = /datum/greyscale_config/buckets_worn
	greyscale_config_inhand_left = /datum/greyscale_config/buckets_inhands_left
	greyscale_config_inhand_right = /datum/greyscale_config/buckets_inhands_right
	custom_materials = list(/datum/material/iron=200)
	w_class = WEIGHT_CLASS_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(5,10,15,20,25,30,50,70)
	volume = 70
	flags_inv = HIDEHAIR
	slot_flags = ITEM_SLOT_HEAD
	resistance_flags = NONE
	armor_type = /datum/armor/cup_bucket
	slot_equipment_priority = list( \
		ITEM_SLOT_BACK, ITEM_SLOT_ID,\
		ITEM_SLOT_ICLOTHING, ITEM_SLOT_OCLOTHING,\
		ITEM_SLOT_MASK, ITEM_SLOT_HEAD, ITEM_SLOT_NECK,\
		ITEM_SLOT_FEET, ITEM_SLOT_GLOVES,\
		ITEM_SLOT_EARS, ITEM_SLOT_EYES,\
		ITEM_SLOT_BELT, ITEM_SLOT_SUITSTORE,\
		ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET,\
		ITEM_SLOT_DEX_STORAGE
	)

/datum/armor/cup_bucket
	melee = 10
	fire = 75
	acid = 50

/obj/item/reagent_containers/cup/bucket/Initialize(mapload, vol)
	if(greyscale_colors == initial(greyscale_colors))
		set_greyscale(pick(list("#0085e5", COLOR_OFF_WHITE, COLOR_ORANGE_BROWN, COLOR_SERVICE_LIME, COLOR_MOSTLY_PURE_ORANGE, COLOR_FADED_PINK, COLOR_RED, COLOR_YELLOW, COLOR_VIOLET, COLOR_WEBSAFE_DARK_GRAY)))
	return ..()

/obj/item/reagent_containers/cup/bucket/wooden
	name = "Seau en bois"
	desc = "C'est un seau... mais en bois..."
	icon_state = "woodbucket"
	inhand_icon_state = "woodbucket"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 2)
	resistance_flags = FLAMMABLE
	armor_type = /datum/armor/bucket_wooden

/datum/armor/bucket_wooden
	melee = 10
	acid = 50

/obj/item/reagent_containers/cup/bucket/attackby(obj/O, mob/user, params)
	if(istype(O, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, span_warning("[src] n'a plus d'eau !"))
		else
			reagents.trans_to(O, 5, transfered_by = user)
			to_chat(user, span_notice("Vous aspergez [O] avec [src]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
		return
	else if(isprox(O)) //This works with wooden buckets for now. Somewhat unintended, but maybe someone will add sprites for it soon(TM)
		to_chat(user, span_notice("Vizs ajoutez [O] dans [src]."))
		qdel(O)
		var/obj/item/bot_assembly/cleanbot/new_cleanbot_ass = new(null, src)
		user.put_in_hands(new_cleanbot_ass)
		return

	return ..()

/obj/item/reagent_containers/cup/bucket/equipped(mob/user, slot)
	. = ..()
	if (slot & ITEM_SLOT_HEAD)
		if(reagents.total_volume)
			to_chat(user, span_userdanger("Le contenu de [src] se répend sur vous !"))
			reagents.expose(user, TOUCH)
			reagents.clear_reagents()
		reagents.flags = NONE

/obj/item/reagent_containers/cup/bucket/dropped(mob/user)
	. = ..()
	reagents.flags = initial(reagent_flags)

/obj/item/reagent_containers/cup/bucket/equip_to_best_slot(mob/M)
	if(reagents.total_volume) //If there is water in a bucket, don't quick equip it to the head
		var/index = slot_equipment_priority.Find(ITEM_SLOT_HEAD)
		slot_equipment_priority.Remove(ITEM_SLOT_HEAD)
		. = ..()
		slot_equipment_priority.Insert(index, ITEM_SLOT_HEAD)
		return
	return ..()

/obj/item/pestle
	name = "Pilon"
	desc = "Un ancien outil, efficace mais simple. Est utilisé avec un mortier pour broyer et presser des objets."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "pestle"
	force = 7

/obj/item/reagent_containers/cup/mortar
	name = "Mortier"
	desc = "Un bol spécéfiquement formé pour le broyage. Il est possible de broyer des objets placer dedans avec un pilon. Contrairement au méthode moderne, cette solution est lente et fatiguante."
	desc_controls = "Alt + clique pour éjecter l'objet."
	icon_state = "mortar"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50, 100)
	volume = 100
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT)
	resistance_flags = FLAMMABLE
	reagent_flags = OPENCONTAINER
	spillable = TRUE
	var/obj/item/grinded

/obj/item/reagent_containers/cup/mortar/AltClick(mob/user)
	if(grinded)
		grinded.forceMove(drop_location())
		grinded = null
		to_chat(user, span_notice("Vous éjectez l'objet."))

/obj/item/reagent_containers/cup/mortar/attackby(obj/item/I, mob/living/carbon/human/user)
	..()
	if(istype(I,/obj/item/pestle))
		if(grinded)
			if(user.getStaminaLoss() > 50)
				to_chat(user, span_warning("Vous êtes trop fatigué pour travailler !"))
				return
			var/list/choose_options = list(
				"Grind" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_grind"),
				"Juice" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_juice")
			)
			var/picked_option = show_radial_menu(user, src, choose_options, radius = 38, require_near = TRUE)
			if(grinded && in_range(src, user) && user.is_holding(I) && picked_option)
				to_chat(user, span_notice("Vous commencez à broyer..."))
				if(do_after(user, 25, target = src))
					user.adjustStaminaLoss(40)
					switch(picked_option)
						if("Juice") //prioritize juicing
							if(grinded.juice_results)
								grinded.on_juice()
								reagents.add_reagent_list(grinded.juice_results)
								to_chat(user, span_notice("Vous pressez [grinded]. Vous obtenez du liquide."))
								QDEL_NULL(grinded)
								return
							else
								grinded.on_grind()
								reagents.add_reagent_list(grinded.grind_results)
								if(grinded.reagents) //If grinded item has reagents within, transfer them to the mortar
									grinded.reagents.trans_to(src, grinded.reagents.total_volume, transfered_by = user)
								to_chat(user, span_notice("Vous essayez de presser [grinded] mais il n'y pas de liquide, a la place vous obtenez de la poudre."))
								QDEL_NULL(grinded)
								return
						if("Grind")
							if(grinded.grind_results)
								grinded.on_grind()
								reagents.add_reagent_list(grinded.grind_results)
								if(grinded.reagents) //If grinded item has reagents within, transfer them to the mortar
									grinded.reagents.trans_to(src, grinded.reagents.total_volume, transfered_by = user)
								to_chat(user, span_notice("Vous broyez [grinded] en une poudre."))
								QDEL_NULL(grinded)
								return
							else
								grinded.on_juice()
								reagents.add_reagent_list(grinded.juice_results)
								to_chat(user, span_notice("Vous essayez de broyer [grinded] mais directement iel se transforme en liquide."))
								QDEL_NULL(grinded)
								return
						else
							to_chat(user, span_notice("Vous essayez de broyer le mortier lui même à la place de [grinded]. Vous avez échoué."))
							return
			return
		else
			to_chat(user, span_warning("Il n'y a rien à broyer !"))
			return
	if(grinded)
		to_chat(user, span_warning("Il y'a deja quelque chose dedans !"))
		return
	if(I.juice_results || I.grind_results)
		I.forceMove(src)
		grinded = I
		return
	to_chat(user, span_warning("Vous ne pouvez pas broyer ça !"))

//Coffeepots: for reference, a standard cup is 30u, to allow 20u for sugar/sweetener/milk/creamer
/obj/item/reagent_containers/cup/coffeepot
	name = "Cafetière"
	desc = "Une grosse cafetière. Elle permet de distribuer l'ambrosie de la vie d'entreprise connu sous le nom de \"café\" auprès des mortels."
	volume = 120
	icon_state = "coffeepot"
	fill_icon_state = "coffeepot"
	fill_icon_thresholds = list(0, 1, 30, 60, 100)

/obj/item/reagent_containers/cup/coffeepot/bluespace
	name = "Cafetière bluespace"
	desc = "La cafetière la plus avancée que les intellos ont su créer : Une apparence simple mais raffinée, une connexion à une dimension de poche pour le stockage du café et sans oublier le stockage de 8 tasses à café. Ouais, cette machine incroyable à tout... Elle fait même le café."
	volume = 240
	icon_state = "coffeepot_bluespace"
	fill_icon_thresholds = list(0)
