/obj/item/stack/tile/iron
	name = "dalles"
	singular_name = "dalle"
	desc = "Le sol que vous foulez."
	icon_state = "tile"
	inhand_icon_state = "tile"
	force = 6
	mats_per_unit = list(/datum/material/iron=500)
	throwforce = 10
	flags_1 = CONDUCT_1
	turf_type = /turf/open/floor/iron
	armor_type = /datum/armor/tile_iron
	resistance_flags = FIRE_PROOF
	matter_amount = 1
	cost = 125
	source = /datum/robot_energy_storage/iron
	merge_type = /obj/item/stack/tile/iron
	tile_reskin_types = list(
		/obj/item/stack/tile/iron,
		/obj/item/stack/tile/iron/edge,
		/obj/item/stack/tile/iron/half,
		/obj/item/stack/tile/iron/corner,
		/obj/item/stack/tile/iron/large,
		/obj/item/stack/tile/iron/small,
		/obj/item/stack/tile/iron/diagonal,
		/obj/item/stack/tile/iron/herringbone,
		/obj/item/stack/tile/iron/textured,
		/obj/item/stack/tile/iron/textured_edge,
		/obj/item/stack/tile/iron/textured_half,
		/obj/item/stack/tile/iron/textured_corner,
		/obj/item/stack/tile/iron/textured_large,
		/obj/item/stack/tile/iron/dark,
		/obj/item/stack/tile/iron/dark/smooth_edge,
		/obj/item/stack/tile/iron/dark/smooth_half,
		/obj/item/stack/tile/iron/dark/smooth_corner,
		/obj/item/stack/tile/iron/dark/smooth_large,
		/obj/item/stack/tile/iron/dark/small,
		/obj/item/stack/tile/iron/dark/diagonal,
		/obj/item/stack/tile/iron/dark/herringbone,
		/obj/item/stack/tile/iron/dark_side,
		/obj/item/stack/tile/iron/dark_corner,
		/obj/item/stack/tile/iron/checker,
		/obj/item/stack/tile/iron/dark/textured,
		/obj/item/stack/tile/iron/dark/textured_edge,
		/obj/item/stack/tile/iron/dark/textured_half,
		/obj/item/stack/tile/iron/dark/textured_corner,
		/obj/item/stack/tile/iron/dark/textured_large,
		/obj/item/stack/tile/iron/white,
		/obj/item/stack/tile/iron/white/smooth_edge,
		/obj/item/stack/tile/iron/white/smooth_half,
		/obj/item/stack/tile/iron/white/smooth_corner,
		/obj/item/stack/tile/iron/white/smooth_large,
		/obj/item/stack/tile/iron/white/small,
		/obj/item/stack/tile/iron/white/diagonal,
		/obj/item/stack/tile/iron/white/herringbone,
		/obj/item/stack/tile/iron/white_side,
		/obj/item/stack/tile/iron/white_corner,
		/obj/item/stack/tile/iron/cafeteria,
		/obj/item/stack/tile/iron/white/textured,
		/obj/item/stack/tile/iron/white/textured_edge,
		/obj/item/stack/tile/iron/white/textured_half,
		/obj/item/stack/tile/iron/white/textured_corner,
		/obj/item/stack/tile/iron/white/textured_large,
		/obj/item/stack/tile/iron/recharge_floor,
		/obj/item/stack/tile/iron/smooth,
		/obj/item/stack/tile/iron/smooth_edge,
		/obj/item/stack/tile/iron/smooth_half,
		/obj/item/stack/tile/iron/smooth_corner,
		/obj/item/stack/tile/iron/smooth_large,
		/obj/item/stack/tile/iron/terracotta,
		/obj/item/stack/tile/iron/terracotta/small,
		/obj/item/stack/tile/iron/terracotta/diagonal,
		/obj/item/stack/tile/iron/terracotta/herringbone,
		/obj/item/stack/tile/iron/kitchen,
		/obj/item/stack/tile/iron/kitchen/small,
		/obj/item/stack/tile/iron/kitchen/diagonal,
		/obj/item/stack/tile/iron/kitchen/herringbone,
		/obj/item/stack/tile/iron/chapel,
		/obj/item/stack/tile/iron/showroomfloor,
		/obj/item/stack/tile/iron/solarpanel,
		/obj/item/stack/tile/iron/freezer,
		/obj/item/stack/tile/iron/grimy,
		/obj/item/stack/tile/iron/sepia,
	)

/obj/item/stack/tile/iron/two
	amount = 2

