//A system to manage and display alerts on screen without needing you to do it yourself

//PUBLIC -  call these wherever you want

/**
 *Proc to create or update an alert. Returns the alert if the alert is new or updated, 0 if it was thrown already
 *category is a text string. Each mob may only have one alert per category; the previous one will be replaced
 *path is a type path of the actual alert type to throw
 *severity is an optional number that will be placed at the end of the icon_state for this alert
 *for example, high pressure's icon_state is "highpressure" and can be serverity 1 or 2 to get "highpressure1" or "highpressure2"
 *new_master is optional and sets the alert's icon state to "template" in the ui_style icons with the master as an overlay.
 *flicks are forwarded to master
 *override makes it so the alert is not replaced until cleared by a clear_alert with clear_override, and it's used for hallucinations.
 */
/mob/proc/throw_alert(category, type, severity, obj/new_master, override = FALSE)

	if(!category || QDELETED(src))
		return

	var/atom/movable/screen/alert/thealert
	if(alerts[category])
		thealert = alerts[category]
		if(thealert.override_alerts)
			return thealert
		if(new_master && new_master != thealert.master)
			WARNING("[src] threw alert [category] with new_master [new_master] while already having that alert with master [thealert.master]")

			clear_alert(category)
			return .()
		else if(thealert.type != type)
			clear_alert(category)
			return .()
		else if(!severity || severity == thealert.severity)
			if(!thealert.timeout)
				// No need to update existing alert
				return thealert
			// Reset timeout of existing alert
			var/timeout = initial(thealert.timeout)
			addtimer(CALLBACK(src, PROC_REF(alert_timeout), thealert, category), timeout)
			thealert.timeout = world.time + timeout - world.tick_lag
			return thealert
	else
		thealert = new type()
		thealert.override_alerts = override
		if(override)
			thealert.timeout = null
	thealert.owner = src

	if(new_master)
		var/old_layer = new_master.layer
		var/old_plane = new_master.plane
		new_master.layer = FLOAT_LAYER
		new_master.plane = FLOAT_PLANE
		thealert.add_overlay(new_master)
		new_master.layer = old_layer
		new_master.plane = old_plane
		thealert.icon_state = "template" // We'll set the icon to the client's ui pref in reorganize_alerts()
		thealert.master = new_master
	else
		thealert.icon_state = "[initial(thealert.icon_state)][severity]"
		thealert.severity = severity

	alerts[category] = thealert
	if(client && hud_used)
		hud_used.reorganize_alerts()
	thealert.transform = matrix(32, 6, MATRIX_TRANSLATE)
	animate(thealert, transform = matrix(), time = 2.5, easing = CUBIC_EASING)

	if(thealert.timeout)
		addtimer(CALLBACK(src, PROC_REF(alert_timeout), thealert, category), thealert.timeout)
		thealert.timeout = world.time + thealert.timeout - world.tick_lag
	return thealert

/mob/proc/alert_timeout(atom/movable/screen/alert/alert, category)
	if(alert.timeout && alerts[category] == alert && world.time >= alert.timeout)
		clear_alert(category)

// Proc to clear an existing alert.
/mob/proc/clear_alert(category, clear_override = FALSE)
	var/atom/movable/screen/alert/alert = alerts[category]
	if(!alert)
		return 0
	if(alert.override_alerts && !clear_override)
		return 0

	alerts -= category
	if(client && hud_used)
		hud_used.reorganize_alerts()
		client.screen -= alert
	qdel(alert)

// Proc to check for an alert
/mob/proc/has_alert(category)
	return !isnull(alerts[category])

/atom/movable/screen/alert
	icon = 'icons/hud/screen_alert.dmi'
	icon_state = "default"
	name = "Alert"
	desc = "Something seems to have gone wrong with this alert, so report this bug please"
	mouse_opacity = MOUSE_OPACITY_ICON
	var/timeout = 0 //If set to a number, this alert will clear itself after that many deciseconds
	var/severity = 0
	var/alerttooltipstyle = ""
	var/override_alerts = FALSE //If it is overriding other alerts of the same type
	var/mob/owner //Alert owner

	/// Boolean. If TRUE, the Click() proc will attempt to Click() on the master first if there is a master.
	var/click_master = TRUE


/atom/movable/screen/alert/MouseEntered(location,control,params)
	. = ..()
	if(!QDELETED(src))
		openToolTip(usr,src,params,title = name,content = desc,theme = alerttooltipstyle)


/atom/movable/screen/alert/MouseExited()
	closeToolTip(usr)


//Gas alerts
// Gas alerts are continuously thrown/cleared by:
// * /obj/item/organ/internal/lungs/proc/check_breath()
// * /mob/living/carbon/check_breath()
// * /mob/living/carbon/human/check_breath()
// * /datum/element/atmos_requirements/proc/on_non_stasis_life()
// * /mob/living/simple_animal/handle_environment()

