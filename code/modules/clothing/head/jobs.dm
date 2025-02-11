//defines the drill hat's yelling setting
#define DRILL_DEFAULT "default"
#define DRILL_SHOUTING "shouting"
#define DRILL_YELLING "yelling"
#define DRILL_CANADIAN "canadian"

//Chef
/obj/item/clothing/head/utility/chefhat
	name = "chapeau de patron"
	inhand_icon_state = "chefhat"
	icon_state = "chef"
	desc = "Le chapeau du commandant en chef."
	strip_delay = 10
	equip_delay_other = 10

	dog_fashion = /datum/dog_fashion/head/chef
	///the chance that the movements of a mouse inside of this hat get relayed to the human wearing the hat
	var/mouse_control_probability = 20

/obj/item/clothing/head/utility/chefhat/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/chefhat)

/obj/item/clothing/head/utility/chefhat/i_am_assuming_direct_control
	desc = "Le chapeau du commande en chef. En y regardant de plus près, il semble y avoir des douzaines de petits leviers, boutons, cadrans et écrans à l'intérieur de ce chapeau. Qu'est-ce que c'est que ce bordel...?"
	mouse_control_probability = 100

/obj/item/clothing/head/utility/chefhat/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] est entrain de porter le [src] ! Il semble que [user.p_theyre()] essaye de se suicider."))
	user.say("Bork Bork Bork!", forced = "suicide du chapeau de commandant en chef")
	sleep(2 SECONDS)
	user.visible_message(span_suicide("[user] monte dans un four imaginaire !"))
	user.say("BOOORK!", forced = "suicide du chapeau de commandant en chef")
	playsound(user, 'sound/machines/ding.ogg', 50, TRUE)
	return FIRELOSS

/obj/item/clothing/head/utility/chefhat/relaymove(mob/living/user, direction)
	if(!ismouse(user) || !isliving(loc) || !prob(mouse_control_probability))
		return
	var/mob/living/L = loc
	if(L.incapacitated(IGNORE_RESTRAINTS)) //just in case
		return
	step_towards(L, get_step(L, direction))

//Captain
/obj/item/clothing/head/hats/caphat
	name = "chapeau du capitaine"
	desc = "C'est bon d'être roi."
	icon_state = "captain"
	inhand_icon_state = "that"
	flags_inv = 0
	armor_type = /datum/armor/hats_caphat
	strip_delay = 60
	dog_fashion = /datum/dog_fashion/head/captain

//Captain: This is no longer space-worthy
/datum/armor/hats_caphat
	melee = 25
	bullet = 15
	laser = 25
	energy = 35
	bomb = 25
	fire = 50
	acid = 50
	wound = 5

/obj/item/clothing/head/hats/caphat/parade
	name = "chapeau de parade du capitaine"
	desc = "Porté uniquement par des capitaines extrêmement classieux."
	icon_state = "capcap"
	dog_fashion = null

/obj/item/clothing/head/caphat/beret
	name = "béret du capitaine"
	desc = "Pour les capitaines connus pour leur sens de la mode."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#0070B7#FFCE5B"

//Head of Personnel
/obj/item/clothing/head/hats/hopcap
	name = "casquette du chef du personnel"
	icon_state = "hopcap"
	desc = "Le symbole d'un vrai micromanagement bureaucratique."
	armor_type = /datum/armor/hats_hopcap
	dog_fashion = /datum/dog_fashion/head/hop

//Chaplain
/datum/armor/hats_hopcap
	melee = 25
	bullet = 15
	laser = 25
	energy = 35
	bomb = 25
	fire = 50
	acid = 50

/obj/item/clothing/head/chaplain/nun_hood
	name = "capuche de nonne"
	desc = "Piété maximale dans ce système stellaire."
	icon_state = "nun_hood"
	flags_inv = HIDEHAIR
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/chaplain/bishopmitre
	name = "chapeau de l'évêque"
	desc = "Un chapeau opulent qui fonctionne comme une radio vers Dieu. Ou comme un paratonnerre, selon qui vous demandez."
	icon_state = "bishopmitre"

