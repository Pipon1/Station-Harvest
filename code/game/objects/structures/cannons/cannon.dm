///how much projectile damage is lost when using a bad fuel
#define BAD_FUEL_DAMAGE_TAX 20
///extra chance it explodes upon firing
#define BAD_FUEL_EXPLODE_PROBABILTY 10

/obj/structure/cannon
	name = "Canon"
	desc = "Perforeur Deluxe: un modèle de sport avec un bon pouvoir d'arrêt. Tout amateur de canon devrait commencer par celui-ci."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/weapons/cannons.dmi'
	icon_state = "falconet_patina"
	max_integrity = 300
	///whether the cannon can be unwrenched from the ground.
	var/anchorable_cannon = TRUE
	var/obj/item/stack/cannonball/loaded_cannonball = null
	var/charge_ignited = FALSE
	var/fire_delay = 15
	var/charge_size = 15
	var/fire_sound = 'sound/weapons/gun/general/cannon.ogg'

/obj/structure/cannon/Initialize(mapload)
	. = ..()
	create_reagents(charge_size)

/obj/structure/cannon/examine(mob/user)
	. = ..()
	. += span_notice("[src] accepte de la poudre à canon ou du combustible à souder.")
	. += span_warning("Utiliser du combustible à souder affaiblira la force du projectile propulsé.")

/obj/structure/cannon/proc/fire()
	for(var/mob/shaken_mob in urange(10, src))
		if(shaken_mob.stat == CONSCIOUS)
			shake_camera(shaken_mob, 3, 1)

		playsound(src, fire_sound, 50, TRUE)
		flick(icon_state+"_fire", src)
	if(loaded_cannonball)
		var/obj/projectile/fired_projectile = new loaded_cannonball.projectile_type(get_turf(src))
		if(reagents.has_reagent(/datum/reagent/fuel, charge_size))
			fired_projectile.damage = max(2, fired_projectile.damage - BAD_FUEL_DAMAGE_TAX)
		QDEL_NULL(loaded_cannonball)
		fired_projectile.firer = src
		fired_projectile.fired_from = src
		fired_projectile.fire(dir2angle(dir))
	reagents.remove_all()
	charge_ignited = FALSE

/obj/structure/cannon/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(!anchorable_cannon)
		return FALSE
	default_unfasten_wrench(user, tool)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/cannon/attackby(obj/item/used_item, mob/user, params)
	if(charge_ignited)
		balloon_alert(user, "Ca va faire feu !")
		return
	var/ignition_message = used_item.ignition_effect(src, user)

	if(istype(used_item, /obj/item/stack/cannonball))
		if(loaded_cannonball)
			balloon_alert(user, "Déjà chargé !")
		else
			var/obj/item/stack/cannonball/cannoneers_balls = used_item
			loaded_cannonball = new cannoneers_balls.type(src, 1)
			loaded_cannonball.copy_evidences(cannoneers_balls)
			balloon_alert(user, "a chargé un [cannoneers_balls.singular_name]")
			cannoneers_balls.use(1, transfer = TRUE)
		return

	else if(ignition_message)
		if(!reagents.has_reagent(/datum/reagent/gunpowder,charge_size) && !reagents.has_reagent(/datum/reagent/fuel,charge_size))
			balloon_alert(user, "a besoin d'une dose de [reagents.maximum_volume] !")
			return
		visible_message(ignition_message)
		user.log_message("a tiré au canon", LOG_ATTACK)
		log_game("[key_name(user)] a tiré au canon ici : [AREACOORD(src)]")
		addtimer(CALLBACK(src, PROC_REF(fire)), fire_delay)
		charge_ignited = TRUE
		return

	else if(is_reagent_container(used_item))
		var/obj/item/reagent_containers/powder_keg = used_item
		if(!(powder_keg.reagent_flags & OPENCONTAINER))
			return ..()
		if(istype(powder_keg, /obj/item/reagent_containers/cup/rag))
			return ..()

		if(!powder_keg.reagents.total_volume)
			balloon_alert(user, "[powder_keg] est vide !")
			return
		if(reagents.total_volume == reagents.maximum_volume)
			balloon_alert(user, "[src] est plein !")
			return
		var/has_enough_gunpowder = powder_keg.reagents.has_reagent(/datum/reagent/gunpowder, charge_size)
		var/has_enough_alt_fuel = powder_keg.reagents.has_reagent(/datum/reagent/fuel, charge_size)
		if(!has_enough_gunpowder && !has_enough_alt_fuel)
			balloon_alert(user, "[powder_keg] a besoin d'une dose de 15u pour charger !")
			to_chat(user, span_warning("[powder_keg] n'a pas une dose d'au moins 15u pour remplir [src]!"))
			return
		if(has_enough_gunpowder)
			powder_keg.reagents.trans_id_to(src, /datum/reagent/gunpowder, amount = charge_size)
			balloon_alert(user, "[src] chargé avec de la poudre à canon.")
			return
		if(has_enough_alt_fuel)
			powder_keg.reagents.trans_id_to(src, /datum/reagent/fuel, amount = charge_size)
			balloon_alert(user, "[src] chargé avec du combustilbe à souder.")
			return
	..()

/obj/structure/cannon/trash
	name = "Canon de la rue"
	desc = "Oui, d'accord, vous pouvez appeler ca une boîte à outils soudée à une bouteille d'oxygène cablée à un skateboard, mais c'est un CANON DE LA RUE pour nous."
	icon_state = "garbagegun"
	anchored = FALSE
	anchorable_cannon = FALSE
	var/fires_before_deconstruction = 5

/obj/structure/cannon/trash/fire()
	var/explode_chance = 10
	var/used_alt_fuel = reagents.has_reagent(/datum/reagent/fuel, charge_size)
	if(used_alt_fuel)
		explode_chance += BAD_FUEL_EXPLODE_PROBABILTY
	. = ..()
	fires_before_deconstruction--
	if(used_alt_fuel)
		fires_before_deconstruction--
	if(prob(explode_chance))
		visible_message(span_userdanger("[src] explose !"))
		explosion(src, heavy_impact_range = 1, light_impact_range = 5, flame_range = 5)
		return
	if(fires_before_deconstruction <= 0)
		visible_message(span_warning("[src] se brise durant l'opération !"))
		qdel(src)

/obj/structure/cannon/trash/Destroy()
	new /obj/item/stack/sheet/iron/five(src.loc)
	new /obj/item/stack/rods(src.loc)
	. = ..()

#undef BAD_FUEL_DAMAGE_TAX
#undef BAD_FUEL_EXPLODE_PROBABILTY
