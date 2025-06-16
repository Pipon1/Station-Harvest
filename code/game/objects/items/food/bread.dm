
/// Abstract parent object for bread items. Should not be made obtainable in game.
/obj/item/food/bread
	name = "Pain ?"
	desc = "Vous ne devriez pas voir cela, prevenez ceux qui codent."
	icon = 'icons/obj/food/burgerbread.dmi'
	max_volume = 80
	tastes = list("de pain" = 10)
	foodtypes = GRAIN
	eat_time = 3 SECONDS
	/// type is spawned 5 at a time and replaces this bread loaf when processed by cutting tool
	var/obj/item/food/breadslice/slice_type
	/// so that the yield can change if it isnt 5
	var/yield = 5

/obj/item/food/bread/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)
	AddComponent(/datum/component/food_storage)

/obj/item/food/bread/make_processable()
	if (slice_type)
		AddElement(/datum/element/processable, TOOL_KNIFE, slice_type, yield, 3 SECONDS, table_required = TRUE, screentip_verb = "Slice")
		AddElement(/datum/element/processable, TOOL_SAW, slice_type, yield, 4 SECONDS, table_required = TRUE, screentip_verb = "Slice")

// Abstract parent object for sliced bread items. Should not be made obtainable in game.
/obj/item/food/breadslice
	name = "Tranche de pain ?"
	desc = "Vous ne devriez pas voir cela, prevenez ceux qui codent."
	icon = 'icons/obj/food/burgerbread.dmi'
	foodtypes = GRAIN
	food_flags = FOOD_FINGER_FOOD
	eat_time = 0.5 SECONDS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/breadslice/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/bread/plain
	name = "Pain"
	desc = "Du bon vieux pain terrestre comme à l'ancienne."
	icon_state = "bread"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10)
	tastes = list("de pain" = 10)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP
	burns_in_oven = TRUE
	slice_type = /obj/item/food/breadslice/plain

/obj/item/food/bread/plain/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, /obj/item/food/bread/empty, CUSTOM_INGREDIENT_ICON_FILL, max_ingredients = 8)

// special subtype we use for the "Bread" Admin Smite (or the breadify proc)
/obj/item/food/bread/plain/smite
	desc = "En le portant à votre oreille, vous pouvez entendre les cris de celui qui a été maudit."

/obj/item/food/breadslice/plain
	name = "Tranche de pain"
	desc = "Une tranche de vie."
	icon_state = "breadslice"
	foodtypes = GRAIN
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	venue_value = FOOD_PRICE_TRASH
	decomp_type = /obj/item/food/breadslice/moldy

/obj/item/food/breadslice/plain/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, null, CUSTOM_INGREDIENT_ICON_STACK)

/obj/item/food/breadslice/plain/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/griddle_toast, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/breadslice/moldy
	name = "Tranche de 'pain' moisi"
	desc = "Des stations entières se sont entredéchirées pour savoir si c'était encore mangeable."
	icon_state = "moldybreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/mold = 10,
	)
	tastes = list("de champignons en décomposition" = 1)
	foodtypes = GROSS
	preserved_food = TRUE

/obj/item/food/breadslice/moldy/bacteria
	name = "Tranche de 'pain' moisie riche en bactérie"
	desc = "Quelque chose (de potentiellement nécrotique) a élevé ce pain au statut de mort-vivant macabre. \
		Ça bouge, quand on ne le regarde pas. Au cas où, cherchez peut-être un prêtre. Ou un lance-flamme. Ou un roi-oignon."

/obj/item/food/breadslice/moldy/bacteria/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOLD, CELL_VIRUS_TABLE_GENERIC, rand(2, 4), 25)

/obj/item/food/bread/meat
	name = "Pain de viande"
	desc = "La base culinaire de tous les hommes respectables."
	icon_state = "meatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/nutriment/protein = 12,
	)
	tastes = list("de pain" = 10, "de viande" = 10)
	foodtypes = GRAIN | MEAT
	venue_value = FOOD_PRICE_CHEAP
	slice_type = /obj/item/food/breadslice/meat

