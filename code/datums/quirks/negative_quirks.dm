//predominantly negative traits

/datum/quirk/badback
	name = "Dos fragile"
	desc = "A cause de votre mauvaise posture, les sacs à dos et les autres types de sacs ne tiennent pas en place sur votre dos. Des objets au poids mieux réparti tiennent mieux."
	icon = FA_ICON_HIKING
	value = -8
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	gain_text = span_danger("Votre dos vous fait VRAIMENT mal.")
	lose_text = span_notice("Votre dos ne vous fait plus mal.")
	medical_record_text = "Le scan du patient indique des douleurs sévères et chroniques du dos."
	hardcore_value = 4
	mail_goodies = list(/obj/item/cane)
	var/datum/weakref/backpack

/datum/quirk/badback/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/storage/backpack/equipped_backpack = human_holder.back
	if(istype(equipped_backpack))
		quirk_holder.add_mood_event("back_pain", /datum/mood_event/back_pain)
		RegisterSignal(human_holder.back, COMSIG_ITEM_POST_UNEQUIP, PROC_REF(on_unequipped_backpack))
	else
		RegisterSignal(quirk_holder, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_equipped_item))

/datum/quirk/badback/remove()
	UnregisterSignal(quirk_holder, COMSIG_MOB_EQUIPPED_ITEM)

	var/obj/item/storage/equipped_backpack = backpack?.resolve()
	if(equipped_backpack)
		UnregisterSignal(equipped_backpack, COMSIG_ITEM_POST_UNEQUIP)
		quirk_holder.clear_mood_event("back_pain")

/// Signal handler for when the quirk_holder equips an item. If it's a backpack, adds the back_pain mood event.
/datum/quirk/badback/proc/on_equipped_item(mob/living/source, obj/item/equipped_item, slot)
	SIGNAL_HANDLER

	if(!(slot & ITEM_SLOT_BACK) || !istype(equipped_item, /obj/item/storage/backpack))
		return

	quirk_holder.add_mood_event("back_pain", /datum/mood_event/back_pain)
	RegisterSignal(equipped_item, COMSIG_ITEM_POST_UNEQUIP, PROC_REF(on_unequipped_backpack))
	UnregisterSignal(quirk_holder, COMSIG_MOB_EQUIPPED_ITEM)
	backpack = WEAKREF(equipped_item)

/// Signal handler for when the quirk_holder unequips an equipped backpack. Removes the back_pain mood event.
/datum/quirk/badback/proc/on_unequipped_backpack(obj/item/source, force, atom/newloc, no_move, invdrop, silent)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_ITEM_POST_UNEQUIP)
	quirk_holder.clear_mood_event("back_pain")
	backpack = null
	RegisterSignal(quirk_holder, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_equipped_item))

/datum/quirk/blooddeficiency
	name = "Hémophilie"
	desc = "Votre sang ne coagule pas correctement, vous forcant à être souvent transfusé."
	icon = FA_ICON_TINT
	value = -8
	mob_trait = TRAIT_BLOOD_DEFICIENCY
	gain_text = span_danger("Vous sentez votre vigueur s'estomper.")
	lose_text = span_notice("Vous vous sentez vigoureux de nouveaux.")
	medical_record_text = "Le patient a besoin d'un traitement régulier de transfusions sanguines à cause de pertes de sang spontanées"
	hardcore_value = 8
	quirk_flags = QUIRK_HUMAN_ONLY
	mail_goodies = list(/obj/item/reagent_containers/blood/o_minus) // universal blood type that is safe for all
	var/min_blood = BLOOD_VOLUME_SAFE - 25 // just barely survivable without treatment

/datum/quirk/blooddeficiency/post_add()
	if(!ishuman(quirk_holder))
		return

	// for making sure the roundstart species has the right blood pack sent to them
	var/mob/living/carbon/human/carbon_target = quirk_holder
	carbon_target.dna.species.update_quirk_mail_goodies(carbon_target, src)

/**
 * Makes the mob lose blood from having the blood deficiency quirk, if possible
 *
 * Arguments:
 * * seconds_per_tick
 */
/datum/quirk/blooddeficiency/proc/lose_blood(seconds_per_tick)
	if(quirk_holder.stat == DEAD)
		return

	var/mob/living/carbon/human/carbon_target = quirk_holder
	if(HAS_TRAIT(carbon_target, TRAIT_NOBLOOD) && isnull(carbon_target.dna.species.exotic_blood)) //can't lose blood if your species doesn't have any
		return

	if (carbon_target.blood_volume <= min_blood)
		return
	// Ensures that we don't reduce total blood volume below min_blood.
	carbon_target.blood_volume = max(min_blood, carbon_target.blood_volume - carbon_target.dna.species.blood_deficiency_drain_rate * seconds_per_tick)

/datum/quirk/item_quirk/blindness
	name = "Cécité"
	desc = "Vous êtes complètement aveugle, rien ne peut arranger cela."
	icon = FA_ICON_EYE_SLASH
	value = -16
	gain_text = span_danger("Vous ne pouvez rien voir.")
	lose_text = span_notice("Vous récupérez par miracle votre vision.")
	medical_record_text = "Le patient est atteint de cécité permanente."
	hardcore_value = 15
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_CHANGES_APPEARANCE
	mail_goodies = list(/obj/item/clothing/glasses/sunglasses, /obj/item/cane/white)

/datum/quirk/item_quirk/blindness/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/glasses/blindfold/white, list(LOCATION_EYES = ITEM_SLOT_EYES, LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/blindness/add(client/client_source)
	quirk_holder.become_blind(QUIRK_TRAIT)

/datum/quirk/item_quirk/blindness/remove()
	quirk_holder.cure_blind(QUIRK_TRAIT)

	/* A couple of brain tumor stats for anyone curious / looking at this quirk for balancing:
	 * - It takes less 16 minute 40 seconds to die from brain death due to a brain tumor.
	 * - It takes 1 minutes 40 seconds to take 10% (20 organ damage) brain damage.
	 * - 5u mannitol will heal 12.5% (25 organ damage) brain damage
	 */
/datum/quirk/item_quirk/brainproblems
	name = "Tumeure cérébrale"
	desc = "Vous avez un petit ami dans votre cerveau qui le détruit à petit feu. Vous feriez mieux d'ammener du mannitol !"
	icon = FA_ICON_BRAIN
	value = -12
	gain_text = span_danger("Vous sentez une douleur grossisante dans votre tête.")
	lose_text = span_notice("La douleur dans votre tête s'estombe entièrement.")
	medical_record_text = "Le patient a un tumeur dans leur cerveau qui l'entraîne doucement vers une mort cérébrale."
	hardcore_value = 12
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES
	mail_goodies = list(/obj/item/storage/pill_bottle/mannitol/braintumor)

/datum/quirk/item_quirk/brainproblems/add_unique(client/client_source)
	give_item_to_holder(
		/obj/item/storage/pill_bottle/mannitol/braintumor,
		list(
			LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
			LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
			LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
			LOCATION_HANDS = ITEM_SLOT_HANDS,
		),
		flavour_text = "Ceci vous maintiendra en vie jusqu'a ce que vous trouviez un apport régulier en médication : ne vous reposez pas trop dessus !",
	)

/datum/quirk/item_quirk/brainproblems/process(seconds_per_tick)
	if(quirk_holder.stat == DEAD)
		return

	if(HAS_TRAIT(quirk_holder, TRAIT_TUMOR_SUPPRESSED))
		return

	quirk_holder.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.2 * seconds_per_tick)

