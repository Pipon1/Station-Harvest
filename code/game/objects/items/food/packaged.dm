// Pre-packaged meals, canned, wrapped, and vended

// Cans
/obj/item/food/canned
	name = "air en conserve"
	desc = "Si vous vous êtes jamais demandé d'où vient l'air..."
	food_reagents = list(
		/datum/reagent/oxygen = 6,
		/datum/reagent/nitrogen = 24,
	)
	icon = 'icons/obj/food/canned.dmi'
	icon_state = "peachcan"
	food_flags = FOOD_IN_CONTAINER
	w_class = WEIGHT_CLASS_NORMAL
	max_volume = 30
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE

/obj/item/food/canned/proc/open_can(mob/user)
	to_chat(user, span_notice("Vous ouvrez [src]."))
	playsound(user.loc, 'sound/items/foodcanopen.ogg', 50)
	reagents.flags |= OPENCONTAINER
	preserved_food = FALSE
	make_decompose()

/obj/item/food/canned/attack_self(mob/user)
	if(!is_drainable())
		open_can(user)
		icon_state = "[icon_state]_open"
	return ..()

/obj/item/food/canned/attack(mob/living/target, mob/user, def_zone)
	if (!is_drainable())
		to_chat(user, span_warning("le couvercle de [src]ne s'ouvre pas !"))
		return FALSE
	return ..()

/obj/item/food/canned/beans
	name = "conserve d'haricots"
	desc = "Le logo indique que, d'une façon ou d'une autre, Nanotrasen produit des conserves d'haricots."
	icon_state = "beans"
	trash_type = /obj/item/trash/can/food/beans
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 9,
		/datum/reagent/consumable/ketchup = 4,
	)
	tastes = list("d'haricot" = 1)
	foodtypes = VEGETABLES

/obj/item/food/canned/peaches
	name = "pêches en boite"
	desc = "Une conserve de pêches mures, nageant dans leurs propres jus."
	icon_state = "peachcan"
	trash_type = /obj/item/trash/can/food/peaches
	food_reagents = list(
		/datum/reagent/consumable/peachjuice = 20,
		/datum/reagent/consumable/sugar = 8,
		/datum/reagent/consumable/nutriment = 2,
	)
	tastes = list("de pêche" = 7, "de conserve" = 1)
	foodtypes = FRUIT | SUGAR

/obj/item/food/canned/peaches/maint
	name = "pêches de maintenance"
	desc = "J'ai une bouche et je dois manger."
	icon_state = "peachcanmaint"
	trash_type = /obj/item/trash/can/food/peaches/maint
	tastes = list("de pêche" = 1, "de conserve" = 7)
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/canned/tomatoes
	name = "tomates de San Marzano en conserve"
	desc = "Une conserve de tomates de San Marzano d'une grande qualité. Vient des colinnes du sud de l'Italie."
	icon_state = "tomatoescan"
	trash_type = /obj/item/trash/can/food/tomatoes
	food_reagents = list(
		/datum/reagent/consumable/tomatojuice = 20,
		/datum/reagent/consumable/salt = 2,
	)
	tastes = list("de tomate" = 7, "de conserve" = 1)
	foodtypes = VEGETABLES //fuck you, real life!

/obj/item/food/canned/pine_nuts
	name = "pignons de pin en conserve"
	desc = "Une petite boite de conserve de pignons de pin. Vous pouvez la manger comme ça, si vous voulez."
	icon_state = "pinenutscan"
	trash_type = /obj/item/trash/can/food/pine_nuts
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("de pignons de pin" = 1)
	foodtypes = NUTS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/canned/envirochow
	name = "corgi en conserve" //French's edit : Il y avait des blagues racistes, ici
	desc = "Cachez ce plat que le HoP ne saurait voir."
	icon_state = "envirochow"
	trash_type = /obj/item/trash/can/food/envirochow
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 9,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("d'amitié brisée" = 5, "de chien" = 3)
	foodtypes = MEAT | GROSS

/obj/item/food/canned/envirochow/attack_animal(mob/living/simple_animal/user, list/modifiers)
	if(!check_buffability(user))
		return ..()
	apply_buff(user)

/obj/item/food/canned/envirochow/attack_basic_mob(mob/living/basic/user, list/modifiers)
	if(!check_buffability(user))
		return ..()
	apply_buff(user)

/obj/item/food/canned/envirochow/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(!proximity_flag)
		return
	if(!check_buffability(target))
		return
	apply_buff(target, user)

///This proc checks if the mob is able to recieve the buff.
/obj/item/food/canned/envirochow/proc/check_buffability(mob/living/hungry_pet)
	if(!isanimal_or_basicmob(hungry_pet)) // Not a pet
		return FALSE
	if(!is_drainable()) // Can is not open
		return FALSE
	if(hungry_pet.stat) // Parrot deceased
		return FALSE
	if(hungry_pet.mob_biotypes & (MOB_BEAST|MOB_REPTILE|MOB_BUG))
		return TRUE
	else
		return FALSE // Humans, robots & spooky ghosts not allowed

