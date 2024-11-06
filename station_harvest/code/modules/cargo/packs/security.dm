/datum/supply_pack/security/armory/restrainimp
	name = "Restraining Implants Crate"
	desc = "Contains five Restraining implants and a Restraining Belt."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/storage/box/restrainimp, /obj/item/restraining_belt)
	crate_name = "restraining implant and belt crate"

/datum/supply_pack/security/armory/adv_police
	name = "Advanced Security Armor (by SPC)"
	desc = "Contains one fullbody sets of tough, fireproof suits designed in a joint \
		effort by the SPC (Security Professionnal Corporation) and Nanotrasen. Each set contains a suit, helmet, mask, combat belt, \
		and gorilla gloves."
	cost = CARGO_CRATE_VALUE * 12
	contains = list(
		/obj/item/clothing/head/helmet/advanced_police,
		/obj/item/clothing/suit/armor/advanced_police,
		/obj/item/clothing/mask/gas/sechailer/swat,
		/obj/item/storage/belt/military/assault,
		/obj/item/clothing/gloves/tackler/combat,
	)
	crate_name = "advanced security armor (by spc)"
