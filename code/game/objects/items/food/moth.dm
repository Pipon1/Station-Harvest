//Moth Foods, the three C's: cheese, coleslaw, and cotton
//A large emphasis has been put on sharing and multiple portion dishes
//Additionally, where a mothic name is given, a short breakdown of what exactly it means is provided, for the curious on the internal workings of mothic: it's very onomatopoeic, and makes heavy use of combined words and accents
//French's edit : J'ai fait le choix de laisser les noms mothiens tel quel pour faciliter la cohérence des traductions. Un mothien, une mothienne, les moths (pas de traduction de 'moth' parce que c'est vague et moche sinon).

//Base ingredients and miscellany, generally not served on their own
/obj/item/food/herby_cheese
	name = "fromage aux herbes"
	desc = "Une des bases de la cuisine mothienne, le fromage étant agrémenté de differentes saveurs pour garder de la variéter. \
		Les herbes sont un de ces ajouts possibles, et un des plus appréciés."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "herby_cheese"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6)
	tastes = list("de fromage" = 1, "d'herbes" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/grilled_cheese
	name = "fromage grillé"
	desc = "Comme l'a dit le Seigneur Alton, loué soit son nom, 99.997% de ce que les anglophones appelent grilled cheese sont des mensonges : \
		Ce n'est jamais du fromage grillé, c'est seulement des sandwich au fromage fondu. Mais ça, c'est vraiment du fromage grillé, avec les marques de la grille et tout !"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "grilled_cheese"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/char = 1,
	)
	tastes = list("de fromage" = 1, "de grillade" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/mothic_salad
	name = "salade mothienne"
	desc = "Une salade de base composée de chou, d'oignons rouges et de tomates. Tellement de salades possibles."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "mothic_salad"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("de salade" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/toasted_seeds
	name = "graines grillées"
	desc = "Ça ne remplit pas l'estomac, mais c'est un en-cas très populaire chez les moths ! \
		Du sel, du sucre et même d'autres saveurs plus exotiques peuvent y être ajoutées pour donner plus de piment."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "toasted_seeds"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("de graine" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/engine_fodder
	name = "combustible à moteur"
	desc = "Un en-cas commun parmi les ingénieurs de la flotte mothienne. Composé de graines, de noix, de chocolat, de popcorn et de chips. \
		designé pour être dense en calories et facile à manger pour quand on a besoin d'un coup de boost."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "engine_fodder"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/sugar = 4,
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/salt = 2,
	)
	tastes = list("de graines" = 1, "de noix" = 1, "de chocolat" = 1, "de sel" = 1, "de popcorn" = 1, "de pomme de terre" = 1)
	foodtypes = GRAIN | NUTS | VEGETABLES | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/mothic_pizza_dough
	name = "pâte à pizza mothienne"
	desc = "Une solide pâte glutineuse, faite avec de la semoule de maïs et de la farine, traditionnellement garnie avec du fromage et de la sauce."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "mothic_pizza_dough"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("de farine crue" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL

//Entrees: categorising food that is 90% cheese and salad is not easy
/obj/item/food/squeaking_stir_fry
	name = "skeklitmischtpoppl" //skeklit = squeaking, mischt = stir, poppl = fry
	desc = "Un classique mothien, fait avec du fromage en grain et du tofu (entre autre). \
		Traduit littéralement, le nom veut dire 'couinement mélanger frir', un nom dû au couinement distinctif des protéines."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "squeaking_stir_fry"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de fromage" = 1, "de tofu" = 1, "de légumes" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/sweet_chili_cabbage_wrap
	name = "wrap de chou au piment doux"
	desc = "Du fromage grillé et de la salade dans un wrap de chou, relevé avec de la sauce pimentée."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "sweet_chili_cabbage_wrap"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 8,
		/datum/reagent/consumable/capsaicin = 1,
	)
	tastes = list("de fromage" = 1, "de salade" = 1, "de piment doux" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/loaded_curds
	name = "ozlsettitæloskekllön ede potatoes" //ozlsettit = overflowing (ozl = over, sett = flow, it = ing), ælo = cheese, skekllön = curds (skeklit = squeaking, llön = pieces/bits), ede = and, pommes = fries (hey, France!) (french's edit : ...Hey)
	desc = "Quoi de mieux que du fromage en grains ? Du fromage en grains frit ! Quoi de mieux que du fromage en grains frit ? \
		La même chose, mais avec du piment et plus de fromage ! Encore encore mieux si on le met sur des frites !"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "loaded_curds"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/capsaicin = 1,
	)
	tastes = list("de fromage" = 1, "d'huile" = 1, "de piment" = 1, "de frites" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/baked_cheese
	name = "meule de fromage au four"
	desc = "Une meule de fromage rôtie, fondante et délicieuse."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "baked_cheese"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/nutriment = 5,
	)
	tastes = list("de fromage" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/baked_cheese_platter
	name = "stanntkraktælo" //stannt = oven, krakt = baked, ælo = cheese
	desc = "Une meule de fromage rôtie : Le meilleur témoin de la tradition de partage des moths. Généralement servi avec du pain grillé, \
		parce que la seule chose encore meilleure que du bon fromage, c'est du bon fromage sur du pain."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "baked_cheese_platter"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 12,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/nutriment = 8,
	)
	tastes = list("du fromage" = 1, "du pain" = 1)
	foodtypes = DAIRY | GRAIN
	w_class = WEIGHT_CLASS_SMALL

//Baked Green Lasagna at the Whistlestop Cafe
/obj/item/food/raw_green_lasagne
	name = "lasagnes vertes crue"
	desc = "De bonnes lasagnes au pesto et à la sauce blanche pleine d'herbes, prêtes à être cuites ! Contient plusieurs portions."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_green_lasagne"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("de fromage" = 1, "de pesto" = 1, "de pâtes" = 1)
	foodtypes = VEGETABLES | GRAIN | NUTS | RAW
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/food/raw_green_lasagne/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/green_lasagne, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/green_lasagne
	name = "lasagnes vertes"
	desc = "De bonnes lasagnes au pesto et à la sauce blanche pleine d'herbes ! Contient plusieurs portions."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "green_lasagne"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 24,
		/datum/reagent/consumable/nutriment/vitamin = 18,
	)
	tastes = list("de fromage" = 1, "de pesto" = 1, "de pâtes" = 1)
	foodtypes = VEGETABLES | GRAIN | NUTS
	w_class = WEIGHT_CLASS_NORMAL
	burns_in_oven = TRUE

/obj/item/food/green_lasagne/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/green_lasagne_slice, 6, 3 SECONDS, table_required = TRUE,  screentip_verb = "coupe")

