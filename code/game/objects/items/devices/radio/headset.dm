// Used for translating channels to tokens on examination
GLOBAL_LIST_INIT(channel_tokens, list(
	RADIO_CHANNEL_COMMON = RADIO_KEY_COMMON,
	RADIO_CHANNEL_SCIENCE = RADIO_TOKEN_SCIENCE,
	RADIO_CHANNEL_COMMAND = RADIO_TOKEN_COMMAND,
	RADIO_CHANNEL_MEDICAL = RADIO_TOKEN_MEDICAL,
	RADIO_CHANNEL_ENGINEERING = RADIO_TOKEN_ENGINEERING,
	RADIO_CHANNEL_SECURITY = RADIO_TOKEN_SECURITY,
	RADIO_CHANNEL_CENTCOM = RADIO_TOKEN_CENTCOM,
	RADIO_CHANNEL_SYNDICATE = RADIO_TOKEN_SYNDICATE,
	RADIO_CHANNEL_SUPPLY = RADIO_TOKEN_SUPPLY,
	RADIO_CHANNEL_SERVICE = RADIO_TOKEN_SERVICE,
	MODE_BINARY = MODE_TOKEN_BINARY,
	RADIO_CHANNEL_AI_PRIVATE = RADIO_TOKEN_AI_PRIVATE
))

/obj/item/radio/headset
	name = "oreillette"
	desc = "Un intercom modulaire et amélioré qui se fixe sur la tête. Prend des clés d'encryption."
	icon_state = "headset"
	inhand_icon_state = "headset"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	worn_icon_state = "headset"
	custom_materials = list(/datum/material/iron=75)
	subspace_transmission = TRUE
	canhear_range = 0 // can't hear headsets from very far away

	slot_flags = ITEM_SLOT_EARS
	dog_fashion = null
	var/obj/item/encryptionkey/keyslot2 = null
	/// A list of all languages that this headset allows the user to understand. Populated by language encryption keys.
	var/list/language_list

	// headset is too small to display overlays
	overlay_speaker_idle = null
	overlay_speaker_active = null
	overlay_mic_idle = null
	overlay_mic_active = null

/obj/item/radio/headset/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] commence à mettre l'antenne de [src] dans le nez de [user.p_their()] ! il semble que [user.p_theyre()] essaye de donner le cancer à [user.p_them()] !"))
	return TOXLOSS

/obj/item/radio/headset/examine(mob/user)
	. = ..()

	if(item_flags & IN_INVENTORY && loc == user)
		// construction of frequency description
		var/list/avail_chans = list("Utilisez [RADIO_KEY_COMMON] pour accéder à la fréquence actuelle")
		if(translate_binary)
			avail_chans += "Utilisez [MODE_TOKEN_BINARY] pour accéder à [MODE_BINARY]"
		if(length(channels))
			for(var/i in 1 to length(channels))
				if(i == 1)
					avail_chans += "Utilisez [MODE_TOKEN_DEPARTMENT] ou [GLOB.channel_tokens[channels[i]]] pour [lowertext(channels[i])]"
				else
					avail_chans += "Utilisez [GLOB.channel_tokens[channels[i]]] pour [lowertext(channels[i])]"
		. += span_notice("Un petit écran sur l'affichage tête haute affiche les fréquences disponibles : \n[english_list(avail_chans)].")

		if(command)
			. += span_info("Alt-click pour activer le mode haute-volume.")
	else
		. += span_notice("Un petit écran sur l'affichage tête haute clignote, il est trop petit pour être lu sans tenir ou porter l'oreillette.")

/obj/item/radio/headset/Initialize(mapload)
	. = ..()
	if(ispath(keyslot2))
		keyslot2 = new keyslot2()
	set_listening(TRUE)
	recalculateChannels()
	possibly_deactivate_in_loc()

/obj/item/radio/headset/proc/possibly_deactivate_in_loc()
	if(ismob(loc))
		set_listening(should_be_listening)
	else
		set_listening(FALSE, actual_setting = FALSE)

/obj/item/radio/headset/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	possibly_deactivate_in_loc()

/obj/item/radio/headset/Destroy()
	if(istype(keyslot2))
		QDEL_NULL(keyslot2)
	return ..()

/obj/item/radio/headset/ui_data(mob/user)
	. = ..()
	.["headset"] = TRUE

