/**
 * # Abstract cheese class
 *
 * Everything that is a subclass of this counts as cheese for regal rats.
 */
/obj/item/food/cheese
	name = "Le concept de fromage"
	desc = "Ceci ne devrait probablement pas exister."
	tastes = list("de fromage" = 1)
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)
	foodtypes = DAIRY
	/// used to determine how much health rats/regal rats recover when they eat it.
	var/rat_heal = 0

/obj/item/food/cheese/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_RAT_INTERACT, PROC_REF(on_rat_eat))

/obj/item/food/cheese/proc/on_rat_eat(datum/source, mob/living/simple_animal/hostile/regalrat/king)
	SIGNAL_HANDLER

	king.cheese_heal(src, rat_heal, span_green("Vous mangez : [src]. Cela vous fait un peu de bien."))

/obj/item/food/cheese/wedge
	name = "Morceau de fromage"
	desc = "Un délicieux morceau de Cheddar. La meule de fromage d'origine n'a pas dû aller très loin."
	icon_state = "cheesewedge"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	w_class = WEIGHT_CLASS_SMALL
	rat_heal = 10

/obj/item/food/cheese/wheel
	name = "Meule de fromage"
	desc = "Une grosse meule de Cheddar délicieux."
	icon_state = "cheesewheel"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	) //Hard cheeses contain about 25% protein
	w_class = WEIGHT_CLASS_NORMAL
	rat_heal = 35

/obj/item/food/cheese/wheel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/food_storage)

/obj/item/food/cheese/wheel/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cheese/wedge, 5, 3 SECONDS, table_required = TRUE, screentip_verb = "Slice")

/obj/item/food/cheese/wheel/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/baked_cheese, rand(20 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/cheese/royal
	name = "Fromage Royal"
	desc = "Accédez au trône. Mangez la meule. Sentez le POUVOIR."
	icon_state = "royalcheese"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/gold = 20,
		/datum/reagent/toxin/mutagen = 5,
	)
	w_class = WEIGHT_CLASS_BULKY
	tastes = list("de fromage" = 4, "de royauté" = 1)
	rat_heal = 70

//Curd cheese, a general term which I will now proceed to stretch as thin as the toppings on a supermarket sandwich:
//I'll use it as a substitute for ricotta, cottage cheese and quark, as well as any other non-aged, soft grainy cheese
/obj/item/food/cheese/curd_cheese
	name = "Fromage granuleux"
	desc = "Connu sous de nombreux noms en cuisine humaine, le fromage granuleux est utilisé dans une grand nombre de plats."
	icon_state = "curd_cheese"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/cream = 1,
	)
	tastes = list("de crème" = 1, "de fromage" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL
	rat_heal = 35

/obj/item/food/cheese/curd_cheese/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/cheese/cheese_curds, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/cheese/curd_cheese/make_microwaveable()
	AddElement(/datum/element/microwavable, /obj/item/food/cheese/cheese_curds)

/obj/item/food/cheese/cheese_curds
	name = "Caillebottes"
	desc = "Encore une création chelou des Américains."
	icon_state = "cheese_curds"
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL
	rat_heal = 35

/obj/item/food/cheese/cheese_curds/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dryable,  /obj/item/food/cheese/firm_cheese)

/obj/item/food/cheese/firm_cheese
	name = "Fromage à pâte dure"
	desc = "Fromage à pâte dure, la texture est similaire au tofu à pâte dure. Grâce à son absence de moisissure il est particulièrement utile en cuisine, notamment car il n'est pas facile de le faire fondre."
	icon_state = "firm_cheese"
	tastes = list("de fromage vieilli" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	rat_heal = 35

/obj/item/food/cheese/firm_cheese/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cheese/firm_cheese_slice, 3, 3 SECONDS, screentip_verb = "Slice")

/obj/item/food/cheese/firm_cheese_slice
	name = "Tranche de fromage à pâte dure"
	desc = "Une tranche de fromage à pâte dure. Parfait pour faire des grillades ou du pesto."
	icon_state = "firm_cheese_slice"
	tastes = list("de fromage vieilli" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE
	rat_heal = 10

/obj/item/food/cheese/firm_cheese_slice/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/grilled_cheese, rand(25 SECONDS, 35 SECONDS), TRUE, TRUE)

/obj/item/food/cheese/mozzarella
	name = "Mozzarella"
	desc = "Délicieux, crémeux et fromageux, tout ça dans un seul emballage."
	icon_state = "mozzarella"
	tastes = list("de mozzarella" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL
	rat_heal = 10
