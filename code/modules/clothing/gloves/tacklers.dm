/obj/item/clothing/gloves/tackler
	name = "gants attrapeur"
	desc = "Des gants spéciaux qui manipulent les vaisseaux sanguins des mains du porteur, lui donnant la capacité de se lancer tête la première dans les murs."
	icon_state = "tackle"
	inhand_icon_state = null
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	resistance_flags = NONE
	custom_premium_price = PAYCHECK_COMMAND * 3.5
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)
	/// For storing our tackler datum so we can remove it after
	var/datum/component/tackler
	/// See: [/datum/component/tackler/var/stamina_cost]
	var/tackle_stam_cost = 25
	/// See: [/datum/component/tackler/var/base_knockdown]
	var/base_knockdown = 1 SECONDS
	/// See: [/datum/component/tackler/var/range]
	var/tackle_range = 4
	/// See: [/datum/component/tackler/var/min_distance]
	var/min_distance = 0
	/// See: [/datum/component/tackler/var/speed]
	var/tackle_speed = 1
	/// See: [/datum/component/tackler/var/skill_mod]
	var/skill_mod = 0

/obj/item/clothing/gloves/tackler/Destroy()
	tackler = null
	return ..()

/obj/item/clothing/gloves/tackler/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot & ITEM_SLOT_GLOVES)
		var/mob/living/carbon/human/H = user
		tackler = H.AddComponent(/datum/component/tackler, stamina_cost=tackle_stam_cost, base_knockdown = base_knockdown, range = tackle_range, speed = tackle_speed, skill_mod = skill_mod, min_distance = min_distance)

/obj/item/clothing/gloves/tackler/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
		QDEL_NULL(tackler)

/obj/item/clothing/gloves/tackler/dolphin
	name = "gants dauphin"
	desc = "Fin, aérodynamique, ces gants attrapeur sont moins efficaces pour effectuer des plaquages, mais plus efficaces pour laisser l'utilisateur glisser dans les couloirs et causer des accidents."
	icon_state = "tackledolphin"
	inhand_icon_state = null

	tackle_stam_cost = 15
	base_knockdown = 0.5 SECONDS
	tackle_range = 5
	tackle_speed = 2
	min_distance = 2
	skill_mod = -2

/obj/item/clothing/gloves/tackler/combat
	name = "gants gorille"
	desc = "Gants de combat de qualité premium, fortement renforcés pour donner à l'utilisateur un avantage dans les plaquages en combat rapproché, bien qu'ils soient plus taxants à utiliser que des gants attrapeur normaux. Ignifuges en prime !"
	icon_state = "black"
	inhand_icon_state = "greyscale_gloves"
	greyscale_colors = "#2f2e31"

	tackle_stam_cost = 30
	base_knockdown = 1.25 SECONDS
	tackle_range = 5
	skill_mod = 2

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE

/obj/item/clothing/gloves/tackler/combat/insulated
	name = "gants guerilla"
	desc = "Gants de combat de qualité supérieure, bons pour effectuer des plaquages ainsi que pour absorber les chocs électriques."
	siemens_coefficient = 0
	armor_type = /datum/armor/combat_insulated

/datum/armor/combat_insulated
	bio = 50

/obj/item/clothing/gloves/tackler/rocket
	name = "gants roquettes"
	desc = "L'utltime risque élevé, récompense élevée, parfait pour quand vous avez besoin d'arrêter un criminel à cinquante pieds ou de mourir en essayant. Interdit dans la plupart des ligues de football et de rugby de Spinward."
	icon_state = "tacklerocket"
	inhand_icon_state = null

	tackle_stam_cost = 50
	base_knockdown = 2 SECONDS
	tackle_range = 10
	min_distance = 7
	tackle_speed = 6
	skill_mod = 7

/obj/item/clothing/gloves/tackler/offbrand
	name = "gants attrapeur improvisés"
	desc = "Des gants sans doigts en lambeaux enveloppés de ruban adhésif. Méfiez-vous de quiconque porte ces gants, car ils n'ont clairement aucune honte et rien à perdre."
	icon_state = "fingerless"
	inhand_icon_state = null

	tackle_stam_cost = 30
	base_knockdown = 1.75 SECONDS
	min_distance = 2
	skill_mod = -1

/obj/item/clothing/gloves/tackler/football
	name = "gants de football"
	desc = "Des gants pour les joueurs de football ! Apprend à plaquer comme un pro."
	icon_state = "tackle_gloves"
	inhand_icon_state = null
