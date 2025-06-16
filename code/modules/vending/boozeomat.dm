/obj/machinery/vending/boozeomat
	name = "\improper Alcool-omate"
	desc = "Une merveille de technologie, supposément capable de mélanger votre boisson au moment où vous lui demandez."
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	panel_type = "panel22"

	product_categories = list(
		list(
			"name" = "Alcoolisé",
			"icon" = "wine-bottle",
			"products" = list(
				/obj/item/reagent_containers/cup/glass/bottle/curacao = 5,
				/obj/item/reagent_containers/cup/glass/bottle/applejack = 5,
				/obj/item/reagent_containers/cup/glass/bottle/tequila = 5,
				/obj/item/reagent_containers/cup/glass/bottle/rum = 5,
				/obj/item/reagent_containers/cup/glass/bottle/cognac = 5,
				/obj/item/reagent_containers/cup/glass/bottle/wine = 5,
				/obj/item/reagent_containers/cup/glass/bottle/absinthe = 5,
				/obj/item/reagent_containers/cup/glass/bottle/vermouth = 5,
				/obj/item/reagent_containers/cup/glass/bottle/gin = 5,
				/obj/item/reagent_containers/cup/glass/bottle/grenadine = 4,
				/obj/item/reagent_containers/cup/glass/bottle/hcider = 5,
				/obj/item/reagent_containers/cup/glass/bottle/amaretto = 5,
				/obj/item/reagent_containers/cup/glass/bottle/ale = 6,
				/obj/item/reagent_containers/cup/glass/bottle/grappa = 5,
				/obj/item/reagent_containers/cup/glass/bottle/navy_rum = 5,
				/obj/item/reagent_containers/cup/glass/bottle/maltliquor = 6,
				/obj/item/reagent_containers/cup/glass/bottle/kahlua = 5,
				/obj/item/reagent_containers/cup/glass/bottle/sake = 5,
				/obj/item/reagent_containers/cup/glass/bottle/beer = 6,
				/obj/item/reagent_containers/cup/glass/bottle/vodka = 5,
				/obj/item/reagent_containers/cup/glass/bottle/whiskey = 5,
			),
		),

		list(
			"name" = "Non-Alcoolisé",
			"icon" = "bottle-water",
			"products" = list(
				/obj/item/reagent_containers/cup/glass/ice = 10,
				/obj/item/reagent_containers/cup/glass/bottle/juice/limejuice = 4,
				/obj/item/reagent_containers/cup/glass/bottle/juice/menthol = 4,
				/obj/item/reagent_containers/cup/glass/bottle/juice/cream = 4,
				/obj/item/reagent_containers/cup/glass/bottle/juice/orangejuice = 4,
				/obj/item/reagent_containers/cup/glass/bottle/juice/tomatojuice = 4,
				/obj/item/reagent_containers/cup/soda_cans/sodawater = 15,
				/obj/item/reagent_containers/cup/soda_cans/sol_dry = 8,
				/obj/item/reagent_containers/cup/soda_cans/cola = 8,
				/obj/item/reagent_containers/cup/soda_cans/tonic = 8,
			),
		),

		list(
			"name" = "Verrerie",
			"icon" = "wine-glass",
			"products" = list(
				/obj/item/reagent_containers/cup/glass/drinkingglass = 30,
				/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass = 12,
				/obj/item/reagent_containers/cup/glass/flask = 3,
				/obj/item/reagent_containers/cup/glass/bottle = 15,
				/obj/item/reagent_containers/cup/glass/bottle/small = 15,
			),
		),
	)

	contraband = list(
		/obj/item/reagent_containers/cup/glass/mug/tea = 12,
		/obj/item/reagent_containers/cup/glass/bottle/fernet = 5,
	)
	premium = list(
		/obj/item/reagent_containers/cup/bottle/ethanol = 4,
		/obj/item/reagent_containers/cup/glass/bottle/champagne = 5,
		/obj/item/reagent_containers/cup/glass/bottle/trappist = 5,
		/obj/item/reagent_containers/cup/glass/bottle/bitters = 5,
	)

	product_slogans = "J'espère que personne ne va me demander une trader de tasse de thé...;L'alcool est l'ami de l'humanité. Est-ce que vous abandonneriez un ami ?;Au plaisir de vous servir !;Personne n'a soif, sur cette station ?"
	product_ads = "À boire !;L'alcool, c'est bon pour vous !;L'alcool est l'ami de l'humanité.;Au plaisir de vous servir !;Envie d'une bonne bière ?;Rien ne peut mieux vous soigner que l'alcool !;Prenez une gorgée !;Prenez un verre !;Prenez une bière!;La bière c'est bon pour vous !;Seulement le meilleur alcool !;Meilleur qualité d'alcool depuis 2058 !;Vin prisé !;Maximum d'alcool !;Ici, on aime la bière.;Un toast au progrès!"
	req_access = list(ACCESS_BAR)
	refill_canister = /obj/item/vending_refill/boozeomat
	default_price = PAYCHECK_CREW * 0.9
	extra_price = PAYCHECK_COMMAND
	payment_department = ACCOUNT_SRV
	light_mask = "boozeomat-light-mask"

/obj/machinery/vending/boozeomat/all_access
	desc = "Une merveille de technologie, supposément capable de mélanger votre boisson au moment où vous lui demandez. Ce modèle semble ne pas avoir de restriction."
	req_access = null

/obj/machinery/vending/boozeomat/syndicate_access
	req_access = list(ACCESS_SYNDICATE)
	age_restrictions = FALSE
	initial_language_holder = /datum/language_holder/syndicate

/obj/item/vending_refill/boozeomat
	machine_name = "Alcool-omate"
	icon_state = "refill_booze"
