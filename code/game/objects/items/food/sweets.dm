// Sweets that didn't make it into any other category

/obj/item/food/candy_corn
	name = "bonbon de maïs"
	desc = "C'est une poignée de bonbons au maïs. Peut être rangé dans un chapeau de détective."
	icon_state = "candy_corn"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/sugar = 2,
	)
	tastes = list("de bonbon de maïs" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/candy_corn/prison
	name = "bonbons de maïs déshydratés"
	desc = "Si ces bonbons de maïs étaient plus durs, la sécurité les confisquerait pour port d'arme."
	force = 1 // the description isn't lying
	throwforce = 1 // if someone manages to bust out of jail with candy corn god bless them
	tastes = list("de cire amère" = 1)
	foodtypes = GROSS

/obj/item/food/candiedapple
	name = "pomme d'amour"
	desc = "Une pomme enrobée de sucre."
	icon_state = "candiedapple"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/caramel = 5,
	)
	tastes = list("de pomme" = 2, "de caramel" = 3)
	foodtypes = JUNKFOOD | FRUIT | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/mint
	name = "menthe"
	desc = "C'est seulement une petite feuille."
	icon_state = "mint"
	bite_consumption = 1
	food_reagents = list(/datum/reagent/consumable/mintextract = 2)
	foodtypes = TOXIC | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/ant_candy
	name = "bonbons de fourmis"
	desc = "Une colonie de fourmis en suspension dans du sucre durci. Ces choses sont mortes, n'est-ce pas ?"
	icon_state = "ant_pop"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/ants = 3,
	)
	tastes = list("de bonbon" = 1, "d'insectes" = 1)
	foodtypes = JUNKFOOD | SUGAR | BUGS
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY


// Chocolates
/obj/item/food/chocolatebar
	name = "barre chocolatée"
	desc = "Une nourriture si douce et si sucrée."
	icon_state = "chocolatebar"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/sugar = 2,
		/datum/reagent/consumable/coco = 2,
	)
	tastes = list("de chocolat" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/chococoin
	name = "pièce en chocolat"
	desc = "Une pièce de monnaie festive tout à fait comestible."
	icon_state = "chococoin"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/coco = 1,
		/datum/reagent/consumable/sugar = 1,
	)
	tastes = list("de chocolat" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fudgedice
	name = "dé fondant"
	desc = "Un petit cube de chocolat qui a tendance à avoir un goût moins intense si vous en mangez trop à la fois."
	icon_state = "chocodice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/coco = 1,
		/datum/reagent/consumable/sugar = 1,
	)
	trash_type = /obj/item/dice/fudge
	tastes = list("de fondant" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/chocoorange
	name = "orange au chocolat"
	desc = "Une orange au chocolat festive."
	icon_state = "chocoorange"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/sugar = 1,
	)
	tastes = list("de chocolat" = 3, "d'orange" = 1)
	foodtypes = JUNKFOOD | SUGAR | ORANGES
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/bonbon
	name = "bon bon"
	desc = "Un chocolat minuscule et sucré."
	icon_state = "tiny_chocolate"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/sugar = 1,
		/datum/reagent/consumable/coco = 1,
	)
	tastes = list("de chocolat" = 1)
	foodtypes = DAIRY | JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/bonbon/caramel_truffle
	name = "truffe au caramel"
	desc = "Une bouchée de truffe au chocolat, fourrée d'un caramel moelleux."
	icon_state = "caramel_truffle"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de chocolat" = 1, "de caramel moelleux" = 1)

/obj/item/food/bonbon/chocolate_truffle
	name = "truffe au chocolat"
	desc = "Une bouchée de truffe au chocolat, fourrée d'une riche mousse au chocolat."
	icon_state = "chocolate_truffle"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)

/obj/item/food/bonbon/peanut_truffle
	name = "truffe aux cacahuètes"
	desc = "Une bouchée de truffe au chocolat, mélangée à des cacahuètes croquantes."
	icon_state = "peanut_truffle"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de chocolat" = 1, "de cacahuète" = 1)
	foodtypes = DAIRY | SUGAR | JUNKFOOD | NUTS

/obj/item/food/bonbon/peanut_butter_cup
	name = "tasse de beurre de cacahuètes"
	desc = "Une gâterie au chocolat ultra-sucrée avec un savoureux fourrage au beurre de cacahuètes."
	icon_state = "peanut_butter_cup"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de chocolat" = 1, "de beurre de cacahuètes" = 1)
	foodtypes = DAIRY | SUGAR | JUNKFOOD | NUTS


// Gum
/obj/item/food/bubblegum
	name = "gomme à mâcher"
	desc = "Une bande de gomme à mâcher caoutchouteuse. Elle n'est pas vraiment rassasiante, mais elle permet de s'occuper."
	icon_state = "bubblegum"
	inhand_icon_state = null
	color = "#E48AB5" // craftable custom gums someday?
	food_reagents = list(/datum/reagent/consumable/sugar = 5)
	tastes = list("de bonbon" = 1)
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY

	/// The amount to metabolize per second
	var/metabolization_amount = REAGENTS_METABOLISM / 2

/obj/item/food/bubblegum/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] avale [src] ! Il semblerait que [user] essaye de se suicider !"))
	qdel(src)
	return TOXLOSS

