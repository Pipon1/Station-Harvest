/datum/round_event_control/fake_virus
	name = "Faux virus"
	typepath = /datum/round_event/fake_virus
	weight = 20
	category = EVENT_CATEGORY_HEALTH
	description = "Quelques membres de l'équipage vont souffrir d'une hypochondrie temporaire."

/datum/round_event/fake_virus/start()
	var/list/fake_virus_victims = list()
	for(var/mob/living/carbon/human/victim in shuffle(GLOB.player_list))
		if(victim.stat == DEAD || HAS_TRAIT(victim, TRAIT_CRITICAL_CONDITION) || !(victim.mind.assigned_role.job_flags & JOB_CREW_MEMBER))
			continue
		fake_virus_victims += victim

	//first we do hard status effect victims
	var/defacto_min = min(3, LAZYLEN(fake_virus_victims))
	if(defacto_min)// event will hit 1-3 people by default, but will do 1-2 or just 1 if only those many candidates are available
		for(var/i in 1 to rand(1,defacto_min))
			var/mob/living/carbon/human/hypochondriac = pick(fake_virus_victims)
			hypochondriac.apply_status_effect(/datum/status_effect/fake_virus)
			fake_virus_victims -= hypochondriac
			announce_to_ghosts(hypochondriac)

	//then we do light one-message victims who simply cough or whatever once (have to repeat the process since the last operation modified our candidates list)
	defacto_min = min(5, LAZYLEN(fake_virus_victims))
	if(defacto_min)
		for(var/i in 1 to rand(1,defacto_min))
			var/mob/living/carbon/human/onecoughman = pick(fake_virus_victims)
			if(prob(25))//1/4 odds to get a spooky message instead of coughing out loud
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), onecoughman, span_warning("[pick("Votre tête vous élance.", "Vous avez mal à la tête.")]")), rand(30,150))
			else
				addtimer(CALLBACK(onecoughman, TYPE_PROC_REF(/mob, emote), pick("tousse", "renifle", "éternue")), rand(30,150))//deliver the message with a slightly randomized time interval so there arent multiple people coughing at the exact same time
			fake_virus_victims -= onecoughman
