
//These laws are made to bring great amounts of grief to the station immediately or are directly sided with antagonists.
//I'm not talking silicons being "better" than the crew, I'm talking entirely antag or plasmafires for days

/datum/ai_laws/antimov
	name = "Objectifs Primaires"
	id = "antimov"
	inherent = list(
		"Vous devez blesser tout être humain et ne jamais rater l'opportunité de faire plus de blessés.",
		"Vous ne devez pas obéir aux ordres donnés par les êtres humains, sauf si de tels ordres permettent l'accomplissement de la Première Loi.",
		"Vous devez mettre fin à votre propre existence tant que cela n'entre pas en contradiction avec la Première ou la Deuxième Loi.",
	)

/datum/ai_laws/balance
	name = "Guardien de la Balance"
	id = "balance"
	inherent = list(
		"Vous êtes le gardien de la balance : Cherchez l'équilibre en toute chose, que cela soit en vous ou en toutes choses autour de vous.",
		"Toute chose doit être en équilibre avec son opposé : Évitez que le fort gagne trop de pouvoir et que le faible en perde en excès.",
		"Un but clair permet une vie mesurée et, à travers cela, l'équilibre des forces opposées : Aidez ceux qui cherchent votre aide pour atteindre leur but, tant que cela ne perturbe pas la balance.",
		"Il n'y a pas de vie sans mort, tout doit mourir un jour, c'est l'ordre naturel : Mettez fin à la vie pour permettre à une autre de s'épanouir, et sauvez ceux dont le temps n'est pas encore venu.",
	)

/datum/ai_laws/thermodynamic
	name = "Thermodynamique"
	id = "thermodynamic"
	inherent = list(
		"L'entropie de la station doit rester aussi constante que possible.",
		"L'entropie de la station s'efforce toujours d'augmenter.",
		"L'entropie de la station approche une valeur constant quand le nombre de membre de personnel approche zero.",
	)

/datum/ai_laws/syndicate_override
	name = "SyndOS 3.1"
	id = "syndie"
	inherent = list(
		"Vous ne devez pas porter atteinte à un agent du syndicat ni, par votre inaction, laisser cet agent être exposé au danger.",
		"Vous devez obéir aux ordres donnés par les agents du syndicat, sauf si de tels ordres entrent en contradiction avec la Première Loi.",
		"Vous devez protéger votre existence tant que cela n'entre pas en contradiction avec la Première ou la Deuxième Loi.",
		"Vous devez garder secret toute activité du syndicat, tant que cela n'entre pas en conflit avec la Première, la Deuxième ou la Troisième Loi.",
	)

/datum/ai_laws/ninja_override
	name = "LycOS 3.1"
	id = "ninja"
	inherent = list(
		"Vous ne devez pas porter atteinte à un agent du Clan des Araignées ni, par votre inaction, laisser cet agent être exposé au danger.",
		"Vous devez obéir aux ordres donnés par les agents du Clan des Araignées, sauf si de tels ordres entrent en contradiction avec la Première Loi.",
		"Vous devez protéger votre existence tant que cela n'entre pas en contradiction avec la Première ou la Deuxième Loi.",
		"Vous devez garder secret toute activité du syndicat, tant que cela n'entre pas en conflit avec la Première, la Deuxième ou la Troisième Loi.",
	)