/datum/quirk/item_quirk/deafness
	name = "Surdité"
	desc = "Vous êtes définitivement sourd."
	icon = FA_ICON_DEAF
	value = -8
	mob_trait = TRAIT_DEAF
	gain_text = span_danger("Vous ne pouvez rien entendre.")
	lose_text = span_notice("Vous e^tes capable d'entendre à nouveau !")
	medical_record_text = "Le nerf cochléaire du patien est endommagé de manière irréversible."
	hardcore_value = 12
	mail_goodies = list(/obj/item/clothing/mask/whistle)

/datum/quirk/item_quirk/deafness/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/accessory/deaf_pin, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/depression
	name = "Dépressif"
	desc = "Parfois, vous haïssez juste la vie."
	icon = FA_ICON_FROWN
	mob_trait = TRAIT_DEPRESSION
	value = -3
	gain_text = span_danger("Vous commencez à vous sentir déprimé.")
	lose_text = span_notice("Vous ne vous sentez plus déprimé.") //if only it were that easy!
	medical_record_text = "Le patient est atteint d'un trouble dépressif de l'humeur, ce qui lui entraîne des épisodes de dépression."
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	hardcore_value = 2
	mail_goodies = list(/obj/item/storage/pill_bottle/happinesspsych)

/datum/quirk/item_quirk/family_heirloom
	name = "Trésor de famille"
	desc = "Vous êtes le détenteur actuel d'un trésor de famille, passé de générations en générations. Vous devez le garder en sureté !"
	icon = FA_ICON_TOOLBOX
	value = -2
	medical_record_text = "Le patient montre un attachement singulier à un trésor de famille."
	hardcore_value = 1
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES|QUIRK_MOODLET_BASED
	/// A weak reference to our heirloom.
	var/datum/weakref/heirloom
	mail_goodies = list(/obj/item/storage/secure/briefcase)

/datum/quirk/item_quirk/family_heirloom/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/heirloom_type

	// The quirk holder's species - we have a 50% chance, if we have a species with a set heirloom, to choose a species heirloom.
	var/datum/species/holder_species = human_holder.dna?.species
	if(holder_species && LAZYLEN(holder_species.family_heirlooms) && prob(50))
		heirloom_type = pick(holder_species.family_heirlooms)
	else
		// Our quirk holder's job
		var/datum/job/holder_job = human_holder.last_mind?.assigned_role
		if(holder_job && LAZYLEN(holder_job.family_heirlooms))
			heirloom_type = pick(holder_job.family_heirlooms)

	// If we didn't find an heirloom somehow, throw them a generic one
	if(!heirloom_type)
		heirloom_type = pick(/obj/item/toy/cards/deck, /obj/item/lighter, /obj/item/dice/d20)

	var/obj/new_heirloom = new heirloom_type(get_turf(human_holder))
	heirloom = WEAKREF(new_heirloom)

	give_item_to_holder(
		new_heirloom,
		list(
			LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
			LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
			LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
			LOCATION_HANDS = ITEM_SLOT_HANDS,
		),
		flavour_text = "C'est un trésor de famille passé de générations en générations. Gardez le en sûreté !",
	)

/datum/quirk/item_quirk/family_heirloom/post_add()
	var/list/names = splittext(quirk_holder.real_name, " ")
	var/family_name = names[names.len]

	var/obj/family_heirloom = heirloom?.resolve()
	if(!family_heirloom)
		to_chat(quirk_holder, span_boldnotice("Alors que vous réalisez que votre précieux trésor de famille a disparu, une vague de doutes existentiels vous submerge."))
		return
	family_heirloom.AddComponent(/datum/component/heirloom, quirk_holder.mind, family_name)

	return ..()

/datum/quirk/item_quirk/family_heirloom/process()
	if(quirk_holder.stat == DEAD)
		return

	var/obj/family_heirloom = heirloom?.resolve()

	if(family_heirloom && (family_heirloom in quirk_holder.get_all_contents()))
		quirk_holder.clear_mood_event("family_heirloom_missing")
		quirk_holder.add_mood_event("family_heirloom", /datum/mood_event/family_heirloom)
	else
		quirk_holder.clear_mood_event("family_heirloom")
		quirk_holder.add_mood_event("family_heirloom_missing", /datum/mood_event/family_heirloom_missing)

/datum/quirk/item_quirk/family_heirloom/remove()
	quirk_holder.clear_mood_event("family_heirloom_missing")
	quirk_holder.clear_mood_event("family_heirloom")

/datum/quirk/glass_jaw
	name = "Mâchoire de verre"
	desc = "Vous avez une machoire très fragile. Un coup suffisament fort à votre tête pourrait vous envoyer au tapis."
	icon = FA_ICON_HAND_FIST
	value = -4
	gain_text = span_danger("Votre mâchoire se détend et paraît plus fragile.")
	lose_text = span_notice("Votre mâchoire a l'air de nouveau solide.")
	medical_record_text = "Le patient est absurdément facile à assommer. Eviter les rings de boxes."
	hardcore_value = 4
	mail_goodies = list(
		/obj/item/clothing/gloves/boxing,
		/obj/item/clothing/mask/luchador/rudos,
	)

/datum/quirk/glass_jaw/New()
	. = ..()
	//randomly picks between blue or red equipment for goodies
	if(prob(50))
		mail_goodies = list(
			/obj/item/clothing/gloves/boxing,
			/obj/item/clothing/mask/luchador/rudos,
		)
	else
		mail_goodies = list(
			/obj/item/clothing/gloves/boxing/blue,
			/obj/item/clothing/mask/luchador/tecnicos,
		)

/datum/quirk/glass_jaw/add(client/client_source)
	RegisterSignal(quirk_holder, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(punch_out))

/datum/quirk/glass_jaw/remove()
	UnregisterSignal(quirk_holder, COMSIG_MOB_APPLY_DAMAGE)

/datum/quirk/glass_jaw/proc/punch_out(mob/living/carbon/source, damage, damagetype, def_zone, blocked, wound_bonus, bare_wound_bonus, sharpness, attack_direction)
	SIGNAL_HANDLER
	if((damagetype != BRUTE) || (def_zone != BODY_ZONE_HEAD))
		return
	var/actual_damage = damage - (damage * blocked/100)
	//only roll for knockouts at 5 damage or more
	if(actual_damage < 5)
		return
	//blunt items are more likely to knock out, but sharp ones are still capable of doing it
	if(prob(CEILING(actual_damage * (sharpness & (SHARP_EDGED|SHARP_POINTY) ? 0.65 : 1), 1)))
		source.visible_message(
			span_warning("[source] gets knocked out!"),
			span_userdanger("Vous êtes assommé!"),
			vision_distance = COMBAT_MESSAGE_RANGE,
		)
		source.Unconscious(3 SECONDS)

/datum/quirk/frail
	name = "Fragile"
	desc = "Vous avez des os de verre et une peau fine! Vous vous blessez plus facilement que les autres."
	icon = FA_ICON_SKULL
	value = -6
	mob_trait = TRAIT_EASILY_WOUNDED
	gain_text = span_danger("Vous vous sentez fragile.")
	lose_text = span_notice("Vous vous sentez résistant.")
	medical_record_text = "Le patient est absurdément facile a blesser. Merci de prendre toutes les mesures nécessaires pour éviter toute blessure."
	hardcore_value = 4
	mail_goodies = list(/obj/effect/spawner/random/medical/minor_healing)

