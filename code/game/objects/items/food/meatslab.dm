/obj/item/food/meat
	custom_materials = list(/datum/material/meat = MINERAL_MATERIAL_AMOUNT * 4)
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/food/meat.dmi'
	var/subjectname = ""
	var/subjectjob = null

/obj/item/food/meat/slab
	name = "viande"
	desc = "Une pièce de viande."
	icon_state = "meat"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/cooking_oil = 2,
	) //Meat has fats that a food processor can process into cooking oil
	tastes = list("de viande" = 1)
	foodtypes = MEAT | RAW
	///Legacy code, handles the coloring of the overlay of the cutlets made from this.
	var/slab_color = "#FF0000"


/obj/item/food/meat/slab/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dryable,  /obj/item/food/sosjerky/healthy)

/obj/item/food/meat/slab/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/slab/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/meat/rawcutlet/plain, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

///////////////////////////////////// HUMAN MEATS //////////////////////////////////////////////////////

/obj/item/food/meat/slab/human
	name = "viande"
	tastes = list("de viande tendre" = 1)
	foodtypes = MEAT | RAW | GORE
	venue_value = FOOD_MEAT_HUMAN

/obj/item/food/meat/slab/human/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/human, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/slab/human/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/meat/rawcutlet/plain/human, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/human/mutant/slime
	icon_state = "viande de slime"
	desc = "Parce que la gelée n'était pas une assez grande offense à l'humanité."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/toxin/slimejelly = 3,
	)
	tastes = list("de slime" = 1, "de gêlée" = 1)
	foodtypes = MEAT | RAW | TOXIC
	venue_value = FOOD_MEAT_MUTANT_RARE

/obj/item/food/meat/slab/human/mutant/golem
	icon_state = "viande de golem"
	desc = "Des pierres comestibles, bienvenue dans le futur."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/iron = 3,
	)
	tastes = list("de pierre" = 1)
	foodtypes = MEAT | RAW | GROSS
	venue_value = FOOD_MEAT_MUTANT_RARE

/obj/item/food/meat/slab/human/mutant/golem/adamantine
	icon_state = "viande d'agolem"
	desc = "De l'enclot à slime, en passant par l'atelier de runes pour finir dans la cuisine. La science, messieurs dames."
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/human/mutant/lizard
	icon_state = "viande de lézard"
	desc = "Garantie ssssans écailles.."
	tastes = list("de viande" = 4, "d'écailles" = 1)
	foodtypes = MEAT | RAW | GORE
	venue_value = FOOD_MEAT_MUTANT

/obj/item/food/meat/slab/human/mutant/lizard/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/human/lizard, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/human/mutant/plant
	icon_state = "viande de plante"
	desc = "Toute les joies d'une consommation saine combinée avec toute les joies du cannibalisme."
	tastes = list("de salade" = 1, "de bois" = 1)
	foodtypes = VEGETABLES
	venue_value = FOOD_MEAT_MUTANT_RARE

/obj/item/food/meat/slab/human/mutant/shadow
	icon_state = "viande d'ombre"
	desc = "Aïe, le coin de table..."
	tastes = list("de ténèbres" = 1, "de viande" = 1)
	foodtypes = MEAT | RAW | GORE
	venue_value = FOOD_MEAT_MUTANT_RARE

/obj/item/food/meat/slab/human/mutant/fly
	icon_state = "viande de mouche"
	desc = "Rien n'égale le gout de la chaire radioactive remplie de vers."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/uranium = 3,
	)
	tastes = list("de vers" = 1, "d'intérieur de réacteur" = 1)
	foodtypes = MEAT | RAW | GROSS | BUGS | GORE
	venue_value = FOOD_MEAT_MUTANT

/obj/item/food/meat/slab/human/mutant/moth
	icon_state = "viande de papillon de nuit"
	desc = "Sec et poudreux. Plutôt joli, cela dit."
	tastes = list("de poussière" = 1, "de poudre" = 1, "de viande" = 2)
	foodtypes = MEAT | RAW | BUGS | GORE
	venue_value = FOOD_MEAT_MUTANT

/obj/item/food/meat/slab/human/mutant/skeleton
	name = "os"
	icon_state = "skeletonmeat"
	desc = "Il y a un moment où il faut s'arrêter. Et là, clairement, ce moment a été passé."
	tastes = list("d'os" = 1)
	foodtypes = GROSS | GORE
	venue_value = FOOD_MEAT_MUTANT_RARE

