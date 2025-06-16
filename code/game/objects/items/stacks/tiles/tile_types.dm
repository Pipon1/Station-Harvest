/**
 * TILE STACKS
 *
 * Allows us to place a turf on a plating.
 */
/obj/item/stack/tile
	name = "dalles brisées"
	singular_name = "dalle brisée"
	desc = "Une dalle brisée. Cela ne devrait pas exister."
	lefthand_file = 'icons/mob/inhands/items/tiles_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/tiles_righthand.dmi'
	icon = 'icons/obj/tiles.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 1
	throwforce = 1
	throw_speed = 3
	throw_range = 7
	max_amount = 60
	novariants = TRUE
	material_flags = MATERIAL_EFFECTS
	/// What type of turf does this tile produce.
	var/turf_type = null
	/// What dir will the turf have?
	var/turf_dir = SOUTH
	/// Cached associative lazy list to hold the radial options for tile reskinning. See tile_reskinning.dm for more information. Pattern: list[type] -> image
	var/list/tile_reskin_types
	/// Cached associative lazy list to hold the radial options for tile dirs. See tile_reskinning.dm for more information.
	var/list/tile_rotate_dirs
	/// Allows us to replace the plating we are attacking if our baseturfs are the same.
	var/replace_plating = FALSE

/obj/item/stack/tile/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = rand(-3, 3)
	pixel_y = rand(-3, 3) //randomize a little
	if(tile_reskin_types)
		tile_reskin_types = tile_reskin_list(tile_reskin_types)
	if(tile_rotate_dirs)
		var/list/values = list()
		for(var/set_dir in tile_rotate_dirs)
			values += dir2text(set_dir)
		tile_rotate_dirs = tile_dir_list(values, turf_type)


/obj/item/stack/tile/examine(mob/user)
	. = ..()
	if(tile_reskin_types || tile_rotate_dirs)
		. += span_notice("Utilisez-ceci en main pour changer le type de [src] que vous voulez.")
	if(throwforce && !is_cyborg) //do not want to divide by zero or show the message to borgs who can't throw
		var/verb
		switch(CEILING(MAX_LIVING_HEALTH / throwforce, 1)) //throws to crit a human
			if(1 to 3)
				verb = "superbe arme de jet"
			if(4 to 6)
				verb = "arme de jet correcte"
			if(7 to 9)
				verb = "bonne arme de jet"
			if(10 to 12)
				verb = "arme de jet plutôt décente"
			if(13 to 15)
				verb = "arme de jet médiocre"
		if(!verb)
			return
		. += span_notice("[src] peut être utilisé comme une [verb].")

/**
 * Place our tile on a plating, or replace it.
 *
 * Arguments:
 * * target_plating - Instance of the plating we want to place on. Replaced during sucessful executions.
 * * user - The mob doing the placing.
 */
/obj/item/stack/tile/proc/place_tile(turf/open/floor/plating/target_plating, mob/user)
	var/turf/placed_turf_path = turf_type
	if(!ispath(placed_turf_path))
		return
	if(!istype(target_plating))
		return

	if(!replace_plating)
		if(!use(1))
			return
		target_plating = target_plating.PlaceOnTop(placed_turf_path, flags = CHANGETURF_INHERIT_AIR)
		target_plating.setDir(turf_dir)
		playsound(target_plating, 'sound/weapons/genhit.ogg', 50, TRUE)
		return target_plating // Most executions should end here.

	// If we and the target tile share the same initial baseturf and they consent, replace em.
	if(!target_plating.allow_replacement || initial(target_plating.baseturfs) != initial(placed_turf_path.baseturfs))
		to_chat(user, span_notice("Vous ne pouvez pas placer cette dalle ici !"))
		return
	to_chat(user, span_notice("Vous commencez à remplacer le sol avec la dalle..."))
	if(!istype(target_plating))
		return
	if(!use(1))
		return

	target_plating = target_plating.ChangeTurf(placed_turf_path, target_plating.baseturfs, CHANGETURF_INHERIT_AIR)
	target_plating.setDir(turf_dir)
	playsound(target_plating, 'sound/weapons/genhit.ogg', 50, TRUE)
	return target_plating

//Grass
/obj/item/stack/tile/grass
	name = "dalles en herbe"
	singular_name = "dalle en herbe"
	desc = "Un morceau de gazon comme on en trouve sur les terrains de golf spatiaux."
	icon_state = "tile_grass"
	inhand_icon_state = "tile-grass"
	turf_type = /turf/open/floor/grass
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/grass

//Fairygrass
/obj/item/stack/tile/fairygrass
	name = "dalles en herbe féerique"
	singular_name = "dalle en herbe féerique"
	desc = "Un morceau de gazon bleu étrange."
	icon_state = "tile_fairygrass"
	turf_type = /turf/open/floor/grass/fairy
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/fairygrass

