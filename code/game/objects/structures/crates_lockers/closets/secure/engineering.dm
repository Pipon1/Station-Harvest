/obj/structure/closet/secure_closet/engineering_chief
	name = "casier du chef.fe ingénieur.e"
	req_access = list(ACCESS_CE)
	icon_state = "ce"

/obj/structure/closet/secure_closet/engineering_chief/PopulateContents()
	..()

	new /obj/item/storage/bag/garment/engineering_chief (src)
	new /obj/item/computer_disk/command/ce(src)
	new /obj/item/radio/headset/heads/ce(src)
	new /obj/item/megaphone/command(src)
	new /obj/item/holosign_creator/atmos(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/door_remote/chief_engineer(src)
	new /obj/item/pipe_dispenser(src)
	new /obj/item/circuitboard/machine/techfab/department/engineering(src)
	new /obj/item/extinguisher/advanced(src)
	new /obj/item/storage/photo_album/ce(src)
	new /obj/item/storage/box/skillchips/engineering(src)

/obj/structure/closet/secure_closet/engineering_chief/populate_contents_immediate()
	. = ..()

	// Traitor steal objective
	new /obj/item/areaeditor/blueprints(src)

/obj/structure/closet/secure_closet/engineering_electrical
	name = "casier pour matériel éléctronique"
	req_access = list(ACCESS_ENGINE_EQUIP)
	icon_state = "eng"
	icon_door = "eng_elec"

/obj/structure/closet/secure_closet/engineering_electrical/PopulateContents()
	..()
	var/static/items_inside = list(
		/obj/item/clothing/gloves/color/yellow = 2,
		/obj/item/inducer = 2,
		/obj/item/storage/toolbox/electrical = 3,
		/obj/item/electronics/apc = 3,
		/obj/item/multitool = 3)
	generate_items_inside(items_inside,src)

/obj/structure/closet/secure_closet/engineering_welding
	name = "casier pour matériel de soudage"
	req_access = list(ACCESS_ENGINE_EQUIP)
	icon_state = "eng"
	icon_door = "eng_weld"

/obj/structure/closet/secure_closet/engineering_welding/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/utility/welding(src)
	for(var/i in 1 to 3)
		new /obj/item/weldingtool(src)

/obj/structure/closet/secure_closet/engineering_personal
	name = "casier pour équipement d'ingénieurs"
	req_access = list(ACCESS_ENGINE_EQUIP)
	icon_state = "eng_secure"

/obj/structure/closet/secure_closet/engineering_personal/PopulateContents()
	..()
	new /obj/item/radio/headset/headset_eng(src)
	new /obj/item/storage/toolbox/mechanical(src)
	new /obj/item/tank/internals/emergency_oxygen/engi(src)
	new /obj/item/holosign_creator/engineering(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/glasses/meson/engine(src)
	new /obj/item/storage/box/emptysandbags(src)
	new /obj/item/storage/bag/construction(src)


/obj/structure/closet/secure_closet/atmospherics
	name = "casier pour équipement de technicien.ne en atmosphère"
	req_access = list(ACCESS_ATMOSPHERICS)
	icon_state = "atmos"

/obj/structure/closet/secure_closet/atmospherics/PopulateContents()
	..()
	new /obj/item/radio/headset/headset_eng(src)
	new /obj/item/pipe_dispenser(src)
	new /obj/item/storage/toolbox/mechanical(src)
	new /obj/item/tank/internals/emergency_oxygen/engi(src)
	new /obj/item/holosign_creator/atmos(src)
	new /obj/item/watertank/atmos(src)
	new /obj/item/clothing/suit/utility/fire/atmos(src)
	new /obj/item/clothing/gloves/atmos(src)
	new /obj/item/clothing/mask/gas/atmos(src)
	new /obj/item/clothing/head/utility/hardhat/welding/atmos(src)
	new /obj/item/clothing/glasses/meson/engine/tray(src)
	new /obj/item/extinguisher/advanced(src)