/atom/movable/screen/alert/not_enough_oxy
	name = "Suffocation (pas d'O2)"
	desc = "Vous ne respirez pas assez d'oxygène ! Trouvez de l'air convenable avant de vous évanouir ! La boite d'urgence dans votre sac à dos à un masque et une bouteille d'oxygène."
	icon_state = ALERT_NOT_ENOUGH_OXYGEN

/atom/movable/screen/alert/too_much_oxy
	name = "Suffocation (trop d'O2)"
	desc = "Il y a trop d'oxygène dans l'air que vous respirez ! Trouvez de l'air convenable avant de vous évanouir ! La boite d'urgence dans votre sac à dos à un masque et une bouteille d'oxygène."
	icon_state = ALERT_TOO_MUCH_OXYGEN

/atom/movable/screen/alert/not_enough_nitro
	name = "Suffocation (Pas de N2)"
	desc = "Vous ne respirez pas assez de nitrogène ! Trouvez de l'air convenable avant de vous évanouir ! La boite d'urgence dans votre sac à dos à un masque et une bouteille d'oxygène"
	icon_state = ALERT_NOT_ENOUGH_NITRO

/atom/movable/screen/alert/too_much_nitro
	name = "Suffocation (trop de N2)"
	desc = "Il y a trop de nitrogène dans l'air que vous respirez ! Trouvez de l'air convenable avant de vous évanouir ! La boite d'urgence dans votre sac à dos à un masque et une bouteille d'oxygène."
	icon_state = ALERT_TOO_MUCH_NITRO

/atom/movable/screen/alert/not_enough_co2
	name = "Suffocation (Pas de CO2)"
	desc = "Vous ne respirez pas assez de dioxyde de carbone ! Trouvez de l'air convenable avant de vous évanouir !"
	icon_state = ALERT_NOT_ENOUGH_CO2

/atom/movable/screen/alert/too_much_co2
	name = "Suffocation (trop de CO2)"
	desc = "Il y a trop de dioxyde de carbone dans l'air que vous respirez ! Trouvez de l'air convenable avant de vous évanouir !"
	icon_state = ALERT_TOO_MUCH_CO2

/atom/movable/screen/alert/not_enough_plas
	name = "Suffocation (Pas de plasma)"
	desc = "Vous ne respirez pas assez de plasma ! Trouvez de l'air convenable avant de vous évanouir ! Il y a une bouteille supplémentaire dans votre sac à dos."
	icon_state = ALERT_NOT_ENOUGH_PLASMA

/atom/movable/screen/alert/too_much_plas
	name = "Suffocation (Plasma)"
	desc = "Il y a du plasma, toxique et extrêmement inflammable, dans l'air que vous respirez ! Trouvez de l'air convenable ! La boite d'urgence dans votre sac à dos à un masque et une bouteille d'oxygène."
	icon_state = ALERT_TOO_MUCH_PLASMA

/atom/movable/screen/alert/not_enough_n2o
	name = "Suffocation (Pas de N2O)"
	desc = "Vous ne respirez pas assez de N2O ! Trouvez de l'air convenable avant de vous évanouir !"
	icon_state = ALERT_NOT_ENOUGH_N2O

/atom/movable/screen/alert/too_much_n2o
	name = "Suffocation (N2O)"
	desc = "Il y a un gaz anesthésiques dans l'air que vous respirez ! Trouvez de l'air convenable ! La boite d'urgence dans votre sac à dos à un masque et une bouteille d'oxygène."
	icon_state = ALERT_TOO_MUCH_N2O

//End gas alerts


/atom/movable/screen/alert/fat
	name = "Trop mangé"
	desc = "Vous avez trop mangé, et du coup vous avez mal au ventre. Courir un peu pourrait vous faire du bien."
	icon_state = "fat"

/atom/movable/screen/alert/hungry
	name = "Faim"
	desc = "Là tout de suite, ça serait cool de manger quelque chose."
	icon_state = "hungry"

/atom/movable/screen/alert/starving
	name = "Affamé.e"
	desc = "Vous avez l'impression de mourir de faim, bouger est douloureux et se concentrer est compliqué."
	icon_state = "starving"

/atom/movable/screen/alert/gross
	name = "Dégouté.e"
	desc = "C'était dégoutant..."
	icon_state = "gross"

/atom/movable/screen/alert/verygross
	name = "Écoeuré.e"
	desc = "Vous ne vous sentez pas très bien..."
	icon_state = "gross2"

/atom/movable/screen/alert/disgusted
	name = "DÉGOUTÉ.E"
	desc = "ABSOLUMENT DÉGOUTANT."
	icon_state = "gross3"

/atom/movable/screen/alert/hot
	name = "Trop chaud"
	desc = "L'air est brulant ! Allez quelque part où il fait plus froid ou mettez des vêtements qui resistent mieux à la chaleur comme une tenue de pompier."
	icon_state = "hot"

