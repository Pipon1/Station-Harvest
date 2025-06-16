//this category is very little but I think that it has great potential to grow
////////////////////////////////////////////SALAD////////////////////////////////////////////
/obj/item/food/salad
	icon = 'icons/obj/food/soupsalad.dmi'
	trash_type = /obj/item/reagent_containers/cup/bowl
	bite_consumption = 3
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("de feuilles" = 1)
	foodtypes = VEGETABLES
	eatverbs = list("aspire", "mange", "avale", "déguste", "boit") //who the fuck gnaws and devours on a salad
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/salad/aesirsalad
	name = "\improper salade Aesir"
	desc = "Probablement trop formidable pour que des mortels l'apprécie à sa juste valeur."
	icon_state = "aesirsalad"
	food_reagents = list(/datum/reagent/consumable/nutriment = 8, /datum/reagent/consumable/nutriment/vitamin = 12)
	tastes = list("de feuilles" = 1)
	foodtypes = VEGETABLES | FRUIT

/obj/item/food/salad/herbsalad
	name = "salade d'herbes"
	desc = "Une salade goûtue avec des morceaux de pommes sur le dessus."
	icon_state = "herbsalad"
	food_reagents = list(/datum/reagent/consumable/nutriment = 8, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("de feuilles" = 1, "de pomme" = 1)
	foodtypes = VEGETABLES | FRUIT

/obj/item/food/salad/validsalad
	name = "salade réglementaire"
	desc = "Juste une salade aux herbes avec des boulettes de viande et des frites. Rien de suspect."
	icon_state = "validsalad"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/doctor_delight = 8, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("de feuilles" = 1, "de pommes de terre" = 1, "de viande" = 1)
	foodtypes = VEGETABLES | MEAT | FRIED | FRUIT

/obj/item/food/salad/fruit
	name = "salade de fruits"
	desc = "Jolie jolie."
	icon_state = "fruitsalad"
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("d'orange" = 1, "de pomme" = 1, "de raisins" = 1, "de pastèque" = 2)
	foodtypes = FRUIT

/obj/item/food/salad/jungle
	name = "salade de fuits exotiques"
	desc = "Des fruits 'exotiques' coupés, dans un bol."
	icon_state = "junglesalad"
	food_reagents = list(/datum/reagent/consumable/nutriment = 11, /datum/reagent/consumable/banana = 5, /datum/reagent/consumable/nutriment/vitamin = 7)
	tastes = list("de banane" = 2, "de pomme" = 1, "de raisins" = 1, "de pastèque" = 2)
	foodtypes = FRUIT

/obj/item/food/salad/citrusdelight
	name = "salade d'agrumes"
	desc = "Attaque d'agrumes !"
	icon_state = "citrusdelight"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/vitamin = 7,
	)
	tastes = list("d'acidité" = 2, "d'orange" = 1, "de citron" = 1, "de citron vert" = 1)
	foodtypes = FRUIT | ORANGES

/obj/item/food/uncooked_rice
	name = "riz cru" //French's edit : Pourquoi c'est là ça ?
	desc = "Un tas de riz cru."
	icon_state = "uncooked_rice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("de riz cru" = 1)
	foodtypes = GRAIN | RAW

/obj/item/food/uncooked_rice/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/boiledrice, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/uncooked_rice/make_microwaveable()
	AddElement(/datum/element/microwavable, /obj/item/food/boiledrice)

/obj/item/food/boiledrice
	name = "riz cuit" //French's edit : Pourquoi c'est là ça bis ?
	desc = "Un bol fumant de riz cuit. Un peu fade en lui même, mais la base d'une infinité de plats délicieux..."
	icon_state = "cooked_rice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de riz" = 1)
	foodtypes = GRAIN | BREAKFAST

/obj/item/food/salad/ricepudding
	name = "riz au lait"
	desc = "Tout le monde aime le riz au lait !"
	icon_state = "ricepudding"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de riz" = 1, "de sucré" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/salad/ricepork
	name = "riz et porc"
	desc = "Au moins ça ressemble à du porc..."
	icon_state = "riceporkbowl"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de riz" = 1, "de viande" = 1)
	foodtypes = GRAIN | MEAT