/obj/item/stack/tile/iron/four
	amount = 4

/datum/armor/tile_iron
	fire = 100
	acid = 70

/obj/item/stack/tile/iron/Initialize(mapload)
	. = ..()
	var/static/list/tool_behaviors = list(
		TOOL_WELDER = list(
			SCREENTIP_CONTEXT_LMB = "Créer des plaques de fer",
			SCREENTIP_CONTEXT_RMB = "Créer des barres de fer",
		),
	)
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)

/obj/item/stack/tile/iron/welder_act(mob/living/user, obj/item/tool)
	if(get_amount() < 4)
		balloon_alert(user, "Pas assez de dalles !")
		return
	if(tool.use_tool(src, user, delay = 0, volume = 40))
		var/obj/item/stack/sheet/iron/new_item = new(user.loc)
		user.visible_message(
			span_notice("[user.name] a façonné [src] en plaques avec [tool]."),
			blind_message = span_hear("Vous entendez des bruits de soudure."),
			vision_distance = COMBAT_MESSAGE_RANGE,
			ignored_mobs = user
		)
		use(4)
		user.put_in_inactive_hand(new_item)
		return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/item/stack/tile/iron/welder_act_secondary(mob/living/user, obj/item/tool)
	if(get_amount() < 2)
		balloon_alert(user, "Pas assez de dalles !")
		return
	if(tool.use_tool(src, user, delay = 0, volume = 40))
		var/obj/item/stack/rods/new_item = new(user.loc)
		user.visible_message(
			span_notice("[user.name] a façonné [src] en tiges avec [tool]."),
			blind_message = span_hear("You hear welding."),
			vision_distance = COMBAT_MESSAGE_RANGE,
			ignored_mobs = user
		)
		use(2)
		user.put_in_inactive_hand(new_item)
		return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/item/stack/tile/iron/base //this subtype should be used for most stuff
	merge_type = /obj/item/stack/tile/iron/base

/obj/item/stack/tile/iron/base/cyborg //cant reskin these, fucks with borg code
	merge_type = /obj/item/stack/tile/iron/base/cyborg
	tile_reskin_types = null

/obj/item/stack/tile/iron/edge
	name = "dalles de bordure"
	singular_name = "dalle de bordure"
	icon_state = "tile_edge"
	turf_type = /turf/open/floor/iron/edge
	merge_type = /obj/item/stack/tile/iron/edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/half
	name = "demi dalles"
	singular_name = "demi dalle"
	icon_state = "tile_half"
	turf_type = /turf/open/floor/iron/half
	merge_type = /obj/item/stack/tile/iron/half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/iron/corner
	name = "dalles de coin"
	singular_name = "dalle de coin"
	icon_state = "tile_corner"
	turf_type = /turf/open/floor/iron/corner
	merge_type = /obj/item/stack/tile/iron/corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/large
	name = "grande dalles"
	singular_name = "grande dalle"
	icon_state = "tile_large"
	turf_type = /turf/open/floor/iron/large
	merge_type = /obj/item/stack/tile/iron/large

/obj/item/stack/tile/iron/textured
	name = "dalles texturées"
	singular_name = "dalle texturée"
	icon_state = "tile_textured"
	turf_type = /turf/open/floor/iron/textured
	merge_type = /obj/item/stack/tile/iron/textured

/obj/item/stack/tile/iron/textured_edge
	name = "dalles de bordure texturées"
	singular_name = "dalle de bordure texturées"
	icon_state = "tile_textured_edge"
	turf_type = /turf/open/floor/iron/textured_edge
	merge_type = /obj/item/stack/tile/iron/textured_edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/textured_half
	name = "demi dalles texturées"
	singular_name = "demi dalle texturée"
	icon_state = "tile_textured_half"
	turf_type = /turf/open/floor/iron/textured_half
	merge_type = /obj/item/stack/tile/iron/textured_half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/iron/textured_corner
	name = "dalles de coin texturées"
	singular_name = "dalle de coin texturée"
	icon_state = "tile_textured_corner"
	turf_type = /turf/open/floor/iron/textured_corner
	merge_type = /obj/item/stack/tile/iron/textured_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/textured_large
	name = "grande dalles texturées"
	singular_name = "grande dalle texturée"
	icon_state = "tile_textured_large"
	turf_type = /turf/open/floor/iron/textured_large
	merge_type = /obj/item/stack/tile/iron/textured_large

