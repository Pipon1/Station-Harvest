// Pizza (Whole)
/obj/item/food/pizza
	icon = 'icons/obj/food/pizza.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	max_volume = 80
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 28,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1)
	foodtypes = GRAIN | DAIRY | VEGETABLES
	venue_value = FOOD_PRICE_CHEAP
	burns_in_oven = TRUE
	/// type is spawned 6 at a time and replaces this pizza when processed by cutting tool
	var/obj/item/food/pizzaslice/slice_type
	///What label pizza boxes use if this pizza spawns in them.
	var/boxtag = ""

/obj/item/food/pizza/raw
	foodtypes = GRAIN | DAIRY | VEGETABLES | RAW
	burns_in_oven = FALSE
	slice_type = null

/obj/item/food/pizza/raw/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza, rand(70 SECONDS, 80 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/make_processable()
	if (slice_type)
		AddElement(/datum/element/processable, TOOL_KNIFE, slice_type, 6, 3 SECONDS, table_required = TRUE, screentip_verb = "Couper")
		AddElement(/datum/element/processable, TOOL_SAW, slice_type, 6, 4.5 SECONDS, table_required = TRUE, screentip_verb = "Couper")
		AddElement(/datum/element/processable, TOOL_SCALPEL, slice_type, 6, 6 SECONDS, table_required = TRUE, screentip_verb = "Couper")

// Pizza Slice
/obj/item/food/pizzaslice
	icon = 'icons/obj/food/pizza.dmi'
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	foodtypes = GRAIN | DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	decomp_type = /obj/item/food/pizzaslice/moldy

/obj/item/food/pizzaslice/make_processable()
	AddElement(/datum/element/processable, TOOL_ROLLINGPIN, /obj/item/stack/sheet/pizza, 1, 1 SECONDS, table_required = TRUE, screentip_verb = "Aplatir")

/obj/item/food/pizza/margherita
	name = "pizza margherita"
	desc = "La pizza la plus basique de la galaxie."
	icon_state = "pizzamargherita"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 25,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY
	slice_type = /obj/item/food/pizzaslice/margherita
	boxtag = "Margherita Deluxe"


/obj/item/food/pizza/margherita/raw
	name = "pizza margherita crue"
	icon_state = "pizzamargherita_raw"
	foodtypes = GRAIN | VEGETABLES | DAIRY | RAW
	burns_in_oven = FALSE
	slice_type = null

/obj/item/food/pizza/margherita/raw/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/margherita, rand(70 SECONDS, 80 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/margherita/robo
	food_reagents = list(
		/datum/reagent/cyborg_mutation_nanomachines = 70,
		/datum/reagent/consumable/nutriment = 25,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)

/obj/item/food/pizzaslice/margherita
	name = "part de margherita"
	desc = "Une part de la pizza la plus basique de la galaxie."
	icon_state = "pizzamargheritaslice"
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/pizzaslice/margherita/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, null, CUSTOM_INGREDIENT_ICON_FILL, max_ingredients = 12)

/obj/item/food/pizza/meat
	name = "pizza à la viande"
	desc = "Un pizza avec de la délicieuse viande."
	icon_state = "meatpizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 25,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 8,
	)
	foodtypes = GRAIN | VEGETABLES| DAIRY | MEAT
	slice_type = /obj/item/food/pizzaslice/meat
	boxtag = "Super pizza viande"

/obj/item/food/pizza/meat/raw
	name = "pizza à la viande crue"
	icon_state = "meatpizza_raw"
	foodtypes = GRAIN | VEGETABLES| DAIRY | MEAT | RAW
	burns_in_oven = FALSE
	slice_type = null

/obj/item/food/pizza/meat/raw/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/meat, rand(70 SECONDS, 80 SECONDS), TRUE, TRUE)

/obj/item/food/pizzaslice/meat
	name = "part de pizza à la viande"
	desc = "Une part de pizza à la viande."
	icon_state = "meatpizzaslice"
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "de viande" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | MEAT

/obj/item/food/pizza/mushroom
	name = "pizza aux champignons"
	desc = "Une pizza très spéciale."
	icon_state = "mushroompizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 28,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "de champignon" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY
	slice_type = /obj/item/food/pizzaslice/mushroom
	boxtag = "Speciale champignon"

/obj/item/food/pizza/mushroom/raw
	name = "pizza aux champignons crue"
	icon_state = "mushroompizza_raw"
	foodtypes = GRAIN | VEGETABLES | DAIRY | RAW
	burns_in_oven = FALSE
	slice_type = null

/obj/item/food/pizza/mushroom/raw/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/mushroom, rand(70 SECONDS, 80 SECONDS), TRUE, TRUE)