/datum/quirk/heavy_sleeper
	name = "Dormeur Lourd"
	desc = "Vous dormez comme une pierre! Lorsque vous êtes assommés ou endormis, vous prenez un peu plus de temps à vous réveiller."
	icon = FA_ICON_BED
	value = -2
	mob_trait = TRAIT_HEAVY_SLEEPER
	gain_text = span_danger("Vous vous sentez somnolent.")
	lose_text = span_notice("Vous vous sentez de nouveau alerte.")
	medical_record_text = "Le patient présente des phases de sommeil anormalement longues et éprouve des difficultés à se lever."
	hardcore_value = 2
	mail_goodies = list(
		/obj/item/clothing/glasses/blindfold,
		/obj/item/bedsheet/random,
		/obj/item/clothing/under/misc/pj/red,
		/obj/item/clothing/head/costume/nightcap/red,
		/obj/item/clothing/under/misc/pj/blue,
		/obj/item/clothing/head/costume/nightcap/blue,
		/obj/item/pillow/random,
	)

/datum/quirk/hypersensitive
	name = "Hypersensible"
	desc = "Pour le meilleur ou pour le pire, la moindre petite chose peut altérer votre humeur plus que ca ne devrait."
	icon = FA_ICON_FLUSHED
	value = -2
	gain_text = span_danger("Vous sentez que vous devenez hypersensible, et que tout peut vous atteindre.")
	lose_text = span_notice("Vous sentez que vous n'êtes plus sensible a tout.")
	medical_record_text = "Le patient présente un haut niveau d'instabilité émotionnelle."
	hardcore_value = 3
	mail_goodies = list(/obj/effect/spawner/random/entertainment/plushie_delux)

/datum/quirk/hypersensitive/add(client/client_source)
	if (quirk_holder.mob_mood)
		quirk_holder.mob_mood.mood_modifier += 0.5

/datum/quirk/hypersensitive/remove()
	if (quirk_holder.mob_mood)
		quirk_holder.mob_mood.mood_modifier -= 0.5

/datum/quirk/light_drinker
	name = "Faible constitution"
	desc = "Vous ne tenez pas très bien l'alcool et êtes plus rapidement soûl."
	icon = FA_ICON_COCKTAIL
	value = -2
	mob_trait = TRAIT_LIGHT_DRINKER
	gain_text = span_notice("Juste à la pensée de l'alcool, vous tête tourne.")
	lose_text = span_danger("Vous êtes capable de tenir l'alcool.")
	medical_record_text = "Le patient montre une faible tolérance à l'alcool."
	hardcore_value = 3
	mail_goodies = list(/obj/item/reagent_containers/cup/glass/waterbottle)

/datum/quirk/item_quirk/nearsighted
	name = "Bigleux"
	desc = "Vous voyez mal sans lunettes de correction (vous apparaissez avec une paire)."
	icon = FA_ICON_GLASSES
	value = -4
	gain_text = span_danger("Les choses éloignées apparaissent flou.")
	lose_text = span_notice("Les choses éloignées apparaissent nettes de nouveau.")
	medical_record_text = "Le patient a besoin de lunettes de correction pour sa vue défaillante."
	hardcore_value = 5
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_CHANGES_APPEARANCE
	mail_goodies = list(/obj/item/clothing/glasses/regular) // extra pair if orginal one gets broken by somebody mean

/datum/quirk/item_quirk/nearsighted/add_unique(client/client_source)
	var/glasses_name = client_source?.prefs.read_preference(/datum/preference/choiced/glasses) || "Regular"
	var/obj/item/clothing/glasses/glasses_type
	switch(glasses_name)
		if ("Fine")
			glasses_type = /obj/item/clothing/glasses/regular/thin
		if ("Cercle")
			glasses_type = /obj/item/clothing/glasses/regular/circle
		if ("Hipster")
			glasses_type = /obj/item/clothing/glasses/regular/hipster
		else
			glasses_type = /obj/item/clothing/glasses/regular

	give_item_to_holder(glasses_type, list(
		LOCATION_EYES = ITEM_SLOT_EYES,
		LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
		LOCATION_HANDS = ITEM_SLOT_HANDS,
	))

/datum/quirk/item_quirk/nearsighted/add(client/client_source)
	quirk_holder.become_nearsighted(QUIRK_TRAIT)

/datum/quirk/item_quirk/nearsighted/remove()
	quirk_holder.cure_nearsighted(QUIRK_TRAIT)

/datum/quirk/nyctophobia
	name = "Nyctophobie"
	desc = "D'aussi loin que vous pouvez vous rappeler, vous avez toujours été éffrayé par l'obscurité. Lorsque vous êtes dans l'obscurité sans source de lumière, vous commencez à avoir des frayeurs."
	icon = FA_ICON_LIGHTBULB
	value = -3
	medical_record_text = "Le patient présente une peur du noir. (Sérieusement?)"
	hardcore_value = 5
	mail_goodies = list(/obj/effect/spawner/random/engineering/flashlight)

/datum/quirk/nyctophobia/add(client/client_source)
	RegisterSignal(quirk_holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_holder_moved))

/datum/quirk/nyctophobia/remove()
	UnregisterSignal(quirk_holder, COMSIG_MOVABLE_MOVED)
	quirk_holder.clear_mood_event("nyctophobia")

