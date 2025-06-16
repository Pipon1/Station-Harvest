#define PAPERS_PER_OVERLAY 8
#define PAPER_OVERLAY_PIXEL_SHIFT 2
/obj/item/paper_bin
	name = "rack à papier"
	desc = "Contient tout le papier dont vous pourriez rêver."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin0"
	inhand_icon_state = "sheet-metal"
	lefthand_file = 'icons/mob/inhands/items/sheets_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/sheets_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 3
	throw_range = 7
	pressure_resistance = 8
	var/papertype = /obj/item/paper
	var/total_paper = 30
	var/list/paper_stack = list()
	var/obj/item/pen/bin_pen
	///Overlay of the pen on top of the bin.
	var/mutable_appearance/pen_overlay
	///Name of icon that goes over the paper overlays.
	var/bin_overlay_string = "paper_bin_overlay"
	///Overlay that goes over the paper overlays.
	var/mutable_appearance/bin_overlay

/obj/item/paper_bin/Initialize(mapload)
	. = ..()
	interaction_flags_item &= ~INTERACT_ITEM_ATTACK_HAND_PICKUP
	AddElement(/datum/element/drag_pickup)
	if(mapload)
		var/obj/item/pen/pen = locate(/obj/item/pen) in loc
		if(pen && !bin_pen)
			pen.forceMove(src)
			bin_pen = pen
	update_appearance()

/obj/item/paper_bin/Destroy()
	QDEL_LIST(paper_stack)
	return ..()

/// Returns a fresh piece of paper
/obj/item/paper_bin/proc/generate_paper()
	var/obj/item/paper/paper = new papertype
	if(check_holidays(APRIL_FOOLS))
		if(prob(30))
			paper.add_raw_text("<font face=\"[CRAYON_FONT]\" color=\"red\"><b>POUET POUET POUET POUET POUET POUET POUET<br>POUEEEEEEEEEEEEEEEEEEEEET<br>POISSON D'AVRIL</b></font>")
			paper.AddElement(/datum/element/honkspam)
			paper.update_appearance()
	return paper

/obj/item/paper_bin/dump_contents(atom/droppoint, collapse = FALSE)
	if(!droppoint)
		droppoint = drop_location()
	if(collapse)
		visible_message(span_warning("Le tas de papier s'éfondre !"))
	for(var/atom/movable/movable_atom in contents)
		movable_atom.forceMove(droppoint)
		if(!movable_atom.pixel_y)
			movable_atom.pixel_y = rand(-3,3)
		if(!movable_atom.pixel_x)
			movable_atom.pixel_x = rand(-3,3)
	update_appearance()

/obj/item/paper_bin/fire_act(exposed_temperature, exposed_volume)
	if(total_paper > 0)
		total_paper = 0
		QDEL_LIST(paper_stack)
		update_appearance()

	..()

/obj/item/paper_bin/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/paper_bin/attack_hand(mob/user, list/modifiers)
	if(isliving(user))
		var/mob/living/living_mob = user
		if(!(living_mob.mobility_flags & MOBILITY_PICKUP))
			return
	user.changeNext_move(CLICK_CD_RAPID)
	if(at_overlay_limit())
		dump_contents(drop_location(), TRUE)
		return
	if(bin_pen)
		var/obj/item/pen/pen = bin_pen
		pen.add_fingerprint(user)
		pen.forceMove(user.loc)
		user.put_in_hands(pen)
		to_chat(user, span_notice("vous sortez le [pen] du [src]."))
		bin_pen = null
		update_appearance()
	else if(total_paper > 0)
		var/obj/item/paper/top_paper = pop(paper_stack) || generate_paper()
		total_paper -= 1
		top_paper.add_fingerprint(user)
		top_paper.forceMove(user.loc)
		user.put_in_hands(top_paper)
		to_chat(user, span_notice("vous prenez le [top_paper] du [src]."))
		update_appearance()
	else
		to_chat(user, span_warning("[src] est vide !"))
	add_fingerprint(user)
	return ..()

/obj/item/paper_bin/attackby(obj/item/I, mob/user, params)
	if(at_overlay_limit())
		dump_contents(drop_location(), TRUE)
		return
	if(istype(I, /obj/item/paper))
		var/obj/item/paper/paper = I
		if(!user.transferItemToLoc(paper, src))
			return
		to_chat(user, span_notice("Vous posez le [paper] dans [src]."))
		paper_stack += paper
		total_paper += 1
		update_appearance()
	else if(istype(I, /obj/item/pen) && !bin_pen)
		var/obj/item/pen/pen = I
		if(!user.transferItemToLoc(pen, src))
			return
		to_chat(user, span_notice("Vous placez le [pen] dans [src]."))
		bin_pen = pen
		update_appearance()
	else
		return ..()

/obj/item/paper_bin/proc/at_overlay_limit()
	return overlays.len >= MAX_ATOM_OVERLAYS - 1

