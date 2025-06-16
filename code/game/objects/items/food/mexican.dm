/obj/item/food/tortilla
	name = "tortilla"
	desc = "La base de tous vos burritos."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "tortilla"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("tortilla" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/tortilla/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/hard_taco_shell, rand(15 SECONDS, 30 SECONDS), TRUE, TRUE)

/obj/item/food/burrito
	name = "burrito"
	desc = "Une tortilla pleine de bonnes choses."
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "burrito"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de tortilla" = 2, "de haricot" = 3)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/cheesyburrito
	name = "burrito au fromage"
	desc = "Un burrito avec du fromage."
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "cheesyburrito"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de tortilla" = 2, "de haricots" = 3, "de fromage" = 1)
	foodtypes = GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/carneburrito
	name = "carne asada burrito"
	desc = "Le burrito préféré de ceux qui aiment la viande."
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "carneburrito"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de tortilla" = 2, "de viande" = 4)
	foodtypes = GRAIN | MEAT
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/fuegoburrito
	name = "fuego plasma burrito"
	desc = "Un burrito super épicé"
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "fuegoburrito"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/capsaicin = 5,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de tortilla" = 2, "de haricots" = 3, "de piment" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_LEGENDARY

/obj/item/food/nachos
	name = "nachos"
	desc = "Des chips du Néo-Mexique."
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "nachos"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de nachos" = 1)
	foodtypes = GRAIN | FRIED
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cheesynachos
	name = "nachos au fromage"
	desc = "Une délicieuse combinaison de nachos et de fromage fondu."
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "cheesynachos"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de nachos" = 2, "de fromage" = 1)
	foodtypes = GRAIN | FRIED | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/cubannachos
	name = "nachos cubain"
	desc = "Des nachos dangereusement épicés."
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "cubannachos"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 7,
		/datum/reagent/consumable/capsaicin = 8,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de nachos" = 2, "de piment" = 1)
	foodtypes = VEGETABLES | FRIED | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/taco
	name = "taco classique"
	desc = "Un taco traditionnel, avec de la viande, du fromage et de la salade."
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "taco"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de taco" = 4, "de viande" = 2, "de fromage" = 2, "de salade" = 1)
	foodtypes = MEAT | DAIRY | GRAIN | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/taco/plain
	name = "taco simple"
	desc = "Un taco traditionnel avec de la viande et du fromage, mais sans crudités."
	icon_state = "taco_plain"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de taco" = 4, "de viande" = 2, "de fromage" = 2)
	foodtypes = MEAT | DAIRY | GRAIN
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/taco/fish
	name = "taco au poisson"
	desc = "Un taco avec du poisson, du fromage et du chou."
	icon_state = "fishtaco"
	tastes = list("de taco" = 4, "de poisson" = 2, "de fromage" = 2, "de chou" = 1)
	foodtypes = SEAFOOD | DAIRY | GRAIN | VEGETABLES

/obj/item/food/enchiladas
	name = "enchiladas"
	desc = "¡ Viva La Mexico !"
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "enchiladas"
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/capsaicin = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de piment" = 1, "de viande" = 3, "de fromage" = 1, "de crème sure" = 1)
	foodtypes = MEAT | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/stuffedlegion
	name = "legion farcie"
	desc = "L'ex-crane d'un humain damné, farci de viande de goliath. Accompagné de sa fondaine de lave décorative, faite avec du ketchup et de la sauce piquante."
	icon_state = "stuffed_legion"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/capsaicin = 2,
	)
	tastes = list("de la mort" = 2, "de cailloux" = 1, "de viande" = 1, "de piment" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_LEGENDARY

/obj/item/food/chipsandsalsa
	name = "chips et sauce"
	desc = "Des chips de tortilla avec une coupelle de sauce piquante. Extrêmement addictif !"
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "chipsandsalsa"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/capsaicin = 2,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de poivre" = 1, "de sauce" = 3, "de chips de tortilla" = 1, "d'oignon" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/classic_chimichanga
	name = "chimichanga classique"
	desc = "Un burrito fri, généreusement farci de viande et de fromage."
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "classic_chimichanga"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/nutriment/protein = 6,
	)
	tastes = list("de tortilla frie" = 1, "de viande" = 3, "de fromage" = 1, "d'oignon" = 1)
	foodtypes = MEAT | GRAIN | VEGETABLES | DAIRY | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/vegetarian_chimichanga
	name = "chimichanga végétarien"
	desc = "Un burrito frit, généreusement farci de légumes rôtis, pour les végétariens."
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "vegetarian_chimichanga"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("de tortilla frie" = 1, "de chou" = 3, "d'oignon" = 1, "de poivre" = 1)
	foodtypes = GRAIN | VEGETABLES | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/hard_taco_shell
	name = "coquille de taco"
	desc = "Une coquille de taco, qui n'attend que d'être remplie d'ingrédients. Utilisez un ingrédient dessus pour commencer à faire des tacos personnalisés !"
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "hard_taco_shell"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("de croquille de taco" = 1)
	foodtypes = GRAIN | FRIED
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/hard_taco_shell/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, /obj/item/food/hard_taco_shell/empty, CUSTOM_INGREDIENT_ICON_FILL, max_ingredients = 6)

// empty taco shell for custom tacos
/obj/item/food/hard_taco_shell/empty
	name = "coquille de taco"
	foodtypes = NONE
	tastes = list()
	icon_state = "hard_taco_shell"
	desc = "Une coquille de taco vide."

/obj/item/food/classic_hard_shell_taco
	name = "taco à coque dure classique"
	desc = "Un taco dur classique, la bouchée la plus satisfaisante de la galaxie."
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "classic_hard_shell_taco"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/nutriment/protein = 6,
	)
	tastes = list("de taco croustillant" = 1, "de chou" = 3, "de tomate" = 1, "de viande hachée" = 1, "de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | MEAT | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/plain_hard_shell_taco
	name = "taco à coque dure simple"
	desc = "Un taco dur avec de la viande, pour les enfants et les difficiles parmi nous."
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "plain_hard_shell_taco"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
		/datum/reagent/consumable/nutriment/protein = 6,
	)
	tastes = list("de taco croustillant" = 1, "de viande hachée" = 1)
	foodtypes = GRAIN | MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/refried_beans
	name = "haricots frits"
	desc = "Un bol fumant de délicieux haricots frits, un élément essentiel de la cuisine Mexicaine."
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "refried_beans"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/nutriment/protein = 4,
	)
	tastes = list("d'haricots écrasés" = 1, "d'oignon" = 3,)
	foodtypes = VEGETABLES | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/spanish_rice
	name = "riz à la tomate"
	desc = "Une délicieux bol de riz à la tomate. Sa couleur orange vient de la sauce tomate."
	icon = 'icons/obj/food/mexican.dmi'
	icon_state = "spanish_rice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de riz piquant" = 1, "de sauce tomate" = 3,)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
