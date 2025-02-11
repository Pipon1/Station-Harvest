/datum/round_event_control/mice_migration
	name = "Migration de souris"
	typepath = /datum/round_event/mice_migration
	weight = 10
	category = EVENT_CATEGORY_ENTITIES
	description = "Une horde de souris arrive dans les maintenances, parfois même le roi des rats lui même."

/datum/round_event/mice_migration
	var/minimum_mice = 5
	var/maximum_mice = 15

/datum/round_event/mice_migration/announce(fake)
	var/cause = pick("de l'hiver stellaire", "de coupures de budget", "du Ragnarok",
		"du refroidissement de l'univers", "de \[SUPPRIMÉ\]", "du réchauffement climatique",
		"d'un manque de chance")
	var/plural = pick("un certain nombre de", "une horde de", "un pack de", "une vague de",
		"une troupe de", "pas plus de [maximum_mice]")
	var/name = pick("rongeurs", "souris", "trucs qui font squeak squeak",
		"mammifères mangeurs de cable", "\[SUPPRIMÉ\]", "parasites draineurs d'énergie")
	var/movement = pick("ont migrés", "ont déferlés", "ont fui", "se sont rués")
	var/location = pick("les conduits de maintenance", "les maintenances",
		"\[SUPPRIMÉ\]", "des endroits avec pleins de cables appétissants")

	priority_announce("À cause [cause], [plural] [name] [movement] \
		vers [location].", "Alerte migration",
		'sound/effects/mousesqueek.ogg')

/datum/round_event/mice_migration/start()
	SSminor_mapping.trigger_migration(rand(minimum_mice, maximum_mice))