/obj/item/paper_bin/proc/remove_paper(amount = 1)
	var/obj/item/paper/top_paper = pop(paper_stack)
	if(top_paper)
		qdel(top_paper)
	total_paper -= amount

/obj/item/paper_bin/examine(mob/user)
	. = ..()
	if(total_paper)
		. += "ça contient [total_paper > 1 ? "[total_paper] papiers" : "un papier"]."
	else
		. += "ça ne contient rien."

/obj/item/paper_bin/update_icon_state()
	if(total_paper < 1)
		icon_state = "paper_bin0"
	else
		icon_state = "[initial(icon_state)]"
	return ..()

/obj/item/paper_bin/update_overlays()
	. = ..()

	var/static/obj/item/paper/reference_paper
	if (isnull(reference_paper))
		reference_paper = new /obj/item/paper

	if(bin_pen)
		pen_overlay = mutable_appearance(bin_pen.icon, bin_pen.icon_state)

	if(!bin_overlay)
		bin_overlay = mutable_appearance(icon, bin_overlay_string)

	if(total_paper > 0)
		if(total_paper > length(paper_stack))
			SET_PLANE_EXPLICIT(reference_paper, initial(reference_paper.plane), src)
			reference_paper.update_appearance() // Ensures all our overlays are on the right plane
		for(var/paper_number in 1 to total_paper)
			if(paper_number != total_paper && paper_number % PAPERS_PER_OVERLAY != 0) //only top paper and every nth paper get overlays
				continue

			var/obj/item/paper/current_paper = paper_number > (total_paper - paper_stack.len) \
				? paper_stack[paper_stack.len - (total_paper - paper_number + 1) + 1] \
				: reference_paper

			var/mutable_appearance/paper_overlay = mutable_appearance(current_paper.icon, current_paper.icon_state)
			paper_overlay.color = current_paper.color
			paper_overlay.pixel_z = paper_number/PAPERS_PER_OVERLAY - PAPER_OVERLAY_PIXEL_SHIFT //gives the illusion of stacking
			. += paper_overlay
			if(paper_number == total_paper) //this is our top paper
				. += current_paper.overlays //add overlays only for top paper
				if(istype(src, /obj/item/paper_bin/bundlenatural))
					bin_overlay.pixel_z = paper_overlay.pixel_z //keeps binding centred on stack
				if(bin_pen)
					pen_overlay.pixel_z = paper_overlay.pixel_z //keeps pen on top of stack
		. += bin_overlay

	if(bin_pen)
		. += pen_overlay

/obj/item/paper_bin/construction
	name = "rack à papier de construction"
	desc = "Contient tous le papier dont vous aurez besoin... EN COULEUR CETTE FOIS !"
	papertype = /obj/item/paper/construction

/obj/item/paper_bin/bundlenatural
	name = "tas de papier naturel"
	desc = "Un tas de papier créer en utilisant des méthodes traditionnel."
	icon_state = "paper_stack"
	papertype = /obj/item/paper/natural
	resistance_flags = FLAMMABLE
	bin_overlay_string = "paper_bundle_overlay"
	///Cable this bundle is held together with.
	var/obj/item/stack/cable_coil/binding_cable

/obj/item/paper_bin/bundlenatural/Initialize(mapload)
	binding_cable = new(src, 2)
	binding_cable.set_cable_color(CABLE_COLOR_BROWN)
	binding_cable.desc += " Non-naturel."
	return ..()

/obj/item/paper_bin/bundlenatural/dump_contents(atom/droppoint)
	. = ..()
	qdel(src)

/obj/item/paper_bin/bundlenatural/update_overlays()
	bin_overlay = mutable_appearance(icon, bin_overlay_string)
	bin_overlay.color = binding_cable.color
	return ..()

/obj/item/paper_bin/bundlenatural/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(total_paper == 0)
		deconstruct(FALSE)

/obj/item/paper_bin/bundlenatural/deconstruct(disassembled)
	dump_contents()
	return ..()

/obj/item/paper_bin/bundlenatural/fire_act(exposed_temperature, exposed_volume)
	qdel(src)

/obj/item/paper_bin/bundlenatural/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/paper/carbon))
		to_chat(user, span_warning("[W] ne peut pas rentrer dans [src]."))
		return
	if(W.get_sharpness())
		if(W.use_tool(src, user, 1 SECONDS))
			to_chat(user, span_notice("Vous coupez le câble de [src]."))
			deconstruct(TRUE)
	else
		..()

/obj/item/paper_bin/carbon
	name = "rack à papier en carbon"
	desc = "Contient tout le papier dont vous pouvez rêver, en double !"
	icon_state = "paper_bin_carbon0"
	papertype = /obj/item/paper/carbon
	bin_overlay_string = "paper_bin_carbon_overlay"

#undef PAPERS_PER_OVERLAY
#undef PAPER_OVERLAY_PIXEL_SHIFT
