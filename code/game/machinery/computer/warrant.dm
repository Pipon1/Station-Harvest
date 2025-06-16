/obj/machinery/computer/warrant
	name = "Ordinateur de consultation des mandats"
	desc = "Utilisé pour consulter les mandats de recherche."
	icon_screen = "security"
	icon_keyboard = "security_key"
	circuit = /obj/item/circuitboard/computer/warrant
	light_color = COLOR_SOFT_RED
	/// The state of the printer
	var/printing = FALSE

/obj/machinery/computer/warrant/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WarrantConsole", name)
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/machinery/computer/warrant/ui_data(mob/user)
	var/list/data = list()

	var/list/records = list()

	for(var/datum/record/crew/target in GLOB.manifest.general)
		if(!length(target.citations))
			continue

		var/list/citations = list()

		for(var/datum/crime/citation/warrant as anything in target.citations)
			if(!warrant.valid)
				continue

			var/list/entry = list(list(
				author = warrant.author,
				details = warrant.details,
				fine = warrant.fine,
				fine_name = warrant.name,
				fine_ref = REF(warrant),
				paid = warrant.paid,
				time = warrant.time,
			))

			citations += entry

		var/list/record = list(list(
			citations = citations,
			crew_name = target.name,
			crew_ref = REF(target),
			notes = target.security_note,
			rank = target.rank,
		))

		records += record
	data["records"] = records

	return data

/obj/machinery/computer/warrant/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return FALSE

	switch(action)
		if("pay")
			pay_fine(usr, params)
			return TRUE

		if("print")
			ui.close()
			print_bounty(usr, params)
			return TRUE

		if("refresh")
			return TRUE

	return FALSE

/// Pays towards a listed fine.
/obj/machinery/computer/warrant/proc/pay_fine(mob/user, list/params)
	var/datum/record/crew/target = locate(params["crew_ref"]) in GLOB.manifest.general
	if(!target)
		return FALSE

	var/datum/crime/citation/warrant = locate(params["fine_ref"]) in target.citations
	if(!warrant)
		return FALSE

	if(!isliving(user) || issilicon(user))
		to_chat(user, span_warning("ACCES REFUSE"))
		playsound(src, 'sound/machines/terminal_error.ogg', 100, TRUE)
		return FALSE

	var/mob/living/player = user
	var/obj/item/card/id/auth = player.get_idcard(TRUE)
	if(!auth)
		to_chat(user, span_warning("ACCES REFUSE : AUCUNE CARTE D'IDENTITE DETECTEE"))
		playsound(src, 'sound/machines/terminal_error.ogg', 100, TRUE)
		return FALSE

	var/datum/bank_account/account = auth.registered_account
	if(!account?.account_holder || account.account_holder == "Unassigned")
		to_chat(user, span_warning("ACCES REFUSE : CARTE D'IDENTITE NON ENREGISTREE"))
		playsound(src, 'sound/machines/terminal_error.ogg', 100, TRUE)
		return FALSE

	var/amount = params["amount"]
	if(!amount || !isnum(amount) || amount > warrant.fine || !account.adjust_money(-amount, "Amende payer pour [target.name]"))
		to_chat(user, span_warning("ACCES REFUSE : MONTANT INVALIDE"))
		playsound(src, 'sound/machines/terminal_error.ogg', 100, TRUE)
		return FALSE

	account.bank_card_talk("Vous avez payé [amount]cr du total de l'amende de [target.name] qui est de [warrant.fine]cr.")
	log_econ("[amount]cr ont été transféré [user] pour payer l'amende de [target.name] d'une somme totale de [warrant.fine]cr.")
	SSblackbox.record_feedback("amount", "credits_transferred", amount)
	warrant.pay_fine(amount)

	if(amount >= 100 && target?.name != user)
		var/list/titles = list(
			"Un bénéfacteur anonyme",
			"Un citoyen généreux",
			"Une âme charitable",
			"Un bon samaritain",
			"Un visage sympathique",
			"Un étranger bienveillant",
		)
		warrant.alert_owner(user, src, target.name, "[pick(titles)] a fait don de  [amount]cr pour aider à payer votre amende.")

	var/datum/bank_account/sec_account = SSeconomy.get_dep_account(ACCOUNT_SEC)
	sec_account.adjust_money(amount)

	if(warrant.fine != 0 || target.name == user)
		return TRUE

	warrant.alert_owner(user, src, target.name, "Une de nos amendes a été complètement payé.")
	return TRUE

/// Finishes printing, resets the printer.
/obj/machinery/computer/warrant/proc/print_finish(obj/item/paper/bounty)
	printing = FALSE
	playsound(src, 'sound/machines/terminal_eject.ogg', 100, TRUE)
	bounty.forceMove(loc)

	return TRUE

/// Prints a bounty for a listed fine.
/obj/machinery/computer/warrant/proc/print_bounty(mob/user, list/params)
	if(printing)
		balloon_alert(user, "l'imprimante est déja en cours d'utilisation.")
		playsound(src, 'sound/machines/terminal_error.ogg', 100, TRUE)
		return FALSE

	var/datum/record/crew/target = locate(params["crew_ref"]) in GLOB.manifest.general
	if(!target)
		return FALSE

	var/datum/crime/citation/warrant = locate(params["fine_ref"]) in target.citations
	if(!warrant?.fine)
		return FALSE

	var/bounty_text = "<center><h2><b>Voulu mort ou vif : [target.name]</b><h2></center><BR>"
	bounty_text += "<center>Recherché pour : [warrant.name]</h2></center><br><br>"
	bounty_text += "<b>Détails : </b><br>[warrant.details]<br>"
	bounty_text += "<b>Ordonnée par : </b><br>[usr]<br>"
	bounty_text += "<b>Ordonnée à : </b><br>[warrant.time]<br>"
	bounty_text += "<b>Commentaire : </b><br>[!target.security_note ? "Aucun." : target.security_note]<br><br>"
	bounty_text += "<center><b>AMENDE : </b> [warrant.fine] credits</center>"

	printing = TRUE
	balloon_alert(user, "Imprimage en cours")
	playsound(src, 'sound/machines/printer.ogg', 100, TRUE)

	var/obj/item/paper/bounty = new(null)
	bounty.name = "Prime pour [target.name]"
	bounty.desc = "une prime de [warrant.fine]cr pour [target.name]."
	bounty.add_raw_text(bounty_text)
	bounty.update_icon()

	addtimer(CALLBACK(src, PROC_REF(print_finish), bounty), 2 SECONDS)

	return TRUE