/obj/item/food/meat/slab/human/mutant/skeleton/make_processable()
	return //skeletons dont have cutlets

/obj/item/food/meat/slab/human/mutant/zombie
	name = "viande (avariée)"
	icon_state = "rottenmeat"
	desc = "À deux doigts de devenir du fertilisant pour votre jardin."
	tastes = list("de cervelle" = 1, "de viande" = 1)
	foodtypes = RAW | MEAT | TOXIC | GORE | GROSS

/obj/item/food/meat/slab/human/mutant/ethereal
	icon_state = "etherealmeat"
	desc = "Tellement brillant que l'ingérer vous fera briller aussi."
	food_reagents = list(/datum/reagent/consumable/liquidelectricity/enriched = 10)
	tastes = list("d'éléctricité pure" = 2, "de viande" = 1)
	foodtypes = RAW | MEAT | TOXIC | GORE
	venue_value = FOOD_MEAT_MUTANT

////////////////////////////////////// OTHER MEATS ////////////////////////////////////////////////////////

/obj/item/food/meat/slab/synthmeat
	name = "viande synthétique"
	icon_state = "meat_old"
	desc = "Une pièce de viande de synthèse."
	foodtypes = RAW | MEAT //hurr durr chemicals were harmed in the production of this meat thus its non-vegan.
	venue_value = FOOD_PRICE_WORTHLESS

/obj/item/food/meat/slab/synthmeat/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/synth, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/meatproduct
	name = "produit de viande"
	icon_state = "meatproduct"
	desc = "Ue pièce de viande transformée par des produits chimiques."
	tastes = list("de saveur de viande" = 2, "d'amidon modifié" = 2, "de colorants naturels et artificiels" = 1, "d'acide butyrique" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/meatproduct/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/meatproduct, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/monkey
	name = "viande de singe"
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/bugmeat
	name = "viande d'insecte"
	icon_state = "spidermeat"
	foodtypes = RAW | MEAT | BUGS

/obj/item/food/meat/slab/mouse
	name = "viande de souris"
	desc = "Une pièce de viande de souris. Il vaut probablement mieux ne pas la manger crue."
	foodtypes = RAW | MEAT | GORE

/obj/item/food/meat/slab/mouse/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOUSE, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/corgi
	name = "viande de corgi"
	desc = "À le goût de... Vous savez..."
	tastes = list("de viande" = 4, "d'une tendresse pour les chapeaux" = 1)
	foodtypes = RAW | MEAT | GORE

/obj/item/food/meat/slab/corgi/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CORGI, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/mothroach
	name = "viande de mite"
	desc = "Une petite pièce de viande."
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/mothroach/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/pug
	name = "pug meat"
	desc = "À le goût de... Vous savez..."
	foodtypes = RAW | MEAT | GORE

/obj/item/food/meat/slab/pug/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_PUG, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/killertomato
	name = "viande de tomate tueuse"
	desc = "Une tranche d'une énorme tomate.."
	icon_state = "tomatomeat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("de tomate" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/slab/killertomato/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/killertomato, rand(70 SECONDS, 85 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/killertomato/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/killertomato, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/bear
	name = "viande d'ours"
	desc = "Une pièce de viande très virile."
	icon_state = "bearmeat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 16,
		/datum/reagent/medicine/morphine = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/cooking_oil = 6,
	)
	tastes = list("de viande" = 1, "de saumon" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/bear/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/bear, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/bear/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/bear, rand(40 SECONDS, 70 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/bear/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_BEAR, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/xeno
	name = "viande de xéno"
	desc = "Une pièce de viande."
	icon_state = "xenomeat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	bite_consumption = 4
	tastes = list("de viande" = 1, "d'acide" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/xeno/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/xeno, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/xeno/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/xeno, rand(40 SECONDS, 70 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/spider
	name = "viande d'araignée"
	desc = "Une pièce de viande d'araignée. C'est vraiment kafkaïen."
	icon_state = "spidermeat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/toxin = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de toile d'araignée" = 1)
	foodtypes = RAW | MEAT | TOXIC

/obj/item/food/meat/slab/spider/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/spider, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/spider/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/spider, rand(40 SECONDS, 70 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/goliath
	name = "viande de goliath"
	desc = "Une pièce de viande de goliath. Ce n'est pas très comestible pour l'instant, mais ça se cuise assez bien dans de la lave."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/toxin = 5,
		/datum/reagent/consumable/cooking_oil = 3,
	)
	icon_state = "goliathmeat"
	tastes = list("de viande" = 1)
	foodtypes = RAW | MEAT | TOXIC

/obj/item/food/meat/slab/goliath/burn()
	visible_message(span_notice("[src] a finit de cuire !"))
	new /obj/item/food/meat/steak/goliath(loc)
	qdel(src)

/obj/item/food/meat/slab/meatwheat
	name = "boulette de blé"
	desc = "Ça ne ressemble pas à de la viande, mais vos standars ne sont pas <i>si</i> élevé que ça."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/blood = 5, /datum/reagent/consumable/cooking_oil = 1)
	icon_state = "meatwheat_clump"
	bite_consumption = 4
	tastes = list("de viande" = 1, "de blé" = 1)
	foodtypes = GRAIN

/obj/item/food/meat/slab/gorilla
	name = "viande de gorille"
	desc = "Plus grand que la viande de singe."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/cooking_oil = 5, //Plenty of fat!
	)

/obj/item/food/meat/rawbacon
	name = "tranche de bacon crue"
	desc = "Une tranche de bacon crue."
	icon_state = "baconb"
	bite_consumption = 2
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/cooking_oil = 3,
	)
	tastes = list("de bacon" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/rawbacon/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/bacon, rand(25 SECONDS, 45 SECONDS), TRUE, TRUE)

