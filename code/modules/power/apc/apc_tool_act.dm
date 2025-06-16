//attack with an item - open/close cover, insert cell, or (un)lock interface
/obj/machinery/power/apc/crowbar_act(mob/user, obj/item/crowbar)
	. = TRUE
	if((!opened && opened != APC_COVER_REMOVED) && !(machine_stat & BROKEN))
		if(coverlocked && !(machine_stat & MAINT)) // locked...
			balloon_alert(user, "le couvercle est vérouillé !")
			return
		else if(panel_open)
			balloon_alert(user, "les câbles empêchent l'ouverture !")
			return
		else
			opened = APC_COVER_OPENED
			update_appearance()
			return

	if((opened && has_electronics == APC_ELECTRONICS_SECURED) && !(machine_stat & BROKEN))
		opened = APC_COVER_CLOSED
		coverlocked = TRUE //closing cover relocks it
		balloon_alert(user, "le couvercle est maintenant vérouillé")
		update_appearance()
		return

	if(!opened || has_electronics != APC_ELECTRONICS_INSTALLED)
		return
	if(terminal)
		balloon_alert(user, "déconnectez les câbles !")
		return
	crowbar.play_tool_sound(src)
	if(!crowbar.use_tool(src, user, 50))
		return
	if(has_electronics != APC_ELECTRONICS_INSTALLED)
		return
	has_electronics = APC_ELECTRONICS_MISSING
	if(machine_stat & BROKEN)
		user.visible_message(span_notice("[user.name] casse la carte mère à l'intérieur de [name] !"), \
			span_hear("Vous entendez un crack."))
		balloon_alert(user, "la carte mère brulée casse")
		return
	else if(obj_flags & EMAGGED)
		obj_flags &= ~EMAGGED
		user.visible_message(span_notice("[user.name] jète la carte mère piratée !"))
		balloon_alert(user, "la carte mère piratée a été jetée")
		return
	else if(malfhack)
		user.visible_message(span_notice("[user.name] jète la carte mère reprogrammée !"))
		balloon_alert(user, "la carte mère reprogrammée a été jetée")
		malfai = null
		malfhack = 0
		return
	user.visible_message(span_notice("[user.name] retire la carte mère !"))
	balloon_alert(user, "la carte mère a été retirée")
	new /obj/item/electronics/apc(loc)
	return

/obj/machinery/power/apc/screwdriver_act(mob/living/user, obj/item/W)
	if(..())
		return TRUE
	. = TRUE

	if(!opened)
		if(obj_flags & EMAGGED)
			balloon_alert(user, "L'interface est cassé !")
			return
		toggle_panel_open()
		balloon_alert(user, "les câbles sont [panel_open ? "exposés" : "cachés"]")
		update_appearance()
		return

	if(cell)
		user.visible_message(span_notice("[user] retire la [cell] de [src] !"))
		balloon_alert(user, "la batterie a été retirée")
		var/turf/user_turf = get_turf(user)
		cell.forceMove(user_turf)
		cell.update_appearance()
		cell = null
		charging = APC_NOT_CHARGING
		update_appearance()
		return

	switch (has_electronics)
		if(APC_ELECTRONICS_INSTALLED)
			has_electronics = APC_ELECTRONICS_SECURED
			set_machine_stat(machine_stat & ~MAINT)
			W.play_tool_sound(src)
			balloon_alert(user, "carte mère attachée")
		if(APC_ELECTRONICS_SECURED)
			has_electronics = APC_ELECTRONICS_INSTALLED
			set_machine_stat(machine_stat | MAINT)
			W.play_tool_sound(src)
			balloon_alert(user, "carte mère détachée")
		else
			balloon_alert(user, "aucune carte mère !")
			return
	update_appearance()

/obj/machinery/power/apc/wirecutter_act(mob/living/user, obj/item/W)
	. = ..()
	if(terminal && opened)
		terminal.dismantle(user, W)
		return TRUE

