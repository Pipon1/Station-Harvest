//CONTAINS: Evidence bags

/obj/item/evidencebag
	name = "sac à preuves"
	desc = "Un sac à preuves vide."
	icon = 'icons/obj/storage/storage.dmi'
	icon_state = "evidenceobj"
	inhand_icon_state = ""
	w_class = WEIGHT_CLASS_TINY

/obj/item/evidencebag/afterattack(obj/item/I, mob/user,proximity)
	. = ..()
	if(!proximity || loc == I)
		return
	evidencebagEquip(I, user)
	return . | AFTERATTACK_PROCESSED_ITEM

/obj/item/evidencebag/attackby(obj/item/I, mob/user, params)
	if(evidencebagEquip(I, user))
		return 1

/obj/item/evidencebag/handle_atom_del(atom/A)
	cut_overlays()
	w_class = initial(w_class)
	icon_state = initial(icon_state)
	desc = initial(desc)

/obj/item/evidencebag/proc/evidencebagEquip(obj/item/I, mob/user)
	if(!istype(I) || I.anchored)
		return

	if(loc.atom_storage && I.atom_storage)
		to_chat(user, span_warning("Peu importe à quel point vous essayez, vous ne pouvez pas faire rentrer [I] dans [src]."))
		return TRUE //begone infinite storage ghosts, begone from me

	if(HAS_TRAIT(I, TRAIT_NO_STORAGE_INSERT))
		to_chat(user, span_warning("Peu importe à quel point vous essayez, vous ne pouvez pas faire rentrer [I] dans [src]."))
		return TRUE

	if(istype(I, /obj/item/evidencebag))
		to_chat(user, span_warning("Vous trouvez que mettre un sac à preuves dans un autre sac à preuves est un peu absurde."))
		return TRUE //now this is podracing

	if(loc in I.get_all_contents()) // fixes tg #39452, evidence bags could store their own location, causing I to be stored in the bag while being present inworld still, and able to be teleported when removed.
		to_chat(user, span_warning("Vous trouvez difficile de mettre [I] dans [src] alors qu'il est encore à l'intérieur !"))
		return

	if(I.w_class > WEIGHT_CLASS_NORMAL)
		to_chat(user, span_warning("[I] ne rentre pas dans [src] !"))
		return

	if(contents.len)
		to_chat(user, span_warning("[src] a deja quelque chose dedans."))
		return

	if(!isturf(I.loc)) //If it isn't on the floor. Do some checks to see if it's in our hands or a box. Otherwise give up.
		if(I.loc.atom_storage) //in a container.
			I.loc.atom_storage.remove_single(user, I, src)
		if(!user.dropItemToGround(I))
			return

	user.visible_message(span_notice("[user] met [I] dans [src]."), span_notice("Vous placez [I] à l'intérieur de [src]."),\
	span_hear("Vous entendez un bruit de plastique, comme si quelqu'un mettait quelque chose dans un sac en plastique."))

	icon_state = "evidence"

	var/mutable_appearance/in_evidence = new(I)
	in_evidence.plane = FLOAT_PLANE
	in_evidence.layer = FLOAT_LAYER
	in_evidence.pixel_x = 0
	in_evidence.pixel_y = 0
	add_overlay(in_evidence)
	add_overlay("evidence") //should look nicer for transparent stuff. not really that important, but hey.

	desc = "Un sac à preuves contenant [I]. [I.desc]"
	I.forceMove(src)
	w_class = I.w_class
	return 1

/obj/item/evidencebag/attack_self(mob/user)
	if(contents.len)
		var/obj/item/I = contents[1]
		user.visible_message(span_notice("[user] sort [I] de [src]."), span_notice("Vous prenez [I] de [src]."),\
		span_hear("Vous entendez un bruit de plastique, comme si quelqu'un sortait quelque chose dans un sac en plastique."))
		cut_overlays() //remove the overlays
		user.put_in_hands(I)
		w_class = WEIGHT_CLASS_TINY
		icon_state = "evidenceobj"
		desc = "Un sac à preuves vide."

	else
		to_chat(user, span_notice("[src] est vide."))
		icon_state = "evidenceobj"
	return

/obj/item/storage/box/evidence
	name = "boîte de sac à preuves"
	desc = "Une boite qui prétend contenir des sacs à preuves."

/obj/item/storage/box/evidence/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/evidencebag(src)