//Wood
/obj/item/stack/tile/wood
	name = "dalles en bois"
	singular_name = "dalle en bois"
	desc = "Une dalle de sol en bois facile à poser. Utilisez-la en main pour changer le motif."
	icon_state = "tile-wood"
	inhand_icon_state = "tile-wood"
	turf_type = /turf/open/floor/wood
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/wood
	tile_reskin_types = list(
		/obj/item/stack/tile/wood,
		/obj/item/stack/tile/wood/large,
		/obj/item/stack/tile/wood/tile,
		/obj/item/stack/tile/wood/parquet,
	)

/obj/item/stack/tile/wood/parquet
	name = "dalles en parquet"
	singular_name = "dalle en parquet"
	icon_state = "tile-wood_parquet"
	turf_type = /turf/open/floor/wood/parquet
	merge_type = /obj/item/stack/tile/wood/parquet

/obj/item/stack/tile/wood/large
	name = "grande dalles en bois"
	singular_name = "grande dalle en bois"
	icon_state = "tile-wood_large"
	turf_type = /turf/open/floor/wood/large
	merge_type = /obj/item/stack/tile/wood/large

/obj/item/stack/tile/wood/tile
	name = "dalles en bois carrelées"
	singular_name = "dalle en bois carrelée"
	icon_state = "tile-wood_tile"
	turf_type = /turf/open/floor/wood/tile
	merge_type = /obj/item/stack/tile/wood/tile

//Bamboo
/obj/item/stack/tile/bamboo
	name = "morceaux de tapis en bambou"
	singular_name = "morceau de tapis en bambou"
	desc = "Un morceau de tapis en bambou avec une bordure décorative."
	icon_state = "tile_bamboo"
	inhand_icon_state = "tile-bamboo"
	turf_type = /turf/open/floor/bamboo
	merge_type = /obj/item/stack/tile/bamboo
	resistance_flags = FLAMMABLE
	tile_reskin_types = list(
		/obj/item/stack/tile/bamboo,
		/obj/item/stack/tile/bamboo/tatami,
		/obj/item/stack/tile/bamboo/tatami/purple,
		/obj/item/stack/tile/bamboo/tatami/black,
	)

/obj/item/stack/tile/bamboo/tatami
	name = "Tatamis avec une bordure verte"
	singular_name = "Tanami avec une bordure verte"
	icon_state = "tile_tatami_green"
	turf_type = /turf/open/floor/bamboo/tatami
	merge_type = /obj/item/stack/tile/bamboo/tatami
	tile_rotate_dirs = list(NORTH, EAST, SOUTH, WEST)

/obj/item/stack/tile/bamboo/tatami/purple
	name = "Tatamis avec une bordure violette"
	singular_name = "Tatami avec une bordure violette"
	icon_state = "tile_tatami_purple"
	turf_type = /turf/open/floor/bamboo/tatami/purple
	merge_type = /obj/item/stack/tile/bamboo/tatami/purple

/obj/item/stack/tile/bamboo/tatami/black
	name = "Tatamis avec une bordure noire"
	singular_name = "Tatami avec une bordure noire"
	icon_state = "tile_tatami_black"
	turf_type = /turf/open/floor/bamboo/tatami/black
	merge_type = /obj/item/stack/tile/bamboo/tatami/black

//Basalt
/obj/item/stack/tile/basalt
	name = "dalles en basalte"
	singular_name = "dalle en basalte"
	desc = "Un sol artificiellement fait pour ressembler à un environnement hostile."
	icon_state = "tile_basalt"
	inhand_icon_state = "tile-basalt"
	turf_type = /turf/open/floor/fakebasalt
	merge_type = /obj/item/stack/tile/basalt

//Carpets
/obj/item/stack/tile/carpet
	name = "tapis"
	singular_name = "tapis"
	desc = "Un morceau de tapis. Il est de la même taille qu'une dalle."
	icon_state = "tile-carpet"
	inhand_icon_state = "tile-carpet"
	turf_type = /turf/open/floor/carpet
	resistance_flags = FLAMMABLE
	tableVariant = /obj/structure/table/wood/fancy
	merge_type = /obj/item/stack/tile/carpet
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet,
		/obj/item/stack/tile/carpet/symbol,
		/obj/item/stack/tile/carpet/star,
	)

/obj/item/stack/tile/carpet/symbol
	name = "tapis avec un symbole"
	singular_name = "tapis avec des symboles"
	icon_state = "tile-carpet-symbol"
	desc = "Un morceau de tapis. Celui-ci a un symbole dessus."
	turf_type = /turf/open/floor/carpet/lone
	merge_type = /obj/item/stack/tile/carpet/symbol
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST, SOUTHEAST)

/obj/item/stack/tile/carpet/star
	name = "tapis étoilé"
	singular_name = "tapis étoilé"
	icon_state = "tile-carpet-star"
	desc = "Un morceau de tapis. Celui-ci a une étoile dessus."
	turf_type = /turf/open/floor/carpet/lone/star
	merge_type = /obj/item/stack/tile/carpet/star

