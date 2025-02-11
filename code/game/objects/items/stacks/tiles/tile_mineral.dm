/obj/item/stack/tile/mineral
	/// Determines what stack is gotten out of us when welded.
	var/mineralType = null

/obj/item/stack/tile/mineral/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WELDER)
		if(get_amount() < 4)
			to_chat(user, span_warning("Vous avez besoin d'au moins quatre dalles pour faire ça !"))
			return
		if(!mineralType)
			to_chat(user, span_warning("Vous ne pouvez pas reformer ça !"))
			stack_trace("Un minerai de type [type] n'a pas son mineralType défini.")
			return
		if(W.use_tool(src, user, 0, volume=40))
			var/sheet_type = text2path("/obj/item/stack/sheet/mineral/[mineralType]")
			var/obj/item/stack/sheet/mineral/new_item = new sheet_type(user.loc)
			user.visible_message(span_notice("[user] forme [src] en [new_item] avec [W]."), \
				span_notice("Vous avez formé [src] en [new_item] avec [W]."), \
				span_hear("Vous entendez des bruits de soudage."))
			var/holding = user.is_holding(src)
			use(4)
			if(holding && QDELETED(src))
				user.put_in_hands(new_item)
	else
		return ..()

/obj/item/stack/tile/mineral/plasma
	name = "dalles de plasma"
	singular_name = "dalle de plasma"
	desc = "Une dalle faite de plasma hautement inflammable. Cela ne peut que bien se terminer."
	icon_state = "tile_plasma"
	inhand_icon_state = "tile-plasma"
	turf_type = /turf/open/floor/mineral/plasma
	mineralType = "plasma"
	mats_per_unit = list(/datum/material/plasma=MINERAL_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/plasma

/obj/item/stack/tile/mineral/uranium
	name = "dalles en uranium"
	singular_name = "dalle en uranium"
	desc = "Une dalle faite d'uranium. Vous vous sentez un peu étourdi."
	icon_state = "tile_uranium"
	inhand_icon_state = "tile-uranium"
	turf_type = /turf/open/floor/mineral/uranium
	mineralType = "uranium"
	mats_per_unit = list(/datum/material/uranium=MINERAL_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/uranium

/obj/item/stack/tile/mineral/gold
	name = "dalles en or"
	singular_name = "dalle en or"
	desc = "Une dalle faite d'or, le swag semble fort ici."
	icon_state = "tile_gold"
	inhand_icon_state = "tile-gold"
	turf_type = /turf/open/floor/mineral/gold
	mineralType = "gold"
	mats_per_unit = list(/datum/material/gold=MINERAL_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/gold

/obj/item/stack/tile/mineral/silver
	name = "dalles en argent"
	singular_name = "dalle en argent"
	desc = "Une dalle faite d'argent, la lumière qui en émane est aveuglante."
	icon_state = "tile_silver"
	inhand_icon_state = "tile-silver"
	turf_type = /turf/open/floor/mineral/silver
	mineralType = "silver"
	mats_per_unit = list(/datum/material/silver=MINERAL_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/silver

/obj/item/stack/tile/mineral/diamond
	name = "dalles en diamant"
	singular_name = "dalle en diamant"
	desc = "Une dalle faite de diamant. Wow, juste, wow."
	icon_state = "tile_diamond"
	inhand_icon_state = "tile-diamond"
	turf_type = /turf/open/floor/mineral/diamond
	mineralType = "diamond"
	mats_per_unit = list(/datum/material/diamond=MINERAL_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/diamond

/obj/item/stack/tile/mineral/bananium
	name = "dalles en bananium"
	singular_name = "dalle en bananium"
	desc = "Une dalle qui ne glisse pas faite de bananium, POUEEEEEEEEEEEET !"
	icon_state = "tile_bananium"
	inhand_icon_state = "tile-bananium"
	turf_type = /turf/open/floor/mineral/bananium
	mineralType = "bananium"
	mats_per_unit = list(/datum/material/bananium=MINERAL_MATERIAL_AMOUNT*0.25)
	material_flags = NONE //The slippery comp makes it unpractical for good clown decor. The material tiles should still slip.
	merge_type = /obj/item/stack/tile/mineral/bananium

/obj/item/stack/tile/mineral/abductor
	name = "dalles alien"
	singular_name = "dalle alien"
	desc = "Une dalle faite d'alliage alien."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "tile_abductor"
	inhand_icon_state = "tile-abductor"
	mats_per_unit = list(/datum/material/alloy/alien=MINERAL_MATERIAL_AMOUNT*0.25)
	turf_type = /turf/open/floor/mineral/abductor
	mineralType = "abductor"
	merge_type = /obj/item/stack/tile/mineral/abductor

/obj/item/stack/tile/mineral/titanium
	name = "dalles de titane"
	singular_name = "dalle de titane"
	desc = "Une dalle faite de titane, utilisée pour les navettes."
	icon_state = "tile_titanium"
	inhand_icon_state = "tile-shuttle"
	turf_type = /turf/open/floor/mineral/titanium
	mineralType = "titanium"
	mats_per_unit = list(/datum/material/titanium=MINERAL_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/titanium
	tile_reskin_types = list(
		/obj/item/stack/tile/mineral/titanium,
		/obj/item/stack/tile/mineral/titanium/yellow,
		/obj/item/stack/tile/mineral/titanium/blue,
		/obj/item/stack/tile/mineral/titanium/white,
		/obj/item/stack/tile/mineral/titanium/purple,
		/obj/item/stack/tile/mineral/titanium/tiled,
		/obj/item/stack/tile/mineral/titanium/tiled/yellow,
		/obj/item/stack/tile/mineral/titanium/tiled/blue,
		/obj/item/stack/tile/mineral/titanium/tiled/white,
		/obj/item/stack/tile/mineral/titanium/tiled/purple,
		)

/obj/item/stack/tile/mineral/titanium/yellow
	name = "dalles de titane jaune"
	singular_name = "dalle de titane jaune"
	desc = "Une dalle jaune faite de titane, utilisée pour les navettes."
	turf_type = /turf/open/floor/mineral/titanium/yellow
	icon_state = "tile_titanium_yellow"
	merge_type = /obj/item/stack/tile/mineral/titanium/yellow

/obj/item/stack/tile/mineral/titanium/blue
	name = "dalles de titane bleu"
	singular_name = "dalle de titane bleu"
	desc = "Une dalle bleu faite de titane, utilisée pour les navettes."
	turf_type = /turf/open/floor/mineral/titanium/blue
	icon_state = "tile_titanium_blue"
	merge_type = /obj/item/stack/tile/mineral/titanium/blue

/obj/item/stack/tile/mineral/titanium/white
	name = "dalles de titane blanche"
	singular_name = "dalle de titane blanche"
	desc = "Une dalle blanche faite de titane, utilisée pour les navettes."
	turf_type = /turf/open/floor/mineral/titanium/white
	icon_state = "tile_titanium_white"
	merge_type = /obj/item/stack/tile/mineral/titanium/white

/obj/item/stack/tile/mineral/titanium/purple
	name = "dalles de titane violette"
	singular_name = "dalle de titane violette"
	desc = "Une dalle violette faite de titane, utilisée pour les navettes."
	turf_type = /turf/open/floor/mineral/titanium/purple
	icon_state = "tile_titanium_purple"
	merge_type = /obj/item/stack/tile/mineral/titanium/purple

/obj/item/stack/tile/mineral/titanium/tiled
	name = "dalles de titane carrelées"
	singular_name = "dalle de titane carrelée"
	desc = "Dalle de titane carrelée, utilisée pour les navettes."
	turf_type = /turf/open/floor/mineral/titanium/tiled
	icon_state = "tile_titanium_tiled"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled

/obj/item/stack/tile/mineral/titanium/tiled/yellow
	name = "dalles de titane jaune"
	singular_name = "dalle de titane jaune"
	desc = "Une dalle jaune faite de titane, utilisée pour les navettes."
	turf_type = /turf/open/floor/mineral/titanium/tiled/yellow
	icon_state = "tile_titanium_tiled_yellow"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled/yellow

/obj/item/stack/tile/mineral/titanium/tiled/blue
	name = "dalles de titane bleu"
	singular_name = "dalle de titane bleu"
	desc = "Une dalle bleu faite de titane, utilisée pour les navettes."
	turf_type = /turf/open/floor/mineral/titanium/tiled/blue
	icon_state = "tile_titanium_tiled_blue"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled/blue

/obj/item/stack/tile/mineral/titanium/tiled/white
	name = "dalles de titane blanche"
	singular_name = "dalle de titane blanche"
	desc = "Une dalle blanche faite de titane, utilisée pour les navettes."
	turf_type = /turf/open/floor/mineral/titanium/tiled/white
	icon_state = "tile_titanium_tiled_white"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled/white

/obj/item/stack/tile/mineral/titanium/tiled/purple
	name = "dalles de titane violette"
	singular_name = "dalle de titane violette"
	desc = "Une dalle violette faite de titane, utilisée pour les navettes."
	turf_type = /turf/open/floor/mineral/titanium/tiled/purple
	icon_state = "tile_titanium_tiled_purple"
	merge_type = /obj/item/stack/tile/mineral/titanium/tiled/purple

/obj/item/stack/tile/mineral/plastitanium
	name = "dalles de plastitane"
	singular_name = "dalle de plastitane"
	desc = "Une dalle faite de plastitane, utilisée pour les navettes très maléfiques."
	icon_state = "tile_plastitanium"
	inhand_icon_state = "tile-darkshuttle"
	turf_type = /turf/open/floor/mineral/plastitanium
	mineralType = "plastitanium"
	mats_per_unit = list(/datum/material/alloy/plastitanium=MINERAL_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/plastitanium
	tile_reskin_types = list(
		/obj/item/stack/tile/mineral/plastitanium,
		/obj/item/stack/tile/mineral/plastitanium/red,
		)

/obj/item/stack/tile/mineral/plastitanium/red
	name = "dalles de plastitane rouge"
	singular_name = "dalle de plastitane rouge"
	desc = "Une dalle faite de plastitane, utilisée pour les navettes très rouges."
	turf_type = /turf/open/floor/mineral/plastitanium/red
	icon_state = "tile_plastitanium_red"
	merge_type = /obj/item/stack/tile/mineral/plastitanium/red

/obj/item/stack/tile/mineral/snow
	name = "dalles de neige"
	singular_name = "dalle de neige"
	desc = "Une couche de neige."
	icon_state = "tile_snow"
	inhand_icon_state = "tile-silver"
	turf_type = /turf/open/floor/fake_snow
	mineralType = "snow"
	merge_type = /obj/item/stack/tile/mineral/snow
