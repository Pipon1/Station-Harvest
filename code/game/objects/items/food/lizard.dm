//Lizard Foods, for lizards (and weird humans!)

//Meat Dishes

/obj/item/food/raw_tiziran_sausage
	name = "Boudin tizirien cru"
	desc = "Un boudin tizirien cru, prêt à être séché sur un étendoir."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "raw_lizard_sausage"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/blood = 3,
	)
	tastes = list("de viande" = 1, "de boudin noir" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_tiziran_sausage/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dryable, /obj/item/food/tiziran_sausage)

/obj/item/food/tiziran_sausage
	name = "\improper Boudin tizirien"
	desc = "Un gros boudin séché, traditionnellement fait par les fermiers autour de Zagoskeld. La texture est similaire au chorizo espagnol de la vieille Terre."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "lizard_sausage"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de viande" = 1, "de boudin noir" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_headcheese
	name = "Bloc de pâté de tête cru"
	desc = "Un aliment courant à Tizira. Le pâté de tête est traditionnellement fait à partir de la tête sans organe d'un animal qu'on a bouilli jusqu'à ce qu'elle s'effiloche. Après avoir été retiré de l'eau, égoutté, salé, mis sous forme de bloc, le pâté est laissé séché et veillir pendant plusieurs mois. Le résultat est un bloc dur à l'odeur de fromage."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "raw_lizard_cheese"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 15,
		/datum/reagent/consumable/salt = 5,
	)
	tastes = list("de viande" = 1, "de sel" = 1)
	foodtypes = MEAT | GORE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_headcheese/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dryable, /obj/item/food/headcheese)

/obj/item/food/headcheese
	name = "Bloc de pâté de tête"
	desc = "Un bloc de pâté de tête séché. Délicieux, si vous êtes un lézard."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "lizard_cheese"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 15,
		/datum/reagent/consumable/salt = 5,
	)
	tastes = list("de fromage" = 1, "de sel" = 1)
	foodtypes = MEAT | GORE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/headcheese/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/headcheese_slice, 5, 3 SECONDS, table_required = TRUE, screentip_verb = "Slice")

/obj/item/food/headcheese_slice
	name = "Tranche de pâté de tête"
	desc = "Une tranche de pâté de tête, utile pour faire des sandwichs ou des en-cas. Ou survivre aux hivers tiziriens."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "lizard_cheese_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/salt = 1,
	)
	tastes = list("de fromage" = 1, "de sel" = 1)
	foodtypes = MEAT | GORE
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/shredded_lungs
	name = "Sauté de poumons effiloché croustillants"
	desc = "Des lamelles croustillantes de poumons, avec des légumes et une sauce épicées. Délicieux, si vous aimez les poumons."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "lung_stirfry"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/capsaicin = 2,
	)
	tastes = list("de viande" = 1, "d'épices" = 1, "de légumes" = 1)
	foodtypes = MEAT | VEGETABLES | GORE
	trash_type = /obj/item/reagent_containers/cup/bowl
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/tsatsikh
	name = "Tsatsikh"
	desc = "Un plat tizirien composé d'abats moulus, épicés et fourrés dans un estomac puis bouillis. Seuls les connaisseurs peuvent l'apprécier."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "tsatsikh"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 10)
	tastes = list("d'assortiment d’organes hachés" = 1)
	foodtypes = MEAT | GORE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/liver_pate
	name = "Pâté de foie"
	desc = "Une riche pâte faite de foie, de viande et de quelques ajoûts supplémentaires pour toujours plus d'arômes."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "pate"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 5)
	tastes = list("de foie" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/moonfish_eggs
	name = "Oeufs de poisson lune"
	desc = "Le poisson lune pond de grands oeufs blancs et translucides prisés dans la cuisine lézarde. Leur goût est similaire à celui du caviar, mais est souvent décris comme plus complexe et profond."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "moonfish_eggs"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de caviar" = 1)
	foodtypes = SEAFOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/moonfish_caviar
	name = "Pâte de caviar de poisson lune"
	desc = "Une pâte riche faite à partir d'oeufs de poisson lune. L'unique moyen pour les lézards d'avoir ces oeufs, très utilisé dans la cuisine côtière."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "moonfish_caviar"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("de caviar" = 1)
	foodtypes = SEAFOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/lizard_escargot
	name = "Escargot-spirale du désert"
	desc = "Un autre exemple du mélange culturel entre les humains et les lézards, les escagot du désert sont en vérité plus proche du plat romain que du plat français contemporains. De la nourriture d'étale, commune dans les cités du désert."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "lizard_escargot"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/garlic = 2,
	)
	tastes = list("d'escargots" = 1, "d'ail" = 1, "d'huile" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fried_blood_sausage
	name = "Boudin frit"
	desc = "Un boudin frit et pané, le plus souvent servi avec des frites. Un en-cas rapide et simple des rues de Zagoskeld."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "fried_blood_sausage"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/cooking_oil = 1,
	)
	tastes = list("de boudin noir" = 1, "de pâte" = 1, "d'huile" = 1)
	foodtypes = MEAT | FRIED
	w_class = WEIGHT_CLASS_SMALL