///This makes the animal eat the food, and applies the buff status effect to them.
/obj/item/food/canned/envirochow/proc/apply_buff(mob/living/simple_animal/hungry_pet, mob/living/dog_mom)
	hungry_pet.apply_status_effect(/datum/status_effect/limited_buff/health_buff) //the status effect keeps track of the stacks
	hungry_pet.visible_message(
		span_notice("[hungry_pet] mange le [src]."),
		span_nicegreen("Vous mangez le [src]."),
		span_notice("Vous entendez des bruits de mastications humides."))
	SEND_SIGNAL(src, COMSIG_FOOD_CONSUMED, hungry_pet, dog_mom ? dog_mom : hungry_pet) //If there is no dog mom, we assume the pet fed itself.
	playsound(loc, 'sound/items/eatfood.ogg', rand(30, 50), TRUE)
	qdel(src)


// DONK DINNER: THE INNOVATIVE WAY TO GET YOUR DAILY RECOMMENDED ALLOWANCE OF SALT... AND THEN SOME!
/obj/item/food/ready_donk
	name = "\improper Donk-Facile : Avec du goût"
	desc = "Un rapide diner-Donk : Maintenant avec du goût !"
	icon_state = "ready_donk"
	trash_type = /obj/item/trash/ready_donk
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("de nourriture ?" = 2, "de fainéantise" = 1)
	foodtypes = MEAT | JUNKFOOD
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

	/// What type of ready-donk are we warmed into?
	var/warm_type = /obj/item/food/ready_donk/warm

/obj/item/food/ready_donk/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/ready_donk/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type)

/obj/item/food/ready_donk/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>Vous regardez à l'arrière de la boite...</i>")
	. += "\t[span_info("Donk-Facile : une production de Donk Co.")]"
	. += "\t[span_info("Instructions de préparation : Ouvrez la boite et percez le film plastique, chauffez au micro-onde pendant 2 minutes. Laissez reposer pendant 60 secondes avant de consommer. Attention, le produit sera chaud.")]"
	. += "\t[span_info("Pour 200g : 8g sodium; 25g matières grasses, dont 22g sont saturés; 2g sucre.")]"
	return .

/obj/item/food/ready_donk/warm
	name = "Donk-Facile chaud : Avec du goût"
	desc = "Un rapide diner-Donk, maintenant avec du goût ! Et c'est même chaud !"
	icon_state = "ready_donk_warm"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/medicine/omnizine = 3,
	)
	tastes = list("de nourriture ?" = 2, "de fainéantise" = 1)

	// Don't burn your warn ready donks.
	warm_type = /obj/item/food/badrecipe

/obj/item/food/ready_donk/mac_n_cheese
	name = "\improper Donk-Facile : Donk-a-Roni"
	desc = "Macaronis au fromage néon-orange, et ça en quelques secondes !"
	tastes = list("de pâte avec du fromage" = 2, "de fainéantise" = 1)
	foodtypes = GRAIN | DAIRY | JUNKFOOD

	warm_type = /obj/item/food/ready_donk/warm/mac_n_cheese

/obj/item/food/ready_donk/warm/mac_n_cheese
	name = "Donk-Facile chaud : Donk-a-Roni"
	desc = "Macaronis au fromage néon-orange, prêts à être mangé !"
	icon_state = "ready_donk_warm_mac"
	tastes = list("de pâte avec du fromage" = 2, "de fainéantise" = 1)
	foodtypes = GRAIN | DAIRY | JUNKFOOD

/obj/item/food/ready_donk/donkhiladas
	name = "\improper Donk-Facile : Donkhiladas"
	desc = "Les donkhiladas, la signature de Donk Co., avec de la sauce Donk, pour un goût 'authentique' du Mexique."
	tastes = list("d'enchiladas" = 2, "de fainéantise" = 1)
	foodtypes = GRAIN | DAIRY | MEAT | VEGETABLES | JUNKFOOD

	warm_type = /obj/item/food/ready_donk/warm/donkhiladas

/obj/item/food/ready_donk/warm/donkhiladas
	name = "Donk-Facile chaud : Donkhiladas"
	desc = "Les donkhiladas, la signature de Donk Co., avec de la sauce Donk, suivi aussi chaud que le soleil mexicain."
	icon_state = "ready_donk_warm_mex"
	tastes = list("d'enchiladas" = 2, "de fainéantise" = 1)
	foodtypes = GRAIN | DAIRY | MEAT | VEGETABLES | JUNKFOOD


// Rations
/obj/item/food/rationpack
	name = "ration"
	desc = "Un barre rectangulaire qui <i>ressemble</i> tristement à du chocolat, dans un emballage gris sans description. A sauvé la vie de nombreux soldats, généralement en stoppant des balles."
	icon_state = "rationpack"
	bite_consumption = 3
	junkiness = 15
	tastes = list("de carton" = 3, "de tristesse" = 3)
	foodtypes = null //Don't ask what went into them. You're better off not knowing.
	food_reagents = list(
		/datum/reagent/consumable/nutriment/stabilized = 10,
		/datum/reagent/consumable/nutriment = 2,
	) //Won't make you fat. Will make you question your sanity.

///Override for checkliked callback
/obj/item/food/rationpack/make_edible()
	. = ..()
	AddComponent(/datum/component/edible, check_liked = CALLBACK(src, PROC_REF(check_liked)))

/obj/item/food/rationpack/proc/check_liked(fraction, mob/mob) //Nobody likes rationpacks. Nobody.
	return FOOD_DISLIKED
