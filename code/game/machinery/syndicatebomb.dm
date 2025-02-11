#define BUTTON_COOLDOWN 60 // cant delay the bomb forever
#define BUTTON_DELAY 50 //five seconds

/obj/machinery/syndicatebomb
	icon = 'icons/obj/assemblies/assemblies.dmi'
	name = "bombe du syndicat"
	icon_state = "syndicate-bomb"
	desc = "Une bombe large et menaçante. Peut être fixée avec une clé à molette."

	anchored = FALSE
	density = FALSE
	layer = BELOW_MOB_LAYER //so people can't hide it and it's REALLY OBVIOUS
	resistance_flags = FIRE_PROOF | ACID_PROOF
	processing_flags = START_PROCESSING_MANUALLY
	subsystem_type = /datum/controller/subsystem/processing/fastprocess
	interaction_flags_machine = INTERACT_MACHINE_WIRES_IF_OPEN | INTERACT_MACHINE_OFFLINE
	use_power = NO_POWER_USE

	/// What is the lowest amount of time we can set the timer to?
	var/minimum_timer = SYNDIEBOMB_MIN_TIMER_SECONDS
	/// What is the highest amount of time we can set the timer to?
	var/maximum_timer = 100 MINUTES
	/// What is the default amount of time we set the timer to?
	var/timer_set = SYNDIEBOMB_MIN_TIMER_SECONDS
	/// Can we be unanchored?
	var/can_unanchor = TRUE
	/// Are the wires exposed?
	var/open_panel = FALSE
	/// Is the bomb counting down?
	var/active = FALSE
	/// What sound do we make as we beep down the timer?
	var/beepsound = 'sound/items/timer.ogg'
	/// Is the delay wire pulsed?
	var/delayedbig = FALSE
	/// Is the activation wire pulsed?
	var/delayedlittle = FALSE
	/// Should we just tell the payload to explode now? Usually triggered by an event (like cutting the wrong wire)
	var/explode_now = FALSE
	/// The timer for the bomb.
	var/detonation_timer
	/// When do we beep next?
	var/next_beep
	/// Reference to the bomb core inside the bomb, which is the part that actually explodes.
	var/obj/item/bombcore/payload = /obj/item/bombcore/syndicate
	/// The countdown that'll show up to ghosts regarding the bomb's timer.
	var/obj/effect/countdown/syndicatebomb/countdown
	/// Whether the countdown is visible on examine
	var/examinable_countdown = TRUE

/obj/machinery/syndicatebomb/proc/try_detonate(ignore_active = FALSE)
	. = (payload in src) && (active || ignore_active)
	if(.)
		payload.detonate()

/obj/machinery/syndicatebomb/atom_break()
	if(!try_detonate())
		..()

/obj/machinery/syndicatebomb/atom_destruction()
	if(!try_detonate())
		..()

/obj/machinery/syndicatebomb/ex_act(severity, target)
	return

/obj/machinery/syndicatebomb/process()
	if(!active)
		end_processing()
		detonation_timer = null
		next_beep = null
		countdown.stop()
		if(payload in src)
			payload.defuse()
		return

	if(!isnull(next_beep) && (next_beep <= world.time))
		var/volume
		switch(seconds_remaining())
			if(0 to 5)
				volume = 50
			if(5 to 10)
				volume = 40
			if(10 to 15)
				volume = 30
			if(15 to 20)
				volume = 20
			if(20 to 25)
				volume = 10
			else
				volume = 5
		playsound(loc, beepsound, volume, FALSE)
		next_beep = world.time + 10

	if(active && ((detonation_timer <= world.time) || explode_now))
		active = FALSE
		timer_set = initial(timer_set)
		update_appearance()
		try_detonate(TRUE)

/obj/machinery/syndicatebomb/Initialize(mapload)
	. = ..()
	wires = new /datum/wires/syndicatebomb(src)
	if(payload)
		payload = new payload(src)
	update_appearance()
	countdown = new(src)
	end_processing()

/obj/machinery/syndicatebomb/Destroy()
	QDEL_NULL(wires)
	QDEL_NULL(countdown)
	end_processing()
	return ..()

