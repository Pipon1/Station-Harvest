/obj/item/food/pie
	icon = 'icons/obj/food/piecake.dmi'
	inhand_icon_state = "pie"
	bite_consumption = 3
	w_class = WEIGHT_CLASS_NORMAL
	max_volume = 80
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("de tarte" = 1)
	foodtypes = GRAIN
	venue_value = FOOD_PRICE_NORMAL
	/// type is spawned 5 at a time and replaces this pie when processed by cutting tool
	var/obj/item/food/pieslice/slice_type
	/// so that the yield can change if it isnt 5
	var/yield = 5

/obj/item/food/pie/make_processable()
	if (slice_type)
		AddElement(/datum/element/processable, TOOL_KNIFE, slice_type, yield, table_required = TRUE, screentip_verb = "Couper")

/obj/item/food/pieslice
	name = "part de tarte"
	icon = 'icons/obj/food/piecake.dmi'
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("de tarte" = 1, "d'incertitude" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/pie/plain
	name = "tarte simple"
	desc = "Une tarte simple, simplement délicieuse."
	icon_state = "pie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("de tarte" = 1)
	foodtypes = GRAIN
	burns_in_oven = TRUE

/obj/item/food/pie/cream
	name = "tarte à la banane"
	desc = "Exactement comme à la maison, sur la planète des clowns ! POUET !"
	icon_state = "pie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/banana = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de tarte" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	var/stunning = TRUE

/obj/item/food/pie/cream/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!.) //if we're not being caught
		splat(hit_atom)

/obj/item/food/pie/cream/proc/splat(atom/movable/hit_atom)
	if(isliving(loc)) //someone caught us!
		return
	var/turf/hit_turf = get_turf(hit_atom)
	new/obj/effect/decal/cleanable/food/pie_smudge(hit_turf)
	if(reagents?.total_volume)
		reagents.expose(hit_atom, TOUCH)
	var/is_creamable = TRUE
	if(isliving(hit_atom))
		var/mob/living/living_target_getting_hit = hit_atom
		if(stunning)
			living_target_getting_hit.Paralyze(2 SECONDS) //splat!
		if(iscarbon(living_target_getting_hit))
			is_creamable = !!(living_target_getting_hit.get_bodypart(BODY_ZONE_HEAD))
		if(is_creamable)
			living_target_getting_hit.adjust_eye_blur(2 SECONDS)
		living_target_getting_hit.visible_message(span_warning("[living_target_getting_hit] est couvert de crème à cause d'une [src]!"), span_userdanger("Une [src] volante vous a recouvert de crème !"))
		playsound(living_target_getting_hit, SFX_DESECRATION, 50, TRUE)
	if(is_creamable && is_type_in_typecache(hit_atom, GLOB.creamable))
		hit_atom.AddComponent(/datum/component/creamed, src)
	qdel(src)

/obj/item/food/pie/cream/nostun
	stunning = FALSE

/obj/item/food/pie/berryclafoutis
	name = "clafoutis aux baies"
	desc = "Attention à ne pas cafouiller dans la baie."
	icon_state = "berryclafoutis"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/berryjuice = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de tarte" = 1, "de baies" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/pie/bearypie
	name = "tarte à l'ours"
	desc = "Attention à ne pas cafourser dans la forêt."
	icon_state = "bearypie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de tarte" = 1, "de viande" = 1, "de saumon" = 1)
	foodtypes = GRAIN | SUGAR | MEAT | FRUIT

/obj/item/food/pie/meatpie
	name = "tourte à la viande"
	icon_state = "meatpie"
	desc = "Une vielle recette toujours aussi délicieuse !"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("de tourte" = 1, "de viande" = 1)
	foodtypes = GRAIN | MEAT
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/pie/tofupie
	name = "tourte au tofu"
	icon_state = "meatpie"
	desc = "Une délicieuse tourte au tofu."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de tourte" = 1, "de tofu" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/pie/amanita_pie
	name = "tarte à l'amanite"
	desc = "Douce et goutûe, pleine de poison !"
	icon_state = "amanita_pie"
	bite_consumption = 4
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/toxin/amatoxin = 3,
		/datum/reagent/drug/mushroomhallucinogen = 1,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de tarte" = 1, "de champignon" = 1)
	foodtypes = GRAIN | VEGETABLES | TOXIC | GROSS