//Detective
/obj/item/clothing/head/fedora/det_hat
	name = "fedora de détective"
	desc = "Il y'a seulement qu'une personne qui peut sentir la puanteur de la saleté du crime, et elle porte probablement ce chapeau."
	armor_type = /datum/armor/fedora_det_hat
	icon_state = "detective"
	inhand_icon_state = "det_hat"
	var/candy_cooldown = 0
	dog_fashion = /datum/dog_fashion/head/detective
	///Path for the flask that spawns inside their hat roundstart
	var/flask_path = /obj/item/reagent_containers/cup/glass/flask/det

/datum/armor/fedora_det_hat
	melee = 25
	bullet = 5
	laser = 25
	energy = 35
	fire = 30
	acid = 50
	wound = 5

/obj/item/clothing/head/fedora/det_hat/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/small/fedora/detective)

	new flask_path(src)

/obj/item/clothing/head/fedora/det_hat/examine(mob/user)
	. = ..()
	. += span_notice("Alt-clique pour prendre le bonbon.")

/obj/item/clothing/head/fedora/det_hat/AltClick(mob/user)
	. = ..()
	if(loc != user || !user.can_perform_action(src, NEED_DEXTERITY|NEED_HANDS))
		return
	if(candy_cooldown < world.time)
		var/obj/item/food/candy_corn/CC = new /obj/item/food/candy_corn(src)
		user.put_in_hands(CC)
		to_chat(user, span_notice("Vous placez un bonbon dans votre chapeau."))
		candy_cooldown = world.time+1200
	else
		to_chat(user, span_warning("Vous venez de prendre un bonbon ! Vous devriez attendre quelques minutes, sinon vous allez vider votre stock."))

/obj/item/clothing/head/fedora/det_hat/minor
	flask_path = /obj/item/reagent_containers/cup/glass/flask/det/minor

//Mime
/obj/item/clothing/head/beret
	name = "béret"
	desc = "Un béret, le couvre-chef préféré des mimes."
	icon_state = "beret"
	dog_fashion = /datum/dog_fashion/head/beret
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#972A2A"
	flags_1 = IS_PLAYER_COLORABLE_1

//Security
/obj/item/clothing/head/hats/hos
	name = "chapeau de chef de la sécurité générique"
	desc = "Veuillez contacter le département de costumage de Nanotrasen si trouvé."
	armor_type = /datum/armor/hats_hos
	strip_delay = 8 SECONDS

/obj/item/clothing/head/hats/hos/cap
	name = "casquette du chef de la sécurité"
	desc = "Une casquette robuste pour le chef de la sécurité, pour montrer aux officiers qui est le patron."
	icon_state = "hoscap"

/datum/armor/hats_hos
	melee = 40
	bullet = 30
	laser = 25
	energy = 35
	bomb = 25
	bio = 10
	fire = 50
	acid = 60
	wound = 10

/obj/item/clothing/head/hats/hos/cap/syndicate
	name = "casquette du syndicat"
	desc = "Une casquette noire pour un officier de haut rang du syndicat."

/obj/item/clothing/head/hats/hos/shako
	name = "shako solide"
	desc = "Portez ceci vous donne envie de crier \"À terre et faites moi 20 pompes !\" à quelqu'un."
	icon_state = "hosshako"
	worn_icon = 'icons/mob/large-worn-icons/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/hats/hos/beret
	name = "béret du chef de la sécurité"
	desc = "Un béret robuste pour le chef de la sécurité, pour avoir du style sans sacrifier la protection."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#39393f#f0cc8f"

/obj/item/clothing/head/hats/hos/beret/navyhos
	name = "bérêt formel du chef de la sécurité"
	desc = "Un béret spécial avec l'insigne du chef de la sécurité dessus. Un symbole d'excellence, un badge de courage, une marque de distinction."
	greyscale_colors = "#638799#f0cc8f"

/obj/item/clothing/head/hats/hos/beret/syndicate
	name = "béret du syndicat"
	desc = "Un béret noir avec un rembourrage d'armure épais à l'intérieur. Élégant et robuste."

/obj/item/clothing/head/hats/warden
	name = "chapeau de police du gardien"
	desc = "Un chapeau spécial pour le gardien de la sécurité. Protège la tête des impacts."
	icon_state = "policehelm"
	armor_type = /datum/armor/hats_warden
	strip_delay = 60
	dog_fashion = /datum/dog_fashion/head/warden

/datum/armor/hats_warden
	melee = 40
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 30
	acid = 60
	wound = 6