/obj/machinery/syndicatebomb/examine(mob/user)
	. = ..()
	. += "L'extérieur de la bombe est résistant à la compression explosive, protégeant le coeur de la bombe d'une détonation prématurée."
	if(istype(payload))
		. += "Une petite fenêtre permet de voir la charge explosive : [payload.desc]."
	if(examinable_countdown)
		. += span_notice("Un écran digital affiche \"[seconds_remaining()]\".")
		if(active)
			balloon_alert(user, "[seconds_remaining()]")
	else
		. += span_notice({"L'écran digital est inactif."})

/obj/machinery/syndicatebomb/update_icon_state()
	icon_state = "[initial(icon_state)][active ? "-active" : "-inactive"][open_panel ? "-wires" : ""]"
	return ..()

/obj/machinery/syndicatebomb/proc/seconds_remaining()
	if(active)
		. = max(0, round((detonation_timer - world.time) / 10))

	else
		. = timer_set

/obj/machinery/syndicatebomb/wrench_act(mob/living/user, obj/item/tool)
	if(!can_unanchor)
		return FALSE
	if(!anchored)
		if(!isturf(loc) || isspaceturf(loc))
			to_chat(user, span_notice("La bombe doit être placée sur un sol solide pour être fixée."))
		else
			to_chat(user, span_notice("Vous attachez fermement la bombe au sol."))
			tool.play_tool_sound(src)
			set_anchored(TRUE)
			if(active)
				to_chat(user, span_notice("Les verrous se vérouillent."))
	else
		if(!active)
			to_chat(user, span_notice("Vous dévissez la bombe du sol."))
			tool.play_tool_sound(src)
			set_anchored(FALSE)
		else
			to_chat(user, span_warning("Les verrous sont bloqués !"))

	return TRUE

/obj/machinery/syndicatebomb/screwdriver_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src, 50)
	open_panel = !open_panel
	update_appearance()
	to_chat(user, span_notice("Vous [open_panel ? "ouvrez" : "fermez"] la trappe d'accès au fils."))
	return TRUE

/obj/machinery/syndicatebomb/crowbar_act(mob/living/user, obj/item/tool)
	. = TRUE
	if(open_panel && wires.is_all_cut())
		if(payload)
			tool.play_tool_sound(src, 25) // sshhh
			to_chat(user, span_notice("Vous sortez avec délicatesse [payload]."))
			payload.forceMove(drop_location())
			payload = null
		else
			to_chat(user, span_warning("Il n'y a rien a retirer !"))
	else if (open_panel)
		to_chat(user, span_warning("Les fils connectant la coque aux explosifs les maintiennent en place !"))
	else
		to_chat(user, span_warning("La trappe est vissée, elle ne s'ouvrira pas !"))

/obj/machinery/syndicatebomb/welder_act(mob/living/user, obj/item/tool)
	if(payload || !wires.is_all_cut() || !open_panel)
		return FALSE

	if(!tool.tool_start_check(user, amount=5))  //uses up 5 fuel
		return TRUE

	to_chat(user, span_notice("Vous commencez à trancher [src]..."))
	if(tool.use_tool(src, user, 20, volume=50, amount=5)) // uses up 5 fuel
		to_chat(user, span_notice("Vous tranchez [src]."))
		new /obj/item/stack/sheet/plasteel(loc, 5)
		qdel(src)
	return TRUE


/obj/machinery/syndicatebomb/attackby(obj/item/I, mob/user, params)

	if(is_wire_tool(I) && open_panel)
		wires.interact(user)

	else if(istype(I, /obj/item/bombcore))
		if(!payload)
			if(!user.transferItemToLoc(I, src))
				return
			payload = I
			to_chat(user, span_notice("Vous placez [payload] dans [src]."))
		else
			to_chat(user, span_warning("[payload] est déja chargé dans [src] ! Vous devez le retirer en premier."))
	else
		var/old_integ = atom_integrity
		. = ..()
		if((old_integ > atom_integrity) && active && (payload in src))
			to_chat(user, span_warning("Cela semble être une très mauvaise idée..."))

