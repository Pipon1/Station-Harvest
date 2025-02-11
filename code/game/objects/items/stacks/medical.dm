/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/medical/stack_medical.dmi'
	amount = 6
	max_amount = 6
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	resistance_flags = FLAMMABLE
	max_integrity = 40
	novariants = FALSE
	item_flags = NOBLUDGEON
	cost = 250
	source = /datum/robot_energy_storage/medical
	merge_type = /obj/item/stack/medical
	/// How long it takes to apply it to yourself
	var/self_delay = 5 SECONDS
	/// How long it takes to apply it to someone else
	var/other_delay = 0
	/// If we've still got more and the patient is still hurt, should we keep going automatically?
	var/repeating = FALSE
	/// How much brute we heal per application. This is the only number that matters for simplemobs
	var/heal_brute
	/// How much burn we heal per application
	var/heal_burn
	/// How much we reduce bleeding per application on cut wounds
	var/stop_bleeding
	/// How much sanitization to apply to burn wounds on application
	var/sanitization
	/// How much we add to flesh_healing for burn wounds on application
	var/flesh_regeneration

/obj/item/stack/medical/attack(mob/living/patient, mob/user)
	. = ..()
	try_heal(patient, user)

/// In which we print the message that we're starting to heal someone, then we try healing them. Does the do_after whether or not it can actually succeed on a targeted mob
/obj/item/stack/medical/proc/try_heal(mob/living/patient, mob/user, silent = FALSE)
	if(!patient.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
		return
	if(patient == user)
		if(!silent)
			user.visible_message(span_notice("[user] commence a appliquer [src] sur sois même"), span_notice("Vous commencez à appliquer [src] sur vous même..."))
		if(!do_after(user, self_delay, patient, extra_checks=CALLBACK(patient, TYPE_PROC_REF(/mob/living, try_inject), user, null, INJECT_TRY_SHOW_ERROR_MESSAGE)))
			return
	else if(other_delay)
		if(!silent)
			user.visible_message(span_notice("[user] commence a appliquer [src] sur [patient]."), span_notice("Vous commencez à appliquer [src] sur [patient]..."))
		if(!do_after(user, other_delay, patient, extra_checks=CALLBACK(patient, TYPE_PROC_REF(/mob/living, try_inject), user, null, INJECT_TRY_SHOW_ERROR_MESSAGE)))
			return

	if(heal(patient, user))
		log_combat(user, patient, "healed", src.name)
		use(1)
		if(repeating && amount > 0)
			try_heal(patient, user, TRUE)

/// Apply the actual effects of the healing if it's a simple animal, goes to [/obj/item/stack/medical/proc/heal_carbon] if it's a carbon, returns TRUE if it works, FALSE if it doesn't
/obj/item/stack/medical/proc/heal(mob/living/patient, mob/user)
	if(patient.stat == DEAD)
		patient.balloon_alert(user, "iel est mort !")
		return
	if(isanimal_or_basicmob(patient) && heal_brute) // only brute can heal
		var/mob/living/simple_animal/critter = patient
		if (istype(critter) && !critter.healable)
			patient.balloon_alert(user, "ça ne marchera pas !")
			return FALSE
		if (!(patient.mob_biotypes & MOB_ORGANIC))
			patient.balloon_alert(user, "vous ne pouvez pas réparer ça !")
			return FALSE
		if (patient.health == patient.maxHealth)
			patient.balloon_alert(user, "n'est pas blessé !")
			return FALSE
		user.visible_message("<span class='infoplain'><span class='green'>[user] applique [src] sur [patient].</span></span>", "<span class='infoplain'><span class='green'vous appliquez [src] sur [patient].</span></span>")
		patient.heal_bodypart_damage((heal_brute * 0.5))
		return TRUE
	if(iscarbon(patient))
		return heal_carbon(patient, user, heal_brute, heal_burn)
	patient.balloon_alert(user, "vous ne pouvez pas soigner ça !")

/// The healing effects on a carbon patient. Since we have extra details for dealing with bodyparts, we get our own fancy proc. Still returns TRUE on success and FALSE on fail
/obj/item/stack/medical/proc/heal_carbon(mob/living/carbon/patient, mob/user, brute, burn)
	var/obj/item/bodypart/affecting = patient.get_bodypart(check_zone(user.zone_selected))
	if(!affecting) //Missing limb?
		patient.balloon_alert(user, "non [parse_zone(user.zone_selected)] !")
		return FALSE
	if(!IS_ORGANIC_LIMB(affecting)) //Limb must be organic to be healed - RR
		patient.balloon_alert(user, "c'est méchanique !")
		return FALSE
	if(affecting.brute_dam && brute || affecting.burn_dam && burn)
		user.visible_message(
			span_infoplain(span_green("[user] applique [src] sur le/la [parse_zone(affecting.body_zone)] de [patient].")),
			span_infoplain(span_green("Vous appliquez [src] sur le/la [parse_zone(affecting.body_zone)] de [patient]."))
		)
		var/previous_damage = affecting.get_damage()
		if(affecting.heal_damage(brute, burn))
			patient.update_damage_overlays()
		post_heal_effects(max(previous_damage - affecting.get_damage(), 0), patient, user)
		return TRUE
	patient.balloon_alert(user, "vous ne pouvez pas soigner ça !")
	return FALSE

///Override this proc for special post heal effects.
/obj/item/stack/medical/proc/post_heal_effects(amount_healed, mob/living/carbon/healed_mob, mob/user)
	return

/obj/item/stack/medical/bruise_pack
	name = "Kit de soins physique"
	singular_name = "kit de soins physique"
	desc = "Un kit de soins contenant de quoi soigner des blessures physique."
	icon_state = "brutepack"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	heal_brute = 40
	self_delay = 4 SECONDS
	other_delay = 2 SECONDS
	grind_results = list(/datum/reagent/medicine/c2/libital = 10)
	merge_type = /obj/item/stack/medical/bruise_pack

/obj/item/stack/medical/bruise_pack/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] tabasse [user.p_them()] avec [src] ! Il semble que [user.p_theyre()] essaie de se suicide !"))
	return BRUTELOSS