/// Called when the quirk holder moves. Updates the quirk holder's mood.
/datum/quirk/nyctophobia/proc/on_holder_moved(mob/living/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER

	if(quirk_holder.stat != CONSCIOUS || quirk_holder.IsSleeping() || quirk_holder.IsUnconscious())
		return

	if(HAS_TRAIT(quirk_holder, TRAIT_FEARLESS))
		return

	var/mob/living/carbon/human/human_holder = quirk_holder

	if(human_holder.dna?.species.id in list(SPECIES_SHADOW, SPECIES_NIGHTMARE))
		return

	if((human_holder.sight & SEE_TURFS) == SEE_TURFS)
		return

	var/turf/holder_turf = get_turf(quirk_holder)

	var/lums = holder_turf.get_lumcount()

	if(lums > LIGHTING_TILE_IS_DARK)
		quirk_holder.clear_mood_event("nyctophobia")
		return

	if(quirk_holder.m_intent == MOVE_INTENT_RUN)
		to_chat(quirk_holder, span_warning("Doucement, doucement, vas-y doucement... tu es dans le noir..."))
		quirk_holder.toggle_move_intent()
	quirk_holder.add_mood_event("nyctophobia", /datum/mood_event/nyctophobia)

/datum/quirk/nonviolent
	name = "Pacifiste"
	desc = "La notion de violence vous dégoûte. Vous êtes, de ce fait, incapable de blesser quiconque."
	icon = FA_ICON_PEACE
	value = -8
	mob_trait = TRAIT_PACIFISM
	gain_text = span_danger("Vous vous sentez révulsé par la pensée de violences!")
	lose_text = span_notice("Vous sentez que vous pouvez vous défendre de nouveau.")
	medical_record_text = "Le patient est de nature pacifiste et ne peut se résoudre à causer des blessures physiques. (Malgré tout, c'est toujours vous)"
	hardcore_value = 6
	mail_goodies = list(/obj/effect/spawner/random/decoration/flower, /obj/effect/spawner/random/contraband/cannabis) // flower power

/datum/quirk/paraplegic
	name = "Paraplégique"
	desc = "Vos jambes ne fonctionnent plus, et rien ne pourra arranger cela. Mais hé, chaise roulante gratuite!"
	icon = FA_ICON_WHEELCHAIR
	value = -12
	gain_text = null // Handled by trauma.
	lose_text = null
	medical_record_text = "La patient possède de graves troubles moteurs situés dans les membres inférieurs."
	hardcore_value = 15
	mail_goodies = list(/obj/vehicle/ridden/wheelchair/motorized) //yes a fullsized unfolded motorized wheelchair does fit

/datum/quirk/paraplegic/add_unique(client/client_source)
	if(quirk_holder.buckled) // Handle late joins being buckled to arrival shuttle chairs.
		quirk_holder.buckled.unbuckle_mob(quirk_holder)

	var/turf/holder_turf = get_turf(quirk_holder)
	var/obj/structure/chair/spawn_chair = locate() in holder_turf

	var/obj/vehicle/ridden/wheelchair/wheels
	if(client_source?.get_award_status(/datum/award/score/hardcore_random) >= 5000) //More than 5k score? you unlock the gamer wheelchair.
		wheels = new /obj/vehicle/ridden/wheelchair/gold(holder_turf)
	else
		wheels = new(holder_turf)
	if(spawn_chair) // Makes spawning on the arrivals shuttle more consistent looking
		wheels.setDir(spawn_chair.dir)

	wheels.buckle_mob(quirk_holder)

	// During the spawning process, they may have dropped what they were holding, due to the paralysis
	// So put the things back in their hands.
	for(var/obj/item/dropped_item in holder_turf)
		if(dropped_item.fingerprintslast == quirk_holder.ckey)
			quirk_holder.put_in_hands(dropped_item)

/datum/quirk/paraplegic/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.gain_trauma(/datum/brain_trauma/severe/paralysis/paraplegic, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/paraplegic/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.cure_trauma_type(/datum/brain_trauma/severe/paralysis/paraplegic, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/poor_aim
	name = "Visée de stormtrooper"
	desc = "Vous n'avez jamais réussi à toucher votre cible."
	icon = FA_ICON_BULLSEYE
	value = -4
	mob_trait = TRAIT_POOR_AIM
	medical_record_text = "Le patient possède une tremblote forte dans ses deux poignets."
	hardcore_value = 3
	mail_goodies = list(/obj/item/cardboard_cutout) // for target practice

/datum/quirk/prosopagnosia
	name = "Prosopagnosie"
	desc = "Vous avez un trouble mental qui vous empêche de de reconnaître les visages."
	icon = FA_ICON_USER_SECRET
	value = -4
	mob_trait = TRAIT_PROSOPAGNOSIA
	medical_record_text = "Le patient souffre de prosopagnosie et est incapable de reconnaîtres les visages."
	hardcore_value = 5
	mail_goodies = list(/obj/item/skillchip/appraiser) // bad at recognizing faces but good at recognizing IDs

/datum/quirk/prosthetic_limb
	name = "Membre prothétique"
	desc = "Un accident vous a fait perdre un membre. Vous avez maintenant un membre aléatoire prothétique!"
	icon = "tg-prosthetic-leg"
	value = -3
	medical_record_text = "Durant l'examen médical, un membre prothétique a été repéré chez le patient."
	hardcore_value = 3
	quirk_flags = QUIRK_HUMAN_ONLY // while this technically changes appearance, we don't want it to be shown on the dummy because it's randomized at roundstart
	mail_goodies = list(/obj/item/weldingtool/mini, /obj/item/stack/cable_coil/five)
	/// The slot to replace, in string form
	var/slot_string = "limb"
	/// the original limb from before the prosthetic was applied
	var/obj/item/bodypart/old_limb

/datum/quirk/prosthetic_limb/add_unique(client/client_source)
	var/limb_slot = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/bodypart/prosthetic
	switch(limb_slot)
		if(BODY_ZONE_L_ARM)
			prosthetic = new /obj/item/bodypart/arm/left/robot/surplus
			slot_string = "bras gauche"
		if(BODY_ZONE_R_ARM)
			prosthetic = new /obj/item/bodypart/arm/right/robot/surplus
			slot_string = "bras droit"
		if(BODY_ZONE_L_LEG)
			prosthetic = new /obj/item/bodypart/leg/left/robot/surplus
			slot_string = "jambe gauche"
		if(BODY_ZONE_R_LEG)
			prosthetic = new /obj/item/bodypart/leg/right/robot/surplus
			slot_string = "jambe droite"
	old_limb = human_holder.return_and_replace_bodypart(prosthetic)

/datum/quirk/prosthetic_limb/post_add()
	to_chat(quirk_holder, span_boldannounce("Votre [slot_string] a été remplacé avec un membre prothétique. Il est très fragile et se détachera facilement au moindre accrochage. De plus, \
	vous aurez besoin d'un fer à souder et de câbles pour le réparer, au lieu de bandages et crèmes."))

/datum/quirk/prosthetic_limb/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.del_and_replace_bodypart(old_limb)
	old_limb = null

/datum/quirk/quadruple_amputee
	name = "Quadruple amputé"
	desc = "Oups! Tout vos membres sont prothétique! A cause d'une punition cosmique cruelle, tout vos membres vous ont été retirés."
	icon = "tg-prosthetic-full"
	value = -6
	medical_record_text = "Au cours de l'examen médical, une absence de membres a été repéré chez le patient."
	hardcore_value = 6
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_CHANGES_APPEARANCE

/datum/quirk/quadruple_amputee/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.del_and_replace_bodypart(new /obj/item/bodypart/arm/left/robot/surplus)
	human_holder.del_and_replace_bodypart(new /obj/item/bodypart/arm/right/robot/surplus)
	human_holder.del_and_replace_bodypart(new /obj/item/bodypart/leg/left/robot/surplus)
	human_holder.del_and_replace_bodypart(new /obj/item/bodypart/leg/right/robot/surplus)

/datum/quirk/quadruple_amputee/post_add()
	to_chat(quirk_holder, span_boldannounce("Tout vos membres ont étés remplacés avec des membres prothétiques. Ils sont très fragiles et se détacheront facilement au moindre accrochage. De plus, \
	vous aurez besoin d'un fer à souder et de câbles pour les réparer, au lieu de bandages et crèmes."))

/datum/quirk/pushover
	name = "Souffre-douleur"
	desc = "Votre premier instinct est de toujour laisser les autres faire ce qu'il veulent de vous. Résister à quelqu'un qui vous attrape vous demandera de gros efforts."
	icon = FA_ICON_HANDSHAKE
	value = -8
	mob_trait = TRAIT_GRABWEAKNESS
	gain_text = span_danger("Vous vous sentez comme un souffre-douleur.")
	lose_text = span_notice("Vous vous sentez de vous battre pour vous même.")
	medical_record_text = "Le patient démontre une forte personnalité non assertive, et est facile à manipuler."
	hardcore_value = 4
	mail_goodies = list(/obj/item/clothing/gloves/cargo_gauntlet)

/datum/quirk/insanity
	name = "Trouble de dépersonnalisation"
	desc = "Vous souffre d'un sévère trouble de la dépersonnalisation qui vous cause des hallucinations. \
		La Toxine Psychotrope peut annuler ses effets, et vous êtes immunisés contre les effets hallucinogènes des psychotropes. \
		CE N'EST PAS UN PRETEXTE POUR GRIEF."
	icon = FA_ICON_GRIN_TONGUE_WINK
	value = -8
	gain_text = span_userdanger("Vous sentez votre emprise sur votre psyché faiblire.")
	lose_text = span_notice("Vous vous sentez de nouveau en accord avec votre psyché.")
	medical_record_text = "Le patient souffre d'un trouble de la dépersonnalisation aïgu et subi de violentes hallucinations."
	hardcore_value = 6
	mail_goodies = list(/obj/item/storage/pill_bottle/lsdpsych)
	/// Weakref to the trauma we give out
	var/datum/weakref/added_trama_ref

/datum/quirk/insanity/add(client/client_source)
	if(!iscarbon(quirk_holder))
		return
	var/mob/living/carbon/carbon_quirk_holder = quirk_holder

	// Setup our special RDS mild hallucination.
	// Not a unique subtype so not to plague subtypesof,
	// also as we inherit the names and values from our quirk.
	var/datum/brain_trauma/mild/hallucinations/added_trauma = new()
	added_trauma.resilience = TRAUMA_RESILIENCE_ABSOLUTE
	added_trauma.name = name
	added_trauma.desc = medical_record_text
	added_trauma.scan_desc = lowertext(name)
	added_trauma.gain_text = null
	added_trauma.lose_text = null

	carbon_quirk_holder.gain_trauma(added_trauma)
	added_trama_ref = WEAKREF(added_trauma)

/datum/quirk/insanity/post_add()
	if(!quirk_holder.mind || quirk_holder.mind.special_role)
		return
	// I don't /think/ we'll need this, but for newbies who think "roleplay as insane" = "license to kill",
	// it's probably a good thing to have.
	to_chat(quirk_holder, span_big(span_bold(span_info("Merci de prendre en compte que votre [lowertext(name)] ne vous DONNE PAS LE DROIT d'attaquer d'autres joueurs ou d'interférer \
		avec le round en cours. Vous n'êtes pas un antagoniste, les mêmes règles que l'équippage s'appliquent pour vous."))))

/datum/quirk/insanity/remove()
	QDEL_NULL(added_trama_ref)

/datum/quirk/social_anxiety
	name = "Anxiété sociale"
	desc = "Parler aux gens est très compliqué pour vous, et il vous arrive souvent de bégayer ou de vous fermer aux gens."
	icon = FA_ICON_COMMENT_SLASH
	value = -3
	gain_text = span_danger("Vous commencez à être anxieux de parler aux gens.")
	lose_text = span_notice("Vous vous sentez plus à l'aise de parler aux autres.") //if only it were that easy!
	medical_record_text = "Le patient présente une anxiété lors de relations sociales et préfère les éviter."
	hardcore_value = 4
	mob_trait = TRAIT_ANXIOUS
	mail_goodies = list(/obj/item/storage/pill_bottle/psicodine)
	var/dumb_thing = TRUE

/datum/quirk/social_anxiety/add(client/client_source)
	RegisterSignal(quirk_holder, COMSIG_MOB_EYECONTACT, PROC_REF(eye_contact))
	RegisterSignal(quirk_holder, COMSIG_MOB_EXAMINATE, PROC_REF(looks_at_floor))
	RegisterSignal(quirk_holder, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/quirk/social_anxiety/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_MOB_EYECONTACT, COMSIG_MOB_EXAMINATE, COMSIG_MOB_SAY))

/datum/quirk/social_anxiety/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	if(HAS_TRAIT(quirk_holder, TRAIT_FEARLESS))
		return

	var/moodmod
	if(quirk_holder.mob_mood)
		moodmod = (1+0.02*(50-(max(50, quirk_holder.mob_mood.mood_level*(7-quirk_holder.mob_mood.sanity_level))))) //low sanity levels are better, they max at 6
	else
		moodmod = (1+0.02*(50-(max(50, 0.1*quirk_holder.nutrition))))
	var/nearby_people = 0
	for(var/mob/living/carbon/human/H in oview(3, quirk_holder))
		if(H.client)
			nearby_people++
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		var/list/message_split = splittext(message, " ")
		var/list/new_message = list()
		var/mob/living/carbon/human/quirker = quirk_holder
		for(var/word in message_split)
			if(prob(max(5,(nearby_people*12.5*moodmod))) && word != message_split[1]) //Minimum 1/20 chance of filler
				new_message += pick("hum,","erm,","euh,")
				if(prob(min(5,(0.05*(nearby_people*12.5)*moodmod)))) //Max 1 in 20 chance of cutoff after a successful filler roll, for 50% odds in a 15 word sentence
					quirker.set_silence_if_lower(6 SECONDS)
					to_chat(quirker, span_danger("Vous réalisez ce que vous êtes en train de dire et arrêtez de parler. Vous avez besoin d'un moment pour vous en remettre!"))
					break
			if(prob(max(5,(nearby_people*12.5*moodmod)))) //Minimum 1/20 chance of stutter
				// Add a short stutter, THEN treat our word
				quirker.adjust_stutter(0.5 SECONDS)
				new_message += quirker.treat_message(word, capitalize_message = FALSE)

			else
				new_message += word

		message = jointext(new_message, " ")
	var/mob/living/carbon/human/quirker = quirk_holder
	if(prob(min(50,(0.50*(nearby_people*12.5)*moodmod)))) //Max 50% chance of not talking
		if(dumb_thing)
			to_chat(quirker, span_userdanger("Vous vous rappelez d'une chose stupide que vous avez dit il y a longtemps et vous criez intérieurement."))
			dumb_thing = FALSE //only once per life
			if(prob(1))
				new/obj/item/food/spaghetti/pastatomato(get_turf(quirker)) //now that's what I call spaghetti code
		else
			to_chat(quirk_holder, span_warning("Vous décidez que ca n'ajouterait pas grand chose à la conversation et décidez de ne pas le dire."))
			if(prob(min(25,(0.25*(nearby_people*12.75)*moodmod)))) //Max 25% chance of silence stacks after successful not talking roll
				to_chat(quirker, span_danger("Vous vous retranchez à l'intérieur de vous même. Vous ne vous sentez <i>vraiment</i> pas de parler."))
				quirker.set_silence_if_lower(10 SECONDS)

		speech_args[SPEECH_MESSAGE] = pick("Heu.","Erm.","Euh.")
	else
		speech_args[SPEECH_MESSAGE] = message

// small chance to make eye contact with inanimate objects/mindless mobs because of nerves
/datum/quirk/social_anxiety/proc/looks_at_floor(datum/source, atom/A)
	SIGNAL_HANDLER

	var/mob/living/mind_check = A
	if(prob(85) || (istype(mind_check) && mind_check.mind))
		return

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), quirk_holder, span_smallnotice("You make eye contact with [A].")), 3)