/obj/item/clothing/head/hats/warden/police
	name = "chapeau d'officier de police"
	desc = "Un chapeau de policer. Ce chapeau vous donne l'air de dire que vous êtes LA LOI."

/obj/item/clothing/head/hats/warden/red
	name = "chapeau du gardien"
	desc = "Un chapeau rouge pour le gardien. Le regarder vous donnes envie de placer des gens en cellules aussi longtemps que possible."
	icon_state = "wardenhat"
	armor_type = /datum/armor/warden_red
	strip_delay = 60
	dog_fashion = /datum/dog_fashion/head/warden_red

/datum/armor/warden_red
	melee = 40
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 30
	acid = 60
	wound = 6

/obj/item/clothing/head/hats/warden/drill
	name = "chapeau de campagne du gardien"
	desc = "Un chapeau de campagne spécial avec l'insigne de la sécurité dessus. Utilise un tissu renforcé pour offrir une protection suffisante."
	icon_state = "wardendrill"
	inhand_icon_state = null
	dog_fashion = null
	var/mode = DRILL_DEFAULT

/obj/item/clothing/head/hats/warden/drill/screwdriver_act(mob/living/carbon/human/user, obj/item/I)
	if(..())
		return TRUE
	switch(mode)
		if(DRILL_DEFAULT)
			to_chat(user, span_notice("Vous réglez le circuit vocal sur la position médiane."))
			mode = DRILL_SHOUTING
		if(DRILL_SHOUTING)
			to_chat(user, span_notice("Vous réglez le circuit vocal sur la dernière position."))
			mode = DRILL_YELLING
		if(DRILL_YELLING)
			to_chat(user, span_notice("Vous réglez le circuit vocal sur la première position."))
			mode = DRILL_DEFAULT
		if(DRILL_CANADIAN)
			to_chat(user, span_danger("Vous réglez le circuit vocal, mais rien ne se passe, probablement parce qu'il est cassé."))
	return TRUE

/obj/item/clothing/head/hats/warden/drill/wirecutter_act(mob/living/user, obj/item/I)
	..()
	if(mode != DRILL_CANADIAN)
		to_chat(user, span_danger("Vous avez cassé le circuit vocal !"))
		mode = DRILL_CANADIAN
	return TRUE

/obj/item/clothing/head/hats/warden/drill/equipped(mob/M, slot)
	. = ..()
	if (slot & ITEM_SLOT_HEAD)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/head/hats/warden/drill/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/head/hats/warden/drill/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		switch (mode)
			if(DRILL_SHOUTING)
				message += "!"
			if(DRILL_YELLING)
				message += "!!"
			if(DRILL_CANADIAN)
				message = "[message]"
				var/list/canadian_words = strings("canadian_replacement.json", "canadian")

				for(var/key in canadian_words)
					var/value = canadian_words[key]
					if(islist(value))
						value = pick(value)

					message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
					message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
					message = replacetextEx(message, " [key]", " [value]")

				if(prob(30))
					message += pick(", eh ?", ", EH ?")
		speech_args[SPEECH_MESSAGE] = message

/obj/item/clothing/head/beret/sec
	name = "béret de sécurité"
	desc = "Un béret robuste avec l'insigne de la sécurité dessus. Utilise un tissu renforcé pour offrir une protection suffisante."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#a52f29#F2F2F2"
	armor_type = /datum/armor/beret_sec
	strip_delay = 60
	dog_fashion = null
	flags_1 = NONE

/datum/armor/beret_sec
	melee = 35
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 20
	acid = 50
	wound = 4

/obj/item/clothing/head/beret/sec/navywarden
	name = "béret du gardien"
	desc = "Un béret spécial avec l'insigne du gardien dessus. Pour les gardiens avec de la classe."
	greyscale_colors = "#638799#ebebeb"
	strip_delay = 60

/obj/item/clothing/head/beret/sec/navyofficer
	desc = "Un béret spécial avec l'insigne de la sécurité dessus. Pour les officiers avec de la classe."
	greyscale_colors = "#638799#a52f29"

//Science
/obj/item/clothing/head/beret/science
	name = "béret de science"
	desc = "Un bérêt pour les scientifiques qui veulent être à la mode."
	greyscale_colors = "#8D008F"
	flags_1 = NONE

/obj/item/clothing/head/beret/science/rd
	desc = "Un badge violet avec l'insigne du directeur de la recherche attaché. Pour le bureaucrate en vous!"
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#7e1980#c9cbcb"

