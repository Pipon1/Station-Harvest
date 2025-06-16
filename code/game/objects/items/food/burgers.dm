/obj/item/food/burger
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "hburger"
	inhand_icon_state = "burger"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de petit pain" = 2, "de steak haché" = 4)
	foodtypes = GRAIN | MEAT //lettuce doesn't make burger a vegetable.
	eat_time = 15 //Quick snack
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/burger/plain
	name = "Steak haché"
	desc = "La pierre angulaire de tous les petits déjeuners nutritifs."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	foodtypes = GRAIN | MEAT
	custom_price = PAYCHECK_CREW * 0.8
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/burger/plain/Initialize(mapload)
	. = ..()
	if(prob(1))
		new/obj/effect/particle_effect/fluid/smoke(get_turf(src))
		playsound(src, 'sound/effects/smoke.ogg', 50, TRUE)
		visible_message(span_warning("Oh, ye gods! [src] is ruined! But what if...?"))
		name = "Jambon fumé"
		desc = pick("Ahh, monsieur le chef du personnel, bienvenue, bienvenue. J'espère que vous êtes prêt pour un dîner mémorable !",
			"Et vous les appelez 'Jambon fumé', malgré le fait qu'ils sont évidemment cuit aux micro-ondes ?",
			"La station Aurore Boréale 13 ? À ce moment de notre service, à ce moment de l'année, dans ce secteur de l'espace, entièrement localisée dans votre chambre froide ?",
			"Vous savez, ces hamburgers ont un goût plutôt similaire à ceux du Faucon Maltais.")

/obj/item/food/burger/human
	name = "Burger à l'humain"
	desc = "Un burger à l'humain."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("d'un petit pain" = 2, "de poulet sans uniforme" = 4)
	foodtypes = MEAT | GRAIN | GORE
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/burger/human/CheckParts(list/parts_list)
	..()
	var/obj/item/food/patty/human/human_patty = locate(/obj/item/food/patty/human) in contents
	for(var/datum/material/meat/mob_meat/mob_meat_material in human_patty.custom_materials)
		if(mob_meat_material.subjectname)
			name = "burger de [mob_meat_material.subjectname]"
		else if(mob_meat_material.subjectjob)
			name = "burger de [mob_meat_material.subjectjob]"

/obj/item/food/burger/corgi
	name = "Burger au corgi"
	desc = "Espèce de monstre."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("d'un petit pain" = 4, "de corgi" = 2)
	foodtypes = GRAIN | MEAT | GORE
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/burger/appendix
	name = "Burger à l'appendice"
	desc = "A le goût de appendicite."
	icon_state = "appendixburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("d'un petit pain" = 4, "d'apprendice" = 2)
	foodtypes = GRAIN | MEAT | GORE
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/burger/fish
	name = "Sandwich de filet de carpe"
	desc = "Presque comme si une carpe hurlait quelque part... Rendez-moi ce filet de carpe, donnez-moi cette carpe."
	icon_state = "fishburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("d'un petit pain" = 4, "de poisson" = 4)
	foodtypes = GRAIN | SEAFOOD
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/burger/tofu
	name = "Burger au tofu"
	desc = "Qu'est-ce qu'est.. cette viande ?"
	icon_state = "tofuburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("d'un petit pain" = 4, "de tofu" = 4)
	foodtypes = GRAIN | VEGETABLES
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/burger/roburger
	name = "Burger aux bots"
	desc = "La salade est le seul composant organique. Bip."
	icon_state = "roburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/cyborg_mutation_nanomachines = 6,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("d'un petit pain" = 4, "de salade" = 2, "de boue d'épuration" = 1)
	foodtypes = GRAIN | TOXIC
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/burger/roburger/big
	desc = "Ce gigantesque pâté n'a pas l'air très bon pour la santé. Bip."
	max_volume = 120
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/cyborg_mutation_nanomachines = 80,
		/datum/reagent/consumable/nutriment/vitamin = 15,
	)

