/datum/quirk/item_quirk/junkie
	value = -8

/datum/quirk/item_quirk/narcolepsy
	name = "Narcolepsy"
	desc = "You fall asleep at random. The more you are stressed the more often you fall asleep."
	icon = FA_ICON_BED
	value = -10
	mob_trait = TRAIT_NARCOLEPSY
	medical_record_text = "Patient suffer from narcolepsy."
	hardcore_value = 8
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES
	mail_goodies = list(/obj/item/storage/pill_bottle/nosleeppill)
	COOLDOWN_DECLARE(narco_cooldown)
	var/first = 1

/datum/quirk/item_quirk/narcolepsy/add_unique(client/client_source)
	give_item_to_holder(/obj/item/storage/pill_bottle/nosleeppill, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/narcolepsy/process()
	if (!COOLDOWN_FINISHED(src, narco_cooldown) && first == 2)
		return
	else if (COOLDOWN_FINISHED(src, narco_cooldown) && first == 2 && !locate(/datum/reagent/consumable/coffee) in quirk_holder.reagents.reagent_list)
		if (quirk_holder.mob_mood.sanity > SANITY_DISTURBED)
			its_time_for_bed()
			COOLDOWN_START(src, narco_cooldown, rand(25, 45) MINUTES)
		else if (quirk_holder.mob_mood.sanity <= SANITY_DISTURBED)
			its_time_for_bed()
			COOLDOWN_START(src, narco_cooldown, rand(15, 35) MINUTES)
		else if (quirk_holder.mob_mood.sanity <= SANITY_CRAZY)
			its_time_for_bed()
			COOLDOWN_START(src, narco_cooldown, rand(10, 15) MINUTES)
	else if (first == 1)
		COOLDOWN_START(src, narco_cooldown, rand(20, 25) MINUTES)
		first = 2
	else if (locate(/datum/reagent/consumable/coffee) in quirk_holder.reagents.reagent_list)
		to_chat(quirk_holder, span_notice("You feel awake!"))
		COOLDOWN_START(src, narco_cooldown, rand(25, 45) MINUTES)

/datum/quirk/item_quirk/narcolepsy/proc/its_time_for_bed()
	quirk_holder.Sleeping(rand(5, 90) SECONDS)
