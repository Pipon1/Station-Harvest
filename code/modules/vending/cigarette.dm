/obj/machinery/vending/cigarette
	name = "\improper Clope-louche de luxe"
	desc = "Si vous voulez un cancer, il veut mieux le faire avec style."
	product_slogans = "Fumer une cigarette dans l'espace, avec le goût qu'une cigarette devrait avoir.;Je préfère fumer ma vie qu'éteindre ma clope.;Fumez !;Ne croyez pas les études, fumez des clopes !"
	product_ads = "Probablement pas dangereux pour la santé !;Ne croyez pas les scientifiques !;C'est bon pour vous !;N'arretez pas, achetez plus !;Fumez !;Un paradis de nicotine.;Meilleures cigarettes depuis 2150.;Cigarettes prisées."
	icon_state = "cigs"
	panel_type = "panel5"
	products = list(
		/obj/item/storage/fancy/cigarettes = 5,
		/obj/item/storage/fancy/cigarettes/cigpack_candy = 4,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_robust = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_carp = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_midori = 3,
		/obj/item/storage/box/matches = 10,
		/obj/item/lighter/greyscale = 4,
		/obj/item/storage/fancy/rollingpapers = 5,
	)
	contraband = list(
		/obj/item/clothing/mask/vape = 5,
	)
	premium = list(
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold = 3,
		/obj/item/storage/box/gum/nicotine = 2,
		/obj/item/lighter = 3,
		/obj/item/storage/fancy/cigarettes/cigars = 1,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 1,
		/obj/item/storage/fancy/cigarettes/cigars/cohiba = 1,
	)

	refill_canister = /obj/item/vending_refill/cigarette
	default_price = PAYCHECK_CREW
	extra_price = PAYCHECK_COMMAND
	payment_department = ACCOUNT_SRV
	light_mask = "cigs-light-mask"

/obj/machinery/vending/cigarette/syndicate
	products = list(
		/obj/item/storage/fancy/cigarettes/cigpack_syndicate = 7,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_candy = 2,
		/obj/item/storage/fancy/cigarettes/cigpack_robust = 2,
		/obj/item/storage/fancy/cigarettes/cigpack_carp = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_midori = 1,
		/obj/item/storage/box/matches = 10,
		/obj/item/lighter/greyscale = 4,
		/obj/item/storage/fancy/rollingpapers = 5,
	)
	initial_language_holder = /datum/language_holder/syndicate

/obj/machinery/vending/cigarette/beach //Used in the lavaland_biodome_beach.dmm ruin
	name = "\improper Clope-louche Ultra"
	desc = "Dès maintenant : de nouveaux produits de luxe !"
	product_ads = "Probablement pas dangereux pour la santé !;La drogue t'aidera à passer les mauvais moments où t'as pas de thune, quand la thune t'aidera pas à passer les moments sans drogue !;C'est bon pour vous !"
	product_slogans = "Allumer, fumer, recommencez Turn on, tune in, drop out!;Better living through chemistry!;Toke!;Don't forget to keep a smile on your lips and a song in your heart!"
	products = list(
		/obj/item/storage/fancy/cigarettes = 5,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_robust = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_carp = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_midori = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_cannabis = 5,
		/obj/item/storage/box/matches = 10,
		/obj/item/lighter/greyscale = 4,
		/obj/item/storage/fancy/rollingpapers = 5,
	)
	premium = list(
		/obj/item/storage/fancy/cigarettes/cigpack_mindbreaker = 5,
		/obj/item/clothing/mask/vape = 5,
		/obj/item/lighter = 3,
	)
	initial_language_holder = /datum/language_holder/beachbum

/obj/item/vending_refill/cigarette
	machine_name = "Clope-louche de luxe"
	icon_state = "refill_smoke"

/obj/machinery/vending/cigarette/pre_throw(obj/item/I)
	if(istype(I, /obj/item/lighter))
		var/obj/item/lighter/L = I
		L.set_lit(TRUE)