/obj/item/food/pizzaslice/mushroom
	name = "part de pizza aux champignons"
	desc = "Peut-être que c'est la dernière part de pizza de votre vie."
	icon_state = "mushroompizzaslice"
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "de champignon" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY


/obj/item/food/pizza/vegetable
	name = "pizza végétarienne"
	desc = "Pour ceux qui aiment les légumes."
	icon_state = "vegetablepizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 25,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de croûte" = 1, "de tomate" = 2, "de fromage" = 1, "de carotte" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY
	slice_type = /obj/item/food/pizzaslice/vegetable
	boxtag = "Gourmet végétarien"
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/pizza/vegetable/raw
	name = "pizza végétarienne crue"
	icon_state = "vegetablepizza_raw"
	foodtypes = GRAIN | VEGETABLES | DAIRY | RAW
	burns_in_oven = FALSE
	slice_type = null

/obj/item/food/pizza/vegetable/raw/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/vegetable, rand(70 SECONDS, 80 SECONDS), TRUE, TRUE)

/obj/item/food/pizzaslice/vegetable
	name = "part de pizza végétarienne"
	desc = "Peut donner des envies de ratatouille..."
	icon_state = "vegetablepizzaslice"
	tastes = list("de croûte" = 1, "de tomate" = 2, "de fromage" = 1, "de carotte" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/pizza/donkpocket
	name = "pizza donkpocket"
	desc = "Qui a pensé que c'était une bonne idée ?"
	icon_state = "donkpocketpizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/protein = 15,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/medicine/omnizine = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "de viande" = 1, "de fainéantise" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | MEAT | JUNKFOOD
	slice_type = /obj/item/food/pizzaslice/donkpocket
	boxtag = "Ding-Donk"

/obj/item/food/pizza/donkpocket/raw
	name = "pizza donkpocket crue"
	icon_state = "donkpocketpizza_raw"
	foodtypes = GRAIN | VEGETABLES | DAIRY | MEAT | JUNKFOOD | RAW
	burns_in_oven = FALSE
	slice_type = null

/obj/item/food/pizza/donkpocket/raw/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/donkpocket, rand(70 SECONDS, 80 SECONDS), TRUE, TRUE)

/obj/item/food/pizzaslice/donkpocket
	name = "part de pizza donkpocket"
	desc = "Sent comme des donkpockets."
	icon_state = "donkpocketpizzaslice"
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "de viande" = 1, "de fainéantise" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | MEAT | JUNKFOOD

/obj/item/food/pizza/dank
	name = "pizza dank"
	desc = "Pas sûr que tout soit très bon pour la santé, là dedans..."
	icon_state = "dankpizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 25,
		/datum/reagent/consumable/doctor_delight = 5,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "de viande" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY
	slice_type = /obj/item/food/pizzaslice/dank
	boxtag = "Herbes Fraiches"

/obj/item/food/pizza/dank/raw
	name = "pizza dank crue"
	icon_state = "dankpizza_raw"
	foodtypes = GRAIN | VEGETABLES | DAIRY | RAW
	burns_in_oven = FALSE
	slice_type = null

/obj/item/food/pizza/dank/raw/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/dank, rand(70 SECONDS, 80 SECONDS), TRUE, TRUE)

/obj/item/food/pizzaslice/dank
	name = "part de pizza dank"
	desc = "Encore plus belle une fois mangée."
	icon_state = "dankpizzaslice"
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "de viande" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/pizza/sassysage
	name = "pizza insaucisse"
	desc = "Vous pouvez presque goûter l'insolence..."
	icon_state = "sassysagepizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/protein = 15,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "de viande" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | MEAT
	slice_type = /obj/item/food/pizzaslice/sassysage
	boxtag = "Amoureux des saucisses"

/obj/item/food/pizza/sassysage/raw
	name = "pizza insaucisse crue"
	icon_state = "sassysagepizza_raw"
	foodtypes = GRAIN | VEGETABLES | DAIRY | MEAT | RAW
	burns_in_oven = FALSE
	slice_type = null

/obj/item/food/pizza/sassysage/raw/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/sassysage, rand(70 SECONDS, 80 SECONDS), TRUE, TRUE)

/obj/item/food/pizzaslice/sassysage
	name = "part de pizza insaucisse"
	desc = "Deliciously sassy."
	icon_state = "sassysagepizzaslice"
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "de viande" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | MEAT

/obj/item/food/pizza/pineapple
	name = "\improper pizza hawaïenne"
	desc = "Celle-ci peut provoquer des guerres ou réunir des peuples."
	icon_state = "pineapplepizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/pineapplejuice = 8,
	)
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "d'ananas" = 2, "de jambe" = 2)
	foodtypes = GRAIN | VEGETABLES | DAIRY | MEAT | FRUIT | PINEAPPLE
	slice_type = /obj/item/food/pizzaslice/pineapple
	boxtag = "Pizza de guerre"

