/obj/structure/reagent_dispensers
	name = "Dispenser"
	desc = "..."
	icon = 'icons/obj/medical/chemical_tanks.dmi'
	icon_state = "water"
	density = TRUE
	anchored = FALSE
	pressure_resistance = 2*ONE_ATMOSPHERE
	max_integrity = 300
	/// In units, how much the dispenser can hold
	var/tank_volume = 1000
	/// The ID of the reagent that the dispenser uses
	var/reagent_id = /datum/reagent/water
	/// Can you turn this into a plumbing tank?
	var/can_be_tanked = TRUE
	/// Is this source self-replenishing?
	var/refilling = FALSE
	/// Can this dispenser be opened using a wrench?
	var/openable = FALSE
	/// Is this dispenser slowly leaking its reagent?
	var/leaking = FALSE
	/// How much reagent to leak
	var/amount_to_leak = 10
	/// An assembly attached to the tank - if this dispenser accepts_rig
	var/obj/item/assembly_holder/rig = null
	/// Whether this dispenser can be rigged with an assembly (and blown up with an igniter)
	var/accepts_rig = FALSE
	//overlay of attached assemblies
	var/mutable_appearance/assembliesoverlay
	/// The person who attached an assembly to this dispenser, for bomb logging purposes
	var/last_rigger = ""

// This check is necessary for assemblies to automatically detect that we are compatible
/obj/structure/reagent_dispensers/IsSpecialAssembly()
	return accepts_rig

/obj/structure/reagent_dispensers/Destroy()
	QDEL_NULL(rig)
	return ..()

/**
 * rig_boom: Wrapper to log when a reagent_dispenser is set off by an assembly
 *
 */
/obj/structure/reagent_dispensers/proc/rig_boom()
	log_bomber(last_rigger, "rigged [src] exploded", src)
	boom()

/obj/structure/reagent_dispensers/Initialize(mapload)
	. = ..()

	if(icon_state == "water" && check_holidays(APRIL_FOOLS))
		icon_state = "water_fools"

/obj/structure/reagent_dispensers/examine(mob/user)
	. = ..()
	if(can_be_tanked)
		. += span_notice("Un lingot de fer peut être utilisé pour convertir ce distribiteur en version avec plomberie.")
	if(openable)
		if(!leaking)
			. += span_notice("Le robinet peut être ouvert avec une <b>clé à molette</b>.")
		else
			. += span_warning("Le robinet a été ouvert avec une <b>clé à molette</b> !")
	if(accepts_rig && get_dist(user, src) <= 2)
		if(rig)
			. += span_warning("Il y'a un objet <b>connecté</b> au reservoir !")
		else
			. += span_notice("Vous pourriez <b>connecter</b> un objet sur le reservoir.")


/obj/structure/reagent_dispensers/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(. && atom_integrity > 0)
		if(tank_volume && (damage_flag == BULLET || damage_flag == LASER))
			boom()

/obj/structure/reagent_dispensers/attackby(obj/item/W, mob/user, params)
	if(W.is_refillable())
		return FALSE //so we can refill them via their afterattack.
	if(istype(W, /obj/item/assembly_holder) && accepts_rig)
		if(rig)
			balloon_alert(user, "Il y'a déja quelque chose de connecté.")
			return ..()
		var/obj/item/assembly_holder/holder = W
		if(!(locate(/obj/item/assembly/igniter) in holder.assemblies))
			return ..()

		user.balloon_alert_to_viewers("Vous connectez l'object...")
		add_fingerprint(user)
		if(!do_after(user, 2 SECONDS, target = src) || !user.transferItemToLoc(holder, src))
			return
		rig = holder
		holder.master = src
		holder.on_attach()
		assembliesoverlay = holder
		assembliesoverlay.pixel_x += 6
		assembliesoverlay.pixel_y += 1
		add_overlay(assembliesoverlay)
		RegisterSignal(src, COMSIG_IGNITER_ACTIVATE, PROC_REF(rig_boom))
		log_bomber(user, "attached [holder.name] to ", src)
		last_rigger = user
		user.balloon_alert_to_viewers("object connecté")
		return

	if(istype(W, /obj/item/stack/sheet/iron) && can_be_tanked)
		var/obj/item/stack/sheet/iron/metal_stack = W
		metal_stack.use(1)
		var/obj/structure/reagent_dispensers/plumbed/storage/new_tank = new /obj/structure/reagent_dispensers/plumbed/storage(drop_location())
		new_tank.reagents.maximum_volume = reagents.maximum_volume
		reagents.trans_to(new_tank, reagents.total_volume)
		new_tank.name = "[name] stationnaire"
		new_tank.update_appearance(UPDATE_OVERLAYS)
		new_tank.set_anchored(anchored)
		qdel(src)
		return FALSE

	return ..()