/obj/machinery/syndicatebomb/interact(mob/user)
	wires.interact(user)
	if(!open_panel)
		if(!active)
			settings(user)
		else if(anchored)
			to_chat(user, span_warning("La bombe est active et fixée au sol !"))

/obj/machinery/syndicatebomb/proc/activate()
	active = TRUE
	begin_processing()
	countdown.start()
	next_beep = world.time + 10
	detonation_timer = world.time + (timer_set * 10)
	playsound(loc, 'sound/machines/click.ogg', 30, TRUE)
	update_appearance()

/obj/machinery/syndicatebomb/proc/settings(mob/user)
	if(!user.can_perform_action(src, ALLOW_SILICON_REACH) || !user.can_interact_with(src))
		return
	var/new_timer = tgui_input_number(user, "Définir le minuteur", "Décompte", timer_set, maximum_timer, minimum_timer)
	if(!new_timer || QDELETED(user) || QDELETED(src) || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return
	timer_set = new_timer
	loc.visible_message(span_notice("[icon2html(src, viewers(src))] décompte définit à [timer_set] secondes."))
	var/choice = tgui_alert(user, "Voulez-vous activer le décompte ?", "Minuteur de la bombe", list("Oui","Non"))
	if(choice != "Oui")
		return
	if(active)
		to_chat(user, span_warning("Le minuteur est déjà actif !"))
		return
	visible_message(span_danger("[icon2html(src, viewers(loc))] [timer_set] secondes avant l'explosion, veuillez évacuer la zone."))
	activate()
	add_fingerprint(user)
	// We don't really concern ourselves with duds or fakes after this
	if(isnull(payload) || istype(payload, /obj/machinery/syndicatebomb/training))
		return

	notify_ghosts("\A [src] a été activé à [get_area(src)]!", source = src, action = NOTIFY_ORBIT, flashwindow = FALSE, header = "Bomb Planted")
	user.add_mob_memory(/datum/memory/bomb_planted/syndicate, antagonist = src)
	log_bomber(user, "has primed a", src, "for detonation (Payload: [payload.name])")
	payload.adminlog = "The [name] that [key_name(user)] had primed detonated!"
	user.log_message("primed the [src]. (Payload: [payload.name])", LOG_GAME, log_globally = FALSE)

///Bomb Subtypes///

/obj/machinery/syndicatebomb/training
	name = "bombe d'entrainement"
	icon_state = "training-bomb"
	desc = "Une bombe du syndicat récupérée et vidée de ses explosifs pour être utilisée comme un outil d'entraînement pour les futurs désamorceurs de bombes."
	payload = /obj/item/bombcore/training

/obj/machinery/syndicatebomb/emp
	name = "bombe IEM"
	desc = "Une bombe modifiée pour libérer une impulsion électromagnétique paralysant l'éléctronique."
	payload = /obj/item/bombcore/emp

/obj/machinery/syndicatebomb/badmin
	name = "generic summoning badmin bomb"
	desc = "Oh god what is in this thing?"
	payload = /obj/item/bombcore/badmin/summon

/obj/machinery/syndicatebomb/badmin/clown
	name = "clown bomb"
	icon_state = "clown-bomb"
	desc = "HONK."
	payload = /obj/item/bombcore/badmin/summon/clown
	beepsound = 'sound/items/bikehorn.ogg'

/obj/machinery/syndicatebomb/empty
	name = "bombe"
	icon_state = "base-bomb"
	desc = "Une bombe créé pour exploser une charge explosive. Elle peut être vissée avec une clée à molette."
	payload = null
	open_panel = TRUE
	timer_set = 120

/obj/machinery/syndicatebomb/empty/Initialize(mapload)
	. = ..()
	wires.cut_all()

/obj/machinery/syndicatebomb/self_destruct
	name = "bombe auto-destructrice"
	desc = "Ne pas énerver. Garantie annulée si exposée à des températures élevées. Ne convient pas aux agents de moins de 3 ans."
	payload = /obj/item/bombcore/syndicate/large
	can_unanchor = FALSE

///Bomb Cores///

/obj/item/bombcore
	name = "charge explosive"
	desc = "Une charge explosive secondaire de conception syndicale et de composition inconnue, elle devrait être stable dans des conditions normales..."
	icon = 'icons/obj/assemblies/assemblies.dmi'
	icon_state = "bombcore"
	inhand_icon_state = "eshield"
	lefthand_file = 'icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/shields_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1 // We detonate upon being exploded.
	resistance_flags = FLAMMABLE //Burnable (but the casing isn't)
	var/adminlog = null
	var/range_heavy = 3
	var/range_medium = 9
	var/range_light = 17
	var/range_flame = 17

/obj/item/bombcore/ex_act(severity, target) // Little boom can chain a big boom.
	detonate()

/obj/item/bombcore/burn()
	detonate()
	..()

/obj/item/bombcore/proc/detonate()
	if(adminlog)
		message_admins(adminlog)
		log_game(adminlog)
	explosion(src, range_heavy, range_medium, range_light, range_flame)
	if(loc && istype(loc, /obj/machinery/syndicatebomb/))
		qdel(loc)
	qdel(src)

/obj/item/bombcore/proc/defuse()
//Note: the machine's defusal is mostly done from the wires code, this is here if you want the core itself to do anything.

///Bomb Core Subtypes///

/// Subtype for the bomb cores found inside syndicate bombs, which will not detonate due to explosion/burning.
/obj/item/bombcore/syndicate
	name = "Donk Co. Super-Stable Bomb Payload"
	desc = "After a string of unwanted detonations, this payload has been specifically redesigned to not explode unless triggered electronically by a bomb shell."

/obj/item/bombcore/syndicate/ex_act(severity, target)
	return

/obj/item/bombcore/syndicate/burn()
	return ..()

/obj/item/bombcore/syndicate/large
	name = "Donk Co. Super-Stable Bomb Payload XL"
	range_heavy = 5
	range_medium = 10
	range_light = 20
	range_flame = 20

/obj/item/bombcore/training
	name = "Fausse charge explosive"
	desc = "Une réplique de charge explosive du syndicat conçue par Nanotrasen. Elle n'est pas destinée à exploser, mais à annoncer qu'elle aurait explosé, puis à se réarmer pour permettre plus d'entraînement."
	var/defusals = 0
	var/attempts = 0

/obj/item/bombcore/training/proc/reset()
	var/obj/machinery/syndicatebomb/holder = loc
	if(istype(holder))
		if(holder.wires)
			holder.wires.repair()
			holder.wires.shuffle_wires()
		holder.delayedbig = FALSE
		holder.delayedlittle = FALSE
		holder.explode_now = FALSE
		holder.update_appearance()
		STOP_PROCESSING(SSfastprocess, holder)

/obj/item/bombcore/training/detonate()
	var/obj/machinery/syndicatebomb/holder = loc
	if(istype(holder))
		attempts++
		holder.loc.visible_message(span_danger("[icon2html(holder, viewers(holder))] Alerte : La bombe a explosée. Votre score est maintenant [defusals] pour [attempts] ! Réinisialisation des fils dans 5 secondes..."))
		reset()
	else
		qdel(src)

/obj/item/bombcore/training/defuse()
	var/obj/machinery/syndicatebomb/holder = loc
	if(istype(holder))
		attempts++
		defusals++
		holder.loc.visible_message(span_notice("[icon2html(holder, viewers(holder))] Alerte : La bombe a été désarmée. Votre score est maintenant [defusals] pour [attempts] ! Réinisialisation des fils dans 5 secondes..."))
		sleep(5 SECONDS) //Just in case someone is trying to remove the bomb core this gives them a little window to crowbar it out
		if(istype(holder))
			reset()

/obj/item/bombcore/badmin
	name = "badmin payload"
	desc = "If you're seeing this someone has either made a mistake or gotten dangerously savvy with var editing!"

/obj/item/bombcore/badmin/defuse() //because we wouldn't want them being harvested by players
	var/obj/machinery/syndicatebomb/B = loc
	qdel(B)
	qdel(src)

/obj/item/bombcore/badmin/summon
	var/summon_path = /obj/item/food/cookie
	var/amt_summon = 1

/obj/item/bombcore/badmin/summon/detonate()
	var/obj/machinery/syndicatebomb/B = loc
	spawn_and_random_walk(summon_path, src, amt_summon, walk_chance=50, admin_spawn=TRUE)
	qdel(B)
	qdel(src)

/obj/item/bombcore/badmin/summon/clown
	summon_path = /mob/living/simple_animal/hostile/retaliate/clown
	amt_summon = 50

/obj/item/bombcore/badmin/summon/clown/defuse()
	playsound(src, 'sound/misc/sadtrombone.ogg', 50)
	..()

/obj/item/bombcore/large
	name = "charge explosive XL"
	range_heavy = 5
	range_medium = 10
	range_light = 20
	range_flame = 20

/obj/item/bombcore/miniature
	name = "petite charge explosive"
	w_class = WEIGHT_CLASS_SMALL
	range_heavy = 1
	range_medium = 2
	range_light = 4
	range_flame = 2

/obj/item/bombcore/chemical
	name = "charge explosive chimique"
	desc = "Une charge explosive conçue pour répandre des produits chimiques, dangereux ou non, sur une grande surface. Les propriétés de la charge peuvent varier en fonction du type de grenade, et doivent être chargées avant utilisation."
	icon_state = "chemcore"
	/// The initial volume of the reagent holder the bombcore has.
	var/core_holder_volume = 1000
	/// The set of beakers that have been inserted into the bombcore.
	var/list/beakers = list()
	/// The maximum number of beakers that this bombcore can have.
	var/max_beakers = 1 // Read on about grenade casing properties below
	/// The range this spreads the reagents added to the bombcore.
	var/spread_range = 5
	/// How much this heats the reagents in it on detonation.
	var/temp_boost = 50
	/// The amount of reagents released with each detonation.
	var/time_release = 0

/obj/item/bombcore/chemical/Initialize(mapload)
	. = ..()
	create_reagents(core_holder_volume)

/obj/item/bombcore/chemical/detonate()

	if(time_release > 0)
		var/total_volume = reagents.total_volume
		for(var/obj/item/reagent_containers/RC in beakers)
			total_volume += RC.reagents.total_volume

		if(total_volume < time_release) // If it's empty, the detonation is complete.
			if(loc && istype(loc, /obj/machinery/syndicatebomb/))
				qdel(loc)
			qdel(src)
			return

		var/fraction = time_release/total_volume
		var/datum/reagents/reactants = new(time_release)
		reactants.my_atom = src
		for(var/obj/item/reagent_containers/RC in beakers)
			RC.reagents.trans_to(reactants, RC.reagents.total_volume*fraction, 1, 1, 1)
		chem_splash(get_turf(src), reagents, spread_range, list(reactants), temp_boost)

		// Detonate it again in one second, until it's out of juice.
		addtimer(CALLBACK(src, PROC_REF(detonate)), 10)

	// If it's not a time release bomb, do normal explosion

	var/list/reactants = list()

	for(var/obj/item/reagent_containers/cup/G in beakers)
		reactants += G.reagents

	for(var/obj/item/slime_extract/S in beakers)
		if(S.Uses)
			for(var/obj/item/reagent_containers/cup/G in beakers)
				G.reagents.trans_to(S, G.reagents.total_volume)

			if(S && S.reagents && S.reagents.total_volume)
				reactants += S.reagents

	if(!chem_splash(get_turf(src), reagents, spread_range, reactants, temp_boost))
		playsound(loc, 'sound/items/screwdriver2.ogg', 50, TRUE)
		return // The Explosion didn't do anything. No need to log, or disappear.

	if(adminlog)
		message_admins(adminlog)
		log_game(adminlog)

	playsound(loc, 'sound/effects/bamf.ogg', 75, TRUE, 5)

/obj/item/bombcore/chemical/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_CROWBAR && beakers.len > 0)
		I.play_tool_sound(src)
		for (var/obj/item/B in beakers)
			B.forceMove(drop_location())
			beakers -= B
		return
	else if(istype(I, /obj/item/reagent_containers/cup/beaker) || istype(I, /obj/item/reagent_containers/cup/bottle))
		if(beakers.len < max_beakers)
			if(!user.transferItemToLoc(I, src))
				return
			beakers += I
			to_chat(user, span_notice("You load [src] with [I]."))
		else
			to_chat(user, span_warning("[I] ne rentrera pas ! [src] ne peut que contenir que [max_beakers] bécher."))
			return
	..()

