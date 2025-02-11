/// One of the potential shuttle loans you might recieve.
/datum/shuttle_loan_situation
	/// Who sent the shuttle
	var/sender = "Centcom"
	/// What they said about it.
	var/announcement_text = "Unset announcement text"
	/// What the shuttle says about it.
	var/shuttle_transit_text = "Unset transit text"
	/// Supply points earned for taking the deal.
	var/bonus_points = 10000
	/// Response for taking the deal.
	var/thanks_msg = "Votre navette cargo devrait revenir d'ici 5 minutes. Des points de livraison supplémentaires vous ont été envoyés en dédommagement."
	/// Small description of the loan for easier log reading.
	var/logging_desc

/datum/shuttle_loan_situation/New()
	. = ..()
	if(!logging_desc)
		stack_trace("No logging blurb set for [src.type]!")

/// Spawns paths added to `spawn_list`, and passes empty shuttle turfs so you can spawn more complicated things like dead bodies.
/datum/shuttle_loan_situation/proc/spawn_items(list/spawn_list, list/empty_shuttle_turfs)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Unimplemented get_spawned_items() on [src.type].")

/datum/shuttle_loan_situation/antidote
	sender = "Initiative de recherche de CentCom"
	announcement_text = "Votre station a été choisie pour un projet de recherche épidémiologique. Envoyez nous votre navette de cargo pour recevoir des échantillons de recherche."
	shuttle_transit_text = "Échantillons de virus en approche."
	logging_desc = "Virus shuttle"

/datum/shuttle_loan_situation/antidote/spawn_items(list/spawn_list, list/empty_shuttle_turfs)
	var/obj/effect/mob_spawn/corpse/human/assistant/infected_assistant = pick(list(
		/obj/effect/mob_spawn/corpse/human/assistant/beesease_infection,
		/obj/effect/mob_spawn/corpse/human/assistant/brainrot_infection,
		/obj/effect/mob_spawn/corpse/human/assistant/spanishflu_infection,
	))
	for(var/i in 1 to 10)
		if(prob(15))
			spawn_list.Add(/obj/item/reagent_containers/cup/bottle)
		else if(prob(15))
			spawn_list.Add(/obj/item/reagent_containers/syringe)
		else if(prob(25))
			spawn_list.Add(/obj/item/shard)
		var/turf/assistant_turf = pick_n_take(empty_shuttle_turfs)
		new infected_assistant(assistant_turf)
	spawn_list.Add(/obj/structure/closet/crate)
	spawn_list.Add(/obj/item/reagent_containers/cup/bottle/pierrot_throat)
	spawn_list.Add(/obj/item/reagent_containers/cup/bottle/magnitis)

/datum/shuttle_loan_situation/department_resupply
	sender = "Département logistique de CentCom"
	announcement_text = "On dirait qu'on nous a envoyé le double de notre ravitaillement départemental de ce mois-ci. Est-ce qu'on peut vous envoyer les doublons ?"
	shuttle_transit_text = "Ravitaillement doublon en approche."
	thanks_msg = "Votre navette cargo devrait revenir d'ici 5 minutes."
	bonus_points = 0
	logging_desc = "Resupply packages"

/datum/shuttle_loan_situation/department_resupply/spawn_items(list/spawn_list, list/empty_shuttle_turfs)
	var/list/crate_types = list(
		/datum/supply_pack/emergency/equipment,
		/datum/supply_pack/security/supplies,
		/datum/supply_pack/organic/food,
		/datum/supply_pack/emergency/weedcontrol,
		/datum/supply_pack/engineering/tools,
		/datum/supply_pack/engineering/engiequipment,
		/datum/supply_pack/science/robotics,
		/datum/supply_pack/science/plasma,
		/datum/supply_pack/medical/supplies
		)
	for(var/crate in crate_types)
		var/datum/supply_pack/pack = SSshuttle.supply_packs[crate]
		pack.generate(pick_n_take(empty_shuttle_turfs))

	for(var/i in 1 to 5)
		var/decal = pick(/obj/effect/decal/cleanable/food/flour, /obj/effect/decal/cleanable/robot_debris, /obj/effect/decal/cleanable/oil)
		new decal(pick_n_take(empty_shuttle_turfs))

/datum/shuttle_loan_situation/syndiehijacking
	sender = "Contre-espionnage de CentCom"
	announcement_text = "Le Syndicat essaye d'infiltrer votre station. Si vous les laissez détourner votre navette cargo, vous nous épargerez une migraine."
	shuttle_transit_text = "Équipe d'abordage du Syndicat en approche."
	logging_desc = "Syndicate boarding party"

