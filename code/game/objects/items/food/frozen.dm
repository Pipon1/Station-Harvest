/obj/item/food/icecreamsandwich
	name = "Sandwich à la glace"
	desc = "De la glace transportable avec son propre emballage."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "icecreamsandwich"
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/ice = 4,
	)
	tastes = list("de la glace" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	food_flags = FOOD_FINGER_FOOD

/obj/item/food/strawberryicecreamsandwich
	name = "Sandwich à la glace à la fraise"
	desc = "De la glace transportable avec son propre emballage à fraise."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "strawberryicecreamsandwich"
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/ice = 4,
	)
	tastes = list("de la glace" = 2, "de baies" = 2)
	foodtypes = FRUIT | DAIRY | SUGAR
	food_flags = FOOD_FINGER_FOOD


/obj/item/food/spacefreezy
	name = "Glace à l'italienne de l'espace"
	desc = "La meilleure glace dans l'espace."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "spacefreezy"
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/bluecherryjelly = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de cerises bleues" = 2, "de la glace" = 2)
	foodtypes = FRUIT | DAIRY | SUGAR

/obj/item/food/spacefreezy/make_edible()
	. = ..()
	AddComponent(/datum/component/ice_cream_holder)

/obj/item/food/sundae
	name = "Sundae"
	desc = "Un dessert classique."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "sundae"
	w_class = WEIGHT_CLASS_SMALL
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/banana = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de la glace" = 1, "de banane" = 1)
	foodtypes = FRUIT | DAIRY | SUGAR

/obj/item/food/sundae/make_edible()
	. = ..()
	AddComponent(/datum/component/ice_cream_holder, y_offset = -2, sweetener = /datum/reagent/consumable/caramel)

/obj/item/food/honkdae
	name = "Pouetdae"
	desc = "Le dessert favoris du clown."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "honkdae"
	w_class = WEIGHT_CLASS_SMALL
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/banana = 10,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de la glace" = 1, "de banane" = 1, "d'une mauvaise blague" = 1)
	foodtypes = FRUIT | DAIRY | SUGAR

/obj/item/food/honkdae/make_edible()
	. = ..()
	AddComponent(/datum/component/ice_cream_holder, y_offset = -2) //The sugar will react with the banana forming laughter. Honk!

/////////////
//SNOWCONES//
/////////////

/obj/item/food/snowcones //We use this as a base for all other snowcones
	name = "Cône de neige nature"
	desc = "Juste de la glace pilée. Tout de même marrant à mastiquer."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "flavorless_sc"
	w_class = WEIGHT_CLASS_SMALL
	trash_type = /obj/item/reagent_containers/cup/glass/sillycup //We dont eat paper cups
	food_reagents = list(
		/datum/reagent/water = 11,
	) // We dont get food for water/juices
	tastes = list("de glace" = 1, "d'eau" = 1)
	foodtypes = SUGAR //We use SUGAR as a base line to act in as junkfood, other wise we use fruit
	food_flags = FOOD_FINGER_FOOD

/obj/item/food/snowcones/lime
	name = "Cône de neige au citron vert"
	desc = "Du sirop de citron vert versé sur une boule de neige dans une coupe en papier."
	icon_state = "lime_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/limejuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de citron vert" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/lemon
	name = "Cône de neige au citron"
	desc = "Du sirop de citron versé sur une boule de neige dans une coupe en papier."
	icon_state = "lemon_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/lemonjuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de citron" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/apple
	name = "Cône de neige à la pomme"
	desc = "Du sirop de pomme versé sur une boule de neige dans une coupe en papier."
	icon_state = "amber_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/applejuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de pommes" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/grape
	name = "Cône de glace au raison"
	desc = "Du sirop de raisin versé sur une boule de neige dans une coupe en papier."
	icon_state = "grape_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/grapejuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de raisin" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/orange
	name = "Cône de glace à l'orange"
	desc = "Du sirop d'orange versé sur une boule de neige dans une coupe en papier."
	icon_state = "orange_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/orangejuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "d'orange" = 5)
	foodtypes = FRUIT | ORANGES