/obj/item/food/breadslice/meat
	name = "Tranche de pain au viande"
	desc = "Une délicieuse tranche de pain au viande."
	icon_state = "meatbreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 2.4,
	)
	tastes = list("de pain" = 1, "de viande" = 1)
	foodtypes = GRAIN | MEAT

/obj/item/food/bread/sausage
	name = "Saucisse en croute"
	desc = "N'y pensez pas trop."
	icon_state = "sausagebread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/nutriment/protein = 12,
	)
	tastes = list("de pain" = 10, "de viande" = 10)
	foodtypes = GRAIN | MEAT
	slice_type = /obj/item/food/breadslice/sausage

/obj/item/food/breadslice/sausage
	name = "Tranche de saucisse en croûte."
	desc = "Une tranche de saucisse en croûte."
	icon_state = "sausagebreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 2.4,
	)
	tastes = list("de pain" = 10, "de viande" = 10)
	foodtypes = GRAIN | MEAT

/obj/item/food/bread/xenomeat
	name = "Pain à la viande de xéno"
	desc = "La base culinaire de tous les hommes respectables. Archi-hérétique."
	icon_state = "xenomeatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/nutriment/protein = 15,
	)
	tastes = list("de pain" = 10, "d'acide" = 10)
	foodtypes = GRAIN | MEAT
	slice_type = /obj/item/food/breadslice/xenomeat

/obj/item/food/breadslice/xenomeat
	name = "Tranche de pain à la viande de xéno"
	desc = "Une délicieuse tranche de pain au viande. Archi-hérétique."
	icon_state = "xenobreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 3,
	)
	tastes = list("de pain" = 10, "d'acide" = 10)
	foodtypes = GRAIN | MEAT

/obj/item/food/bread/spidermeat
	name = "Pain à la viande d'araignée"
	desc = "Un pain à la viande d'un vert rassurant, fait à partir de viande d'araignée."
	icon_state = "spidermeatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/toxin = 15,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/nutriment/protein = 12,
	)
	tastes = list("de pain" = 10, "de toiles d'araignées" = 5)
	foodtypes = GRAIN | MEAT | TOXIC
	slice_type = /obj/item/food/breadslice/spidermeat

/obj/item/food/breadslice/spidermeat
	name = "Tranche de pain à la viande d'araignée"
	desc = "Une tranche de pain à la viande, fait à partir d'un animal qui veut probablement toujours votre mort."
	icon_state = "spidermeatslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/toxin = 3,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de pain" = 10, "de toiles d'araignées" = 5)
	foodtypes = GRAIN | MEAT | TOXIC

/obj/item/food/bread/banana
	name = "Pain à la banane et aux noix"
	desc = "Un divin régal qui va bien vous caler."
	icon_state = "bananabread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/banana = 20,
	)
	tastes = list("de pain" = 10) // bananjuice will also flavour
	foodtypes = GRAIN | FRUIT
	slice_type = /obj/item/food/breadslice/banana

/obj/item/food/breadslice/banana
	name = "Tranche de pain à la banane et aux noix"
	desc = "Une tranche d'un délicieux pain à la banane."
	icon_state = "bananabreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/banana = 4,
	)
	tastes = list("de pain" = 10)
	foodtypes = GRAIN | FRUIT

/obj/item/food/bread/tofu
	name = "Pain au tofu"
	desc = "Comme le pain à la viande mais pour les végétariens. Superpouvoirs non garantis."
	icon_state = "tofubread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/nutriment/protein = 10,
	)
	tastes = list("de pain" = 10, "de tofu" = 10)
	foodtypes = GRAIN | VEGETABLES
	venue_value = FOOD_PRICE_TRASH
	slice_type = /obj/item/food/breadslice/tofu

/obj/item/food/breadslice/tofu
	name = "Tranche de pain au tofu"
	desc = "Une tranche d'un délicieux pain au tofu."
	icon_state = "tofubreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de pain" = 10, "de tofu" = 10)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/bread/creamcheese
	name = "Pain au fromage à la crème"
	desc = "Miam miam !"
	icon_state = "creamcheesebread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("de pain" = 10, "de fromage" = 10)
	foodtypes = GRAIN | DAIRY
	slice_type = /obj/item/food/breadslice/creamcheese

