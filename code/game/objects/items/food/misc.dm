
////////////////////////////////////////////OTHER////////////////////////////////////////////
/obj/item/food/watermelonslice
	name = "tranche de pastèque"
	desc = "Une tranche rafraichissante."
	icon_state = "watermelonslice"
	food_reagents = list(
		/datum/reagent/water = 1,
		/datum/reagent/consumable/nutriment/vitamin = 0.2,
		/datum/reagent/consumable/nutriment = 1,
	)
	tastes = list("de pastèque" = 1)
	foodtypes = FRUIT
	food_flags = FOOD_FINGER_FOOD
	juice_results = list(/datum/reagent/consumable/watermelonjuice = 5)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/hugemushroomslice
	name = "tranche de grand champignon"
	desc = "Une tranche d'un grand champignon."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "hugemushroomslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de champignon" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/hugemushroomslice/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_WALKING_MUSHROOM, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)

/obj/item/food/popcorn
	name = "popcorn"
	desc = "Maintenant il faut se mettre d'accord sur le film."
	icon_state = "popcorn"
	trash_type = /obj/item/trash/popcorn
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	bite_consumption = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0
	tastes = list("popcorn" = 3, "beurre" = 1)
	foodtypes = JUNKFOOD
	eatverbs = list("mange", "gobe", "ronge", "engloutit", "mache")
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/popcorn/salty
	name = "popcorn salé"
	icon_state = "salty_popcorn"
	desc = "Le popcorn salé, un classique."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/salt = 2,
	)
	tastes = list("de sel" = 2, "de popcorn" = 1)
	trash_type = /obj/item/trash/popcorn/salty

/obj/item/food/popcorn/caramel
	name = "popcorn au caramel"
	icon_state = "сaramel_popcorn"
	desc = "Du popcorn recouvert de caramel. Cool !"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/caramel = 4,
	)
	tastes = list("caramel" = 2, "popcorn" = 1)
	foodtypes = JUNKFOOD | SUGAR
	trash_type = /obj/item/trash/popcorn/caramel

/obj/item/food/soydope
	name = "nouille de soja"
	desc = "Un  tas de nouille de soja."
	icon_state = "soydope"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/protein = 1,
	)
	tastes = list("de soja" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/badrecipe
	name = "amas brulé"
	desc = "Quelqu'un devrait être renvoyé."
	icon_state = "badrecipe"
	food_reagents = list(/datum/reagent/toxin/bad_food = 30)
	foodtypes = GROSS
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE //Can't decompose any more than this

/obj/item/food/badrecipe/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_GRILL_PROCESS, PROC_REF(OnGrill))

/obj/item/food/badrecipe/moldy
	name = "amas moisi"
	desc = "Un culture de moisissure et de fourmis. Quelque part là dessous, il y a des preuves que c'était <i>à un certain moment</i> de la nourriture."
	food_reagents = list(/datum/reagent/consumable/mold = 30)
	preserved_food = FALSE
	ant_attracting = TRUE
	decomp_type = null
	decomposition_time = 30 SECONDS

/obj/item/food/badrecipe/moldy/bacteria
	name = "amas moisi riche en bacteries"
	desc = "Ce n'est pas seulement un tas d'insectes grouillants, \
		ça bouillonne aussi de vies microscopiques. <i>Ça bouge quand vous ne le regardez pas.</i>"

/obj/item/food/badrecipe/moldy/bacteria/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOLD, CELL_VIRUS_TABLE_GENERIC, rand(2, 4), 25)

///Prevents grilling burnt shit from well, burning.
/obj/item/food/badrecipe/proc/OnGrill()
	SIGNAL_HANDLER
	return COMPONENT_HANDLED_GRILLING

/obj/item/food/spidereggs
	name = "oeufs d'araignée"
	desc = "Un groupe d'oeufs d'araignée juteux. Un bon accompagnement quand tu ne tiens pas à ta vie."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "spidereggs"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/toxin = 2,
	)
	tastes = list("de toile d'araignée" = 1)
	foodtypes = MEAT | TOXIC | BUGS
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/spidereggs/processed
	name = "oeufs d'araignée"
	desc = "Un groupe d'oeufs d'araignée juteux. Éclate dans votre bouche sans vous faire tomber malade."
	icon_state = "spidereggs"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4)
	tastes = list("de toile d'araignée" = 1)
	foodtypes = MEAT | BUGS
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/spiderling
	name = "araignée"
	desc = "Ça tresaille légérement dans votre main. Erk..."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "spiderling"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/toxin = 4,
	)
	tastes = list("de toile d'araignée" = 1)
	foodtypes = MEAT | TOXIC | BUGS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/melonfruitbowl
	name = "bol salade de fruit"
	desc = "Pour les gens qui veulent un bol qui peut se manger."
	icon_state = "melonfruitbowl"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("de pastèque" = 1, "de fruits" = 1)
	foodtypes = FRUIT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/melonkeg
	name = "tomelonet"
	desc = "Saviez vous que la vodka était un fruit ?"
	icon_state = "melonkeg"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 9,
		/datum/reagent/consumable/ethanol/vodka = 15,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	max_volume = 80
	bite_consumption = 5
	tastes = list("d'alcool de grain" = 1, "de fruit" = 1)
	foodtypes = FRUIT | ALCOHOL

