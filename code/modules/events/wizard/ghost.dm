/datum/round_event_control/wizard/ghost //The spook is real
	name = "F-F-Fantômes !"
	weight = 3
	typepath = /datum/round_event/wizard/ghost
	max_occurrences = 1
	earliest_start = 0 MINUTES
	description = "Les fantômes deviennent visibles."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 7

/datum/round_event/wizard/ghost/start()
	var/msg = span_warning("Vous vous sentez soudainement extrêmement visible...")
	set_observer_default_invisibility(0, msg)


//--//

/datum/round_event_control/wizard/possession //Oh shit
	name = "F-F-Fantômes (possessifs) !" //French's edit : Oui c'est pas une super traduction mais va traduire "possessing" aussi !
	weight = 2
	typepath = /datum/round_event/wizard/possession
	max_occurrences = 5
	earliest_start = 0 MINUTES
	description = "Les fantômes deviennent visibles et gagnent le pouvoir de possession."

/datum/round_event/wizard/possession/start()
	for(var/mob/dead/observer/G in GLOB.player_list)
		add_verb(G, /mob/dead/observer/verb/boo)
		add_verb(G, /mob/dead/observer/verb/possess)
		to_chat(G, "Vous vous sentez soudainement extrêmement visible, en même temps que gagné.e d'un nouveau pouvoir...")
