//traits with no real impact that can be taken freely
//MAKE SURE THESE DO NOT MAJORLY IMPACT GAMEPLAY. those should be positive or negative traits.

/datum/quirk/extrovert
	name = "Extraverti"
	desc = "Vous tirez votre énergie des discussions que vous avez avec les autres, et vous aimez passer votre temps libre au bar."
	icon = FA_ICON_USERS
	value = 0
	mob_trait = TRAIT_EXTROVERT
	gain_text = span_notice("Vous avez envie de traîner avec d'autres personnes.")
	lose_text = span_danger("Vous sentez que vous n'avez plus d'attrait pour le bar.")
	medical_record_text = "Le patient ne se taît jamais."
	mail_goodies = list(/obj/item/reagent_containers/cup/glass/flask)

/datum/quirk/introvert
	name = "Introverti"
	desc = "Vous tirez votre énergie du temps du temps que vous passez seul, et vous aimez passer votre temps livre à la bibliothèque."
	icon = FA_ICON_BOOK_READER
	value = 0
	mob_trait = TRAIT_INTROVERT
	gain_text = span_notice("Vous sentez que vous avez envie de lire un bon livre tranquillement.")
	lose_text = span_danger("Vous sentez que les libraires sont ennuyeuses.")
	medical_record_text = "Le patient ne parle pas beaucoup (quel était son nom déjà?)"
	mail_goodies = list(/obj/item/book/random)

/datum/quirk/no_taste
	name = "Agueusie"
	desc = "Rien n'a de goût pour vous! La nourriture toxique vous empoisonnera quand même."
	icon = FA_ICON_MEH_BLANK
	value = 0
	mob_trait = TRAIT_AGEUSIA
	gain_text = span_notice("Plus rien n'a de goût! (covid?)")
	lose_text = span_notice("Le goût revient!")
	medical_record_text = "Le patient souffre d'agueusie et est incapable de ressentir le goût. "
	mail_goodies = list(/obj/effect/spawner/random/food_or_drink/condiment) // but can you taste the salt? CAN YOU?!

/datum/quirk/foreigner
	name = "Étranger"
	desc = "Vous n'êtes pas d'ici. Vous ne connaissez pas le language Galactique Commun!"
	icon = FA_ICON_LANGUAGE
	value = 0
	gain_text = span_notice("Les mots parlés autour de vous ne font plus sens.")
	lose_text = span_notice("Vous êtes désormais bilingue en Galactique Commun.")
	medical_record_text = "Le patient ne parle pas Galactique Commun et aurait besoin d'un traducteur."
	mail_goodies = list(/obj/item/taperecorder) // for translation

/datum/quirk/foreigner/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.add_blocked_language(/datum/language/common)
	if(ishumanbasic(human_holder))
		human_holder.grant_language(/datum/language/uncommon)

/datum/quirk/foreigner/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.remove_blocked_language(/datum/language/common)
	if(ishumanbasic(human_holder))
		human_holder.remove_language(/datum/language/uncommon)

/datum/quirk/vegetarian
	name = "Végetarien"
	desc = "Vous trouvez l'idée de manger de la viande répugnante physiquement."
	icon = FA_ICON_CARROT
	value = 0
	gain_text = span_notice("Vous vous sentez répugné à l'idée de manger de la viande.")
	lose_text = span_notice("Vous vous sentez de manger de la viande à nouveau.")
	medical_record_text = "Le patient consomme un régime végétarien (non, il ne mange pas de graines)"
	mail_goodies = list(/obj/effect/spawner/random/food_or_drink/salad)

/datum/quirk/vegetarian/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.liked_food &= ~MEAT
	species.disliked_food |= MEAT
	RegisterSignal(human_holder, COMSIG_SPECIES_GAIN, PROC_REF(on_species_gain))

/datum/quirk/vegetarian/proc/on_species_gain(datum/source, datum/species/new_species, datum/species/old_species)
	SIGNAL_HANDLER
	new_species.liked_food &= ~MEAT
	new_species.disliked_food |= MEAT