/obj/item/stack/tile/iron/small
	name = "petite dalles"
	singular_name = "petite dalle"
	icon_state = "tile_small"
	turf_type = /turf/open/floor/iron/small
	merge_type = /obj/item/stack/tile/iron/small

/obj/item/stack/tile/iron/diagonal
	name = "dalles diagonales"
	singular_name = "dalle diagonale"
	icon_state = "tile_diagonal"
	turf_type = /turf/open/floor/iron/diagonal
	merge_type = /obj/item/stack/tile/iron/diagonal

/obj/item/stack/tile/iron/herringbone
	name = "dalles en chevron"
	singular_name = "dalle en chevron"
	icon_state = "tile_herringbone"
	turf_type = /turf/open/floor/iron/herringbone
	merge_type = /obj/item/stack/tile/iron/herringbone

/obj/item/stack/tile/iron/dark
	name = "dalles sombres"
	singular_name = "dalle sombre"
	icon_state = "tile_dark"
	turf_type = /turf/open/floor/iron/dark
	merge_type = /obj/item/stack/tile/iron/dark

/obj/item/stack/tile/iron/dark/smooth_edge
	name = "dalles de bordure sombres"
	singular_name = "dalle de bordure sombre"
	icon_state = "tile_dark_edge"
	turf_type = /turf/open/floor/iron/dark/smooth_edge
	merge_type = /obj/item/stack/tile/iron/dark/smooth_edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/dark/smooth_half
	name = "demi dalles sombres"
	singular_name = "demi dalle sombre"
	icon_state = "tile_dark_half"
	turf_type = /turf/open/floor/iron/dark/smooth_half
	merge_type = /obj/item/stack/tile/iron/dark/smooth_half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/iron/dark/smooth_corner
	name = "dalles de coin sombres"
	singular_name = "dalles de coin sombre"
	icon_state = "tile_dark_corner"
	turf_type = /turf/open/floor/iron/dark/smooth_corner
	merge_type = /obj/item/stack/tile/iron/dark/smooth_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/dark/smooth_large
	name = "grande dalles sombres"
	singular_name = "grande dalle sombre"
	icon_state = "tile_dark_large"
	turf_type = /turf/open/floor/iron/dark/smooth_large
	merge_type = /obj/item/stack/tile/iron/dark/smooth_large

/obj/item/stack/tile/iron/dark_side
	name = "demi dalles sombres"
	singular_name = "demi dalle sombre"
	icon_state = "tile_darkside"
	turf_type = /turf/open/floor/iron/dark/side
	merge_type = /obj/item/stack/tile/iron/dark_side
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)

/obj/item/stack/tile/iron/dark_corner
	name = "quart de dalles sombres"
	singular_name = "quart de dalle sombre"
	icon_state = "tile_darkcorner"
	turf_type = /turf/open/floor/iron/dark/corner
	merge_type = /obj/item/stack/tile/iron/dark_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/checker
	name = "dalles à damier"
	singular_name = "dalle à damier"
	icon_state = "tile_checker"
	turf_type = /turf/open/floor/iron/checker
	merge_type = /obj/item/stack/tile/iron/checker
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/iron/dark/textured
	name = "dalles texturées sombres"
	singular_name = "dalle texturée sombre"
	icon_state = "tile_textured_dark"
	turf_type = /turf/open/floor/iron/dark/textured
	merge_type = /obj/item/stack/tile/iron/dark/textured

/obj/item/stack/tile/iron/dark/textured_edge
	name = "dalles de bordure texturées sombres"
	singular_name = "dalle de bordure texturée sombre"
	icon_state = "tile_textured_dark_edge"
	turf_type = /turf/open/floor/iron/dark/textured_edge
	merge_type = /obj/item/stack/tile/iron/dark/textured_edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/dark/textured_half
	name = "demi dalles texturées sombres"
	singular_name = "demi dalle texturée sombre"
	icon_state = "tile_textured_dark_half"
	turf_type = /turf/open/floor/iron/dark/textured_half
	merge_type = /obj/item/stack/tile/iron/dark/textured_half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/iron/dark/textured_corner
	name = "dalles de coin texturées sombres"
	singular_name = "dalle de coin texturée sombre"
	icon_state = "tile_textured_dark_corner"
	turf_type = /turf/open/floor/iron/dark/textured_corner
	merge_type = /obj/item/stack/tile/iron/dark/textured_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/dark/textured_large
	name = "grande dalles texturées sombres"
	singular_name = "grande dalle texturée sombre"
	icon_state = "tile_textured_dark_large"
	turf_type = /turf/open/floor/iron/dark/textured_large
	merge_type = /obj/item/stack/tile/iron/dark/textured_large

