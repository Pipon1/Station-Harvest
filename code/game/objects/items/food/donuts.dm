#define DONUT_SPRINKLE_CHANCE 30

/obj/item/food/donut
	name = "Donut"
	desc = "Se marie parfaitement avec un bon café."
	icon = 'icons/obj/food/donuts.dmi'
	bite_consumption = 5
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/sugar = 3)
	tastes = list("de donut" = 1)
	foodtypes = JUNKFOOD | GRAIN | FRIED | SUGAR | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	var/decorated_icon = "donut_homer"
	var/is_decorated = FALSE
	var/extra_reagent = null
	var/decorated_adjective = "sprinkled"

/obj/item/food/donut/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, amount_per_dunk = 10)
	if(prob(DONUT_SPRINKLE_CHANCE))
		decorate_donut()

///Override for checkliked callback
/obj/item/food/donut/make_edible()
	. = ..()
	AddComponent(/datum/component/edible, check_liked = CALLBACK(src, PROC_REF(check_liked)))

/obj/item/food/donut/proc/decorate_donut()
	if(is_decorated || !decorated_icon)
		return
	is_decorated = TRUE
	name = "[decorated_adjective] [name]"
	icon_state = decorated_icon //delish~!
	reagents.add_reagent(/datum/reagent/consumable/sprinkles, 1)
	return TRUE

/// Returns the sprite of the donut while in a donut box
/obj/item/food/donut/proc/in_box_sprite()
	return "[icon_state]_inbox"

///Override for checkliked in edible component, because all cops LOVE donuts
/obj/item/food/donut/proc/check_liked(fraction, mob/living/carbon/human/consumer)
	var/obj/item/organ/internal/liver/liver = consumer.get_organ_slot(ORGAN_SLOT_LIVER)
	if(!HAS_TRAIT(consumer, TRAIT_AGEUSIA) && liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		return FOOD_LIKED

//Use this donut ingame
/obj/item/food/donut/plain
	icon_state = "donut"

/obj/item/food/donut/chaos
	name = "Donut chaos"
	desc = "Comme la vie, le goût n'est jamais tout à fait le même."
	icon_state = "donut_chaos"
	bite_consumption = 10
	tastes = list("de donut" = 3, "de chaos" = 1)
	is_decorated = TRUE

/obj/item/food/donut/chaos/Initialize(mapload)
	. = ..()
	extra_reagent = pick(
		/datum/reagent/consumable/nutriment,
		/datum/reagent/consumable/capsaicin,
		/datum/reagent/consumable/frostoil,
		/datum/reagent/drug/krokodil,
		/datum/reagent/toxin/plasma,
		/datum/reagent/consumable/coco,
		/datum/reagent/toxin/slimejelly,
		/datum/reagent/consumable/banana,
		/datum/reagent/consumable/berryjuice,
		/datum/reagent/medicine/omnizine,
	)
	reagents.add_reagent(extra_reagent, 3)

/obj/item/food/donut/meat
	name = "Donut à la viande"
	desc = "A également le goût affreux qu'il a l'air d'avoir."
	icon_state = "donut_meat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/ketchup = 3,
	)
	tastes = list("de viande" = 1)
	foodtypes = JUNKFOOD | MEAT | GORE | FRIED | BREAKFAST
	is_decorated = TRUE

/obj/item/food/donut/berry
	name = "Donut rose"
	desc = "Se marie bien avec un latte au lait de soja."
	icon_state = "donut_pink"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/berryjuice = 3,
		/datum/reagent/consumable/sprinkles = 1, //Extra sprinkles to reward frosting
	)
	decorated_icon = "donut_homer"

/obj/item/food/donut/trumpet
	name = "Donut de l'astronaute"
	desc = "Se marie bien avec du lait froid."
	icon_state = "donut_purple"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/sprinkles = 1,
	)
	tastes = list("de donut" = 3, "de violettes" = 1)
	is_decorated = TRUE

/obj/item/food/donut/apple
	name = "Donut à la pomme"
	desc = "Se marie bien avec un shot de schnapps à la cannelle."
	icon_state = "donut_green"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/applejuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
	)
	tastes = list("de donut" = 3, "de pommes vertes" = 1)
	is_decorated = TRUE

