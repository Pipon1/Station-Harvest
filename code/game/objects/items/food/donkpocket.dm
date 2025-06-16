////////////////////////////////////////////DONK POCKETS////////////////////////////////////////////

/obj/item/food/donkpocket
	name = "\improper Donk-pocket"
	desc = "La nourriture de choix pour tout traitre aguerri."
	icon_state = "donkpocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("de viande" = 2, "de pâte" = 2, "de paresse" = 1)
	foodtypes = GRAIN
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

	/// What type of donk pocket we're warmed into via baking or microwaving.
	var/warm_type = /obj/item/food/donkpocket/warm
	/// The lower end for how long it takes to bake
	var/baking_time_short = 25 SECONDS
	/// The upper end for how long it takes to bake
	var/baking_time_long = 30 SECONDS

/obj/item/food/donkpocket/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE)

/obj/item/food/donkpocket/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type)

/obj/item/food/donkpocket/warm
	name = "Donk-pocket chaud"
	desc = "La nourriture chaud de choix pour tout traitre aguerri."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/medicine/omnizine = 6,
	)
	tastes = list("de viande" = 2, "de pâte" = 2, "de paresse" = 1)
	foodtypes = GRAIN

	// Warmed donk pockets will burn if you leave them in the oven or microwave.
	warm_type = /obj/item/food/badrecipe
	baking_time_short = 10 SECONDS
	baking_time_long = 15 SECONDS

/obj/item/food/dankpocket
	name = "\improper Dank-pocket"
	desc = "La nourriture de choix pour tout botaniste aguerri."
	icon_state = "dankpocket"
	food_reagents = list(
		/datum/reagent/toxin/lipolicide = 3,
		/datum/reagent/drug/space_drugs = 3,
		/datum/reagent/consumable/nutriment = 4,
	)
	tastes = list("de viande" = 2, "de pâte" = 2)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/donkpocket/spicy
	name = "\improper Spicy-pocket"
	desc = "Le casse-croûte de base, avec une petite odeur épicée."
	icon_state = "donkpocketspicy"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/capsaicin = 2,
	)
	tastes = list("de viande" = 2, "de pâte" = 2, "d'épices" = 1)
	foodtypes = GRAIN
	warm_type = /obj/item/food/donkpocket/warm/spicy

/obj/item/food/donkpocket/warm/spicy
	name = "Spicy-pocket chaud"
	desc = "Le casse-croûte de base, mais peut-être avec un peu trop d'épices."
	icon_state = "donkpocketspicy"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/capsaicin = 5,
	)
	tastes = list("de viandes" = 2, "de pâte" = 2, "d'épices étranges" = 2)
	foodtypes = GRAIN

/obj/item/food/donkpocket/teriyaki
	name = "\improper Teriyaki-pocket"
	desc = "Une approche est-asiatique du casse-groûte classique."
	icon_state = "donkpocketteriyaki"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/soysauce = 2,
	)
	tastes = list("de viande" = 2, "de pâte" = 2, "de sauce soja" = 2)
	foodtypes = GRAIN
	warm_type = /obj/item/food/donkpocket/warm/teriyaki

/obj/item/food/donkpocket/warm/teriyaki
	name = "Teriyaki-pocket chaud"
	desc = "Une approche est-asiatique du casse-groûte classique, cette fois chaud et avec de la vapeur."
	icon_state = "donkpocketteriyaki"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/soysauce = 2,
	)
	tastes = list("de viande" = 2, "de pâte" = 2, "de sauce soja" = 2)
	foodtypes = GRAIN

/obj/item/food/donkpocket/pizza
	name = "\improper Pizza-pocket"
	desc = "Délicieux, fondant et qui cale étonnamment bien."
	icon_state = "donkpocketpizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/tomatojuice = 2,
	)
	tastes = list("de viande" = 2, "de pâte" = 2, "de fromage"= 2)
	foodtypes = GRAIN
	warm_type = /obj/item/food/donkpocket/warm/pizza

/obj/item/food/donkpocket/warm/pizza
	name = "Pizza-pocket chaud"
	desc = "Délicieux, fondant et encore meilleur chaud."
	icon_state = "donkpocketpizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/tomatojuice = 2,
	)
	tastes = list("de viande" = 2, "de pâte" = 2, "de fromage chaud"= 2)
	foodtypes = GRAIN

/obj/item/food/donkpocket/honk
	name = "\improper Honk-pocket"
	desc = "Le casse-croûte primé ayant déjà gagné le coeur des clowns et des humanoïdes."
	icon_state = "donkpocketbanana"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/banana = 4,
	)
	tastes = list("de banane" = 2, "de pâte" = 2, "d'antibiotiques pour enfant" = 1)
	foodtypes = GRAIN

	warm_type = /obj/item/food/donkpocket/warm/honk

/obj/item/food/donkpocket/warm/honk
	name = "Honk-pocket chaud"
	desc = "Le donk-pocket primé, désormais chaud."
	icon_state = "donkpocketbanana"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/banana = 4,
		/datum/reagent/consumable/laughter = 6,
	)
	tastes = list("de banane" = 2, "de pâte" = 2, "d'antibiotiques pour enfant" = 1)
	foodtypes = GRAIN

/obj/item/food/donkpocket/berry
	name = "\improper Berry-pocket"
	desc = "Un donk-pocket sucré jusqu'à l'écoeurement, à l'origine créé pour l'opération Tempête du Dessert."
	icon_state = "donkpocketberry"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/berryjuice = 3,
	)
	tastes = list("de pâte" = 2, "de confiture" = 2)
	foodtypes = GRAIN

	warm_type = /obj/item/food/donkpocket/warm/berry

/obj/item/food/donkpocket/warm/berry
	name = "Berry-pocket chaud"
	desc = "Un donk-pocket sucré jusqu'à l'écoeurement, désormais chaud et délicieux."
	icon_state = "donkpocketberry"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/consumable/berryjuice = 3,
	)
	tastes = list("de pâte" = 2, "de confiture chaud" = 2)
	foodtypes = GRAIN

/obj/item/food/donkpocket/gondola
	name = "\improper Gondola-pocket"
	desc = "Utiliser de la vraie viande de gondola est un choix controversé." //Only a monster would craft this.
	icon_state = "donkpocketgondola"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/gondola_mutation_toxin = 5,
	)
	tastes = list("de viande" = 2, "de pâte" = 2, "de paix intérieur" = 1)
	foodtypes = GRAIN

	warm_type = /obj/item/food/donkpocket/warm/gondola

/obj/item/food/donkpocket/warm/gondola
	name = "Gondola-pocket chaud"
	desc = "Utiliser de la vraie viande de gondola est un choix controversé."
	icon_state = "donkpocketgondola"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/medicine/omnizine = 2,
		/datum/reagent/gondola_mutation_toxin = 10,
	)
	tastes = list("de viande" = 2, "de pâte" = 2, "de paix intérieur" = 1)
	foodtypes = GRAIN
