/datum/round_event_control/spooky
	name = "2 SPOOKY! (Halloween)"
	holidayID = HALLOWEEN
	typepath = /datum/round_event/spooky
	weight = -1 //forces it to be called, regardless of weight
	max_occurrences = 1
	earliest_start = 0 MINUTES
	category = EVENT_CATEGORY_HOLIDAY
	description = "Donne des sucreries à tout le monde, et met Ian et Poly dans leur version festive.."

/datum/round_event/spooky/start()
	..()
	for(var/i in GLOB.human_list)
		var/mob/living/carbon/human/H = i
		var/obj/item/storage/backpack/b = locate() in H.contents
		if(b)
			new /obj/item/storage/spooky(b)

	for(var/mob/living/basic/pet/dog/corgi/ian/Ian in GLOB.mob_living_list)
		Ian.place_on_head(new /obj/item/bedsheet(Ian))
	for(var/mob/living/simple_animal/parrot/poly/Poly in GLOB.mob_living_list)
		new /mob/living/simple_animal/parrot/poly/ghost(Poly.loc)
		qdel(Poly)

/datum/round_event/spooky/announce(fake)
	priority_announce(pick("UN BONBON OU UN SORT !","TOC TOC TOC !", "DING DONG !", "SPOOKY SCARY SKELETONS!", "IL EST L'HEURE, VOICI LA PEUR!") , "ATTENTION LES FANTOMES DEPOUSSIERENT LEUR DRAP, LES AUTRES SORTENT DE LEUR TOMBE !")

//spooky foods (you can't actually make these when it's not halloween)
/obj/item/food/cookie/sugar/spookyskull
	name = "cookie squelette"
	desc = "Terrifiant ! Avec un petit goût de calcium !"
	icon = 'icons/obj/holiday/halloween_items.dmi'
	icon_state = "skeletoncookie"

/obj/item/food/cookie/sugar/spookycoffin
	name = "cookie tombeau"
	desc = "Terrifiant ! Avec un petit goût de café !"
	icon = 'icons/obj/holiday/halloween_items.dmi'
	icon_state = "coffincookie"

//spooky items

/obj/item/storage/spooky
	name = "sacitrouille"
	desc = "Un sac qui donne trop la trouille, pour contenir tous les bonbons !!"
	icon = 'icons/obj/holiday/halloween_items.dmi'
	icon_state = "treatbag"

/obj/item/storage/spooky/Initialize(mapload)
	. = ..()
	for(var/distrobuteinbag in 0 to 5)
		var/type = pick(/obj/item/food/cookie/sugar/spookyskull,
		/obj/item/food/cookie/sugar/spookycoffin,
		/obj/item/food/candy_corn,
		/obj/item/food/candy,
		/obj/item/food/candiedapple,
		/obj/item/food/chocolatebar,
		/obj/item/organ/internal/brain ) // OH GOD THIS ISN'T CANDY!
		new type(src)