/obj/item/food/pizza/pineapple/raw
	name = "pizza hawaïenne crue"
	icon_state = "pineapplepizza_raw"
	foodtypes = GRAIN | VEGETABLES | DAIRY | MEAT | FRUIT | PINEAPPLE | RAW
	burns_in_oven = FALSE
	slice_type = null

/obj/item/food/pizza/pineapple/raw/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/pineapple, rand(70 SECONDS, 80 SECONDS), TRUE, TRUE)

/obj/item/food/pizzaslice/pineapple
	name = "\improper part de pizza hawaïenne"
	desc = "Une part d'une délicieuse controverse."
	icon_state = "pineapplepizzaslice"
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "d'ananas" = 2, "de jambe" = 2)
	foodtypes = GRAIN | VEGETABLES | DAIRY | MEAT | FRUIT | PINEAPPLE


// Moldly Pizza
// Used in cytobiology.
/obj/item/food/pizzaslice/moldy
	name = "part de pizza moisie"
	desc = "Autrefois c'était une part d'une provabablement délicieuse pizza. Maintenant ça traine là, rancie et plein de moisissures. \
		Quelle déception ! Mais on ne doit pas vivre dans le passé, il faut regarder vers l'avenir."
	icon_state = "moldy_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/peptides = 3,
		/datum/reagent/consumable/tomatojuice = 1,
		/datum/reagent/toxin/amatoxin = 2,
	)
	tastes = list("de croûte racie" = 1, "de fromage moisie" = 2, "de champignon" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | GROSS
	preserved_food = TRUE

/obj/item/food/pizzaslice/moldy/bacteria
	name = "part de pizza moisie riche en bactéries"
	desc = "Non seulement ce qui était auparavant une délicieuse part de pizza est maintenant couverte de spores, mais il semblerait même qu'une nouvelle forme de vie soit en train de s'y développer."

/obj/item/food/pizzaslice/moldy/bacteria/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOLD, CELL_VIRUS_TABLE_GENERIC, rand(2, 4), 25)

// Arnold Pizza
// Has meme code. French's edit : C'est vieux et pas plus drole que ça, désolée :/.
/obj/item/food/pizza/arnold
	name = "\improper pizza d'Arnold"
	desc = "Hello, you've reached Arnold's pizza shop. I'm not here now, I'm out killing pepperoni."
	icon_state = "arnoldpizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 25,
		/datum/reagent/consumable/nutriment/protein = 9,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/iron = 10,
		/datum/reagent/medicine/omnizine = 30,
	)
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "de pepperoni" = 2, "de balles de 9 millimètres" = 2)
	slice_type = /obj/item/food/pizzaslice/arnold
	boxtag = "9mm Pepperoni"

/obj/item/food/pizza/arnold/raw
	name = "pizza d'Arnold crue"
	icon_state = "arnoldpizza_raw"
	foodtypes = GRAIN | DAIRY | VEGETABLES | RAW
	burns_in_oven = FALSE
	slice_type = null

/obj/item/food/pizza/arnold/raw/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/arnold, rand(70 SECONDS, 80 SECONDS), TRUE, TRUE)

//fuck it, i will leave this at the food level for now.
/obj/item/food/proc/try_break_off(mob/living/attacker, mob/living/user) //maybe i give you a pizza maybe i break off your arm
	if(prob(50) || (attacker != user) || !iscarbon(user) || HAS_TRAIT(user, TRAIT_NODISMEMBER))
		return
	var/obj/item/bodypart/arm/left = user.get_bodypart(BODY_ZONE_L_ARM)
	var/obj/item/bodypart/arm/right = user.get_bodypart(BODY_ZONE_R_ARM)
	var/did_the_thing = (left?.dismember() || right?.dismember()) //not all limbs can be removed, so important to check that we did. the. thing.
	if(!did_the_thing)
		return
	to_chat(user, span_userdanger("Peut-être que je vais te donner un pizza, peut-être que je vais te casser le bras.")) //makes the reference more obvious
	user.visible_message(span_warning("La [src] casse le bras de [user] !"), span_warning("La [src] casse votre bras !"))
	playsound(user, SFX_DESECRATION, 50, TRUE, -1)

/obj/item/food/proc/i_kill_you(obj/item/item, mob/living/user)
	if(istype(item, /obj/item/food/pineappleslice))
		to_chat(user, "<font color='red' size='7'>Si tu veux quelque chose de bizarre comme de l'ananas, je te tue..</font>") //this is in bigger text because it's hard to spam something that gibs you, and so that you're perfectly aware of the reason why you died
		user.investigate_log("a été étripé en mettant de l'ananas sur un pizza d'Arnold.", INVESTIGATE_DEATHS)
		user.gib() //if you want something crazy like pineapple, i'll kill you
	else if(istype(item, /obj/item/food/grown/mushroom) && iscarbon(user))
		to_chat(user, span_userdanger("Donc, si tu veux des champignons, ta gueule.")) //not as large as the pineapple text, because you could in theory spam it
		var/mob/living/carbon/shutup = user
		shutup.gain_trauma(/datum/brain_trauma/severe/mute)