/obj/item/radio/headset/MouseDrop(mob/over, src_location, over_location)
	var/mob/headset_user = usr
	if((headset_user == over) && headset_user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return attack_self(headset_user)
	return ..()

/// Grants all the languages this headset allows the mob to understand via installed chips.
/obj/item/radio/headset/proc/grant_headset_languages(mob/grant_to)
	for(var/language in language_list)
		grant_to.grant_language(language, understood = TRUE, spoken = FALSE, source = LANGUAGE_RADIOKEY)

/obj/item/radio/headset/equipped(mob/user, slot, initial)
	. = ..()
	if(!(slot_flags & slot))
		return

	grant_headset_languages(user)

/obj/item/radio/headset/dropped(mob/user, silent)
	. = ..()
	for(var/language in language_list)
		user.remove_language(language, understood = TRUE, spoken = FALSE, source = LANGUAGE_RADIOKEY)

/obj/item/radio/headset/syndicate //disguised to look like a normal headset for stealth ops

/obj/item/radio/headset/syndicate/Initialize(mapload)
	. = ..()
	make_syndie()

/obj/item/radio/headset/syndicate/alt //undisguised bowman with flash protection
	name = "oreillette du syndicat"
	desc = "Une oreillette du syndicat qui peut être utilisée pour entendre toutes les fréquences radio. Protège les oreilles des flashbangs."
	icon_state = "syndie_headset"
	worn_icon_state = "syndie_headset"

/obj/item/radio/headset/syndicate/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/syndicate/alt/leader
	name = "oreillette du chef d'équipe"
	command = TRUE

/obj/item/radio/headset/syndicate/alt/psyker
	name = "oreillette psychique"
	desc = "Une oreillette conçue pour amplifier les ondes psychiques. Protège les oreilles des flashbangs."
	icon_state = "psyker_headset"
	worn_icon_state = "syndie_headset"

/obj/item/radio/headset/syndicate/alt/psyker/equipped(mob/living/user, slot)
	. = ..()
	if(slot_flags & slot)
		ADD_CLOTHING_TRAIT(user, TRAIT_ECHOLOCATION_EXTRA_RANGE)

/obj/item/radio/headset/syndicate/alt/psyker/dropped(mob/user, silent)
	. = ..()
	REMOVE_CLOTHING_TRAIT(user, TRAIT_ECHOLOCATION_EXTRA_RANGE)

/obj/item/radio/headset/binary
	keyslot = /obj/item/encryptionkey/binary

/obj/item/radio/headset/headset_sec
	name = "oreillette de sécurité"
	desc = "Oreillette utilisée par les forces de sécurité."
	icon_state = "sec_headset"
	worn_icon_state = "sec_headset"
	keyslot = /obj/item/encryptionkey/headset_sec

/obj/item/radio/headset/headset_sec/alt
	name = "oreillette de sécurité bowman"
	desc = "Oreiilette utilisée par les forces de sécurité. Protège les oreilles des flashbangs."
	icon_state = "sec_headset_alt"
	worn_icon_state = "sec_headset_alt"

/obj/item/radio/headset/headset_sec/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/headset_eng
	name = "oreillette d'ingénieurie"
	desc = "Quand les ingénieurs veulent discuter comme des filles."
	icon_state = "eng_headset"
	worn_icon_state = "eng_headset"
	keyslot = /obj/item/encryptionkey/headset_eng

/obj/item/radio/headset/headset_rob
	name = "oreillette de robotique"
	desc = "Fait spécifiquement pour les roboticistes, qui ne peuvent pas décider entre les départements."
	icon_state = "rob_headset"
	worn_icon_state = "rob_headset"
	keyslot = /obj/item/encryptionkey/headset_rob

/obj/item/radio/headset/headset_med
	name = "oreillette médicale"
	desc = "Une oreillette pour le personnel formé de la zone-médicale."
	icon_state = "med_headset"
	worn_icon_state = "med_headset"
	keyslot = /obj/item/encryptionkey/headset_med

/obj/item/radio/headset/headset_sci
	name = "oreillette scientifique"
	desc = "Un oreillette scientifique. Comme d'habitude."
	icon_state = "sci_headset"
	worn_icon_state = "sci_headset"
	keyslot = /obj/item/encryptionkey/headset_sci

/obj/item/radio/headset/headset_medsci
	name = "oreillette de recherche médicale"
	desc = "Une oreillette qui est le résultat de l'accouplement entre la médecine et la science."
	icon_state = "medsci_headset"
	worn_icon_state = "medsci_headset"
	keyslot = /obj/item/encryptionkey/headset_medsci

/obj/item/radio/headset/headset_srvsec
	name = "oreillette loi et ordre"
	desc = "Dans l'oerillette de justice criminelle, la clé d'encryption représente deux groupes distincts mais tout aussi importants. La sécurité, qui enquête sur les crimes, et le service, qui fournit des services. Ce sont leurs communications."
	icon_state = "srvsec_headset"
	worn_icon_state = "srvsec_headset"
	keyslot = /obj/item/encryptionkey/headset_srvsec

/obj/item/radio/headset/headset_srvmed
	name = "oreillette de psychologie"
	desc = "Une oreillette permettant à son porteur de communiquer avec la zone médicale et le service."
	icon_state = "med_headset"
	worn_icon_state = "med_headset"
	keyslot = /obj/item/encryptionkey/headset_srvmed

/obj/item/radio/headset/headset_com
	name = "oreillette de commandement"
	desc = "Une oreillette avec accès au canal de commandement."
	icon_state = "com_headset"
	worn_icon_state = "com_headset"
	keyslot = /obj/item/encryptionkey/headset_com

/obj/item/radio/headset/heads
	command = TRUE

/obj/item/radio/headset/heads/captain
	name = "\proper oreillette du capitaine"
	desc = "L'oreillette du roi."
	icon_state = "com_headset"
	worn_icon_state = "com_headset"
	keyslot = /obj/item/encryptionkey/heads/captain

/obj/item/radio/headset/heads/captain/alt
	name = "\proper oreillette du capitaine bowman"
	desc = "L'oreillette du roi. Protège les oreilles des flashbangs."
	icon_state = "com_headset_alt"
	worn_icon_state = "com_headset_alt"

/obj/item/radio/headset/heads/captain/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/heads/rd
	name = "\proper oreillette du directeur de la recherche"
	desc = "Oreillette de la personne qui fait avancer la société vers la singularité technologique."
	icon_state = "com_headset"
	worn_icon_state = "com_headset"
	keyslot = /obj/item/encryptionkey/heads/rd

/obj/item/radio/headset/heads/hos
	name = "\proper oreillette du chef de la sécurité"
	desc = "L'oreillette de la personne en charge de maintenir l'ordre et de protéger la station."
	icon_state = "com_headset"
	worn_icon_state = "com_headset"
	keyslot = /obj/item/encryptionkey/heads/hos

/obj/item/radio/headset/heads/hos/alt
	name = "\proper oreillette du chef de la sécurité bowman"
	desc = "L'oreillette de la personne en charge de maintenir l'ordre et de protéger la station. Protège les oreilles des flashbangs."
	icon_state = "com_headset_alt"
	worn_icon_state = "com_headset_alt"

/obj/item/radio/headset/heads/hos/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/heads/ce
	name = "\proper oreillette du chef de l'ingénierie"
	desc = "L'oreillette de la personne en charge de maintenir la station alimentée et non endommagée."
	icon_state = "com_headset"
	worn_icon_state = "com_headset"
	keyslot = /obj/item/encryptionkey/heads/ce

/obj/item/radio/headset/heads/cmo
	name = "\proper l'oreillette du chef médical"
	desc = "L'oreillette d'un chef médical hautement qualifié."
	icon_state = "com_headset"
	worn_icon_state = "com_headset"
	keyslot = /obj/item/encryptionkey/heads/cmo

/obj/item/radio/headset/heads/hop
	name = "\proper l'oreillette du chef du personnel"
	desc = "L'oreillette de la personne qui sera un jour capitaine."
	icon_state = "com_headset"
	worn_icon_state = "com_headset"
	keyslot = /obj/item/encryptionkey/heads/hop

/obj/item/radio/headset/heads/qm
	name = "\proper oreillette du quartier-maître"
	desc = "L'oreillette de la personne qui gère le département de la logistique."
	icon_state = "com_headset"
	worn_icon_state = "com_headset"
	keyslot = /obj/item/encryptionkey/heads/qm

/obj/item/radio/headset/headset_cargo
	name = "oreillette de la logistique"
	desc = "Une oreillette utilisée par les esclaves du QM."
	icon_state = "cargo_headset"
	worn_icon_state = "cargo_headset"
	keyslot = /obj/item/encryptionkey/headset_cargo

/obj/item/radio/headset/headset_cargo/mining
	name = "oreillette de mineur"
	desc = "Une oreillette utilisée par les mineurs."
	icon_state = "mine_headset"
	worn_icon_state = "mine_headset"
	// "puts the antenna down" while the headset is off
	overlay_speaker_idle = "headset_up"
	overlay_mic_idle = "headset_up"
	keyslot = /obj/item/encryptionkey/headset_mining

/obj/item/radio/headset/headset_srv
	name = "oreillette du service"
	desc = "Oreiilette utilisée par le personnel de service, chargé de garder la station pleine, heureuse et propre."
	icon_state = "srv_headset"
	worn_icon_state = "srv_headset"
	keyslot = /obj/item/encryptionkey/headset_service

/obj/item/radio/headset/headset_cent
	name = "\improper oreillette de CentCom"
	desc = "Une oreillette utilisée par les échelons supérieurs de Nanotrasen."
	icon_state = "cent_headset"
	worn_icon_state = "cent_headset"
	keyslot = /obj/item/encryptionkey/headset_cent
	keyslot2 = /obj/item/encryptionkey/headset_com

/obj/item/radio/headset/headset_cent/empty
	keyslot = null
	keyslot2 = null

/obj/item/radio/headset/headset_cent/commander
	keyslot2 = /obj/item/encryptionkey/heads/captain

/obj/item/radio/headset/headset_cent/alt
	name = "\improper oreillette de CentCom bowman"
	desc = "Une oreillette spécialement conçue pour le personnel de réponse d'urgence. Protège les oreilles des flashbangs."
	icon_state = "cent_headset_alt"
	worn_icon_state = "cent_headset_alt"
	keyslot2 = null

/obj/item/radio/headset/headset_cent/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/silicon/pai
	name = "\proper mini Transmetteur Subspatial Intégré "
	subspace_transmission = FALSE


/obj/item/radio/headset/silicon/ai
	name = "\proper Transmetteur Subspatial Intégré "
	keyslot2 = new /obj/item/encryptionkey/ai
	command = TRUE

/obj/item/radio/headset/screwdriver_act(mob/living/user, obj/item/tool)
	user.set_machine(src)
	if(keyslot || keyslot2)
		for(var/ch_name in channels)
			SSradio.remove_object(src, GLOB.radiochannels[ch_name])
			secure_radio_connections[ch_name] = null

		if(keyslot)
			user.put_in_hands(keyslot)
			keyslot = null
		if(keyslot2)
			user.put_in_hands(keyslot2)
			keyslot2 = null

		recalculateChannels()
		to_chat(user, span_notice("Vous placez la clés d'encryption dans l'oreillette."))

	else
		to_chat(user, span_warning("Cette oreillette n'a pas de clé d'encryption unique! Quelle inutilité..."))
	tool.play_tool_sound(src, 10)
	return TRUE

/obj/item/radio/headset/attackby(obj/item/W, mob/user, params)
	user.set_machine(src)

	if(istype(W, /obj/item/encryptionkey))
		if(keyslot && keyslot2)
			to_chat(user, span_warning("Cette oreillette ne peut pas contenir une autre clé !"))
			return

		if(!keyslot)
			if(!user.transferItemToLoc(W, src))
				return
			keyslot = W

		else
			if(!user.transferItemToLoc(W, src))
				return
			keyslot2 = W


		recalculateChannels()
	else
		return ..()

/obj/item/radio/headset/recalculateChannels()
	. = ..()
	if(keyslot2)
		for(var/ch_name in keyslot2.channels)
			if(!(ch_name in src.channels))
				LAZYSET(channels, ch_name, keyslot2.channels[ch_name])

		if(keyslot2.translate_binary)
			translate_binary = TRUE
		if(keyslot2.syndie)
			syndie = TRUE
		if(keyslot2.independent)
			independent = TRUE

		for(var/ch_name in channels)
			secure_radio_connections[ch_name] = add_radio(src, GLOB.radiochannels[ch_name])

	var/list/old_language_list = language_list?.Copy()
	language_list = list()
	if(keyslot?.translated_language)
		language_list += keyslot.translated_language
	if(keyslot2?.translated_language)
		language_list += keyslot2.translated_language

	// If we're equipped on a mob, we should make sure all the languages
	// learned from our installed key chips are all still accurate
	var/mob/mob_loc = loc
	if(istype(mob_loc) && mob_loc.get_item_by_slot(slot_flags) == src)
		// Remove all the languages we may not be able to know anymore
		for(var/language in old_language_list)
			mob_loc.remove_language(language, understood = TRUE, spoken = FALSE, source = LANGUAGE_RADIOKEY)

		// And grant all the languages we definitely should know now
		grant_headset_languages(mob_loc)

/obj/item/radio/headset/AltClick(mob/living/user)
	if(!istype(user) || !Adjacent(user) || user.incapacitated())
		return
	if (command)
		use_command = !use_command
		to_chat(user, span_notice("Vous changez l'état du mode volume fort [use_command ? "on" : "off"]."))