/obj/item/stack/tile/carpet/black
	name = "tapis noir"
	icon_state = "tile-carpet-black"
	inhand_icon_state = "tile-carpet-black"
	turf_type = /turf/open/floor/carpet/black
	tableVariant = /obj/structure/table/wood/fancy/black
	merge_type = /obj/item/stack/tile/carpet/black

/obj/item/stack/tile/carpet/blue
	name = "tapis bleu"
	icon_state = "tile-carpet-blue"
	inhand_icon_state = "tile-carpet-blue"
	turf_type = /turf/open/floor/carpet/blue
	tableVariant = /obj/structure/table/wood/fancy/blue
	merge_type = /obj/item/stack/tile/carpet/blue

/obj/item/stack/tile/carpet/cyan
	name = "tapis cyan"
	icon_state = "tile-carpet-cyan"
	inhand_icon_state = "tile-carpet-cyan"
	turf_type = /turf/open/floor/carpet/cyan
	tableVariant = /obj/structure/table/wood/fancy/cyan
	merge_type = /obj/item/stack/tile/carpet/cyan

/obj/item/stack/tile/carpet/green
	name = "tapis vert"
	icon_state = "tile-carpet-green"
	inhand_icon_state = "tile-carpet-green"
	turf_type = /turf/open/floor/carpet/green
	tableVariant = /obj/structure/table/wood/fancy/green
	merge_type = /obj/item/stack/tile/carpet/green

/obj/item/stack/tile/carpet/orange
	name = "tapis orange"
	icon_state = "tile-carpet-orange"
	inhand_icon_state = "tile-carpet-orange"
	turf_type = /turf/open/floor/carpet/orange
	tableVariant = /obj/structure/table/wood/fancy/orange
	merge_type = /obj/item/stack/tile/carpet/orange

/obj/item/stack/tile/carpet/purple
	name = "tapis violet"
	icon_state = "tile-carpet-purple"
	inhand_icon_state = "tile-carpet-purple"
	turf_type = /turf/open/floor/carpet/purple
	tableVariant = /obj/structure/table/wood/fancy/purple
	merge_type = /obj/item/stack/tile/carpet/purple

/obj/item/stack/tile/carpet/red
	name = "tapis rouge"
	icon_state = "tile-carpet-red"
	inhand_icon_state = "tile-carpet-red"
	turf_type = /turf/open/floor/carpet/red
	tableVariant = /obj/structure/table/wood/fancy/red
	merge_type = /obj/item/stack/tile/carpet/red

/obj/item/stack/tile/carpet/royalblack
	name = "tapis royal noir"
	icon_state = "tile-carpet-royalblack"
	inhand_icon_state = "tile-carpet-royalblack"
	turf_type = /turf/open/floor/carpet/royalblack
	tableVariant = /obj/structure/table/wood/fancy/royalblack
	merge_type = /obj/item/stack/tile/carpet/royalblack

/obj/item/stack/tile/carpet/royalblue
	name = "tapis royal bleu"
	icon_state = "tile-carpet-royalblue"
	inhand_icon_state = "tile-carpet-royalblue"
	turf_type = /turf/open/floor/carpet/royalblue
	tableVariant = /obj/structure/table/wood/fancy/royalblue
	merge_type = /obj/item/stack/tile/carpet/royalblue

/obj/item/stack/tile/carpet/executive
	name = "tapis d'actionnaire"
	icon_state = "tile_carpet_executive"
	inhand_icon_state = "tile-carpet-royalblue"
	turf_type = /turf/open/floor/carpet/executive
	merge_type = /obj/item/stack/tile/carpet/executive

/obj/item/stack/tile/carpet/stellar
	name = "tapis stellaire"
	icon_state = "tile_carpet_stellar"
	inhand_icon_state = "tile-carpet-royalblue"
	turf_type = /turf/open/floor/carpet/stellar
	merge_type = /obj/item/stack/tile/carpet/stellar

/obj/item/stack/tile/carpet/donk
	name = "\improper tapis promotionnel de marque Donk Co."
	icon_state = "tile_carpet_donk"
	inhand_icon_state = "tile-carpet-orange"
	turf_type = /turf/open/floor/carpet/donk
	merge_type = /obj/item/stack/tile/carpet/donk

/obj/item/stack/tile/carpet/fifty
	amount = 50

/obj/item/stack/tile/carpet/black/fifty
	amount = 50

/obj/item/stack/tile/carpet/blue/fifty
	amount = 50

/obj/item/stack/tile/carpet/cyan/fifty
	amount = 50

/obj/item/stack/tile/carpet/green/fifty
	amount = 50

/obj/item/stack/tile/carpet/orange/fifty
	amount = 50

/obj/item/stack/tile/carpet/purple/fifty
	amount = 50

/obj/item/stack/tile/carpet/red/fifty
	amount = 50

/obj/item/stack/tile/carpet/royalblack/fifty
	amount = 50

/obj/item/stack/tile/carpet/royalblue/fifty
	amount = 50