/obj/structure/reagent_dispensers/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == rig)
		rig = null

/obj/structure/reagent_dispensers/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(. || !rig)
		return
	// mousetrap rigs only make sense if you can set them off, can't step on them
	// If you see a mousetrap-rigged fuel tank, just leave it alone
	rig.on_found()
	if(QDELETED(src))
		return
	user.balloon_alert_to_viewers("vous détachez l'objet...")
	if(!do_after(user, 2 SECONDS, target = src))
		return
	user.balloon_alert_to_viewers("vous avez détaché l'objet")
	user.log_message("detached [rig] from [src].", LOG_GAME)
	if(!user.put_in_hands(rig))
		rig.forceMove(get_turf(user))
	rig = null
	last_rigger = null
	cut_overlays(assembliesoverlay)
	UnregisterSignal(src, COMSIG_IGNITER_ACTIVATE)

/obj/structure/reagent_dispensers/Initialize(mapload)
	create_reagents(tank_volume, DRAINABLE | AMOUNT_VISIBLE)
	if(reagent_id)
		reagents.add_reagent(reagent_id, tank_volume)
	. = ..()

/**
 * boom: Detonate a reagent dispenser.
 *
 * This is most dangerous for fuel tanks, which will explosion().
 * Other dispensers will scatter their contents within range.
 */
/obj/structure/reagent_dispensers/proc/boom()
	var/datum/reagent/fuel/volatiles = reagents.has_reagent(/datum/reagent/fuel)
	var/fuel_amt = 0
	if(istype(volatiles) && volatiles.volume >= 25)
		fuel_amt = volatiles.volume
		reagents.del_reagent(/datum/reagent/fuel) // not actually used for the explosion
	if(reagents.total_volume)
		if(!fuel_amt)
			visible_message(span_danger("Lae [src] se perce !"))
		// Leave it up to future terrorists to figure out the best way to mix reagents with fuel for a useful boom here
		chem_splash(loc, null, 2 + (reagents.total_volume + fuel_amt) / 1000, list(reagents), extra_heat=(fuel_amt / 50),adminlog=(fuel_amt<25))

	if(fuel_amt) // with that done, actually explode
		visible_message(span_danger("Lae [src] explose !"))
		// old code for reference:
		// standard fuel tank = 1000 units = heavy_impact_range = 1, light_impact_range = 5, flame_range = 5
		// big fuel tank = 5000 units = devastation_range = 1, heavy_impact_range = 2, light_impact_range = 7, flame_range = 12
		// It did not account for how much fuel was actually in the tank at all, just the size of the tank.
		// I encourage others to better scale these numbers in the future.
		// As it stands this is a minor nerf in exchange for an easy bombing technique working that has been broken for a while.
		switch(volatiles.volume)
			if(25 to 150)
				explosion(src, light_impact_range = 1, flame_range = 2)
			if(150 to 300)
				explosion(src, light_impact_range = 2, flame_range = 3)
			if(300 to 750)
				explosion(src, heavy_impact_range = 1, light_impact_range = 3, flame_range = 5)
			if(750 to 1500)
				explosion(src, heavy_impact_range = 1, light_impact_range = 4, flame_range = 6)
			if(1500 to INFINITY)
				explosion(src, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 6, flame_range = 8)
	qdel(src)

/obj/structure/reagent_dispensers/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!disassembled)
			boom()
	else
		qdel(src)

/obj/structure/reagent_dispensers/proc/tank_leak()
	if(leaking && reagents && reagents.total_volume >= amount_to_leak)
		reagents.expose(get_turf(src), TOUCH, amount_to_leak / max(amount_to_leak, reagents.total_volume))
		reagents.remove_reagent(reagent_id, amount_to_leak)
		return TRUE
	return FALSE