//Medical
/obj/item/clothing/head/beret/medical
	name = "béret médical"
	desc = "Un béret médical pour le médecin en vous !"
	greyscale_colors = "#FFFFFF"
	flags_1 = NONE

/obj/item/clothing/head/beret/medical/paramedic
	name = "béret de secouriste"
	desc = "Pour trouver des cadavres avec style !"
	greyscale_colors = "#16313D"

/obj/item/clothing/head/beret/medical/cmo
	name = "béret du médecin-chef"
	desc = "Un béret médical pour le médecin-chef en vous !"
	greyscale_colors = "#5EB8B8"

/obj/item/clothing/head/utility/surgerycap
	name = "bandana de chirurgie bleu"
	icon_state = "surgicalcap"
	desc = "Un bandana médical bleu pour empêcher les cheveux du chirurgien d'entrer dans les entrailles du patient!"

/obj/item/clothing/head/utility/surgerycap/purple
	name = "bandana de chirurgie pourpre"
	icon_state = "surgicalcapwine"
	desc = "Un bandana médical pourpre pour empêcher les cheveux du chirurgien d'entrer dans les entrailles du patient!"

/obj/item/clothing/head/utility/surgerycap/green
	name = "bandana de chirurgie vert"
	icon_state = "surgicalcapgreen"
	desc = "Un bandana médical vert pour empêcher les cheveux du chirurgien d'entrer dans les entrailles du patient!"

/obj/item/clothing/head/utility/surgerycap/cmo
	name = "bandana de chirurgie turquoise"
	icon_state = "surgicalcapcmo"
	desc = "Le bandana médical du CMO pour empêcher ses cheveux d'entrer dans les entrailles du patient!"

//Engineering
/obj/item/clothing/head/beret/engi
	name = "béret d'ingénieur"
	desc = "Il ne vous protégera peut-être pas des radiations, mais il vous protégera certainement contre le fait d'être démodé !"
	greyscale_colors = "#FFBC30"
	flags_1 = NONE

//Cargo
/obj/item/clothing/head/beret/cargo
	name = "béret de la logistique"
	desc = "Pas besoin de compenser quand vous pouvez porter ce béret !" //cargo petit bite ?
	greyscale_colors = "#c99840"
	flags_1 = NONE

//Curator
/obj/item/clothing/head/fedora/curator
	name = "fedora de chasseur de trésor"
	desc = "Vous avez du texte rouge aujourd'hui, gamin, mais ça ne veut pas dire que vous devez l'aimer."
	icon_state = "curator"

/obj/item/clothing/head/beret/durathread
	name = "béret en Fildurable"
	desc = "Un bérêt fait de Fildurable, ses fibres résilientes offrent une certaine protection à celui qui le porte."
	icon_state = "beret_badge"
	icon_preview = 'icons/obj/previews.dmi'
	icon_state_preview = "beret_durathread"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#C5D4F3#ECF1F8"
	armor_type = /datum/armor/beret_durathread

/datum/armor/beret_durathread
	melee = 15
	bullet = 5
	laser = 15
	energy = 25
	bomb = 10
	fire = 30
	acid = 5
	wound = 4

/obj/item/clothing/head/beret/highlander
	desc = "Cette fabrique était blanche. <i>Etait.</i>"
	dog_fashion = null //THIS IS FOR SLAUGHTER, NOT PUPPIES

/obj/item/clothing/head/beret/highlander/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HIGHLANDER)

//CentCom
/obj/item/clothing/head/beret/centcom_formal
	name = "\improper bérêt formel de CentCom"
	desc = "Parfois, un compromis entre la mode et la défense doit être fait. Grâce aux dernières améliorations de la durabilité des nano-tissus de Nanotrasen, ce n'est pas le cas cette fois."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#46b946#f2c42e"
	armor_type = /datum/armor/beret_centcom_formal
	strip_delay = 10 SECONDS


#undef DRILL_DEFAULT
#undef DRILL_SHOUTING
#undef DRILL_YELLING
#undef DRILL_CANADIAN

/datum/armor/beret_centcom_formal
	melee = 80
	bullet = 80
	laser = 50
	energy = 50
	bomb = 100
	bio = 100
	fire = 100
	acid = 90
	wound = 10