/obj/item/food/meat/bacon
	name = "tranche de bacon"
	desc = "Une délicieuse tranche de bacon."
	icon_state = "baconcookedb"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/cooking_oil = 2,
	)
	tastes = list("de bacon" = 1)
	foodtypes = MEAT | BREAKFAST
	burns_on_grill = TRUE

/obj/item/food/meat/slab/gondola
	name = "viande de gondola"
	desc = "Selon les vieilles légende, consommer de la chair crue de gondola accordre la paix intérieure."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/gondola_mutation_toxin = 5,
		/datum/reagent/consumable/cooking_oil = 3,
	)
	tastes = list("de viande" = 4, "de sérénité" = 1)
	foodtypes = RAW | MEAT | GORE

/obj/item/food/meat/slab/gondola/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/gondola, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/gondola/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/gondola, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/slab/penguin
	name = "viande de manchot"
	icon_state = "birdmeat"
	desc = "Une pièce de viande de manchot"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/cooking_oil = 3,
	)
	tastes = list("de boeuf" = 1, "de morue" = 1)

/obj/item/food/meat/slab/penguin/make_processable()
	. = ..()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/penguin, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/penguin/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/penguin, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/slab/rawcrab
	name = "viande de crabe crue"
	desc = "Une pile de viande de crabe crue."
	icon_state = "crabmeatraw"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/cooking_oil = 3,
	)
	tastes = list("de crabe cru" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/rawcrab/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/crab, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/crab
	name = "viande de crabe"
	desc = "De la délicieuse viande de crabe cuite."
	icon_state = "crabmeat"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/cooking_oil = 2,
	)
	tastes = list("de crabe" = 1)
	foodtypes = SEAFOOD
	burns_on_grill = TRUE

/obj/item/food/meat/slab/chicken
	name = "viande de poulet"
	icon_state = "birdmeat"
	desc = "Une pièce de poulet crue. N'oubliez pas de vous laver les mains !"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6) //low fat
	tastes = list("de poulet" = 1)

/obj/item/food/meat/slab/chicken/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/chicken, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/chicken/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/chicken, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe? (no this is chicken)

/obj/item/food/meat/slab/chicken/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CHICKEN, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/pig
	name = "porc cru"
	desc = "Une pièce de porc cru. Ce petit cochon a finalement rencontré le grand méchant boucher."
	icon_state = "pig_meat"
	tastes = list("de cochon" = 1)
	foodtypes = RAW | MEAT | GORE

/obj/item/food/meat/slab/pig/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/pig, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)


////////////////////////////////////// MEAT STEAKS ///////////////////////////////////////////////////////////
/obj/item/food/meat/steak
	name = "steak"
	desc = "Un morceau de viande épicée."
	icon_state = "meatsteak"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	foodtypes = MEAT
	tastes = list("de viande" = 1)
	burns_on_grill = TRUE

/obj/item/food/meat/steak/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_MICROWAVE_COOKED, PROC_REF(on_microwave_cooked))

/obj/item/food/meat/steak/proc/on_microwave_cooked(datum/source, atom/source_item, cooking_efficiency = 1)
	SIGNAL_HANDLER

	name = "[source_item.name] steak"

