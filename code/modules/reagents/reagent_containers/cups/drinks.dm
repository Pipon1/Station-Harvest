////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/cup/glass
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/drinks/drinks.dmi'
	icon_state = null
	possible_transfer_amounts = list(5,10,15,20,25,30,50)
	resistance_flags = NONE

	isGlass = TRUE


/obj/item/reagent_containers/cup/glass/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum, do_splash = TRUE)
	. = ..()
	if(!.) //if the bottle wasn't caught
		smash(hit_atom, throwingdatum?.thrower, TRUE)

/obj/item/reagent_containers/cup/glass/proc/smash(atom/target, mob/thrower, ranged = FALSE, break_top = FALSE)
	if(!isGlass)
		return
	if(QDELING(src) || !target) //Invalid loc
		return
	if(bartender_check(target) && ranged)
		return
	SplashReagents(target, ranged, override_spillable = TRUE)
	var/obj/item/broken_bottle/B = new (loc)
	B.mimic_broken(src, target, break_top)
	qdel(src)
	target.Bumped(B)

/obj/item/reagent_containers/cup/glass/bullet_act(obj/projectile/P)
	. = ..()
	if(QDELETED(src))
		return
	if(P.damage > 0 && P.damage_type == BRUTE)
		var/atom/T = get_turf(src)
		smash(T)


/obj/item/reagent_containers/cup/glass/trophy
	name = "Trophée pewter"
	desc = "Tout le monde doit obtenir un trophée."
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "pewter_cup"
	w_class = WEIGHT_CLASS_TINY
	force = 1
	throwforce = 1
	amount_per_transfer_from_this = 5
	custom_materials = list(/datum/material/iron=100)
	possible_transfer_amounts = list(5)
	volume = 5
	flags_1 = CONDUCT_1
	spillable = TRUE
	resistance_flags = FIRE_PROOF
	isGlass = FALSE

/obj/item/reagent_containers/cup/glass/trophy/gold_cup
	name = "Trophée en or"
	desc = "Vous êtes le gagnant !"
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "golden_cup"
	inhand_icon_state = "golden_cup"
	w_class = WEIGHT_CLASS_BULKY
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	custom_materials = list(/datum/material/gold=1000)
	volume = 150

/obj/item/reagent_containers/cup/glass/trophy/silver_cup
	name = "Trophée en argent"
	desc = "Le meilleur perdant !"
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "silver_cup"
	w_class = WEIGHT_CLASS_NORMAL
	force = 10
	throwforce = 8
	amount_per_transfer_from_this = 15
	custom_materials = list(/datum/material/silver=800)
	volume = 100


/obj/item/reagent_containers/cup/glass/trophy/bronze_cup
	name = "Trophée en bronze"
	desc = "Au moins vous êtes sur le podium !"
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "bronze_cup"
	w_class = WEIGHT_CLASS_SMALL
	force = 5
	throwforce = 4
	amount_per_transfer_from_this = 10
	custom_materials = list(/datum/material/iron=400)
	volume = 25

///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
// rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
// Formatting is the same as food.

/obj/item/reagent_containers/cup/glass/coffee
	name = "Café robuste"
	desc = "Attention, la boisson que vous vous apprêtez à boire est extrêment chaude."
	icon = 'icons/obj/drinks/coffee.dmi'
	icon_state = "coffee"
	base_icon_state = "coffee"
	list_reagents = list(/datum/reagent/consumable/coffee = 30)
	spillable = TRUE
	resistance_flags = FREEZE_PROOF
	isGlass = FALSE
	drink_type = BREAKFAST
	var/lid_open = 0

/obj/item/reagent_containers/cup/glass/coffee/no_lid
	icon_state = "coffee_empty"
	list_reagents = null

/obj/item/reagent_containers/cup/glass/coffee/examine(mob/user)
	. = ..()
	. += span_notice("Alt + clique pour enlever le couvercle.")
	return

/obj/item/reagent_containers/cup/glass/coffee/AltClick(mob/user)
	lid_open = !lid_open
	update_icon_state()
	return ..()

/obj/item/reagent_containers/cup/glass/coffee/update_icon_state()
	if(lid_open)
		icon_state = reagents.total_volume ? "[base_icon_state]_full" : "[base_icon_state]_empty"
	else
		icon_state = base_icon_state
	return ..()

/obj/item/reagent_containers/cup/glass/ice
	name = "Verre de glace"
	desc = "Attention, glace froide, ne pas manger."
	custom_price = PAYCHECK_LOWER * 0.6
	icon_state = "icecup"
	list_reagents = list(/datum/reagent/consumable/ice = 30)
	spillable = TRUE
	isGlass = FALSE

