//predominantly positive traits
//this file is named weirdly so that positive traits are listed above negative ones

/datum/quirk/alcohol_tolerance
	name = "Tolérance à l'alcool"
	desc = "Vous mettez plus de temps à ressentir les effets de l'alcool"
	icon = FA_ICON_BEER
	value = 4
	mob_trait = TRAIT_ALCOHOL_TOLERANCE
	gain_text = span_notice("Vous sentez que vous pourriez boire un tonneau entier!")
	lose_text = span_danger("Vous sentez que vous ne tenez plus aussi bien l'alcool.")
	medical_record_text = "Le patient démontre une forte résistance a l'alcool."
	mail_goodies = list(/obj/item/skillchip/wine_taster)

/datum/quirk/apathetic
	name = "Adiaphorie"
	desc = "Vous éprouvez une indifférence à ce qui vous entoure. Un point positif dans un endroit comme ceci, je suppose."
	icon = FA_ICON_MEH
	value = 4
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	medical_record_text = "Le patient s'est vu proposé le Test d'Evaluation de l'Adiaphorie mais ne s'est pas embêté à le traduire."
	mail_goodies = list(/obj/item/hourglass)

/datum/quirk/apathetic/add(client/client_source)
	quirk_holder.mob_mood?.mood_modifier -= 0.2

/datum/quirk/apathetic/remove()
	quirk_holder.mob_mood?.mood_modifier += 0.2

/datum/quirk/drunkhealing
	name = "Drunken Resilience"
	desc = "Rien ne vous plaît plus que la sensation d'ivresse. Quand vous êtes ivre, vous récupérez lentement de vos blessures."
	icon = FA_ICON_WINE_BOTTLE
	value = 8
	gain_text = span_notice("You feel like a drink would do you good.")
	lose_text = span_danger("You no longer feel like drinking would ease your pain.")
	medical_record_text = "Patient has unusually efficient liver metabolism and can slowly regenerate wounds by drinking alcoholic beverages."
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES
	mail_goodies = list(/obj/effect/spawner/random/food_or_drink/booze)

/datum/quirk/drunkhealing/process(seconds_per_tick)
	switch(quirk_holder.get_drunk_amount())
		if (6 to 40)
			quirk_holder.adjustBruteLoss(-0.1 * seconds_per_tick, FALSE, required_bodytype = BODYTYPE_ORGANIC)
			quirk_holder.adjustFireLoss(-0.05 * seconds_per_tick, required_bodytype = BODYTYPE_ORGANIC)
		if (41 to 60)
			quirk_holder.adjustBruteLoss(-0.4 * seconds_per_tick, FALSE, required_bodytype = BODYTYPE_ORGANIC)
			quirk_holder.adjustFireLoss(-0.2 * seconds_per_tick, required_bodytype = BODYTYPE_ORGANIC)
		if (61 to INFINITY)
			quirk_holder.adjustBruteLoss(-0.8 * seconds_per_tick, FALSE, required_bodytype = BODYTYPE_ORGANIC)
			quirk_holder.adjustFireLoss(-0.4 * seconds_per_tick, required_bodytype = BODYTYPE_ORGANIC)

/datum/quirk/empath
	name = "Empathie"
	desc = "Que ce soir un sixième sense ou une étude attentive du language corporel, ca ne vous prends qu'un regard pour comprendre les ressentiments d'une personne."
	icon = FA_ICON_SMILE_BEAM
	value = 8
	mob_trait = TRAIT_EMPATH
	gain_text = span_notice("Vous vous sentez connecté aux gens autour de vous.")
	lose_text = span_danger("Vous vous sentez isolé des autres.")
	medical_record_text = "Le patient est très réceptif aux stimulus sociaux. Tests approfondis nécessaires."
	mail_goodies = list(/obj/item/toy/foamfinger)

/datum/quirk/item_quirk/clown_enjoyer
	name = "Fan des clowns"
	desc = "Vous adorez les clowns et vous gagnez un bonus d'humeur en portant votre pin's de clown."
	icon = FA_ICON_MAP_PIN
	value = 2
	mob_trait = TRAIT_CLOWN_ENJOYER
	gain_text = span_notice("You are a big enjoyer of clowns.")
	lose_text = span_danger("The clown doesn't seem so great.")
	medical_record_text = "Patient reports being a big enjoyer of clowns."
	mail_goodies = list(
		/obj/item/bikehorn,
		/obj/item/stamp/clown,
		/obj/item/megaphone/clown,
		/obj/item/clothing/shoes/clown_shoes,
		/obj/item/bedsheet/clown,
		/obj/item/clothing/mask/gas/clown_hat,
		/obj/item/storage/backpack/clown,
		/obj/item/storage/backpack/duffelbag/clown,
		/obj/item/toy/crayon/rainbow,
		/obj/item/toy/figure/clown,
	)