/obj/item/food/green_lasagne_slice
	name = "part de lasagnes vertes"
	desc = "Une part de lasagnes au pesto et aux herbes."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "green_lasagne_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de fromage" = 1, "pde esto" = 1, "de pâtes" = 1)
	foodtypes = VEGETABLES | GRAIN | NUTS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_baked_rice
	name = "grand woke de riz cru"
	desc = "Une grande poêle de pommes de terre, recouvertes de riz et de bouillon de légumes, prête à être cuite en un superbe plat à partager."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_baked_rice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("de riz" = 1, "de pommes de terre" = 1, "de légumes" = 1)
	foodtypes = VEGETABLES | GRAIN | RAW
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/food/raw_baked_rice/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/big_baked_rice, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/big_baked_rice
	name = "grand woke de riz"
	desc = "Un plat mothien, le riz peut être garni d'une grande variété de légumes pour créer une délicieux plat à partager. \
		Des pommes de terre sont souvent disposées au fond de la poêle, comme ici, pour créer une croute savoureuse souvent disputée par les convives."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "big_baked_rice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 18,
		/datum/reagent/consumable/nutriment/vitamin = 42,
	)
	tastes = list("du riz" = 1, "de pommes de terre" = 1, "de légumes" = 1)
	foodtypes = VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_NORMAL
	burns_in_oven = TRUE

/obj/item/food/big_baked_rice/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/lil_baked_rice, 6, 3 SECONDS, table_required = TRUE, screentip_verb = "Coupe")

