/obj/structure/closet/secure_closet/ert_com
	name = "casier du commandant de l'unité de réponse rapide"
	desc = "Une unité de stockage contenant l'équipement du commandant de l'unité de réponse rapide."
	req_access = list(ACCESS_CENT_CAPTAIN)
	icon_state = "cap"

/obj/structure/closet/secure_closet/ert_com/PopulateContents()
	..()
	new /obj/item/storage/medkit/regular(src)
	new /obj/item/storage/box/handcuffs(src)
	new /obj/item/assembly/flash/handheld(src)
	if(prob(50))
		new /obj/item/ammo_box/magazine/m50(src)
		new /obj/item/ammo_box/magazine/m50(src)
		new /obj/item/gun/ballistic/automatic/pistol/deagle(src)
	else
		new /obj/item/ammo_box/a357(src)
		new /obj/item/ammo_box/a357(src)
		new /obj/item/gun/ballistic/revolver/mateba(src)

/obj/structure/closet/secure_closet/ert_com/populate_contents_immediate()
	. = ..()

	// Traitor steal objective
	new /obj/item/aicard(src)

/obj/structure/closet/secure_closet/ert_sec
	name = "casier d'agent de sécurité de l'unité de réponse rapide"
	desc = "Une unité de stockage contenant l'équipement des agents de sécurité de l'équipe de réponse rapide."
	req_access = list(ACCESS_CENT_SPECOPS)
	icon_state = "hos"

/obj/structure/closet/secure_closet/ert_sec/PopulateContents()
	..()
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/teargas(src)
	new /obj/item/storage/box/flashes(src)
	new /obj/item/storage/box/handcuffs(src)
	new /obj/item/shield/riot/tele(src)

/obj/structure/closet/secure_closet/ert_med
	name = "casier de médecin de l'unité de réponse rapide"
	desc = "Une unité de stockage contenant l'équipement pour les médecins de l'équipe de réponse rapide."
	req_access = list(ACCESS_CENT_MEDICAL)
	icon_state = "cmo"

/obj/structure/closet/secure_closet/ert_med/PopulateContents()
	..()
	new /obj/item/storage/medkit/o2(src)
	new /obj/item/storage/medkit/toxin(src)
	new /obj/item/storage/medkit/fire(src)
	new /obj/item/storage/medkit/brute(src)
	new /obj/item/storage/medkit/regular(src)
	new /obj/item/defibrillator/compact/combat/loaded/nanotrasen(src)
	new /mob/living/simple_animal/bot/medbot(src)

/obj/structure/closet/secure_closet/ert_engi
	name = "casier de l'ingénieur de l'unité de réponse rapide"
	desc = "Une unité de stockage contenant l'équipement des ingénieurs de l'unité de réponse rapide."
	req_access = list(ACCESS_CENT_STORAGE)
	icon_state = "ce"

/obj/structure/closet/secure_closet/ert_engi/PopulateContents()
	..()
	new /obj/item/stack/sheet/plasteel(src, 50)
	new /obj/item/stack/sheet/iron(src, 50)
	new /obj/item/stack/sheet/glass(src, 50)
	new /obj/item/stack/sheet/mineral/sandbags(src, 30)
	new /obj/item/clothing/shoes/magboots(src)
	new /obj/item/storage/box/smart_metal_foam(src)
	for(var/i in 1 to 3)
		new /obj/item/rcd_ammo/large(src)