/obj/item/food/pie/plump_pie
	name = "tarte au chapeau"
	desc = "Je parie que vous adorez les plats à base de chapeaux rondouillets !"
	icon_state = "plump_pie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de tarte" = 1, "de champignon" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/pie/plump_pie/Initialize(mapload)
	var/fey = prob(10)
	if(fey)
		name = "tarte au chapeau exeptionnel"
		desc = "Le micro-onde a été pris d'une humeur féérique et a cuit une tarte au chapeau rondouillet exeptionnel !"
		food_reagents = list(
			/datum/reagent/consumable/nutriment = 11,
			/datum/reagent/medicine/omnizine = 5,
			/datum/reagent/consumable/nutriment/vitamin = 4,
		)
	. = ..()

/obj/item/food/pie/xemeatpie
	name = "tourte au xeno"
	icon_state = "xenomeatpie"
	desc = "Une délicieuse tourte à la viande. Probablement hérétique."
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de tourte" = 1, "de viande" = 1, "d'acide" = 1)
	foodtypes = GRAIN | MEAT

/obj/item/food/pie/applepie
	name = "tarte aux pommes"
	desc = "Une tarte avec plein d'amour sucré... Ou des pommes."
	icon_state = "applepie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de tarte" = 1, "de pomme" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/pie/cherrypie
	name = "tarte à la cerise"
	desc = "Bonne à en faire pleurer."
	icon_state = "cherrypie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de tarte" = 1, "de cerise" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/pie/pumpkinpie
	name = "tarte à la citrouille"
	desc = "Une délicieuse sucrerie pour les mois d'automne."
	icon_state = "pumpkinpie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 11,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de tarte" = 1, "de citrouille" = 1)
	foodtypes = GRAIN | VEGETABLES | SUGAR
	slice_type = /obj/item/food/pieslice/pumpkin

/obj/item/food/pieslice/pumpkin
	name = "part de tarte à la citrouille"
	desc = "Une parte de tarte à la citrouille, avec une touche sucrée par dessus. Parfait."
	icon_state = "pumpkinpieslice"
	tastes = list("de tarte" = 1, "de citrouille" = 1)
	foodtypes = GRAIN | VEGETABLES | SUGAR

/obj/item/food/pie/appletart
	name = "tarte streusel aux pommes dorées"
	desc = "Un savoureux dessert qui ne passera pas les dédtecteurs de métaux."
	icon_state = "gappletart"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/gold = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de tarte" = 1, "de pomme" = 1, "de métal très cher" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/pie/grapetart
	name = "tarte aux raisins"
	desc = "Une savoureuse tarte qui vous rappelle le vin que vous ne produisez pas."
	icon_state = "grapetart"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de tarte" = 1, "de raisin" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/pie/mimetart
	name = "tarte du mime"
	desc = "..."
	icon_state = "mimetart"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/nothing = 10,
	)
	tastes = list("de rien" = 3)
	foodtypes = GRAIN

/obj/item/food/pie/berrytart
	name = "tartelette aux baies"
	desc = "Un savoureux dessert composée d'un assortiment de petites baies posées sur une fine pâte croustillante."
	icon_state = "berrytart"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("de tarte" = 1, "de baies" = 2)
	foodtypes = GRAIN | FRUIT

/obj/item/food/pie/cocolavatart
	name = "fondant au chocolat"
	desc = "Un savoureux dessert au chocolat, avec un coeur fondant." //But it doesn't even contain chocolate...
	icon_state = "cocolavatart"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de tarte" = 1, "de chocolat noir" = 3)
	foodtypes = GRAIN | SUGAR

/obj/item/food/pie/blumpkinpie
	name = "tarte à la trouillebleu"
	desc = "Une tarte bleue un peu étrange, fait avec de la trouillebleu toxique."
	icon_state = "blumpkinpie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 13,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de tarte" = 1, "d'une gorgé d'eau de piscine" = 1)
	foodtypes = GRAIN | VEGETABLES
	slice_type = /obj/item/food/pieslice/blumpkin

