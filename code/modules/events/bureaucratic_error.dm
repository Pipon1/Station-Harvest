/datum/round_event_control/bureaucratic_error
	name = "Erreur bureaucratique"
	typepath = /datum/round_event/bureaucratic_error
	max_occurrences = 1
	weight = 5
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "Ouvre et ferme des postes, en plus de changer le travail par défault (celui selectionné quand tous es roles sont déjà rempli)."

/datum/round_event/bureaucratic_error
	announce_when = 1

/datum/round_event/bureaucratic_error/announce(fake)
	priority_announce("Une récente erreur bureaucratique du Département des Ressources Organiques a pu résulté en une pénurie de personnel dans certains départements et un surplus dans d'autres.", "Alerte cafouillage de paperasse")

/datum/round_event/bureaucratic_error/start()
	var/list/jobs = SSjob.joinable_occupations.Copy()
	if(prob(33)) // Only allows latejoining as a single role. Add latejoin AI bluespace pods for fun later.
		var/datum/job/overflow = pick_n_take(jobs)
		overflow.spawn_positions = -1
		overflow.total_positions = -1 // Ensures infinite slots as this role. Assistant will still be open for those that cant play it.
		for(var/job in jobs)
			var/datum/job/current = job
			if(!current.allow_bureaucratic_error)
				continue
			current.total_positions = 0
	else // Adds/removes a random amount of job slots from all jobs.
		for(var/datum/job/current as anything in jobs)
			if(!current.allow_bureaucratic_error)
				continue
			var/ran = rand(-2,4)
			current.total_positions = max(current.total_positions + ran, 0)
