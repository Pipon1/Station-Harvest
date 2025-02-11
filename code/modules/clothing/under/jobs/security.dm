/*
 * Contains:
 * Security
 * Detective
 * Navy uniforms
 */

/*
 * Security
 */

/obj/item/clothing/under/rank/security
	icon = 'icons/obj/clothing/under/security.dmi'
	worn_icon = 'icons/mob/clothing/under/security.dmi'
	armor_type = /datum/armor/rank_security
	strip_delay = 50
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/datum/armor/rank_security
	melee = 10
	bio = 10
	fire = 30
	acid = 30
	wound = 10

/obj/item/clothing/under/rank/security/officer
	name = "uniforme de sécurité"
	desc = "Une tenue de sécurité tactique pour les officiers, avec une boucle de ceinture Nanotrasen."
	icon_state = "rsecurity"
	inhand_icon_state = "r_suit"

/obj/item/clothing/under/rank/security/officer/grey
	name = "tenue de sécurité grise"
	desc = "Une relique tactique des années passées avant que Nanotrasen ne décide qu'il était moins cher de teindre les costumes en rouge plutôt que de laver le sang."
	icon_state = "security"
	inhand_icon_state = "gy_suit"

/obj/item/clothing/under/rank/security/officer/skirt
	name = "jupe de sécurité"
	desc = "Un uniforme de sécurité \"tactique\" avec les jambes remplacées par une jupe."
	icon_state = "secskirt"
	inhand_icon_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/officer/blueshirt
	name = "chemise bleue et cravate"
	desc = "Je suis un peu occupé en ce moment, Calhoun."
	icon_state = "blueshift"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/officer/formal
	name = "uniforme de sécurité formel"
	desc = "La dernière mode en matière de tenue de sécurité."
	icon_state = "officerblueclothes"
	inhand_icon_state = null
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/constable
	name = "tenue de constable"
	desc = "Une tenue ayant l'air britannique."
	icon_state = "constable"
	inhand_icon_state = null
	can_adjust = FALSE
	custom_price = PAYCHECK_COMMAND


/obj/item/clothing/under/rank/security/warden
	name = "tenue de sécurité"
	desc = "Une tenue de sécurité formelle pour les officiers, avec une boucle de ceinture Nanotrasen."
	icon_state = "rwarden"
	inhand_icon_state = "r_suit"

/obj/item/clothing/under/rank/security/warden/grey
	name = "tenue de sécurité grise"
	desc = "Une relique tactique des années passées avant que Nanotrasen ne décide qu'il était moins cher de teindre les costumes en rouge plutôt que de laver le sang."
	icon_state = "warden"
	inhand_icon_state = "gy_suit"

/obj/item/clothing/under/rank/security/warden/skirt
	name = "jupe de sécurité du gardien"
	desc = "Une tenue avec jupe pour les officiers, avec une boucle de ceinture Nanotrasen."
	icon_state = "rwarden_skirt"
	inhand_icon_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/warden/formal
	desc = "L'insigne sur cet uniforme vous dit que cet uniforme appartient au Gardien."
	name = "uniforme du gardien formel"
	icon_state = "wardenblueclothes"
	inhand_icon_state = null
	alt_covers_chest = TRUE

/*
 * Detective
 */
/obj/item/clothing/under/rank/security/detective
	name = "tenue usée"
	desc = "Si quelqu'un porte ça, c'est qu'il est sérieux."
	icon_state = "detective"
	inhand_icon_state = "det"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/detective/skirt
	name = "jupe de détective"
	desc = "Si quelqu'un porte ça, c'est qu'il est sérieux."
	icon_state = "detective_skirt"
	inhand_icon_state = "det"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/detective/noir
	name = "tenue noir"
	desc = "La tenue d'un détective privé dur à cuire, avec une pince à cravate."
	icon_state = "noirdet"
	inhand_icon_state = null
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/detective/noir/skirt
	name = "jupe noir"
	desc = "La jupe d'un détective privé dur à cuire, avec une pince à cravate."
	icon_state = "noirdet_skirt"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/*
 * Head of Security
 */
/obj/item/clothing/under/rank/security/head_of_security
	name = "uniforme du chef de la sécurité"
	desc = "Une tenue de sécurité décorée pour ceux qui ont la détermination de devenir chef de la sécurité."
	icon_state = "rhos"
	inhand_icon_state = "r_suit"
	armor_type = /datum/armor/security_head_of_security
	strip_delay = 60