/datum/quirk/vegetarian/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder

	var/datum/species/species = human_holder.dna.species
	if(initial(species.liked_food) & MEAT)
		species.liked_food |= MEAT
	if(!(initial(species.disliked_food) & MEAT))
		species.disliked_food &= ~MEAT
	UnregisterSignal(human_holder, COMSIG_SPECIES_GAIN)

/datum/quirk/snob
	name = "Snob"
	desc = "Vous avez le souci des détails : si une chambre n'est pas belle, cela ne vaut pas le coup n'est-ce pas?"
	icon = FA_ICON_USER_TIE
	value = 0
	gain_text = span_notice("Vous avez le souci du détail")
	lose_text = span_notice("Bah qui se soucie de la déco même?")
	medical_record_text = "Le patient a l'air d'être coincé."
	mob_trait = TRAIT_SNOB
	mail_goodies = list(/obj/item/chisel, /obj/item/paint_palette)

/datum/quirk/pineapple_liker
	name = "Affinité pour l'ananas"
	desc = "Vous êtes un enthousiaste de l'ananas. Vous ne pouvez vous passer de cette douceur divine!"
	icon = FA_ICON_THUMBS_UP
	value = 0
	gain_text = span_notice("Vous avez une énorme envie d'ananas.")
	lose_text = span_notice("Votre ressentiment envers l'ananas s'estompe.")
	medical_record_text = "Le patient démontre une forte affection pour les ananas."
	mail_goodies = list(/obj/item/food/pizzaslice/pineapple)

/datum/quirk/pineapple_liker/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.liked_food |= PINEAPPLE
	RegisterSignal(human_holder, COMSIG_SPECIES_GAIN, PROC_REF(on_species_gain))

/datum/quirk/pineapple_liker/proc/on_species_gain(datum/source, datum/species/new_species, datum/species/old_species)
	SIGNAL_HANDLER
	new_species.liked_food |= PINEAPPLE

/datum/quirk/pineapple_liker/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.liked_food &= ~PINEAPPLE
	UnregisterSignal(human_holder, COMSIG_SPECIES_GAIN)

/datum/quirk/pineapple_hater
	name = "Aversion pour l'ananas"
	desc = "Vous êtes dégoûté par l'ananas, comment quelqu'un peut il trouver cela bon? Et qui est le fou qui le met sur sa pizza ?!"
	icon = FA_ICON_THUMBS_DOWN
	value = 0
	gain_text = span_notice("Vous commencez à vous demander qui est assez idiot pour aimer l'ananas...")
	lose_text = span_notice("Votre ressentiment envers l'ananas s'estompe.")
	medical_record_text = "Le patient pense, à juste titre, que l'ananas est dégoûtant."
	mail_goodies = list( // basic pizza slices
		/obj/item/food/pizzaslice/margherita,
		/obj/item/food/pizzaslice/meat,
		/obj/item/food/pizzaslice/mushroom,
		/obj/item/food/pizzaslice/vegetable,
		/obj/item/food/pizzaslice/sassysage,
	)

/datum/quirk/pineapple_hater/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.disliked_food |= PINEAPPLE
	RegisterSignal(human_holder, COMSIG_SPECIES_GAIN, PROC_REF(on_species_gain))

/datum/quirk/pineapple_hater/proc/on_species_gain(datum/source, datum/species/new_species, datum/species/old_species)
	SIGNAL_HANDLER
	new_species.disliked_food |= PINEAPPLE

/datum/quirk/pineapple_hater/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.disliked_food &= ~PINEAPPLE
	UnregisterSignal(human_holder, COMSIG_SPECIES_GAIN)

/datum/quirk/deviant_tastes
	name = "Goûts différents"
	desc = "Vous détestez la nourriture que la majorité des gens aiment, et vous adorez ce que la majorité des gens détestent."
	icon = FA_ICON_GRIN_TONGUE_SQUINT
	value = 0
	gain_text = span_notice("Vous avez envie de quelque chose qui goûte bizarrement.")
	lose_text = span_notice("Vos envie de nourriture reviennent à la normale.")
	medical_record_text = "Le patient démontre une attirance pour des goûts singuliers."
	mail_goodies = list(/obj/item/food/urinalcake, /obj/item/food/badrecipe) // Mhhhmmm yummy