/obj/item/food/pieslice/blumpkin
	name = "part de tarte à la trouillebleu"
	desc = "Une part de tarte à la trouillebleu, avec un touche sucrée par dessus. Est-ce que c'est commestible ?"
	icon_state = "blumpkinpieslice"
	tastes = list("de tarte" = 1, "d'une gorgé d'eau de piscine" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/pie/dulcedebatata
	name = "dulce de batata"
	desc = "Un dessin sud-américain fait avec des patates douces."
	icon_state = "dulcedebatata"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 14,
		/datum/reagent/consumable/nutriment/vitamin = 8,
	)
	tastes = list("de sucre" = 1, "de patate douce" = 1)
	foodtypes = VEGETABLES | SUGAR
	venue_value = FOOD_PRICE_EXOTIC
	slice_type = /obj/item/food/pieslice/dulcedebatata

/obj/item/food/pieslice/dulcedebatata
	name = "part de dulce de batata"
	desc = "Une part de dulce de batata."
	icon_state = "dulcedebatataslice"
	tastes = list("de sucre" = 1, "de patate douce" = 1)
	foodtypes = VEGETABLES | SUGAR

/obj/item/food/pie/frostypie
	name = "tarte gelée"
	desc = "A le goût de la couleur bleu et du froid."
	icon_state = "frostypie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 14,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de menthe" = 1, "de tarte" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/pie/baklava
	name = "baklava"
	desc = "Un délicieux gateau feuilleté aux noix."
	icon_state = "baklava"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("de noix" = 1, "de tarte" = 1)
	foodtypes = NUTS | SUGAR
	slice_type = /obj/item/food/pieslice/baklava
	yield = 6

/obj/item/food/pieslice/baklava
	name = "part de baklava"
	desc = "Une délicieuse part de gateau feuilleté aux noix."
	icon_state = "baklavaslice"
	tastes = list("de noix" = 1, "de tarte" = 1)
	foodtypes = NUTS | SUGAR

/obj/item/food/pie/frenchsilkpie
	name = "french silk pie"
	desc = "Un gateau décadent, fait d'une mousse au chocolat crémeuse avec une sur-couche de crème fouettée et d'éclats de chocolat par dessus. Peut être découpé en tranches. Malgré son nom, c'est une recette très américaine." //French's edit : Au point qu'on a même pas de traduction...
	icon_state = "frenchsilkpie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("de tarte" = 1, "de chocolat" = 1, "de crème fouettée" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	slice_type = /obj/item/food/pieslice/frenchsilk

/obj/item/food/pieslice/frenchsilk
	name = "part de french silk pie"
	desc = "Une part de gateau décadente, faite d'une mousse au chocolat crémeuse avec une sur-couche de crème fouettée et d'éclats de chocolat par dessus. Suffisament bon pour vous faire pleurer."
	icon_state = "frenchsilkpieslice"
	tastes = list("de tarte" = 1, "de chocolat" = 1, "de crème fouettée" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR

/obj/item/food/pie/shepherds_pie
	name = "hachis parmentier d’agneau à l’anglaise"
	desc = "Un plat à base de viande et de légumes, cuit sous une couche de purée de pomme de terre. Peut être coupé en parts. Il parait que celui ou celle qui la créée s'appellait Shepherd."
	icon_state = "shepherds_pie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 40,
		/datum/reagent/consumable/nutriment/vitamin = 12,
		/datum/reagent/consumable/nutriment/protein = 20,
	)
	tastes = list("de viande juteuse" = 2, "de purée de pommes de terre" = 2, "de légumes cuits" = 2)
	foodtypes = MEAT | DAIRY | VEGETABLES
	slice_type = /obj/item/food/pieslice/shepherds_pie
	yield = 4

/obj/item/food/pieslice/shepherds_pie
	name = "part de hachis parmentier d’agneau à l’anglaise"
	desc = "Une part de la fameuse tarte de Shepherd, à base de viande et de légumes, cuit sous une couche de purée de pomme de terre. Dangereusement bonne."
	icon_state = "shepherds_pie_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 3,
		/datum/reagent/consumable/nutriment/protein = 5,
	)
	tastes = list("de viande juteuse" = 2, "de purée de pommes de terre" = 2, "de légumes cuits" = 2)
	foodtypes = MEAT | DAIRY | VEGETABLES

/obj/item/food/pie/asdfpie
	name = "Tarte à la tarte"
	desc = "C'était de la tarte à faire !"
	icon_state = "asdfpie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 16,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("de tarte" = 1, "de la lointaine année 2010" = 1)
	foodtypes = GRAIN
	burns_in_oven = TRUE