//Why does like, every language on the planet besides English call them pommes? Who knows, who cares- the lizards call them it too, because funny. Trad's edit : Parce que nous on est civilisé
/obj/item/food/lizard_fries
	name = "Poms-franzisks épicées"
	desc = "Une des nombreuses nourritures humaines à avoir fait son petit chemin dans la culture lézarde est les frites, autrement appelée poms-franzisks en Draconic. Une fois sublimées avec de la viande et de la sauce barbecue, vous obtenez un repas copieux."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "lizard_fries"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/bbqsauce = 2,
	)
	tastes = list("de frites" = 2, "de sauce barbecue" = 1, "de viande grillée" = 1)
	foodtypes = MEAT | VEGETABLES | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/brain_pate
	name = "Pâté de globe-oculaire-et-cerveau"
	desc = "Un pâté rose épais fait de globes oculaires et de cerveaux pochés finement hachés, d'oignons frits et gras. Les lézards jurent que c'est délicieux !"
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "brain_pate"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/liquidgibs = 2,
	)
	tastes = list("de cerveaux" = 2)
	foodtypes = MEAT | VEGETABLES | GORE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/crispy_headcheese
	name = "Pâté de tête pané"
	desc = "Un délicieux en-cas des rues de Zagoskeld, consistant en un pâté de tête recouvert de panure croustillante. Généralement servi avec des frites."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "crispy_headcheese"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/cooking_oil = 2,
	)
	tastes = list("de fromage" = 1, "d'huile" = 1)
	foodtypes = MEAT | VEGETABLES | NUTS | GORE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/kebab/picoss_skewers
	name = "Brochette picoss"
	desc = "Un plat tizirien populaire, consistant en un poisson cuirassé mariné dans du vinaigre embroché avec de l'oignon et des piments."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "picoss_skewer"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/vinegar = 1,
		/datum/reagent/consumable/capsaicin = 1,
	)
	tastes = list("de poisson" = 1, "d'acide" = 1, "d'oignon" = 1, "d'épices" = 1)
	foodtypes = SEAFOOD | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/nectar_larvae
	name = "Nectar de larve"
	desc = "De petites larves croustillantes dans du nectar de korta, une sauce douce et épicée. Fantbzzastique !"
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "nectar_larvae"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/korta_nectar = 3,
		/datum/reagent/consumable/capsaicin = 1,
	)
	tastes = list("de viande" = 1, "de sucre" = 1, "d'épices" = 1)
	foodtypes = GORE | MEAT | BUGS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/mushroomy_stirfry
	name = "Sauté champignonnesque"
	desc = "Une salade de champignons, faite pour rassasier vos monstrueuses fringales. Merveilleux !"
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "mushroomy_stirfry"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de supers champignons" = 1, "de sublimes champignons" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

//Fish Dishes
/obj/item/food/grilled_moonfish
	name = "Poisson lune grillé"
	desc = "Une tranche de poisson lune grillée. Traditionnellement servie sur un lit de racines avec une sauce au vin."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "grilled_moonfish"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de poisson" = 1)
	foodtypes = SEAFOOD
	burns_on_grill = TRUE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/moonfish_demiglace
	name = "Demi-glace de poisson lune"
	desc = "Une tranche de poisson lune magnifiquement grillée, sur un lit de pommes de terres et de carottes saucée de vin et de demi-glace. Tout simplement merveilleux."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "moonfish_demiglace"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/nutriment = 2,
	)
	tastes = list("de poisson" = 2, "de pomme de terre" = 1, "de carotte" = 1)
	foodtypes = SEAFOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/lizard_surf_n_turf
	name = "\improper Buffet surf 'n' turf de Zagoskeld"
	desc = "Un énorme plateau des meilleurs plats à base de viande et de fruits de mer de Tizira, généralement partagé entre familles ou amis sur la plage. Bien sûr, rien ne vous empêche de tout manger tout seul... À part votre diabète."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "surf_n_turf"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("de terre" = 1, "de mer" = 1)
	foodtypes = MEAT | SEAFOOD | VEGETABLES
	w_class = WEIGHT_CLASS_BULKY

//Spaghetti Dishes

/obj/item/food/spaghetti/nizaya
	name = "Pâtes nizaya"
	desc = "Une forme de pâtes de racines et de noix, venant originellement des régions côtières de Tizira. Similaire aux gnocchis en texture et en apparence. "
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "nizaya"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de gnocchi" = 1)
	foodtypes = VEGETABLES | NUTS

/obj/item/food/spaghetti/snail_nizaya
	name = "Nizaya aux escargots du désert"
	desc = "Un plat de pâte haut de gamme venant de la région viticole de la Valyngia, sur Tizira. Traditionnellement fait avec les vins tiziriens les plus fins... La piquette humaine fera l'affaire, je suppose."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "snail_nizaya"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("d'escargots" = 1, "de vin" = 1, "de gnocchi" = 1)
	foodtypes = VEGETABLES | MEAT | NUTS

/obj/item/food/spaghetti/garlic_nizaya
	name = "Pâtes nizaya à l'ail et à l'huile d'olive"
	desc = "Une adaptation lézarde du plat de pâtes italien 'aglio e olia', fait avec des pâtes nizaya."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "garlic_nizaya"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("d'ail" = 1, "d'huile" = 1, "de gnocchi" = 1)
	foodtypes = VEGETABLES | NUTS

/obj/item/food/spaghetti/demit_nizaya
	name = "Pâtes nizaya tout-en-un"
	desc = "Un plat de pâtes nizaya sucré et crémeux fait avec du lait et du nectar de korta."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "demit_nizaya"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/korta_nectar = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de doux poivre" = 1, "de légumes" = 1, "de gnocchi" = 1)
	foodtypes = VEGETABLES | SUGAR | NUTS

/obj/item/food/spaghetti/mushroom_nizaya
	name = "Champignons nizaya"
	desc = "Un plat de pâtes nizaya fait à partir de chapignons Seraka et de l'huile de qualité. A une forte saveur de noix."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "mushroom_nizaya"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("de sapidité" = 1, "de noix" = 1, "de gnocchi" = 1)
	foodtypes = VEGETABLES

//Dough Dishes

/obj/item/food/rootdough
	name = "Pâte de racines"
	desc = "Une pâte faite à partir de racines, fait avec des noix et des tubercules. Utilisé dans une grande variété de recettes tiziriennes."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "rootdough"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("de pomme de terre" = 1, "de chaleur terreuse" = 1)
	foodtypes = VEGETABLES | NUTS

/obj/item/food/rootdough/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/bread/root, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/rootdough/make_processable()
	AddElement(/datum/element/processable, TOOL_ROLLINGPIN, /obj/item/food/flatrootdough, 1, 3 SECONDS, table_required = TRUE, screentip_verb = "Flatten")

/obj/item/food/flatrootdough
	name = "Pâte de racines plate"
	desc = "Une pâte de racines applatie, prête à être transformée en pain plat ou coupée en morceaux."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "flat_rootdough"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6)
	tastes = list("de pomme de terre" = 1, "de chaleur terreuse" = 1)
	foodtypes = VEGETABLES | NUTS

/obj/item/food/flatrootdough/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/rootdoughslice, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Slice")

/obj/item/food/flatrootdough/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/root_flatbread, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/rootdoughslice
	name = "Boule de pâte de racines"
	desc = "Une boule de pâtes de racines. Parfaite pour faire des pizzas ou des petits pains."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "rootdough_slice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("de pomme de terre" = 1, "de chaleur terreuse" = 1)
	foodtypes = VEGETABLES | NUTS

/obj/item/food/rootdoughslice/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/spaghetti/nizaya, 1, 3 SECONDS, table_required = TRUE, screentip_verb = "Slice")

/obj/item/food/rootdoughslice/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/rootroll, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/root_flatbread
	name = "Pain plat de racines"
	desc = "Un simple pain plat de racine grillé. Peut être agrémenté de toutes sortes de nourritures que les lézards apprécient manger."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "root_flatbread"
	food_reagents = list(/datum/reagent/consumable/nutriment = 8)
	tastes = list("de pain" = 1, "de chaleur terreur" = 1)
	foodtypes = VEGETABLES | NUTS
	burns_on_grill = TRUE

/obj/item/food/rootroll
	name = "Petit pain de racines"
	desc = "Une petit pain danse et caoutchouteux, fait à partir de racines. Un bon compagnon pour un bol de soupe."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "rootroll"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("de petit pain" = 1) // the roll tastes of roll.
	foodtypes = VEGETABLES | NUTS
	burns_in_oven = TRUE

//Bread Dishes

/obj/item/food/bread/root
	name = "Pain de racines"
	desc = "L'équivalent du pain pour les lézards, fait à partir de tubercules comme les pommes de terre et les ignames mixés à des arachides et des graines. Sensiblement plus dense que le pain standard."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "lizard_bread"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20)
	tastes = list("de pain" = 8, "de noix" = 2)
	foodtypes = VEGETABLES | NUTS
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP
	burns_in_oven = TRUE
	slice_type = /obj/item/food/breadslice/root

/obj/item/food/bread/root/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, /obj/item/food/bread/empty, CUSTOM_INGREDIENT_ICON_FILL, max_ingredients = 8)

/obj/item/food/breadslice/root
	name = "Tranche de pain de racines"
	desc = "Une tranche de pain dense et caoutchouteux."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "lizard_breadslice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("de pain" = 8, "de noix" = 2)
	foodtypes = VEGETABLES | NUTS
	venue_value = FOOD_PRICE_TRASH

/obj/item/food/breadslice/root/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, null, CUSTOM_INGREDIENT_ICON_STACK)

//Pizza Dishes
/obj/item/food/pizza/flatbread
	icon = 'icons/obj/food/lizard.dmi'
	slice_type = null

/obj/item/food/pizza/flatbread/rustic
	name = "Pain plat rustique"
	desc = "Un simple plat tizirien, populaire comme accompagnement pour des plats à base de viandes ou de poissons. Relevé à l'aide d'herbes et d'huile."
	icon_state = "rustic_flatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/vitamin = 15,
		/datum/reagent/consumable/garlic = 2,
	)
	tastes = list("de pain" = 1, "d'herbes" = 1, "d'huile" = 1, "d'ail" = 1)
	foodtypes = VEGETABLES | NUTS
	boxtag = "Tiziran Flatbread"

/obj/item/food/pizza/flatbread/italic
	name = "\improper Pain plat italique"
	desc = "L'introduction de la nourriture humaine sur Tizira a mené à des avancées en matière de cuisine lézarde. Le pain plat italique est maintenant fréquemment vu sur les menus de restautant tizirien à l'emporter."
	icon_state = "italic_flatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 15,
	)
	tastes = list("de pain" = 1, "d'herbes" = 1, "d'huile" = 1, "d'ail" = 1, "de tomates" = 1, "de viande" = 1)
	foodtypes = VEGETABLES | NUTS | MEAT
	boxtag = "Italic Flatbread"

/obj/item/food/pizza/flatbread/imperial
	name = "\improper Pain plat impérial"
	desc = "Un pain plat agrémenté de pâté, de légumes marinés et de pâté de tête en cube. Ne convient à personne excepté aux lézards."
	icon_state = "imperial_flatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/protein = 15,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("de pain" = 1, "d'herbes" = 1, "d'huile" = 1, "d'ail" = 1, "de tomate" = 1, "de viande" = 1)
	foodtypes = VEGETABLES | MEAT | NUTS | GORE
	boxtag = "Imperial Victory Flatbread"

/obj/item/food/pizza/flatbread/rawmeat
	name = "Pain plat à la viande"
	desc = "Curieusement, ce plat tizirien est un des plats préféré de certains humains soucieux de leur santé."
	icon_state = "rawmeat_flatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/protein = 10,
	)
	tastes = list("de pain" = 1, "de viande" = 1)
	foodtypes = MEAT | NUTS | RAW | GORE