/obj/item/food/honeybar
	name = "barre avoine-miel"
	desc = "De l'avoine et des noix compressées ensemble sous forme de barre, tenus ensemble par un glaçage au miel."
	icon_state = "honeybar"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/honey = 5,
	)
	tastes = list("avoine" = 3, "noix" = 2, "miel" = 1)
	foodtypes = GRAIN | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/powercrepe
	name = "Crepuissante"
	desc = "Un grand pouvoir implique de grandes crèpes. Ça ressemble à un pancake rempli de gelée mais ça a plus de puissance sous le capot."
	icon_state = "powercrepe"
	inhand_icon_state = "powercrepe"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/cherryjelly = 5,
	)
	force = 30
	throwforce = 15
	block_chance = 55
	armour_penetration = 80
	wound_bonus = -50
	attack_verb_continuous = list("gifle", "badigeonne")
	attack_verb_simple = list("gifler", "badigeonner")
	w_class = WEIGHT_CLASS_BULKY
	tastes = list("de cerise" = 1, "de crepe" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/branrequests
	name = "céréales à l'avoine"
	desc = "Une boite de céréales sèches, qui satisfait votre demande de son d'avoine. A le gout de raisin et de sel."
	icon_state = "bran_requests"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/salt = 8,
	)
	tastes = list("de son" = 4, "de raisin" = 3, "de sel" = 1)
	foodtypes = GRAIN | FRUIT | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/butter
	name = "plaquette de beurre"
	desc = "Éviter de tout manger comme ça."
	icon_state = "butter"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("butter" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/butter/examine(mob/user)
	. = ..()
	. += span_notice("Je ne sais pas pourquoi vous voudriez faire ça, mais si vous y ajoutez une tige en fer, vous pouvez faire du <b>beurre sur un baton</b>.")

/obj/item/food/butter/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/stack/rods))
		var/obj/item/stack/rods/rods = item
		if(!rods.use(1))//borgs can still fail this if they have no metal
			to_chat(user, span_warning("Vous n'avez pas assez de fer pour mettre une [src] sur un baton !"))
			return ..()
		to_chat(user, span_notice("Vous mettez votre tige de fer dans la blaquette de beurre. Erk."))
		var/obj/item/food/butter/on_a_stick/new_item = new(usr.loc)
		var/replace = (user.get_inactive_held_item() == rods)
		if(!rods && replace)
			user.put_in_hands(new_item)
		qdel(src)
		return TRUE
	..()

/obj/item/food/butter/on_a_stick //there's something so special about putting it on a stick. French's edit : ???
	name = "beurre sur un baton"
	desc = "Je crois que c'est censé être une blague de cul. Rajouter la tige de métal n'a pas améliorer sa comestibilité."
	icon_state = "butteronastick"
	trash_type = /obj/item/stack/rods
	food_flags = FOOD_FINGER_FOOD

