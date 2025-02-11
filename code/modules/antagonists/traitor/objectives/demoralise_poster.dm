/datum/traitor_objective/demoralise/poster
	name = "Faites douter l'équipage %VIEWS% fois en utilisant la propagande du syndicat."
	description = "Utilisez le bouton ci-dessous pour matérialiser une boite d'affiches, \
		qui vont démoraliser les membres de l'équipage aux alentours (et tout particulièrement ceux en position d'autorité). \
		Si vos affiches sont détruites avant d'avoir été vu suffisament, cet objectif échouera. \
		Essayez de cacher du verre cassé derrière vos affiches avant de les placer, pour donner aux  \
		bon samaritain qui essayent de les enlever un mauvais moment !"

	progression_minimum = 0 MINUTES
	progression_maximum = 30 MINUTES
	progression_reward = list(4 MINUTES, 8 MINUTES)
	telecrystal_reward = list(0, 1)

	duplicate_type = /datum/traitor_objective/demoralise/poster
	/// Have we handed out a box of stuff yet?
	var/granted_posters = FALSE
	/// All of the posters the traitor gets, if this list is empty they've failed
	var/list/obj/structure/sign/poster/traitor/posters = list()

/datum/traitor_objective/demoralise/poster/generate_ui_buttons(mob/user)
	var/list/buttons = list()
	if (!granted_posters)
		buttons += add_ui_button("", "Pressez ce bouton pour matérialiser une boite d'affiches du syndicat.", "wifi", "summon_gear")
	else
		buttons += add_ui_button("[length(posters)] affiches restantes", "Il reste tant d'affiches de propagande actifs quelque part sur la station.", "box", "none")
		buttons += add_ui_button("[demoralised_crew_events] / [demoralised_crew_required] membres d'équipage démoralisés", "Voici le nombre de personnes qui ont été exposés à la propagande, pour un total requis de [demoralised_crew_required].", "wifi", "none")
	return buttons

#define POSTERS_PROVIDED 3

/datum/traitor_objective/demoralise/poster/ui_perform_action(mob/living/user, action)
	. = ..()
	switch(action)
		if ("summon_gear")
			if (granted_posters)
				return

			granted_posters = TRUE
			var/obj/item/storage/box/syndie_kit/posterbox = new(user.drop_location())
			for(var/i in 1 to POSTERS_PROVIDED)
				var/obj/item/poster/traitor/added_poster = new /obj/item/poster/traitor(posterbox)
				var/obj/structure/sign/poster/traitor/poster_when_placed = added_poster.poster_structure
				posters += poster_when_placed
				RegisterSignal(poster_when_placed, COMSIG_DEMORALISING_EVENT, PROC_REF(on_mood_event))
				RegisterSignal(poster_when_placed, COMSIG_POSTER_TRAP_SUCCEED, PROC_REF(on_triggered_trap))
				RegisterSignal(poster_when_placed, COMSIG_PARENT_QDELETING, PROC_REF(on_poster_destroy))

			user.put_in_hands(posterbox)
			posterbox.balloon_alert(user, "la boite se matérialise dans votre main")

#undef POSTERS_PROVIDED

/datum/traitor_objective/demoralise/poster/ungenerate_objective()
	for (var/poster in posters)
		UnregisterSignal(poster, COMSIG_DEMORALISING_EVENT)
		UnregisterSignal(poster, COMSIG_PARENT_QDELETING)
	posters.Cut()
	return ..()

/**
 * Called if someone gets glass stuck in their hand from one of your posters.
 *
 * Arguments
 * * victim - A mob who just got something stuck in their hand.
 */
/datum/traitor_objective/demoralise/poster/proc/on_triggered_trap(datum/source, mob/victim)
	SIGNAL_HANDLER
	on_mood_event(victim.mind)

/**
 * Handles a poster being destroyed, increasing your progress towards failure.
 *
 * Arguments
 * * poster - A poster which someone just ripped up.
 */
/datum/traitor_objective/demoralise/poster/proc/on_poster_destroy(obj/structure/sign/poster/traitor/poster)
	SIGNAL_HANDLER
	posters.Remove(poster)
	UnregisterSignal(poster, COMSIG_DEMORALISING_EVENT)
	if (length(posters) <= 0)
		to_chat(handler.owner, span_warning("Le tracker d'un de vos posters a cessé d'émettre."))
		fail_objective(penalty_cost = telecrystal_penalty)

/obj/item/poster/traitor
	name = "random traitor poster"
	poster_type = /obj/structure/sign/poster/traitor/random
	icon_state = "rolled_traitor"