/obj/item/food/pizza/arnold/attack(mob/living/target, mob/living/user)
	. = ..()
	try_break_off(target, user)

/obj/item/food/pizza/arnold/attackby(obj/item/item, mob/user)
	i_kill_you(item, user)
	. = ..()

/obj/item/food/pizzaslice/arnold
	name = "\improper part de pizza d'Arnold"
	desc = "Je viens, peut-être que je te donne une pizza, peut-être que je te casse le bras."
	icon_state = "arnoldpizzaslice"
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "de pepperoni" = 2, "de balles de 9 millimètres" = 2)
	foodtypes = GRAIN | VEGETABLES | DAIRY | MEAT

/obj/item/food/pizzaslice/arnold/attack(mob/living/target, mob/living/user)
	. =..()
	try_break_off(target, user)

/obj/item/food/pizzaslice/arnold/attackby(obj/item/item, mob/user)
	i_kill_you(item, user)
	. = ..()

// Ant Pizza, now with more ants.
/obj/item/food/pizzaslice/ants
	name = "\improper part de pizza fête à la fourmie"
	desc = "La clé pour une part de pizza parfaite, c'est de ne pas abuser avec les fourmis."
	icon_state = "antpizzaslice"
	food_reagents = list(
		/datum/reagent/ants = 5,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1, "d'insectes" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | BUGS

// Ethereal Pizza, for when they want a slice
/obj/item/food/pizza/energy
	name = "pizza énergique"
	desc = "Vous pouvez probablement alimenter un RIPLEY, avec ça. Vous ne devriez probablement pas manger ça, si vous n'êtes pas un Éthéré."
	icon_state ="energypizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 18,
		/datum/reagent/consumable/liquidelectricity/enriched = 18,
	)
	tastes = list("d'électricité pure" = 4, "de pizza" = 2)
	slice_type = /obj/item/food/pizzaslice/energy
	foodtypes = TOXIC
	boxtag = "Énergie pour 24 heures"

/obj/item/food/pizza/energy/raw
	name = "pizza énergique crue"
	icon_state = "energypizza_raw"
	foodtypes = TOXIC
	burns_in_oven = FALSE
	slice_type = null

/obj/item/food/pizza/energy/raw/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/energy, rand(70 SECONDS, 80 SECONDS), TRUE, TRUE)

/obj/item/food/pizzaslice/energy
	name = "part de pizza énergique"
	desc = "Vous êtes en train de vous demander si vous pouvez charger votre combinaison avec ça. Évitez."
	icon_state ="energypizzaslice"
	tastes = list("d'électricité pure" = 4, "de pizza" = 2)
	foodtypes = TOXIC

/obj/item/food/raw_meat_calzone
	name = "calzone à la viande crue"
	desc = "Une calzone crue, prête à passer au four."
	icon_state = "raw_calzone"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("de pâte crue" = 1, "de viande crue" = 1, "de fromage froid" = 1, "de sauce tomate froide" = 1)
	foodtypes = GRAIN | RAW | DAIRY | MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_meat_calzone/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/meat_calzone, rand(20 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/meat_calzone
	name = "calzone à la viande"
	desc = "Une calzone garnie avec du fromage, de la viande et de la sauce tomate. Attention à ne pas vous bruler la langue !"
	icon_state = "meat_calzone"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/nutriment/protein = 6,
	)
	tastes = list("de croûte" = 1, "de viande juteuse" = 1, "de fromage fondue" = 1, "de sauce tomate" = 1)
	foodtypes = GRAIN | DAIRY | MEAT
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/raw_vegetarian_calzone
	name = "calzone végétarienne crue"
	desc = "Une calzone crue, prête à être mise au four !"
	icon_state = "raw_calzone"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de pâte crue" = 1, "de légume croquant" = 1, "de sauce tomate froide" = 1)
	foodtypes = GRAIN | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_vegetarian_calzone/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/vegetarian_calzone, rand(20 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/vegetarian_calzone
	name = "calzone végétarienne"
	desc = "Une calzone garnie de légumes et de sauce tomate. Peut-être plus saine que son équivalente avec de la viande."
	icon_state = "vegetarian_calzone"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 8,
	)
	tastes = list("de croûte" = 1, "de légume cuit" = 1, "de sauce tomate" = 1)
	foodtypes = GRAIN | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE
