/obj/item/food/eggplantparm
	name = "Parmigiana d'aubergine"
	desc = "La seule bonne recette pour de l'aubergine."
	icon_state = "eggplantparm"

	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("d'aubergine" = 3, "de fromage" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/yakiimo
	name = "yaki imo"
	desc = "À base de patates douces rôties."
	icon_state = "yakiimo"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de patate douce" = 1)
	foodtypes = VEGETABLES | SUGAR
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/roastparsnip
	name = "panais rôti"
	desc = "Sucré et croquant."
	icon_state = "roastparsnip"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de panais" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

// Potatoes
/obj/item/food/tatortot
	name = "croquette de patate"
	desc = "Un gros morceau de pomme de terre frit, plus Américain que jamais."
	icon_state = "tatortot"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("de pomme de terre" = 3, "de valeur" = 1)
	foodtypes = FRIED | VEGETABLES
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/tatortot/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/mashed_potatoes
	name = "purée"
	desc = "Une portion crémeuse de purée de pommes de terre, parfait pour les flemmards."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "mashed_potatoes"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de purée de pommes de terre crémeuse" = 1, "d'ail" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/baked_potato
	name = "pomme de terre au four"
	desc = "Une pomme de terre bien chaude, cuite au four. Un peu fade en soi."
	icon_state = "baked_potato"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("de pomme de terre rotie" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/buttered_baked_potato
	name = "pomme de terre au four beurrée"
	desc = "Une pomme de terre au four bien chaude, agrémentée d'une tranche de beurre. La perfection."
	icon_state = "buttered_baked_potato"
	food_reagents = list(/datum/reagent/consumable/nutriment = 8, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("de pomme de terre cuite" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/loaded_baked_potato
	name = "pomme de terre au four garnie"
	desc = "Une pomme de terre au four bien chaude, dont l'intérieur a été découpé et mélangé à des morceaux de bacon, du fromage et du chou."
	icon_state = "loaded_baked_potato"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/vitamin = 6, /datum/reagent/consumable/nutriment/protein = 4)
	tastes = list("de pomme de terre cuite" = 1, "de bacon" = 1, "de fromage" = 1, "de chou" = 1)
	foodtypes = VEGETABLES | DAIRY | MEAT
	w_class = WEIGHT_CLASS_SMALL

// frites
/obj/item/food/fries
	name = "frites de l'espace"
	desc = "Comme il faut, créé par les Belges, conquis par les Français."
	icon_state = "frites"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("de frites" = 3, "de sel" = 1)
	foodtypes = VEGETABLES | FRIED
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/frites/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/cheesyfries
	name = "frites au fromage"
	desc = "Frites. Recouvertes de fromage. Duh."
	icon_state = "cheesyfries"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de frites" = 3, "de fromage" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cheesyfries/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/carrotfries
	name = "frites de carottes"
	desc = "De savoureuses frites à base de carottes fraîches."
	icon_state = "carrotfries"

	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("de carottes" = 3, "de sel" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/carrotfries/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/poutine
	name = "poutine"
	desc = "Frites recouvertes de fromage en grains et de sauce."
	icon_state = "poutine"
	food_reagents = list(/datum/reagent/consumable/nutriment = 7)
	tastes = list("de pomme de terre" = 3, "de sauce" = 1, "de fromage coulant" = 1)
	foodtypes = VEGETABLES | FRIED | MEAT
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/poutine/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)
