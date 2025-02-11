// This file contains everything used by security, or in other combat applications.

/obj/item/storage/box/flashbangs
	name = "boîte de flashbang (ATTENTION)"
	desc = "<B>ATTENTION : Ces dispositifs sont extrêmement dangereux et peuvent causer des blessures graves ou la mort en cas d'utilisation répétée.</B>"
	icon_state = "secbox"
	illustration = "flashbang"

/obj/item/storage/box/flashbangs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/flashbang(src)

/obj/item/storage/box/stingbangs
	name = "boîte de pique-bang (ATTENTION)"
	desc = "<B>ATTENTION : Ces dispositifs sont extrêmement dangereux et peuvent causer des blessures graves ou la mort en cas d'utilisation répétée.</B>"
	icon_state = "secbox"
	illustration = "flashbang"

/obj/item/storage/box/stingbangs/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/grenade/stingbang(src)

/obj/item/storage/box/flashes
	name = "boîte d'ampoule flash"
	desc = "<B>ATTENTION : Les flash peuvent causer des dégâts oculaires graves, des lunettes de protection sont nécessaires.</B>"
	icon_state = "secbox"
	illustration = "flash"

/obj/item/storage/box/flashes/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/assembly/flash/handheld(src)

/obj/item/storage/box/wall_flash
	name = "kit de création de flash fixe"
	desc = "Cette boîte contient tout ce qui est nécessaire pour construire un flash mural. <B>ATTENTION : Les flash peuvent causer des dégâts oculaires graves, des lunettes de protection sont nécessaires.</B>"
	icon_state = "secbox"
	illustration = "flash"

/obj/item/storage/box/wall_flash/PopulateContents()
	var/id = rand(1000, 9999)
	// FIXME what if this conflicts with an existing one?

	new /obj/item/wallframe/button(src)
	new /obj/item/electronics/airlock(src)
	var/obj/item/assembly/control/flasher/remote = new(src)
	remote.id = id
	var/obj/item/wallframe/flasher/frame = new(src)
	frame.id = id
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/screwdriver(src)


/obj/item/storage/box/teargas
	name = "boîte de grenade à gaz lacrymogène (ATTENTION)"
	desc = "<B>ATTENTION : Ces dispositifs sont extrêmement dangereux et peuvent causer aveuglement et irritation de la peau.</B>"
	icon_state = "secbox"
	illustration = "grenade"

/obj/item/storage/box/teargas/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/teargas(src)

/obj/item/storage/box/emps
	name = "boîte de grenade IEM"
	desc = "Une boîte avec 5 grenades IEM."
	illustration = "emp"

/obj/item/storage/box/emps/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/grenade/empgrenade(src)

/obj/item/storage/box/trackimp
	name = "boîte d'implants de pistage"
	desc = "Une boîte pleine d'implant de pistage de sacs à merde."
	icon_state = "secbox"
	illustration = "implant"

/obj/item/storage/box/trackimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/tracking = 4,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
		/obj/item/locator = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/minertracker
	name = "boîte d'implants de pistage"
	desc = "Une boîte pleine d'implant de pistage pour trouver les morts sur lavaland."
	illustration = "implant"

/obj/item/storage/box/minertracker/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/tracking = 3,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
		/obj/item/locator = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/chemimp
	name = "boîte d'implants chimiques"
	desc = "Une boîte pleine d'implants chimiques."
	illustration = "implant"

/obj/item/storage/box/chemimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/chem = 5,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/exileimp
	name = "boîte d'implants d'exil"
	desc = "boîte d'implants d'exil. Il y a une image d'un clown se faisant botter à travers la Porte."
	illustration = "implant"

/obj/item/storage/box/exileimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/exile = 5,
		/obj/item/implanter = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/prisoner
	name = "boîte d'ID de prisonnier"
	desc = "Prenez leur la fin de leur dignité, leur nom."
	icon_state = "secbox"
	illustration = "id"

/obj/item/storage/box/prisoner/PopulateContents()
	..()
	new /obj/item/card/id/advanced/prisoner/one(src)
	new /obj/item/card/id/advanced/prisoner/two(src)
	new /obj/item/card/id/advanced/prisoner/three(src)
	new /obj/item/card/id/advanced/prisoner/four(src)
	new /obj/item/card/id/advanced/prisoner/five(src)
	new /obj/item/card/id/advanced/prisoner/six(src)
	new /obj/item/card/id/advanced/prisoner/seven(src)

/obj/item/storage/box/seccarts
	name = "boîte de cartouches pour PDA de sécurité"
	desc = "Une boîte pleine de cartouches pour PDA utilisées par la sécurité."
	icon_state = "secbox"
	illustration = "pda"

/obj/item/storage/box/seccarts/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/computer_disk/security(src)