/obj/item/food/lil_baked_rice
	name = "part du woke de riz"
	desc = "Une part individuelle du grand woke de riz, parfait en accompagnement ou même pour un plat complet."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "lil_baked_rice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 7,
	)
	tastes = list("de riz" = 1, "de pommes de terre" = 1, "de légumes" = 1)
	foodtypes = VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/oven_baked_corn
	name = "maïs au four"
	desc = "Un épi de maïs rôti au four jusqu'à ce qu'il soit noircit. \
		Un ingrédient apprécié pour son goût, sa simplicité et ses possibilités de combinaison avec d'autres plats de la Flotte."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "oven_baked_corn"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/char = 1,
	)
	tastes = list("de maïs" = 1, "de brulé" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/buttered_baked_corn
	name = "maïs au four beurré"
	desc = "Quoi de mieux qu'un épi de maïs au four ? Un épi de maïs au four, beurré comme il faut !"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "buttered_baked_corn"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/char = 1,
	)
	tastes = list("de maïs" = 1, "de brulé" = 1, "de beurre" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fiesta_corn_skillet
	name = "poêlée de maïs de fête"
	desc = "Doux, pimenté, en sauce... 50 nuances de maïs !"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "fiesta_corn_skillet"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/char = 1,
	)
	tastes = list("de maïs" = 1, "de piment" = 1, "de brulé" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_ratatouille
	name = "ratatouille crue" //rawtatouille? French's edit : Oui.
	desc = "Des morceaux de légumes avec une sauce au poivre rôti. Délicieux, mais manque encore de cuisson."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_ratatouille"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 8,
		/datum/reagent/consumable/char = 1,
	)
	tastes = list("de légumes" = 1, "de poivre rôti" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_ratatouille/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/ratatouille, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/ratatouille
	name = "ratatouille"
	desc = "Des morceaux de légumes avec une sauce au poivre rôti. Délicieux, surtout pour un.e critique culinaire qui va décidé du sort de votre restaurant."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "ratatouille"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/char = 1,
	)
	tastes = list("de légumes" = 1, "de poivre rôti" = 1, "de brulé" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/mozzarella_sticks
	name = "baton de mozzarella"
	desc = "Des petits batons de mozzarella avec de la pannure, frits ."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "mozzarella_sticks"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 6,
	)
	tastes = list("de fromage fondant" = 1, "de pannure" = 1, "d'huile" = 1)
	foodtypes = DAIRY | GRAIN | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_stuffed_peppers
	name = "voltölpaprik crue" //voltöl = stuffed (vol = full, töl = push), paprik (from German paprika) = bell pepper
	desc = "Un poivron sans chapeau et garni d'un mélange de fromage herbeux et d'oignons. Ne devrait probablement pas être mangé cru."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_stuffed_pepper"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 6,
	)
	tastes = list("de fromage fondant" = 1, "d'herbes" = 1, "d'oignon" = 1, "de poivron" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_stuffed_peppers/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/stuffed_peppers, rand(10 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/stuffed_peppers
	name = "voltölpaprik"
	desc = "Un poivron doux mais encore croustillant, rempli d'un fromage fondant incroyable."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "stuffed_pepper"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 8,
	)
	tastes = list("de fromage crémeux" = 1, "d'herbes" = 1, "d'oignon" = 1, "de poivron" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/fueljacks_lunch
	name = "\improper déjeuner des écumeurs"
	desc = "Un plat à base de légumes frits, populaire parmi les écumeurs de carburant, les braves moths qui gérent les écumoires à carburant qui permettent à la Flotte de continuer à tourner. \
		Étant donné leur besoin constant en carburant, et la très petite fenêtre pendant lequel les étoiles s'allignent (littéralement)pour permettre la récolte, \
		iels prennent souvent des repas tout prêt. Cela leur permet de gagner le temps de trajet jusqu'à la cafétériat. Réchauffer son repas est alors un vrai savoir faire."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "fueljacks_lunch"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/protein = 8,
	)
	tastes = list("de chou" = 1, "de pomme de terre" = 1, "d'oignon" = 1, "de piment" = 1, "de fromage" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/mac_balls
	name = "macheronirölen"
	desc = "Des boules de macaroni au fromage, enroulées dans de la pâte de maïs, frits et servies avec de la sauce tomate. \
		Un en-cas populaire dans toute la galaxie, mais tout particulièrement dans la Flotte mothienne."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "mac_balls"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 10,
	)
	tastes = list("de pâte" = 1, "de pain au maïs" = 1, "de fromage" = 1)
	foodtypes = DAIRY | VEGETABLES | FRIED | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/sustenance_bar
	name = "surplus de BSP de la Flotte"
	desc = "La BSP, Barre de Subsistance Préemballée, est un paquet dense de nutriments conçu pour être distribué à la population pendant les famines. \
		Fait à partir de soja et de petits pois. Chaque paquet est fait pour durer 3 jours, si rationné correctement. Même s'ils ont l'avantage de se concerver longtemps, \
		ils finissent quand même par se dégrader, ce qui pousse la Flotte à vendre les surplus. Celui-là en particulier est, comme la plupart des saveurs venant de l'industrie mothienne, a le goût d'herbes."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "sustenance_bar"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20)
	tastes = list("d'herbes" = 1)
	foodtypes = VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/sustenance_bar/neapolitan
	name = "surplus de BSP napolitain de la Flotte"
	desc = "La BSP, Barre de Subsistance Préemballée, est un paquet dense de nutriments conçu pour être distribué à la population pendant les famines. \
		Fait à partir de soja et de petits pois. Chaque paquet est fait pour durer 3 jours, si rationné correctement. Même s'ils ont l'avantage de se concerver longtemps, \
		ils finissent quand même par se dégrader, ce qui pousse la Flotte à vendre les surplus. Celui-là en particulier se veut au goût napolitain : Fraise, vanille, chocolat."
	tastes = list("de fraise" = 1, "de vanille" = 1, "de chocolat" = 1)