/obj/item/food/bubblegum/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/chewable, metabolization_amount = metabolization_amount)

/obj/item/food/bubblegum/nicotine
	name = "nicotine à macher"
	food_reagents = list(
		/datum/reagent/drug/nicotine = 10,
		/datum/reagent/consumable/menthol = 5,
	)
	tastes = list("de menthe" = 1)
	color = "#60A584"

/obj/item/food/bubblegum/happiness
	name = "gomme à macher HP+"
	desc = "Une bande de gomme à mâcher caoutchouteuse. Elle a une drôle d'odeur."
	food_reagents = list(/datum/reagent/drug/happiness = 15)
	tastes = list("de diluant pour peinture" = 1)
	color = "#EE35FF"

/obj/item/food/bubblegum/bubblegum
	name = "gomme de gomme à macher"
	desc = "Une bande de gomme à mâcher caoutchouteuse. Vous n'avez pas l'impression que c'est une bonne idée de la manger."
	color = "#913D3D"
	food_reagents = list(/datum/reagent/blood = 15)
	tastes = list("d'enfer" = 1, "de gens" = 1)
	metabolization_amount = REAGENTS_METABOLISM

/obj/item/food/bubblegum/bubblegum/process()
	. = ..()
	if(iscarbon(loc))
		hallucinate(loc)

/obj/item/food/bubblegum/bubblegum/make_edible()
	. = ..()
	AddComponent(/datum/component/edible, on_consume = CALLBACK(src, PROC_REF(OnConsume)))

/obj/item/food/bubblegum/bubblegum/proc/OnConsume(mob/living/eater, mob/living/feeder)
	if(iscarbon(eater))
		hallucinate(eater)

///This proc has a 5% chance to have a bubblegum line appear, with an 85% chance for just text and 15% for a bubblegum hallucination and scarier text.
/obj/item/food/bubblegum/bubblegum/proc/hallucinate(mob/living/carbon/victim)
	if(prob(95)) //cursed by bubblegum
		return
	if(prob(15))
		victim.cause_hallucination(/datum/hallucination/oh_yeah, "bubblegum bubblegum", haunt_them = TRUE)
	else
		to_chat(victim, span_warning("[pick("Vous entendez de faibles murmures.", "Vous sentez le goût de cendres.", "Vous avez chaud.", "Vous entendez un rugissement au loin.")]"))

/obj/item/food/bubblegum/bubblegum/suicide_act(mob/living/user)
	user.say(";[pick(BUBBLEGUM_HALLUCINATION_LINES)]")
	return ..()

/obj/item/food/gumball
	name = "boule de gomme"
	desc = "Une boule de gomme colorée et sucrée."
	icon = 'icons/obj/food/lollipop.dmi'
	icon_state = "gumball"
	worn_icon_state = "bubblegum"
	food_reagents = list(/datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/sal_acid = 2, /datum/reagent/medicine/oxandrolone = 2) //Kek
	tastes = list("de bonbon")
	foodtypes = JUNKFOOD
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY
	venue_value = FOOD_PRICE_WORTHLESS

/obj/item/food/gumball/Initialize(mapload)
	. = ..()
	color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	AddElement(/datum/element/chewable)


// Lollipop
/obj/item/food/lollipop
	name = "sucette"
	desc = "Une délicieuse sucette. Un cadeau idéal pour la Saint-Valentin."
	icon = 'icons/obj/food/lollipop.dmi'
	icon_state = "lollipop_stick"
	inhand_icon_state = null
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/iron = 10, /datum/reagent/consumable/sugar = 5,
		/datum/reagent/medicine/omnizine = 2,
	)
	tastes = list("de bonbon" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY
	venue_value = FOOD_PRICE_WORTHLESS
	var/mutable_appearance/head
	var/head_color = rgb(0, 0, 0)

/obj/item/food/lollipop/Initialize(mapload)
	. = ..()
	head = mutable_appearance('icons/obj/food/lollipop.dmi', "lollipop_head")
	change_head_color(rgb(rand(0, 255), rand(0, 255), rand(0, 255)))
	AddElement(/datum/element/chewable)

/obj/item/food/lollipop/proc/change_head_color(C)
	head_color = C
	cut_overlay(head)
	head.color = C
	add_overlay(head)

/obj/item/food/lollipop/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..(hit_atom)
	throw_speed = 1
	throwforce = 0

/obj/item/food/lollipop/cyborg
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/iron = 10,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/medicine/psicodine = 2, //psicodine instead of omnizine, because the latter was making coders freak out
	)

/obj/item/food/spiderlollipop
	name = "sucette araignée"
	desc = "C'est toujours aussi dégoûtant, mais au moins il y a une montagne de sucre dessus."
	icon_state = "spiderlollipop"
	worn_icon_state = "lollipop_stick"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/toxin = 1,
		/datum/reagent/iron = 10,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/medicine/omnizine = 2,
	) //lollipop, but vitamins = toxins
	tastes = list("de toiles d'araignée" = 1, "de sucre" = 2)
	foodtypes = JUNKFOOD | SUGAR | BUGS
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK

/obj/item/food/spiderlollipop/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/chewable)