/obj/item/stack/tile/iron/dark/small
	name = "petite dalles sombres"
	singular_name = "petite dalle sombre"
	icon_state = "tile_dark_small"
	turf_type = /turf/open/floor/iron/dark/small
	merge_type = /obj/item/stack/tile/iron/dark/small

/obj/item/stack/tile/iron/dark/diagonal
	name = "dalles diagonales sombres"
	singular_name = "dalle diagonale sombre"
	icon_state = "tile_dark_diagonal"
	turf_type = /turf/open/floor/iron/dark/diagonal
	merge_type = /obj/item/stack/tile/iron/dark/diagonal

/obj/item/stack/tile/iron/dark/herringbone
	name = "dalles en chevron sombres"
	singular_name = "dalles en chevron sombres"
	icon_state = "tile_dark_herringbone"
	turf_type = /turf/open/floor/iron/dark/herringbone
	merge_type = /obj/item/stack/tile/iron/dark/herringbone

/obj/item/stack/tile/iron/white
	name = "dalles blanche"
	singular_name = "dalle blanche"
	icon_state = "tile_white"
	turf_type = /turf/open/floor/iron/white
	merge_type = /obj/item/stack/tile/iron/white

/obj/item/stack/tile/iron/white/smooth_edge
	name = "dalles de bordure blanche"
	singular_name = "dalle de bordure blanche"
	icon_state = "tile_white_edge"
	turf_type = /turf/open/floor/iron/white/smooth_edge
	merge_type = /obj/item/stack/tile/iron/white/smooth_edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/white/smooth_half
	name = "demi dalles blanches"
	singular_name = "demi dalle blanche"
	icon_state = "tile_white_half"
	turf_type = /turf/open/floor/iron/white/smooth_half
	merge_type = /obj/item/stack/tile/iron/white/smooth_half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/iron/white/smooth_corner
	name = "dalles de coin blanches"
	singular_name = "dalle de coin blanche"
	icon_state = "tile_white_corner"
	turf_type = /turf/open/floor/iron/white/smooth_corner
	merge_type = /obj/item/stack/tile/iron/white/smooth_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/white/smooth_large
	name = "grande dalles blanches"
	singular_name = "grande dalle blanche"
	icon_state = "tile_white_large"
	turf_type = /turf/open/floor/iron/white/smooth_large
	merge_type = /obj/item/stack/tile/iron/white/smooth_large

/obj/item/stack/tile/iron/white_side
	name = "demi dalles blanches"
	singular_name = "demi dalle blanche"
	icon_state = "tile_whiteside"
	turf_type = /turf/open/floor/iron/white/side
	merge_type = /obj/item/stack/tile/iron/white_side
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)

/obj/item/stack/tile/iron/white_corner
	name = "quart de dalles blanches"
	singular_name = "quart de dalle blanche"
	icon_state = "tile_whitecorner"
	turf_type = /turf/open/floor/iron/white/corner
	merge_type = /obj/item/stack/tile/iron/white_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/cafeteria
	name = "dalles de cafétéria"
	singular_name = "dalle de cafétéria"
	icon_state = "tile_cafeteria"
	turf_type = /turf/open/floor/iron/cafeteria
	merge_type = /obj/item/stack/tile/iron/cafeteria
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/iron/white/textured
	name = "dalles texturées blanches"
	singular_name = "dalle texturée blanche"
	icon_state = "tile_textured_white"
	turf_type = /turf/open/floor/iron/white/textured
	merge_type = /obj/item/stack/tile/iron/white/textured

/obj/item/stack/tile/iron/white/textured_edge
	name = "dalles de bordure texturées blanches"
	singular_name = "dalle de bordure texturée blanche"
	icon_state = "tile_textured_white_edge"
	turf_type = /turf/open/floor/iron/white/textured_edge
	merge_type = /obj/item/stack/tile/iron/white/textured_edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/white/textured_half
	name = "demi dalles texturées blanches"
	singular_name = "demi dalle texturée blanche"
	icon_state = "tile_textured_white_half"
	turf_type = /turf/open/floor/iron/white/textured_half
	merge_type = /obj/item/stack/tile/iron/white/textured_half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/iron/white/textured_corner
	name = "dalles de coin texturées blanches"
	singular_name = "dalle de coin texturée blanche"
	icon_state = "tile_textured_white_corner"
	turf_type = /turf/open/floor/iron/white/textured_corner
	merge_type = /obj/item/stack/tile/iron/white/textured_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/white/textured_large
	name = "grande dalles texturées blanches"
	singular_name = "grande dalle texturée blanche"
	icon_state = "tile_textured_white_large"
	turf_type = /turf/open/floor/iron/white/textured_large
	merge_type = /obj/item/stack/tile/iron/white/textured_large