/obj/item/stack/tile/carpet/executive/thirty
	amount = 30

/obj/item/stack/tile/carpet/stellar/thirty
	amount = 30

/obj/item/stack/tile/carpet/donk/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon
	name = "tapis néon"
	singular_name = "tapis néon"
	desc = "Un morceau de tapis en caoutchouc incrusté d'un motif phosphorescent."
	inhand_icon_state = "tile-neon"
	turf_type = /turf/open/floor/carpet/neon
	merge_type = /obj/item/stack/tile/carpet/neon

	// Neon overlay
	/// The icon used for the neon overlay and emissive overlay.
	var/neon_icon
	/// The icon state used for the neon overlay and emissive overlay.
	var/neon_icon_state
	/// The icon state used for the neon overlay inhands.
	var/neon_inhand_icon_state
	/// The color used for the neon overlay.
	var/neon_color
	/// The alpha used for the emissive overlay.
	var/emissive_alpha = 150

/obj/item/stack/tile/carpet/neon/update_overlays()
	. = ..()
	var/mutable_appearance/neon_overlay = mutable_appearance(neon_icon || icon, neon_icon_state || icon_state, alpha = alpha)
	neon_overlay.color = neon_color
	. += neon_overlay
	. += emissive_appearance(neon_icon || icon, neon_icon_state || icon_state, src, alpha = emissive_alpha)

/obj/item/stack/tile/carpet/neon/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands || !neon_inhand_icon_state)
		return

	var/mutable_appearance/neon_overlay = mutable_appearance(icon_file, neon_inhand_icon_state)
	neon_overlay.color = neon_color
	. += neon_overlay
	. += emissive_appearance(icon_file, neon_inhand_icon_state, src, alpha = emissive_alpha)