/obj/item/food/donut/caramel
	name = "Donut au caramel"
	desc = "Se marie bien avec une tasse de chocolat chaud."
	icon_state = "donut_beige"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/caramel = 3,
		/datum/reagent/consumable/sprinkles = 1,
	)
	tastes = list("de donut" = 3, "de beurre sucré" = 1)
	is_decorated = TRUE

/obj/item/food/donut/choco
	name = "Donut au chocolat"
	desc = "Se marie bien avec un verre de lait chaud."
	icon_state = "donut_choc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/hot_coco = 3,
		/datum/reagent/consumable/sprinkles = 1,
	) //the coco reagent is just bitter.
	tastes = list("de donut" = 4, "amer" = 1)
	decorated_icon = "donut_choc_sprinkles"

/obj/item/food/donut/blumpkin
	name = "Donut à la trouillebleu"
	desc = "Se marie bien avec une tasse d'alcool de trouillebleus."
	icon_state = "donut_blue"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/blumpkinjuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
	)
	tastes = list("de donut" = 2, "de trouillebleu" = 1)
	is_decorated = TRUE

/obj/item/food/donut/bungo
	name = "Donut au bungo"
	desc = "Se marie bien avec un bocal de laitue du diable."
	icon_state = "donut_yellow"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/bungojuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
	)
	tastes = list("de donut" = 3, "d'une douceur tropicale" = 1)
	is_decorated = TRUE

/obj/item/food/donut/matcha
	name = "Donut au matcha"
	desc = "Se marie bien avec une tasse de thé."
	icon_state = "donut_olive"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/toxin/teapowder = 3,
		/datum/reagent/consumable/sprinkles = 1,
	)
	tastes = list("de donut" = 3, "de matcha" = 1)
	is_decorated = TRUE

/obj/item/food/donut/laugh
	name = "Donut aux petits pois sympa"
	desc = "Se marie bien avec une bouteille de bourbon Bastion !"
	icon_state = "donut_laugh"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/laughter = 3,
	)
	tastes = list("de donut" = 3, "de tutti frutti pétillant" = 1,)
	is_decorated = TRUE

//////////////////////JELLY DONUTS/////////////////////////

/obj/item/food/donut/jelly
	name = "Donut à la confiture"
	desc = "Bonne maman ?"
	icon_state = "jelly"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/sugar = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	extra_reagent = /datum/reagent/consumable/berryjuice
	tastes = list("jelly" = 1, "de donut" = 3)
	foodtypes = JUNKFOOD | GRAIN | FRIED | FRUIT | SUGAR | BREAKFAST

// Jelly donuts don't have holes, but look the same on the outside
/obj/item/food/donut/jelly/in_box_sprite()
	return "[replacetext(icon_state, "jelly", "donut")]_inbox"

/obj/item/food/donut/jelly/Initialize(mapload)
	. = ..()
	if(extra_reagent)
		reagents.add_reagent(extra_reagent, 3)

/obj/item/food/donut/jelly/plain //use this ingame to avoid inheritance related crafting issues.
	decorated_icon = "jelly_homer"

/obj/item/food/donut/jelly/berry
	name = "Donut rose à la confiture"
	desc = "Se marie bien avec un latte au lait de soja."
	icon_state = "jelly_pink"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/berryjuice = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1) //Extra sprinkles to reward frosting.
	decorated_icon = "jelly_homer"

/obj/item/food/donut/jelly/trumpet
	name = "Donut d'astronaute à la confiture"
	desc = "Se marie bien avec du lait froid."
	icon_state = "jelly_purple"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 3, "de violettes" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/apple
	name = "Donut à la confiture de pomme"
	desc = "Se marie bien avec un shot de schnapps à la cannelle."
	icon_state = "jelly_green"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/applejuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 3, "de pommes vertes" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/caramel
	name = "Donut caramel-confiture"
	desc = "Se marie bien avec une tasse de chocolat chaud."
	icon_state = "jelly_beige"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/caramel = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 3, "de beurre sucré" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/choco
	name = "Donut chocolat-confiture"
	desc = "Se marie bien avec un verre de lait chaud."
	icon_state = "jelly_choc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/hot_coco = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 4, "amer" = 1)
	decorated_icon = "jelly_choc_sprinkles"

