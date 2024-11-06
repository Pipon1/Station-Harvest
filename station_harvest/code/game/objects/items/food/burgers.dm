/obj/item/food/burger/wilo
	name = "Wilo burger"
	desc = "Un burger basé sur Veronica Wilo... un peu croquant... serait-ce des morceaux d'os ? Ou bien un masque à oxygène ?"
	icon = 'station_harvest/icons/obj/food/burgerbread.dmi'
	icon_state = "wiloburger"
	food_reagents = list(
		/datum/reagent/drug/maint/sludge = 4,
		/datum/reagent/consumable/nutriment/protein = 6,
	)
	tastes = list("bun" = 2, "beef patty" = 3, "dépression" = 5)
	foodtypes = GRAIN | MEAT | DAIRY