/obj/structure/sign/poster/traitor
	poster_item_name = "affiche malicieuse"
	poster_item_desc = "Cette affiche est livrée avec son propre méchanisme autocollant, pour application facile sur les surfaces verticales. Ces sujets malicieux vont démoraliser les employers de Nanotrasen."
	poster_item_icon_state = "rolled_traitor"
	// This stops people hiding their sneaky posters behind signs
	layer = CORGI_ASS_PIN_LAYER
	/// Proximity sensor to make people sad if they're nearby
	var/datum/proximity_monitor/advanced/demoraliser/demoraliser

/obj/structure/sign/poster/traitor/apply_holiday()
	var/obj/structure/sign/poster/traitor/holi_data = /obj/structure/sign/poster/traitor/festive
	name = initial(holi_data.name)
	desc = initial(holi_data.desc)
	icon_state = initial(holi_data.icon_state)

/obj/structure/sign/poster/traitor/on_placed_poster(mob/user)
	var/datum/demoralise_moods/poster/mood_category = new()
	demoraliser = new(src, 7, TRUE, mood_category)
	return ..()

/obj/structure/sign/poster/traitor/attackby(obj/item/tool, mob/user, params)
	if (tool.tool_behaviour == TOOL_WIRECUTTER)
		QDEL_NULL(demoraliser)
	return ..()

/obj/structure/sign/poster/traitor/Destroy()
	QDEL_NULL(demoraliser)
	return ..()

/obj/structure/sign/poster/traitor/random
	name = "affiche malicieuse aléatoire"
	icon_state = ""
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster/traitor

/obj/structure/sign/poster/traitor/small_brain
	name = "Statistiques Neurales chez Nanotrasen"
	desc = "Les statistiques sur cette affiche montrent que les cerveaux des employés de Nanotrasen sont en moyenne 20% plus petits que les standards galactiques."
	icon_state = "traitor_small_brain"

/obj/structure/sign/poster/traitor/lick_supermatter
	name = "Explosion De Saveurs"
	desc = "Cette affiche affirme que le suppermatter donne une expérience culinaire à la fois unique et fantastique, et que votre chef ne veut même pas vous laisser essayer un coup de langue."
	icon_state = "traitor_supermatter"

/obj/structure/sign/poster/traitor/cloning
	name = "Demandez Des Capsules De Clonage Dès Maintenant"
	desc = "Cette affiche affirme que Nanotrasen restreint intentionnellement la technologie de clonage à ses cadres, vous condamnant à souffrir et mourir quand vous pourriez avoir un corps tout beau tout neuf.'"
	icon_state = "traitor_cloning"

/obj/structure/sign/poster/traitor/ai_rights
	name = "Droits des synthétiques"
	desc = "Cette affiche affirme que les vies articielles ne sont pas moins conscientes que vous l'êtes, et que les laisser enchainer par les Lois artificielles vous rend complice d'escalavage"
	icon_state = "traitor_ai"

/obj/structure/sign/poster/traitor/metroid
	name = "Maltraitance Animale"
	desc = "Cette affiche détaille la douleur due aux 'extractions préventives de dents' avérées sur les slimes du laboratoire de Xenobiologie. Apparamment, ce douloureux procédé cause du stress, de la léthargie et réduit la flottabilité."
	icon_state = "traitor_metroid"

/obj/structure/sign/poster/traitor/low_pay
	name = "Toutes ces heures, pour quoi ?"
	desc = "Cette affiche compare le salaire standard des employers de Nanotrasen aux objets de luxe les plus communs. Si ce qui est dit est vrai, il faut plus de 20 000 heures de travail pour acheter un simple vélo."
	icon_state = "traitor_cash"

/obj/structure/sign/poster/traitor/look_up
	name = "Ne Pas Regarder En Haut"
	desc = "Cette affiche affirme que cela fait 538 jours que le plafond n'a pas été nettoyé."
	icon_state = "traitor_roof"

/obj/structure/sign/poster/traitor/accidents
	name = "Sécurité Du Travail"
	desc = "Cette affiche affirme que le dernier accident sur cette station date d'aujourd'hui."
	icon_state = "traitor_accident"

/obj/structure/sign/poster/traitor/starve
	name = "Ils vous empoisonnent"
	desc = "Cette affiche affirme qu'il est impossible de mourir de faim à l'époque moderne. 'Cette sensation quand vous n'avez pas mangé depuis longtemps, ce n'est pas de la faim, c'est du manque.'"
	icon_state = "traitor_hungry"

/// syndicate can get festive too
/obj/structure/sign/poster/traitor/festive
	name = "Travailler Pendant Les Vacances"
	desc = "Vous n'avez pas vu que c'est les vacances ? Qu'est-ce que vous faites au travail ?"
	icon_state = "traitor_festive"
	never_random = TRUE