/datum/shuttle_loan_situation/syndiehijacking/spawn_items(list/spawn_list, list/empty_shuttle_turfs)
	var/datum/supply_pack/pack = SSshuttle.supply_packs[/datum/supply_pack/imports/specialops]
	pack.generate(pick_n_take(empty_shuttle_turfs))

	spawn_list.Add(/mob/living/basic/syndicate/ranged/infiltrator)
	spawn_list.Add(/mob/living/basic/syndicate/ranged/infiltrator)
	if(prob(75))
		spawn_list.Add(/mob/living/basic/syndicate/ranged/infiltrator)
	if(prob(50))
		spawn_list.Add(/mob/living/basic/syndicate/ranged/infiltrator)

/datum/shuttle_loan_situation/lots_of_bees
	sender = "Division conciergerie de CentCom"
	announcement_text = "Une de nos navettes cargo transportant une cargaison d'abeille a été attaquée par des éco-terroristes. Vous pouvez nettoyer le bordel pour nous ?"
	shuttle_transit_text = "Navette à nettoyer en approche."
	bonus_points = 20000 //Toxin bees can be unbeelievably lethal
	logging_desc = "Shuttle full of bees"

/datum/shuttle_loan_situation/lots_of_bees/spawn_items(list/spawn_list, list/empty_shuttle_turfs)
	var/datum/supply_pack/pack = SSshuttle.supply_packs[/datum/supply_pack/organic/hydroponics/beekeeping_fullkit]
	pack.generate(pick_n_take(empty_shuttle_turfs))

	spawn_list.Add(/obj/effect/mob_spawn/corpse/human/bee_terrorist)
	spawn_list.Add(/obj/effect/mob_spawn/corpse/human/cargo_tech)
	spawn_list.Add(/obj/effect/mob_spawn/corpse/human/cargo_tech)
	spawn_list.Add(/obj/effect/mob_spawn/corpse/human/nanotrasensoldier)
	spawn_list.Add(/obj/item/gun/ballistic/automatic/pistol/no_mag)
	spawn_list.Add(/obj/item/gun/ballistic/automatic/pistol/m1911/no_mag)
	spawn_list.Add(/obj/item/honey_frame)
	spawn_list.Add(/obj/item/honey_frame)
	spawn_list.Add(/obj/item/honey_frame)
	spawn_list.Add(/obj/structure/beebox/unwrenched)
	spawn_list.Add(/obj/item/queen_bee/bought)
	spawn_list.Add(/obj/structure/closet/crate/hydroponics)

	for(var/i in 1 to 8)
		spawn_list.Add(/mob/living/simple_animal/hostile/bee/toxin)

	for(var/i in 1 to 5)
		var/decal = pick(/obj/effect/decal/cleanable/blood, /obj/effect/decal/cleanable/insectguts)
		new decal(pick_n_take(empty_shuttle_turfs))

	for(var/i in 1 to 10)
		var/casing = /obj/item/ammo_casing/spent
		new casing(pick_n_take(empty_shuttle_turfs))

/datum/shuttle_loan_situation/jc_a_bomb
	sender = "Division de sécurité de CentCom"
	announcement_text = "Nous avons découvert une bombe du Syndicat près des lignes de ravitaillement pour navette VIP. Si vous vous sentez à la hauteur, on vous payera pour la désamorcer."
	shuttle_transit_text = "Équipement explosif sous tension en approche. Procédez avec extrême prudence."
	thanks_msg = "Équipement explosif sous tension en approche via votre navette cargo. L'évacuation du département en question est recommandée."
	bonus_points = 45000 //If you mess up, people die and the shuttle gets turned into swiss cheese
	logging_desc = "Shuttle with a ticking bomb"

/datum/shuttle_loan_situation/jc_a_bomb/spawn_items(list/spawn_list, list/empty_shuttle_turfs)
	spawn_list.Add(/obj/machinery/syndicatebomb/shuttle_loan)
	if(prob(95))
		spawn_list.Add(/obj/item/paper/fluff/cargo/bomb)
	else
		spawn_list.Add(/obj/item/paper/fluff/cargo/bomb/allyourbase)

