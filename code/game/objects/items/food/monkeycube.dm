/obj/item/food/monkeycube
	name = "cube de singe"
	desc = "Ajoutez juste de l'eau !"
	icon_state = "monkeycube"
	bite_consumption = 12
	food_reagents = list(/datum/reagent/monkey_powder = 30)
	tastes = list("de jungle" = 1, "de banane" = 1)
	foodtypes = MEAT | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY
	var/faction
	var/spawned_mob = /mob/living/carbon/human/species/monkey

/obj/item/food/monkeycube/proc/Expand()
	var/mob/spammer = get_mob_by_key(fingerprintslast)
	var/mob/living/bananas = new spawned_mob(drop_location(), TRUE, spammer)
	if(faction)
		bananas.faction = faction
	if (!QDELETED(bananas))
		visible_message(span_notice("[src] s'aggrandit !"))
		bananas.log_message("spawned via [src], Last attached mob: [key_name(spammer)].", LOG_ATTACK)
	else if (!spammer) // Visible message in case there are no fingerprints
		visible_message(span_notice("[src] échoue à s'aggrandir !"))
	qdel(src)

/obj/item/food/monkeycube/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] met [src] dans la bouche de [user.p_their()] ! On dirait que [user.p_theyre()] essaye de se suicider !"))
	var/eating_success = do_after(user, 1 SECONDS, src)
	if(QDELETED(user)) //qdeletion: the nuclear option of self-harm
		return SHAME
	if(!eating_success || QDELETED(src)) //checks if src is gone or if they failed to wait for a second
		user.visible_message(span_suicide("[user] a changé d'avis !"))
		return SHAME
	if(HAS_TRAIT(user, TRAIT_NOHUNGER)) //plasmamen don't have saliva/stomach acid
		user.visible_message(span_suicide("[user] réalise que le corps de [user.p_their()] ne va pas activer le [src]!")
		,span_warning("Votre corps ne va pas activer le [src]..."))
		return SHAME
	playsound(user, 'sound/items/eatfood.ogg', rand(10, 50), TRUE)
	user.temporarilyRemoveItemFromInventory(src) //removes from hands, keeps in M
	addtimer(CALLBACK(src, PROC_REF(finish_suicide), user), 15) //you've eaten it, you can run now
	return MANUAL_SUICIDE

/obj/item/food/monkeycube/proc/finish_suicide(mob/living/user) ///internal proc called by a monkeycube's suicide_act using a timer and callback. takes as argument the mob/living who activated the suicide
	if(QDELETED(user) || QDELETED(src))
		return
	if(src.loc != user) //how the hell did you manage this
		to_chat(user, span_warning("Quelque chose est en train d'arriver à [src]..."))
		return
	Expand()
	user.visible_message(span_danger("Le torse de [user] s'ouvre et un singe en sort !"))
	user.gib(null, TRUE, null, TRUE)

/obj/item/food/monkeycube/syndicate
	faction = list(FACTION_NEUTRAL, ROLE_SYNDICATE)

/obj/item/food/monkeycube/gorilla
	name = "cube de gorille"
	desc = "Presque comme le cube de singe !"
	bite_consumption = 20
	food_reagents = list(
		/datum/reagent/monkey_powder = 30,
		/datum/reagent/medicine/strange_reagent = 5,
	)
	tastes = list("de jungle" = 1, "de banane" = 1)
	spawned_mob = /mob/living/simple_animal/hostile/gorilla

/obj/item/food/monkeycube/chicken
	name = "cube de poulet"
	desc = "Un nouveau classique de Nanotrasen, le cube de poulet. Sans goût !"
	bite_consumption = 20
	food_reagents = list(
		/datum/reagent/consumable/eggyolk = 30,
		/datum/reagent/medicine/strange_reagent = 1,
	)
	tastes = list("de poulet" = 1, "du pays" = 1, "de bouillon de poulet" = 1)
	spawned_mob = /mob/living/simple_animal/chicken

/obj/item/food/monkeycube/bee
	name = "cube d'abeille"
	desc = "On était certain que c'était une bonne idée. Ajoutez juste de l'eau."
	bite_consumption = 20
	food_reagents = list(
		/datum/reagent/consumable/honey = 10,
		/datum/reagent/toxin = 5,
		/datum/reagent/medicine/strange_reagent = 1,
	)
	tastes = list("de bzz bzz" = 1, "de miel" = 1, "de regrets" = 1)
	spawned_mob = /mob/living/simple_animal/hostile/bee