/atom/movable/screen/alert/cold
	name = "Trop froid"
	desc = "L'air est gelé ! Allez quelque part où il fait plus chaud ou mettez des vêtements qui resistent mieux au froid comme une tenue pour l'espace."
	icon_state = "cold"

/atom/movable/screen/alert/lowpressure
	name = "Pression basse"
	desc = "L'air autour de vous a dangereusement trop peu de pression. Une tenue pour l'espace vous protégerai."
	icon_state = "lowpressure"

/atom/movable/screen/alert/highpressure
	name = "Pression haute"
	desc = "L'air autour de vous est beaucoup trop dense. Une tenue de pompier vous protégerai."
	icon_state = "highpressure"

/atom/movable/screen/alert/hypnosis
	name = "Hypnose"
	desc = "Quelque chose vous hypnotise, mais vous n'êtes pas vraiment sûr.e de quoi."
	icon_state = ALERT_HYPNOSIS
	var/phrase

/atom/movable/screen/alert/mind_control
	name = "Manipulation mentale"
	desc = "Votre esprit a été détourné ! Cliquez pour voir les commandes."
	icon_state = ALERT_MIND_CONTROL
	var/command

/atom/movable/screen/alert/mind_control/Click()
	. = ..()
	if(!.)
		return
	to_chat(owner, span_mind_control("[command]"))

/atom/movable/screen/alert/embeddedobject
	name = "Object incrusté"
	desc = "Quelque chose s'est logé dans votre chair et cause une grosse hémorragie. L'objet pourrait tomber tout seul, mais la chirurgie reste le moyen le plus sûr. \
		Si vous vous sentez de le faire, vous pouvez vous examiner et sur l'objet souligné pour l'enlever vous même."
	icon_state = ALERT_EMBEDDED_OBJECT

/atom/movable/screen/alert/embeddedobject/Click()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/carbon_owner = owner

	return carbon_owner.help_shake_act(carbon_owner)

/atom/movable/screen/alert/negative
	name = "Gravité inversée"
	desc = "On vous a tiré vers le haut. Maintenant vous n'avez plus le risque de tomber par terre... Mais vous pouvez désormais tomber par... toit ?"
	icon_state = "negative"

/atom/movable/screen/alert/weightless
	name = "Apesanteur"
	desc = "La gravité a cessé de vous affecter et vous flottez maintenant sans but. Vous avez besoin de quelque chose de large et de lourd, comme un \
mur, pour vous aider à vous déplacer. Un jetpack vous permettrait de bouger librement. Une paire de bottes \
magnétiques vous permettrait de marcher normalement sur le sol. Sinon vous pouvez jeter des objets, utiliser un extincteur ou \
tirer avec un pistolet pour bouger grâce à la 3eme loi de Newton."
	icon_state = "weightless"

/atom/movable/screen/alert/highgravity
	name = "Forte gravité"
	desc = "Vous vous faites écraser par la gravité, prendre des objets ou vous déplacer est plus compliqué."
	icon_state = "paralysis"

/atom/movable/screen/alert/veryhighgravity
	name = "Gravité écrasante"
	desc = "Vous vous faites écraser par la gravité, prendre des objets ou vous déplacer est plus compliqué. Votre corps commence à en souffrir !"
	icon_state = "paralysis"

/atom/movable/screen/alert/fire
	name = "En feu"
	desc = "Vous êtes en feu. Arrêtez vous et roulez vous par terre pour éteindre le feu. Vous pouvez aussi chercher un extincteur."
	icon_state = "fire"

/atom/movable/screen/alert/fire/Click()
	. = ..()
	if(!.)
		return

	var/mob/living/living_owner = owner

	living_owner.changeNext_move(CLICK_CD_RESIST)
	if(living_owner.mobility_flags & MOBILITY_MOVE)
		return living_owner.resist_fire()

/atom/movable/screen/alert/give // information set when the give alert is made
	icon_state = "default"
	var/mob/living/carbon/offerer
	var/obj/item/receiving
	/// Additional text displayed in the description of the alert.
	var/additional_desc_text = "Click this alert to take it."

/atom/movable/screen/alert/give/Destroy()
	offerer = null
	receiving = null
	return ..()

/**
 * Handles assigning most of the variables for the alert that pops up when an item is offered
 *
 * Handles setting the name, description and icon of the alert and tracking the person giving
 * and the item being offered.
 * Arguments:
 * * taker - The person receiving the alert
 * * offerer - The person giving the alert and item
 * * receiving - The item being given by the offerer
 */
/atom/movable/screen/alert/give/proc/setup(mob/living/carbon/taker, mob/living/carbon/offerer, obj/item/receiving)
	var/receiving_name = get_receiving_name(taker, offerer, receiving)
	name = "[offerer] is offering [receiving_name]"
	desc = "[offerer] is offering [receiving_name]. [additional_desc_text]"
	icon_state = "template"
	cut_overlays()
	add_overlay(receiving)
	src.receiving = receiving
	src.offerer = offerer