/obj/item/food/pizza/flatbread/stinging
	name = "\improper Pain plat piquant"
	desc = "Le mélange électrique de méduses et de larves d'abeille vous donne une sensation qui vous en fait demander plus !"
	icon_state = "stinging_flatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/nutriment/protein = 20,
		/datum/reagent/consumable/honey = 2,
	)
	tastes = list("de pain" = 1, "de douceur" = 1, "de piquant" = 1, "de slime" = 1)
	foodtypes = BUGS | NUTS | SEAFOOD | GORE

/obj/item/food/pizza/flatbread/zmorgast  // Name is based off of the Swedish dish Smörgåstårta
	name = "\improper Pain plat Zmorgast"
	desc = "Un gâteau sandwich suédois revisité à la mode tizirienne, le Zmogast est une plat assez commuen dans les réunions de familles."
	icon_state = "zmorgast_flatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 16,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de pain" = 1, "de foie" = 1, "de nostalgie familiale" = 1)
	foodtypes = VEGETABLES | NUTS | MEAT

/obj/item/food/pizza/flatbread/fish
	name = "\improper Pain plat au poisson grillé"
	desc = "Delamination du réacteur, clown spécial, froid de l'espace... Je veux juste faire un barbecue pour l'amour de Tizira !"
	icon_state = "fish_flatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/protein = 15,
		/datum/reagent/consumable/bbqsauce = 2,
	)
	tastes = list("de pain" = 1, "de poisson" = 1)
	foodtypes = SEAFOOD | NUTS

/obj/item/food/pizza/flatbread/mushroom
	name = "Pain plat aux champignons et aux tomates"
	desc = "Une alternative simple au pain plat italique, pour quand vous avez déjà fait votre plein de viande."
	icon_state = "mushroom_flatbread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 18,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes =  list("de pain" = 1, "de champignons" = 1, "de tomates" = 1)
	foodtypes = VEGETABLES | NUTS

/obj/item/food/pizza/flatbread/nutty
	name = "Pain plat aux noix"
	desc = "La technologie moderne dans le domaine gastronomique a permis de doubler la délicieuse saveur des noix korta en les utilisant à la fois comme base et comme garniture."
	icon_state = "nutty_flatbread"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20)
	tastes =  list("de pain" = 1, "de noix" = 2)
	foodtypes = NUTS

//Sandwiches/Toast Dishes
/obj/item/food/emperor_roll
	name = "Petit pain empereur"
	desc = "Un sandwich populaire sur Tizira, nommé en l'honneur de la famille impériale."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "emperor_roll"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de pain" = 1, "de fromage" = 1, "de foie" = 1, "de caviar" = 1)
	foodtypes = VEGETABLES | NUTS | MEAT | GORE | SEAFOOD
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/honey_roll
	name = "Petit pain roulé au miel"
	desc = "Un petit paint roulé et sucré avec des morceaux de fruit, apprécié en tant que dessert saisonnier sur Tizira."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "honey_roll"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 8,
		/datum/reagent/consumable/honey = 2,
	)
	tastes = list("de pain" = 1, "de miel" = 1, "de fruits" = 1)
	foodtypes = VEGETABLES | NUTS | FRUIT
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

//Egg Dishes
/obj/item/food/black_eggs
	name = "Oeufs brouillés noirs"
	desc = "Un plat des campagnes de Tizira. Fait avec des oeufs, du sang, et fourré avec des légumes verts. Mangé traditionnellement avec du pain de racines et de la sauce épicée."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "black_eggs"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("d'oeufs" = 1, "de légumes verts" = 1, "de sang" = 1)
	foodtypes = MEAT | BREAKFAST | GORE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/patzikula
	name = "Patzikula"
	desc = "Une sauce liquide et épicée, faite à partir de sauce tomate et d'oeufs rôtis. Délicieux."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "patzikula"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 8,
		/datum/reagent/consumable/capsaicin = 2,
	)
	tastes = list("d'oeufs" = 1, "de tomates" = 1, "de chaleur" = 1)
	foodtypes = VEGETABLES | MEAT | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL

//Cakes/Sweets