/obj/item/food/salad/risotto
	name = "risotto"
	desc = "La preuve que les italiens maitrisent tous les types de féculents."
	icon_state = "risotto"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de riz" = 1, "de fromage" = 1, "de champignons" = 1)
	foodtypes = GRAIN | DAIRY
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/salad/eggbowl
	name = "bol d'oeufs"
	desc = "Un boc avec du riz, des oeufs brouillés et un peu de légumes."
	icon_state = "eggbowl"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de riz" = 1, "d'oeuf" = 1, "de carotte" = 1, "de maïs" = 1)
	foodtypes = GRAIN | MEAT //EGG = MEAT -NinjaNomNom 2017

/obj/item/food/salad/edensalad
	name = "\improper Salade d'Eden"
	desc = "Une salade pleine de potentiel inexploité."
	icon_state = "edensalad"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 7,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("d'amertume extrème" = 3, "d'espoir" = 1)
	foodtypes = VEGETABLES

/obj/item/food/salad/gumbo
	name = "doliques à oeil noir"
	desc = "Un savoureux plat épicié à base viande et de riz."
	icon_state = "gumbo"
	food_reagents = list(
		/datum/reagent/consumable/capsaicin = 2,
		/datum/reagent/consumable/nutriment/vitamin = 3,
		/datum/reagent/consumable/nutriment = 5,
	)
	tastes = list("de piment" = 2, "de viande" = 1, "de pois" = 1, "d'épice" = 1)
	foodtypes = GRAIN | MEAT | VEGETABLES

/obj/item/reagent_containers/cup/bowl
	name = "bol"
	desc = "Un bol. Avec du bol, vous pouvez l'utiliser pour des soupes ou des salades."
	icon = 'icons/obj/food/soupsalad.dmi'
	icon_state = "bowl"
	base_icon_state = "bowl"
	reagent_flags = OPENCONTAINER | DUNKABLE
	custom_materials = list(/datum/material/glass = 500)
	w_class = WEIGHT_CLASS_NORMAL
	custom_price = PAYCHECK_CREW * 0.6
	fill_icon_thresholds = list(0)
	fill_icon_state = "fullbowl"
	fill_icon = 'icons/obj/food/soupsalad.dmi'

	volume = SOUP_SERVING_SIZE + 5
	gulp_size = 3

/obj/item/reagent_containers/cup/bowl/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_PARENT_REAGENT_EXAMINE, PROC_REF(reagent_special_examine))
	AddElement(/datum/element/foodlike_drink)
	AddComponent(/datum/component/customizable_reagent_holder, /obj/item/food/salad/empty, CUSTOM_INGREDIENT_ICON_FILL, max_ingredients = 6)
	AddComponent( \
		/datum/component/takes_reagent_appearance, \
		on_icon_changed = CALLBACK(src, PROC_REF(on_cup_change)), \
		on_icon_reset = CALLBACK(src, PROC_REF(on_cup_reset)), \
		base_container_type = /obj/item/reagent_containers/cup/bowl, \
	)

/obj/item/reagent_containers/cup/bowl/on_cup_change(datum/glass_style/style)
	. = ..()
	fill_icon_thresholds = null

/obj/item/reagent_containers/cup/bowl/on_cup_reset()
	. = ..()
	fill_icon_thresholds ||= list(0)

/**
 * Override standard reagent examine
 * so that anyone examining a bowl of soup sees the soup but nothing else (unless they have sci goggles)
 */
/obj/item/reagent_containers/cup/bowl/proc/reagent_special_examine(datum/source, mob/user, list/examine_list, can_see_insides = FALSE)
	SIGNAL_HANDLER

	if(can_see_insides || reagents.total_volume <= 0)
		return

	var/unknown_volume = 0
	var/list/soups_found = list()
	for(var/datum/reagent/current_reagent as anything in reagents.reagent_list)
		if(istype(current_reagent, /datum/reagent/consumable/nutriment/soup))
			soups_found += "&bull; [round(current_reagent.volume, 0.01)] unités de [current_reagent.name]"
		else
			unknown_volume += current_reagent.volume

	if(!length(soups_found))
		// There was no soup in the pot, do normal examine
		return

	examine_list += "À l'intérieur, vous pouvez voir :"
	examine_list += soups_found
	if(unknown_volume > 0)
		examine_list += "&bull; [round(unknown_volume, 0.01)] unités de réactifs inconnus."

	return STOP_GENERIC_REAGENT_EXAMINE