/obj/item/stack/medical/gauze
	name = "Gaze médicale"
	desc = "Un rouleau de gaze médicale, parfait pour stabiliser de nombreuse blessures."
	gender = PLURAL
	singular_name = "gaze médicale"
	icon_state = "gauze"
	self_delay = 5 SECONDS
	other_delay = 2 SECONDS
	max_amount = 12
	amount = 6
	grind_results = list(/datum/reagent/cellulose = 2)
	custom_price = PAYCHECK_CREW * 2
	absorption_rate = 0.125
	absorption_capacity = 5
	splint_factor = 0.7
	burn_cleanliness_bonus = 0.35
	merge_type = /obj/item/stack/medical/gauze

// gauze is only relevant for wounds, which are handled in the wounds themselves
/obj/item/stack/medical/gauze/try_heal(mob/living/patient, mob/user, silent)
	var/obj/item/bodypart/limb = patient.get_bodypart(check_zone(user.zone_selected))
	if(!limb)
		patient.balloon_alert(user, "le membre manque !") //Tant que c'est pas celui auquel je pense...
		return
	if(!LAZYLEN(limb.wounds))
		patient.balloon_alert(user, "aucune blessure !") // good problem to have imo
		return

	var/gauzeable_wound = FALSE
	for(var/i in limb.wounds)
		var/datum/wound/woundies = i
		if(woundies.wound_flags & ACCEPTS_GAUZE)
			gauzeable_wound = TRUE
			break
	if(!gauzeable_wound)
		patient.balloon_alert(user, "impossible de soigner ces blessures !")
		return

	if(limb.current_gauze && (limb.current_gauze.absorption_capacity * 1.2 > absorption_capacity)) // ignore if our new wrap is < 20% better than the current one, so someone doesn't bandage it 5 times in a row
		patient.balloon_alert(user, "deja bandagé !")
		return

	user.visible_message(span_warning("[user] commence à couvrir les blessures de le/la [limb.plaintext_zone] de [patient] avec [src]..."), span_warning("Vous commencez à couvrir les blessures de le/la [limb.plaintext_zone] de [patient]  avec [src]..."))
	if(!do_after(user, (user == patient ? self_delay : other_delay), target=patient))
		return

	user.visible_message("<span class='infoplain'><span class='green'>[user] applique [src] sur le/la [limb.plaintext_zone] de [patient].</span></span>", "<span class='infoplain'><span class='green'>Vous couvrez les blessures de le/la [limb.plaintext_zone] de [patient].</span></span>")
	limb.apply_gauze(src)

/obj/item/stack/medical/gauze/twelve
	amount = 12

/obj/item/stack/medical/gauze/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER || I.get_sharpness())
		if(get_amount() < 2)
			balloon_alert(user, "pas assez de gaze !")
			return
		new /obj/item/stack/sheet/cloth(I.drop_location())
		if(user.CanReach(src))
			user.visible_message(span_notice("[user] coupe [src] en petite pièces de tissu avec [I]."), \
				span_notice("Vous coupez [src] en petite pièces de tissu avec [I]."), \
				span_hear("Vous entendez un bruit de coupe-coupe."))
		else //telekinesis
			visible_message(span_notice("[I] coupe [src] en petite pièces de tissu."), \
				blind_message = span_hear("Vous entendez un bruit de coupe-coupe."))
		use(2)
	else
		return ..()