/obj/item/food/breadslice/creamcheese
	name = "Tranche de pain au fromage à la crème"
	desc = "Une tranche de miam !"
	icon_state = "creamcheesebreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de pain" = 10, "de fromage" = 10)
	foodtypes = GRAIN | DAIRY

/obj/item/food/bread/mimana
	name = "Pain au mimana"
	desc = "À manger en silence."
	icon_state = "mimanabread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/toxin/mutetoxin = 5,
		/datum/reagent/consumable/nothing = 5,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("de pain" = 10, "de silence" = 10)
	foodtypes = GRAIN | FRUIT
	slice_type = /obj/item/food/breadslice/mimana

/obj/item/food/breadslice/mimana
	name = "Tranche de pain au mimana"
	desc = "Une tranche de silence !"
	icon_state = "mimanabreadslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/toxin/mutetoxin = 1,
		/datum/reagent/consumable/nothing = 1,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de pain" = 10, "de silence" = 10)
	foodtypes = GRAIN | FRUIT

/obj/item/food/bread/empty
	name = "Pain"
	icon_state = "tofubread"
	desc = "Un pain, personnalisé selon vos rêves les plus fous."
	slice_type = /obj/item/food/breadslice/empty

// What you get from cutting a custom bread. Different from custom sliced bread.
/obj/item/food/breadslice/empty
	name = "Tranche de pain"
	icon_state = "tofubreadslice"
	foodtypes = GRAIN
	desc = "Une tranche de pain, personnalisée selon vos rêves les plus fous."

/obj/item/food/breadslice/empty/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, null, CUSTOM_INGREDIENT_ICON_FILL, max_ingredients = 8)

/obj/item/food/baguette
	name = "Baguette"
	desc = "Bon appétit !"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "baguette"
	inhand_icon_state = null
	worn_icon_state = "baguette"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	bite_consumption = 3
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	attack_verb_continuous = list("touche's")
	attack_verb_simple = list("touche")
	tastes = list("de pain" = 1)
	foodtypes = GRAIN
	venue_value = FOOD_PRICE_CHEAP
	/// whether this is in fake swordplay mode or not
	var/fake_swordplay = FALSE

/obj/item/food/baguette/Initialize(mapload)
	. = ..()
	register_context()

/obj/item/food/baguette/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if (HAS_TRAIT(user, TRAIT_MIMING) && held_item == src)
		context[SCREENTIP_CONTEXT_LMB] = "Toggle Swordplay"
		return CONTEXTUAL_SCREENTIP_SET

/obj/item/food/baguette/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_MIMING))
		. += span_notice("Vous pouvez brandir cette baguette comme si c'était une épée, en la tenant dans votre main.")

/obj/item/food/baguette/attack_self(mob/user, modifiers)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_MIMING))
		return
	if(fake_swordplay)
		end_swordplay(user)
	else
		begin_swordplay(user)

/obj/item/food/baguette/proc/begin_swordplay(mob/user)
	visible_message(
		span_notice("[user] commence à brandir une [src] comme une épée !"),
		span_notice("Vous commencez à brandir la [src] comme une épée d'une main ferme tenant une poignée imaginaire.")
	)
	ADD_TRAIT(src, TRAIT_CUSTOM_TAP_SOUND, SWORDPLAY_TRAIT)
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/weapons/rapierhit.ogg'
	fake_swordplay = TRUE

	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, PROC_REF(on_sword_equipped))
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(on_sword_dropped))

/obj/item/food/baguette/proc/end_swordplay(mob/user)
	UnregisterSignal(src, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))

	REMOVE_TRAIT(src, TRAIT_CUSTOM_TAP_SOUND, SWORDPLAY_TRAIT)
	attack_verb_continuous = initial(attack_verb_continuous)
	attack_verb_simple = initial(attack_verb_simple)
	hitsound = initial(hitsound)
	fake_swordplay = FALSE

	if(user)
		visible_message(
			span_notice("[user] arrête de tenir la [src] comme une épée !"),
			span_notice("Vous recommencez à tenir la [src] normalement.")
		)