/obj/item/stack/tile/carpet/neon/simple
	name = "tapis néon simple"
	singular_name = "tapis néon simple"
	icon_state = "tile_carpet_neon_simple"
	neon_icon_state = "tile_carpet_neon_simple_light"
	neon_inhand_icon_state = "tile-neon-glow"
	turf_type = /turf/open/floor/carpet/neon/simple
	merge_type = /obj/item/stack/tile/carpet/neon/simple
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple,
		/obj/item/stack/tile/carpet/neon/simple/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	neon_inhand_icon_state = "tile-neon-glow-nodots"
	turf_type = /turf/open/floor/carpet/neon/simple
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple,
		/obj/item/stack/tile/carpet/neon/simple/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/white
	name = "tapis néon blanc simple"
	singular_name = "tapis néon blanc simple"
	turf_type = /turf/open/floor/carpet/neon/simple/white
	merge_type = /obj/item/stack/tile/carpet/neon/simple/white
	neon_color = COLOR_WHITE
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/white,
		/obj/item/stack/tile/carpet/neon/simple/white/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/white/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/white/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/white/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/white,
		/obj/item/stack/tile/carpet/neon/simple/white/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/black
	name = "tapis néon noir simple"
	singular_name = "tapis néon noir simple"
	neon_icon_state = "tile_carpet_neon_simple_glow"
	turf_type = /turf/open/floor/carpet/neon/simple/black
	merge_type = /obj/item/stack/tile/carpet/neon/simple/black
	neon_color = COLOR_BLACK
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/black,
		/obj/item/stack/tile/carpet/neon/simple/black/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/black/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_glow_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/black/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/black/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/black,
		/obj/item/stack/tile/carpet/neon/simple/black/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/red
	name = "tapis néon rouge simple"
	singular_name = "tapis néon rouge simple"
	turf_type = /turf/open/floor/carpet/neon/simple/red
	merge_type = /obj/item/stack/tile/carpet/neon/simple/red
	neon_color = COLOR_RED
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/red,
		/obj/item/stack/tile/carpet/neon/simple/red/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/red/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/red/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/red/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/red,
		/obj/item/stack/tile/carpet/neon/simple/red/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/orange
	name = "tapis néon orange simple"
	singular_name = "tapis néon orange simple"
	turf_type = /turf/open/floor/carpet/neon/simple/orange
	merge_type = /obj/item/stack/tile/carpet/neon/simple/orange
	neon_color = COLOR_ORANGE
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/orange,
		/obj/item/stack/tile/carpet/neon/simple/orange/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/orange/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/orange/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/orange/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/orange,
		/obj/item/stack/tile/carpet/neon/simple/orange/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/yellow
	name = "tapis néon jaune simple"
	singular_name = "tapis néon jaune simple"
	turf_type = /turf/open/floor/carpet/neon/simple/yellow
	merge_type = /obj/item/stack/tile/carpet/neon/simple/yellow
	neon_color = COLOR_YELLOW
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/yellow,
		/obj/item/stack/tile/carpet/neon/simple/yellow/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/yellow/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/yellow/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/yellow/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/yellow,
		/obj/item/stack/tile/carpet/neon/simple/yellow/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/lime
	name = "tapis néon jaune-citron simple"
	singular_name = "tapis néon jaune-citron simple"
	turf_type = /turf/open/floor/carpet/neon/simple/lime
	merge_type = /obj/item/stack/tile/carpet/neon/simple/lime
	neon_color = COLOR_LIME
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/lime,
		/obj/item/stack/tile/carpet/neon/simple/lime/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/lime/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/lime/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/lime/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/lime,
		/obj/item/stack/tile/carpet/neon/simple/lime/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/green
	name = "tapis néon vert simple"
	singular_name = "tapis néon vert simple"
	turf_type = /turf/open/floor/carpet/neon/simple/green
	merge_type = /obj/item/stack/tile/carpet/neon/simple/green
	neon_color = COLOR_GREEN
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/green,
		/obj/item/stack/tile/carpet/neon/simple/green/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/green/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/green/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/green/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/green,
		/obj/item/stack/tile/carpet/neon/simple/green/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/teal
	name = "tapis néon sarcelle simple"
	singular_name = "tapis néon sarcelle simple"
	turf_type = /turf/open/floor/carpet/neon/simple/teal
	merge_type = /obj/item/stack/tile/carpet/neon/simple/teal
	neon_color = COLOR_TEAL
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/teal,
		/obj/item/stack/tile/carpet/neon/simple/teal/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/teal/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/teal/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/teal/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/teal,
		/obj/item/stack/tile/carpet/neon/simple/teal/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/cyan
	name = "tapis néon cyan simple"
	singular_name = "tapis néon cyan simple"
	turf_type = /turf/open/floor/carpet/neon/simple/cyan
	merge_type = /obj/item/stack/tile/carpet/neon/simple/cyan
	neon_color = COLOR_CYAN
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/cyan,
		/obj/item/stack/tile/carpet/neon/simple/cyan/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/cyan/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/cyan/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/cyan/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/cyan,
		/obj/item/stack/tile/carpet/neon/simple/cyan/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/blue
	name = "tapis néon bleu simple"
	singular_name = "tapis néon bleu simple"
	turf_type = /turf/open/floor/carpet/neon/simple/blue
	merge_type = /obj/item/stack/tile/carpet/neon/simple/blue
	neon_color = COLOR_BLUE
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/blue,
		/obj/item/stack/tile/carpet/neon/simple/blue/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/blue/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/blue/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/blue/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/blue,
		/obj/item/stack/tile/carpet/neon/simple/blue/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/purple
	name = "tapis néon violet simple"
	singular_name = "tapis néon violet simple"
	turf_type = /turf/open/floor/carpet/neon/simple/purple
	merge_type = /obj/item/stack/tile/carpet/neon/simple/purple
	neon_color = COLOR_PURPLE
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/purple,
		/obj/item/stack/tile/carpet/neon/simple/purple/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/purple/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/purple/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/purple/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/purple,
		/obj/item/stack/tile/carpet/neon/simple/purple/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/violet
	name = "tapis néon violet simple"
	singular_name = "tapis néon violet simple"
	turf_type = /turf/open/floor/carpet/neon/simple/violet
	merge_type = /obj/item/stack/tile/carpet/neon/simple/violet
	neon_color = COLOR_VIOLET
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/violet,
		/obj/item/stack/tile/carpet/neon/simple/violet/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/violet/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/violet/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/violet/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/violet,
		/obj/item/stack/tile/carpet/neon/simple/violet/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/pink
	name = "tapis néon rose simple"
	singular_name = "tapis néon rose simple"
	turf_type = /turf/open/floor/carpet/neon/simple/pink
	merge_type = /obj/item/stack/tile/carpet/neon/simple/pink
	neon_color = COLOR_LIGHT_PINK
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/pink,
		/obj/item/stack/tile/carpet/neon/simple/pink/nodots,
	)

/obj/item/stack/tile/carpet/neon/simple/pink/nodots
	icon_state = "tile_carpet_neon_simple_nodots"
	neon_icon_state = "tile_carpet_neon_simple_light_nodots"
	turf_type = /turf/open/floor/carpet/neon/simple/pink/nodots
	merge_type = /obj/item/stack/tile/carpet/neon/simple/pink/nodots
	tile_reskin_types = list(
		/obj/item/stack/tile/carpet/neon/simple/pink,
		/obj/item/stack/tile/carpet/neon/simple/pink/nodots,
	)

/obj/item/stack/tile/carpet/neon/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/white/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/white/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/white/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/black/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/black/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/black/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/red/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/red/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/red/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/orange/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/orange/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/orange/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/yellow/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/yellow/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/yellow/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/lime/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/lime/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/lime/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/green/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/green/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/green/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/teal/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/teal/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/teal/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/cyan/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/cyan/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/cyan/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/blue/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/blue/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/blue/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/purple/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/purple/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/purple/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/violet/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/violet/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/violet/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/pink/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/pink/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/pink/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/white/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/white/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/white/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/black/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/black/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/black/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/red/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/red/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/red/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/orange/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/orange/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/orange/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/yellow/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/yellow/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/yellow/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/lime/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/lime/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/lime/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/green/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/green/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/green/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/teal/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/teal/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/teal/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/cyan/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/cyan/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/cyan/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/blue/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/blue/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/blue/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/purple/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/purple/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/purple/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/violet/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/violet/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/violet/nodots/sixty
	amount = 60

