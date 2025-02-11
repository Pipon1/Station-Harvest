/obj/item/food/bowled
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'icons/obj/food/soupsalad.dmi'
	bite_consumption = 5
	max_volume = 80
	foodtypes = NONE
	eatverbs = list("aspire", "mange", "avale", "boit")
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/bowled/wish
	name = "soupe de vœux"
	desc = "J'aimerais que ce soit de la soupe."
	icon_state = "wishsoup"
	food_reagents = list(/datum/reagent/water = 10)
	tastes = list("de voeux" = 1)

/obj/item/food/bowled/wish/Initialize(mapload)
	. = ..()
	if(prob(25))
		desc = "Un voeux a été exaucé !"
		reagents.add_reagent(/datum/reagent/consumable/nutriment, 9)
		reagents.add_reagent(/datum/reagent/consumable/nutriment/vitamin, 1)

/obj/item/food/bowled/mammi
	name = "Mammi"
	desc = "Un bol de pain mou et de lait. Attention à la tête !"
	icon_state = "mammi"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	foodtypes = SUGAR | DAIRY

/obj/item/food/bowled/spacylibertyduff
	name = "pudding spacy liberty"
	desc = "Jello gelatin, du livre de cuisine d'Alfred Hubbard."
	icon_state = "spacylibertyduff"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/drug/mushroomhallucinogen = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de gelée" = 1, "de champignon" = 1)
	foodtypes = VEGETABLES

/obj/item/food/bowled/amanitajelly
	name = "gelée d'amanite"
	desc = "Ça semble curieusement toxique."
	icon_state = "amanitajelly"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 7,
		/datum/reagent/drug/mushroomhallucinogen = 3,
		/datum/reagent/toxin/amatoxin = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de gelée" = 1, "de champignon" = 1)
	foodtypes = VEGETABLES | TOXIC