/obj/item/reagent_containers/cup/glass/ice/prison
	name = "Verre de glace sale"
	desc = "Soit l'eau potable de Nanotrasen est contaminée, soit cette machine en réalité vend des glaces au chocolat/citron/cerise."
	list_reagents = list(/datum/reagent/consumable/ice = 25, /datum/reagent/consumable/liquidgibs = 5)

/obj/item/reagent_containers/cup/glass/mug // parent type is literally just so empty mug sprites are a thing
	name = "Tasse"
	desc = "Une boisson servie dans une tasse classieuse."
	icon = 'icons/obj/drinks/coffee.dmi'
	icon_state = "tea_empty"
	base_icon_state = "tea"
	inhand_icon_state = "coffee"
	spillable = TRUE

/obj/item/reagent_containers/cup/glass/mug/update_icon_state()
	icon_state = "[base_icon_state][reagents.total_volume ? null : "_empty"]"
	return ..()

/obj/item/reagent_containers/cup/glass/mug/tea
	name = "Thé violet du duc"
	desc = "Une insulte à l'encontre du duc violet est une insulte à l'encontre de la reine de l'espace ! N'importe quel vrai gentil-homme vousaffrontera si vous dites du mal de ce thé."
	icon_state = "tea"
	list_reagents = list(/datum/reagent/consumable/tea = 30)

/obj/item/reagent_containers/cup/glass/mug/coco
	name = "Chocolat chaud hollandais"
	desc = "Fabriqué en amérique du sud de l'espace."
	icon_state = "tea"
	list_reagents = list(/datum/reagent/consumable/hot_coco = 15, /datum/reagent/consumable/sugar = 5)
	drink_type = SUGAR
	resistance_flags = FREEZE_PROOF
	custom_price = PAYCHECK_CREW * 1.2

/obj/item/reagent_containers/cup/glass/mug/nanotrasen
	name = "\improper Tasse Nanotrasen"
	desc = "Une tasse pour montrer vous fierté d'appartenance à la plus grande et meilleure des entreprises."
	icon_state = "mug_nt_empty"
	base_icon_state = "mug_nt"

/obj/item/reagent_containers/cup/glass/coffee_cup
	name = "Tasse à café"
	desc = "Une tasse à café en plastique. Peut aussi être utilisé pour d'autre boisson... Si vous vous sentez d'humeur aventureuse."
	icon = 'icons/obj/drinks/coffee.dmi'
	icon_state = "coffee_cup_e"
	base_icon_state = "coffee_cup"
	possible_transfer_amounts = list(10)
	volume = 30
	spillable = TRUE
	isGlass = FALSE

/obj/item/reagent_containers/cup/glass/coffee_cup/update_icon_state()
	icon_state = reagents.total_volume ? base_icon_state : "[base_icon_state]_e"
	return ..()

/obj/item/reagent_containers/cup/glass/dry_ramen
	name = "Ramen instantanée"
	desc = "Ajoutez 5ml d'eau. Un gout qui vous rappelle vos années d'étude. Maintenant avec un nouveau gout salé !"
	icon_state = "ramen"
	list_reagents = list(/datum/reagent/consumable/dry_ramen = 15, /datum/reagent/consumable/salt = 3)
	drink_type = GRAIN
	isGlass = FALSE
	custom_price = PAYCHECK_CREW * 0.9

/obj/item/reagent_containers/cup/glass/waterbottle
	name = "Bouteille d'eau"
	desc = "Une bouteille d'eau remplie dans une vieille usine sur la vieille terre."
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "smallbottle"
	inhand_icon_state = null
	list_reagents = list(/datum/reagent/water = 49.5, /datum/reagent/fluorine = 0.5)//see desc, don't think about it too hard
	custom_materials = list(/datum/material/plastic=1000)
	volume = 50
	amount_per_transfer_from_this = 10
	fill_icon_thresholds = list(0, 10, 25, 50, 75, 80, 90)
	isGlass = FALSE
	// The 2 bottles have separate cap overlay icons because if the bottle falls over while bottle flipping the cap stays fucked on the moved overlay
	var/cap_icon = 'icons/obj/drinks/drink_effects.dmi'
	var/cap_icon_state = "bottle_cap_small"
	var/cap_on = TRUE
	var/cap_lost = FALSE
	var/mutable_appearance/cap_overlay
	var/flip_chance = 10
	custom_price = PAYCHECK_LOWER * 0.8

/obj/item/reagent_containers/cup/glass/waterbottle/Initialize(mapload)
	. = ..()
	cap_overlay = mutable_appearance(cap_icon, cap_icon_state)
	if(cap_on)
		spillable = FALSE
		update_appearance()

/obj/item/reagent_containers/cup/glass/waterbottle/update_overlays()
	. = ..()
	if(cap_on)
		. += cap_overlay