/obj/item/food/meat/steak/plain
	foodtypes = MEAT

/obj/item/food/meat/steak/plain/human
	tastes = list("de viande tendre" = 1)
	foodtypes = MEAT | GORE

///Make sure the steak has the correct name
/obj/item/food/meat/steak/plain/human/on_microwave_cooked(datum/source, atom/source_item, cooking_efficiency = 1)
	. = ..()
	if(!istype(source_item, /obj/item/food/meat))
		return

	var/obj/item/food/meat/origin_meat = source_item
	subjectname = origin_meat.subjectname
	subjectjob = origin_meat.subjectjob
	if(subjectname)
		name = "[origin_meat.subjectname] meatsteak"
	else if(subjectjob)
		name = "[origin_meat.subjectjob] meatsteak"


/obj/item/food/meat/steak/killertomato
	name = "steak de tomate tueuse"
	tastes = list("de tomate" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/steak/bear
	name = "steak d'ours"
	tastes = list("de viande" = 1, "de saumon" = 1)

/obj/item/food/meat/steak/xeno
	name = "steak de xéno"
	tastes = list("meat" = 1, "d'acide" = 1)

/obj/item/food/meat/steak/spider
	name = "steak d'araignée"
	tastes = list("de toile d'araignée" = 1)

/obj/item/food/meat/steak/goliath
	name = "steak de goliath"
	desc = "Un délicieux steak cuisiné à la lave."
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	icon_state = "goliathsteak"
	trash_type = null
	tastes = list("de viande" = 1, "de pierre" = 1)
	foodtypes = MEAT

/obj/item/food/meat/steak/gondola
	name = "steak de gondola"
	tastes = list("de viande" = 1, "de sérénité" = 1)

/obj/item/food/meat/steak/penguin
	name = "steak de manchot"
	icon_state = "birdsteak"
	tastes = list("de boeuf" = 1, "de morue" = 1)

/obj/item/food/meat/steak/chicken
	name = "steak de poulet" //Can you have chicken steaks? Maybe this should be renamed once it gets new sprites.
	icon_state = "birdsteak"
	tastes = list("de poulet" = 1)

/obj/item/food/meat/steak/plain/human/lizard
	name = "steak de lézard"
	icon_state = "birdsteak"
	tastes = list("de poulet juteux" = 3, "d'écailles" = 1)
	foodtypes = MEAT | GORE

/obj/item/food/meat/steak/meatproduct
	name = "produit de viande traité thermiquement"
	icon_state = "meatproductsteak"
	tastes = list("de chaleur amélioré" = 2, "d'une suspicieuse tendresse" = 2, "de colorants naturels et artificiels" = 2, "d'agents émulsifiants" = 1)

/obj/item/food/meat/steak/plain/synth
	name = "synthsteak"
	desc = "Un steak de viande synthétique. Ça n'a pas l'air très bon."
	icon_state = "meatsteak_old"
	tastes = list("de viande" = 4, "de cryoxandone" = 1)

/obj/item/food/meat/steak/plain/pig
	name = "côte de porc"
	desc = "Une côte de porc."
	icon_state = "pigsteak"
	tastes = list("de cochon" = 1)
	foodtypes = MEAT

//////////////////////////////// MEAT CUTLETS ///////////////////////////////////////////////////////

//Raw cutlets

/obj/item/food/meat/rawcutlet
	name = "côtelette crue"
	desc = "Une côtelette crue."
	icon_state = "rawcutlet"
	bite_consumption = 2
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("de viande" = 1)
	foodtypes = MEAT | RAW
	var/meat_type = "meat"

/obj/item/food/meat/rawcutlet/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/plain, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/OnCreatedFromProcessing(mob/living/user, obj/item/work_tool, list/chosen_option, atom/original_atom)
	. = ..()
	if(!istype(original_atom, /obj/item/food/meat/slab))
		return
	var/obj/item/food/meat/slab/original_slab = original_atom
	var/mutable_appearance/filling = mutable_appearance(icon, "rawcutlet_coloration")
	filling.color = original_slab.slab_color
	add_overlay(filling)
	name = "raw [original_atom.name] cutlet"
	meat_type = original_atom.name

/obj/item/food/meat/rawcutlet/plain
	foodtypes = MEAT

/obj/item/food/meat/rawcutlet/plain/human
	tastes = list("de viande tendre" = 1)
	foodtypes = MEAT | RAW | GORE

/obj/item/food/meat/rawcutlet/plain/human/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/plain/human, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/plain/human/OnCreatedFromProcessing(mob/living/user, obj/item/item, list/chosen_option, atom/original_atom)
	. = ..()
	if(!istype(original_atom, /obj/item/food/meat))
		return
	var/obj/item/food/meat/origin_meat = original_atom
	subjectname = origin_meat.subjectname
	subjectjob = origin_meat.subjectjob
	if(subjectname)
		name = "côtelette crue de [origin_meat.subjectname]"
	else if(subjectjob)
		name = "côtelette crue de [origin_meat.subjectname]"

/obj/item/food/meat/rawcutlet/killertomato
	name = "côtelette crue de tomate tueuse"
	tastes = list("de tomate" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/rawcutlet/killertomato/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/killertomato, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/bear
	name = "côtelette crue d'ours"
	tastes = list("de viande" = 1, "de saumon" = 1)

/obj/item/food/meat/rawcutlet/bear/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_BEAR, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/rawcutlet/bear/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/bear, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/xeno
	name = "côtelette crue de xéno"
	tastes = list("de viande" = 1, "d'acide" = 1)

/obj/item/food/meat/rawcutlet/xeno/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/xeno, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/spider
	name = "côtelette crue d'araignée"
	tastes = list("de toile d'araignée" = 1)

/obj/item/food/meat/rawcutlet/spider/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/spider, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/gondola
	name = "côtelette crue de gondola"
	tastes = list("de viande" = 1, "de sérénité" = 1)

/obj/item/food/meat/rawcutlet/gondola/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/gondola, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/penguin
	name = "côtelette crue de manchot"
	tastes = list("de boeuf" = 1, "de morrue" = 1)

/obj/item/food/meat/rawcutlet/penguin/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/penguin, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/chicken
	name = "côtelette crue de poulet"
	tastes = list("de poulet" = 1)

/obj/item/food/meat/rawcutlet/chicken/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/chicken, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/chicken/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CHICKEN, CELL_VIRUS_TABLE_GENERIC_MOB)

//Cooked cutlets

/obj/item/food/meat/cutlet
	name = "côtelette "
	desc = "Une côtelette cuite."
	icon_state = "cutlet"
	bite_consumption = 2
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("de viande" = 1)
	foodtypes = MEAT
	burns_on_grill = TRUE

/obj/item/food/meat/cutlet/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_MICROWAVE_COOKED, PROC_REF(on_microwave_cooked))