/obj/item/food/baguette/proc/on_sword_dropped(datum/source, mob/user)
	SIGNAL_HANDLER

	end_swordplay()

/obj/item/food/baguette/proc/on_sword_equipped(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER

	if(!(slot & ITEM_SLOT_HANDS))
		end_swordplay()

/// Deadly bread used by a mime
/obj/item/food/baguette/combat
	sharpness = SHARP_EDGED
	/// Force when wielded as a sword by a mime
	var/active_force = 20
	/// Block chance when wielded as a sword by a mime
	var/active_block = 50

/obj/item/food/baguette/combat/begin_swordplay(mob/user)
	. = ..()
	force = active_force
	block_chance = active_block

/obj/item/food/baguette/combat/end_swordplay(mob/user)
	. = ..()
	force = initial(force)
	block_chance = initial(block_chance)

/obj/item/food/garlicbread
	name = "Pain à l'ail"
	desc = "Hélas, il n'est pas infini."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "garlicbread"
	inhand_icon_state = null
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/garlic = 2,
	)
	bite_consumption = 3
	tastes = list("de pain" = 1, "d'ail" = 1, "de beurre" = 1)
	foodtypes = GRAIN
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/butterbiscuit
	name = "Biscuit au beurre"
	desc = "Owi viens beurrer mon biscuit..."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "butterbiscuit"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de beurre" = 1, "de biscuit" = 1)
	foodtypes = GRAIN | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/butterdog
	name = "Miche beurrée"
	desc = "Comme si on avait mis du beurre sur un chien, mais que le chien était du pain."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "butterdog"
	bite_consumption = 1
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de beurre" = 1, "de beurre exotique" = 1)
	foodtypes = GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/butterdog/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 8 SECONDS)

/obj/item/food/raw_frenchtoast
	name = "Pain perdu cru"
	desc = "Une tranche de pain trempée dans un mélange d'oeufs. Mettez-le sur un grill pour commencer la cuisson !"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "raw_frenchtoast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("d'oeuf crus" = 2, "de pain trempé" = 1)
	foodtypes = GRAIN | RAW | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_frenchtoast/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/frenchtoast, rand(20 SECONDS, 30 SECONDS), TRUE)

	/obj/item/food/frenchtoast
	name = "Pain perdu"
	desc = "Une tranche de pain trempée dans un mélange d'oeufs et grillée jusqu'à devenir doré comme il faut ! À arroser de sirop !"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "frenchtoast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de pain perdu" = 1, "de sirop d'érable" = 1, "d'un délice doré" = 1)
	foodtypes = GRAIN | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/raw_breadstick
	name = "Gressin cru"
	desc = "Une bande de pâte crue en forme de gressin."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "raw_breadstick"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de pâte crue" = 1)
	foodtypes = GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_breadstick/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/breadstick, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/breadstick
	name = "Gressin"
	desc = "Un délicieux gressin beurré. Super addictif, mais ça vaut teeellement le coup."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "breadstick"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de pain moelleux" = 1, "de beurre" = 2)
	foodtypes = GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/raw_croissant
	name = "Croissant cru"
	desc = "Une pâte repliée, prête à être cuite en un délicieux croissant."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "raw_croissant"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("de pâte crue" = 1)
	foodtypes = GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_croissant/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/croissant, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/croissant
	name = "Croissant"
	desc = "Un délicieux croissant beurré. La meilleure façon de commencer la journée."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "croissant"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("de pain moelleux" = 1, "de beurre" = 2)
	foodtypes = GRAIN | DAIRY | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

// Enhanced weaponised bread
/obj/item/food/croissant/throwing
	throwforce = 20
	tastes = list("de pain moelleux" = 1, "de beurre" = 2, "de métal" = 1)
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/iron = 1)

/obj/item/food/croissant/throwing/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/boomerang, throw_range, TRUE)