// empty salad for custom salads
/obj/item/food/salad/empty
	name = "salade"
	foodtypes = NONE
	tastes = list()
	icon_state = "bowl"
	desc = "Une délicieuse salade personnalisée."

/obj/item/food/salad/kale_salad
	name = "salade de chou"
	desc = "Une salade bonne pour la santé avec un filet d'huile, parfaite pour les chauds mois d'été."
	icon_state = "kale_salad"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 12,
		/datum/reagent/consumable/nutriment = 12,
	)
	tastes = list("d'oignon rouge" = 2, "de carotte" = 1, "de chou" = 1, "d'huile" = 1)
	foodtypes = VEGETABLES

/obj/item/food/salad/greek_salad
	name = "salade grecque"
	desc = "Une salade répendue faite avec des tomates, des oignons, de la feta et des olives, le tout relevé avec de l'huile d'olive. Mais on dirait qu'il manque quelque chose..."
	icon_state = "greek_salad"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 13,
		/datum/reagent/consumable/nutriment = 14,
	)
	tastes = list("d'olive" = 1, "de tomate" = 1, "d'oignon rouge" = 2, "de feta" = 2, "d'huile d'olive" = 3)
	foodtypes = VEGETABLES | DAIRY

/obj/item/food/salad/caesar_salad
	name = "salade césar"
	desc = "Une simple mais savoureuse salade avec de l'oignon, de la salade, des croutons et du fromage, le tout relevé avec de l'huile. Vient avec sa tranche de pain pita !"
	icon_state = "caesar_salad"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 12,
		/datum/reagent/consumable/nutriment = 12,
	)
	tastes = list("de salade" = 2, "d'oignon rouge" = 2, "de parmesan" = 2, "d'huile" = 1, "de pain pita" = 1)
	foodtypes = VEGETABLES | DAIRY | GRAIN

/obj/item/food/salad/spring_salad
	name = "salade de printemps"
	desc = "Une salade toute simple avec des carottes, de la laitue et des pois, relevée avec du sel et un filet d'huile d'olive."
	icon_state = "spring_salad"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 12,
		/datum/reagent/consumable/nutriment = 12,
	)
	tastes = list("de végétaux croquants" = 2, "d'huile d'olive" = 2, "de sel" = 1)
	foodtypes = VEGETABLES

/obj/item/food/salad/potato_salad
	name = "salade de pommes de terre"
	desc = "Une salade de pommes de terre à la valeur avec des oeufs brouillés, de l'oignon et de la mayonnaise."
	icon_state = "potato_salad"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 12,
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/protein = 4,
	)
	tastes = list("de pommes de terre fondantes" = 2, "d'oeufs" = 2, "de mayonnaise" = 1, "d'oignons" = 1)
	foodtypes = VEGETABLES | BREAKFAST

/obj/item/food/salad/spinach_fruit_salad
	name = "salade d'épinards et de fruits"
	desc = "Une salade d'épinards, de baies et de morceaux d'ananas avec de l'huile d'olive. Miam !"
	icon_state = "spinach_fruit_salad"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 12,
		/datum/reagent/consumable/nutriment = 12,
	)
	tastes = list("d'épinards" = 2, "de baies" = 2, "d'ananas" = 2, "d'huile d'olive" = 1)
	foodtypes = VEGETABLES | FRUIT

/obj/item/food/salad/antipasto_salad
	name = "salade antipasto"
	desc = "Une salade italienne traditionnelle avec du saucisson, de la mozzarella, des olives et des tomates. Souvent servie en entrée."
	icon_state = "antipasto_salad"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 12,
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/protein = 6,
	)
	tastes = list("de laitue" = 2, "de saucisson" = 2, "de mozzarella" = 2, "de tomate" = 2, "d'olive" = 1)
	foodtypes = VEGETABLES | DAIRY | MEAT