/obj/item/storage/box/firingpins
	name = "boîte de percuteurs standard"
	desc = "Une boîte pleine de percuteurs standard, pour permettre aux armes à feu nouvellement développées de fonctionner."
	icon_state = "secbox"
	illustration = "firingpin"

/obj/item/storage/box/firingpins/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/firing_pin(src)

/obj/item/storage/box/firingpins/paywall
	name = "boîte de percuteurs bloqué par un paiement"
	desc = "Une boîte pleine de percuteurs bloqués par un paiement, pour permettre aux armes à feu nouvellement développées de fonctionner derrière un paiement personnalisé."
	illustration = "firingpin"

/obj/item/storage/box/firingpins/paywall/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/firing_pin/paywall(src)

/obj/item/storage/box/lasertagpins
	name = "boîte de percuteurs de laser tag"
	desc = "Une boîte pleine de percuteurs de laser tag, pour permettre aux armes à feu nouvellement développées de nécessiter le port d'une armure en plastique de couleur vive avant de pouvoir être utilisées."
	illustration = "firingpin"

/obj/item/storage/box/lasertagpins/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/firing_pin/tag/red(src)
		new /obj/item/firing_pin/tag/blue(src)

/obj/item/storage/box/handcuffs
	name = "boîte de menottes de rechange"
	desc = "Une boîte pleine de menottes."
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/handcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs(src)

/obj/item/storage/box/zipties
	name = "boîte de serres-câble de rechange"
	desc = "Une boîte pleine de serres-câble."
	icon_state = "secbox"
	illustration = "handcuff"

/obj/item/storage/box/zipties/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs/cable/zipties(src)

/obj/item/storage/box/alienhandcuffs
	name = "boîte de menottes de rechange"
	desc = "Une boîte pleine de menottes."
	icon_state = "alienbox"
	illustration = "handcuff"

/obj/item/storage/box/alienhandcuffs/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/restraints/handcuffs/alien(src)

/obj/item/storage/box/rubbershot
	name = "boîte de cartouches pour fusil à pompe (Moins que létal - munitions en caoutchouc)"
	desc = "Une boîte pleine de cartouches en caoutchouc pour fusil à pompe, conçues pour les fusils à pompe."
	icon_state = "rubbershot_box"
	illustration = null

/obj/item/storage/box/rubbershot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/rubbershot(src)

/obj/item/storage/box/lethalshot
	name = "boîte de cartouches pour fusil à pompe (Létal)"
	desc = "Une boîte pleine de cartouches létale pour fusil à pompe, conçues pour les fusils à pompe."
	icon_state = "lethalshot_box"
	illustration = null

/obj/item/storage/box/lethalshot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/buckshot(src)

/obj/item/storage/box/beanbag
	name = "boîte de cartouches pour fusil à pompe (Moins que létal - munitions à sac de plombs)"
	desc = "Une boîte pleine de cartouches à sac de plombs pour fusil à pompe, conçues pour les fusils à pompe."
	icon_state = "beanbagshot_box"
	illustration = null

/obj/item/storage/box/beanbag/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/ammo_casing/shotgun/beanbag(src)

/obj/item/storage/box/emptysandbags
	name = "boîte de sacs de sable vides"
	illustration = "sandbag"

/obj/item/storage/box/emptysandbags/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/emptysandbag(src)

/obj/item/storage/box/holy_grenades
	name = "boîte de sainte grenades"
	desc = "Une boîte pleine de grenades utilisées pour purger rapidement l'hérésie."
	illustration = "grenade"

/obj/item/storage/box/holy_grenades/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/chem_grenade/holy(src)

/obj/item/storage/box/fireworks
	name = "boîte de feux d'artifice"
	desc = "Une boîte pleine de feux d'artifice."
	illustration = "sparkler"

/obj/item/storage/box/fireworks/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/sparkler(src)
		new/obj/item/grenade/firecracker(src)
	new /obj/item/toy/snappop(src)

/obj/item/storage/box/fireworks/dangerous
	desc = "Cette boîte a une petite étiquette indiquant qu'elle provient des Maraudeurs Gorlex. Contient un assortiment de \"feux d'artifice\"."

/obj/item/storage/box/fireworks/dangerous/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/sparkler(src)
		new/obj/item/grenade/firecracker(src)
	if(prob(20))
		new /obj/item/grenade/frag(src)
	else
		new /obj/item/toy/snappop(src)

/obj/item/storage/box/firecrackers
	name = "boîte de pétards"
	desc = "Une boîte pleine de pétards illégaux. Vous vous demandez qui les fabrique encore."
	icon_state = "syndiebox"
	illustration = "firecracker"

/obj/item/storage/box/firecrackers/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/firecracker(src)

/obj/item/storage/box/sparklers
	name = "boîte de pétards brillant"
	desc = "Une boîte de pétards brillant de la marque Nanotrasen, brûle chaud même dans le froid de l'espace-hiver."
	illustration = "sparkler"

/obj/item/storage/box/sparklers/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/sparkler(src)