/obj/item/food/sustenance_bar/cheese
	name = "surplus de BSP aux trois fromages de la Flotte"
	desc = "La BSP, Barre de Subsistance Préemballée, est un paquet dense de nutriments conçu pour être distribué à la population pendant les famines. \
		Fait à partir de soja et de petits pois. Chaque paquet est fait pour durer 3 jours, si rationné correctement. Même s'ils ont l'avantage de se concerver longtemps, \
		ils finissent quand même par se dégrader, ce qui pousse la Flotte à vendre les surplus. Celui-là en particulier se veut au goût trois fromages : Parmesan, mozzarella, cheddar."
	tastes = list("de parmesan" = 1, "de mozzarella" = 1, "de cheddar" = 1)

/obj/item/food/sustenance_bar/mint
	name = "surplus de BSP à la glace menthe-chocolat de la Flotte"
	desc = "La BSP, Barre de Subsistance Préemballée, est un paquet dense de nutriments conçu pour être distribué à la population pendant les famines. \
		Fait à partir de soja et de petits pois. Chaque paquet est fait pour durer 3 jours, si rationné correctement. Même s'ils ont l'avantage de se concerver longtemps, \
		ils finissent quand même par se dégrader, ce qui pousse la Flotte à vendre les surplus. Celui-là en particulier se veut au goût de glace menthe-chocolat : Menthe, \
		chocolat noir, chips, ce qui montre que les moths n'ont aucune idée de ce qu'est la glace menthe-chocolat."
	tastes = list("de menthe" = 1, "de chips(?)" = 1, "de chocolat noir" = 1)

/obj/item/food/sustenance_bar/wonka
	name = "surplus de BSP aux trois soupers de la Flotte"
	desc = "La BSP, Barre de Subsistance Préemballée, est un paquet dense de nutriments conçu pour être distribué à la population pendant les famines. \
		Fait à partir de soja et de petits pois. Chaque paquet est fait pour durer 3 jours, si rationné correctement. Même s'ils ont l'avantage de se concerver longtemps, \
		ils finissent quand même par se dégrader, ce qui pousse la Flotte à vendre les surplus. Celui-là en particulier est séparé en trois goûts pour faire un repas typique : \
		Soupe à la tomate, citrouille rôtie, tarte à la myrtille." //Thankfully not made by Willy Wonka
	tastes = list("de soupe de tomate" = 1, "de citrouille rôtie" = 1, "de tarte à la myrtille" = 1)

