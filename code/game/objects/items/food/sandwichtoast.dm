/obj/item/food/sandwich
	name = "sandwich"
	desc = "Une grande création de viande, de fromage et de pain."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "sandwich"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de viande" = 2, "de fromage" = 1, "de pain" = 2)
	foodtypes = GRAIN | VEGETABLES
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/grilled_cheese_sandwich
	name = "sandwich grilled cheese"
	desc = "Un sandwich fondant qui se marie parfaitement avec de la soupe à la tomate."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "toastedsandwich"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/carbon = 4,
	)
	tastes = list("de pain" = 2, "de fromage chaud" = 3, "de beurre" = 1)
	foodtypes = GRAIN
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/cheese_sandwich
	name = "sandwich au fromage"
	desc = "Un petit en-cas pour les jours chauds... Mais et si vous le grilliez ?"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "sandwich"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 7,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de pain" = 1, "de fromage" = 1)
	foodtypes = GRAIN | DAIRY
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/cheese_sandwich/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/grilled_cheese_sandwich, rand(30 SECONDS, 60 SECONDS), TRUE)

/obj/item/food/jellysandwich
	name = "sandwich à la confiture"
	desc = "Une sombre partie de vous se demande où est le pot de beurre de cacahuète le plus proche."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "jellysandwich"
	bite_consumption = 3
	tastes = list("de pain" = 1, "de confiture à la cerise" = 1)
	foodtypes = GRAIN
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/jellysandwich/slime
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/slimejelly = 10, /datum/reagent/consumable/nutriment/vitamin = 4)
	foodtypes = GRAIN | TOXIC

/obj/item/food/jellysandwich/cherry
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/cherryjelly = 8, /datum/reagent/consumable/nutriment/vitamin = 4)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/notasandwich
	name = "pas-un-sandwich"
	desc = "Quelque chose semble bizarre, mais vous n'arrivez pas à mettre le doigt dessus. Peut-être la moustache ?"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "notasandwich"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("de rien de bizarre" = 1)
	foodtypes = GRAIN | GROSS
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/griddle_toast
	name = "tranche de pain grillée"
	desc = "Du pain grillé !"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "griddle_toast"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("de pain grillé" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE
	slot_flags = ITEM_SLOT_MASK

/obj/item/food/butteredtoast
	name = "tranche de pain beurré"
	desc = "Du pain et du beurre, Martine. Du pain et du beurre."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "butteredtoast"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de beurre" = 1, "de pain" = 1)
	foodtypes = GRAIN | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/jelliedtoast
	name = "tranche de pain à la confiture"
	desc = "Une tranche de pain recouvert de confiture."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "jellytoast"
	bite_consumption = 3
	tastes = list("de pain" = 1, "de confiture" = 1)
	foodtypes = GRAIN | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/jelliedtoast/cherry
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/cherryjelly = 8, /datum/reagent/consumable/nutriment/vitamin = 4)
	foodtypes = GRAIN | FRUIT | SUGAR | BREAKFAST

/obj/item/food/jelliedtoast/slime
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/toxin/slimejelly = 8, /datum/reagent/consumable/nutriment/vitamin = 4)
	foodtypes = GRAIN | TOXIC | SUGAR | BREAKFAST

/obj/item/food/twobread
	name = "deux tranches de pain"
	desc = "Ça a l'air très amère."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "twobread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de pain" = 1, "de vin" = 1)
	foodtypes = GRAIN
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/hotdog
	name = "hotdog"
	desc = "COMMANDEMENT QUATRE ! Un Discordien ne doit Partager Aucun Pain à Hot-Dog, car Tel fut le Réconfort de Notre Déesse quand Elle fut Confrontée à La Rebuffade Originelle ! \
	COMMANDEMENT CINQ ! Il est Défendu à un Discordien de Croire ce qu'il lit."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "hotdog"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/ketchup = 3,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de petit pain" = 3, "de viande" = 2, "de ketchup" = 1)
	foodtypes = GRAIN | MEAT //Ketchup is not a vegetable
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

// Used for unit tests, do not delete
/obj/item/food/hotdog/debug
	eat_time = 0

/obj/item/food/danish_hotdog
	name = "hotdog danois"
	desc = "Un petit pain appétissant avec une saucisse au millieu, couvert de sauce, d'oignons frit et de bouts cornichons."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "danish_hotdog"
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/ketchup = 3,
		/datum/reagent/consumable/nutriment/vitamin = 7,
	)
	tastes = list("de petit pain" = 3, "de viande" = 2, "d'oignon frit" = 1, "de cornichon" = 1)
	foodtypes = GRAIN | MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/blt
	name = "\improper BLT"
	desc = "Un classique américain : Bacon, laitue, tomate."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "blt"
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 7,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de bacon" = 3, "de laitue" = 2, "de tomate" = 2, "de pain" = 2)
	foodtypes = GRAIN | MEAT | VEGETABLES | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/peanut_butter_jelly_sandwich
	name = "sandwich au beurre de cacahuète et à la confiture"
	desc = "J'imagine que vous avez juste pris une tranche de pain à la confiture, une tranche de pain au beurre de cacahuète, et que vous avez décidé d'avoir mauvais goût."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "peanut_butter_jelly_sandwich"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de beurre de cacahuète" = 1, "de confiture à la cerise" = 1, "de pain" = 2)
	foodtypes = GRAIN | FRUIT | NUTS
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/peanut_butter_banana_sandwich
	name = "sandwich au beurre de cacahuète et à la banane"
	desc = "D'accord donc vous avez juste pris ce qui vous passait sous la main."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "peanut_butter_banana_sandwich"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/banana = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de beurre de cacahuète" = 1, "de banane" = 1, "de pain" = 2)
	foodtypes = GRAIN | FRUIT | NUTS
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/philly_cheesesteak
	name = "cheesesteak de Philadelphie"
	desc = "Une sandwich populaire aux États-Unis fait de tranche de viande, d'oignons, de fromage fondu et d'un énorme pain. En terme de description, 'Appétissant' est bien insuffisant."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "philly_cheesesteak"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 8,
	)
	tastes = list("de pain" = 1, "de viande juteuse" = 1, "de fromage fondu" = 1, "d'oignon" = 1)
	foodtypes = GRAIN | MEAT | DAIRY | VEGETABLES
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
