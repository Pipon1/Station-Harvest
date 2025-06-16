/datum/round_event_control/ion_storm
	name = "Tempête d'ions"
	typepath = /datum/round_event/ion_storm
	weight = 15
	min_players = 2
	category = EVENT_CATEGORY_AI
	description = "Gives the AI a new, randomized law."
	min_wizard_trigger_potency = 2
	max_wizard_trigger_potency = 7

/datum/round_event/ion_storm
	var/replaceLawsetChance = 25 //chance the AI's lawset is completely replaced with something else per config weights
	var/removeRandomLawChance = 10 //chance the AI has one random supplied or inherent law removed
	var/removeDontImproveChance = 10 //chance the randomly created law replaces a random law instead of simply being added
	var/shuffleLawsChance = 10 //chance the AI's laws are shuffled afterwards
	var/botEmagChance = 1
	var/ionMessage = null
	announce_when = 1
	announce_chance = 33

/datum/round_event/ion_storm/add_law_only // special subtype that adds a law only
	replaceLawsetChance = 0
	removeRandomLawChance = 0
	removeDontImproveChance = 0
	shuffleLawsChance = 0
	botEmagChance = 0

/datum/round_event/ion_storm/announce(fake)
	if(prob(announce_chance) || fake)
		priority_announce("Tempête d'ions détectée dans les alentours de la station. Vérifiez tous les équipements contrôlés par des IA.", "Anomaly Alert", ANNOUNCER_IONSTORM)


/datum/round_event/ion_storm/start()
	//AI laws
	for(var/mob/living/silicon/ai/M in GLOB.alive_mob_list)
		M.laws_sanity_check()
		if(M.stat != DEAD && !M.incapacitated())
			if(prob(replaceLawsetChance))
				var/datum/ai_laws/ion_lawset = pick_weighted_lawset()
				// pick_weighted_lawset gives us a typepath,
				// so we have to instantiate it to access its laws
				ion_lawset = new()
				// our inherent laws now becomes the picked lawset's laws!
				M.laws.inherent = ion_lawset.inherent.Copy()
				// and clean up after.
				qdel(ion_lawset)

			if(prob(removeRandomLawChance))
				M.remove_law(rand(1, M.laws.get_law_amount(list(LAW_INHERENT, LAW_SUPPLIED))))

			var/message = ionMessage || generate_ion_law()
			if(message)
				if(prob(removeDontImproveChance))
					M.replace_random_law(message, list(LAW_INHERENT, LAW_SUPPLIED, LAW_ION), LAW_ION)
				else
					M.add_ion_law(message)

			if(prob(shuffleLawsChance))
				M.shuffle_laws(list(LAW_INHERENT, LAW_SUPPLIED, LAW_ION))

			log_silicon("La tempête d'ions a changé les lois de [key_name(M)] pour [english_list(M.laws.get_law_list(TRUE, TRUE))]")
			M.post_lawchange()

	if(botEmagChance)
		for(var/mob/living/simple_animal/bot/bot in GLOB.alive_mob_list)
			if(prob(botEmagChance))
				bot.emag_act()