/obj/structure/reagent_dispensers/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(!openable)
		return FALSE
	leaking = !leaking
	balloon_alert(user, "[leaking ? "ouvert" : "fermé"] le robinet de lae [src].")
	user.log_message("[leaking ? "opened" : "closed"] [src].", LOG_GAME)
	tank_leak()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/reagent_dispensers/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	tank_leak()

/obj/structure/reagent_dispensers/watertank
	name = "réservoir d'eau"
	desc = "Un réservoir d'eau."
	icon_state = "water"
	openable = TRUE

/obj/structure/reagent_dispensers/watertank/high
	name = "réservoir d'eau à haute capacité"
	desc = "Un réservoir d'eau à haute capacité fait pour contenir de gigantesque quantité d'eau."
	icon_state = "water_high" //I was gonna clean my room...
	tank_volume = 100000

/obj/structure/reagent_dispensers/foamtank
	name = "résevoir de mousse anti-incendie"
	desc = "Un réservoir remplie de mousse anti-incendie."
	icon_state = "foam"
	reagent_id = /datum/reagent/firefighting_foam
	tank_volume = 500
	openable = TRUE

/obj/structure/reagent_dispensers/fueltank
	name = "résevoir de carburant pour soudeur"
	desc = "Un réservoir remplie de carburant pour soudeur. Ne pas avaler."
	icon_state = "fuel"
	reagent_id = /datum/reagent/fuel
	openable = TRUE
	accepts_rig = TRUE

/obj/structure/reagent_dispensers/fueltank/Initialize(mapload)
	. = ..()

	if(check_holidays(APRIL_FOOLS))
		icon_state = "fuel_fools"

/obj/structure/reagent_dispensers/fueltank/blob_act(obj/structure/blob/B)
	boom()

/obj/structure/reagent_dispensers/fueltank/ex_act()
	boom()

/obj/structure/reagent_dispensers/fueltank/fire_act(exposed_temperature, exposed_volume)
	boom()

/obj/structure/reagent_dispensers/fueltank/zap_act(power, zap_flags)
	. = ..() //extend the zap
	if(ZAP_OBJ_DAMAGE & zap_flags)
		boom()

/obj/structure/reagent_dispensers/fueltank/bullet_act(obj/projectile/P)
	. = ..()
	if(QDELETED(src)) //wasn't deleted by the projectile's effects.
		return

	if(P.damage > 0 && ((P.damage_type == BURN) || (P.damage_type == BRUTE)))
		log_bomber(P.firer, "detonated a", src, "via projectile")
		boom()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_WELDER)
		if(!reagents.has_reagent(/datum/reagent/fuel))
			to_chat(user, span_warning("[src] n'a plus de carburant !"))
			return
		var/obj/item/weldingtool/W = I
		if(istype(W) && !W.welding)
			if(W.reagents.has_reagent(/datum/reagent/fuel, W.max_fuel))
				to_chat(user, span_warning("Votre [W.name] est plein !"))
				return
			reagents.trans_to(W, W.max_fuel, transfered_by = user)
			user.visible_message(span_notice("[user] remplie son/sa [W.name]."), span_notice("Vous remplissez votre [W.name]"))
			playsound(src, 'sound/effects/refill.ogg', 50, TRUE)
			W.update_appearance()
		else
			user.visible_message(span_danger("[user] échoue de façon catastrophique a remplir leur [I.name] !"), span_userdanger("C'était vraiment stupide de votre part."))
			log_bomber(user, "detonated a", src, "via welding tool")
			boom()
		return

	return ..()

/obj/structure/reagent_dispensers/fueltank/large
	name = "réservoir de carburant de soudeur de haute capacité"
	desc = "Un réservoir de carburant de soudeur à haute capacité. Ne pas approcher du feu."
	icon_state = "fuel_high"
	tank_volume = 5000

/// Wall mounted dispeners, like pepper spray or virus food. Not a normal tank, and shouldn't be able to be turned into a plumbed stationary one.
/obj/structure/reagent_dispensers/wall
	anchored = TRUE
	density = FALSE
	can_be_tanked = FALSE

/obj/structure/reagent_dispensers/wall/peppertank
	name = "station de recharge pour spray au poivre"
	desc = "Contient de la capsaicin concentré. Reservé à l'utilisation de agents de \"l'ordre\"."
	icon_state = "pepper"
	reagent_id = /datum/reagent/consumable/condensedcapsaicin

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/reagent_dispensers/wall/peppertank, 30)

