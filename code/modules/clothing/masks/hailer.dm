
// **** Security gas mask ****

// Cooldown times
#define PHRASE_COOLDOWN (3 SECONDS)
#define OVERUSE_COOLDOWN (18 SECONDS)

// Aggression levels
#define AGGR_GOOD_COP 1
#define AGGR_BAD_COP 2
#define AGGR_SHIT_COP 3
#define AGGR_BROKEN 4

// Phrase list index markers
#define EMAG_PHRASE 1 // index of emagged phrase
#define GOOD_COP_PHRASES 6 // final index of good cop phrases
#define BAD_COP_PHRASES 12 // final index of bad cop phrases
#define BROKE_PHRASES 13 // starting index of broken phrases
#define ALL_PHRASES 19 // total phrases

// All possible hailer phrases
// Remember to modify above index markers if changing contents
GLOBAL_LIST_INIT(hailer_phrases, list(
	/datum/hailer_phrase/emag,
	/datum/hailer_phrase/halt,
	/datum/hailer_phrase/bobby,
	/datum/hailer_phrase/compliance,
	/datum/hailer_phrase/justice,
	/datum/hailer_phrase/running,
	/datum/hailer_phrase/dontmove,
	/datum/hailer_phrase/floor,
	/datum/hailer_phrase/robocop,
	/datum/hailer_phrase/god,
	/datum/hailer_phrase/freeze,
	/datum/hailer_phrase/imperial,
	/datum/hailer_phrase/bash,
	/datum/hailer_phrase/harry,
	/datum/hailer_phrase/asshole,
	/datum/hailer_phrase/stfu,
	/datum/hailer_phrase/shutup,
	/datum/hailer_phrase/super,
	/datum/hailer_phrase/dredd
))

/obj/item/clothing/mask/gas/sechailer
	name = "masque anti-gas de sécurité"
	desc = "Un masque anti-gaz de sécurité standard avec un système \"Compli-o-nator 3000\" intégré. Joue plus d'une douzaine de phrases pré-enregistrées de conformité conçues pour faire tenir les salauds en place pendant que vous les tasez. Ne pas manipuler l'appareil."
	actions_types = list(/datum/action/item_action/halt, /datum/action/item_action/adjust)
	icon_state = "sechailer"
	inhand_icon_state = "sechailer"
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEFACIALHAIR | HIDEFACE | HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	visor_flags_inv = HIDEFACIALHAIR | HIDEFACE | HIDESNOUT
	flags_cover = MASKCOVERSMOUTH
	visor_flags_cover = MASKCOVERSMOUTH
	tint = 0
	has_fov = FALSE
	COOLDOWN_DECLARE(hailer_cooldown)
	var/aggressiveness = AGGR_BAD_COP
	var/overuse_cooldown = FALSE
	var/recent_uses = 0
	var/broken_hailer = FALSE
	var/safety = TRUE

/obj/item/clothing/mask/gas/sechailer/plasmaman
	starting_filter_type = /obj/item/gas_filter/plasmaman

/obj/item/clothing/mask/gas/sechailer/swat
	name = "\improper masque du SWAT"
	desc = "Un masque tactique avec un Compli-o-nator 3000 particulièrement agressif."
	actions_types = list(/datum/action/item_action/halt)
	icon_state = "swat"
	inhand_icon_state = "swat"
	aggressiveness = AGGR_SHIT_COP
	flags_inv = HIDEFACIALHAIR | HIDEFACE | HIDEEYES | HIDEEARS | HIDEHAIR | HIDESNOUT
	visor_flags_inv = 0
	flags_cover = MASKCOVERSMOUTH | MASKCOVERSEYES | PEPPERPROOF
	visor_flags_cover = MASKCOVERSMOUTH | MASKCOVERSEYES | PEPPERPROOF

/obj/item/clothing/mask/gas/sechailer/swat/spacepol
	name = "masque de police de l'espace"
	desc = "Un masque tactique étanche créé en coopération avec certaine megacorporation possède un Compli-o-nator 3000 particulièrement agressif."
	icon_state = "spacepol"
	inhand_icon_state = "spacepol_mask"
	flags_cover = MASKCOVERSMOUTH | MASKCOVERSEYES | PEPPERPROOF
	visor_flags_cover = MASKCOVERSMOUTH | MASKCOVERSEYES | PEPPERPROOF

/obj/item/clothing/mask/gas/sechailer/cyborg
	name = "hurleur de sécurité"
	desc = "Un set de message enregistré que les cyborgs doivent utiliser en arrêtant des criminels."
	icon = 'icons/obj/device.dmi'
	icon_state = "taperecorder_idle"
	slot_flags = null
	aggressiveness = AGGR_GOOD_COP // Borgs are nicecurity!
	actions_types = list(/datum/action/item_action/halt)

/obj/item/clothing/mask/gas/sechailer/screwdriver_act(mob/living/user, obj/item/I)
	. = TRUE
	if(..())
		return
	else if (aggressiveness == AGGR_BROKEN)
		to_chat(user, span_danger("Vous ajustez le restricteur mais rien ne se passe, probablement parce qu'il est cassé."))
		return
	var/position = aggressiveness == AGGR_GOOD_COP ? "milieu" : aggressiveness == AGGR_BAD_COP ? "dernier" : "premier"
	to_chat(user, span_notice("Vous changez le mode du Compli-o-nator 3000 : [position]."))
	aggressiveness = aggressiveness % 3 + 1 // loop AGGR_GOOD_COP -> AGGR_SHIT_COP

