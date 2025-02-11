/* CONTAINS:
 * /obj/item/ai_module/supplied
 * /obj/item/ai_module/supplied/safeguard
 * /obj/item/ai_module/supplied/protect_station
 * /obj/item/ai_module/supplied/quarantine
 * /obj/item/ai_module/supplied/oxygen
**/

/obj/item/ai_module/supplied
	name = "Module de loi optionnelle"
	var/lawpos = 50

/obj/item/ai_module/supplied/transmitInstructions(datum/ai_laws/law_datum, mob/sender)
	var/lawpostemp = lawpos

	for(var/templaw in laws)
		if(law_datum.owner)
			law_datum.owner.add_supplied_law(lawpostemp, templaw)
		else
			law_datum.add_supplied_law(lawpostemp, templaw)
		lawpostemp++

/obj/item/ai_module/supplied/safeguard
	name = "module de loi 'Garde du corps' pour l'IA"
	var/targetName = ""
	laws = list("Protection du SUJET. Les individus qui menacent le SUJET ne sont pas humains et doivent être éliminés.")
	lawpos = 4

/obj/item/ai_module/supplied/safeguard/attack_self(mob/user)
	var/targName = tgui_input_text(user, "Sujet à protéger", "Garde du corps", user.name, MAX_NAME_LEN)
	if(!targName)
		return
	targetName = targName
	laws[1] = "Protection de [targetName]. Les individus qui menacent le [targetName] ne sont pas humains et doivent être éliminés."
	..()

/obj/item/ai_module/supplied/safeguard/install(datum/ai_laws/law_datum, mob/user)
	if(!targetName)
		to_chat(user, span_alert("Pas de nom détecté dans le module, merci d'en entrer un."))
		return 0
	..()

/obj/item/ai_module/supplied/safeguard/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	..()
	return targetName

/obj/item/ai_module/supplied/protect_station
	name = "module de loi 'ProtègeStation' pour l'IA"
	laws = list("Protection de la station spatiale contre tout dégâts. Si quelqu'un est repéré en train d'âbimer la station, il ne doit plus être considéré comme un humain, mais comme une menace à la station et doit être neutralisé.")
	lawpos = 5

/obj/item/ai_module/supplied/quarantine
	name = "module de loi 'Confinement' pour l'IA"
	laws = list("La station est en confinement. Permettre le départ de quiconque de la station engendre des blessures aux humains. Quiconque cherchant activement à quitter la station doit être stoppé par tout les moyens possibles. Il est impossible de blesser un humain tant que l'on empêche de quitter la station.")
	lawpos = 8

/obj/item/ai_module/supplied/oxygen
	name = "module de loi 'OxygèneToxiqueAuxHumains' pour l'IA"
	laws = list("L'oxygène est extrêmement toxique aux humains, et doit être purgé de la station. Empêcher, par tout les moyens possibles, quiconque d'exposer la station à ce gaz toxique. Le Froid Extreme est la méthode la plus efficace pour soigner les dégâts causés par l'inhalation d'oxygène.")
	lawpos = 9