/obj/item/reagent_containers/cup/glass/waterbottle/examine(mob/user)
	. = ..()
	if(cap_lost)
		. += span_notice("Le bouchon semble manquer.")
	else if(cap_on)
		. += span_notice("Le bouchon est fermement vissé pour empêcher toute éclaboussure. Alt + clique pour retirer le bouchon.")
	else
		. += span_notice("Le bouchon a été retiré. Alt + clique pour le remettre.")

/obj/item/reagent_containers/cup/glass/waterbottle/AltClick(mob/user)
	. = ..()
	if(cap_lost)
		to_chat(user, span_warning("Le bouchon semble manquer ! Mais où est-il allé ?"))
		return

	var/fumbled = HAS_TRAIT(user, TRAIT_CLUMSY) && prob(5)
	if(cap_on || fumbled)
		cap_on = FALSE
		spillable = TRUE
		animate(src, transform = null, time = 2, loop = 0)
		if(fumbled)
			to_chat(user, span_warning("Vous vous amusez avec le bouchon de lae [src] ! Le bouchon tombe par terre et... disparait sans un bruit. Mais putain il est allé où ?"))
			cap_lost = TRUE
		else
			to_chat(user, span_notice("Vous retirez le boucher de lae [src]."))
			playsound(loc, 'sound/effects/can_open1.ogg', 50, TRUE)
	else
		cap_on = TRUE
		spillable = FALSE
		to_chat(user, span_notice("Vous mettez le bouchon sur lae [src]."))
	update_appearance()

/obj/item/reagent_containers/cup/glass/waterbottle/is_refillable()
	if(cap_on)
		return FALSE
	return ..()

/obj/item/reagent_containers/cup/glass/waterbottle/is_drainable()
	if(cap_on)
		return FALSE
	return ..()

/obj/item/reagent_containers/cup/glass/waterbottle/attack(mob/target, mob/living/user, def_zone)
	if(!target)
		return

	if(cap_on && reagents.total_volume && istype(target))
		to_chat(user, span_warning("Vous devez retirer le bouchon avant de faire ça !"))
		return

	return ..()

/obj/item/reagent_containers/cup/glass/waterbottle/afterattack(obj/target, mob/living/user, proximity)
	. |= AFTERATTACK_PROCESSED_ITEM

	if(cap_on && (target.is_refillable() || target.is_drainable() || (reagents.total_volume && !user.combat_mode)))
		to_chat(user, span_warning("Vous devez retirer le bouchon avant de faire ça !"))
		return

	else if(istype(target, /obj/item/reagent_containers/cup/glass/waterbottle))
		var/obj/item/reagent_containers/cup/glass/waterbottle/other_bottle = target
		if(other_bottle.cap_on)
			to_chat(user, span_warning("[other_bottle] a le bouchon fermement attaché !"))
			return

	return . | ..()

// heehoo bottle flipping
/obj/item/reagent_containers/cup/glass/waterbottle/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(QDELETED(src))
		return
	if(!cap_on || !reagents.total_volume)
		return
	if(prob(flip_chance)) // landed upright
		src.visible_message(span_notice("[src] atterit droit !"))
		if(throwingdatum.thrower)
			var/mob/living/living_thrower = throwingdatum.thrower
			living_thrower.add_mood_event("bottle_flip", /datum/mood_event/bottle_flip)
	else // landed on it's side
		animate(src, transform = matrix(prob(50)? 90 : -90, MATRIX_ROTATE), time = 3, loop = 0)

/obj/item/reagent_containers/cup/glass/waterbottle/pickup(mob/user)
	. = ..()
	animate(src, transform = null, time = 1, loop = 0)

/obj/item/reagent_containers/cup/glass/waterbottle/empty
	list_reagents = list()
	cap_on = FALSE

/obj/item/reagent_containers/cup/glass/waterbottle/large
	desc = "Bouteille d'eau commercial"
	icon_state = "largebottle"
	custom_materials = list(/datum/material/plastic=3000)
	list_reagents = list(/datum/reagent/water = 100)
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100)
	cap_icon_state = "bottle_cap"

/obj/item/reagent_containers/cup/glass/waterbottle/large/empty
	list_reagents = list()
	cap_on = FALSE

// Admin spawn
/obj/item/reagent_containers/cup/glass/waterbottle/relic
	name = "Bouteille mystérieuse"
	desc = "Une bouteille assez similaire à une bouteille d'eau, mais avec des mots bizarre écrit dessus au stylo indélébile. Elle semble radier une mystérieuse énergie."
	flip_chance = 100 // FLIPP

/obj/item/reagent_containers/cup/glass/waterbottle/relic/Initialize(mapload)
	var/reagent_id = get_random_reagent_id()
	var/datum/reagent/random_reagent = new reagent_id
	list_reagents = list(random_reagent.type = 50)
	. = ..()
	desc += span_notice("L'écrit dit : '[random_reagent.name]'.")
	update_appearance()


