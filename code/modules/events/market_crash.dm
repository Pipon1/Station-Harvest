/**
 * An event which decreases the station target temporarily, causing the inflation var to increase heavily.
 *
 * Done by decreasing the station_target by a high value per crew member, resulting in the station total being much higher than the target, and causing artificial inflation.
 */
/datum/round_event_control/market_crash
	name = "Krach boursier"
	typepath = /datum/round_event/market_crash
	weight = 10
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "Augmente temporairement le prix des distributeurs."

/datum/round_event/market_crash
	var/market_dip = 0

/datum/round_event/market_crash/setup()
	start_when = 1
	end_when = rand(25, 50)
	announce_when = 2

/datum/round_event/market_crash/announce(fake)
	var/list/poss_reasons = list("de l'alignement entre la lune et le soleil",\
		"des investissements risqués en immobilier",\
		"de la chute inévitable de l'équipe B.E.P.I.S.",\
		"de spéculations concernant l'échec des subvensions du gouvernement",\
		"de rapports grandement éxagérés concernant un sucide de masse chez les comptables de Nanotrasen")
	var/reason = pick(poss_reasons)
	priority_announce("À cause [reason], les prix des distributeurs de la station vont augmenter pour une courte période.", "Division de comptabilité de Nanotrasen")

/datum/round_event/market_crash/start()
	. = ..()
	market_dip = rand(1000,10000) * length(SSeconomy.bank_accounts_by_id)
	SSeconomy.station_target = max(SSeconomy.station_target - market_dip, 1)
	SSeconomy.price_update()
	ADD_TRAIT(SSeconomy, TRAIT_MARKET_CRASHING, MARKET_CRASH_EVENT_TRAIT)

/datum/round_event/market_crash/end()
	. = ..()
	SSeconomy.station_target += market_dip
	REMOVE_TRAIT(SSeconomy, TRAIT_MARKET_CRASHING, MARKET_CRASH_EVENT_TRAIT)
	SSeconomy.price_update()
	priority_announce("Les prix des distributeurs sont maintenant stabilisés.", "Division de comptabilité de Nanotrasen")