/obj/item/stack/tile/iron/white/small
	name = "petite dalles blanches"
	singular_name = "petite dalle blanche"
	icon_state = "tile_white_small"
	turf_type = /turf/open/floor/iron/white/small
	merge_type = /obj/item/stack/tile/iron/white/small

/obj/item/stack/tile/iron/white/diagonal
	name = "dalles diagonales blanches"
	singular_name = "dalle diagonale blanche"
	icon_state = "tile_white_diagonal"
	turf_type = /turf/open/floor/iron/white/diagonal
	merge_type = /obj/item/stack/tile/iron/white/diagonal

/obj/item/stack/tile/iron/white/herringbone
	name = "dalles en chevron blanches"
	singular_name = "dalle en chevron blanche"
	icon_state = "tile_white_herringbone"
	turf_type = /turf/open/floor/iron/white/herringbone
	merge_type = /obj/item/stack/tile/iron/white/herringbone

/obj/item/stack/tile/iron/recharge_floor
	name = "dalles de recharge"
	singular_name = "dalle de recharge"
	icon_state = "tile_recharge"
	turf_type = /turf/open/floor/iron/recharge_floor
	merge_type = /obj/item/stack/tile/iron/recharge_floor

/obj/item/stack/tile/iron/smooth
	name = "dalles lisses"
	singular_name = "dalle lisse"
	icon_state = "tile_smooth"
	turf_type = /turf/open/floor/iron/smooth
	merge_type = /obj/item/stack/tile/iron/smooth

/obj/item/stack/tile/iron/smooth_edge
	name = "dalles de bordure lisses"
	singular_name = "dalle de bordure lisse"
	icon_state = "tile_smooth_edge"
	turf_type = /turf/open/floor/iron/smooth_edge
	merge_type = /obj/item/stack/tile/iron/smooth_edge
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/smooth_half
	name = "demi dalles lisses"
	singular_name = "demi dalle lisse"
	icon_state = "tile_smooth_half"
	turf_type = /turf/open/floor/iron/smooth_half
	merge_type = /obj/item/stack/tile/iron/smooth_half
	tile_rotate_dirs = list(SOUTH, NORTH)

/obj/item/stack/tile/iron/smooth_corner
	name = "dalles de coin lisses"
	singular_name = "dalle de coin lisse"
	icon_state = "tile_smooth_corner"
	turf_type = /turf/open/floor/iron/smooth_corner
	merge_type = /obj/item/stack/tile/iron/smooth_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/iron/smooth_large
	name = "grande dalles lisses"
	singular_name = "grande dalle lisse"
	icon_state = "tile_smooth_large"
	turf_type = /turf/open/floor/iron/smooth_large
	merge_type = /obj/item/stack/tile/iron/smooth_large

/obj/item/stack/tile/iron/terracotta
	name = "dalles en terre cuite"
	singular_name = "dalle en terre cuite"
	icon_state = "tile_terracotta"
	turf_type = /turf/open/floor/iron/terracotta
	merge_type = /obj/item/stack/tile/iron/terracotta

/obj/item/stack/tile/iron/terracotta/small
	name = "petite dalles en terre cuite"
	singular_name = "petite dalle en terre cuite"
	icon_state = "tile_terracotta_small"
	turf_type = /turf/open/floor/iron/terracotta/small
	merge_type = /obj/item/stack/tile/iron/terracotta/small

/obj/item/stack/tile/iron/terracotta/diagonal
	name = "dalles diagonales en terre cuite"
	singular_name = "dalle diagonale en terre cuite"
	icon_state = "tile_terracotta_diagonal"
	turf_type = /turf/open/floor/iron/terracotta/diagonal
	merge_type = /obj/item/stack/tile/iron/terracotta/diagonal

/obj/item/stack/tile/iron/terracotta/herringbone
	name = "dalles en chevron en terre cuite"
	singular_name = "dalle en chevron en terre cuite"
	icon_state = "tile_terracotta_herringbone"
	turf_type = /turf/open/floor/iron/terracotta/herringbone
	merge_type = /obj/item/stack/tile/iron/terracotta/herringbone