/obj/item/food/burger/xeno
	name = "Burger au xéno"
	desc = "A l'odeur du corrosif. A le goût de l'hérésie."
	icon_state = "xburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("d'un petit pain" = 4, "d'acide" = 4)
	foodtypes = GRAIN | MEAT
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/burger/bearger
	name = "Burzzlis"
	desc = "Àgrouh servir cru."
	icon_state = "bearger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("d'un petit pain" = 2, "de viande" = 2, "de saumon" = 2)
	foodtypes = GRAIN | MEAT
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/burger/clown
	name = "Burger de clown"
	desc = "Ça sent drôle..."
	icon_state = "clownburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("d'un petit pain" = 2, "d'une mauvaise blague" = 4)
	foodtypes = GRAIN | FRUIT
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/burger/mime
	name = "Burger de mime"
	desc = "Le goût brise la barrière de la langue."
	icon_state = "mimeburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 9,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/nothing = 6,
	)
	foodtypes = GRAIN
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/burger/brain
	name = "Burger au cerveau"
	desc = "Un burger étrange. A presque l'air conscient."
	icon_state = "brainburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/medicine/mannitol = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/nutriment/protein = 6,
	)
	tastes = list("d'un petit pain" = 4, "de cerveaux" = 2)
	foodtypes = GRAIN | MEAT | GORE
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/burger/ghost
	name = "Burger fantôme"
	desc = "Trop effrayant !"
	icon_state = "ghostburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 12,
		/datum/reagent/consumable/salt = 5,
	)
	tastes = list("d'un petit pain" = 2, "d'ectoplasme" = 4)
	foodtypes = GRAIN
	alpha = 170
	verb_say = "moans"
	verb_yell = "wails"
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/burger/ghost/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/food/burger/ghost/process()
	if(!isturf(loc)) //no floating out of bags
		return
	var/paranormal_activity = rand(100)
	switch(paranormal_activity)
		if(97 to 100)
			audible_message("[src] rattles a length of chain.")
			playsound(loc, 'sound/misc/chain_rattling.ogg', 300, TRUE)
		if(91 to 96)
			say(pick("OoOoOoo.", "OoooOOooOoo!!"))
		if(84 to 90)
			dir = pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
			step(src, dir)
		if(71 to 83)
			step(src, dir)
		if(65 to 70)
			var/obj/machinery/light/light = locate(/obj/machinery/light) in view(4, src)
			light?.flicker()
		if(62 to 64)
			playsound(loc, pick('sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg'), 50, TRUE, ignore_walls = FALSE)
		if(61)
			visible_message("[src] crache une boule d'ectoplasme !")
			new /obj/effect/decal/cleanable/greenglow/ecto(loc)
			playsound(loc, 'sound/effects/splat.ogg', 200, TRUE)

		//If i was less lazy i would make the burger forcefeed itself to a nearby mob here.

/obj/item/food/burger/ghost/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/food/burger/red
	name = "Burger rouge"
	desc = "Parfait pour cacher que c'est carbonnisé."
	icon_state = "cburger"
	color = COLOR_RED
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/colorful_reagent/powder/red = 10,
	)
	tastes = list("d'un petit pain" = 2, "de Rouge" = 2)
	foodtypes = GRAIN | MEAT

/obj/item/food/burger/orange
	name = "Burger orange"
	desc = "Contient 0% de jus."
	icon_state = "cburger"
	color = COLOR_ORANGE
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/colorful_reagent/powder/orange = 10,
	)
	tastes = list("d'un petit pain" = 2, "d'orange" = 2)
	foodtypes = GRAIN | MEAT

/obj/item/food/burger/yellow
	name = "Burger jaune"
	desc = "Brillant jusqu'à la dernière bouchée."
	icon_state = "cburger"
	color = COLOR_YELLOW
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/colorful_reagent/powder/yellow = 10,
	)
	tastes = list("d'un petit pain" = 2, "de jaune" = 2)
	foodtypes = GRAIN | MEAT

/obj/item/food/burger/green
	name = "Burger vert"
	desc = "Ce n'est pas de la moisissure, c'est de la peinture !"
	icon_state = "cburger"
	color = COLOR_GREEN
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/colorful_reagent/powder/green = 10,
	)
	tastes = list("d'un petit pain" = 2, "de vert" = 2)
	foodtypes = GRAIN | MEAT

/obj/item/food/burger/blue
	name = "Burger bleu"
	desc = "Est-ce que c'est cuit bleu ?"
	icon_state = "cburger"
	color = COLOR_BLUE
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/colorful_reagent/powder/blue = 10,
	)
	tastes = list("d'un petit pain" = 2, "de bleu" = 2)
	foodtypes = GRAIN | MEAT

