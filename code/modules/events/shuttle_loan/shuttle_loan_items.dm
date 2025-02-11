
/obj/item/storage/belt/fannypack/yellow/bee_terrorist/PopulateContents()
	new /obj/item/grenade/c4 (src)
	new /obj/item/reagent_containers/pill/cyanide(src)
	new /obj/item/grenade/chem_grenade/facid(src)

/obj/item/paper/fluff/bee_objectives
	name = "Objectifs d'un agent du Front de Libération des Abeilles"
	default_raw_text = "<b>Objectif #1</b>. Libérer toutes les abeilles du vaisseau de transport 2416/B de NT. <b>Objectif atteint !</b>  <br><b>Objectif #2</b>. S'échaper. <b>Objectif échoué.</b>"

/obj/machinery/syndicatebomb/shuttle_loan/Initialize(mapload)
	. = ..()
	set_anchored(TRUE)
	timer_set = rand(480, 600) //once the supply shuttle docks (after 5 minutes travel time), players have between 3-5 minutes to defuse the bomb
	activate()
	update_appearance()

/obj/item/paper/fluff/cargo/bomb
	name = "note manuscrite écrite hativement"
	default_raw_text = "BON COURAGE !"

/obj/item/paper/fluff/cargo/bomb/allyourbase
	default_raw_text = "Quelqu'un a mis en place nous la bombe !"