/obj/item/food/cake/korta_brittle
	name = "Bloc de korta friable"
	desc = "Un gros bloc de noix de korta friable. Tellement sucré que ça pourrait être un crime !"
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "korta_brittle"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 20,
		/datum/reagent/consumable/nutriment = 15,
		/datum/reagent/consumable/korta_nectar = 15,
	)
	tastes = list("de chaleur poivrée" = 1, "de douceur" = 1)
	foodtypes = NUTS | SUGAR
	slice_type = /obj/item/food/cakeslice/korta_brittle

/obj/item/food/cakeslice/korta_brittle
	name = "Tranche de korta cassant"
	desc = "Une petite tranche de noix de korta friable. Le pire ennemi du diabète."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "korta_brittle_slice"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 4,
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/korta_nectar = 3,
	)
	tastes = list("de chaleur poivrée" = 1, "de douceur" = 1)
	foodtypes = NUTS | SUGAR

/obj/item/food/snowcones/korta_ice
	name = "Glace au korta"
	desc = "De la glace pilée, du nectar de korta et des baies. Une petite sucrerie à manger pour battre la chaleur de l'été !"
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "korta_ice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 8,
		/datum/reagent/consumable/ice = 4,
		/datum/reagent/consumable/berryjuice = 6,
	)
	tastes = list("de chaleur poivrée" = 1, "de baies" = 1)
	foodtypes = NUTS | SUGAR | FRUIT

/obj/item/food/kebab/candied_mushrooms
	name = "Champignons confits"
	desc = "Un plat un peu bizarre de Tizira, consitant en des champignons seraka enrobés de caramel sur une brochette. Une attaque sucré-salée sur pattes."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "candied_mushrooms"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/caramel = 4,
	)
	tastes = list("de sapidité" = 1, "de sucre" = 1)
	foodtypes = SUGAR | VEGETABLES

//Misc Dishes
/obj/item/food/sauerkraut
	name = "Choucroute"
	desc = "Du chou mariné rendu célèbre par les Allemands et popularisé en cuisine lézarde où il est connu comme Zauerkrat."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "sauerkraut"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("de chou" = 1, "d'acidité" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/lizard_dumplings
	name = "\improper Raviolis tiziriens"
	desc = "Des racines de légumes réduites en purée, mixées à de la farine de korta et bouillies pour produire des grosses boulettes rondes et un peu épicées. Généralement mangées en soupe."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "lizard_dumplings"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de pomme de terre" = 1, "de chaleur terreuse" = 1)
	foodtypes = VEGETABLES | NUTS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/steeped_mushrooms
	name = "champignons seraka marinés"
	desc = "Les champignons seraka ont été laissées marinées dans de l'eau alcaline pour en enlever l'extrait, ce qui a permis de le rendre comestible."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "steeped_mushrooms"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de sapidité" = 1, "de noix" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/canned/jellyfish
	name = "Méduse mitrailleuse en conserve"
	desc = "Une boîte de conserve de méduse mitrailleuse en saumure. Contient un hallucinogène léger détruit lors de la cuisson."
	icon_state = "jellyfish"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/toxin/mindbreaker = 2,
		/datum/reagent/consumable/salt = 1,
	)
	trash_type = /obj/item/trash/can/food/jellyfish
	tastes = list("de slime" = 1, "de brulure" = 1, "de sel" = 1)
	foodtypes = SEAFOOD | GORE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/canned/desert_snails
	name = "Escargots du désert en conserve"
	desc = "Les escargots géants du désert tizirien, en saumure. Coquilles incluses. Il vaut mieux ne pas les manger crus, à moins que vous soyez un lézard."
	icon_state = "snails"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/salt = 2,
	)
	trash_type = /obj/item/trash/can/food/desert_snails
	tastes = list("d'escargots" = 1)
	foodtypes = MEAT | GORE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/canned/larvae
	name = "Larves d'abeille en conserve"
	desc = "Une boîte de conserve de larves d'abeilles dans du miel. Donne probablement l'appétit à quelqu'un."
	icon_state = "larvae"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/honey = 2,
	)
	trash_type = /obj/item/trash/can/food/larvae
	tastes = list("de doux insectes" = 1)
	foodtypes = MEAT | GORE | BUGS
	w_class = WEIGHT_CLASS_SMALL