/datum/quirk/item_quirk/clown_enjoyer/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/accessory/clown_enjoyer_pin, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/clown_enjoyer/add(client/client_source)
	var/datum/atom_hud/fan = GLOB.huds[DATA_HUD_FAN]
	fan.show_to(quirk_holder)

/datum/quirk/item_quirk/mime_fan
	name = "Fan des mimes"
	desc = "Vous adorez les mimes et vous gagnez un bonus d'humeur en portant votre pin's de mime."
	icon = FA_ICON_THUMBTACK
	value = 2
	mob_trait = TRAIT_MIME_FAN
	gain_text = span_notice("You are a big fan of the Mime.")
	lose_text = span_danger("The mime doesn't seem so great.")
	medical_record_text = "Patient reports being a big fan of mimes."
	mail_goodies = list(
		/obj/item/toy/crayon/mime,
		/obj/item/clothing/mask/gas/mime,
		/obj/item/storage/backpack/mime,
		/obj/item/clothing/under/rank/civilian/mime,
		/obj/item/reagent_containers/cup/glass/bottle/bottleofnothing,
		/obj/item/stamp/mime,
		/obj/item/storage/box/survival/hug/black,
		/obj/item/bedsheet/mime,
		/obj/item/clothing/shoes/sneakers/mime,
		/obj/item/toy/figure/mime,
		/obj/item/toy/crayon/spraycan/mimecan,
	)

/datum/quirk/item_quirk/mime_fan/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/accessory/mime_fan_pin, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/mime_fan/add(client/client_source)
	var/datum/atom_hud/fan = GLOB.huds[DATA_HUD_FAN]
	fan.show_to(quirk_holder)

/datum/quirk/freerunning
	name = "Coureur de marathon"
	desc = "Vous êtes agile et rapide! Vous pouvez escalader les tables plus rapidement et vous ne prenez pas de dégât de chute d'une faible hauteur."
	icon = FA_ICON_RUNNING
	value = 8
	mob_trait = TRAIT_FREERUNNING
	gain_text = span_notice("You feel lithe on your feet!")
	lose_text = span_danger("You feel clumsy again.")
	medical_record_text = "Patient scored highly on cardio tests."
	mail_goodies = list(/obj/item/melee/skateboard, /obj/item/clothing/shoes/wheelys/rollerskates)

/datum/quirk/friendly
	name = "Amical"
	desc = "Vous donnez les meilleurs câlins, surtout quand vous êtes dans une bonne humeur."
	icon = FA_ICON_HANDS_HELPING
	value = 2
	mob_trait = TRAIT_FRIENDLY
	gain_text = span_notice("You want to hug someone.")
	lose_text = span_danger("You no longer feel compelled to hug others.")
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	medical_record_text = "Patient demonstrates low-inhibitions for physical contact and well-developed arms. Requesting another doctor take over this case."
	mail_goodies = list(/obj/item/storage/box/hug)

/datum/quirk/jolly
	name = "Heureux"
	desc = "Vous vous sentez parfois juste heureux, sans raison particulière."
	icon = FA_ICON_GRIN
	value = 4
	mob_trait = TRAIT_JOLLY
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	medical_record_text = "Patient demonstrates constant euthymia irregular for environment. It's a bit much, to be honest."
	mail_goodies = list(/obj/item/clothing/mask/joy)

/datum/quirk/light_step
	name = "Pas légers"
	desc = "Vous marchez d'un pas léger; marcher sur des objets pointus fais moins de bruit et moins mal. De plus, vos mains et vêtements ne seront pas tachés dans le cas où vous marchez sur du sang."
	icon = FA_ICON_SHOE_PRINTS
	value = 4
	mob_trait = TRAIT_LIGHT_STEP
	gain_text = span_notice("You walk with a little more litheness.")
	lose_text = span_danger("You start tromping around like a barbarian.")
	medical_record_text = "Patient's dexterity belies a strong capacity for stealth."
	mail_goodies = list(/obj/item/clothing/shoes/sandal)