/obj/item/food/donut/jelly/blumpkin
	name = "Donut trouillebleu-confiture"
	desc = "Se marie bien avec une tasse d'alcool de trouillebleus."
	icon_state = "jelly_blue"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/blumpkinjuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 2, "de trouillebleu" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/bungo
	name = "Donut bungo-confiture"
	desc = "Se marie bien avec un bocal de laitue du diable."
	icon_state = "jelly_yellow"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/bungojuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 3, "de douceur tropicale" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/matcha
	name = "Donut matcha-confiture"
	desc = "Se marie bien avec une tasse thé."
	icon_state = "jelly_olive"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/toxin/teapowder = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 3, "de matcha" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/laugh
	name = "Donut petits pois sympa-confiture"
	desc = "Se marie bien avec une bouteille de bourbon Bastion !"
	icon_state = "jelly_laugh"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/laughter = 3,
	)
	tastes = list("de confiture" = 3, "de donut" = 1, "de tutti frutti pétillant" = 1)
	is_decorated = TRUE

//////////////////////////SLIME DONUTS/////////////////////////

/obj/item/food/donut/jelly/slimejelly
	name = "Donut à la confiture"
	desc = "Bonne maman ?"
	extra_reagent = /datum/reagent/toxin/slimejelly
	foodtypes = JUNKFOOD | GRAIN | FRIED | TOXIC | SUGAR | BREAKFAST

/obj/item/food/donut/jelly/slimejelly/plain
	icon_state = "jelly"

/obj/item/food/donut/jelly/slimejelly/berry
	name = "Donut rose à la confiture"
	desc = "Se marie bien avec un latte au lait de soja."
	icon_state = "jelly_pink"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/berryjuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	) //Extra sprinkles to reward frosting

/obj/item/food/donut/jelly/slimejelly/trumpet
	name = "Donut d'astronaute à la confiture"
	desc = "Se marie bien avec du lait froid."
	icon_state = "jelly_purple"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 3, "de violettes" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/slimejelly/apple
	name = "Donut à la confiture de pomme"
	desc = "Se marie bien avec un shot de schnapps à la cannelle."
	icon_state = "jelly_green"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/applejuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 3, "de pommes vertes" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/slimejelly/caramel
	name = "Donut caramel-confiture"
	desc = "Se marie bien avec une tasse de chocolat chaud."
	icon_state = "jelly_beige"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/caramel = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 3, "de beurre sucré" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/slimejelly/choco
	name = "Donut chocolat-confiture"
	desc = "Se marie bien avec un verre de lait chaud."
	icon_state = "jelly_choc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/hot_coco = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 4, "amer" = 1)
	decorated_icon = "jelly_choc_sprinkles"

/obj/item/food/donut/jelly/slimejelly/blumpkin
	name = "Donut trouillebleu-confiture"
	desc = "Se marie bien avec une tasse d'alcool de trouillebleus."
	icon_state = "jelly_blue"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/blumpkinjuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 2, "de trouillebleu" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/slimejelly/bungo
	name = "Donut bungo-confiture"
	desc = "Se marie bien avec un bocal de laitue du diable."
	icon_state = "jelly_yellow"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/bungojuice = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 3, "de douceur tropicale" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/slimejelly/matcha
	name = "Donut matcha-confiture"
	desc = "Se marie bien avec une tasse thé."
	icon_state = "jelly_olive"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/toxin/teapowder = 3,
		/datum/reagent/consumable/sprinkles = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de confiture" = 1, "de donut" = 3, "de matcha" = 1)
	is_decorated = TRUE

/obj/item/food/donut/jelly/slimejelly/laugh
	name = "Donut petits pois sympa-confiture"
	desc = "Se marie bien avec une bouteille de bourbon Bastion !"
	icon_state = "jelly_laugh"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/laughter = 3,
	)
	tastes = list("de confiture" = 3, "de donut" = 1, "de tutti frutti pétillant" = 1)
	is_decorated = TRUE

#undef DONUT_SPRINKLE_CHANCE