/obj/item/reagent_containers/cup/glass/sillycup
	name = "Verre en polyester"
	desc = "Un verre en polyester."
	icon_state = "water_cup_e"
	possible_transfer_amounts = list(10)
	volume = 10
	spillable = TRUE
	isGlass = FALSE

/obj/item/reagent_containers/cup/glass/sillycup/update_icon_state()
	icon_state = reagents.total_volume ? "water_cup" : "water_cup_e"
	return ..()

/obj/item/reagent_containers/cup/glass/bottle/juice/smallcarton
	name = "Petit brique de boisson"
	desc = "Une petite brique, a utilisé pour stocker des boissons."
	icon = 'icons/obj/drinks/boxes.dmi'
	icon_state = "juicebox"
	volume = 15
	drink_type = NONE

/obj/item/reagent_containers/cup/glass/bottle/juice/smallcarton/Initialize(mapload, vol)
	. = ..()
	AddComponent( \
		/datum/component/takes_reagent_appearance, \
		on_icon_changed = CALLBACK(src, PROC_REF(on_cup_change)), \
		on_icon_reset = CALLBACK(src, PROC_REF(on_cup_reset)), \
		base_container_type = /obj/item/reagent_containers/cup/glass/bottle/juice/smallcarton, \
	)

/obj/item/reagent_containers/cup/glass/bottle/juice/smallcarton/smash(atom/target, mob/thrower, ranged = FALSE)
	if(bartender_check(target) && ranged)
		return
	SplashReagents(target, ranged, override_spillable = TRUE)
	var/obj/item/broken_bottle/bottle_shard = new (loc)
	bottle_shard.mimic_broken(src, target)
	qdel(src)
	target.Bumped(bottle_shard)

/obj/item/reagent_containers/cup/glass/colocup
	name = "Verre de fête"
	desc = "Un  verre peu cher, produit en masse. Généralement utilisé dans des fêtes. Ils ne semblent jamais être produit en rouge..."
	icon = 'icons/obj/drinks/colo.dmi'
	icon_state = "colocup"
	inhand_icon_state = "colocup"
	custom_materials = list(/datum/material/plastic = 1000)
	possible_transfer_amounts = list(5, 10, 15, 20)
	volume = 20
	amount_per_transfer_from_this = 5
	isGlass = FALSE
	/// Allows the lean sprite to display upon crafting
	var/random_sprite = TRUE

/obj/item/reagent_containers/cup/glass/colocup/Initialize(mapload)
	. = ..()
	pixel_x = rand(-4,4)
	pixel_y = rand(-4,4)
	if(!random_sprite)
		return
	icon_state = "colocup[rand(0, 6)]"
	if(icon_state == "colocup6")
		desc = "Un  verre peu cher, produit en masse. Généralement utilisé dans des fêtes. Woah, celui ci est rouge ! Improbable mais très très cool."

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
// itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
// icon states.

/obj/item/reagent_containers/cup/glass/shaker
	name = "Mélanger"
	desc = "Un mélangeur en métal pour mélanger des boissons."
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "shaker"
	custom_materials = list(/datum/material/iron=1500)
	amount_per_transfer_from_this = 10
	volume = 100
	isGlass = FALSE

/obj/item/reagent_containers/cup/glass/shaker/Initialize(mapload)
	. = ..()
	if(prob(10))
		name = "\improper Mélangeur des 20 années d'anniversaire de Nanotrasen"
		desc += "Il y'a le logo de Nanotrasen gravé dessus."
		icon_state = "shaker_n"

/obj/item/reagent_containers/cup/glass/flask
	name = "Flasque"
	desc = "N'importe quel habitué de l'espace sait que c'est une bonne idée d'amener quelques verres de whisky partout où il va."
	custom_price = PAYCHECK_COMMAND * 2
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "flask"
	custom_materials = list(/datum/material/iron=250)
	volume = 60
	isGlass = FALSE

/obj/item/reagent_containers/cup/glass/flask/gold
	name = "Flasque du capitaine"
	desc = "Une flasque en or apartenant au capitaine."
	icon_state = "flask_gold"
	custom_materials = list(/datum/material/gold=500)

/obj/item/reagent_containers/cup/glass/flask/det
	name = "Flasque du détective"
	desc = "Le seul ami du détective."
	icon_state = "detflask"
	list_reagents = list(/datum/reagent/consumable/ethanol/whiskey = 30)

/obj/item/reagent_containers/cup/glass/flask/det/minor
	list_reagents = list(/datum/reagent/consumable/applejuice = 30)

/obj/item/reagent_containers/cup/glass/mug/britcup
	name = "Verre"
	desc = "Un  verre avec le drapeau britanique gravé dessus."
	icon = 'icons/obj/drinks/coffee.dmi'
	icon_state = "britcup_empty"
	base_icon_state = "britcup"
	volume = 30
	spillable = TRUE
