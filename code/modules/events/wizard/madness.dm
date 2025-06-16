/datum/round_event_control/wizard/madness
	name = "Malédiction de la folie"
	weight = 1
	typepath = /datum/round_event/wizard/madness
	earliest_start = 0 MINUTES
	description = "Révèle une terrible vérité à tout le monde, leur donnant un traumatisme."
	admin_setup = list(/datum/event_admin_setup/text_input/madness)

/datum/round_event/wizard/madness
	/// the horrifying truth sent to the crew, can be picked by admins.
	var/horrifying_truth

/datum/round_event/wizard/madness/start()
	if(!horrifying_truth)
		horrifying_truth = pick(strings(REDPILL_FILE, "redpill_questions"))

	curse_of_madness(null, horrifying_truth)

/datum/event_admin_setup/text_input/madness
	input_text = "QUelle terrible vérité allez vous révéler ?"

/datum/event_admin_setup/text_input/madness/get_text_suggestion()
	return pick(strings(REDPILL_FILE, "redpill_questions"))

/datum/event_admin_setup/text_input/madness/apply_to_event(datum/round_event/wizard/madness/event)
	event.horrifying_truth = chosen
