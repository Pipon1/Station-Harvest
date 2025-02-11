/datum/mood_event/drunk
	mood_change = 3
	description = "Tout va mieux, après un verre ou deux."
	/// The blush overlay to display when the owner is drunk
	var/datum/bodypart_overlay/simple/emote/blush_overlay

/datum/mood_event/drunk/add_effects(param)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/human_owner = owner
	blush_overlay = human_owner.give_emote_overlay(/datum/bodypart_overlay/simple/emote/blush)

/datum/mood_event/drunk/remove_effects()
	QDEL_NULL(blush_overlay)

/datum/mood_event/quality_nice
	description = "Ce p'tit verre n'était pas mauvais du tout."
	mood_change = 2
	timeout = 7 MINUTES

/datum/mood_event/quality_good
	description = "Cette boisson était plutôt bonne."
	mood_change = 4
	timeout = 7 MINUTES

/datum/mood_event/quality_verygood
	description = "Cette boisson était très bonne !"
	mood_change = 6
	timeout = 7 MINUTES

/datum/mood_event/quality_fantastic
	description = "Cette boisson était incroyable !"
	mood_change = 8
	timeout = 7 MINUTES

/datum/mood_event/amazingtaste
	description = "Quel goût incroyable !"
	mood_change = 50
	timeout = 10 MINUTES