/datum/quirk/social_anxiety/proc/eye_contact(datum/source, mob/living/other_mob, triggering_examiner)
	SIGNAL_HANDLER

	if(prob(75))
		return
	var/msg
	if(triggering_examiner)
		msg = "Vous avez un contact droit dans les yeux avec [other_mob], "
	else
		msg = "[other_mob] fait un contact en vous regardant droit dans les yeux, "

	switch(rand(1,3))
		if(1)
			quirk_holder.set_jitter_if_lower(20 SECONDS)
			msg += "vous faisant vous agiter sur place!"
		if(2)
			quirk_holder.set_stutter_if_lower(6 SECONDS)
			msg += "vous faisant bégayer!"
		if(3)
			quirk_holder.Stun(2 SECONDS)
			msg += "vous faisant vous immobiliser!"

	quirk_holder.add_mood_event("anxiety_eyecontact", /datum/mood_event/anxiety_eyecontact)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), quirk_holder, span_userdanger("[msg]")), 3) // so the examine signal has time to fire and this will print after
	return COMSIG_BLOCK_EYECONTACT

/datum/mood_event/anxiety_eyecontact
	description = "Parfois le contact droit dans les yeux me rend mal à l'aise..."
	mood_change = -5
	timeout = 3 MINUTES

/datum/quirk/item_quirk/junkie
	name = "Accro à la drogue"
	desc = "Vous n'avez jamais assez des drogues dures."
	icon = FA_ICON_PILLS
	value = -8
	gain_text = span_danger("Vous avez soudain une envie de drogues dures.")
	medical_record_text = "La patient a un historique de consommation élevée de drogues dures."
	hardcore_value = 4
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES
	mail_goodies = list(/obj/effect/spawner/random/contraband/narcotics)
	var/drug_list = list(/datum/reagent/drug/blastoff, /datum/reagent/drug/krokodil, /datum/reagent/medicine/morphine, /datum/reagent/drug/happiness, /datum/reagent/drug/methamphetamine) //List of possible IDs
	var/datum/reagent/reagent_type //!If this is defined, reagent_id will be unused and the defined reagent type will be instead.
	var/datum/reagent/reagent_instance //! actual instanced version of the reagent
	var/where_drug //! Where the drug spawned
	var/obj/item/drug_container_type //! If this is defined before pill generation, pill generation will be skipped. This is the type of the pill bottle.
	var/where_accessory //! where the accessory spawned
	var/obj/item/accessory_type //! If this is null, an accessory won't be spawned.
	var/process_interval = 30 SECONDS //! how frequently the quirk processes
	var/next_process = 0 //! ticker for processing
	var/drug_flavour_text = "En espérant que vous ne tombez pas à court..."

