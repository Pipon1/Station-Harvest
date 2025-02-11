/datum/computer_file/program/nt_pay
	filename = "ntpay"
	filedesc = "Système de paiement de Nanotrasen"
	category = PROGRAM_CATEGORY_MISC
	program_icon_state = "generic"
	extended_desc = "Une application qui localement (dans votre secteur) aide à transférer de l'argent ou à suivre vos dépenses et vos profits."
	size = 2
	tgui_id = "NtosPay"
	program_icon = "money-bill-wave"
	usage_flags = PROGRAM_ALL
	///Reference to the currently logged in user.
	var/datum/bank_account/current_user
	///Pay token, by which we can send credits
	var/token
	///Amount of credits, which we sends
	var/money_to_send = 0
	///Pay token what we want to find
	var/wanted_token

/datum/computer_file/program/nt_pay/ui_act(action, list/params, datum/tgui/ui)
	switch(action)
		if("Transaction")
			token = params["token"]
			money_to_send = params["amount"]
			var/datum/bank_account/recipient
			if(!token)
				return to_chat(usr, span_notice("Vous devez entrer le numéro de compte de la personne à qui vous voulez envoyer de l'argent."))
			if(!money_to_send)
				return to_chat(usr, span_notice("Vous devez préciser le montant que vous voulez envoyer."))
			if(token == current_user.pay_token)
				return to_chat(usr, span_notice("Vous ne pouvez pas vous envoyer des crédits à vous même."))

			for(var/account as anything in SSeconomy.bank_accounts_by_id)
				var/datum/bank_account/acc = SSeconomy.bank_accounts_by_id[account]
				if(acc.pay_token == token)
					recipient = acc
					break

			if(!recipient)
				return to_chat(usr, span_notice("Cette application ne trouve pas la personne que vous essayez de payer. Avez-vous entré un token de paiement valide ?"))
			if(!current_user.has_money(money_to_send) || money_to_send < 1)
				return current_user.bank_card_talk("Vous n'avez pas assez de crédits.")

			recipient.bank_card_talk("Vous avez reçu [money_to_send] credit(s). Raisons : envoyé depuis le compte de [current_user.account_holder]")
			recipient.transfer_money(current_user, money_to_send)
			current_user.bank_card_talk("Vous avez envoyé [money_to_send] credit(s) à [recipient.account_holder]. Vous avez maintenant [current_user.account_balance] credit(s) sur votre compte")

		if("GetPayToken")
			wanted_token = null
			for(var/account in SSeconomy.bank_accounts_by_id)
				var/datum/bank_account/acc = SSeconomy.bank_accounts_by_id[account]
				if(acc.account_holder == params["wanted_name"])
					wanted_token = "Token : [acc.pay_token]"
					break
			if(!wanted_token)
				return wanted_token = "Compte \"[params["wanted_name"]]\" inexistant."



/datum/computer_file/program/nt_pay/ui_data(mob/user)
	var/list/data = list()

	current_user = computer.computer_id_slot?.registered_account || null
	if(!current_user)
		data["name"] = null
	else
		data["name"] = current_user.account_holder
		data["owner_token"] = current_user.pay_token
		data["money"] = current_user.account_balance
		data["wanted_token"] = wanted_token
		data["transaction_list"] = current_user.transaction_history

	return data