/datum/shuttle_loan_situation/papers_please
	sender = "Division de la paperasse de CentCom"
	announcement_text = "Une station voisine a besoin d'aide pour gérer de la paperasse. Est-ce que vous voulez bien les aider à s'en occuper pour nous ?"
	shuttle_transit_text = "Paperasse en approche."
	thanks_msg = "Votre navette cargo devrait revenir d'ici 5 minutes. Votre payement vous sera transféré dès que la paperasse sera signée et renvoyée."
	bonus_points = 0 //Payout is made when the stamped papers are returned
	logging_desc = "Paperwork shipment"

/datum/shuttle_loan_situation/papers_please/spawn_items(list/spawn_list, list/empty_shuttle_turfs)
	spawn_list += subtypesof(/obj/item/paperwork) - typesof(/obj/item/paperwork/photocopy) - typesof(/obj/item/paperwork/ancient)

/datum/shuttle_loan_situation/pizza_delivery
	sender = "Division alimentation de CentCom"
	announcement_text = "On dirait qu'une station voisine à donné votre adresse à la place la leur, pour leur commande de pizza."
	shuttle_transit_text = "Livraison de pizza en approche !"
	thanks_msg = "Votre navette cargo devrait revenir d'ici 5 minutes."
	bonus_points = 0
	logging_desc = "Pizza delivery"

/datum/shuttle_loan_situation/pizza_delivery/spawn_items(list/spawn_list, list/empty_shuttle_turfs)
	var/naughtypizza = list(/obj/item/pizzabox/bomb, /obj/item/pizzabox/margherita/robo) //oh look another blacklist, for pizza nonetheless!
	var/nicepizza = list(/obj/item/pizzabox/margherita, /obj/item/pizzabox/meat, /obj/item/pizzabox/vegetable, /obj/item/pizzabox/mushroom)
	for(var/i in 1 to 6)
		spawn_list.Add(pick(prob(5) ? naughtypizza : nicepizza))

/datum/shuttle_loan_situation/russian_party
	sender = "Programme de recherche russo-terrien de CentCom"
	announcement_text = "Un groupe de russes en colère veulent faire une fête. Est-ce qu'on peut vous les envoyer pour les faire disparaitre ?"
	shuttle_transit_text = "Russes fêtards en approche."
	logging_desc = "Russian party squad"

/datum/shuttle_loan_situation/russian_party/spawn_items(list/spawn_list, list/empty_shuttle_turfs)
	var/datum/supply_pack/pack = SSshuttle.supply_packs[/datum/supply_pack/service/party]
	pack.generate(pick_n_take(empty_shuttle_turfs))

	spawn_list.Add(/mob/living/basic/syndicate/russian)
	spawn_list.Add(/mob/living/basic/syndicate/russian/ranged) //drops a mateba
	spawn_list.Add(/mob/living/simple_animal/hostile/bear/russian)
	if(prob(75))
		spawn_list.Add(/mob/living/basic/syndicate/russian)
	if(prob(50))
		spawn_list.Add(/mob/living/simple_animal/hostile/bear/russian)

/datum/shuttle_loan_situation/spider_gift
	sender = "Corps diplomatique de CentCom"
	announcement_text = "Le Clan des araignées nous a envoyé un mystérieux cadeau. Est-ce qu'on peut vous l'envoyer pour voir ce qu'il y a dedans ?"
	shuttle_transit_text = "Cadeau du Cland des araignées en approche."
	logging_desc = "Shuttle full of spiders"

/datum/shuttle_loan_situation/spider_gift/spawn_items(list/spawn_list, list/empty_shuttle_turfs)
	var/datum/supply_pack/pack = SSshuttle.supply_packs[/datum/supply_pack/imports/specialops]
	pack.generate(pick_n_take(empty_shuttle_turfs))

	spawn_list.Add(/mob/living/basic/giant_spider)
	spawn_list.Add(/mob/living/basic/giant_spider)
	spawn_list.Add(/mob/living/basic/giant_spider/nurse)
	if(prob(50))
		spawn_list.Add(/mob/living/basic/giant_spider/hunter)

	var/turf/victim_turf = pick_n_take(empty_shuttle_turfs)

	new /obj/effect/decal/remains/human(victim_turf)
	new /obj/item/clothing/shoes/jackboots/fast(victim_turf)
	new /obj/item/clothing/mask/balaclava(victim_turf)

	for(var/i in 1 to 5)
		var/turf/web_turf = pick_n_take(empty_shuttle_turfs)
		new /obj/structure/spider/stickyweb(web_turf)