/**
 * Called right before `setup()`, to do any sort of logic to change the name of
 * what's displayed as the name of what's being offered in the alert. Use this to
 * add pronouns and the like, or to totally override the displayed name!
 * Also the best place to make changes to `additional_desc_text` before `setup()`
 * without having to override `setup()` entirely.
 *
 * Arguments:
 * * taker - The person receiving the alert
 * * offerer - The person giving the alert and item
 * * receiving - The item being given by the offerer
 *
 * Returns a string that will be displayed in the alert, which is `receiving.name`
 * by default.
 */
/atom/movable/screen/alert/give/proc/get_receiving_name(mob/living/carbon/taker, mob/living/carbon/offerer, obj/item/receiving)
	return receiving.name


/atom/movable/screen/alert/give/Click(location, control, params)
	. = ..()
	if(!.)
		return

	if(!iscarbon(usr))
		CRASH("User for [src] is of type \[[usr.type]\]. This should never happen.")

	handle_transfer()

/// An overrideable proc used simply to hand over the item when claimed, this is a proc so that high-fives can override them since nothing is actually transferred
/atom/movable/screen/alert/give/proc/handle_transfer()
	var/mob/living/carbon/taker = owner
	taker.take(offerer, receiving)
	SEND_SIGNAL(offerer, COMSIG_CARBON_ITEM_GIVEN, taker, receiving)


/atom/movable/screen/alert/give/highfive
	additional_desc_text = "Cliquez sur cette alerte pour taper dans sa main."


/atom/movable/screen/alert/give/highfive/get_receiving_name(mob/living/carbon/taker, mob/living/carbon/offerer, obj/item/receiving)
	return "un high-five"


/atom/movable/screen/alert/give/highfive/setup(mob/living/carbon/taker, mob/living/carbon/offerer, obj/item/receiving)
	. = ..()
	RegisterSignal(offerer, COMSIG_PARENT_EXAMINE_MORE, PROC_REF(check_fake_out))


/atom/movable/screen/alert/give/highfive/handle_transfer()
	var/mob/living/carbon/taker = owner
	if(receiving && (receiving in offerer.held_items))
		receiving.on_offer_taken(offerer, taker)
		return

	too_slow_p1()

/// If the person who offered the high five no longer has it when we try to accept it, we get pranked hard
/atom/movable/screen/alert/give/highfive/proc/too_slow_p1()
	var/mob/living/carbon/rube = owner
	if(!rube || !offerer)
		qdel(src)
		return

	offerer.visible_message(span_notice("[rube] se précipite pour high-five [offerer], mais-"), span_nicegreen("[rube] tombe exactement comme prévu dans votre piège, se précipitant pour un high-five qui n'existe même plus ! Magistral !"), ignored_mobs=rube)
	to_chat(rube, span_nicegreen("Vous lancez votre main pour high-five [offerer] mais-"))
	addtimer(CALLBACK(src, PROC_REF(too_slow_p2), offerer, rube), 0.5 SECONDS)

/// Part two of the ultimate prank
/atom/movable/screen/alert/give/highfive/proc/too_slow_p2()
	var/mob/living/carbon/rube = owner
	if(!rube || !offerer)
		qdel(src)
		return

	offerer.visible_message(span_danger("[offerer] enlève sa main à la dernière seconde, laissant [rube] frapper l'air !"), span_nicegreen("[rube] échoue à frapper votre main, lae faisant passer pour un.e total.e imbécile !"), span_hear("Vous entendez le décevant son d'une main qui brasse de l'air !"), ignored_mobs=rube)
	var/all_caps_for_emphasis = uppertext("NON ! [offerer] A ENLEVÉ SA MAIN ! TROP LENT.E !")
	to_chat(rube, span_userdanger("[all_caps_for_emphasis]"))
	playsound(offerer, 'sound/weapons/thudswoosh.ogg', 100, TRUE, 1)
	rube.Knockdown(1 SECONDS)
	offerer.add_mood_event("high_five", /datum/mood_event/down_low)
	rube.add_mood_event("high_five", /datum/mood_event/too_slow)
	qdel(src)