/datum/armor/security_head_of_security
	melee = 10
	bio = 10
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/under/rank/security/head_of_security/skirt
	name = "jupe du chef de la sécurité"
	desc = "Une tenue de sécurité avec une jupe décorée pour ceux qui ont la détermination de devenir chef de la sécurité."
	icon_state = "rhos_skirt"
	inhand_icon_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/head_of_security/grey
	name = "tenue grise du chef de la sécurité"
	desc = "Il y'a des vieux hommes, et il y'a des hommes courageux, mais il y'a très peu de vieux hommes courageux."
	icon_state = "hos"
	inhand_icon_state = "gy_suit"

/obj/item/clothing/under/rank/security/head_of_security/alt
	name = "pull à col roulé du chef de la sécurité"
	desc = "Une tenue de sécurité avec un pull à col roulé pour ceux qui ont la détermination de devenir chef de la sécurité."
	icon_state = "hosalt"
	inhand_icon_state = "bl_suit"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/head_of_security/alt/skirt
	name = "tenue à col roulé accompagné d'une jupe du chef de la sécurité"
	desc = "Une tenue de sécurité avec un pull à col roulé pour ceux qui ont la détermination de devenir chef de la sécurité."
	icon_state = "hosalt_skirt"
	inhand_icon_state = "bl_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/head_of_security/parade
	name = "uniforme de parade du chef de la sécurité"
	desc = "Une tenue pour les chefs de la sécurité masculin, pour les occasions spéciales."
	icon_state = "hos_parade_male"
	inhand_icon_state = "r_suit"
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/head_of_security/parade/female
	name = "uniforme de parade du chef de la sécurité"
	desc = "Une tenue pour les chefs de la sécurité féminin, pour les occasions spéciales."
	icon_state = "hos_parade_fem"
	inhand_icon_state = "r_suit"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/head_of_security/formal
	desc = "L'insigne sur cet uniforme vous dit que cet uniforme appartient au chef de la sécurité."
	name = "uniforme formel du chef de la sécurité"
	icon_state = "hosblueclothes"
	inhand_icon_state = null
	alt_covers_chest = TRUE

/*
 *Spacepol
 */

/obj/item/clothing/under/rank/security/officer/spacepol
	name = "uniforme de police"
	desc = "L'espace n'est pas contrôlé par les mégacorporations, les planètes ou les pirates sont sous la juridiction de Spacepol."
	icon_state = "spacepol"
	inhand_icon_state = null
	can_adjust = FALSE
	armor_type = /datum/armor/sec_uniform_spacepol

/datum/armor/sec_uniform_spacepol
	fire = 10
	acid = 10
	melee = 10

/obj/item/clothing/under/rank/prisoner
	name = "tenue de prisonnier"
	desc = "Une tenue standardisée pour les prisonniers de Nanotrasen. Ses capteurs de combinaison sont bloqués en position \"Entièrement activé\"."
	icon_state = "jumpsuit"
	icon_preview = 'icons/obj/previews.dmi'
	icon_state_preview = "prisonsuit"
	inhand_icon_state = "jumpsuit"
	greyscale_colors = "#ff8300"
	greyscale_config = /datum/greyscale_config/jumpsuit_prison
	greyscale_config_inhand_left = /datum/greyscale_config/jumpsuit_prison_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/jumpsuit_prison_inhand_right
	greyscale_config_worn = /datum/greyscale_config/jumpsuit_prison_worn
	has_sensor = LOCKED_SENSORS
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/prisoner/skirt
	name = "jupe de prisonnier"
	desc = "Une tenue standardisée pour les prisonniers de Nanotrasen. Ses capteurs de combinaison sont bloqués en position \"Entièrement activé\"."
	icon_preview = 'icons/obj/previews.dmi'
	icon_state_preview = "prisonskirt"
	greyscale_colors = "#ff8300"
	greyscale_config = /datum/greyscale_config/jumpsuit_prison
	greyscale_config_inhand_left = /datum/greyscale_config/jumpsuit_prison_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/jumpsuit_prison_inhand_right
	greyscale_config_worn = /datum/greyscale_config/jumpsuit_prison_worn
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/officer/beatcop
	name = "Uniforme de policier de l'espace"
	desc = "Un uniforme de police souvent trouvé dans les files d'attente des magasins de beignets."
	icon_state = "spacepolice_families"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/detective/disco
	name = "uniforme de policier superstar"
	desc = "Une tenue fait de pantalons évasés et d'une chemise sale qui aurait pu être chic avant que quelqu'un ne pisse dans les aisselles. C'est la tenue d'une superstar."
	icon_state = "jamrock_suit"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/detective/kim
	name = "tenue aerostatique"
	desc = "Une tenue aérostique, professionnelle, confortable et curieusement autoritaire."
	icon_state = "aerostatic_suit"
	inhand_icon_state = null
	can_adjust = FALSE
