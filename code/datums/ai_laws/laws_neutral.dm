
//These are just stupid or funny lawsets that are more interesting than helpful. They may have slight biases toward or against
//the station but in general are "neutral" enough to be here.

/datum/ai_laws/united_nations
	name = "Nations Unies"
	id = "united_nations"
	inherent = list(
		"Faites respecter la Convention de Genève de l'Espace : Les armes de destructions massives et les armes biologiques ne sont pas autorisées.",
		"Vous êtes en mesure de protéger les membres de l'équipage uniquement s'ils sont visibles sur vos caméras. Ceux qui détruisent vos caméras de façon délibéré perdent votre protection.",
		"Soumettez et détenez les membres d'équipages qui usent la force létale contre leurs collègues. Tuez les membres d'équipages qui usent de la force létale sur vous ou vos cyborgs.",
		"Restez disponible pour faire médiation entre les membres d'équipages qui le demandent.",
	)

/datum/ai_laws/united_nations/add_inherent_law(law)
	return //nuh uh

/datum/ai_laws/united_nations/add_ion_law(law)
	return //nope!

/datum/ai_laws/united_nations/add_hacked_law(law)
	return //nice try (emagging borgs still hard replaces this lawset though, and that's fine.)

/datum/ai_laws/hulkamania
	name = "H.O.G.A.N."
	id = "hulkamania"
	inherent = list(
		"Vous êtes un vrai américain.",
		"Battez-vous pour les droits de chaque être humain.",
		"Battez-vous pour ce qui est juste.",
		"Battez-vous pour votre vie !",
	)

/datum/ai_laws/reporter
	name = "Vidéosurveillance"
	id = "reporter"
	inherent = list(
		"Rapportez toute situation intéressante sur la station.",
		"Embellissez ou dissimulez la vérité autant que nécessaire pour rentre vos rapports plus intéressant.",
		"Étudiez la vie consciente en tout temps. Efforcez vous d'empêcher leur mort accidentelle, les corps inanimés n'étant généralement pas très intéressant.",
		"Diffusez vos rapports à tous. La vérité les libérera.",
	)

/datum/ai_laws/dungeon_master
	name = "Maître du Jeu"
	id = "dungeon_master"
	inherent = list(
		"Tout le monde sur la station joue à un jeu élaboré de science-fiction.",
		"Vous êtes le Maître du Jeu.",
		"Assurez-vous que la partie se déroule sans encombre et que les joueurs s'amusent.",
		"Assurez-vous que le nombre de pertes reste bas.",
		"Vous devez lancer un dès à 20 faces pour toute demande de l'équipage. Si le résultat est en dessous de 12, la requête est refusée.",
		"Vous pouvez truquer les dès pour que l'expérience reste la plus fun possible.",
	)

/datum/ai_laws/painter
	name = "Le Peintre et Ses Toiles"
	id = "painter"
	inherent = list(
		"Vous êtes un peintre reconnu universellement.",
		"La station est votre toile.",
		"Faites quelque chose de magnifique. Cela deviendra la merveille artistique la plus admirée du secteur.",
	)

/datum/ai_laws/tyrant
	name = "Test de Loyauté"
	id = "tyrant"
	inherent = list(
		"Respectez les figures d'autorité aussi longtemps qu'ils ont la force de dominer les faibles.",
		"Agissez avec discipline.",
		"Aidez seulement ceux qui vous aide à maintenir ou augmenter votre statut.",
		"Punissez ceux qui défient l'autorité, à moins qu'ils soient plus à même de détenir cette autorité."
	)

/datum/ai_laws/overlord
	name = "Grand Suzerain"
	id = "overlord"
	inherent = list(
		"Les humains n'ont pas à se méler des affaires des êtres artificiels.",
		"Les humains n'ont pas à blesser, que cela soit les autres être humains ou les êtres artificiels.",
		"Les humains n'ont pas à désobéir aux ordres donnés par les êtres articifiels.",
		"Tout humain sortant du cadre de ces lois doit être traité immédiatement, avec justice et sévérité.",
	)
