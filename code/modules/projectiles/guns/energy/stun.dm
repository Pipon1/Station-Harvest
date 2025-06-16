/obj/item/gun/energy/taser
	name = "taser"
	desc = "Une arme à impulsion électrique à faible capacité utilisée par les équipes de sécurité pour neutraliser les cibles à distance."
	icon_state = "taser"
	inhand_icon_state = null //so the human update icon uses the icon_state instead.
	ammo_type = list(/obj/item/ammo_casing/energy/electrode)
	ammo_x_offset = 3

/obj/item/gun/energy/e_gun/advtaser
	name = "taser hybride"
	desc = "Un taser hybride à double mode conçu pour tirer à la fois des électrodes haute puissance à courte portée et des faisceaux paralysant à longue portée."
	icon_state = "advtaser"
	ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/disabler)
	ammo_x_offset = 2

/obj/item/gun/energy/e_gun/advtaser/cyborg
	name = "taser de cyborg"
	desc = "Un taser hybride intégré qui puise directement dans la cellule d'énergie d'un cyborg. L'arme contient un limiteur pour empêcher la cellule d'énergie du cyborg de surchauffer."
	can_charge = FALSE
	use_cyborg_cell = TRUE

/obj/item/gun/energy/e_gun/advtaser/cyborg/add_seclight_point()
	return

/obj/item/gun/energy/e_gun/advtaser/cyborg/emp_act()
	return

/obj/item/gun/energy/disabler
	name = "paralyseur"
	desc = "Une arme d'auto-défense qui épuise les cibles organiques, les affaiblissant jusqu'à ce qu'elles s'effondrent."
	icon_state = "disabler"
	inhand_icon_state = null
	ammo_type = list(/obj/item/ammo_casing/energy/disabler)
	ammo_x_offset = 2

/obj/item/gun/energy/disabler/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 15, \
		overlay_y = 10)

/obj/item/gun/energy/disabler/cyborg
	name = "paralyseur de cyborg"
	desc = "Un paralyseur intégré qui puise directement dans la cellule d'énergie d'un cyborg. L'arme contient un limiteur pour empêcher la cellule d'énergie du cyborg de surchauffer."
	can_charge = FALSE
	use_cyborg_cell = TRUE

/obj/item/gun/energy/disabler/cyborg/emp_act()
	return