/datum/quirk/deviant_tastes/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	var/liked = species.liked_food
	species.liked_food = species.disliked_food
	species.disliked_food = liked
	RegisterSignal(human_holder, COMSIG_SPECIES_GAIN, PROC_REF(on_species_gain))

/datum/quirk/deviant_tastes/proc/on_species_gain(datum/source, datum/species/new_species, datum/species/old_species)
	SIGNAL_HANDLER
	var/liked = new_species.liked_food
	new_species.liked_food = new_species.disliked_food
	new_species.disliked_food = liked

/datum/quirk/deviant_tastes/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.liked_food = initial(species.liked_food)
	species.disliked_food = initial(species.disliked_food)
	UnregisterSignal(human_holder, COMSIG_SPECIES_GAIN)

/datum/quirk/heterochromatic
	name = "Hétérochromie"
	desc = "L'un de vos yeux est de couleur différente!"
	icon = FA_ICON_EYE_LOW_VISION // Ignore the icon name, its actually a fairly good representation of different color eyes
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_CHANGES_APPEARANCE
	value = 0
	mail_goodies = list(/obj/item/clothing/glasses/eyepatch)

// Only your first eyes are heterochromatic
// If someone comes and says "well mr coder you can have DNA bound heterochromia so it's not unrealistic
// to allow all inserted replacement eyes to become heterochromatic or for it to transfer between mobs"
// Then just change this to [proc/add] I really don't care
/datum/quirk/heterochromatic/add_unique(client/client_source)
	var/color = client_source?.prefs.read_preference(/datum/preference/color/heterochromatic)
	if(!color)
		return

	apply_heterochromatic_eyes(color)

/// Applies the passed color to this mob's eyes
/datum/quirk/heterochromatic/proc/apply_heterochromatic_eyes(color)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/was_not_hetero = !human_holder.eye_color_heterochromatic
	human_holder.eye_color_heterochromatic = TRUE
	human_holder.eye_color_right = color

	var/obj/item/organ/internal/eyes/eyes_of_the_holder = quirk_holder.get_organ_by_type(/obj/item/organ/internal/eyes)
	if(!eyes_of_the_holder)
		return

	eyes_of_the_holder.eye_color_right = color
	eyes_of_the_holder.old_eye_color_right = color
	eyes_of_the_holder.refresh()

	if(was_not_hetero)
		RegisterSignal(human_holder, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(check_eye_removal))

/datum/quirk/heterochromatic/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.eye_color_heterochromatic = FALSE
	human_holder.eye_color_right = human_holder.eye_color_left
	UnregisterSignal(human_holder, COMSIG_CARBON_LOSE_ORGAN)

/datum/quirk/heterochromatic/proc/check_eye_removal(datum/source, obj/item/organ/internal/eyes/removed)
	SIGNAL_HANDLER

	if(!istype(removed))
		return

	// Eyes were removed, remove heterochromia from the human holder and bid them adieu
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.eye_color_heterochromatic = FALSE
	human_holder.eye_color_right = human_holder.eye_color_left
	UnregisterSignal(human_holder, COMSIG_CARBON_LOSE_ORGAN)

/datum/quirk/monochromatic
	name = "Daltonisme"
	desc = "Vous souffrez de daltonisme, et vous voyez le monde en nuances de noir et blanc."
	icon = FA_ICON_ADJUST
	value = 0
	medical_record_text = "Le patient souffre de daltonisme complet."
	mail_goodies = list( // Noir detective wannabe
		/obj/item/clothing/suit/jacket/det_suit/noir,
		/obj/item/clothing/suit/jacket/det_suit/dark,
		/obj/item/clothing/head/fedora/beige,
		/obj/item/clothing/head/fedora/white,
	)

/datum/quirk/monochromatic/add(client/client_source)
	quirk_holder.add_client_colour(/datum/client_colour/monochrome)