/obj/item/stack/tile/carpet/neon/simple/pink/nodots/ten
	amount = 10

/obj/item/stack/tile/carpet/neon/simple/pink/nodots/thirty
	amount = 30

/obj/item/stack/tile/carpet/neon/simple/pink/nodots/sixty
	amount = 60

/obj/item/stack/tile/fakespace
	name = "tapis astraux"
	singular_name = "tapis astral"
	desc = "Un morceau de tapis avec un motif d'étoiles convaincant."
	icon_state = "tile_space"
	inhand_icon_state = "tile-space"
	turf_type = /turf/open/floor/fakespace
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/fakespace

/obj/item/stack/tile/fakespace/loaded
	amount = 30

/obj/item/stack/tile/fakepit
	name = "faux trous"
	singular_name = "faux trous"
	desc = "Un morceau de tapis avec une illusion de perspective forcée d'un trou. Impossible de tromper qui que ce soit !"
	icon_state = "tile_pit"
	inhand_icon_state = "tile-basalt"
	turf_type = /turf/open/floor/fakepit
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/fakepit

/obj/item/stack/tile/fakepit/loaded
	amount = 30

/obj/item/stack/tile/fakeice
	name = "fausse glace"
	singular_name = "fausse glace"
	desc = "Un morceau de tapis avec un motif de glace convaincant."
	icon_state = "tile_ice"
	inhand_icon_state = "tile-diamond"
	turf_type = /turf/open/floor/fakeice
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/fakeice

/obj/item/stack/tile/fakeice/loaded
	amount = 30

//High-traction
/obj/item/stack/tile/noslip
	name = "dalles antidérapantes"
	singular_name = "dalle antidérapante"
	desc = "Une dalle antidérapante. Elle est caoutchouteuse au toucher."
	icon_state = "tile_noslip"
	inhand_icon_state = "tile-noslip"
	turf_type = /turf/open/floor/noslip
	merge_type = /obj/item/stack/tile/noslip

/obj/item/stack/tile/noslip/thirty
	amount = 30

//Circuit
/obj/item/stack/tile/circuit
	name = "dalles à circuits bleus"
	singular_name = "dalle à circuit bleu"
	desc = "Une dalle à circuit bleu."
	icon_state = "tile_bcircuit"
	inhand_icon_state = "tile-bcircuit"
	turf_type = /turf/open/floor/circuit
	merge_type = /obj/item/stack/tile/circuit

/obj/item/stack/tile/circuit/green
	name = "dalles à circuits verts"
	singular_name = "dalle à circuit vert"
	desc = "Une dalle à circuit vert."
	icon_state = "tile_gcircuit"
	inhand_icon_state = "tile-gcircuit"
	turf_type = /turf/open/floor/circuit/green
	merge_type = /obj/item/stack/tile/circuit/green

/obj/item/stack/tile/circuit/green/anim
	turf_type = /turf/open/floor/circuit/green/anim
	merge_type = /obj/item/stack/tile/circuit/green/anim

/obj/item/stack/tile/circuit/red
	name = "dalles à circuits rouges"
	singular_name = "dalle à circuit rouge"
	desc = "Une dalle à circuit rouge."
	icon_state = "tile_rcircuit"
	inhand_icon_state = "tile-rcircuit"
	turf_type = /turf/open/floor/circuit/red
	merge_type = /obj/item/stack/tile/circuit/red

/obj/item/stack/tile/circuit/red/anim
	turf_type = /turf/open/floor/circuit/red/anim
	merge_type = /obj/item/stack/tile/circuit/red/anim

//Pod floor
/obj/item/stack/tile/pod
	name = "dalles de nacelle de sauvetage"
	singular_name = "dalle de nacelle de sauvetage"
	desc = "Une dalle rainurée."
	icon_state = "tile_pod"
	inhand_icon_state = "tile-pod"
	turf_type = /turf/open/floor/pod
	merge_type = /obj/item/stack/tile/pod
	tile_reskin_types = list(
		/obj/item/stack/tile/pod,
		/obj/item/stack/tile/pod/light,
		/obj/item/stack/tile/pod/dark,
		)

/obj/item/stack/tile/pod/light
	name = "dalles de nacelle de sauvetage claires"
	singular_name = "dalle de nacelle de sauvetage claire"
	desc = "Une dalle rainurée claire."
	icon_state = "tile_podlight"
	turf_type = /turf/open/floor/pod/light
	merge_type = /obj/item/stack/tile/pod/light