/obj/item/food/snowcones/blue
	name = "Cône de glace aux cerises bleues"
	desc = "Du sirop de cerise bleue versé sur une boule de neige dans une coupe en papier."
	icon_state = "blue_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/bluecherryjelly = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de bleu" = 5, "de cerises" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/red
	name = "Cône de glace aux cerises"
	desc = "Du sirop de cerise versé sur une boule de neige dans une coupe en papier."
	icon_state = "red_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/cherryjelly = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de rouge" = 5, "de cerises" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/berry
	name = "Cône de glace aux baies"
	desc = "Du sirop de baies versé sur une boule de neige dans une coupe en papier."
	icon_state = "berry_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/berryjuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de baies" = 5)
	foodtypes = FRUIT

/obj/item/food/snowcones/fruitsalad
	name = "Cône de glace à la salade de fruit"
	desc = "Un mélange excquis de sirop d'agrumes versé sur une boule de neige dans une coupe en papier."
	icon_state = "fruitsalad_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/lemonjuice = 5,
		/datum/reagent/consumable/limejuice = 5,
		/datum/reagent/consumable/orangejuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "d'oranges" = 5, "de citron vert" = 5, "de citron" = 5, "d'agrumes" = 5, "de salade" = 5)
	foodtypes = FRUIT | ORANGES

/obj/item/food/snowcones/pineapple
	name = "Cône de glace à l'ananas"
	desc = "Du sirop d'ananas versé sur une boule de neige dans une coupe en papier."
	icon_state = "pineapple_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/pineapplejuice = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "d'ananas" = 5)
	foodtypes = PINEAPPLE //Pineapple to allow all that like pineapple to enjoy

/obj/item/food/snowcones/mime
	name = "Cône de glace du mime"
	desc = "..."
	icon_state = "mime_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nothing = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de rien" = 5)
	foodtypes = SUGAR

/obj/item/food/snowcones/clown
	name = "Cône de glace du clown"
	desc = "Du rire versé sur une boule de neige dans une coupe en papier."
	icon_state = "clown_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/laughter = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de blagues" = 5, "du mal de tête après avoir mangé de la glace" = 5, "de joie" = 5)
	foodtypes = SUGAR | FRUIT

/obj/item/food/snowcones/soda
	name = "Cône de glace au Cola de l'espace"
	desc = "Du Cola de l'espace versé sur une boule de neige dans une coupe en papier."
	icon_state = "soda_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/space_cola = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de cola" = 5)
	foodtypes = SUGAR

/obj/item/food/snowcones/spacemountainwind
	name = "Cône de glace Space Mountain Wind"
	desc = "Du Space Mountain Wind versé sur une boule de neige dans une coupe en papier."
	icon_state = "mountainwind_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/spacemountainwind = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de mountain wind" = 5)
	foodtypes = SUGAR


/obj/item/food/snowcones/pwrgame
	name = "Cône de glace au Pwrgame"
	desc = "Du Pwrgame versé sur une boule de neige dans une coupe en papier."
	icon_state = "pwrgame_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/pwr_game = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de validité" = 5, "de sel" = 5, "d'électricité" = 5)
	foodtypes = SUGAR

/obj/item/food/snowcones/honey
	name = "Cône de glace au miel"
	desc = "Du miel versé sur une boule de neige dans une coupe en papier."
	icon_state = "amber_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/honey = 5,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de fleurs" = 5, "de sucre" = 5, "de cire" = 1)
	foodtypes = SUGAR

/obj/item/food/snowcones/rainbow
	name = "Cône de glace arc-en-ciel"
	desc = "Une boule de neige très colorée dans une coupe en papier."
	icon_state = "rainbow_sc"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/laughter = 25,
		/datum/reagent/water = 11,
	)
	tastes = list("de glace" = 1, "d'eau" = 1, "de lumière du soleil" = 5, "de lumière" = 5, "de slime" = 5, "de peinture" = 3, "de nuage" = 3)
	foodtypes = SUGAR

