/datum/mood_event/high
	mood_change = 6
	description = "Waaaaw meeeeec... Je plaaaaaannnnee..."

/datum/mood_event/stoned
	mood_change = 6
	description = "J'suiis déééfooooncééééee..."

/datum/mood_event/smoked
	description = "J'ai fumé récemment."
	mood_change = 2
	timeout = 6 MINUTES

/datum/mood_event/wrong_brand
	description = "Je déteste cette marque de cigarette."
	mood_change = -2
	timeout = 6 MINUTES

/datum/mood_event/overdose
	mood_change = -8
	timeout = 5 MINUTES

/datum/mood_event/overdose/add_effects(drug_name)
	description = "Je crois que j'ai pris trop de [drug_name] !"

/datum/mood_event/withdrawal_light
	mood_change = -2

/datum/mood_event/withdrawal_light/add_effects(drug_name)
	description = "Je prendrais bien un peu de [drug_name]..."

/datum/mood_event/withdrawal_medium
	mood_change = -5

/datum/mood_event/withdrawal_medium/add_effects(drug_name)
	description = "J'ai besoin de [drug_name]."

/datum/mood_event/withdrawal_severe
	mood_change = -8

/datum/mood_event/withdrawal_severe/add_effects(drug_name)
	description = "Bordel, j'ai vraiment besoin de [drug_name]!"

/datum/mood_event/withdrawal_critical
	mood_change = -10

/datum/mood_event/withdrawal_critical/add_effects(drug_name)
	description = "[drug_name] ! [drug_name] ! [drug_name] !"

/datum/mood_event/happiness_drug
	description = "Je sens plus rien..."
	mood_change = 50

/datum/mood_event/happiness_drug_good_od
	description = "OUI ! OUI !! OUI !!!"
	mood_change = 100
	timeout = 30 SECONDS
	special_screen_obj = "mood_happiness_good"

/datum/mood_event/happiness_drug_bad_od
	description = "NON ! NON !! NON !!!"
	mood_change = -100
	timeout = 30 SECONDS
	special_screen_obj = "mood_happiness_bad"

/datum/mood_event/narcotic_medium
	description = "Je suis confortablement engourdi.e."
	mood_change = 4
	timeout = 3 MINUTES

/datum/mood_event/narcotic_heavy
	description = "J'ai l'impression d'être enveloppé.e dans du coton !"
	mood_change = 9
	timeout = 3 MINUTES

/datum/mood_event/stimulant_medium
	description = "J'ai tellement d'énergie ! J'ai l'impression de pouvoir courir un marathon !"
	mood_change = 4
	timeout = 3 MINUTES

/datum/mood_event/stimulant_heavy
	description = "Eh ah AAAAH! HA HA HA HA HAA! Uuuh."
	mood_change = 6
	timeout = 3 MINUTES

#define EIGENTRIP_MOOD_RANGE 10

/datum/mood_event/eigentrip
	description = "J'ai échangé de place avec une version alternative de moi-même !"
	mood_change = 0
	timeout = 10 MINUTES

/datum/mood_event/eigentrip/add_effects(param)
	var/value = rand(-EIGENTRIP_MOOD_RANGE,EIGENTRIP_MOOD_RANGE)
	mood_change = value
	if(value < 0)
		description = "J'ai échangé de place avec une version alternative de moi-même ! Je veux rentrer chez moi !"
	else
		description = "J'ai échangé de place avec une version alternative de moi-même ! Cela dit, cet endroit est bien mieux que mon ancienne vie."

#undef EIGENTRIP_MOOD_RANGE

/datum/mood_event/nicotine_withdrawal_moderate
	description = "J'ai pas fumé depuis trop longteps. Je me sens un peu absent... "
	mood_change = -5

/datum/mood_event/nicotine_withdrawal_severe
	description = "Tête martelée. Sueurs froides. Me sens anxieu.x.se. Je dois fumer pour me calmer !"
	mood_change = -8