/obj/item/stack/tile/pod/dark
	name = "dalles de nacelle de sauvetage sombres"
	singular_name = "dalle de nacelle de sauvetage sombre"
	desc = "Une dalle rainurée sombre."
	icon_state = "tile_poddark"
	turf_type = /turf/open/floor/pod/dark
	merge_type = /obj/item/stack/tile/pod/dark

/obj/item/stack/tile/plastic
	name = "dalles en plastique"
	singular_name = "dalle en plastique"
	desc = "Une dalle en plastique bon marché et fragile."
	icon_state = "tile_plastic"
	mats_per_unit = list(/datum/material/plastic=500)
	turf_type = /turf/open/floor/plastic
	merge_type = /obj/item/stack/tile/plastic

/obj/item/stack/tile/material
	name = "dalles"
	singular_name = "dalle"
	desc = "Le sol sur lequel vous marchez."
	throwforce = 10
	icon_state = "material_tile"
	turf_type = /turf/open/floor/material
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	merge_type = /obj/item/stack/tile/material

/obj/item/stack/tile/material/place_tile(turf/open/target_plating, mob/user)
	. = ..()
	var/turf/open/floor/material/floor = .
	floor?.set_custom_materials(mats_per_unit)

/obj/item/stack/tile/eighties
	name = "dalles rétro"
	singular_name = "dalle rétro"
	desc = "Un tas de dalles qui vous rappellent une époque funky. Utilisez-les dans votre main pour choisir entre un motif noir ou rouge."
	icon_state = "tile_eighties"
	turf_type = /turf/open/floor/eighties
	merge_type = /obj/item/stack/tile/eighties
	tile_reskin_types = list(
		/obj/item/stack/tile/eighties,
		/obj/item/stack/tile/eighties/red,
	)

/obj/item/stack/tile/eighties/loaded
	amount = 15

/obj/item/stack/tile/eighties/red
	name = "dalles rétro rouges"
	singular_name = "dalle rétro rouge"
	desc = "Un tas de dalles ROUGE-ALORS ! Utilisez-les dans votre main pour choisir entre un motif noir ou rouge." //i am so sorry
	icon_state = "tile_eightiesred"
	turf_type = /turf/open/floor/eighties/red
	merge_type = /obj/item/stack/tile/eighties/red

/obj/item/stack/tile/bronze
	name = "dalles en bronze"
	singular_name = "dalle en bronze"
	desc = "Une dalle en bronze de haute qualité. Les techniques de construction horlogère permettent de minimiser le bruit de claquement."
	icon_state = "tile_brass"
	turf_type = /turf/open/floor/bronze
	mats_per_unit = list(/datum/material/bronze=500)
	merge_type = /obj/item/stack/tile/bronze
	tile_reskin_types = list(
		/obj/item/stack/tile/bronze,
		/obj/item/stack/tile/bronze/flat,
		/obj/item/stack/tile/bronze/filled,
		)

/obj/item/stack/tile/bronze/flat
	name = "dalles en bronze plates"
	singular_name = "dalle en bronze plate"
	icon_state = "tile_reebe"
	turf_type = /turf/open/floor/bronze/flat
	merge_type = /obj/item/stack/tile/bronze/flat

/obj/item/stack/tile/bronze/filled
	name = "dalles en bronze remplies"
	singular_name = "dalle en bronze remplie"
	icon_state = "tile_brass_filled"
	turf_type = /turf/open/floor/bronze/filled
	merge_type = /obj/item/stack/tile/bronze/filled

/obj/item/stack/tile/cult
	name = "dalles gravées"
	singular_name = "dalle gravée"
	desc = "Une dalle étrange faite de métal runique. Elle ne semble pas avoir de pouvoirs paranormaux."
	icon_state = "tile_cult"
	turf_type = /turf/open/floor/cult
	mats_per_unit = list(/datum/material/runedmetal=500)
	merge_type = /obj/item/stack/tile/cult

/// Floor tiles used to test emissive turfs.
/obj/item/stack/tile/emissive_test
	name = "emissive test tile"
	singular_name = "emissive test floor tile"
	desc = "A glow-in-the-dark floor tile used to test emissive turfs."
	turf_type = /turf/open/floor/emissive_test
	merge_type = /obj/item/stack/tile/emissive_test

/obj/item/stack/tile/emissive_test/update_overlays()
	. = ..()
	. += emissive_appearance(icon, icon_state, src, alpha = alpha)

/obj/item/stack/tile/emissive_test/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	. += emissive_appearance(standing.icon, standing.icon_state, src, alpha = standing.alpha)

/obj/item/stack/tile/emissive_test/sixty
	amount = 60

/obj/item/stack/tile/emissive_test/white
	name = "white emissive test tile"
	singular_name = "white emissive test floor tile"
	turf_type = /turf/open/floor/emissive_test/white
	merge_type = /obj/item/stack/tile/emissive_test/white

/obj/item/stack/tile/emissive_test/white/sixty
	amount = 60