/obj/item/food/bowled/hua_mulan_congee
	name = "\improper congree d'Hua Mulan"
	desc = "Personne ne sait vraiment pourquoi ce bol de gruaut de riz avec des oeufs et du bacon est nommé d'après une figure de la mythologie chinoise, \
		d'une manière ou d'une autre c'est juste comme ça que ça s'est toujours appelé."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "hua_mulan_congee"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/nutriment/protein = 6,
	)
	tastes = list("de bacon" = 1, "d'oeufs" = 1)
	foodtypes = MEAT | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/bowled/fried_eggplant_polenta
	name = "aubergine frite et polenta"
	desc = "De la polenta garnie de fromage, servie avec quelques tranches d'aubergine frite et de la sauce tomate. Lække !"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "fried_eggplant_polenta"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 12,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/nutriment = 10,
	)
	tastes = list("de semoule de maïs" = 1, "de fromage" = 1, "d'aubergine" = 1, "de sauce tomate" = 1)
	foodtypes = DAIRY | GRAIN
	w_class = WEIGHT_CLASS_SMALL

//Salads: the bread and butter of mothic cuisine
/obj/item/food/caprese_salad
	name = "salade caprese"
	desc = "Bien que ça ne soit pas une création originale des moths, la salade caprese est devenu un classique dans la Flotte, \
		notamment car c'est simple à préparer et très bon. Les moths connaissent ce plat sous le nom de zaileskenknusksolt, \
		salade bicolore, en commun." //zail = two, esken = colour/tone, knuskolt = salad
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "caprese_salad"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 8,
	)
	tastes = list("de mozzarella" = 1, "de tomate" = 1, "de vinaigre balsamique" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/salad/fleet_salad
	name = "lörtonknusksolt" //lörton = fleet, knusksolt = salad (knusk = crisp, solt = bowl)
	desc = "Lörtonknusksolt, ou salade de la Flotte, en commun, est un plat habituel des brasseries et cantines de la Flotte. \
		Le (vrai) fromage grillé la rend particulièrement nourissante, et les croutons y ajoutent du croquant."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "fleet_salad"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 12,
	)
	tastes = list("de fromage" = 1, "de salade" = 1, "de pain" = 1)
	foodtypes = DAIRY | VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/salad/cotton_salad
	name = "flöfrölenknusksolt"
	desc = "Une salade dans lequel on a rajouté du coton et une sauce basique. Il y a probablement des moths dans le coin."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "cotton_salad"
	food_reagents = list(,
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 14,
	)
	tastes = list("du fromage" = 1, "de salade" = 1, "de pain" = 1)
	foodtypes = VEGETABLES | CLOTH
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/salad/moth_kachumbari
	name = "\improper Kæniatknusksolt" //Kæniat = Kenyan, knusksolt = salad
	desc = "Une recette originaire du Kenya. Le kachumbari est une des recettes issue d'un mélange culturel avec les humains qui a été adoptée par les moths, \
		bien que quelques ingrédients aient dû être changés."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "moth_kachumbari"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 18,
	)
	tastes = list("d'oignons" = 1, "de tomate" = 1, "de maïs" = 1, "de piment" = 1, "de coriandre" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

//Pizza
/obj/item/food/raw_mothic_margherita
	name = "pizza margherita mothienne crue"
	desc = "Un autre classique humain que les moths ont adopté. Les pizzas mothiennes utilisent des ingrédients frais, notamment de la mozzarella fraiche, \
		et de la farine blanche pour avoir une pâte avec beaucoup de gluten."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_margherita_pizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de pâte" = 1, "de tomate" = 1, "de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | RAW

/obj/item/food/raw_mothic_margherita/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/mothic_margherita, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/mothic_margherita
	name = "pizza margherita mothienne"
	desc = "Une caractéristique des pizzas dans la culture mothienne est qu'elles sont vendues au poids. Une seule part vaut seulement quelques crédits, quand un ticket restaurant peut acheter toute la pizza."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "margherita_pizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 25,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY
	slice_type = /obj/item/food/pizzaslice/mothic_margherita
	boxtag = "Margherita alla Mothuchi"

/obj/item/food/pizzaslice/mothic_margherita
	name = "part de margherita mothienne"
	desc = "Une part de pizza margherita mothienne."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "margherita_slice"
	tastes = list("de croûte" = 1, "de tomate" = 1, "de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/raw_mothic_firecracker
	name = "pizza diable mothienne crue" //French's edit : pas trouvé de traduction à la pizza firecracker alors j'ai mis un équivalent
	desc = "Un des plats préférés des plus aventureux des moths. Attention, la pizza diable va vous arracher la gueule."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_firecracker_pizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/bbqsauce = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
		/datum/reagent/consumable/capsaicin = 10,
	)
	tastes = list("de pâte" = 1, "de piment" = 1, "de maïs" = 1, "de fromage" = 1, "de sauce barbecue" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | RAW

/obj/item/food/raw_mothic_firecracker/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/mothic_firecracker, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/mothic_firecracker
	name = "pizza diable mothienne"
	desc = "Ils ne rigolent pas quand ils disent que cette pizza est épicée."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "firecracker_pizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 25,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/bbqsauce = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/capsaicin = 10,
	)
	tastes = list("de pâte" = 1, "de piment" = 1, "de maïs" = 1, "de fromage" = 1, "de sauce barbecue" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY
	slice_type = /obj/item/food/pizzaslice/mothic_firecracker
	boxtag = "Vesuvian Firecracker"

/obj/item/food/pizzaslice/mothic_firecracker
	name = "part de diable mothienne"
	desc = "Une part épicée de quelque chose de plutôt bon."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "firecracker_slice"
	tastes = list("de pâte" = 1, "de piment" = 1, "de maïs" = 1, "de fromage" = 1, "de sauce barbecue" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/raw_mothic_five_cheese
	name = "pizza cinq fromage mothienne crue"
	desc = "Pendant des siècles des universitaires se sont demandés : À partir de combien de fromages il y a trop de fromage ?"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_five_cheese_pizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de pâte" = 1, "de fromage" = 1, "d'encore plus de fromage" = 1, "de beaucoup trop de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | RAW

/obj/item/food/raw_mothic_five_cheese/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/mothic_five_cheese, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/mothic_five_cheese
	name = "pizza cinq fromage mothienne"
	desc = "Un classique chez les souris, les rats et les français." //French's edit : C'est pas très flatteur de remplacer un anglais par un français, mais j'ai pas la ref...
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "five_cheese_pizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 25,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de pâte" = 1, "de fromage" = 1, "d'encore plus de fromage" = 1, "de beaucoup trop de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY
	slice_type = /obj/item/food/pizzaslice/mothic_five_cheese
	boxtag = "Cheeseplosion"

/obj/item/food/pizzaslice/mothic_five_cheese
	name = "part de cinq fromage mothienne"
	desc = "La part avec le plus de fromage de la galaxie ! Au moins jusqu'à ce que ça soit dans votre ventre..."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "five_cheese_slice"
	tastes = list("de pâte" = 1, "de fromage" = 1, "d'encore plus de fromage" = 1, "de beaucoup trop de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/raw_mothic_white_pie
	name = "pizza blanche mothienne crue"
	desc = "Une pizza faite pour ceux qui détestent les tomates."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_white_pie_pizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de pâte" = 1, "de fromage" = 1, "d'herbes" = 1, "d'ail" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | RAW

/obj/item/food/raw_mothic_white_pie/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/mothic_white_pie, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/mothic_white_pie
	name = "pizza blanche mothienne"
	desc = "Ils disent tomato, je dis tomate, et on met aucun des deux sur cette pizza."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "white_pie_pizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 25,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de pâte" = 1, "de fromage" = 1, "d'herbes" = 1, "d'ail" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY
	slice_type = /obj/item/food/pizzaslice/mothic_white_pie
	boxtag = "Pane Bianco"

/obj/item/food/pizzaslice/mothic_white_pie
	name = "part de pizza blanche mothienne"
	desc = "Du fromage, de l'ail, des herbes, délicieux !"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "white_pie_slice"
	tastes = list("de pâte" = 1, "de fromage" = 1, "d'herbes" = 1, "d'ail" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/raw_mothic_pesto
	name = "pizza pesto mothienne crue"
	desc = "Le pesto est une garniture populaire parmi les moths, probablement parce que c'est un bon exemple de leurs goûts préférés : Du fromage, des herbes et des légumes."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_pesto_pizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de pâte" = 1, "de pesto" = 1, "de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | NUTS | RAW

/obj/item/food/raw_mothic_pesto/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/mothic_pesto, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/mothic_pesto
	name = "pizza pesto mothienne"
	desc = "Aussi vert que l'herbe dans le jardin. Pas qu'il y en ai beaucoup dans les vaisseaux mothiens." //French's edit : En même temps c'est un gâchis monstrueux d'eau et d'énergie, Nanotrasen jette de l'argent par les fenêtres et-
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "pesto_pizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 25,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de pâte" = 1, "de pesto" = 1, "de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | NUTS | RAW
	slice_type = /obj/item/food/pizzaslice/mothic_pesto
	boxtag = "Presto Pesto"

/obj/item/food/pizzaslice/mothic_pesto
	name = "part de pizza pesto mothienne"
	desc = "Une part de presto pizza pesto."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "pesto_slice"
	tastes = list("de pâte" = 1, "de pesto" = 1, "de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | NUTS

/obj/item/food/raw_mothic_garlic
	name = "pizza à l'ail mothienne crue"
	desc = "Ahh, l'ail. Un ingrédient universellement aimé. Excepté les vampires, sans doute." //French's edit : Je suis une vampire, j'imagine...
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_garlic_pizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de pâte" = 1, "d'ail" = 1, "de beurre" = 1)
	foodtypes = GRAIN | VEGETABLES | RAW

/obj/item/food/raw_mothic_garlic/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/mothic_garlic, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/mothic_garlic
	name = "pizza à l'ail mothienne"
	desc = "La meilleure nourriture de la galaxie."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "garlic_pizza"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 25,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de pâte" = 1, "d'ail" = 1, "de beurre" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | NUTS
	slice_type = /obj/item/food/pizzaslice/mothic_garlic
	boxtag = "Pain à l'ail alla Mothuchi"

/obj/item/food/pizzaslice/mothic_garlic
	name = "part de pizza à l'ail mothienne"
	desc = "La meilleure combinaison d'huile, d'ail et de pâte connue chez les moths."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "garlic_slice"
	tastes = list("de pâte" = 1, "d'ail" = 1, "de beurre" = 1)
	foodtypes = GRAIN | VEGETABLES

//Bread
/obj/item/food/bread/corn
	name = "pain au maïs"
	desc = "C'est du pain mais en fait c'est pas du pain. Mensonge."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "cornbread"
	food_reagents = list(/datum/reagent/consumable/nutriment = 18)
	tastes = list("de maïs" = 9, "de yaourt" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL
	slice_type = /obj/item/food/breadslice/corn
	yield = 6

/obj/item/food/breadslice/corn
	name = "part de pain au maïs"
	desc = "Une part croustillante de pain au maïs, qui n'est pas du pain. Mais bien au maïs."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "cornbread_slice"
	foodtypes = GRAIN
	food_reagents = list(/datum/reagent/consumable/nutriment = 3)
	tastes = list("de maïs" = 9, "de yaourt" = 1)

//Sweets
/obj/item/food/moth_cheese_cakes
	name = "\improper ælorölen" //ælo = cheese, rölen = balls
	desc = "Ælorölen (balles de fromage), un dessert traditionnel mothien fait avec du fromage à pâte mole, du sucre en poudre et de la farine puis roulé en boules et ensuite frits. Souvent servi avec du chocolat ou du miel, parfois les deux !"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "moth_cheese_cakes"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/sugar = 12,
	)
	tastes = list("du cheesecake" = 1, "de chocolat" = 1, "du miel" = 1)
	foodtypes = SUGAR | FRIED | DAIRY | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cake/mothmallow
	name = "mothmallow tray"
	desc = "Une guimauve légère, douce, et vegan, au goût de vanille et de rhum, réhaussé de chocolat. Connu sous le nom mothien de höllflöfstarkken : nuage carré." //höllflöf = cloud (höll = wind, flöf = cotton), starkken = squares
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "mothmallow_tray"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/sugar = 20,
	)
	tastes = list("de vanille" = 1, "de nuage" = 1, "de chocolat" = 1)
	foodtypes = VEGETABLES | SUGAR
	slice_type = /obj/item/food/cakeslice/mothmallow
	yield = 6

/obj/item/food/cakeslice/mothmallow
	name = "mothmallow"
	desc = "De légers petits nuages de joie, aux couleurs des moths."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "mothmallow_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/sugar = 4,
	)
	tastes = list("de vanille" = 1, "de nuage" = 1, "de chocolat" = 1)
	foodtypes = VEGETABLES | SUGAR

//misc food
/obj/item/food/bubblegum/wake_up
	name = "réveil gum"
	desc = "Une bande de chewing gum. L'emblème de la Flotte nomade mothienne est dessiné dessus."
	food_reagents = list(
		/datum/reagent/consumable/sugar = 13,
		/datum/reagent/drug/methamphetamine = 2,
	)
	tastes = list("d'herbes" = 1)
	color = "#567D46"

/obj/item/storage/box/gum/wake_up
	name = "\improper chewing gum médicamentés Activin 12 heures"
	desc = "Restez éveillez pendant vos longs services dans la maintenance grâce à Activin ! Le sceau d'approbation de la Flotte nomadae mothienne \
		marque le paquet, à côté d'une litanie d'avertissement de santé et de sécurité, à la fois en mothien et en communs."
	icon_state = "bubblegum_wake_up"
	custom_premium_price = PAYCHECK_CREW * 1.5

/obj/item/storage/box/gum/wake_up/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>Vous lisez quelques lignes des avertissements de santé et de sécurité...</i>")
	. += "\t[span_info("Pour soulager les fatigues et somnolences pendant le travail.")]"
	. += "\t[span_info("Ne pas macher plus d'une unité toutes les 12 heures. Ne pas utiliser en tant que substitue au sommeil.")]"
	. += "\t[span_info("Ne pas donner aux enfants de moins de 16 ans. Ne pas dépasser le dosage maximum. Ne pas ingérer. Do not ingest. Ne pas prendre pendant plus que 3 jours consécutifs. Ne pas utiliser en même temps que d'autres médicaments. Peut provoquer des réactions indésirables chez les patients ayant des problèmes cardiaques préexistants.")]"
	. += "\t[span_info("Les effets secondaires d'Activin peuvent inclurent : Agitements d'antennes, ailes hyperactive, perte de lustre au niveau de la kératine, perte d'épaisseur de la setae, arythmie, troubles de la vision, et euphorie. Cessez immédiatement le traitement si un ou plusieurs effets secondaires apparaissent.")]"
	. += "\t[span_info("Une utilisation répétée peut entraîner une dépendance.")]"
	. += "\t[span_info("Si le dosage maximum est dépassé, informez immédiatement un membre de l'équipe médicale de votre baisseau. Ne pas provoquer de vomissement.")]"
	. += "\t[span_info("Ingrédients : Chaque ruban continent 500mg d'Activin (dextro-methamphetamine). Autres ingrédients incluent : colorant Vert 450 (Prairie Verdoyante) et arôme artificielle d'herbes.")]"
	. += "\t[span_info("Stockage : Garder dans un endroit frais et sec. Ne pas utiliser après la date limite de consommation : 32/4/350.")]"
	return .

/obj/item/storage/box/gum/wake_up/PopulateContents()
	for(var/i in 1 to 4)
		new/obj/item/food/bubblegum/wake_up(src)

/obj/item/food/spacers_sidekick
	name = "\improper l'acolyte mentholé de l'homme de l'espace"
	desc = "L'acolyte mentholé de l'homme de l'espace : Respirez sereinement, avec l'ami mentholé à vos côtés !"
	icon_state = "spacers_sidekick"
	trash_type = /obj/item/trash/spacers_sidekick
	food_reagents = list(
		/datum/reagent/consumable/sugar = 1,
		/datum/reagent/consumable/menthol = 1,
		/datum/reagent/medicine/salbutamol = 1,
	)
	tastes = list("de menthe" = 1)
	junkiness = 15
	foodtypes = JUNKFOOD
	w_class = WEIGHT_CLASS_SMALL