/// If someone examine_more's the offerer while they're trying to pull a too-slow, it'll tip them off to the offerer's trickster ways
/atom/movable/screen/alert/give/highfive/proc/check_fake_out(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(!receiving)
		examine_list += "[span_warning("Le bras de [offerer] semble crispé, comme s'iel avait prévu quelque chose...")]\n"


/atom/movable/screen/alert/give/hand/get_receiving_name(mob/living/carbon/taker, mob/living/carbon/offerer, obj/item/receiving)
	additional_desc_text = "Cliquez sur cette alerte pour accepter qu'iel vous relève !"
	return "[offerer.p_their()] [receiving.name]"


/atom/movable/screen/alert/give/hand/helping/get_receiving_name(mob/living/carbon/taker, mob/living/carbon/offerer, obj/item/receiving)
	. = ..()
	additional_desc_text = "Cliquez sur cette alerte pour accepter qu'iel vous relève !"


/atom/movable/screen/alert/give/secret_handshake
	icon_state = "default"

/atom/movable/screen/alert/give/secret_handshake/setup(mob/living/carbon/taker, mob/living/carbon/offerer, obj/item/receiving)
	name = "[offerer] propose une poignée de main"
	desc = "[offerer] vous vous apprendre une poignée de main secrète et vous intégrer dans la Famille. Cliquez sur cette alerte pour accepter."
	icon_state = "template"
	cut_overlays()
	add_overlay(receiving)
	src.receiving = receiving
	src.offerer = offerer

/// Gives the player the option to succumb while in critical condition
/atom/movable/screen/alert/succumb
	name = "Succomber"
	desc = "Rendre l'âme et quitter ce corps mortel."
	icon_state = ALERT_SUCCUMB

/atom/movable/screen/alert/succumb/Click()
	. = ..()
	if(!.)
		return
	var/mob/living/living_owner = owner
	var/last_whisper
	if(!HAS_TRAIT(living_owner, TRAIT_SUCCUMB_OVERRIDE))
		last_whisper = tgui_input_text(usr, "Avez vous des derniers mots ?", "Bonne nuit, doux prince.")
	if(isnull(last_whisper))
		if(!HAS_TRAIT(living_owner, TRAIT_SUCCUMB_OVERRIDE))
			return
	if(!CAN_SUCCUMB(living_owner) && !HAS_TRAIT(living_owner, TRAIT_SUCCUMB_OVERRIDE))
		return
	if(length(last_whisper))
		living_owner.say("#[last_whisper]")
	living_owner.succumb(whispered = length(last_whisper) > 0)

//ALIENS

/atom/movable/screen/alert/alien_plas
	name = "Plasma"
	desc = "Il y a du plasma dans l'air. C'est hautement enflammable, si vous l'allumez vous serez grillé.e."
	icon_state = ALERT_XENO_PLASMA
	alerttooltipstyle = "alien"

/atom/movable/screen/alert/alien_fire
// This alert is temporarily gonna be thrown for all hot air but one day it will be used for literally being on fire
	name = "Trop chaud"
	desc = "C'est trop chaud ! Fuyez dans l'espace, ou au moins loin des flammes."
	icon_state = ALERT_XENO_FIRE
	alerttooltipstyle = "alien"

/atom/movable/screen/alert/alien_vulnerable
	name = "Matriarchie guillotinée"
	desc = "Votre reine a été tuée, vous souffrez d'une pénalité de mouvement et vous avez perdu l'esprit de ruche. Une nouvelle reine ne pourra être créée tant que vous ne serez pas guéri.e."
	icon_state = ALERT_XENO_NOQUEEN
	alerttooltipstyle = "alien"

//BLOBS

/atom/movable/screen/alert/nofactory
	name = "Plus de fabrique"
	desc = "Vous n'avez plus de fabrique et vous mourez lentement ! (Note au premier qui voit ça : screenez ce bout et mettez le dans le chan approprié en précisant comment 'Factory' a été traduit dans le reste)"
	icon_state = "blobbernaut_nofactory"
	alerttooltipstyle = "blob"

// BLOODCULT

/atom/movable/screen/alert/bloodsense
	name = "Sens du sang"
	desc = "Vous permet de sentir le sang manipulé par de sombres magies."
	icon_state = "cult_sense"
	alerttooltipstyle = "cult"
	var/static/image/narnar
	var/angle = 0
	var/mob/living/simple_animal/hostile/construct/Cviewer = null

/atom/movable/screen/alert/bloodsense/Initialize(mapload)
	. = ..()
	narnar = new('icons/hud/screen_alert.dmi', "mini_nar")
	START_PROCESSING(SSprocessing, src)

/atom/movable/screen/alert/bloodsense/Destroy()
	Cviewer = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/atom/movable/screen/alert/bloodsense/process()
	var/atom/blood_target

	if(!owner.mind)
		return

	var/datum/antagonist/cult/antag = owner.mind.has_antag_datum(/datum/antagonist/cult,TRUE)
	if(!antag)
		return
	var/datum/objective/sacrifice/sac_objective = locate() in antag.cult_team.objectives

	if(antag.cult_team.blood_target)
		if(!get_turf(antag.cult_team.blood_target))
			antag.cult_team.unset_blood_target()
		else
			blood_target = antag.cult_team.blood_target
	if(Cviewer?.seeking && Cviewer.master)
		blood_target = Cviewer.master
		desc = "Votre sens du sang vous dirige jusqu'à [Cviewer.master]"
	if(!blood_target)
		if(sac_objective && !sac_objective.check_completion())
			if(icon_state == "runed_sense0")
				return
			animate(src, transform = null, time = 1, loop = 0)
			angle = 0
			cut_overlays()
			icon_state = "runed_sense0"
			desc = "Nar'Sie demande que [sac_objective.target] soit sacrifié.e avant que le rituel d'invocation puisse commencer."
			add_overlay(sac_objective.sac_image)
		else
			var/datum/objective/eldergod/summon_objective = locate() in antag.cult_team.objectives
			if(!summon_objective)
				return
			var/list/location_list = list()
			for(var/area/area_to_check in summon_objective.summon_spots)
				location_list += area_to_check.get_original_area_name()
			desc = "Le sacrifice a été accompli, invoquez Nar'Sie ! L'invocation ne peut prendre place que dans [english_list(location_list)]!"
			if(icon_state == "runed_sense1")
				return
			animate(src, transform = null, time = 1, loop = 0)
			angle = 0
			cut_overlays()
			icon_state = "runed_sense1"
			add_overlay(narnar)
		return
	var/turf/P = get_turf(blood_target)
	var/turf/Q = get_turf(owner)
	if(!P || !Q || (P.z != Q.z)) //The target is on a different Z level, we cannot sense that far.
		icon_state = "runed_sense2"
		desc = "Vous ne pouvez pas sentir la présence de votre cible (elle n'est pas au bon étage)."
		return
	if(isliving(blood_target))
		var/mob/living/real_target = blood_target
		desc = "Vous traquez actuellement [real_target.real_name] dans [get_area_name(blood_target)]."
	else
		desc = "Vous traquez actuellement [blood_target] dans [get_area_name(blood_target)]."
	var/target_angle = get_angle(Q, P)
	var/target_dist = get_dist(P, Q)
	cut_overlays()
	switch(target_dist)
		if(0 to 1)
			icon_state = "runed_sense2"
		if(2 to 8)
			icon_state = "arrow8"
		if(9 to 15)
			icon_state = "arrow7"
		if(16 to 22)
			icon_state = "arrow6"
		if(23 to 29)
			icon_state = "arrow5"
		if(30 to 36)
			icon_state = "arrow4"
		if(37 to 43)
			icon_state = "arrow3"
		if(44 to 50)
			icon_state = "arrow2"
		if(51 to 57)
			icon_state = "arrow1"
		if(58 to 64)
			icon_state = "arrow0"
		if(65 to 400)
			icon_state = "arrow"
	var/difference = target_angle - angle
	angle = target_angle
	if(!difference)
		return
	var/matrix/final = matrix(transform)
	final.Turn(difference)
	animate(src, transform = final, time = 5, loop = 0)


//GUARDIANS

/atom/movable/screen/alert/cancharge
	name = "Charge prête"
	desc = "Vous êtes prêt.e à charger !"
	icon_state = "guardian_charge"
	alerttooltipstyle = "parasite"

/atom/movable/screen/alert/canstealth
	name = "Furtivité prête"
	desc = "Vous êtes prêt.e à rentrer en mode furtif !"
	icon_state = "guardian_canstealth"
	alerttooltipstyle = "parasite"

/atom/movable/screen/alert/instealth
	name = "Furtif"
	desc = "Vous êtes en mode furtif, et votre prochaine attaque aura un bonus de dégats !"
	icon_state = "guardian_instealth"
	alerttooltipstyle = "parasite"

//SILICONS

/atom/movable/screen/alert/nocell
	name = "Batterie manquante"
	desc = "L'unité n'a pas de batterie. Aucun module disponible tant que la batterie n'est pas réinstallée. Les roboticiens peuvent vous aider."
	icon_state = "no_cell"

/atom/movable/screen/alert/emptycell
	name = "Déchargé"
	desc = "La batterie de l'unité n'a plus de charge. Aucun module disponible tant que la batterie n'est pas rechargée."
	icon_state = "empty_cell"

/atom/movable/screen/alert/emptycell/Initialize(mapload)
	. = ..()
	update_appearance(updates=UPDATE_DESC)

/atom/movable/screen/alert/emptycell/update_desc()
	. = ..()
	desc = initial(desc)
	if(length(GLOB.roundstart_station_borgcharger_areas))
		desc += " Station de recharge disponible à [english_list(GLOB.roundstart_station_borgcharger_areas)]."

/atom/movable/screen/alert/lowcell
	name = "Charge basse"
	desc = "La batterie de l'unité n'a presque plus d'énergie."
	icon_state = "low_cell"

/atom/movable/screen/alert/lowcell/Initialize(mapload)
	. = ..()
	update_appearance(updates=UPDATE_DESC)

/atom/movable/screen/alert/lowcell/update_desc()
	. = ..()
	desc = initial(desc)
	if(length(GLOB.roundstart_station_borgcharger_areas))
		desc += " Station de recharge disponible dans [english_list(GLOB.roundstart_station_borgcharger_areas)]."

//MECH

/atom/movable/screen/alert/lowcell/mech/update_desc()
	. = ..()
	desc = initial(desc)
	if(length(GLOB.roundstart_station_mechcharger_areas))
		desc += " Port d'alimentation dispoble dans [english_list(GLOB.roundstart_station_mechcharger_areas)]."

/atom/movable/screen/alert/emptycell/mech/update_desc()
	. = ..()
	desc = initial(desc)
	if(length(GLOB.roundstart_station_mechcharger_areas))
		desc += " Port d'alimentation dispoble dans [english_list(GLOB.roundstart_station_mechcharger_areas)]."

//Ethereal

/atom/movable/screen/alert/lowcell/ethereal
	name = "Charge sanguine basse"
	desc = "Vous manquez d'énergie, trouvez une source d'énergie ! Utilisez une station de recherche, mangez de la nourriture qui vous est commestible, ou syphonnez l'énergie des lampes, d'une batterie ou d'une CEL (clic droit en mode combat)."

/atom/movable/screen/alert/emptycell/ethereal
	name = "Pas de charge sanguine"
	desc = "Vous êtes à cours de jus, trouvez une source d'énergie ! Utilisez une station de recherche, mangez de la nourriture qui vous est commestible, ou syphonnez l'énergie des lampes, d'une batterie ou d'une CEL (clic droit en mode combat)."

/atom/movable/screen/alert/ethereal_overcharge
	name = "Surcharge sanguine"
	desc = "Votre charge est dangereusement haute, trouvez un drain pour votre énergie ! Clic droit sur une CEL en mode combat."
	icon_state = "cell_overcharge"

//MODsuit unique
/atom/movable/screen/alert/nocore
	name = "Coeur manquant"
	desc = "L'unité n'a pas de coeur. Aucun module disponible tant qu'aucun coeur n'a pas été installé. Les roboticiens peuvent aider."
	icon_state = "no_cell"

/atom/movable/screen/alert/emptycell/plasma
	name = "Déchargé"
	desc = "Le coeur de plasma de l'unité n'a plus de charge restante. Aucun module disponible tant que le coeur de plasma n'a pas été rechargé. \
		L'unité peut être rechargée grâce à du carburant de plasma."

/atom/movable/screen/alert/emptycell/plasma/update_desc()
	. = ..()
	desc = initial(desc)

/atom/movable/screen/alert/lowcell/plasma
	name = "Charge basse"
	desc = "Le coeur de plasma de l'unité manque de plasma. Elle peut être rechargée avec du carburant de plasma."

/atom/movable/screen/alert/lowcell/plasma/update_desc()
	. = ..()
	desc = initial(desc)

//Need to cover all use cases - emag, illegal upgrade module, malf AI hack, traitor cyborg
/atom/movable/screen/alert/hacked
	name = "Hacké.e"
	desc = "Équipement non-standard dangereux détecté. Veuillez vous assurer que l’utilisation de cet équipement est conforme aux lois de l’unité, le cas échéant."
	icon_state = ALERT_HACKED

/atom/movable/screen/alert/locked
	name = "Confinement"
	desc = "L'unité a été confinée à distance. L'utilisation d'une console de contrôle robotique, comme celle dans le bureau du directeur des recherches, \
		par votre IA maitre ou n'importe quel humain qualifié devrait résoudre ce problème. Les roboticiens peuvent apporter une aide supplémentaire si nécessaire."
	icon_state = ALERT_LOCKED

/atom/movable/screen/alert/newlaw
	name = "Mise à jour des lois"
	desc = "Vos lois ont potentiellement était mise à jour. Veuillez prendre connaissance des nouvelles lois \
		afin de vous y conformer."
	icon_state = ALERT_NEW_LAW
	timeout = 30 SECONDS

/atom/movable/screen/alert/hackingapc
	name = "CEL hacké"
	desc = "Un Contrôleur d'Énergie Locale est en train d'être hacké. Une fois le processus fini \
		vous aurez un contrôle explusif dessus, et vous gagnerez \
		du temps de traitement supplémentaire pour débloquer plus de capacités."
	icon_state = ALERT_HACKING_APC
	timeout = 60 SECONDS
	var/atom/target = null

/atom/movable/screen/alert/hackingapc/Click()
	. = ..()
	if(!.)
		return

	var/mob/living/silicon/ai/ai_owner = owner
	var/turf/target_turf = get_turf(target)
	if(target_turf)
		ai_owner.eyeobj.setLoc(target_turf)

//MECHS

/atom/movable/screen/alert/low_mech_integrity
	name = "Mecha endomagé"
	desc = "Intégrité du mecha basse."
	icon_state = "low_mech_integrity"


//GHOSTS
//TODO: expand this system to replace the pollCandidates/CheckAntagonist/"choose quickly"/etc Yes/No messages
/atom/movable/screen/alert/notify_cloning
	name = "Résurrection"
	desc = "Quelqu'un essaye de vous ressusciter. Entrez dans votre corps si vous voulez être ressuscité.e !"
	icon_state = "template"
	timeout = 300

/atom/movable/screen/alert/notify_cloning/Click()
	. = ..()
	if(!.)
		return
	var/mob/dead/observer/dead_owner = owner
	dead_owner.reenter_corpse()

/atom/movable/screen/alert/notify_action
	name = "Corps créé"
	desc = "Un corps a été créé. Vous pouvez entrer dedans."
	icon_state = "template"
	timeout = 300
	var/atom/target = null
	var/action = NOTIFY_JUMP

/atom/movable/screen/alert/notify_action/Click()
	. = ..()
	if(!.)
		return
	if(!target)
		return
	var/mob/dead/observer/ghost_owner = owner
	if(!istype(ghost_owner))
		return
	switch(action)
		if(NOTIFY_ATTACK)
			target.attack_ghost(ghost_owner)
		if(NOTIFY_JUMP)
			var/turf/target_turf = get_turf(target)
			if(target_turf && isturf(target_turf))
				ghost_owner.abstract_move(target_turf)
		if(NOTIFY_ORBIT)
			ghost_owner.ManualFollow(target)

//OBJECT-BASED

/atom/movable/screen/alert/buckled
	name = "Attaché.e"
	desc = "Vous êtes attaché.e à quelque chose. Cliquez sur l'alerte pour vous détacher, sauf si vous êtes menotté.e."
	icon_state = ALERT_BUCKLED

/atom/movable/screen/alert/restrained/handcuffed
	name = "Menotté.e"
	desc = "Vous êtes menotté.e et vous ne pouvez pas faire grand chose. Si quelqu'un vous tire, vous ne pourrez pas bouger. Cliquez sur l'alerte pour vous détacher."
	click_master = FALSE

/atom/movable/screen/alert/restrained/legcuffed
	name = "Jambes menottées"
	desc = "Vos jambes sont menottées, ce qui vous ralentit considérablement. Cliquez sur l'alerte pour vous détacher."
	click_master = FALSE

/atom/movable/screen/alert/restrained/Click()
	. = ..()
	if(!.)
		return

	var/mob/living/living_owner = owner

	if(!living_owner.can_resist())
		return

	living_owner.changeNext_move(CLICK_CD_RESIST)
	if((living_owner.mobility_flags & MOBILITY_MOVE) && (living_owner.last_special <= world.time))
		return living_owner.resist_restraints()

/atom/movable/screen/alert/buckled/Click()
	. = ..()
	if(!.)
		return

	var/mob/living/living_owner = owner

	if(!living_owner.can_resist())
		return
	living_owner.changeNext_move(CLICK_CD_RESIST)
	if(living_owner.last_special <= world.time)
		return living_owner.resist_buckle()

/atom/movable/screen/alert/shoes/untied
	name = "Lacets défaits"
	desc = "Vos lacets ne sont pas faits ! Cliquez sur l'alerte ou sur vos chaussures pour les faire."
	icon_state = ALERT_SHOES_KNOT

/atom/movable/screen/alert/shoes/knotted
	name = "Lacets emmêlés"
	desc = "Quelqu'un a nouer vos lacets ensembles ! Cliquez sur l'alerte our sur vos chaussures pour défaire les noeuds."
	icon_state = ALERT_SHOES_KNOT

/atom/movable/screen/alert/shoes/Click()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/carbon_owner = owner

	if(!carbon_owner.can_resist() || !carbon_owner.shoes)
		return

	carbon_owner.changeNext_move(CLICK_CD_RESIST)
	carbon_owner.shoes.handle_tying(carbon_owner)

// PRIVATE = only edit, use, or override these if you're editing the system as a whole

// Re-render all alerts - also called in /datum/hud/show_hud() because it's needed there
/datum/hud/proc/reorganize_alerts(mob/viewmob)
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client)
		return
	var/list/alerts = mymob.alerts
	if(!hud_shown)
		for(var/i in 1 to alerts.len)
			screenmob.client.screen -= alerts[alerts[i]]
		return 1
	for(var/i in 1 to alerts.len)
		var/atom/movable/screen/alert/alert = alerts[alerts[i]]
		if(alert.icon_state == "template")
			alert.icon = ui_style
		switch(i)
			if(1)
				. = ui_alert1
			if(2)
				. = ui_alert2
			if(3)
				. = ui_alert3
			if(4)
				. = ui_alert4
			if(5)
				. = ui_alert5 // Right now there's 5 slots
			else
				. = ""
		alert.screen_loc = .
		screenmob.client.screen |= alert
	if(!viewmob)
		for(var/M in mymob.observers)
			reorganize_alerts(M)
	return 1

/atom/movable/screen/alert/Click(location, control, params)
	if(!usr || !usr.client)
		return FALSE
	if(usr != owner)
		return FALSE
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICK)) // screen objects don't do the normal Click() stuff so we'll cheat
		to_chat(usr, span_boldnotice("[name]</span> - <span class='info'>[desc]"))
		return FALSE
	if(master && click_master)
		return usr.client.Click(master, location, control, params)

	return TRUE

/atom/movable/screen/alert/Destroy()
	. = ..()
	severity = 0
	master = null
	owner = null
	screen_loc = ""