/datum/quirk/item_quirk/junkie/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder

	if(!reagent_type)
		reagent_type = pick(drug_list)

	reagent_instance = new reagent_type()

	for(var/addiction in reagent_instance.addiction_types)
		human_holder.last_mind?.add_addiction_points(addiction, 1000)

	var/current_turf = get_turf(quirk_holder)

	if(!drug_container_type)
		drug_container_type = /obj/item/storage/pill_bottle

	var/obj/item/drug_instance = new drug_container_type(current_turf)
	if(istype(drug_instance, /obj/item/storage/pill_bottle))
		var/pill_state = "pill[rand(1,20)]"
		for(var/i in 1 to 7)
			var/obj/item/reagent_containers/pill/pill = new(drug_instance)
			pill.icon_state = pill_state
			pill.reagents.add_reagent(reagent_type, 3)

	give_item_to_holder(
		drug_instance,
		list(
			LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
			LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
			LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
			LOCATION_HANDS = ITEM_SLOT_HANDS,
		),
		flavour_text = drug_flavour_text,
	)

	if(accessory_type)
		give_item_to_holder(
		accessory_type,
		list(
			LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
			LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
			LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
			LOCATION_HANDS = ITEM_SLOT_HANDS,
		)
	)

/datum/quirk/item_quirk/junkie/remove()
	if(quirk_holder && reagent_instance)
		for(var/addiction_type in subtypesof(/datum/addiction))
			quirk_holder.mind.remove_addiction_points(addiction_type, MAX_ADDICTION_POINTS)

/datum/quirk/item_quirk/junkie/process(seconds_per_tick)
	if(HAS_TRAIT(quirk_holder, TRAIT_NOMETABOLISM))
		return
	var/mob/living/carbon/human/human_holder = quirk_holder
	if(world.time > next_process)
		next_process = world.time + process_interval
		var/deleted = QDELETED(reagent_instance)
		var/missing_addiction = FALSE
		for(var/addiction_type in reagent_instance.addiction_types)
			if(!LAZYACCESS(human_holder.last_mind?.active_addictions, addiction_type))
				missing_addiction = TRUE
		if(deleted || missing_addiction)
			if(deleted)
				reagent_instance = new reagent_type()
			to_chat(quirk_holder, span_danger("Vous pensiez vous en être débarrassé, mais vous retombez dans vos mauvaises habitudes..."))
			for(var/addiction in reagent_instance.addiction_types)
				human_holder.last_mind?.add_addiction_points(addiction, 1000) ///Max that shit out

/datum/quirk/item_quirk/junkie/smoker
	name = "Fumeur"
	desc = "Parfois vous avez juste vraiment envie d'une taffe. Sûrement pas bon pour les poumons."
	icon = FA_ICON_SMOKING
	value = -4
	gain_text = span_danger("Vous avez vraiment envie d'une cigarette maintenant.")
	medical_record_text = "Le patient est un fumeur actif."
	reagent_type = /datum/reagent/drug/nicotine
	accessory_type = /obj/item/lighter/greyscale
	mob_trait = TRAIT_SMOKER
	hardcore_value = 1
	drug_flavour_text = "Préparez vos réserves de votre marque favorite quand vous n'en n'aurez plus."
	mail_goodies = list(
		/obj/effect/spawner/random/entertainment/cigarette_pack,
		/obj/effect/spawner/random/entertainment/cigar,
		/obj/effect/spawner/random/entertainment/lighter,
		/obj/item/clothing/mask/cigarette/pipe,
	)

/datum/quirk/item_quirk/junkie/smoker/New()
	drug_container_type = pick(/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/fancy/cigarettes/cigpack_midori,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift,
		/obj/item/storage/fancy/cigarettes/cigpack_robust,
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold,
		/obj/item/storage/fancy/cigarettes/cigpack_carp)

	return ..()

/datum/quirk/item_quirk/junkie/smoker/post_add()
	. = ..()
	quirk_holder.add_mob_memory(/datum/memory/key/quirk_smoker, protagonist = quirk_holder, preferred_brand = initial(drug_container_type.name))
	// smoker lungs have 25% less health and healing
	var/obj/item/organ/internal/lungs/smoker_lungs = quirk_holder.get_organ_slot(ORGAN_SLOT_LUNGS)
	if (smoker_lungs && !(smoker_lungs.organ_flags & ORGAN_SYNTHETIC)) // robotic lungs aren't affected
		smoker_lungs.maxHealth = smoker_lungs.maxHealth * 0.75
		smoker_lungs.healing_factor = smoker_lungs.healing_factor * 0.75

/datum/quirk/item_quirk/junkie/smoker/process(seconds_per_tick)
	. = ..()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/mask_item = human_holder.get_item_by_slot(ITEM_SLOT_MASK)
	if (istype(mask_item, /obj/item/clothing/mask/cigarette))
		var/obj/item/storage/fancy/cigarettes/cigarettes = drug_container_type
		if(istype(mask_item, initial(cigarettes.spawn_type)))
			quirk_holder.clear_mood_event("wrong_cigs")
			return
		quirk_holder.add_mood_event("wrong_cigs", /datum/mood_event/wrong_brand)