/obj/structure/reagent_dispensers/wall/peppertank/Initialize(mapload)
	. = ..()
	if(prob(1))
		desc = "C'EST L'HEURE DU POIVRE, SALOPE"

/obj/structure/reagent_dispensers/water_cooler
	name = "glacière"
	desc = "Une machine qui distribue des liquides à boire."
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	anchored = TRUE
	tank_volume = 500
	var/paper_cups = 25 //Paper cups left from the cooler

/obj/structure/reagent_dispensers/water_cooler/examine(mob/user)
	. = ..()
	if (paper_cups > 1)
		. += "Il y'a encore [paper_cups] verre en papier en réserve."
	else if (paper_cups == 1)
		. += "Il y'a encore 1 verre en papier en réserve."
	else
		. += "Il n y'a plus de verre en papier en réserve."

/obj/structure/reagent_dispensers/water_cooler/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!paper_cups)
		to_chat(user, span_warning("Il n'y a plus de verre !"))
		return
	user.visible_message(span_notice("[user] prend un verre de la [src]."), span_notice("Vous prennez un verre en papier de la [src]."))
	var/obj/item/reagent_containers/cup/glass/sillycup/S = new(get_turf(src))
	user.put_in_hands(S)
	paper_cups--

/obj/structure/reagent_dispensers/beerkeg
	name = "fût à bière"
	desc = "La bière c'est du pain liquide, c'est bon pour vous..."
	icon_state = "beer"
	reagent_id = /datum/reagent/consumable/ethanol/beer
	openable = TRUE

/obj/structure/reagent_dispensers/beerkeg/blob_act(obj/structure/blob/B)
	explosion(src, heavy_impact_range = 3, light_impact_range = 5, flame_range = 10, flash_range = 7)
	if(!QDELETED(src))
		qdel(src)

/obj/structure/reagent_dispensers/wall/virusfood
	name = "distributeur de nourriture à virus"
	desc = "Un distributeur de mutagène pour virus."
	icon_state = "virus_food"
	reagent_id = /datum/reagent/consumable/virus_food

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/reagent_dispensers/wall/virusfood, 30)

/obj/structure/reagent_dispensers/cooking_oil
	name = "fût d'huile de cuisson"
	desc = "Un gros fût en métal avec un robinet devant. Il est remplie d'huile de cuisson."
	icon_state = "vat"
	anchored = TRUE
	reagent_id = /datum/reagent/consumable/cooking_oil
	openable = TRUE

/obj/structure/reagent_dispensers/servingdish
	name = "plât"
	desc = "Un plât remplie de nourriture horrible pour votre bol."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "serving"
	anchored = TRUE
	reagent_id = /datum/reagent/consumable/nutraslop

/obj/structure/reagent_dispensers/plumbed
	name = "réservoir d'eau stationnaire"
	anchored = TRUE
	icon_state = "water_stationary"
	desc = "Un réservoir d'eau, stationnaire avec de la plomberie."
	can_be_tanked = FALSE

/obj/structure/reagent_dispensers/plumbed/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_supply)

/obj/structure/reagent_dispensers/plumbed/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/reagent_dispensers/plumbed/storage
	name = "réservoir de stockage stationnaire"
	icon_state = "tank_stationary"
	reagent_id = null //start empty

/obj/structure/reagent_dispensers/plumbed/storage/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/structure/reagent_dispensers/plumbed/storage/AltClick(mob/user)
	return ..() // This hotkey is BLACKLISTED since it's used by /datum/component/simple_rotation

/obj/structure/reagent_dispensers/plumbed/storage/update_overlays()
	. = ..()
	if(!reagents)
		return

	if(!reagents.total_volume)
		return

	var/mutable_appearance/tank_color = mutable_appearance('icons/obj/medical/chemical_tanks.dmi', "tank_chem_overlay")
	tank_color.color = mix_color_from_reagents(reagents.reagent_list)
	. += tank_color

/obj/structure/reagent_dispensers/plumbed/fuel
	name = "réservoir de carburant stationnaire"
	icon_state = "fuel_stationary"
	desc = "Un réservoir de carburant, stationnaire avec de la plomberie."
	reagent_id = /datum/reagent/fuel
	accepts_rig = TRUE