/obj/item/food/onionrings
	name = "oignons frits"
	desc = "Des tranches d'oignons enroulées dans de la pâte et fries."
	icon_state = "onionrings"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3)
	gender = PLURAL
	tastes = list("de la pâte" = 3, "d'oignon" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/pineappleslice
	name = "tranche d'ananas"
	desc = "Une tranche d'ananas bien juteuse."
	icon_state = "pineapple_slice"
	juice_results = list(/datum/reagent/consumable/pineapplejuice = 3)
	tastes = list("d'ananase" = 1)
	foodtypes = FRUIT | PINEAPPLE
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/crab_rangoon
	name = "Rangoons au crabe"
	desc = "Peu importe comme vous appelez ça, c'est un merveilleux concentré de crème au crabe."
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "crabrangoon"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("de crème" = 4, "de crabe" = 3, "de croustillant" = 2)
	foodtypes = MEAT | DAIRY | GRAIN
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/pesto
	name = "pesto"
	desc = "Un mélange de fromage solide, de sel, d'herbes, d'ail et de pignons de pin. Fréquemment utilisé comme sauce pour des pates ou des pizzas. Peut également être tartiné sur du pain."
	icon_state = "pesto"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("pesto" = 1)
	foodtypes = VEGETABLES | DAIRY | NUTS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/tomato_sauce
	name = "sauce tomate"
	desc = "De la sauce tomate, parfaite pour des pizzas ou des pâtes. Mamma mia !"
	icon_state = "tomato_sauce"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("tomato" = 1, "herbs" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/bechamel_sauce
	name = "sauce béchamel"
	desc = "Une sauce blanche commune de la cuisine européenne."
	icon_state = "bechamel_sauce"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("de crème" = 1)
	foodtypes = DAIRY | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/roasted_bell_pepper
	name = "poivron rôti"
	desc = "Un poivron noircit, brulé. Super pour faire des sauces."
	icon_state = "roasted_bell_pepper"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/char = 1,
	)
	tastes = list("de poivron" = 1, "de brulé" = 1)
	foodtypes = VEGETABLES
	burns_in_oven = TRUE

/obj/item/food/pierogi
	name = "pierogi"
	desc = "Un ravioli, créé en emballant de la garniture avec de la pâte et en la plongeant dans de l'eau bouillante. Celui ci est garni d'un mélange de patates et d'oignons."
	icon_state = "pierogi"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de pomme de terre" = 1, "d'oignons" = 1)
	foodtypes = GRAIN | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/stuffed_cabbage
	name = "chou garni"
	desc = "Un savoureux mélange de viande hachée et de riz, enveloppée dans des feuilles de chou cuites et recouvert de sauce tomate. À tomber par terre."
	icon_state = "stuffed_cabbage"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de viande juteuse" = 1, "de riz" = 1, "de chou" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/seaweedsheet
	name = "feuille d'algue"
	desc = "Une feuille d'algue séchée utilisée pour faire des sushi. Utilisez un ingrédient dessus pour commencer à faire des sushis personnalisés !"
	icon_state = "seaweedsheet"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("d'algue" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/seaweedsheet/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, /obj/item/food/sushi/empty, CUSTOM_INGREDIENT_ICON_FILL, max_ingredients = 6)

/obj/item/food/granola_bar
	name = "barre de muesli"
	desc = "Un mélange sec d'avoine, de noix, de fruits et de chocolat, condensé dans en une seule barre. Un bon en-cas quand on se promède dans l'espace !"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "granola_bar"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/nutriment/protein = 4,
	)
	tastes = list("de muesli" = 1, "de noix" = 1, "de chocolat" = 1, "de raisin" = 1)
	foodtypes = GRAIN | NUTS | FRUIT | SUGAR | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/onigiri
	name = "onigiri"
	desc = "Une boule de riz de forme triangulaire, avec de la garniture au centre et entouré par une feuille d'algue. Vous pouvez y ajouter de la garniture !"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "onigiri"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("du riz" = 1, "d'algue séchée" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/onigiri/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, /obj/item/food/onigiri/empty, CUSTOM_INGREDIENT_ICON_NOCHANGE, max_ingredients = 4)

// empty onigiri for custom onigiri
/obj/item/food/onigiri/empty
	name = "onigiri"
	desc = "Une boule de riz de forme triangulaire, entouré par une feuille d'algue. Vous pouvez y ajouter de la garniture !"
	icon_state = "onigiri"
	foodtypes = VEGETABLES
	tastes = list()

/obj/item/food/pacoca
	name = "paçoca"
	desc = "Une friandise brésilienne traditionnelle composée de cacahuète moulues, de sucre et de sel compressé sous forme de cylindre."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "pacoca"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("de cacahuète" = 1, "de sucre" = 1)
	foodtypes = NUTS | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/pickle
	name = "cornichon"
	desc = "Les cornichons étaient de la même espèce que les concombres, autrefois. Il y a très longtemps. A clairement été mariné, mais a l'air très appétissant."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "pickle"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/medicine/antihol = 2,
	)
	tastes = list("de cornichon" = 1, "d'épices" = 1, "d'eau salée" = 2)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/springroll
	name = "prouleaux de printemps"
	desc = "Une assiette de wraps de riz translucides, garnis de légumes frais, servi avec de la sauce chili. Soit vous aimez, soit vous détestez."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "springroll"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/capsaicin = 2,
	)
	tastes = list("de craps de riz" = 1, "d'épices" = 1, "de légumes croquants" = 1)
	foodtypes = GRAIN | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cheese_pierogi
	name = "pierogi au fromage"
	desc = "Un ravioli, créé en emballant de la garniture avec de la pâte et en la plongeant dans de l'eau bouillante. Celui ci est garni d'un mélange de patates et de fromage."
	icon_state = "cheese_pierogi"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de pomme de terre" = 1, "de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/meat_pierogi
	name = "pierogi à la viande"
	desc = "Un ravioli, créé en emballant de la garniture avec de la pâte et en la plongeant dans de l'eau bouillante. Celui ci est garni d'un mélange de patates et de viande."
	icon_state = "meat_pierogi"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("de pomme de terre" = 1, "de fromage" = 1)
	foodtypes = GRAIN | VEGETABLES | MEAT
	w_class = WEIGHT_CLASS_SMALL
