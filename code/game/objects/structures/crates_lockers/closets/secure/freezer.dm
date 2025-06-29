/obj/structure/closet/secure_closet/freezer
	icon_state = "congélateur"
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1
	door_anim_squish = 0.22
	door_anim_angle = 123
	door_anim_time = 4
	/// If FALSE, we will protect the first person in the freezer from an explosion / nuclear blast.
	var/jones = FALSE

/obj/structure/closet/secure_closet/freezer/Destroy()
	toggle_organ_decay(src)
	return ..()

/obj/structure/closet/secure_closet/freezer/Initialize(mapload)
	. = ..()
	toggle_organ_decay(src)

/obj/structure/closet/secure_closet/freezer/open(mob/living/user, force = FALSE)
	if(opened || !can_open(user, force)) //dupe check just so we don't let the organs decay when someone fails to open the locker
		return FALSE
	toggle_organ_decay(src)
	return ..()

/obj/structure/closet/secure_closet/freezer/close(mob/living/user)
	if(..()) //if we actually closed the locker
		toggle_organ_decay(src)
		return TRUE

/obj/structure/closet/secure_closet/freezer/ex_act()
	if(jones)
		return ..()
	jones = TRUE
	flags_1 &= ~PREVENT_CONTENTS_EXPLOSION_1

/obj/structure/closet/secure_closet/freezer/atom_destruction(damage_flag)
	new /obj/item/stack/sheet/iron(drop_location(), 1)
	new /obj/item/assembly/igniter/condenser(drop_location())
	return ..()

/obj/structure/closet/secure_closet/freezer/welder_act(mob/living/user, obj/item/tool)
	. = ..()

	if(!opened)
		balloon_alert(user, "il faut l'ouvrir !")
		return TRUE

	if(!tool.use_tool(src, user, 40, volume=50))
		return TRUE

	new /obj/item/stack/sheet/iron(drop_location(), 2)
	new /obj/item/assembly/igniter/condenser(drop_location())
	qdel(src)

	return TRUE

/obj/structure/closet/secure_closet/freezer/empty
	name = "congélateur"

/obj/structure/closet/secure_closet/freezer/empty/open
	req_access = null
	locked = FALSE

/obj/structure/closet/secure_closet/freezer/kitchen
	name = "armoire de cuisine"
	req_access = list(ACCESS_KITCHEN)

/obj/structure/closet/secure_closet/freezer/kitchen/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/condiment/flour(src)
	new /obj/item/reagent_containers/condiment/rice(src)
	new /obj/item/reagent_containers/condiment/sugar(src)

/obj/structure/closet/secure_closet/freezer/kitchen/maintenance
	name = "réfrigérateur de maintenance"
	desc = "Ce réfrigérateur à l'air aussi poussérieux..."
	req_access = list()

/obj/structure/closet/secure_closet/freezer/kitchen/maintenance/PopulateContents()
	..()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/condiment/milk(src)
		new /obj/item/reagent_containers/condiment/soymilk(src)
	for(var/i in 1 to 2)
		new /obj/item/storage/fancy/egg_box(src)

/obj/structure/closet/secure_closet/freezer/kitchen/mining
	req_access = list()

/obj/structure/closet/secure_closet/freezer/meat
	name = "réfrigérateur à viande"
	req_access = list(ACCESS_KITCHEN)

/obj/structure/closet/secure_closet/freezer/meat/PopulateContents()
	..()
	for(var/i in 1 to 4)
		new /obj/item/food/meat/slab/monkey(src)

/obj/structure/closet/secure_closet/freezer/meat/open
	req_access = list()
	locked = FALSE

/obj/structure/closet/secure_closet/freezer/gulag_fridge
	name = "réfrigérateur"

/obj/structure/closet/secure_closet/freezer/gulag_fridge/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/cup/glass/bottle/beer/light(src)

/obj/structure/closet/secure_closet/freezer/fridge
	name = "réfrigérateur"
	req_access = list(ACCESS_KITCHEN)

/obj/structure/closet/secure_closet/freezer/fridge/PopulateContents()
	..()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/condiment/milk(src)
		new /obj/item/reagent_containers/condiment/soymilk(src)
	for(var/i in 1 to 2)
		new /obj/item/storage/fancy/egg_box(src)

/obj/structure/closet/secure_closet/freezer/fridge/open
	req_access = null
	locked = FALSE

/obj/structure/closet/secure_closet/freezer/money
	name = "congélateur"
	desc = "Contient de l'argent froid."
	req_access = list(ACCESS_VAULT)

/obj/structure/closet/secure_closet/freezer/money/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/stack/spacecash/c1000(src)
	for(var/i in 1 to 5)
		new /obj/item/stack/spacecash/c500(src)
	for(var/i in 1 to 6)
		new /obj/item/stack/spacecash/c200(src)

/obj/structure/closet/secure_closet/freezer/cream_pie
	name = "casier pour tarte à la crême"
	desc = "Contient des tartes remplie de crêmes... Espèce de malade."
	req_access = list(ACCESS_THEATRE)

/obj/structure/closet/secure_closet/freezer/cream_pie/PopulateContents()
	..()
	new /obj/item/food/pie/cream(src)
