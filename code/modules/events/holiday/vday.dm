// Valentine's Day events //
// why are you playing spessmens on valentine's day you wizard //

#define VALENTINE_FILE "valentines.json"

// valentine / candy heart distribution //

/datum/round_event_control/valentines
	name = "Saint-Valentin !"
	holidayID = VALENTINES
	typepath = /datum/round_event/valentines
	weight = -1 //forces it to be called, regardless of weight
	max_occurrences = 1
	earliest_start = 0 MINUTES
	category = EVENT_CATEGORY_HOLIDAY
	description = "Met les gens par paire ! Ils doivent se protéger, mais parfois un tier jaloux se rajoute..."

/datum/round_event/valentines/start()
	..()
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		H.put_in_hands(new /obj/item/valentine)
		var/obj/item/storage/backpack/b = locate() in H.contents
		new /obj/item/food/candyheart(b)
		new /obj/item/storage/fancy/heart_box(b)

	var/list/valentines = list()
	for(var/mob/living/M in GLOB.player_list)
		var/turf/current_turf = get_turf(M.mind.current)
		if(!M.stat && M.mind && !current_turf.onCentCom())
			valentines |= M


	while(valentines.len)
		var/mob/living/L = pick_n_take(valentines)
		if(valentines.len)
			var/mob/living/date = pick_n_take(valentines)


			forge_valentines_objective(L, date)
			forge_valentines_objective(date, L)

			if(valentines.len && prob(4))
				var/mob/living/notgoodenough = pick_n_take(valentines)
				forge_valentines_objective(notgoodenough, date)
		else
			L.mind.add_antag_datum(/datum/antagonist/heartbreaker)

/proc/forge_valentines_objective(mob/living/lover,mob/living/date)
	lover.mind.special_role = "valentine"
	var/datum/antagonist/valentine/V = new
	V.date = date.mind
	lover.mind.add_antag_datum(V) //These really should be teams but i can't be assed to incorporate third wheels right now

/datum/round_event/valentines/announce(fake)
	priority_announce("C'est la saint-Valentin ! Donnez votre carte de saint-Valentin à la personne qui vous est chère !")

/obj/item/valentine
	name = "carte de saint-Valentine"
	desc = "Une carte de saint-Valentine ! Je me demande ce que ça dit..."
	icon = 'icons/obj/toys/playing_cards.dmi'
	icon_state = "sc_Ace of Hearts_syndicate" // shut up // bye felicia
	var/message = "Un message d'amours, générique mais un peu mignon !"
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY

/obj/item/valentine/Initialize(mapload)
	. = ..()
	message = pick(strings(VALENTINE_FILE, "valentines"))

/obj/item/valentine/attackby(obj/item/W, mob/user, params)
	..()
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/toy/crayon))
		if(!user.can_write(W))
			return
		var/recipient = tgui_input_text(user, "Pour qui est cette carte de saint-Valentin ?", "Pour :", max_length = MAX_NAME_LEN)
		var/sender = tgui_input_text(user, "Qui envoie cette carte de saint-Valentin ?", "De :", max_length = MAX_NAME_LEN)
		if(!user.can_perform_action(src))
			return
		if(recipient && sender)
			name = "carte de saint-Valentin - Pour : [recipient] De : [sender]"

/obj/item/valentine/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		if( !(ishuman(user) || isobserver(user) || issilicon(user)) )
			user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[stars(message)]</BODY></HTML>", "window=[name]")
			onclose(user, "[name]")
		else
			user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[message]</BODY></HTML>", "window=[name]")
			onclose(user, "[name]")
	else
		. += span_notice("C'est trop loin.")

/obj/item/valentine/attack_self(mob/user)
	user.examinate(src)

/obj/item/food/candyheart
	name = "bonbon en forme de coeur"
	icon = 'icons/obj/holiday/holiday_misc.dmi'
	icon_state = "candyheart"
	desc = "Un bonbon en forme de coeur, au dos vous pouvez lire : "
	food_reagents = list(/datum/reagent/consumable/sugar = 2)
	junkiness = 5

/obj/item/food/candyheart/Initialize(mapload)
	. = ..()
	desc = pick(strings(VALENTINE_FILE, "candyhearts"))
	icon_state = pick("candyheart", "candyheart2", "candyheart3", "candyheart4")

#undef VALENTINE_FILE