/obj/item/stack/medical/gauze/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] commence à sérer [src] autours de la nuqe de [user.p_their()] ! Il semble que [user.p_they()] a oublié comment utilisé du matériel médicale !"))
	return OXYLOSS

/obj/item/stack/medical/gauze/improvised
	name = "gaze improvisé"
	singular_name = "gaze improvisé"
	desc = "Un rouleau de tissu coupé à la va-vite. Moins efficace que de la gaze médicale."
	self_delay = 6 SECONDS
	other_delay = 3 SECONDS
	splint_factor = 0.85
	burn_cleanliness_bonus = 0.7
	absorption_rate = 0.075
	absorption_capacity = 4
	merge_type = /obj/item/stack/medical/gauze/improvised

	/*
	The idea is for the following medical devices to work like a hybrid of the old brute packs and tend wounds,
	they heal a little at a time, have reduced healing density and does not allow for rapid healing while in combat.
	However they provice graunular control of where the healing is directed, this makes them better for curing work-related cuts and scrapes.

	The interesting limb targeting mechanic is retained and i still believe they will be a viable choice, especially when healing others in the field.
	 */

/obj/item/stack/medical/suture
	name = "Fil de suture"
	desc = "Fil de suture stérial tout ce qu'il y'a de plus basique. Utilisé pour stopper les saignements et fermer les coupures profonde."
	gender = PLURAL
	singular_name = "fil de suture"
	icon_state = "suture"
	self_delay = 3 SECONDS
	other_delay = 1 SECONDS
	amount = 10
	max_amount = 10
	repeating = TRUE
	heal_brute = 10
	stop_bleeding = 0.6
	grind_results = list(/datum/reagent/medicine/spaceacillin = 2)
	merge_type = /obj/item/stack/medical/suture

/obj/item/stack/medical/suture/emergency
	name = "Fil de suture d'urgence"
	desc = "Un paquet de fil de suture au rabait. Pas très efficace pour soigner, mais décent pour empêcher les saignements."
	heal_brute = 5
	amount = 5
	max_amount = 5
	merge_type = /obj/item/stack/medical/suture/emergency

/obj/item/stack/medical/suture/medicated
	name = "Fil de suture médicamenté"
	icon_state = "suture_purp"
	desc = "Fil de suture infusé avec des drogues qui rendent la guérison plus rapide."
	heal_brute = 15
	stop_bleeding = 0.75
	grind_results = list(/datum/reagent/medicine/polypyr = 1)
	merge_type = /obj/item/stack/medical/suture/medicated

/obj/item/stack/medical/ointment
	name = "Paumade"
	desc = "Paumade anti-brulure, a utilisé contre les blessures au second degré, avec des bandages. Peut être aussi utilisé pour traiter des brulures plus étendue."
	gender = PLURAL
	singular_name = "paumade"
	icon_state = "ointment"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	amount = 8
	max_amount = 8
	self_delay = 4 SECONDS
	other_delay = 2 SECONDS

	heal_burn = 5
	flesh_regeneration = 2.5
	sanitization = 0.25
	grind_results = list(/datum/reagent/medicine/c2/lenturi = 10)
	merge_type = /obj/item/stack/medical/ointment

/obj/item/stack/medical/ointment/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] presse [src] dans leur bouche [user.p_their()] ! [user.p_they()] ne sait-il donc pas que c'est toxique ?"))
	return TOXLOSS

/obj/item/stack/medical/mesh
	name = "Bandage régénératif"
	desc = "Un bandage anti-bactérien qui soinge efficacement les brulures."
	gender = PLURAL
	singular_name = "morceau de bandage"
	icon_state = "regen_mesh"
	self_delay = 3 SECONDS
	other_delay = 1 SECONDS
	amount = 15
	heal_burn = 10
	max_amount = 15
	repeating = TRUE
	sanitization = 0.75
	flesh_regeneration = 3

	var/is_open = TRUE ///This var determines if the sterile packaging of the mesh has been opened.
	grind_results = list(/datum/reagent/medicine/spaceacillin = 2)
	merge_type = /obj/item/stack/medical/mesh

/obj/item/stack/medical/mesh/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	if(amount == max_amount)  //only seal full mesh packs
		is_open = FALSE
		update_appearance()

/obj/item/stack/medical/mesh/update_icon_state()
	if(is_open)
		return ..()
	icon_state = "regen_mesh_closed"

/obj/item/stack/medical/mesh/try_heal(mob/living/patient, mob/user, silent = FALSE)
	if(!is_open)
		balloon_alert(user, "Il faut d'abord l'ouvrir !")
		return
	return ..()

/obj/item/stack/medical/mesh/AltClick(mob/living/user)
	if(!is_open)
		balloon_alert(user, "Il faut d'abord l'ouvrir !")
		return
	return ..()