/datum/quirk/monochromatic/post_add()
	if(is_detective_job(quirk_holder.mind.assigned_role))
		to_chat(quirk_holder, span_boldannounce("Mmm. Rien n'est plus clair sur cette station. Tout est en nuance de gris..."))
		quirk_holder.playsound_local(quirk_holder, 'sound/ambience/ambidet1.ogg', 50, FALSE)

/datum/quirk/monochromatic/remove()
	quirk_holder.remove_client_colour(/datum/client_colour/monochrome)

/datum/quirk/phobia
	name = "Phobique"
	desc = "Vous êtes irrémédiablement effrayé par quelque chose."
	icon = FA_ICON_SPIDER
	value = 0
	medical_record_text = "Le patient a une peur irrationnelle de quelque chose."
	mail_goodies = list(/obj/item/clothing/glasses/blindfold, /obj/item/storage/pill_bottle/psicodine)

// Phobia will follow you between transfers
/datum/quirk/phobia/add(client/client_source)
	var/phobia = client_source?.prefs.read_preference(/datum/preference/choiced/phobia)
	if(!phobia)
		return

	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.gain_trauma(new /datum/brain_trauma/mild/phobia(phobia), TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/phobia/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.cure_trauma_type(/datum/brain_trauma/mild/phobia, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/shifty_eyes
	name = "Yeux curieux"
	desc = "Vos yeux ont tendance à regarder partout que vous le vouliez ou non ce qui peut donner l'impression aux gens que vous les regarder directement dans les yeux même si ce n'est pas le cas."
	icon = FA_ICON_EYE
	value = 0
	medical_record_text = "Le patient m'a regardé pendant tout l'examen. Je diagnotisque juste pour éviter de penser que c'était intentionnel."
	mob_trait = TRAIT_SHIFTY_EYES
	mail_goodies = list(/obj/item/clothing/head/costume/papersack, /obj/item/clothing/head/costume/papersack/smiley)

/datum/quirk/item_quirk/bald
	name = "Chauve"
	desc = "Vous n'avez pas de cheveux, et êtes sensible sur ce sujet! Gardez votre tête couverte par une perruque ou un chapeau."
	icon = FA_ICON_EGG
	value = 0
	mob_trait = TRAIT_BALD
	gain_text = span_notice("Une calvasse terrible s'empare de vous.")
	lose_text = span_notice("L'opération à réussie, des cheveux repoussent!")
	medical_record_text = "Le patient a strictement refusé de quitter son couvre-chef durant l'examen."
	mail_goodies = list(/obj/item/clothing/head/wig/random)
	/// The user's starting hairstyle
	var/old_hair

/datum/quirk/item_quirk/bald/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	old_hair = human_holder.hairstyle
	human_holder.hairstyle = "Bald"
	human_holder.update_body_parts()
	RegisterSignal(human_holder, COMSIG_CARBON_EQUIP_HAT, PROC_REF(equip_hat))
	RegisterSignal(human_holder, COMSIG_CARBON_UNEQUIP_HAT, PROC_REF(unequip_hat))

/datum/quirk/item_quirk/bald/add_unique(client/client_source)
	var/obj/item/clothing/head/wig/natural/baldie_wig = new(get_turf(quirk_holder))

	if (old_hair == "Bald")
		baldie_wig.hairstyle = pick(GLOB.hairstyles_list - "Bald")
	else
		baldie_wig.hairstyle = old_hair

	baldie_wig.update_appearance()

	give_item_to_holder(baldie_wig, list(LOCATION_HEAD = ITEM_SLOT_HEAD, LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/bald/remove()
	. = ..()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.hairstyle = old_hair
	human_holder.update_body_parts()
	UnregisterSignal(human_holder, list(COMSIG_CARBON_EQUIP_HAT, COMSIG_CARBON_UNEQUIP_HAT))
	human_holder.clear_mood_event("bad_hair_day")

///Checks if the headgear equipped is a wig and sets the mood event accordingly
/datum/quirk/item_quirk/bald/proc/equip_hat(mob/user, obj/item/hat)
	SIGNAL_HANDLER

	if(istype(hat, /obj/item/clothing/head/wig))
		quirk_holder.add_mood_event("bad_hair_day", /datum/mood_event/confident_mane) //Our head is covered, but also by a wig so we're happy.
	else
		quirk_holder.clear_mood_event("bad_hair_day") //Our head is covered

///Applies a bad moodlet for having an uncovered head
/datum/quirk/item_quirk/bald/proc/unequip_hat(mob/user, obj/item/clothing, force, newloc, no_move, invdrop, silent)
	SIGNAL_HANDLER

	quirk_holder.add_mood_event("bad_hair_day", /datum/mood_event/bald)

/datum/quirk/item_quirk/photographer
	name = "Photographe"
	desc = "Vous avez toujours votre appareil photo et votre album sur vous, et vos clichés sont réputés comme légendaires par vos collègues."
	icon = FA_ICON_CAMERA
	value = 0
	mob_trait = TRAIT_PHOTOGRAPHER
	gain_text = span_notice("Vous savez tout de la photographie.")
	lose_text = span_danger("Vous avez oublié comment un appareil photo fonctionne.")
	medical_record_text = "Le patient a mentionné plusieurs fois sa passio nde la photographie et a tenu à me montrer ses clichés."
	mail_goodies = list(/obj/item/camera_film)

/datum/quirk/item_quirk/photographer/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/storage/photo_album/personal/photo_album = new(get_turf(human_holder))
	photo_album.persistence_id = "personal_[human_holder.last_mind?.key]" // this is a persistent album, the ID is tied to the account's key to avoid tampering
	photo_album.persistence_load()
	photo_album.name = "album photo de [human_holder.real_name]"

	give_item_to_holder(photo_album, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
	give_item_to_holder(
		/obj/item/camera,
		list(
			LOCATION_NECK = ITEM_SLOT_NECK,
			LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
			LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
			LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
			LOCATION_HANDS = ITEM_SLOT_HANDS
		)
	)

/datum/quirk/item_quirk/colorist
	name = "Capilairement instable"
	desc = "Vous vous promenez toujours avec une teinture à cheveux pour rapidement changer de couleur."
	icon = FA_ICON_FILL_DRIP
	value = 0
	medical_record_text = "Le patient change souvent de couleur de cheveux."
	mail_goodies = list(/obj/item/dyespray)

/datum/quirk/item_quirk/colorist/add_unique(client/client_source)
	give_item_to_holder(/obj/item/dyespray, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

#define GAMING_WITHDRAWAL_TIME (15 MINUTES)
/datum/quirk/gamer
	name = "Joueur"
	desc = "Vous êtes un joueur acharné, et vous avez besoin de joué. Vous aimez gagner et détestez perdre. Vous n'aimez que la nourriture de joueur."
	icon = FA_ICON_GAMEPAD
	value = 0
	gain_text = span_notice("Vous avez le besoin soudain de lancer une game de LoL.")
	lose_text = span_notice("Vous perdez l'envie de jouer.")
	medical_record_text = "Le patient a une addiction sévère aux jeux vidéos."
	mob_trait = TRAIT_GAMER
	mail_goodies = list(/obj/item/toy/intento, /obj/item/clothing/head/fedora)
	/// Timer for gaming withdrawal to kick in
	var/gaming_withdrawal_timer = TIMER_ID_NULL

/datum/quirk/gamer/add(client/client_source)
	// Gamer diet
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.liked_food = JUNKFOOD
	RegisterSignal(human_holder, COMSIG_SPECIES_GAIN, PROC_REF(on_species_gain))
	RegisterSignal(human_holder, COMSIG_MOB_WON_VIDEOGAME, PROC_REF(won_game))
	RegisterSignal(human_holder, COMSIG_MOB_LOST_VIDEOGAME, PROC_REF(lost_game))
	RegisterSignal(human_holder, COMSIG_MOB_PLAYED_VIDEOGAME, PROC_REF(gamed))

/datum/quirk/gamer/proc/on_species_gain(datum/source, datum/species/new_species, datum/species/old_species)
	SIGNAL_HANDLER
	new_species.liked_food = JUNKFOOD

/datum/quirk/gamer/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.liked_food = initial(species.liked_food)
	UnregisterSignal(human_holder, COMSIG_SPECIES_GAIN)
	UnregisterSignal(human_holder, COMSIG_MOB_WON_VIDEOGAME)
	UnregisterSignal(human_holder, COMSIG_MOB_LOST_VIDEOGAME)
	UnregisterSignal(human_holder, COMSIG_MOB_PLAYED_VIDEOGAME)

/datum/quirk/gamer/add_unique(client/client_source)
	// The gamer starts off quelled
	gaming_withdrawal_timer = addtimer(CALLBACK(src, PROC_REF(enter_withdrawal)), GAMING_WITHDRAWAL_TIME, TIMER_STOPPABLE)

/**
 * Gamer won a game
 *
 * Executed on the COMSIG_MOB_WON_VIDEOGAME signal
 * This signal should be called whenever a player has won a video game.
 * (E.g. Orion Trail)
 */
/datum/quirk/gamer/proc/won_game()
	SIGNAL_HANDLER
	// Epic gamer victory
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.add_mood_event("gamer_won", /datum/mood_event/gamer_won)

/**
 * Gamer lost a game
 *
 * Executed on the COMSIG_MOB_LOST_VIDEOGAME signal
 * This signal should be called whenever a player has lost a video game.
 * (E.g. Orion Trail)
 */
/datum/quirk/gamer/proc/lost_game()
	SIGNAL_HANDLER
	// Executed when a gamer has lost
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.add_mood_event("gamer_lost", /datum/mood_event/gamer_lost)
	// Executed asynchronously due to say()
	INVOKE_ASYNC(src, PROC_REF(gamer_moment))
/**
 * Gamer is playing a game
 *
 * Executed on the COMSIG_MOB_PLAYED_VIDEOGAME signal
 * This signal should be called whenever a player interacts with a video game.
 */
/datum/quirk/gamer/proc/gamed()
	SIGNAL_HANDLER

	var/mob/living/carbon/human/human_holder = quirk_holder
	// Remove withdrawal malus
	human_holder.clear_mood_event("gamer_withdrawal")
	// Reset withdrawal timer
	if (gaming_withdrawal_timer)
		deltimer(gaming_withdrawal_timer)
	gaming_withdrawal_timer = addtimer(CALLBACK(src, PROC_REF(enter_withdrawal)), GAMING_WITHDRAWAL_TIME, TIMER_STOPPABLE)


/datum/quirk/gamer/proc/gamer_moment()
	// It was a heated gamer moment...
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.say(";[pick("MERDE", "FAIT CHIER", "PUTAIN", "SALOPE", "GOBE MES BOULES", "FILS DE PUTE")]!!", forced = name)

/datum/quirk/gamer/proc/enter_withdrawal()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.add_mood_event("gamer_withdrawal", /datum/mood_event/gamer_withdrawal)

#undef GAMING_WITHDRAWAL_TIME


/datum/quirk/item_quirk/pride_pin
	name = "Pin's de la fierté"
	desc = "Montrez votre soutien avec ce badge de fierté!"
	icon = FA_ICON_RAINBOW
	value = 0
	gain_text = span_notice("Vous vous sentez émoustillé.")
	lose_text = span_danger("Vous vous sentez moins émoustillé.")
	medical_record_text = "Le patient a l'air émoustillé."

/datum/quirk/item_quirk/pride_pin/add_unique(client/client_source)
	var/obj/item/clothing/accessory/pride/pin = new(get_turf(quirk_holder))

	var/pride_choice = client_source?.prefs?.read_preference(/datum/preference/choiced/pride_pin) || assoc_to_keys(GLOB.pride_pin_reskins)[1]
	var/pride_reskin = GLOB.pride_pin_reskins[pride_choice]

	pin.current_skin = pride_choice
	pin.icon_state = pride_reskin

	give_item_to_holder(pin, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