/obj/item/stack/tile/iron/kitchen
	name = "dalles de cuisine"
	singular_name = "dalle de cuisine"
	icon_state = "tile_kitchen"
	turf_type = /turf/open/floor/iron/kitchen
	merge_type = /obj/item/stack/tile/iron/kitchen

/obj/item/stack/tile/iron/kitchen/small
	name = "petite dalles de cuisine"
	singular_name = "petite dalle de cuisine"
	icon_state = "tile_kitchen_small"
	turf_type = /turf/open/floor/iron/kitchen/small
	merge_type = /obj/item/stack/tile/iron/kitchen/small

/obj/item/stack/tile/iron/kitchen/diagonal
	name = "dalles de cuisine diagonales"
	singular_name = "dalle de cuisine diagonale"
	icon_state = "tile_kitchen_diagonal"
	turf_type = /turf/open/floor/iron/kitchen/diagonal
	merge_type = /obj/item/stack/tile/iron/kitchen/diagonal

/obj/item/stack/tile/iron/kitchen/herringbone
	name = "dalles de cuisine en chevron"
	singular_name = "dalle de cuisine en chevron"
	icon_state = "tile_kitchen_herringbone"
	turf_type = /turf/open/floor/iron/kitchen/herringbone
	merge_type = /obj/item/stack/tile/iron/kitchen/herringbone

/obj/item/stack/tile/iron/chapel
	name = "dalles de chapelle"
	singular_name = "dalle de chapelle"
	icon_state = "tile_chapel"
	turf_type = /turf/open/floor/iron/chapel
	merge_type = /obj/item/stack/tile/iron/chapel
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)

/obj/item/stack/tile/iron/showroomfloor
	name = "dalles de salle d'exposition"
	singular_name = "dalle de salle d'exposition"
	icon_state = "tile_showroom"
	turf_type = /turf/open/floor/iron/showroomfloor
	merge_type = /obj/item/stack/tile/iron/showroomfloor

/obj/item/stack/tile/iron/solarpanel
	name = "dalles panneau solaire"
	singular_name = "dalle panneau solaire"
	icon_state = "tile_solarpanel"
	turf_type = /turf/open/floor/iron/solarpanel
	merge_type = /obj/item/stack/tile/iron/solarpanel

/obj/item/stack/tile/iron/freezer
	name = "dalles de congélateur"
	singular_name = "dalle de congélateur"
	icon_state = "tile_freezer"
	turf_type = /turf/open/floor/iron/freezer
	merge_type = /obj/item/stack/tile/iron/freezer

/obj/item/stack/tile/iron/grimy
	name = "dalles sales"
	singular_name = "dalle sale"
	icon_state = "tile_grimy"
	turf_type = /turf/open/floor/iron/grimy
	merge_type = /obj/item/stack/tile/iron/grimy

/obj/item/stack/tile/iron/sepia
	name = "dalles sépia"
	singular_name = "dalle sépia"
	desc = "Est bien, le flux du temps est normal sur ces dalles, étrange."
	icon_state = "tile_sepia"
	turf_type = /turf/open/floor/iron/sepia
	merge_type = /obj/item/stack/tile/iron/sepia

//Tiles below can't be gotten through tile reskinning

/obj/item/stack/tile/iron/bluespace
	name = "dalles en bluespace"
	singular_name = "dalle en bluespace"
	desc = "Malheureusement, elles ne semblent pas vous rendre plus rapide..."
	icon_state = "tile_bluespace"
	turf_type = /turf/open/floor/iron/bluespace
	merge_type = /obj/item/stack/tile/iron/bluespace
	tile_reskin_types = null

/obj/item/stack/tile/iron/goonplaque
	name = "dalles de commémoration"
	singular_name = "dalle de commémoration"
	desc = "\"Ceci est une plaque en l'honneur de nos camarades sur les stations G4407. Espérons que le modèle TG4407 puisse être à la hauteur de votre renommée et de votre fortune.\" En dessous, on peut voir une image grossière d'une météorite et d'un astronaute. L'astronaute rit. La météorite explose."
	icon_state = "tile_plaque"
	turf_type = /turf/open/floor/iron/goonplaque
	merge_type = /obj/item/stack/tile/iron/goonplaque
	tile_reskin_types = null

/obj/item/stack/tile/iron/vaporwave
	name = "dalles vaporwave"
	singular_name = "dalle vaporwave"
	icon_state = "tile_vaporwave"
	turf_type = /turf/open/floor/iron/vaporwave
	merge_type = /obj/item/stack/tile/iron/vaporwave
	tile_reskin_types = null