/obj/item/stack/medical/mesh/attack_hand(mob/user, list/modifiers)
	if(!is_open && user.get_inactive_held_item() == src)
		balloon_alert(user, "Il faut d'abord l'ouvrir !")
		return
	return ..()

/obj/item/stack/medical/mesh/attack_self(mob/user)
	if(!is_open)
		is_open = TRUE
		balloon_alert(user, "ouvert")
		update_appearance()
		playsound(src, 'sound/items/poster_ripped.ogg', 20, TRUE)
		return
	return ..()

/obj/item/stack/medical/mesh/advanced
	name = "Bandage régénératif avancé"
	desc = "Un bandage avancé fait avec des extraits d'aloe et des produits chimique stabilisant. A utilisé pour soigner des brulures."

	gender = PLURAL
	icon_state = "aloe_mesh"
	heal_burn = 15
	sanitization = 1.25
	flesh_regeneration = 3.5
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)
	merge_type = /obj/item/stack/medical/mesh/advanced

/obj/item/stack/medical/mesh/advanced/update_icon_state()
	if(is_open)
		return ..()
	icon_state = "aloe_mesh_closed"

/obj/item/stack/medical/aloe
	name = "Crême d'aloe"
	desc = "Une paumade soignante pour les petites coupures et brulure."

	gender = PLURAL
	singular_name = "crême d'aloe"
	icon_state = "aloe_paste"
	self_delay = 2 SECONDS
	other_delay = 1 SECONDS
	novariants = TRUE
	amount = 20
	max_amount = 20
	repeating = TRUE
	heal_brute = 3
	heal_burn = 3
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)
	merge_type = /obj/item/stack/medical/aloe

/obj/item/stack/medical/aloe/fresh
	amount = 2

/obj/item/stack/medical/bone_gel
	name = "Colle à os"
	singular_name = "bone gel"
	desc = "Une colle médical qui une fois appliqué sur des os provoque une violente réaction qui répare les os."
	icon = 'icons/obj/medical/surgery_tools.dmi'
	icon_state = "bone-gel"
	inhand_icon_state = "bone-gel"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

	amount = 1
	self_delay = 20
	grind_results = list(/datum/reagent/bone_dust = 10, /datum/reagent/carbon = 10)
	novariants = TRUE
	merge_type = /obj/item/stack/medical/bone_gel

/obj/item/stack/medical/bone_gel/attack(mob/living/patient, mob/user)
	patient.balloon_alert(user, "pas de fracture !")
	return

/obj/item/stack/medical/bone_gel/suicide_act(mob/living/user)
	if(!iscarbon(user))
		return
	var/mob/living/carbon/patient = user
	patient.visible_message(span_suicide("[patient] éjecte [src] dans la bouche de [patient.p_their()] ! Ce n'est pas une procédure correcte ! Il semble que [patient] essaie de se suicider !"))
	if(!do_after(patient, 2 SECONDS))
		patient.visible_message(span_suicide("[patient] rates comme un abruti et meurt quand même !"))
		return BRUTELOSS

	patient.emote("scream")
	for(var/i in patient.bodyparts)
		var/obj/item/bodypart/bone = i
		var/datum/wound/blunt/severe/oof_ouch = new
		oof_ouch.apply_wound(bone)
		var/datum/wound/blunt/critical/oof_OUCH = new
		oof_OUCH.apply_wound(bone)

	for(var/i in patient.bodyparts)
		var/obj/item/bodypart/bone = i
		bone.receive_damage(brute=60)
	use(1)
	return BRUTELOSS

/obj/item/stack/medical/bone_gel/four
	amount = 4

/obj/item/stack/medical/poultice
	name = "Cataplasmes de deuille"
	singular_name = "Cataplasme de deuille"
	desc = "Un type de cataplasme primitif à base d'herbe médical. Utilisé traditionellement pour préparer des cadavres. Ils peuvent aussi soigné les blessures et brulure des vivants, mais causant des pertes de respiration."
	icon_state = "poultice"
	amount = 15
	max_amount = 15
	heal_brute = 10
	heal_burn = 10
	self_delay = 40
	other_delay = 10
	repeating = TRUE
	drop_sound = 'sound/misc/moist_impact.ogg'
	mob_throw_hit_sound = 'sound/misc/moist_impact.ogg'
	hitsound = 'sound/misc/moist_impact.ogg'
	merge_type = /obj/item/stack/medical/poultice

/obj/item/stack/medical/poultice/heal(mob/living/patient, mob/user)
	if(iscarbon(patient))
		playsound(src, 'sound/misc/soggy.ogg', 30, TRUE)
		return heal_carbon(patient, user, heal_brute, heal_burn)
	return ..()

/obj/item/stack/medical/poultice/post_heal_effects(amount_healed, mob/living/carbon/healed_mob, mob/user)
	. = ..()
	healed_mob.adjustOxyLoss(amount_healed)
