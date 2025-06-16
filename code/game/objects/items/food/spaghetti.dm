///spaghetti prototype used by all subtypes
/obj/item/food/spaghetti
	icon = 'icons/obj/food/spaghetti.dmi'
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	foodtypes = GRAIN
	venue_value = FOOD_PRICE_CHEAP

// Why are you putting cooked spaghetti in your pockets?
/obj/item/food/spaghetti/make_microwaveable()
	var/list/display_message = list(
		span_notice("Quelque chose de mouillé tombe de sa poche et touche le sol. Est-ce que c'est... Des [name] ?"),
		span_warning("Oh, merde ! Tous tes [name] de poche son tombés !"))
	AddComponent(/datum/component/spill, display_message, 'sound/effects/splat.ogg', /datum/memory/lost_spaghetti)

	return ..()

/obj/item/food/spaghetti/raw
	name = "spaghettis"
	desc = "En voilà de bonnes pâtes !"
	icon_state = "spaghetti"
	tastes = list("de pâte" = 1)

/obj/item/food/spaghetti/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/spaghetti/boiledspaghetti, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/spaghetti/raw/make_microwaveable()
	AddElement(/datum/element/microwavable, /obj/item/food/spaghetti/boiledspaghetti)

/obj/item/food/spaghetti/boiledspaghetti
	name = "spaghettis cuites"
	desc = "Un simple plat de spaghettis, qui nécessite plus d'ingrédients."
	icon_state = "spaghettiboiled"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)

/obj/item/food/spaghetti/boiledspaghetti/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, null, CUSTOM_INGREDIENT_ICON_SCATTER, max_ingredients = 6)

/obj/item/food/spaghetti/pastatomato
	name = "spaghettis"
	desc = "Spaghettis et tomates écrasées. Comme à la maison !"
	icon_state = "pastatomato"
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/tomatojuice = 10,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de pâte" = 1, "de tomate" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/spaghetti/pastatomato/soulful
	name = "cuisine de l'âme"
	desc = "Comme le faisait maman."
	food_reagents = list(
		// same as normal pasghetti
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/tomatojuice = 10,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		// where the soul comes from
		/datum/reagent/pax = 5,
		/datum/reagent/medicine/psicodine = 10,
		/datum/reagent/medicine/morphine = 5,
	)
	tastes = list("de nostalgie" = 1, "de joie" = 1)

/obj/item/food/spaghetti/copypasta
	name = "copypasta"
	desc = "Vous ne devriez probablement pas essayer cela, vous entendez toujours les gens dire que c'est mauvais..."
	icon_state = "copypasta"
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/tomatojuice = 20,
		/datum/reagent/consumable/nutriment/vitamin = 8,
	)
	tastes = list("de pâte" = 1, "de tomate" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/spaghetti/meatballspaghetti
	name = "spaghettis et boulettes de viande"
	desc = "Voilà une belle boulette de viande !"
	icon_state = "meatballspaghetti"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de pâte" = 1, "de viande" = 1)
	foodtypes = GRAIN | MEAT

/obj/item/food/spaghetti/spesslaw
	name = "l'oie de l'espace"
	desc = "Le plat préféré des avocats."
	icon_state = "spesslaw"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 20,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de pâte" = 1, "de viande" = 1)
	foodtypes = GRAIN | MEAT

/obj/item/food/spaghetti/chowmein
	name = "chow mein"
	desc = "Un bon mélange de nouilles et de légumes frits."
	icon_state = "chowmein"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de nouille" = 1, "de viande" = 1, "de légumes frits" = 1)
	foodtypes = GRAIN | MEAT | VEGETABLES

/obj/item/food/spaghetti/beefnoodle
	name = "nouilles au bœuf"
	desc = "Nutritif, bovin et nouillesque."
	icon_state = "beefnoodle"
	trash_type = /obj/item/reagent_containers/cup/bowl
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/liquidgibs = 3,
	)
	tastes = list("de nouille" = 1, "de viande" = 1)
	foodtypes = GRAIN | MEAT | VEGETABLES

/obj/item/food/spaghetti/butternoodles
	name = "nouilles au beurre"
	desc = "Des nouilles recouvertes de beurre salé. Simple et glissant, mais délicieux."
	icon_state = "butternoodles"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 9,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de nouille" = 1, "de beurre" = 1)
	foodtypes = GRAIN | DAIRY

/obj/item/food/spaghetti/mac_n_cheese
	name = "mac n' cheese"
	desc = "Fabriqué dans les règles de l'art avec le fromage et la chapelure les plus fins. Voilà encore une horreur américaine."
	icon_state = "mac_n_cheese"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 9,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de fromage" = 1, "de chapelure" = 1, "de pâte" = 1)
	foodtypes = GRAIN | DAIRY
