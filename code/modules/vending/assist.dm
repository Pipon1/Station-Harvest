/obj/machinery/vending/assist
	name = "\improper Marcho-Morceau"
	desc = "Tout l'électronique dont vous avez besoin ! Nous déclinons toute responsibilité liée à de mauvaise utilisation."
	icon_state = "parts"
	icon_deny = "parts-deny"
	panel_type = "panel10"
	products = list(
		/obj/item/assembly/igniter = 3,
		/obj/item/assembly/prox_sensor = 5,
		/obj/item/assembly/signaler = 4,
		/obj/item/computer_disk/ordnance = 4,
		/obj/item/stock_parts/capacitor = 3,
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/micro_laser = 3,
		/obj/item/stock_parts/scanning_module = 3,
		/obj/item/wirecutters = 1,
	)
	contraband = list(
		/obj/item/assembly/health = 2,
		/obj/item/assembly/timer = 2,
		/obj/item/assembly/voice = 2,
		/obj/item/stock_parts/cell/high = 1,
	)
	premium = list(
		/obj/item/assembly/igniter/condenser = 2,
		/obj/item/circuitboard/machine/vendor = 3,
		/obj/item/universal_scanner = 3,
		/obj/item/vending_refill/custom = 3,
	)

	refill_canister = /obj/item/vending_refill/assist
	product_ads = "Les meilleurs morceaux !;Le meilleur de l'électronique.;Le matériel le plus robuste.;Matériaux résistants à l'espace !"
	default_price = PAYCHECK_CREW * 0.7 //Default of 35.
	extra_price = PAYCHECK_CREW
	payment_department = NO_FREEBIES
	light_mask = "parts-light-mask"

/obj/item/vending_refill/assist
	machine_name = "Marcho-Morceau"
	icon_state = "refill_parts"