/obj/item/food/burger/purple
	name = "Burger violet"
	desc = "Bourgeoisie et prolétariat en même temps."
	icon_state = "cburger"
	color = COLOR_PURPLE
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/colorful_reagent/powder/purple = 10,
	)
	tastes = list("d'un petit pain" = 2, "de violet" = 2)
	foodtypes = GRAIN | MEAT

/obj/item/food/burger/black
	name = "Burger noir"
	desc = "C'est trop cuit."
	icon_state = "cburger"
	color = COLOR_ALMOST_BLACK
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/colorful_reagent/powder/black = 10,
	)
	tastes = list("d'un petit pain" = 2, "de noir" = 2)
	foodtypes = GRAIN | MEAT

/obj/item/food/burger/white
	name = "Burger blanc"
	desc = "Quel délicieux titane !"
	icon_state = "cburger"
	color = COLOR_WHITE
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/colorful_reagent/powder/white = 10,
	)
	tastes = list("d'un petit pain" = 2, "de blanc" = 2)
	foodtypes = GRAIN | MEAT

/obj/item/food/burger/spell
	name = "Burger magique"
	desc = "C'est absolument Ei Nath."
	icon_state = "spellburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("d'un petit pain" = 4, "de magie" = 2)
	foodtypes = GRAIN | MEAT
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/burger/bigbite
	name = "Burger pour grand nom"
	desc = "Oubliez le Big Mac. CECI est le futur !"
	icon_state = "bigbiteburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("d'un petit pain" = 2, "de viande" = 10)
	w_class = WEIGHT_CLASS_NORMAL
	foodtypes = GRAIN | MEAT | DAIRY
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/burger/jelly
	name = "Burger à la gelée"
	desc = "Un régal culinaire... ?"
	icon_state = "jellyburger"
	tastes = list("d'un petit pain" = 4, "de gelée" = 2)
	foodtypes = GRAIN | MEAT
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/burger/jelly/slime
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/toxin/slimejelly = 6,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	foodtypes = GRAIN | TOXIC

/obj/item/food/burger/jelly/cherry
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/cherryjelly = 6,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	foodtypes = GRAIN | FRUIT

/obj/item/food/burger/superbite
	name = "Burger pour super nom"
	desc = "C'est une montagne de burger. MANGER !"
	icon_state = "superbiteburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 26,
		/datum/reagent/consumable/nutriment/protein = 40,
		/datum/reagent/consumable/nutriment/vitamin = 13,
	)
	w_class = WEIGHT_CLASS_NORMAL
	bite_consumption = 7
	max_volume = 100
	tastes = list("d'un petit pain" = 4, "de diabètes de type 2" = 10)
	foodtypes = GRAIN | MEAT | DAIRY
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/burger/superbite/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] commence à engouffrer [src] en une seule bouchée, on dirait que [user.p_theyre()] essaye de se suicider !"))
	var/datum/component/edible/component = GetComponent(/datum/component/edible)
	component?.TakeBite(user, user)
	return OXYLOSS

/obj/item/food/burger/fivealarm
	name = "Burger à cinq alarmes"
	desc = "CHAUD ! CHAUD !"
	icon_state = "fivealarmburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/capsaicin = 5,
		/datum/reagent/consumable/condensedcapsaicin = 5,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("d'une chaleur extrême" = 4, "d'un petit pain" = 2)
	foodtypes = GRAIN | MEAT
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/burger/rat
	name = "Burger à la souris"
	desc = "Ça correspond à vos attentes..."
	icon_state = "ratburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de souris mortes" = 4, "d'un petit pain" = 2)
	foodtypes = GRAIN | MEAT | GORE
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/burger/baseball
	name = "Burger 'home run'"
	desc = "C'est toujours chaud. La vapeur qui en provient ressemble à une balle de baseball."
	icon_state = "baseball"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("d'un petit pain" = 2, "d'home run" = 4)
	foodtypes = GRAIN | GROSS
	custom_price = PAYCHECK_CREW * 0.8
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/burger/baconburger
	name = "Burger au bacon"
	desc = "La combinaison parfaite entre toutes les choses américaines."
	icon_state = "baconburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de bacon" = 4, "d'un petit pain" = 2)
	foodtypes = GRAIN | MEAT
	custom_premium_price = PAYCHECK_CREW * 1.6
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/burger/empoweredburger
	name = "Burger puissant"
	desc = "C'est incroyablement bon, enfin, seulement si vous survivez à la dose d'électricité."
	icon_state = "empoweredburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/liquidelectricity/enriched = 6,
	)
	tastes = list("d'un petit pain" = 2, "d'électricié pûre" = 4)
	foodtypes = GRAIN | TOXIC
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/burger/catburger
	name = "Burger au minou"
	desc = "Finalement les chats valent quelque chose !"
	icon_state = "catburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("d'un petit pain" = 4, "de viande" = 2, "de chat" = 2)
	foodtypes = GRAIN | MEAT | GORE