/datum/quirk/item_quirk/musician
	name = "Musicien"
	desc = "Vous pouvez modifier des intruments tenus à la main pour jouer des mélodies qui chassent certains effets négatifs et apaisent l'âme."
	icon = FA_ICON_GUITAR
	value = 2
	mob_trait = TRAIT_MUSICIAN
	gain_text = span_notice("You know everything about musical instruments.")
	lose_text = span_danger("You forget how musical instruments work.")
	medical_record_text = "Patient brain scans show a highly-developed auditory pathway."
	mail_goodies = list(/obj/effect/spawner/random/entertainment/musical_instrument, /obj/item/instrument/piano_synth/headphones)

/datum/quirk/item_quirk/musician/add_unique(client/client_source)
	give_item_to_holder(/obj/item/choice_beacon/music, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/night_vision
	name = "Nyctalope"
	desc = "Vous voyez mieux dans le noir comparé à certaines personnes."
	icon = FA_ICON_MOON
	value = 4
	mob_trait = TRAIT_NIGHT_VISION
	gain_text = span_notice("The shadows seem a little less dark.")
	lose_text = span_danger("Everything seems a little darker.")
	medical_record_text = "Patient's eyes show above-average acclimation to darkness."
	mail_goodies = list(
		/obj/item/flashlight/flashdark,
		/obj/item/food/grown/mushroom/glowshroom/shadowshroom,
		/obj/item/skillchip/light_remover,
	)

/datum/quirk/night_vision/add(client/client_source)
	refresh_quirk_holder_eyes()

/datum/quirk/night_vision/remove()
	refresh_quirk_holder_eyes()

/datum/quirk/night_vision/proc/refresh_quirk_holder_eyes()
	var/mob/living/carbon/human/human_quirk_holder = quirk_holder
	var/obj/item/organ/internal/eyes/eyes = human_quirk_holder.get_organ_by_type(/obj/item/organ/internal/eyes)
	if(!eyes || eyes.lighting_cutoff)
		return
	// We've either added or removed TRAIT_NIGHT_VISION before calling this proc. Just refresh the eyes.
	eyes.refresh()

/datum/quirk/item_quirk/poster_boy
	name = "Fan de posters"
	desc = "Vous avez de beaux posters! Arrcohez les pour que tout le monde passe un bon moment."
	icon = FA_ICON_TAPE
	value = 4
	mob_trait = TRAIT_POSTERBOY
	medical_record_text = "Patient reports a desire to cover walls with homemade objects."
	mail_goodies = list(/obj/item/poster/random_official)

/datum/quirk/item_quirk/poster_boy/add_unique()
	var/mob/living/carbon/human/posterboy = quirk_holder
	var/obj/item/storage/box/posterbox/newbox = new()
	newbox.add_quirk_posters(posterboy.mind)
	give_item_to_holder(newbox, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/obj/item/storage/box/posterbox
	name = "Boîte de posters"
	desc = "Vous les avez fait vous même!"

/// fills box of posters based on job, one neutral poster and 2 department posters
/obj/item/storage/box/posterbox/proc/add_quirk_posters(datum/mind/posterboy)
	new /obj/item/poster/quirk/crew/random(src)
	var/department = posterboy.assigned_role.paycheck_department
	if(department == ACCOUNT_CIV) //if you are not part of a department you instead get 3 neutral posters
		for(var/i in 1 to 2)
			new /obj/item/poster/quirk/crew/random(src)
		return
	for(var/obj/item/poster/quirk/potential_poster as anything in subtypesof(/obj/item/poster/quirk))
		if(initial(potential_poster.quirk_poster_department) != department)
			continue
		new potential_poster(src)

/datum/quirk/selfaware
	name = "Pleinement conscient"
	desc = "Vous connaissez votre corps par coeur, et vous pouvez ressentir chaque blessure précisément."
	icon = FA_ICON_BONE
	value = 8
	mob_trait = TRAIT_SELF_AWARE
	medical_record_text = "Patient demonstrates an uncanny knack for self-diagnosis."
	mail_goodies = list(/obj/item/clothing/neck/stethoscope, /obj/item/skillchip/entrails_reader)

/datum/quirk/skittish
	name = "Peureux"
	desc = "Vous êtes facile a effrayer, et vous cachez souvent. Courez dans un casier pour vous réfugiez dedans (tant que vous y avez accès), marchez pour éviter cela."
	icon = FA_ICON_TRASH
	value = 8
	mob_trait = TRAIT_SKITTISH
	medical_record_text = "Patient demonstrates a high aversion to danger and has described hiding in containers out of fear."
	mail_goodies = list(/obj/structure/closet/cardboard)

/datum/quirk/item_quirk/spiritual
	name = "Croyant"
	desc = "Vous avez des croyances, que ce soir vers Dieu, la nature ou les arcanes de cet univers. Vous êtes rassurés par la présence des hommes de foi, et êtes persuadé que vos prières sont plus spéciales que les autres. Traîner dans la chapelle vous rend heureux."
	icon = FA_ICON_BIBLE
	value = 4
	mob_trait = TRAIT_SPIRITUAL
	gain_text = span_notice("You have faith in a higher power.")
	lose_text = span_danger("You lose faith!")
	medical_record_text = "Patient reports a belief in a higher power."
	mail_goodies = list(
		/obj/item/storage/book/bible/booze,
		/obj/item/reagent_containers/cup/glass/bottle/holywater,
		/obj/item/bedsheet/chaplain,
		/obj/item/toy/cards/deck/tarot,
		/obj/item/storage/fancy/candle_box,
	)

/datum/quirk/item_quirk/spiritual/add_unique(client/client_source)
	give_item_to_holder(/obj/item/storage/fancy/candle_box, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
	give_item_to_holder(/obj/item/storage/box/matches, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/tagger
	name = "Artiste de rue"
	desc = "Vous êtes un artiste de rue expérimenté. Les gens seront impressionés par vos graffitis, et vous tirez mieux profit de vos matériel de dessin de rue."
	icon = FA_ICON_SPRAY_CAN
	value = 4
	mob_trait = TRAIT_TAGGER
	gain_text = span_notice("You know how to tag walls efficiently.")
	lose_text = span_danger("You forget how to tag walls properly.")
	medical_record_text = "Patient was recently seen for possible paint huffing incident."
	mail_goodies = list(
		/obj/item/toy/crayon/spraycan,
		/obj/item/canvas/nineteen_nineteen,
		/obj/item/canvas/twentythree_nineteen,
		/obj/item/canvas/twentythree_twentythree
	)

/datum/quirk/item_quirk/tagger/add_unique(client/client_source)
	var/obj/item/toy/crayon/spraycan/can = new
	can.set_painting_tool_color(client_source?.prefs.read_preference(/datum/preference/color/paint_color))
	give_item_to_holder(can, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/throwingarm
	name = "Ancien joueur de baseball"
	desc = "Vous avez de la force dans les bras. Les objets que vous jetez vont plus loin et ne ratent jamais leur cible."
	icon = FA_ICON_BASEBALL
	value = 7
	mob_trait = TRAIT_THROWINGARM
	gain_text = span_notice("Your arms are full of energy!")
	lose_text = span_danger("Your arms ache a bit.")
	medical_record_text = "Patient displays mastery over throwing balls."
	mail_goodies = list(/obj/item/toy/beach_ball/baseball, /obj/item/toy/basketball, /obj/item/toy/dodgeball)

/datum/quirk/voracious
	name = "Vorace"
	desc = "Rien ne s'interpose entre vous et votre nourriture. Vous mangez plus vite et vous jetez sur la malbouffe. Être en surpoid vous sied bien."
	icon = FA_ICON_DRUMSTICK_BITE
	value = 4
	mob_trait = TRAIT_VORACIOUS
	gain_text = span_notice("You feel HONGRY.")
	lose_text = span_danger("You no longer feel HONGRY.")
	mail_goodies = list(/obj/effect/spawner/random/food_or_drink/dinner)

/datum/quirk/item_quirk/signer
	name = "Signant"
	desc = "Vous savez parler en langue des signes."
	icon = FA_ICON_HANDS
	value = 4
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_CHANGES_APPEARANCE
	mail_goodies = list(/obj/item/clothing/gloves/radio)

/datum/quirk/item_quirk/signer/add_unique(client/client_source)
	quirk_holder.AddComponent(/datum/component/sign_language)
	var/obj/item/clothing/gloves/gloves_type = /obj/item/clothing/gloves/radio
	if(isplasmaman(quirk_holder))
		gloves_type = /obj/item/clothing/gloves/color/plasmaman/radio
	give_item_to_holder(gloves_type, list(LOCATION_GLOVES = ITEM_SLOT_GLOVES, LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/signer/remove()
	qdel(quirk_holder.GetComponent(/datum/component/sign_language))
