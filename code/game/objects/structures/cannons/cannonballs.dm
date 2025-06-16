/obj/item/stack/cannonball
	name = "boulets de canon"
	desc = "Une pile de boulets de canon en plastacier. Les armes à poudre pour l'âge de l'espace !"
	icon_state = "cannonballs"
	base_icon_state = "cannonballs"
	max_amount = 14
	singular_name = "boulet de canon"
	merge_type = /obj/item/stack/cannonball
	throwforce = 10
	flags_1 = CONDUCT_1
	custom_materials = list(/datum/material/alloy/plasteel=MINERAL_MATERIAL_AMOUNT)
	resistance_flags = FIRE_PROOF
	throw_speed = 5
	throw_range = 3
	///the type of projectile this type of cannonball item turns into.
	var/obj/projectile/projectile_type = /obj/projectile/bullet/cannonball

/obj/item/stack/cannonball/update_icon_state()
	. = ..()
	icon_state = (amount == 1) ? "[base_icon_state]" : "[base_icon_state]_[min(amount, 14)]"

/obj/item/stack/cannonball/fourteen
	amount = 14

/obj/item/stack/cannonball/shellball
	name = "boulets explosifs"
	singular_name = "boulet explosif"
	desc = "Un boulet explosif anti-matériel. Fais des trous dans les murs pour une entrée facile."
	color = "#FF0000"
	merge_type = /obj/item/stack/cannonball/shellball
	projectile_type = /obj/projectile/bullet/cannonball/explosive

/obj/item/stack/cannonball/shellball/seven
	amount = 7

/obj/item/stack/cannonball/shellball/fourteen
	amount = 14

/obj/item/stack/cannonball/emp
	name = "boulets électromagnétiques"
	singular_name = "boulet électromagnétique"
	icon_state = "emp_cannonballs"
	base_icon_state = "emp_cannonballs"
	desc = "Un boulet composé de deux chambres qui se mélangent à l'impact, créant un champ électromagnétique chimique. Qu'est ce que cela veut dire? Qui sait? La piraterie moderner a perdue toute son âme avec ces machins technologiques."
	max_amount = 4
	merge_type = /obj/item/stack/cannonball/emp
	projectile_type = /obj/projectile/bullet/cannonball/emp

/obj/item/stack/cannonball/the_big_one
	name = "\"les grobs boulets\""
	singular_name = "\"le gros boulet\""
	desc = "Un montant insensé d'explosifs entassés dans un boulet géant. Le dernier boulet que vous tirerez jamais, en particulier parce qu'il ne restera plus rien après avoir tiré."
	max_amount = 5
	icon_state = "biggest_cannonballs"
	base_icon_state = "biggest_cannonballs"
	merge_type = /obj/item/stack/cannonball/the_big_one
	projectile_type = /obj/projectile/bullet/cannonball/biggest_one

/obj/item/stack/cannonball/the_big_one/five
	amount = 5

/obj/item/stack/cannonball/trashball
	name = "bouletss de déchets"
	singular_name = "boulet de déchet"
	desc = "Un aggrégat de déchets compactés ensemble. Ca fera office de boulet de canon, mais c'est peut être dangereux de l'utiliser dans un vrai cannon."
	max_amount = 4
	icon_state = "trashballs"
	base_icon_state = "trashballs"
	merge_type = /obj/item/stack/cannonball/trashball
	projectile_type = /obj/projectile/bullet/cannonball/trashball

/obj/item/stack/cannonball/trashball/four
	amount = 4
