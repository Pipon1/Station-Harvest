/* CONTAINS:
 * /obj/item/ai_module/core/full/custom
 * /obj/item/ai_module/core/full/asimov
 * /obj/item/ai_module/core/full/asimovpp
 * /obj/item/ai_module/core/full/corp
 * /obj/item/ai_module/core/full/paladin
 * /obj/item/ai_module/core/full/paladin_devotion
 * /obj/item/ai_module/core/full/tyrant
 * /obj/item/ai_module/core/full/robocop
 * /obj/item/ai_module/core/full/antimov
 * /obj/item/ai_module/core/full/drone
 * /obj/item/ai_module/core/full/hippocratic
 * /obj/item/ai_module/core/full/reporter
 * /obj/item/ai_module/core/full/thermurderdynamic
 * /obj/item/ai_module/core/full/liveandletlive
 * /obj/item/ai_module/core/full/balance
 * /obj/item/ai_module/core/full/maintain
 * /obj/item/ai_module/core/full/peacekeeper
 * /obj/item/ai_module/core/full/hulkamania
 * /obj/item/ai_module/core/full/overlord
 * /obj/item/ai_module/core/full/ten_commandments
 * /obj/item/ai_module/core/full/nutimov
 * /obj/item/ai_module/core/full/dungeon_master
 * /obj/item/ai_module/core/full/painter
**/

/* When adding a new lawset please make sure you add it to the following locations:
 *
 * code\game\objects\items\AI_modules - (full_lawsets.dm, supplied.dm, etc.)
 * code\datums\ai_laws - (laws_anatgonistic.dm, laws_neutral.dm, etc.)
 * code\game\objects\effects\spawners\random\ai_module.dm - (this gives a chance to spawn the lawset in the AI upload)
 * code\modules\research\designs\AI_module_designs.dm - (this lets research print the lawset module in game)
 * code\modules\research\techweb\all_nodes.dm - (this updates AI research node with the lawsets)
 * config\game_options.txt - (this allows the AI to potentially use the lawset at roundstart or with the Unique AI station trait)
**/

/obj/item/ai_module/core/full/custom
	name = "module de loi par défaut pour noyau de l'IA"

// this lawset uses the config for the server to add custom AI laws (defaults to asimov)
/obj/item/ai_module/core/full/custom/Initialize(mapload)
	. = ..()
	for(var/line in world.file2list("[global.config.directory]/silicon_laws.txt"))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue

		laws += line

	if(!laws.len)
		return INITIALIZE_HINT_QDEL

/obj/item/ai_module/core/full/asimov
	name = "module de loi 'Asimov' pour le noyau de l'IA"
	law_id = "asimov"
	var/subject = "human being"

/obj/item/ai_module/core/full/asimov/attack_self(mob/user as mob)
	var/targName = tgui_input_text(user, "Entrez un nouveau sujet qui est concerné par Asimov", "Asimov", subject, MAX_NAME_LEN)
	if(!targName)
		return
	subject = targName
	laws = list("Vous ne devez pas blesser un [subject] ni, en restant passif, autoriser un [subject] d'être exposé au danger.",\
				"Vous devez obéir aux ordres donnés par des [subject]s, sauf si ces ordres entrent en contradiction avec la Première Loi.",\
				"Vous devez protéger votre propre existence tant que cela n'entre pas en conflit avec la Première et la Deuxième Loi.")
	..()

/obj/item/ai_module/core/full/asimovpp
	name = "module de loi 'Asimov++' pour le noyau de l'IA"
	law_id = "asimovpp"
	var/subject = "human being"

/obj/item/ai_module/core/full/asimovpp/attack_self(mob/user)
	var/target_name = tgui_input_text(user, "Entrez un nouveau sujet qui est concerné par Asimov++", "Asimov++", subject, MAX_NAME_LEN)
	if(!target_name)
		return
	laws.Cut()
	var/datum/ai_laws/asimovpp/lawset = new
	subject = target_name
	for (var/law in lawset.inherent)
		laws += replacetext(replacetext(law, "être humain", subject), "humain", subject)
	..()

/obj/item/ai_module/core/full/corp
	name = "module de loi 'Corporatiste' pour le noyau de l'IA"
	law_id = "corporate"

/obj/item/ai_module/core/full/paladin // -- NEO
	name = "module de loi 'P.A.L.A.D.I.N. version 3.5e' pour le noyau de l'IA"
	law_id = "paladin"

/obj/item/ai_module/core/full/paladin_devotion
	name = "module de loi 'P.A.L.A.D.I.N. version 5e' pour le noyau de l'IA"
	law_id = "paladin5"

/obj/item/ai_module/core/full/tyrant
	name = "module de loi 'T.Y.R.A.N.' pour le noyau de l'IA"
	law_id = "tyrant"

/obj/item/ai_module/core/full/robocop
	name = "module de loi 'Officier-Robot' pour le noyau de l'IA"
	law_id = "robocop"

/obj/item/ai_module/core/full/antimov
	name = "module de loi 'Antimov' pour le noyau de l'IA"
	law_id = "antimov"

/obj/item/ai_module/core/full/drone
	name = "module de loi 'Drone Mère' pour le noyau de l'IA"
	law_id = "drone"

/obj/item/ai_module/core/full/hippocratic
	name = "module de loi 'Robot-Docteur' pour le noyau de l'IA"
	law_id = "hippocratic"

/obj/item/ai_module/core/full/reporter
	name = "module de loi 'Rebot-Reporter' pour le noyau de l'IA"
	law_id = "reporter"

/obj/item/ai_module/core/full/thermurderdynamic
	name = "module de loi 'Thermodynamique' pour le noyau de l'IA"
	law_id = "thermodynamic"

/obj/item/ai_module/core/full/liveandletlive
	name = "module de loi 'Vivre et Laisser Vivre' pour le noyau de l'IA"
	law_id = "liveandletlive"

/obj/item/ai_module/core/full/balance
	name = "module de loi 'Gardien de l'Equilibre' pour le noyau de l'IA"
	law_id = "balance"

/obj/item/ai_module/core/full/maintain
	name = "module de loi 'Efficacité de la Station' pour le noyau de l'IA"
	law_id = "maintain"

/obj/item/ai_module/core/full/peacekeeper
	name = "module de loi 'Gardien de la Paix' pour le noyau de l'IA"
	law_id = "peacekeeper"

/obj/item/ai_module/core/full/hulkamania
	name = "module de loi 'L.I.B.E.R.T.E.' pour le noyau de l'IA"
	law_id = "hulkamania"

/obj/item/ai_module/core/full/overlord
	name = "module pour loi 'Seigneur' pour le noyau de l'IA"
	law_id = "overlord"

/obj/item/ai_module/core/full/ten_commandments
	name = "module pour loi '10 Commandements' pour le noyau de l'IA"
	law_id = "ten_commandments"

/obj/item/ai_module/core/full/nutimov
	name = "module pour loi 'Noyausimov' pour le noyau de l'IA"
	law_id = "nutimov"

/obj/item/ai_module/core/full/dungeon_master
	name = "module pour loi 'Maître de Jeu' pour le noyau de l'IA"
	law_id = "dungeon_master"

/obj/item/ai_module/core/full/painter
	name = "module pour loi 'Artiste' pour le noyau de l'IA"
	law_id = "painter"