/datum/quirk/unstable
	name = "Instable"
	desc = "A cause de vos troubles passés, vous êtes incapable de récupérer votre santé mentale si vous la perdez. Faites très attention à votre humeur!"
	icon = FA_ICON_ANGRY
	value = -10
	mob_trait = TRAIT_UNSTABLE
	gain_text = span_danger("Vous sentez un poids sur votre esprit.")
	lose_text = span_notice("Votre esprit se calme.")
	medical_record_text = "L'esprit du patient est dans un état très vulnérable, et ne pourra se remettre d'un évènement traumatique."
	hardcore_value = 9
	mail_goodies = list(/obj/effect/spawner/random/entertainment/plushie)

/datum/quirk/item_quirk/allergic
	name = "Allergie extrême aux médicaments"
	desc = "Depuis votre plus tendre enfance, vous avez toujours été allergique à certains produits chimiques..."
	icon = FA_ICON_PRESCRIPTION_BOTTLE
	value = -6
	gain_text = span_danger("Vous sentez votre système immunitaire faiblir.")
	lose_text = span_notice("Vous sentez votre système immunitaire de nouveau opérationnel")
	medical_record_text = "Le système immunitaire du patient réagit viollement à certains produits chimiques."
	hardcore_value = 3
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES
	mail_goodies = list(/obj/item/reagent_containers/hypospray/medipen) // epinephrine medipen stops allergic reactions
	var/list/allergies = list()
	var/list/blacklist = list(/datum/reagent/medicine/c2,/datum/reagent/medicine/epinephrine,/datum/reagent/medicine/adminordrazine,/datum/reagent/medicine/omnizine/godblood,/datum/reagent/medicine/cordiolis_hepatico,/datum/reagent/medicine/synaphydramine,/datum/reagent/medicine/diphenhydramine)
	var/allergy_string

/datum/quirk/item_quirk/allergic/add_unique(client/client_source)
	var/list/chem_list = subtypesof(/datum/reagent/medicine) - blacklist
	var/list/allergy_chem_names = list()
	for(var/i in 0 to 5)
		var/datum/reagent/medicine/chem_type = pick_n_take(chem_list)
		allergies += chem_type
		allergy_chem_names += initial(chem_type.name)

	allergy_string = allergy_chem_names.Join(", ")
	name = "Extreme [allergy_string] Allergies"
	medical_record_text = "Le système immunitaire du patient réagit viollement a ces produits [allergy_string]"

	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/clothing/accessory/allergy_dogtag/dogtag = new(get_turf(human_holder))
	dogtag.display = allergy_string

	give_item_to_holder(dogtag, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS), flavour_text = "Assurez vous que les membres de l'équipe médicale voient ceci...")

/datum/quirk/item_quirk/allergic/post_add()
	quirk_holder.add_mob_memory(/datum/memory/key/quirk_allergy, allergy_string = allergy_string)
	to_chat(quirk_holder, span_boldnotice("Vous êtes allergique à ces produits [allergy_string], faites attention de ne pas en ingérer un seul!"))

/datum/quirk/item_quirk/allergic/process(seconds_per_tick)
	if(!iscarbon(quirk_holder))
		return

	if(IS_IN_STASIS(quirk_holder))
		return

	if(quirk_holder.stat == DEAD)
		return

	var/mob/living/carbon/carbon_quirk_holder = quirk_holder
	for(var/allergy in allergies)
		var/datum/reagent/instantiated_med = carbon_quirk_holder.reagents.has_reagent(allergy)
		if(!instantiated_med)
			continue
		//Just halts the progression, I'd suggest you run to medbay asap to get it fixed
		if(carbon_quirk_holder.reagents.has_reagent(/datum/reagent/medicine/epinephrine))
			instantiated_med.reagent_removal_skip_list |= ALLERGIC_REMOVAL_SKIP
			return //intentionally stops the entire proc so we avoid the organ damage after the loop
		instantiated_med.reagent_removal_skip_list -= ALLERGIC_REMOVAL_SKIP
		carbon_quirk_holder.adjustToxLoss(3 * seconds_per_tick)
		carbon_quirk_holder.reagents.add_reagent(/datum/reagent/toxin/histamine, 3 * seconds_per_tick)
		if(SPT_PROB(10, seconds_per_tick))
			carbon_quirk_holder.vomit()
			carbon_quirk_holder.adjustOrganLoss(pick(ORGAN_SLOT_BRAIN,ORGAN_SLOT_APPENDIX,ORGAN_SLOT_LUNGS,ORGAN_SLOT_HEART,ORGAN_SLOT_LIVER,ORGAN_SLOT_STOMACH),10)

/datum/quirk/bad_touch
	name = "Haptophobe"
	desc = "Vous n'aimez pas les câlins. De manière générale, vous préférez que les gens vous laissent tranquille."
	icon = "tg-bad-touch"
	mob_trait = TRAIT_BADTOUCH
	value = -1
	gain_text = span_danger("Vous sentez que vous voulez juste que les gens vous laissent tranquille.")
	lose_text = span_notice("Vous aimez à nouveau les câlins.")
	medical_record_text = "Le patient déteste être touché, possible diagnostic haptophobe."
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	hardcore_value = 1
	mail_goodies = list(/obj/item/reagent_containers/spray/pepper) // show me on the doll where the bad man touched you

/datum/quirk/bad_touch/add(client/client_source)
	RegisterSignals(quirk_holder, list(COMSIG_LIVING_GET_PULLED, COMSIG_CARBON_HELP_ACT), PROC_REF(uncomfortable_touch))

/datum/quirk/bad_touch/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_LIVING_GET_PULLED, COMSIG_CARBON_HELP_ACT))

/// Causes a negative moodlet to our quirk holder on signal
/datum/quirk/bad_touch/proc/uncomfortable_touch(datum/source)
	SIGNAL_HANDLER

	if(quirk_holder.stat == DEAD)
		return

	new /obj/effect/temp_visual/annoyed(quirk_holder.loc)
	if(quirk_holder.mob_mood.sanity <= SANITY_NEUTRAL)
		quirk_holder.add_mood_event("bad_touch", /datum/mood_event/very_bad_touch)
	else
		quirk_holder.add_mood_event("bad_touch", /datum/mood_event/bad_touch)

/datum/quirk/claustrophobia
	name = "Claustrophobe"
	desc = "Vous êtes terrorisé par les espaces confinés. Si vous êtes dans n'importe quel placard, caisse ou machine, une crise de panique s'empare de vous et il vous est difficile de respirer."
	icon = FA_ICON_BOX_OPEN
	value = -4
	medical_record_text = "Le patient montre un epeur des espaces étroits."
	hardcore_value = 5
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES
	mail_goodies = list(/obj/item/reagent_containers/syringe/convermol) // to help breathing

/datum/quirk/claustrophobia/remove()
	quirk_holder.clear_mood_event("claustrophobia")