/obj/item/food/burger/crab
	name = "Burger au crab"
	desc = "Une délicieuse galette de crabe, coincée dans un petit pain ."
	icon_state = "crabburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("d'un petit pain" = 2, "de crabe" = 4)
	foodtypes = GRAIN | SEAFOOD
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/burger/soylent
	name = "Burger Soylent"
	desc = "Un burger écologique fabriqué à partir de biomasse recyclée de faible valeur."
	icon_state = "soylentburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("d'un petit pain" = 2, "d'assistant" = 4)
	foodtypes = GRAIN | MEAT | DAIRY
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/burger/rib
	name = "MacRib"
	desc = "Un burger insaisissable en forme de côte en édition limitée à travers la galaxy. Pas aussi bon que dans vos souvenirs."
	icon_state = "mcrib"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/bbqsauce = 1,
		)
	tastes = list("d'un petit pain" = 2, "de porc" = 4)
	foodtypes = GRAIN | MEAT
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/burger/mcguffin
	name = "MacGuffin"
	desc = "Une imitation des oeufs bénédictes en pas cher et en gras."
	icon_state = "mcguffin"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/eggyolk = 3,
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de muffin" = 2, "de bacon" = 3)
	foodtypes = GRAIN | MEAT | BREAKFAST
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/burger/chicken
	name = "Burger au poulet" //Apparently the proud people of Americlapstan object to this thing being called a burger. Apparently McDonald's just calls it a burger in Europe as to not scare and confuse us. Mise à jour : On est dans la section burger, les gars
	desc = "Un délicieux burger au poulet, il est dit que les revenus générés par ce plaisir aident à désarmer les gens à la frontière de l'espace."
	icon_state = "chickenburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/mayonnaise = 3,
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/cooking_oil = 2,
	)
	tastes = list("d'un petit pain" = 2, "de poulet" = 4, "de gendarme" = 1)
	foodtypes = GRAIN | MEAT | FRIED
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/burger/cheese
	name = "Cheeseburger"
	desc = "Ce noble burger se dresse fièrement dans son habit de fromage doré."
	icon_state = "cheeseburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("d'un petit pain" = 2, "de steak haché" = 4, "de fromage" = 3)
	foodtypes = GRAIN | MEAT | DAIRY
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/burger/cheese/Initialize(mapload)
	. = ..()
	if(prob(33))
		icon_state = "cheeseburgeralt"

/obj/item/food/burger/crazy
	name = "Burger foufou"
	desc = "Cela ressemble à une nourriture qu'un clown en trench-coat ferait."
	icon_state = "crazyburger"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/capsaicin = 3,
		/datum/reagent/consumable/condensedcapsaicin = 3,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("d'un petit pain" = 2, "de steak haché" = 4, "de fromage" = 2, "de boeuf mariné au piment" = 3, "d'une fusée éclairante allumée" = 2)
	foodtypes = GRAIN | MEAT | DAIRY

/obj/item/food/burger/crazy/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/food/burger/crazy/process(seconds_per_tick) // DIT EES HORRIBLE
	if(SPT_PROB(2.5, seconds_per_tick))
		var/datum/effect_system/fluid_spread/smoke/bad/green/smoke = new
		smoke.set_up(0, holder = src, location = src)
		smoke.start()

// empty burger you can customize
/obj/item/food/burger/empty
	name = "Burger"
	desc = "Un burger de fous fait par un cuisinier malade."
	icon_state = "custburg"
	tastes = list("d'un petit pain")
	foodtypes = GRAIN