/obj/item/food/popsicle
	name = "Glace à l'eau du bug"
	desc = "Mmmmh, cet objet ne devrait très littéralement pas exister."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "popsicle_stick_s"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 4,
	)
	tastes = list("du jus d'insecte")
	trash_type = /obj/item/popsicle_stick
	w_class = WEIGHT_CLASS_SMALL
	foodtypes = DAIRY | SUGAR
	food_flags = FOOD_FINGER_FOOD

	var/overlay_state = "creamsicle_o" //This is the edible part of the popsicle.
	var/bite_states = 4 //This value value is used for correctly setting the bite_consumption to ensure every bite changes the sprite. Do not set to zero.
	var/bitecount = 0


/obj/item/food/popsicle/Initialize(mapload)
	. = ..()
	bite_consumption = reagents.total_volume / bite_states
	update_icon() // make sure the popsicle overlay is primed so it's not just a stick until you start eating it

/obj/item/food/popsicle/make_edible()
	. = ..()
	AddComponent(/datum/component/edible, after_eat = CALLBACK(src, PROC_REF(after_bite)))

/obj/item/food/popsicle/update_overlays()
	. = ..()
	if(!bitecount)
		. += initial(overlay_state)
		return
	. += "[initial(overlay_state)]_[min(bitecount, 3)]"

/obj/item/food/popsicle/proc/after_bite(mob/living/eater, mob/living/feeder, bitecount)
	src.bitecount = bitecount
	update_appearance()

/obj/item/popsicle_stick
	name = "Bâteau de glace à l'eau"
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "popsicle_stick"
	desc = "Cet humble petit baton porte une friandise glacée. Pour le moment, il semble libre de ce poids herculéen."
	custom_materials = list(/datum/material/wood = 20)
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	force = 0

/obj/item/food/popsicle/creamsicle_orange
	name = "Glace à l'orange"
	desc = "Une glace à l'orange classique. Une friandise glacé ensoleillée."
	food_reagents = list(
		/datum/reagent/consumable/orangejuice = 4,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 4,
	)
	foodtypes = FRUIT | DAIRY | SUGAR | ORANGES

/obj/item/food/popsicle/creamsicle_berry
	name = "Glace aux baies"
	desc = "Une glace aux baies à la couleur vibrante. Une bonne briandise fruitée et glacée."
	food_reagents = list(
		/datum/reagent/consumable/berryjuice = 4,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 4,
	)
	overlay_state = "creamsicle_m"
	foodtypes = FRUIT | DAIRY | SUGAR

/obj/item/food/popsicle/jumbo
	name = "Grosse glace"
	desc = "Une crème glacée luxueuse richement nappée dans du chocolat. Semble plus petite que ce que vous vous souvenez."
	food_reagents = list(
		/datum/reagent/consumable/hot_coco = 4,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 3,
		/datum/reagent/consumable/sugar = 2,
	)
	overlay_state = "jumbo"

/obj/item/food/popsicle/licorice_creamsicle
	name = "Barre de vide™"
	desc = "Une glace salée à la réglisse. Une friandise salée et glacée."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 1,
		/datum/reagent/consumable/sugar = 4,
	)
	tastes = list("de réglisse salée")
	overlay_state = "licorice_creamsicle"

/obj/item/food/cornuto
	name = "Cornuto"
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "cornuto"
	desc = "Un cornet de crème glacée napolitaine à la vanille et au chocolat. Soupoudré d'éclats de noix caramélisée."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/hot_coco = 4,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 4,
		/datum/reagent/consumable/sugar = 2,
	)
	tastes = list("de noisettes émincées", "de gaufre")
	foodtypes = DAIRY | SUGAR
	venue_value = FOOD_PRICE_NORMAL