///This proc handles setting up the correct meat name for the cutlet, this should definitely be changed with the food rework.
/obj/item/food/meat/cutlet/proc/on_microwave_cooked(datum/source, atom/source_item, cooking_efficiency)
	SIGNAL_HANDLER

	if(!istype(source_item, /obj/item/food/meat/rawcutlet))
		return

	var/obj/item/food/meat/rawcutlet/original_cutlet = source_item
	name = "côtelette de [original_cutlet.meat_type]"

/obj/item/food/meat/cutlet/plain

/obj/item/food/meat/cutlet/plain/human
	tastes = list("de viande tendre" = 1)
	foodtypes = MEAT | GORE

/obj/item/food/meat/cutlet/plain/human/on_microwave_cooked(datum/source, atom/source_item, cooking_efficiency)
	. = ..()
	if(!istype(source_item, /obj/item/food/meat))
		return

	var/obj/item/food/meat/origin_meat = source_item
	if(subjectname)
		name = "[origin_meat.subjectname] [initial(name)]"
	else if(subjectjob)
		name = "[origin_meat.subjectjob] [initial(name)]"

/obj/item/food/meat/cutlet/killertomato
	name = "côtelette de tomate tueuse"
	tastes = list("de tomate" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/cutlet/bear
	name = "côtelette d'ours"
	tastes = list("de viande" = 1, "de saumon" = 1)

/obj/item/food/meat/cutlet/xeno
	name = "côtelette de xéno"
	tastes = list("de viande" = 1, "d'acide" = 1)

/obj/item/food/meat/cutlet/spider
	name = "côtelette d'araignée"
	tastes = list("de toile d'araignée" = 1)

/obj/item/food/meat/cutlet/gondola
	name = "côtelette d'araignée"
	tastes = list("de viande" = 1, "de sérénité" = 1)

/obj/item/food/meat/cutlet/penguin
	name = "côtelette de manchot"
	tastes = list("de boeuf" = 1, "de morrue" = 1)

/obj/item/food/meat/cutlet/chicken
	name = "côtelette de poulet"
	tastes = list("de poulet" = 1)