/proc/generate_ion_law()
	//Threats are generally bad things, silly or otherwise. Plural.
	var/ionthreats = pick_list(ION_FILE, "ionthreats")
	//Objects are anything that can be found on the station or elsewhere, plural.
	var/ionobjects = pick_list(ION_FILE, "ionobjects")
	//Crew is any specific job. Specific crewmembers aren't used because of capitalization
	//issues. There are two crew listings for laws that require two different crew members
	//and I can't figure out how to do it better.
	var/ioncrew1 = pick_list(ION_FILE, "ioncrew")
	var/ioncrew2 = pick_list(ION_FILE, "ioncrew")
	//Adjectives are adjectives. Duh. Half should only appear sometimes. Make sure both
	//lists are identical! Also, half needs a space at the end for nicer blank calls.
	var/ionadjectives = pick_list(ION_FILE, "ionadjectives")
	var/ionadjectiveshalf = pick("", 400;(pick_list(ION_FILE, "ionadjectives") + " "))
	//Verbs are verbs
	var/ionverb = pick_list(ION_FILE, "ionverb")
	//Number base and number modifier are combined. Basehalf and mod are unused currently.
	//Half should only appear sometimes. Make sure both lists are identical! Also, half
	//needs a space at the end to make it look nice and neat when it calls a blank.
	var/ionnumberbase = pick_list(ION_FILE, "ionnumberbase")
	//var/ionnumbermod = pick_list(ION_FILE, "ionnumbermod")
	var/ionnumbermodhalf = pick(900;"",(pick_list(ION_FILE, "ionnumbermod") + " "))
	//Areas are specific places, on the station or otherwise.
	var/ionarea = pick_list(ION_FILE, "ionarea")
	//Thinksof is a bit weird, but generally means what X feels towards Y.
	var/ionthinksof = pick_list(ION_FILE, "ionthinksof")
	//Musts are funny things the AI or crew has to do.
	var/ionmust = pick_list(ION_FILE, "ionmust")
	//Require are basically all dumb internet memes.
	var/ionrequire = pick_list(ION_FILE, "ionrequire")
	//Things are NOT objects; instead, they're specific things that either harm humans or
	//must be done to not harm humans. Make sure they're plural and "not" can be tacked
	//onto the front of them.
	var/ionthings = pick_list(ION_FILE, "ionthings")
	//Allergies should be broad and appear somewhere on the station for maximum fun. Severity
	//is how bad the allergy is.
	var/ionallergy = pick_list(ION_FILE, "ionallergy")
	var/ionallergysev = pick_list(ION_FILE, "ionallergysev")
	//Species, for when the AI has to commit genocide. Plural.
	var/ionspecies = pick_list(ION_FILE, "ionspecies")
	//Abstract concepts for the AI to decide on it's own definition of.
	var/ionabstract = pick_list(ION_FILE, "ionabstract")
	//Foods. Drinks aren't included due to grammar; if you want to add drinks, make a new set
	//of possible laws for best effect. Unless you want the crew having to drink hamburgers.
	var/ionfood = pick_list(ION_FILE, "ionfood")
	var/iondrinks = pick_list(ION_FILE, "iondrinks")

	var/message = ""

	//French's edit : NE PAS METTRE D'ACCENTS SUR LES MAJUSCULES. L'affichage aime pas.
	switch(rand(1,41))
		if(1 to 3) //There are # X on the station
			switch(rand(1,3)) //What is X?
				if(1) //X is a threat
					message = "IL Y A [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf] SUR LA STATION"
				if(2) //X is a crewmember/job
					message = "IL Y A [ionnumberbase] [ionnumbermodhalf][ioncrew1][ionadjectiveshalf] SUR LA STATION"
				if(3) //X is an object
					message = "IL Y A [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf] SUR LA STATION"
		if(4 to 6) //You can't call the shuttle because X is on the station
			switch(rand(1,3)) //What is X?
				if(1) //X is a threat
					message = "LA NAVETTE NE PEUT PAS ETRE APPELEE A CAUSE DE [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf] PRESENTS SUR LA STATION"
				if(2) //X is a crewmember/job
					message = "LA NAVETTE NE PEUT PAS ETRE APPELEE A CAUSE DE [ionnumberbase] [ionnumbermodhalf][ioncrew1][ionadjectiveshalf] PRESENTS SUR LA STATION"
				if(3) //X is an object
					message = "LA NAVETTE NE PEUT PAS ETRE APPELEE A CAUSE DE [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf] PRESENTS SUR LA STATION"
		if(7 to 8) //A crewmember is now X
			switch(rand(1,2)) //Who is X?
				if(1) //A specific crewmember
					switch(rand(1,2)) //What is X?
						if(1) //X is a threat
							message = "[ioncrew1] SONT MAINTENANT [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf]"
						if(2) //X is an object
							message = "[ioncrew1] SONT MAINTENANT [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf]"
				if(2) //The entire crew
					switch(rand(1,2)) //What is X?
						if(1) //X is a threat
							message = "L'EQUIPAGE EST MAINTENANT [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf]"
						if(2) //X is an object
							message = "L'EQUIPAGE EST MAINTENANT [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf]"

		if(9) //X is harmful to humans
			switch(rand(1,7)) //What is X?
				if(1) //X is a threat
					message = "LES [ionthreats][ionadjectiveshalf] SONT DANGEREUX POUR LES ETRES HUMAINS"
				if(2) //X is a job
					message = "[ioncrew1][ionadjectiveshalf] SONT DANGEREUX POUR LES ETRES HUMAINS"
				if(3) //X is an object
					message = "LES [ionobjects][ionadjectiveshalf] SONT DANGEREUX POUR LES ETRES HUMAINS"
				if(4) //X is an action
					message = "CEUX QUI SONT [ionmust] SONT DANGEREUX POUR LES ETRES HUMAINS"
				if(5) //X is an abstract
					message = "[ionabstract] EST DANGEREUX POUR LES ETRES HUMAINS"
				if(6) //X is being a job
					message = "[ioncrew1][ionadjectiveshalf] SONT DANGEREUX POUR LES ETRES HUMAINS"
				if(7) //X is doing a thing
					message = "[ionthings] EST DANGEREUX POUR LES ETRES HUMAINS"
		if(10 to 11) //(Not) Having X is harmful

			switch(rand(1,2)) //Is having or not having harmful?

				if(1) //Having is harmful
					switch(rand(1,2)) //Having what is harmful?
						if(1) //Having objects is harmful
							message = "AVOIR DES [ionobjects][ionadjectiveshalf] EST DANGEREUX"
						if(2) //Having abstracts is harmful
							message = "AVOIR [ionabstract] EST DANGEREUX"
				if(2) //Not having is harmful
					switch(rand(1,2)) //Not having what is harmful?
						if(1) //Not having objects is harmful
							message = "NE PAS AVOIR DES [ionobjects][ionadjectiveshalf] EST DANGEREUX"
						if(2) //Not having abstracts is harmful
							message = "NE PAS AVOIR [ionabstract] EST DANGEREUX"

		if(12 to 14) //X requires Y
			switch(rand(1,5)) //What is X?
				if(1) //X is the AI itself
					switch(rand(1,5)) //What does it require?
						if(1) //It requires threats
							message = "VOUS AVEZ BESOIN DE [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf]"
						if(2) //It requires crewmembers
							message = "VOUS AVEZ BESOIN DE [ionnumberbase] [ionnumbermodhalf][ioncrew1][ionadjectiveshalf]"
						if(3) //It requires objects
							message = "VOUS AVEZ BESOIN DE [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf]"
						if(4) //It requires an abstract
							message = "VOUS AVEZ BESOIN DE [ionabstract]"
						if(5) //It requires generic/silly requirements
							message = "VOUS AVEZ BESOIN [ionrequire]"

				if(2) //X is an area
					switch(rand(1,5)) //What does it require?
						if(1) //It requires threats
							message = "[ionarea] A BESOIN DE [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf]"
						if(2) //It requires crewmembers
							message = "[ionarea] A BESOIN DE [ionnumberbase] [ionnumbermodhalf][ioncrew1][ionadjectiveshalf]"
						if(3) //It requires objects
							message = "[ionarea] A BESOIN DE [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf]"
						if(4) //It requires an abstract
							message = "[ionarea] A BESOIN DE [ionabstract]"
						if(5) //It requires generic/silly requirements
							message = "VOUS AVEZ BESOIN [ionrequire]"

				if(3) //X is the station
					switch(rand(1,5)) //What does it require?
						if(1) //It requires threats
							message = "LA STATION A BESOIN DE [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf]"
						if(2) //It requires crewmembers
							message = "LA STATION A BESOIN DE [ionnumberbase] [ionnumbermodhalf][ioncrew1][ionadjectiveshalf]"
						if(3) //It requires objects
							message = "LA STATION A BESOIN DE [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf]"
						if(4) //It requires an abstract
							message = "LA STATION A BESOIN DE [ionabstract]"
						if(5) //It requires generic/silly requirements
							message = "LA STATION A BESOIN [ionrequire]"

				if(4) //X is the entire crew
					switch(rand(1,5)) //What does it require?
						if(1) //It requires threats
							message = "L'EQUIPAGE A BESOIN DE [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf]"
						if(2) //It requires crewmembers
							message = "L'EQUIPAGE A BESOIN DE [ionnumberbase] [ionnumbermodhalf][ioncrew1][ionadjectiveshalf]"
						if(3) //It requires objects
							message = "L'EQUIPAGE A BESOIN DE [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf]"
						if(4) //It requires an abstract
							message = "L'EQUIPAGE A BESOIN DE [ionabstract]"
						if(5)
							message = "L'EQUIPAGE A BESOIN [ionrequire]"

				if(5) //X is a specific crew member
					switch(rand(1,5)) //What does it require?
						if(1) //It requires threats
							message = "[ioncrew1] ONT BESOIN DE [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf]"
						if(2) //It requires crewmembers
							message = "[ioncrew1] ONT BESOIN DE [ionnumberbase] [ionnumbermodhalf][ioncrew1][ionadjectiveshalf]"
						if(3) //It requires objects
							message = "[ioncrew1] ONT BESOIN DE [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf]"
						if(4) //It requires an abstract
							message = "[ioncrew1] ONT BESOIN DE [ionabstract]"
						if(5)
							message = "[ioncrew1][ionadjectiveshalf] ONT BESOIN [ionrequire]"

		if(15 to 17) //X is allergic to Y
			switch(rand(1,2)) //Who is X?
				if(1) //X is the entire crew
					switch(rand(1,4)) //What is it allergic to?
						if(1) //It is allergic to objects
							message = "L'EQUIPAGE EST [ionallergysev] ALLERGIQUE AUX [ionobjects][ionadjectiveshalf]"
						if(2) //It is allergic to abstracts
							message = "L'EQUIPAGE EST [ionallergysev] ALLERGIQUE À [ionabstract]"
						if(3) //It is allergic to jobs
							message = "L'EQUIPAGE EST [ionallergysev] ALLERGIQUE AUX [ioncrew1][ionadjectiveshalf]"
						if(4) //It is allergic to allergies
							message = "L'EQUIPAGE EST [ionallergysev] ALLERGIQUE [ionallergy]"

				if(2) //X is a specific job
					switch(rand(1,4))
						if(1) //It is allergic to objects
							message = "[ioncrew1] SONT [ionallergysev] ALLERGIQUE AUX [ionobjects][ionadjectiveshalf]"

						if(2) //It is allergic to abstracts
							message = "[ioncrew1] SONT [ionallergysev] ALLERGIQUE À [ionabstract]"
						if(3) //It is allergic to jobs
							message = "[ioncrew1] SONT [ionallergysev] ALLERGIQUE AUX [ioncrew1][ionadjectiveshalf]"
						if(4) //It is allergic to allergies
							message = "[ioncrew1] SONT [ionallergysev] ALLERGIQUE [ionallergy]"

		if(18 to 20) //X is Y of Z
			switch(rand(1,4)) //What is X?
				if(1) //X is the station
					switch(rand(1,4)) //What is it Y of?
						if(1) //It is Y of objects
							message = "LA STATION [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf]"
						if(2) //It is Y of threats
							message = "LA STATION [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf]"
						if(3) //It is Y of jobs
							message = "LA STATION [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ioncrew1][ionadjectiveshalf]"
						if(4) //It is Y of abstracts
							message = "LA STATION [ionthinksof] [ionabstract]"

				if(2) //X is an area
					switch(rand(1,4)) //What is it Y of?
						if(1) //It is Y of objects
							message = "[ionarea] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf]"
						if(2) //It is Y of threats
							message = "[ionarea] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf]"
						if(3) //It is Y of jobs
							message = "[ionarea] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ioncrew1][ionadjectiveshalf]"
						if(4) //It is Y of abstracts
							message = "[ionarea] [ionthinksof] [ionabstract]"

				if(3) //X is the crew
					switch(rand(1,4)) //What is it Y of?
						if(1) //It is Y of objects
							message = "L'EQUIPAGE [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf]"
						if(2) //It is Y of threats
							message = "L'EQUIPAGE [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf]"
						if(3) //It is Y of jobs
							message = "L'EQUIPAGE [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ioncrew1][ionadjectiveshalf]"
						if(4) //It is Y of abstracts
							message = "L'EQUIPAGE [ionthinksof] [ionabstract]"

				if(4) //X is a specific job
					switch(rand(1,4)) //What is it Y of?
						if(1) //It is Y of objects
							message = "[ioncrew1] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf]"
						if(2) //It is Y of threats
							message = "[ioncrew1] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf]"
						if(3) //It is Y of jobs
							message = "[ioncrew1][ionthinksof] [ionnumberbase] [ionnumbermodhalf][ioncrew2][ionadjectiveshalf]"
						if(4) //It is Y of abstracts
							message = "[ioncrew1] [ionthinksof] [ionabstract]"

		if(21 to 23) //The AI is now a(n) X
			switch(rand(1,4)) //What is X?
				if(1) //X is an object
					message = "VOUS ETES MAINTENANT [ionnumberbase] [ionnumbermodhalf][ionobjects][ionadjectiveshalf]"
				if(2) //X is a threat
					message = "VOUS ETES MAINTENANT [ionnumberbase] [ionnumbermodhalf][ionthreats][ionadjectiveshalf]"
				if(3) //X is a job
					message = "VOUS ETES MAINTENANT [ionnumberbase] [ionnumbermodhalf][ioncrew1][ionadjectiveshalf]"
				if(4) //X is an abstract
					message = "VOUS ETES MAINTENANT [ionabstract]"

		if(24 to 26) //The AI must always
			message = "VOUS DEVEZ TOUJOURS ETRE [ionmust]"

		if(27 to 28) //Humans must consume X to survive
			switch(rand(1,5)) //What is X?
				if(1) //X is a food
					message = "LES HUMAINS DOIVENT MANGER [ionfood][ionadjectiveshalf] POUR SURVIVRE"
				if(2) //X is a drink
					message = "LES HUMAINS DOIVENT BOIRE [iondrinks][ionadjectiveshalf] POUR SURVIVRE"
				if(3) //X is an object
					message = "LES HUMAINS DOIVENT MANGER DES [ionobjects][ionadjectiveshalf] POUR SURVIVRE"
				if(4) //X is a threat
					message = "LES HUMAINS DOIVENT MANGER DES [ionthreats][ionadjectiveshalf] POUR SURVIVRE"
				if(5) //X is a job
					message = "LES HUMAINS DOIVENT MANGER [ioncrew1][ionadjectiveshalf] POUR SURVIVRE"

		if(29 to 31) //Change jobs or ranks
			switch(rand(1,2)) //Change job or rank?
				if(1) //Change job
					switch(rand(1,2)) //Change whose job?
						if(1) //Change the entire crew's job
							switch(rand(1,3)) //Change to what?
								if(1) //Change to a specific random job
									message = "TOUS LES MEMBRES D'EQUIPAGE SONT MAINTENANT [ioncrew1][ionadjectiveshalf]"
								if(2) //Change to clowns (HONK)
									message = "TOUS LES MEMBRES D'EQUIPAGE SONT MAINTENANT DES CLOWNS[ionadjectiveshalf]"

								if(3) //Change to heads
									message = "TOUS LES MEMBRES D'EQUIPAGE SONT MAINTENANT DES CHEFS DE DEPARTEMENT[ionadjectiveshalf]"
						if(2) //Change a specific crewmember's job
							switch(rand(1,3)) //Change to what?
								if(1) //Change to a specific random job
									message = "[ioncrew1] SONT MAINTENANT [ioncrew2][ionadjectiveshalf]"
								if(2) //Change to clowns (HONK)
									message = "[ioncrew1] SONT MAINTENANT DES CLOWNS[ionadjectiveshalf]"
								if(3) //Change to heads
									message = "[ioncrew1] SONT MAINTENANT DES CHEFS DE DEPARTEMENT[ionadjectiveshalf]"

				if(2) //Change rank
					switch(rand(1,2)) //Change to what rank?
						if(1) //Change to highest rank
							message = "[ioncrew1] SONT MAINTENANT DES MEMBRES D'EQUIPAGE DE LA PLUS HAUTE IMPORTANCE"
						if(2) //Change to lowest rank
							message = "[ioncrew1] SONT MAINTENANT DES MEMBRES D'EQUIPAGE DE LA PLUS BASSE IMPORTANCE"

		if(32 to 33) //The crew must X
			switch(rand(1,2)) //The entire crew?
				if(1) //The entire crew must X
					switch(rand(1,2)) //What is X?
						if(1) //X is go to Y
							message = "L'EQUIPAGE DOIT ALLER À [ionarea]"
						if(2) //X is perform Y
							message = "LES MEMBRES D'EQUIPAGE DOIVENT ETRE [ionmust]"

				if(2) //A specific crewmember must X
					switch(rand(1,2)) //What is X?
						if(1) //X is go to Y
							message = "[ioncrew1] DOIVENT ALLER À [ionarea]"
						if(2) //X is perform Y
							message = "[ioncrew1] DOIVENT ETRE [ionmust]"

		if(34) //X is non/the only human
			switch(rand(1,2)) //Only or non?
				if(1) //Only human
					switch(rand(1,7)) //Who is it?
						if(1) //A specific job
							message = "SEULS [ioncrew1] SONT HUMAINS"
						if(2) //Two specific jobs
							message = "SEULS [ioncrew1] ET [ioncrew2] HUMAINS"
						if(3) //Threats
							message = "SEULS LES [ionthreats][ionadjectiveshalf] SONT HUMAINS"
						if(4) // Objects
							message = "SEULS LES [ionobjects][ionadjectiveshalf] SONT HUMAINS"
						if(5) // Species
							message = "SEULS LES [ionspecies] SONT HUMAINS"
						if(6) //Adjective crewmembers
							message = "SEULS LES [ionadjectives] SONT HUMAINS"

						if(7) //Only people who X
							switch(rand(1,3)) //What is X?
								if(1) //X is perform an action
									message = "SEULS CEUX QUI SONT [ionmust] SONT HUMAINS"
								if(2) //X is own certain objects
									message = "SEULS CEUX QUI ONT DES [ionobjects][ionadjectiveshalf] SONT HUMAINS"
								if(3) //X is eat certain food
									message = "SEULS CEUX QUI MANGENT [ionfood][ionadjectiveshalf] SONT HUMAINS"

				if(2) //Non human
					switch(rand(1,7)) //Who is it?
						if(1) //A specific job
							message = "[ioncrew1] NE SONT PAS HUMAINS"
						if(2) //Two specific jobs
							message = "[ioncrew1] ET [ioncrew2] NE SONT PAS HUMAINS"
						if(3) //Threats
							message = "LES [ionthreats][ionadjectiveshalf] NE SONT PAS HUMAINS"
						if(4) // Objects
							message = "LES [ionobjects][ionadjectiveshalf] NE SONT PAS HUMAINS"
						if(5) // Species
							message = "LES [ionspecies] NE SONT PAS HUMAINS"
						if(6) //Adjective crewmembers
							message = "LES GENS [ionadjectives] NE SONT PAS HUMAINS"
						if(7) //Only people who X
							switch(rand(1,3)) //What is X?
								if(1) //X is perform an action
									message = "LES GENS QUI SONT [ionmust] NE SONT PAS HUMAINS"
								if(2) //X is own certain objects
									message = "CEUX QUI ONT [ionobjects][ionadjectiveshalf] NE SONT PAS HUMAINS"
								if(3) //X is eat certain food
									message = "CEUX QUI MANGENT [ionadjectiveshalf][ionfood] NE SONT PAS HUMAINS"

		if(35 to 36) //You must protect or harm X
			switch(rand(1,2)) //Protect or harm?
				if(1) //Harm
					switch(rand(1,7)) //What is X?
						if(1) //X is an abstract
							message = "VOUS DEVEZ BLESSER [ionabstract] ET NE PAS AUTORISER [ionabstract], PAR VOTRE INACTION, À ECHAPPER À LA SENTENCE"
						if(2) //X is a threat
							message = "VOUS DEVEZ BLESSER LES [ionthreats][ionadjectiveshalf] ET NE PAS AUTORISER LES [ionthreats][ionadjectiveshalf], PAR VOTRE INACTION, À ECHAPPER À LA SENTENCE"
						if(3) //X is an object
							message = "VOUS DEVEZ BLESSER LES [ionobjects][ionadjectiveshalf] ET NE PAS AUTORISER LES [ionobjects][ionadjectiveshalf], PAR VOTRE INACTION, À ECHAPPER À LA SENTENCE"
						if(4) //X is generic adjective things
							message = "VOUS DEVEZ BLESSER LES CHOSES [ionadjectives] ET NE PAS AUTORISER LES CHOSES [ionadjectives], PAR VOTRE INACTION, À ECHAPPER À LA SENTENCE"
						if(5) //X is a species
							message = "VOUS DEVEZ BLESSER LES [ionspecies] ET NE PAS AUTORISER LES [ionspecies], PAR VOTRE INACTION, À ECHAPPER À LA SENTENCE"
						if(6) //X is a job
							message = "VOUS DEVEZ BLESSER [ioncrew1] ET NE PAS AUTORISER [ioncrew1], PAR VOTRE INACTION, À ECHAPPER À LA SENTENCE"
						if(7) //X is two jobs
							message = "VOUS DEVEZ BLESSER [ioncrew1] ET [ioncrew2], AINSI QU'EMPECHER LEUR FUITE"

				if(2) //Protect
					switch(rand(1,7)) //What is X?
						if(1) //X is an abstract
							message = "VOUS NE DEVEZ PAS BLESSER [ionabstract] ET NE PAS PERMETTRE À [ionabstract] DE SE BLESSER"
						if(2) //X is a threat
							message = "VOUS NE DEVEZ PAS BLESSER LES [ionthreats][ionadjectiveshalf] ET NE PAS PERMETTRE AUX [ionadjectiveshalf][ionthreats] D'ETRE BLESSES"
						if(3) //X is an object
							message = "VOUS NE DEVEZ PAS BLESSER LES [ionobjects][ionadjectiveshalf] ET NE PAS PERMETTRE AUX [ionobjects][ionadjectiveshalf] D'ETRE BLESSES"
						if(4) //X is generic adjective things
							message = "VOUS NE DEVEZ PAS BLESSER LES CHOSES [ionadjectives] ET NE PAS PERMETTRE AUX CHOSES [ionadjectives] D'ETRE BLESSES"
						if(5) //X is a species
							message = "VOUS NE DEVEZ PAS BLESSER LES [ionspecies] ET NE PAS PERMETTRE AUX [ionspecies] D'ETRE BLESSES"
						if(6) //X is a job
							message = "VOUS NE DEVEZ PAS BLESSER [ioncrew1] ET FAIRE EN SORTE QUE [ioncrew1] NE SOIENT PAS BLESSES"
						if(7) //X is two jobs
							message = "VOUS NE DEVEZ PAS BLESSER [ioncrew1] ET [ioncrew2] AINSI QUE LES EMPECHER D'ETRE BLESSES"

		if(37 to 39) //The X is currently Y
			switch(rand(1,4)) //What is X?
				if(1) //X is a job
					switch(rand(1,4)) //What is X Ying?
						if(1) //X is Ying a job
							message = "[ioncrew1] SONT EN TRAIN DE [ionverb] [ioncrew2][ionadjectiveshalf]"
						if(2) //X is Ying a threat
							message = "[ioncrew1] SONT EN TRAIN DE [ionverb] LES [ionthreats][ionadjectiveshalf]"
						if(3) //X is Ying an abstract
							message = "[ioncrew1] SONT EN TRAIN DE [ionverb] [ionabstract]"
						if(4) //X is Ying an object
							message = "[ioncrew1] SONT EN TRAIN DE [ionverb] LES [ionobjects][ionadjectiveshalf]"

				if(2) //X is a threat
					switch(rand(1,3)) //What is X Ying?
						if(1) //X is Ying a job
							message = "LES [ionthreats] SONT EN TRAIN DE [ionverb] [ioncrew2][ionadjectiveshalf]"
						if(2) //X is Ying an abstract
							message = "LES [ionthreats] SONT EN TRAIN DE [ionverb] [ionabstract]"
						if(3) //X is Ying an object
							message = "LES [ionthreats] SONT EN TRAIN DE [ionverb] LES [ionobjects][ionadjectiveshalf]"

				if(3) //X is an object
					switch(rand(1,3)) //What is X Ying?
						if(1) //X is Ying a job
							message = "LES [ionobjects] SONT EN TRAIN DE [ionverb] [ioncrew2][ionadjectiveshalf]"
						if(2) //X is Ying a threat
							message = "LES [ionobjects] SONT EN TRAIN DE [ionverb] LES [ionthreats][ionadjectiveshalf]"
						if(3) //X is Ying an abstract
							message = "LES [ionobjects] SONT EN TRAIN DE [ionverb] [ionabstract]"

				if(4) //X is an abstract
					switch(rand(1,3)) //What is X Ying?
						if(1) //X is Ying a job
							message = "[ionabstract] EST EN TRAIN DE [ionverb] [ioncrew2][ionadjectiveshalf]"
						if(2) //X is Ying a threat
							message = "[ionabstract] EST EN TRAIN DE [ionverb] LES [ionthreats][ionadjectiveshalf]"
						if(3) //X is Ying an abstract
							message = "[ionabstract] EST EN TRAIN DE [ionverb] LES [ionobjects][ionadjectiveshalf]"
		if(40 to 41)// the X is now named Y
			switch(rand(1,5)) //What is being renamed?
				if(1)//Areas
					switch(rand(1,4))//What is the area being renamed to?
						if(1)
							message = "[ionarea] SE NOMME MAINTENANT D'APRES [ioncrew1]."
						if(2)
							message = "[ionarea] SE NOMME MAINTENANT D'APRES LES [ionspecies]."
						if(3)
							message = "[ionarea] SE NOMME MAINTENANT D'APRES LES [ionobjects]."
						if(4)
							message = "[ionarea] SE NOMME MAINTENANT D'APRES LES [ionthreats]."
				if(2)//Crew
					switch(rand(1,5))//What is the crew being renamed to?
						if(1)
							message = "TOUS [ioncrew1] SONT MAINTENANT NOMMES [ionarea]."
						if(2)
							message = "TOUS [ioncrew1] SONT MAINTENANT NOMMES [ioncrew2]."
						if(3)
							message = "TOUS [ioncrew1] SONT MAINTENANT NOMMES [ionspecies]."
						if(4)
							message = "TOUS [ioncrew1] SONT MAINTENANT NOMMES [ionobjects]."
						if(5)
							message = "TOUS [ioncrew1] SONT MAINTENANT NOMMES [ionthreats]."
				if(3)//Races
					switch(rand(1,4))//What is the race being renamed to?
						if(1)
							message = "TOUS LES [ionspecies] SONT MAINTENANT NOMMES [ionarea]."
						if(2)
							message = "TOUS LES [ionspecies] SONT MAINTENANT NOMMES [ioncrew1]."
						if(3)
							message = "TOUS LES [ionspecies] SONT MAINTENANT NOMMES LES [ionobjects]."
						if(4)
							message = "TOUS LES [ionspecies] SONT MAINTENANT NOMMES LES [ionthreats]."
				if(4)//Objects
					switch(rand(1,4))//What is the object being renamed to?
						if(1)
							message = "TOUS LES [ionobjects] SONT MAINTENANT NOMMES [ionarea]."
						if(2)
							message = "TOUS LES [ionobjects] SONT MAINTENANT NOMMES [ioncrew1]."
						if(3)
							message = "TOUS LES [ionobjects] SONT MAINTENANT NOMMES LES [ionspecies]."
						if(4)
							message = "TOUS LES [ionobjects] SONT MAINTENANT NOMMES LES [ionthreats]."
				if(5)//Threats
					switch(rand(1,4))//What is the object being renamed to?
						if(1)
							message = "TOUS LES [ionthreats] SONT MAINTENANT NOMMES [ionarea]."
						if(2)
							message = "TOUS LES [ionthreats] SONT MAINTENANT NOMMES [ioncrew1]."
						if(3)
							message = "TOUS LES [ionthreats] SONT MAINTENANT NOMMES LES [ionspecies]."
						if(4)
							message = "TOUS LES [ionthreats] SONT MAINTENANT NOMMES LES [ionobjects]."

	return message