/obj/machinery/power/apc/welder_act(mob/living/user, obj/item/welder)
	. = ..()
	if(!opened || has_electronics || terminal)
		return
	if(!welder.tool_start_check(user, amount=3))
		return
	user.visible_message(span_notice("[user.name] soude [src]."), \
						span_hear("Vous entendez de la soudure."))
	balloon_alert(user, "vous soudez la coque du CEL")
	if(!welder.use_tool(src, user, 50, volume=50, amount=3))
		return
	if((machine_stat & BROKEN) || opened == APC_COVER_REMOVED)
		new /obj/item/stack/sheet/iron(loc)
		user.visible_message(span_notice("[user.name] coupe [src] en morceau avec un [welder]."))
		balloon_alert(user, "vous avez désassemblé la coque cassée")
	else
		new /obj/item/wallframe/apc(loc)
		user.visible_message(span_notice("[user.name] arrache [src] du mur avec un [welder]."))
		balloon_alert(user, "vous arrachez [src] du mur")
	qdel(src)
	return TRUE

/obj/machinery/power/apc/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(!(the_rcd.upgrade & RCD_UPGRADE_SIMPLE_CIRCUITS))
		return FALSE

	if(!has_electronics)
		if(machine_stat & BROKEN)
			balloon_alert(user, "la coque est trop endommagée !")
			return FALSE
		return list("mode" = RCD_WALLFRAME, "delay" = 20, "cost" = 1)

	if(!cell)
		if(machine_stat & MAINT)
			balloon_alert(user, "aucune carte mère ! Vous ne pouvez pas installer la batterie !")
			return FALSE
		return list("mode" = RCD_WALLFRAME, "delay" = 50, "cost" = 10)

	balloon_alert(user, "le CEL possède déja une batterie et une carte mère !")
	return FALSE

/obj/machinery/power/apc/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	if(!(the_rcd.upgrade & RCD_UPGRADE_SIMPLE_CIRCUITS) || passed_mode != RCD_WALLFRAME)
		return FALSE

	if(!has_electronics)
		if(machine_stat & BROKEN)
			balloon_alert(user, "la coque est trop endommagée !")
			return
		user.visible_message(span_notice("[user] fabrique un circuit et le place dans [src]."))
		balloon_alert(user, "carte mère placée")
		has_electronics = TRUE
		locked = TRUE
		return TRUE

	if(!cell)
		if(machine_stat & MAINT)
			balloon_alert(user, "aucune carte mère ! Vous ne pouvez pas installer la batterie !")
			return FALSE
		var/obj/item/stock_parts/cell/crap/empty/C = new(src)
		C.forceMove(src)
		cell = C
		chargecount = 0
		user.visible_message(span_notice("[user] fabrique une petite batterie et la place dans [src]."), \
		span_warning("Votre [the_rcd.name] fait un petit ronronnement alors que vous créez et placez la petite baterie dans [src] !"))
		update_appearance()
		return TRUE

	balloon_alert(user, "le CEL possède déja une batterie et une carte mère !")
	return FALSE

/obj/machinery/power/apc/emag_act(mob/user)
	if((obj_flags & EMAGGED) || malfhack)
		return

	if(opened)
		balloon_alert(user, "fermez le couvercle !")
	else if(panel_open)
		balloon_alert(user, "fermez le couvercle !")
	else if(machine_stat & (BROKEN|MAINT))
		balloon_alert(user, "rien ne se passe !")
	else
		flick("apc-spark", src)
		playsound(src, SFX_SPARKS, 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		obj_flags |= EMAGGED
		locked = FALSE
		balloon_alert(user, "vous piratez le CEL")
		update_appearance()

// damage and destruction acts
/obj/machinery/power/apc/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		if(cell)
			cell.emp_act(severity)
		if(occupier)
			occupier.emp_act(severity)
	if(. & EMP_PROTECT_SELF)
		return
	lighting = APC_CHANNEL_OFF
	equipment = APC_CHANNEL_OFF
	environ = APC_CHANNEL_OFF
	update_appearance()
	update()
	addtimer(CALLBACK(src, PROC_REF(reset), APC_RESET_EMP), 600)

/obj/machinery/power/apc/proc/togglelock(mob/living/user)
	if(obj_flags & EMAGGED)
		balloon_alert(user, "l'interface est cassé !")
	else if(opened)
		balloon_alert(user, "fermez le couvercle !")
	else if(panel_open)
		balloon_alert(user, "fermez le couvercle !")
	else if(machine_stat & (BROKEN|MAINT))
		balloon_alert(user, "rien ne se passe !")
	else
		if(allowed(usr) && !wires.is_cut(WIRE_IDSCAN) && !malfhack && !remote_control_user)
			locked = !locked
			balloon_alert(user, locked ? "vérouillé" : "dévérouillé")
			update_appearance()
			if(!locked)
				ui_interact(user)
		else
			balloon_alert(user, "accès refusé !")