//Catwalk Tiles
/obj/item/stack/tile/catwalk_tile //This is our base type, sprited to look maintenance-styled
	name = "échaufaudages"
	singular_name = "échaufaudage"
	desc = "Une dalle qui montre son contenu en dessous. Les ingénieurs l'adorent !"
	icon_state = "maint_catwalk"
	inhand_icon_state = "tile-catwalk"
	mats_per_unit = list(/datum/material/iron=100)
	turf_type = /turf/open/floor/catwalk_floor
	merge_type = /obj/item/stack/tile/catwalk_tile //Just to be cleaner, these all stack with eachother
	tile_reskin_types = list(
		/obj/item/stack/tile/catwalk_tile,
		/obj/item/stack/tile/catwalk_tile/iron,
		/obj/item/stack/tile/catwalk_tile/iron_white,
		/obj/item/stack/tile/catwalk_tile/iron_dark,
		/obj/item/stack/tile/catwalk_tile/flat_white,
		/obj/item/stack/tile/catwalk_tile/titanium,
		/obj/item/stack/tile/catwalk_tile/iron_smooth //this is the original greenish one
	)

/obj/item/stack/tile/catwalk_tile/sixty
	amount = 60

/obj/item/stack/tile/catwalk_tile/iron
	name = "échaufaudages en fer"
	singular_name = "échaufaudage en fer"
	icon_state = "iron_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/iron

/obj/item/stack/tile/catwalk_tile/iron_white
	name = "échaufaudages blancs"
	singular_name = "échaufaudage blanc"
	icon_state = "whiteiron_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/iron_white

/obj/item/stack/tile/catwalk_tile/iron_dark
	name = "échaufaudages sombres"
	singular_name = "échaufaudage sombre"
	icon_state = "darkiron_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/iron_dark

/obj/item/stack/tile/catwalk_tile/flat_white
	name = "échaufaudages blanc plat"
	singular_name = "échaufaudage blanc plat"
	icon_state = "flatwhite_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/flat_white

/obj/item/stack/tile/catwalk_tile/titanium
	name = "échaufaudages en titane"
	singular_name = "échaufaudage en titane"
	icon_state = "titanium_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/titanium

/obj/item/stack/tile/catwalk_tile/iron_smooth //this is the greenish one
	name = "échaufaudages en fer lisse"
	singular_name = "échaufaudage en fer lisse"
	icon_state = "smoothiron_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/iron_smooth

// Glass floors
/obj/item/stack/tile/glass
	name = "dalles en verre"
	singular_name = "dalle en verre"
	desc = "Un sol en verre, pour voir... Ce qui se trouve en dessous."
	icon_state = "tile_glass"
	turf_type = /turf/open/floor/glass
	inhand_icon_state = "tile-glass"
	merge_type = /obj/item/stack/tile/glass
	mats_per_unit = list(/datum/material/glass=MINERAL_MATERIAL_AMOUNT * 0.25) // 4 tiles per sheet
	replace_plating = TRUE

/obj/item/stack/tile/glass/sixty
	amount = 60

/obj/item/stack/tile/rglass
	name = "dalles en verre renforcé"
	singular_name = "dalle en verre renforcé"
	desc = "Une dalle en verre renforcé. Ces mauvais garçons sont 50% plus solides que leurs prédécesseurs !"
	icon_state = "tile_rglass"
	inhand_icon_state = "tile-rglass"
	turf_type = /turf/open/floor/glass/reinforced
	merge_type = /obj/item/stack/tile/rglass
	mats_per_unit = list(/datum/material/iron=MINERAL_MATERIAL_AMOUNT * 0.125, /datum/material/glass=MINERAL_MATERIAL_AMOUNT * 0.25) // 4 tiles per sheet
	replace_plating = TRUE

/obj/item/stack/tile/rglass/sixty
	amount = 60

/obj/item/stack/tile/glass/plasma
	name = "dalles en verre plasma"
	singular_name = "dalle en verre plasma"
	desc = "Une dalle en verre plasma pour quand ce qui se trouve en dessous est trop dangereux pour du verre normal."
	icon_state = "tile_pglass"
	turf_type = /turf/open/floor/glass/plasma
	merge_type = /obj/item/stack/tile/glass/plasma
	mats_per_unit = list(/datum/material/alloy/plasmaglass = MINERAL_MATERIAL_AMOUNT * 0.25)

/obj/item/stack/tile/rglass/plasma
	name = "dalles en verre plasma renforcés"
	singular_name = "dalls en verre plasma renforcé"
	desc = "Une dalle en verre plasma renforcé, parce que quoi qu'il se trouve en bas... devrait vraiment y rester."
	icon_state = "tile_rpglass"
	turf_type = /turf/open/floor/glass/reinforced/plasma
	merge_type = /obj/item/stack/tile/rglass/plasma
	mats_per_unit = list(/datum/material/iron = MINERAL_MATERIAL_AMOUNT * 0.125, /datum/material/alloy/plasmaglass = MINERAL_MATERIAL_AMOUNT * 0.25)