/obj/item/bombcore/chemical/CheckParts(list/parts_list)
	..()
	// Using different grenade casings, causes the payload to have different properties.
	var/obj/item/stock_parts/matter_bin/MB = locate(/obj/item/stock_parts/matter_bin) in src
	if(MB)
		max_beakers += MB.rating // max beakers = 2-5.
		qdel(MB)
	for(var/obj/item/grenade/chem_grenade/G in src)

		if(istype(G, /obj/item/grenade/chem_grenade/large))
			var/obj/item/grenade/chem_grenade/large/LG = G
			max_beakers += 1 // Adding two large grenades only allows for a maximum of 7 beakers.
			spread_range += 2 // Extra range, reduced density.
			temp_boost += 50 // maximum of +150K blast using only large beakers. Not enough to self ignite.
			for(var/obj/item/slime_extract/S in LG.beakers) // And slime cores.
				if(beakers.len < max_beakers)
					beakers += S
					S.forceMove(src)
				else
					S.forceMove(drop_location())

		if(istype(G, /obj/item/grenade/chem_grenade/cryo))
			spread_range -= 1 // Reduced range, but increased density.
			temp_boost -= 100 // minimum of -150K blast.

		if(istype(G, /obj/item/grenade/chem_grenade/pyro))
			temp_boost += 150 // maximum of +350K blast, which is enough to self ignite. Which means a self igniting bomb can't take advantage of other grenade casing properties. Sorry?

		if(istype(G, /obj/item/grenade/chem_grenade/adv_release))
			time_release += 50 // A typical bomb, using basic beakers, will explode over 2-4 seconds. Using two will make the reaction last for less time, but it will be more dangerous overall.

		for(var/obj/item/reagent_containers/cup/B in G)
			if(beakers.len < max_beakers)
				beakers += B
				B.forceMove(src)
			else
				B.forceMove(drop_location())

		qdel(G)