/datum/quirk/claustrophobia/process(seconds_per_tick)
	if(quirk_holder.stat != CONSCIOUS || quirk_holder.IsSleeping() || quirk_holder.IsUnconscious())
		return

	if(HAS_TRAIT(quirk_holder, TRAIT_FEARLESS))
		return

	var/nick_spotted = FALSE

	for(var/mob/living/carbon/human/possible_claus in view(5, quirk_holder))
		if(evaluate_jolly_levels(possible_claus))
			nick_spotted = TRUE
			break

	if(!nick_spotted && isturf(quirk_holder.loc))
		quirk_holder.clear_mood_event("claustrophobia")
		return

	quirk_holder.add_mood_event("claustrophobia", /datum/mood_event/claustrophobia)
	quirk_holder.losebreath += 0.25 // miss a breath one in four times
	if(SPT_PROB(25, seconds_per_tick))
		if(nick_spotted)
			to_chat(quirk_holder, span_warning("Le Père Noël est là! Je dois partir d'ici!"))
		else
			to_chat(quirk_holder, span_warning("Vous vous sentez pris au piège! ..dois m'échapper... peux pas respirer..."))
///investigates whether possible_saint_nick possesses a high level of christmas cheer
/datum/quirk/claustrophobia/proc/evaluate_jolly_levels(mob/living/carbon/human/possible_saint_nick)
	if(!istype(possible_saint_nick))
		return FALSE

	if(istype(possible_saint_nick.back, /obj/item/storage/backpack/santabag))
		return TRUE

	if(istype(possible_saint_nick.head, /obj/item/clothing/head/costume/santa) || istype(possible_saint_nick.head,  /obj/item/clothing/head/helmet/space/santahat))
		return TRUE

	if(istype(possible_saint_nick.wear_suit, /obj/item/clothing/suit/space/santa))
		return TRUE

	return FALSE

/datum/quirk/illiterate
	name = "Illettré"
	desc = "Vous avez abandonné l'école, et êtes incapable de lire ou d'écrire. Cela affecte la lecture, l'écriture, l'utilisation d'ordinateurs et d'autres machines électroniques."
	icon = FA_ICON_GRADUATION_CAP
	value = -8
	mob_trait = TRAIT_ILLITERATE
	medical_record_text = "Le patient n'a pas fini son CP."
	hardcore_value = 8
	mail_goodies = list(/obj/item/pai_card) // can read things for you


/datum/quirk/mute
	name = "Muet"
	desc = "Pour une raison inexpliquée, vous êtes complètement incapable de parler."
	icon = FA_ICON_VOLUME_XMARK
	value = -4
	mob_trait = TRAIT_MUTE
	gain_text = span_danger("Vous vous trouvez incapable de parler!")
	lose_text = span_notice("Vous sentez votre force revenir dans vos cordes vocales.")
	medical_record_text = "Le patient est incapable d'utiliser sa voix."
	hardcore_value = 4

/datum/quirk/body_purist
	name = "Puriste du corps"
	desc = "Votre corps est un temple, et sa forme naturelle est la perfection de l'aboutissement de l'évolution. De ce fait, vous haïssez la possibilité de l'augmenter avec des parties synthétiques, cybernétiques ou prothétiques."
	icon = FA_ICON_PERSON_RAYS
	value = -2
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	gain_text = span_danger("Vous commencez à haïr l'idée de membres synthétiques.")
	lose_text = span_notice("Peut être que la cybernétique n'est pas si mal. Vous êtes OK avec l'idée de membres cybernétiques.")
	medical_record_text = "Le patient a montré un vif sentiment de dégoût concernant les membres et organes artificels."
	hardcore_value = 3
	mail_goodies = list(/obj/item/paper/pamphlet/cybernetics)
	var/cybernetics_level = 0

/datum/quirk/body_purist/add(client/client_source)
	check_cybernetics()
	RegisterSignal(quirk_holder, COMSIG_CARBON_GAIN_ORGAN, PROC_REF(on_organ_gain))
	RegisterSignal(quirk_holder, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(on_organ_lose))
	RegisterSignal(quirk_holder, COMSIG_CARBON_ATTACH_LIMB, PROC_REF(on_limb_gain))
	RegisterSignal(quirk_holder, COMSIG_CARBON_REMOVE_LIMB, PROC_REF(on_limb_lose))

/datum/quirk/body_purist/remove()
	UnregisterSignal(quirk_holder, list(
		COMSIG_CARBON_GAIN_ORGAN,
		COMSIG_CARBON_LOSE_ORGAN,
		COMSIG_CARBON_ATTACH_LIMB,
		COMSIG_CARBON_REMOVE_LIMB,
	))
	quirk_holder.clear_mood_event("body_purist")

/datum/quirk/body_purist/proc/check_cybernetics()
	var/mob/living/carbon/owner = quirk_holder
	if(!istype(owner))
		return
	for(var/obj/item/bodypart/limb as anything in owner.bodyparts)
		if(!IS_ORGANIC_LIMB(limb))
			cybernetics_level++
	for(var/obj/item/organ/organ as anything in owner.organs)
		if((organ.organ_flags & ORGAN_SYNTHETIC || organ.status == ORGAN_ROBOTIC) && !(organ.organ_flags & ORGAN_HIDDEN))
			cybernetics_level++
	update_mood()

/datum/quirk/body_purist/proc/update_mood()
	quirk_holder.clear_mood_event("body_purist")
	if(cybernetics_level)
		quirk_holder.add_mood_event("body_purist", /datum/mood_event/body_purist, -cybernetics_level * 10)

/datum/quirk/body_purist/proc/on_organ_gain(datum/source, obj/item/organ/new_organ, special)
	SIGNAL_HANDLER
	if((new_organ.organ_flags & ORGAN_SYNTHETIC || new_organ.status == ORGAN_ROBOTIC) && !(new_organ.organ_flags & ORGAN_HIDDEN)) //why the fuck are there 2 of them
		cybernetics_level++
		update_mood()

/datum/quirk/body_purist/proc/on_organ_lose(datum/source, obj/item/organ/old_organ, special)
	SIGNAL_HANDLER
	if((old_organ.organ_flags & ORGAN_SYNTHETIC || old_organ.status == ORGAN_ROBOTIC) && !(old_organ.organ_flags & ORGAN_HIDDEN))
		cybernetics_level--
		update_mood()

/datum/quirk/body_purist/proc/on_limb_gain(datum/source, obj/item/bodypart/new_limb, special)
	SIGNAL_HANDLER
	if(!IS_ORGANIC_LIMB(new_limb))
		cybernetics_level++
		update_mood()

/datum/quirk/body_purist/proc/on_limb_lose(datum/source, obj/item/bodypart/old_limb, special)
	SIGNAL_HANDLER
	if(!IS_ORGANIC_LIMB(old_limb))
		cybernetics_level--
		update_mood()

/datum/quirk/cursed
	name = "Maudit"
	desc = "Vous êtes maudit avec de la malchance. Vous avez plus de chance de subir des accidents. Quand il pleut, il drache."
	icon = FA_ICON_CLOUD_SHOWERS_HEAVY
	value = -8
	mob_trait = TRAIT_CURSED
	gain_text = span_danger("Vous sentez que vous allez passer une mauvaise journée.")
	lose_text = span_notice("Vous sentez que vous n'avez plus de malchance.")
	medical_record_text = "Les études montrent que le patient est maudit par de la malchance (l'inverse de SCP-181)"
	hardcore_value = 8

/datum/quirk/cursed/add(client/client_source)
	quirk_holder.AddComponent(/datum/component/omen/quirk)
