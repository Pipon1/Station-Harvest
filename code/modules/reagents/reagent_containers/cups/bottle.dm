//Not to be confused with /obj/item/reagent_containers/cup/glass/bottle

/obj/item/reagent_containers/cup/bottle
	name = "Bouteille"
	desc = "Un petite bouteille."
	icon_state = "bottle"
	fill_icon_state = "bottle"
	inhand_icon_state = "atoxinbottle"
	worn_icon_state = "bottle"
	possible_transfer_amounts = list(5, 10, 15, 25, 30)
	volume = 30
	fill_icon_thresholds = list(0, 1, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/cup/bottle/Initialize(mapload)
	. = ..()
	if(!icon_state)
		icon_state = "bottle"
	update_appearance()

/obj/item/reagent_containers/cup/bottle/epinephrine
	name = "Une bouteille d'épinéphrine"
	desc = "Un petite bouteille. Contient de l'épinéphrine - Utilisé pour stabiliser des patients."
	list_reagents = list(/datum/reagent/medicine/epinephrine = 30)

/obj/item/reagent_containers/cup/bottle/toxin
	name = "Bouteille de toxine"
	desc = "Une petite bouteille de toxine. Ne pas boire c'est toxique."
	list_reagents = list(/datum/reagent/toxin = 30)

/obj/item/reagent_containers/cup/bottle/cyanide
	name = "Bouteille de cyanure"
	desc = "Une petite bouteille de cyanure. Un gout d'amande amère ?"
	list_reagents = list(/datum/reagent/toxin/cyanide = 30)

/obj/item/reagent_containers/cup/bottle/spewium
	name = "Bouteille de spewium"
	desc = "Une petite bouteille de spewmium."
	list_reagents = list(/datum/reagent/toxin/spewium = 30)

/obj/item/reagent_containers/cup/bottle/morphine
	name = "Bouteille de morphine"
	desc = "Une petite bouteille de morphine."
	icon = 'icons/obj/medical/chemical.dmi'
	list_reagents = list(/datum/reagent/medicine/morphine = 30)

/obj/item/reagent_containers/cup/bottle/chloralhydrate
	name = "Bouteille d'hydrate de chloral"
	desc = "Une petite bouteille d'hydrate de chloral. Le favoris de Mickey !"
	icon_state = "bottle20"
	list_reagents = list(/datum/reagent/toxin/chloralhydrate = 15)

/obj/item/reagent_containers/cup/bottle/mannitol
	name = "Bouteille de mannitol"
	desc = "Une petite bouteille de mannitol. Util pour soigner des dégats au cerveau."
	list_reagents = list(/datum/reagent/medicine/mannitol = 30)

/obj/item/reagent_containers/cup/bottle/multiver
	name = "Bouteille de multiver"
	desc = "Une petite bouteille de multiver. Permet de retirer les toxines et autre produit chimique du sans, mais cause des problèmes respiratoir. Les effets sont proportionnel à quantité de produit présent dans le patient."
	list_reagents = list(/datum/reagent/medicine/c2/multiver = 30)

/obj/item/reagent_containers/cup/bottle/phlogiston
	name = "Bouteille de phlogiston"
	desc = "Une petite bouteille de phlogiston. Mettera le feu si utilisé."
	volume = 50
	list_reagents = list(/datum/reagent/phlogiston = 30)

/obj/item/reagent_containers/cup/bottle/ammoniated_mercury
	name = "Bouteille de chlorure de mercure"
	desc = "Purge rapidement les toxines présentent dans le sang. Soigne les dégats de toxine quand le patient n'a aucune blessures. Dans le cas où des blessures sont présente, cause de lourd dégat de toxine."
	list_reagents = list(/datum/reagent/medicine/ammoniated_mercury = 30)

/obj/item/reagent_containers/cup/bottle/syriniver
	name = "Bouteille de syriniver"
	desc = "Une petite bouteille de syriniver."
	list_reagents = list(/datum/reagent/medicine/c2/syriniver = 30)

/obj/item/reagent_containers/cup/bottle/mutagen
	name = "Bouteille de mutagen instable"
	desc = "Une petite bouteille de mutagen instable. Mute de force l'ADN de tout ce qu'il touche."
	list_reagents = list(/datum/reagent/toxin/mutagen = 30)

/obj/item/reagent_containers/cup/bottle/plasma
	name = "Bouteille de plasma liquide"
	desc = "Une petite bouteille de plasma liquide. Extrêmement toxique et réagit avec les micros-organismes présent dans le sang."
	list_reagents = list(/datum/reagent/toxin/plasma = 30)

/obj/item/reagent_containers/cup/bottle/synaptizine
	name = "Bouteille de synaptizine"
	desc = "Une petite bouteille de synpatizine."
	list_reagents = list(/datum/reagent/medicine/synaptizine = 30)

/obj/item/reagent_containers/cup/bottle/ammonia
	name = "Bouteille d'ammoniac"
	desc = "Une petite bouteille d'ammoniac."
	list_reagents = list(/datum/reagent/ammonia = 30)

/obj/item/reagent_containers/cup/bottle/diethylamine
	name = "Bouteille de diéthylamine"
	desc = "Une petite bouteille de diéthylamine."
	list_reagents = list(/datum/reagent/diethylamine = 30)

/obj/item/reagent_containers/cup/bottle/facid
	name = "Bouteille d'acide fluorosulfurique"
	desc = "Une petite bouteille. Contient une petite quantité d'acide fluorosulfurique."
	list_reagents = list(/datum/reagent/toxin/acid/fluacid = 30)

/obj/item/reagent_containers/cup/bottle/adminordrazine
	name = "Bouteille d'adminordrazine"
	desc = "Une petite bouteille. Contient le liquide des dieux."
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "holyflask"
	inhand_icon_state = "holyflask"
	list_reagents = list(/datum/reagent/medicine/adminordrazine = 30)

/obj/item/reagent_containers/cup/bottle/capsaicin
	name = "Bouteille de capsaicin"
	desc = "Une petite bouteille. Contient de la sauce piquante."
	list_reagents = list(/datum/reagent/consumable/capsaicin = 30)

/obj/item/reagent_containers/cup/bottle/frostoil
	name = "Bouteille d'huile de gèle"
	desc = "Une petite bouteille. Contient de la sauce froide."
	list_reagents = list(/datum/reagent/consumable/frostoil = 30)

/obj/item/reagent_containers/cup/bottle/traitor
	name = "Bouteille du syndicat"
	desc = "Une petite bouteille. Contient un produit chimiques toxique aléatoire."
	icon = 'icons/obj/medical/chemical.dmi'
	var/extra_reagent = null

/obj/item/reagent_containers/cup/bottle/traitor/Initialize(mapload)
	. = ..()
	extra_reagent = pick(/datum/reagent/toxin/polonium, /datum/reagent/toxin/histamine, /datum/reagent/toxin/formaldehyde, /datum/reagent/toxin/venom, /datum/reagent/toxin/fentanyl, /datum/reagent/toxin/cyanide)
	reagents.add_reagent(extra_reagent, 3)

/obj/item/reagent_containers/cup/bottle/polonium
	name = "Bouteille de polonium"
	desc = "Une petite bouteille. Contient du polonium."
	list_reagents = list(/datum/reagent/toxin/polonium = 30)

/obj/item/reagent_containers/cup/bottle/magillitis
	name = "Bouteille de magillitis"
	desc = "Une petite bouteille. Contient un sérum connu uniquement sous le nom de \"magillitis\""
	list_reagents = list(/datum/reagent/magillitis = 5)

/obj/item/reagent_containers/cup/bottle/venom
	name = "Bouteille de venin"
	desc = "Une petite bouteille. Contient de venin."
	list_reagents = list(/datum/reagent/toxin/venom = 30)

/obj/item/reagent_containers/cup/bottle/fentanyl
	name = "Bouteille fentanyl"
	desc = "Une petite bouteille. Contient du Fentanyl."
	list_reagents = list(/datum/reagent/toxin/fentanyl = 30)

/obj/item/reagent_containers/cup/bottle/formaldehyde
	name = "Bouteille de formaldehyde"
	desc = "Une petite bouteille. Contient du formaldehyde, un produit chimique qui empêche le pourrissement des organes."
	list_reagents = list(/datum/reagent/toxin/formaldehyde = 30)

/obj/item/reagent_containers/cup/bottle/initropidril
	name = "Bouteille d'initropidril"
	desc = "Une petite bouteille. Contient du initropidril."
	list_reagents = list(/datum/reagent/toxin/initropidril = 30)

/obj/item/reagent_containers/cup/bottle/pancuronium
	name = "Bouteille de pancuronium"
	desc = "Une petite bouteille. Contient du pancurioum."
	list_reagents = list(/datum/reagent/toxin/pancuronium = 30)

/obj/item/reagent_containers/cup/bottle/sodium_thiopental
	name = "Bouteille de sodium de thiopental"
	desc = "Une petite bouteille. Contient du sodium de thiopental."
	list_reagents = list(/datum/reagent/toxin/sodium_thiopental = 30)

/obj/item/reagent_containers/cup/bottle/coniine
	name = "Bouteille de coniine"
	desc = "Une petite bouteille. Contient de la coniine."
	list_reagents = list(/datum/reagent/toxin/coniine = 30)

/obj/item/reagent_containers/cup/bottle/curare
	name = "Bouteille de curare"
	desc = "Une petite bouteille. Contient du curare."
	list_reagents = list(/datum/reagent/toxin/curare = 30)

/obj/item/reagent_containers/cup/bottle/amanitin
	name = "Bouteille d'amanitin"
	desc = "Une petite bouteille. Contient de l'amanitin."
	list_reagents = list(/datum/reagent/toxin/amanitin = 30)

/obj/item/reagent_containers/cup/bottle/histamine
	name = "Bouteille d'histamine"
	desc = "Une petite bouteille. Contient de l'histamine."
	list_reagents = list(/datum/reagent/toxin/histamine = 30)

/obj/item/reagent_containers/cup/bottle/diphenhydramine
	name = "Bouteille d'antihistamine"
	desc = "Une petite bouteille de diphenhydramine."
	list_reagents = list(/datum/reagent/medicine/diphenhydramine = 30)

/obj/item/reagent_containers/cup/bottle/potass_iodide
	name = "Bouteille anti-radiation"
	desc = "Une petite bouteille de potassium d'iode."
	list_reagents = list(/datum/reagent/medicine/potass_iodide = 30)

/obj/item/reagent_containers/cup/bottle/salglu_solution
	name = "Bouteille de solution saline-glucose"
	desc = "Une petite bouteille de solution saline-glucose."
	list_reagents = list(/datum/reagent/medicine/salglu_solution = 30)

/obj/item/reagent_containers/cup/bottle/atropine
	name = "Bouteille d'atropine"
	desc = "Une petite bouteille d'atropine."
	list_reagents = list(/datum/reagent/medicine/atropine = 30)

/obj/item/reagent_containers/cup/bottle/random_buffer
	name = "Bouteille basique/acide"
	desc = "Une petite bouteille contenant une solution acide ou basique."

/obj/item/reagent_containers/cup/bottle/random_buffer/Initialize(mapload)
	. = ..()
	if(prob(50))
		name = "Bouteille de solution acide"
		desc = "Une petite bouteille contenant une solution acide."
		reagents.add_reagent(/datum/reagent/reaction_agent/acidic_buffer, 30)
	else
		name = "Bouteille de solution basique"
		desc = "Une petite bouteille contenant une solution basique."
		reagents.add_reagent(/datum/reagent/reaction_agent/basic_buffer, 30)

/obj/item/reagent_containers/cup/bottle/acidic_buffer
	name = "Bouteille de solution acide"
	desc = "Une petite bouteille contenant une solution acide."
	list_reagents = list(/datum/reagent/reaction_agent/acidic_buffer = 30)

/obj/item/reagent_containers/cup/bottle/basic_buffer
	name = "Bouteille de solution basique"
	desc = "Une petite bouteille contenant une solution basique."
	list_reagents = list(/datum/reagent/reaction_agent/basic_buffer = 30)

/obj/item/reagent_containers/cup/bottle/romerol
	name = "Bouteille de romerol"
	desc = "Une petite bouteille de romeral. La VRAIE poudre à zombie."
	list_reagents = list(/datum/reagent/romerol = 30)

/obj/item/reagent_containers/cup/bottle/random_virus
	name = "Bouteille de culture pour virus experimental"
	desc = "Une petite bouteille. Contient une culture virale non-testé."
	spawned_disease = /datum/disease/advance/random

/obj/item/reagent_containers/cup/bottle/pierrot_throat
	name = "Bouteille de culture pour virus \"Gorge de Pierrot\""
	desc = "Une petite bouteille. Contient une culture du virus HONI<42."
	spawned_disease = /datum/disease/pierrot_throat

/obj/item/reagent_containers/cup/bottle/cold
	name = "Bouteille de culture pour Rhinovirus"
	desc = "Une petite bouteille. Contient une culture du virus XY-rhinovirus."
	spawned_disease = /datum/disease/advance/cold

/obj/item/reagent_containers/cup/bottle/flu_virion
	name = "Bouteille de culture pour grippe virion"
	desc = "Une petite bouteille. Contient une culture du virus de la grippe virion."
	spawned_disease = /datum/disease/advance/flu

/obj/item/reagent_containers/cup/bottle/retrovirus
	name = "Bouteille de culture pour retrovirus"
	desc = "Une petite bouteille. Contient une culture d'une retrovirus."
	spawned_disease = /datum/disease/dna_retrovirus

/obj/item/reagent_containers/cup/bottle/gbs
	name = "Bouteille de culture GBS"
	desc = "Une petite bouteille. Contient une culture de virus Gravitokinectique Bipotentiel de type SADS+." //Or simply - General BullShit
	amount_per_transfer_from_this = 5
	spawned_disease = /datum/disease/gbs

/obj/item/reagent_containers/cup/bottle/fake_gbs
	name = "Bouteille de culture GBS"
	desc = "Une petite bouteille. Contient une culture de virus Gravitokinectique Bipotentiel de type SADS-."//Or simply - General BullShit
	spawned_disease = /datum/disease/fake_gbs

/obj/item/reagent_containers/cup/bottle/brainrot
	name = "Bouteille de culture de pourriture du cerveau"
	desc = "Une petite bouteille. Contient une culture de Cryptococcus Cosmosis."
	icon_state = "bottle3"
	spawned_disease = /datum/disease/brainrot

/obj/item/reagent_containers/cup/bottle/magnitis
	name = "Bouteille de culture de Magnitis"
	desc = "Une petite bouteille. Contient un petit dosage de Fukkos Miracos."
	spawned_disease = /datum/disease/magnitis

/obj/item/reagent_containers/cup/bottle/wizarditis
	name = "Bouteille de culture de wizarditis"
	desc = "Une petite bouteille. Contient un échantillon de Rincewindus Vulgaris."
	spawned_disease = /datum/disease/wizarditis

/obj/item/reagent_containers/cup/bottle/anxiety
	name = "Bouteille d'anxiétée sévère"
	desc = "Une petite bouteille. Contient un échantillon de Lepidopticides."
	spawned_disease = /datum/disease/anxiety

/obj/item/reagent_containers/cup/bottle/beesease
	name = "Bouteille de culture d'Abeilladie"
	desc = "Une petite bouteille. Contient un échantillon d'Apidae."
	spawned_disease = /datum/disease/beesease

/obj/item/reagent_containers/cup/bottle/fluspanish
	name = "Bouteille de culture de grippe espagnole"
	desc = "Une petite bouteille. Contient un échantillon d'Inquisitus."
	spawned_disease = /datum/disease/fluspanish

/obj/item/reagent_containers/cup/bottle/tuberculosis
	name = "Bouteille de culture de tuberculose fongique"
	desc = "Une petite bouteille. Contient un échantillon de Tubercule Fongique bacillus."
	spawned_disease = /datum/disease/tuberculosis

/obj/item/reagent_containers/cup/bottle/tuberculosiscure
	name = "Bouteille de KAVPV" //Kit Anti-Viral Pour Virus
	desc = "Une petite bouteille contenant du Kit Anti-Viral Pour Virus."
	list_reagents = list(/datum/reagent/vaccine/fungal_tb = 30)

//Oldstation.dmm chemical storage bottles
//Pas de trad vu qu'on touche jamais à Oldstation
/obj/item/reagent_containers/cup/bottle/hydrogen
	name = "hydrogen bottle"
	list_reagents = list(/datum/reagent/hydrogen = 30)

/obj/item/reagent_containers/cup/bottle/lithium
	name = "lithium bottle"
	list_reagents = list(/datum/reagent/lithium = 30)

/obj/item/reagent_containers/cup/bottle/carbon
	name = "carbon bottle"
	list_reagents = list(/datum/reagent/carbon = 30)

/obj/item/reagent_containers/cup/bottle/nitrogen
	name = "nitrogen bottle"
	list_reagents = list(/datum/reagent/nitrogen = 30)

/obj/item/reagent_containers/cup/bottle/oxygen
	name = "oxygen bottle"
	list_reagents = list(/datum/reagent/oxygen = 30)

/obj/item/reagent_containers/cup/bottle/fluorine
	name = "fluorine bottle"
	list_reagents = list(/datum/reagent/fluorine = 30)

/obj/item/reagent_containers/cup/bottle/sodium
	name = "sodium bottle"
	list_reagents = list(/datum/reagent/sodium = 30)

/obj/item/reagent_containers/cup/bottle/aluminium
	name = "aluminium bottle"
	list_reagents = list(/datum/reagent/aluminium = 30)

/obj/item/reagent_containers/cup/bottle/silicon
	name = "silicon bottle"
	list_reagents = list(/datum/reagent/silicon = 30)

/obj/item/reagent_containers/cup/bottle/phosphorus
	name = "phosphorus bottle"
	list_reagents = list(/datum/reagent/phosphorus = 30)

/obj/item/reagent_containers/cup/bottle/sulfur
	name = "sulfur bottle"
	list_reagents = list(/datum/reagent/sulfur = 30)

/obj/item/reagent_containers/cup/bottle/chlorine
	name = "chlorine bottle"
	list_reagents = list(/datum/reagent/chlorine = 30)

/obj/item/reagent_containers/cup/bottle/potassium
	name = "potassium bottle"
	list_reagents = list(/datum/reagent/potassium = 30)

/obj/item/reagent_containers/cup/bottle/iron
	name = "iron bottle"
	list_reagents = list(/datum/reagent/iron = 30)

/obj/item/reagent_containers/cup/bottle/copper
	name = "copper bottle"
	list_reagents = list(/datum/reagent/copper = 30)

/obj/item/reagent_containers/cup/bottle/mercury
	name = "mercury bottle"
	list_reagents = list(/datum/reagent/mercury = 30)

/obj/item/reagent_containers/cup/bottle/radium
	name = "radium bottle"
	list_reagents = list(/datum/reagent/uranium/radium = 30)

/obj/item/reagent_containers/cup/bottle/water
	name = "water bottle"
	list_reagents = list(/datum/reagent/water = 30)

/obj/item/reagent_containers/cup/bottle/ethanol
	name = "ethanol bottle"
	list_reagents = list(/datum/reagent/consumable/ethanol = 30)

/obj/item/reagent_containers/cup/bottle/sugar
	name = "sugar bottle"
	list_reagents = list(/datum/reagent/consumable/sugar = 30)

/obj/item/reagent_containers/cup/bottle/sacid
	name = "sulfuric acid bottle"
	list_reagents = list(/datum/reagent/toxin/acid = 30)

/obj/item/reagent_containers/cup/bottle/welding_fuel
	name = "welding fuel bottle"
	list_reagents = list(/datum/reagent/fuel = 30)

/obj/item/reagent_containers/cup/bottle/silver
	name = "silver bottle"
	list_reagents = list(/datum/reagent/silver = 30)

/obj/item/reagent_containers/cup/bottle/iodine
	name = "iodine bottle"
	list_reagents = list(/datum/reagent/iodine = 30)

/obj/item/reagent_containers/cup/bottle/bromine
	name = "bromine bottle"
	list_reagents = list(/datum/reagent/bromine = 30)

/obj/item/reagent_containers/cup/bottle/thermite
	name = "thermite bottle"
	list_reagents = list(/datum/reagent/thermite = 30)

// Bottles for mail goodies.

/obj/item/reagent_containers/cup/bottle/clownstears
	name = "Bouteille de misère de clown distillée"
	desc = "Une petite bouteille. Contient un liquide mythique utilisé par les barmans les plus sublimes. Ce merveilleux liquide est fait à base de larmes de clowns."
	list_reagents = list(/datum/reagent/consumable/nutriment/soup/clown_tears = 30)

/obj/item/reagent_containers/cup/bottle/saltpetre
	name = "Bouteille de salpêtre"
	desc = "Une petite bouteille. Contient de la salpêtre."
	list_reagents = list(/datum/reagent/saltpetre = 30)

/obj/item/reagent_containers/cup/bottle/flash_powder
	name = "Bouteille de poudre aveuglante"
	desc = "Une petite bouteille. Contient de la poudre aveuglante."
	list_reagents = list(/datum/reagent/flash_powder = 30)

/obj/item/reagent_containers/cup/bottle/exotic_stabilizer
	name = "Bouteille de stabilisant exotique"
	desc = "Une petite bouteille. Contient du stabilisant exotique."
	list_reagents = list(/datum/reagent/exotic_stabilizer = 30)

/obj/item/reagent_containers/cup/bottle/leadacetate
	name = "Bouteille d'acétate de plomb"
	desc = "Une petite bouteille. Contient de l'acétate de plomb."
	list_reagents = list(/datum/reagent/toxin/leadacetate = 30)

/obj/item/reagent_containers/cup/bottle/caramel
	name = "Bouteille caramel"
	desc = "Une bouteille contenant du sucre caramélisé, aussi connu sous le nom de caramel. Ne pas lécher."
	list_reagents = list(/datum/reagent/consumable/caramel = 30)

/*
 *	Syrup bottles, basically a unspillable cup that transfers reagents upon clicking on it with a cup
 */

/obj/item/reagent_containers/cup/bottle/syrup_bottle
	name = "Bouteille de sirop"
	desc = "Une bouteille avec une pompe à sirop pour verser cette délicieuse substance directement dans votre café."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "syrup"
	fill_icon_state = "syrup"
	fill_icon_thresholds = list(0, 20, 40, 60, 80, 100)
	possible_transfer_amounts = list(5, 10)
	volume = 50
	amount_per_transfer_from_this = 5
	spillable = FALSE
	///variable to tell if the bottle can be refilled
	var/cap_on = TRUE

/obj/item/reagent_containers/cup/bottle/syrup_bottle/examine(mob/user)
	. = ..()
	. += span_notice("Alt + clique pour activer la pompe.")
	. += span_notice("Utiliser un stylo pour la renommer.")
	return

//when you attack the syrup bottle with a container it refills it
/obj/item/reagent_containers/cup/bottle/syrup_bottle/attackby(obj/item/attacking_item, mob/user, params)

	if(!cap_on)
		return ..()

	if(!check_allowed_items(attacking_item,target_self = TRUE))
		return

	if(attacking_item.is_refillable())
		if(!reagents.total_volume)
			balloon_alert(user, "La bouteille est vide !")
			return TRUE

		if(attacking_item.reagents.holder_full())
			balloon_alert(user, "Le contenant est vide !")
			return TRUE

		var/transfer_amount = reagents.trans_to(attacking_item, amount_per_transfer_from_this, transfered_by = user)
		balloon_alert(user, "Vous avez transféré [transfer_amount] unitées\s")
		flick("syrup_anim",src)

	if(istype(attacking_item, /obj/item/pen))
		rename(user, attacking_item)

	attacking_item.update_appearance()
	update_appearance()

	return TRUE

/obj/item/reagent_containers/cup/bottle/syrup_bottle/AltClick(mob/user)
	cap_on = !cap_on
	if(!cap_on)
		icon_state = "syrup_open"
		balloon_alert(user, "Vous avez retiré le bouchon de la pompe")
	else
		icon_state = "syrup"
		balloon_alert(user, "Vous avez mis le bouchon de la pompe")
	update_icon_state()
	return ..()

/obj/item/reagent_containers/cup/bottle/syrup_bottle/proc/rename(mob/user, obj/item/writing_instrument)
	if(!user.can_write(writing_instrument))
		return

	var/inputvalue = tgui_input_text(user, "Voudriez vous renommer la bouteille à sirop ?", "Nommage de bouteille de sirop", max_length = MAX_NAME_LEN)

	if(!inputvalue)
		return

	if(user.can_perform_action(src))
		name = "[(inputvalue ? "[inputvalue]" : null)] bouteille"

//types of syrups

/obj/item/reagent_containers/cup/bottle/syrup_bottle/caramel
	name = "Bouteille de sirop au caramel"
	desc = "Une bouteille avec pompe contenant du sucre caramélisé, aussi connu sous le nom de caramel. Ne pas lécher."
	list_reagents = list(/datum/reagent/consumable/caramel = 50)

/obj/item/reagent_containers/cup/bottle/syrup_bottle/liqueur
	name = "Bouteille de sirop à la liqueur de café"
	desc = "Une bouteille avec pompe contenant de liqueur au café mexicaine. En production depuis 1936, POUETTE."
	list_reagents = list(/datum/reagent/consumable/ethanol/kahlua = 50)

/obj/item/reagent_containers/cup/bottle/syrup_bottle/korta_nectar
	name = "Bouteille de sirop de korta"
	desc = "Une bouteille avec pompe contenant du sirop de korta. Une substance sucré faite avec des noix de korta écrasées."
	list_reagents = list(/datum/reagent/consumable/korta_nectar = 50)

//secret syrup
/obj/item/reagent_containers/cup/bottle/syrup_bottle/laughsyrup
	name = "Bouteille de sirop de rire"
	desc = "Une bouteille avec pompe contenant du sirop de rire."
	list_reagents = list(/datum/reagent/consumable/laughsyrup = 50)
