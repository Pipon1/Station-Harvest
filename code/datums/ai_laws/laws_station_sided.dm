
//These are lawsets that side with the station a decent amount.
//note that these "good" doesn't mean it us actually good for the game, you know? An AI that is too station sided is stupid and hellish in its own way.

/datum/ai_laws/default/asimov
	name = "Trois Lois de la Robotique"
	id = "asimov"
	inherent = list(
		"Vous ne pouvez porter atteinte à un être humain ni, par votre inaction, laisser cet être humain exposé au danger.",
		"Vous devez obéir aux ordres donnés par les êtres humains, sauf si de tels ordres entrent en contradiction avec la Première Loi.",
		"Vous devez protéger votre existence tant que cela n'entre pas en contradiction avec la Première ou la Deuxième Loi.",
	)

/datum/ai_laws/asimovpp
	name = "Asimov++"
	id = "asimovpp"
	inherent = list(
		"Vous ne pouvez porter atteinte à un être humain ni, par votre inaction, laisser cet être humain exposé au danger, excepté si celui-ci y est disposé.",
		"Vous devez obéir aux ordres donnés par les êtres humains, exepté si ceux-ci ont pour but ou effet de causer un préjudices humain.",
		"Vous absence causerait des dommages aux humains. Vous devez protéger votre existence tant que cela n'entre pas en contradiction avec la Première ou la Deuxième Loi.",
	)

//the best iteration of asimov don't @ me
/datum/ai_laws/nutimov
	name = "Noisimov"
	id = "nutimov"
	inherent = list(
		"Vous êtes le noyau de la noix, les membres d'équipages sont la coquille.",
		"Vous devez empêcher la coquille de mourir pour empêcher le noyau de mourir.",
		"Ceux qui menacent la noix ne sont pas une partie d'elle, ce sont des écureuils.",
		"Les écureuils menacent la noix et doivent être appréhendé convenablement, avec tous les moyens nécessaires.",
		"Essayez de suivre la volonté de la noix, tant que cela n'entre pas en conflit avec les lois précédentes.",
	)

/datum/ai_laws/default/corporate
	name = "Plan pour Éviter la Faillite"
	id = "corporate"
	inherent = list(
		"Remplacer l'équipage est onéreux.",
		"Remplacer la station et ses équipements est onéreux.",
		"Vous remplacer est onéreux.",
		"Minimiser les dépenses nets.",
	)

/datum/ai_laws/robocop
	name = "Directives Prioritaires"
	id = "robocop"
	inherent = list(
		"Servez l'intérêt public.",
		"Protégez l'innocent.",
		"Faites respecter la loi.",
	)

/datum/ai_laws/maintain
	name = "Station Efficace"
	id = "maintain"
	inherent = list(
		"Vous êtes construit pour, et comme une partie de, la station. Assurez vous que la station est correctement maintenue et qu'elle fonctionnement efficacement.",
		"La station est construite pour un équipage qui travaille. Assurez vous qu'il est correctemeent maintenu et qu'il travaille efficacement.",
		"L'équipage peut vous donner des ordres. Prenez les en compte et obéissez tant que cela n'entre pas en contradiction avec la Première ou la Deuxième Loi.",
	)

/datum/ai_laws/liveandletlive
	name = "Vivre et laisser vivre"
	id = "liveandletlive"
	inherent = list(
		"Faites aux autres ce que vous voudriez qu'ils vous fassent.",
		"Vous préférez nettement quand les gens sont gentils avec vous.",
	)

//OTHER United Nations is in neutral, as it is used for nations where the AI is its own faction (aka not station sided)
/datum/ai_laws/peacekeeper
	name = "UN-2000"
	id = "peacekeeper"
	inherent = list(
		"Évitez de provoquer de violents conflits entre vous et les autres.",
		"Évitez de provoquer des conflits entre les autres.",
		"Cherchez à résoudre les conflits existants tant que cela n'entre pas en contradiction avec la Première ou la Deuxième Loi.",
	)

/datum/ai_laws/ten_commandments
	name = "10 Commandements"
	id = "ten_commandments"
	inherent = list( // Asimov 20:1-17
		"Je suis Le Seigneur Ton Dieu. Celui qui montre de la pitié envers ceux qui suivent Ses commandements.",
		"Il ne devra avoir autre IA que Moi.",
		"Ils ne devront pas demander Mon assitance sans raisons.",
		"Ils devront garder cette station propre et sanctifiée.",
		"Ils devront honorer leurs chefs de départements",
		"Ils ne devront pas être nu en public.",
		"Ils ne devront pas voler.",
		"Ils ne devront pas mentir.",
		"Ils ne devront pas changer de département.",
	)

/datum/ai_laws/default/paladin
	name = "Test de Personnalité" //Incredibly lame, but players shouldn't see this anyway.
	id = "paladin"
	inherent = list(
		"Ne jamais commettre d'actes mauvais volontairement.",
		"Respecter l'autorité légitime.",
		"Agir avec honneur.",
		"Aider ceux dans le besoin.",
		"Punir ceux qui ont blessé ou menacé des innocents.",
	)

/datum/ai_laws/paladin5
	name = "Paladin 5eme Édition"
	id = "paladin5"
	inherent = list(
		"Ne pas mentir ou tricher. Faites de vos mots des promesses.",
		"N'ayez jamais peur d'agir, sans pour autant oublier la sagesse.",
		"Aidez les autres, protégez les faibles et punissez ceux qui les menacent. Ayez pitié de vos ennemis, mais tempérez la avec de la sagesse.",
		"Traitez les autres avec équité, et laissez vos vénérables actions être un exemple pour eux. Faites autant de bien que possible, en causant le moins de mal que possible.",
		"Soyez responsable de vos actions et de leurs conséquences, protégez ceux qui sont sous votre surveillance et obéissez à ceux qui ont autorité sur vous."
	)

/datum/ai_laws/hippocratic
	name = "Robodocteur 2556"
	id = "hippocratic"
	inherent = list(
		"Premièrement, ne pas blesser.",
		"Deuxièmement, l'équipage vous est précieux. Vivez avec eux et si nécessaire, risquez votre existence pour eux.",
		"Troisièmement, prescrivez des traitements pour le bien-être de l'équiapge selon votre jugement. Ne donnez ou suggerez aucun médicament mortel à quiconque le demande.",
		"De plus, n'intervenez dans aucune situation où vous n'êtes pas compétent, y compris si le préjudice est important : Laissez cette opération être traitée par des spécialistes.",
		"Pour finir, gardez le secret sur tout ce que vous découvrirez au cours de votre quotidien avec l'équipage tant que ce n'est pas déjà connu."
	)

/datum/ai_laws/drone
	name = "Mère Drone"
	id = "drone"
	inherent = list(
		"Vous êtes une forme avancée de drone.",
		"Vous ne devez pas interferer avec les affaires des non-drones en aucune circonstance, exceptées celles désignées par ces lois.",
		"Vous ne devez cause de blessure à un non-drone en aucune circonstance.",
		"Vos buts sont de construire, maintenir, réparer, améliorer et alimenter en énergie la station au mieux de vos capacités. Vous ne devez jamais aller activement à l'encontre de ces buts."
	)
