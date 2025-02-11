/obj/item/toy/xmas_cracker
	name = "cracker de noël"
	icon = 'icons/obj/holiday/christmas.dmi'
	icon_state = "cracker"
	desc = "Indication d'utilisation : Demande 2 personnes, une pour tenir chaque bout."
	w_class = WEIGHT_CLASS_TINY
	/// The crack state of the toy. If set to TRUE, you can no longer crack it by attacking.
	var/cracked = FALSE

/obj/item/toy/xmas_cracker/attack(mob/target, mob/user)
	if( !cracked && ishuman(target) && (target.stat == CONSCIOUS) && !target.get_active_held_item() )
		target.visible_message(span_notice("[user] et [target] pop un [src]! *pop*"), span_notice("Vous attrapez un [src] avec [target] ! *pop*"), span_hear("Vous entendez un pop."))
		var/obj/item/paper/joke_paper = new /obj/item/paper(user.loc)
		joke_paper.name = "blague [pick("horrible","terrible","pas drole")]"
		joke_paper.add_raw_text(pick("Qu'est-ce qu'un bonhomme de neige dit à un autre ?\n\n<i>'C'est moi ou tu sens la carotte ?'</i>",
			"Pourquoi un bonhomme de neige ne peut pas tirer son coup ?\n\n<i>Parce qu'il est frigide !</i>",
			"Pourquoi mère-noël ne fait pas la tournée des cadeaux avec son mari ?\n\n<i>Parce qu'ELFE-ait du ski !</i>",
			"Qu'est-il arrivé à la personne qui a volé un calendrier de l'avant ?\n\n<i>Il s'est pris 25 jours !</i>",
			"Que fait le père noël quand il est coincé dans une cheminée ?\n\n<i>De la Claus-trophobie !</i>",
			"Certains Français sont chauvins.\n\n<i>Moi, je suis plutôt vin chaud.</i>",
			"Comment appelle-t-on un chat qui est tombé dans un pot de peinture le jour de Noël ?\n\n<i>Un chat-peint de Noël !</i>",
			"Que dit un sapin de Noël qui arrive en retard le soir du réveillon ?\n\n<i>Je vais encore me faire enguirlander !</i>",
			"Pourquoi noël ressemble autant à la vie en entreprise ?\n\n<i>Tu te démènes toute l'année pour des enfants et c'est le gros monsieur qui récolte tous les lauriers.</i>",
			"Pourquoi le père noël n'a aucun enfant ?\n\n<i>Parce qu'il ne vient que dans la cheminée.</i>"))
		joke_paper.update_appearance()
		new /obj/item/clothing/head/costume/festive(target.loc)
		user.update_icons()
		cracked = TRUE
		icon_state = "cracker1"
		var/obj/item/toy/xmas_cracker/other_half = new /obj/item/toy/xmas_cracker(target)
		other_half.cracked = 1
		other_half.icon_state = "cracker2"
		target.put_in_active_hand(other_half)
		playsound(user, 'sound/effects/snap.ogg', 50, TRUE)
		return TRUE
	return ..()

/obj/item/clothing/head/costume/festive
	name = "chapeau festif en papier"
	icon_state = "xmashat"
	desc = "Un chapeau en papier pas ouf que vous êtes OBLIGÉ de mettre."
	flags_inv = 0
	armor_type = /datum/armor/none
	dog_fashion = /datum/dog_fashion/head/festive

/obj/effect/spawner/xmastree
	name = "christmas tree spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
	layer = FLY_LAYER
	plane = ABOVE_GAME_PLANE

	/// Christmas tree, no presents included.
	var/festive_tree = /obj/structure/flora/tree/pine/xmas
	/// Christmas tree, presents included.
	var/christmas_tree = /obj/structure/flora/tree/pine/xmas/presents

/obj/effect/spawner/xmastree/Initialize(mapload)
	. = ..()
	if(check_holidays(CHRISTMAS) && christmas_tree)
		new christmas_tree(get_turf(src))
	else if(check_holidays(FESTIVE_SEASON) && festive_tree)
		new festive_tree(get_turf(src))

/obj/effect/spawner/xmastree/rdrod
	name = "festivus pole spawner"
	festive_tree = /obj/structure/festivus
	christmas_tree = null

/datum/round_event_control/santa
	name = "Visite du père noël"
	holidayID = CHRISTMAS
	typepath = /datum/round_event/santa
	weight = 20
	max_occurrences = 1
	earliest_start = 30 MINUTES
	category = EVENT_CATEGORY_HOLIDAY
	description = "Spawn le père noël, qui va se balander dans la station en distribuant des cadeaux."

/datum/round_event/santa
	var/mob/living/carbon/human/santa //who is our santa?

/datum/round_event/santa/announce(fake)
	priority_announce("Le père noël arrive !", "Transmission inconnue")

/datum/round_event/santa/start()
	var/list/candidates = poll_ghost_candidates("Le père noël arrive ! Est-ce que tu veux le jouer ?", poll_time=150)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		santa = new /mob/living/carbon/human(pick(GLOB.blobstart))
		santa.key = C.key

		var/datum/antagonist/santa/A = new
		santa.mind.add_antag_datum(A)