/obj/item/bombcore/emp
	name = "charge explosive IEM"
	desc = "Un groupe de bobines électromagnétiques supraconductrices conçues pour libérer une impulsion puissante pour détruire les électroniques et brouiller les circuits."
	range_heavy = 15
	range_medium = 25

/obj/item/bombcore/emp/detonate()
	if(adminlog)
		message_admins(adminlog)
		log_game(adminlog)

	empulse(src, range_heavy, range_medium)

	qdel(src)

///Syndicate Detonator (aka the big red button)///

/obj/item/syndicatedetonator
	name = "gros bouton rouge"
	desc = "Ce boutton est utilisé pour déclencher les bombes du syndicat. Il y a un délai de sécurité de cinq secondes pour éviter les \"accidents\"."
	icon = 'icons/obj/assemblies/assemblies.dmi'
	icon_state = "bigred"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/timer = 0
	var/detonated = 0
	var/existent = 0

/obj/item/syndicatedetonator/attack_self(mob/user)
	if(timer < world.time)
		for(var/obj/machinery/syndicatebomb/B in GLOB.machines)
			if(B.active)
				B.detonation_timer = world.time + BUTTON_DELAY
				detonated++
			existent++
		playsound(user, 'sound/machines/click.ogg', 20, TRUE)
		to_chat(user, span_notice("[existent] found, [detonated] triggered."))
		if(detonated)
			detonated--
			log_bomber(user, "remotely detonated [detonated ? "syndicate bombs" : "a syndicate bomb"] using a", src)
		detonated = 0
		existent = 0
		timer = world.time + BUTTON_COOLDOWN



#undef BUTTON_COOLDOWN
#undef BUTTON_DELAY