/obj/item/clothing/mask/gas/sechailer/wirecutter_act(mob/living/user, obj/item/I)
	. = TRUE
	..()
	if(aggressiveness != AGGR_BROKEN)
		to_chat(user, span_danger("Vous avez cassé le restricteur !"))
		aggressiveness = AGGR_BROKEN

/obj/item/clothing/mask/gas/sechailer/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/halt))
		halt()
	else
		adjustmask(user)

/obj/item/clothing/mask/gas/sechailer/attack_self()
	halt()
/obj/item/clothing/mask/gas/sechailer/emag_act(mob/user)
	if(safety)
		safety = FALSE
		to_chat(user, span_warning("Vous court-circuitez les circuits vocaux de [src]."))

/obj/item/clothing/mask/gas/sechailer/verb/halt()
	set category = "Object"
	set name = "HALT"
	set src in usr
	if(!isliving(usr) || !can_use(usr) || !COOLDOWN_FINISHED(src, hailer_cooldown))
		return
	if(broken_hailer)
		to_chat(usr, span_warning("Le système hurleur du [src] est cassé."))
		return

	// handle recent uses for overuse
	recent_uses++
	if(!overuse_cooldown) // check if we can reset recent uses
		recent_uses = 0
		overuse_cooldown = TRUE
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/clothing/mask/gas/sechailer, reset_overuse_cooldown)), OVERUSE_COOLDOWN)

	switch(recent_uses)
		if(3)
			to_chat(usr, span_warning("Le [src] commence à chauffer."))
		if(4)
			to_chat(usr, span_userdanger("Le [src] chauffe dangereusement à cause d'une utilisation excessive !"))
		if(5) // overload
			broken_hailer = TRUE
			to_chat(usr, span_userdanger("Le modulateur de puissance du [src] surcharge et casse."))
			return

	// select phrase to play
	play_phrase(usr, GLOB.hailer_phrases[select_phrase()])


/obj/item/clothing/mask/gas/sechailer/proc/select_phrase()
	if (!safety)
		return EMAG_PHRASE
	else
		var/upper_limit
		switch (aggressiveness)
			if (AGGR_GOOD_COP)
				upper_limit = GOOD_COP_PHRASES
			if (AGGR_BAD_COP)
				upper_limit = BAD_COP_PHRASES
			else
				upper_limit = ALL_PHRASES
		return rand(aggressiveness == AGGR_BROKEN ? BROKE_PHRASES : EMAG_PHRASE + 1, upper_limit)

/obj/item/clothing/mask/gas/sechailer/proc/play_phrase(mob/user, datum/hailer_phrase/phrase)
	if(!COOLDOWN_FINISHED(src, hailer_cooldown))
		return
	COOLDOWN_START(src, hailer_cooldown, PHRASE_COOLDOWN)
	user.audible_message("[user]'s Compli-o-Nator: <font color='red' size='4'><b>[initial(phrase.phrase_text)]</b></font>")
	playsound(src, "sound/runtime/complionator/[initial(phrase.phrase_sound)].ogg", 100, FALSE, 4)
	return TRUE

/obj/item/clothing/mask/gas/sechailer/proc/reset_overuse_cooldown()
	overuse_cooldown = FALSE

/obj/item/clothing/mask/whistle
	name = "sifflet de police"
	desc = "Un sifflet de police pour être sûr que les criminels vous entendent."
	icon_state = "whistle"
	inhand_icon_state = null
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_NECK
	custom_price = PAYCHECK_COMMAND * 1.5
	w_class = WEIGHT_CLASS_SMALL
	actions_types = list(/datum/action/item_action/halt)
	COOLDOWN_DECLARE(whistle_cooldown)

/obj/item/clothing/mask/whistle/ui_action_click(mob/user, action)
	if(!COOLDOWN_FINISHED(src, whistle_cooldown))
		return
	COOLDOWN_START(src, whistle_cooldown, 10 SECONDS)
	user.audible_message("<font color='red' size='5'><b>ARRÊTEZ VOUS !</b></font>")
	playsound(src, 'sound/misc/whistle.ogg', 50, FALSE, 4)

/datum/action/item_action/halt
	name = "HALT!"

/obj/item/clothing/mask/party_horn
	name = "pouet de fête"
	desc = "Un tube en papier utilisé lors de fêtes qui fait du bruit lorsqu'on souffle dedans."
	icon_state = "party_horn"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	actions_types = list(/datum/action/item_action/toot)
	COOLDOWN_DECLARE(horn_cooldown)

/obj/item/clothing/mask/party_horn/ui_action_click(mob/user, action)
	if(!COOLDOWN_FINISHED(src, horn_cooldown))
		return
	COOLDOWN_START(src, horn_cooldown, 10 SECONDS)
	playsound(src, 'sound/items/party_horn.ogg', 75, FALSE)
	flick("party_horn_animated", src)

/datum/action/item_action/toot
	name = "TOOT!"

#undef PHRASE_COOLDOWN
#undef OVERUSE_COOLDOWN
#undef AGGR_GOOD_COP
#undef AGGR_BAD_COP
#undef AGGR_SHIT_COP
#undef AGGR_BROKEN
#undef EMAG_PHRASE
#undef GOOD_COP_PHRASES
#undef BAD_COP_PHRASES
#undef BROKE_PHRASES
#undef ALL_PHRASES
