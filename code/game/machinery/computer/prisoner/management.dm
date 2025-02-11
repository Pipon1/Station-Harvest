/obj/machinery/computer/prisoner/management
	name = "Ordinateur de gestion des prisonniers"
	desc = "Utilisé pour gérer les implants de loclisation des prisonniers."
	icon_screen = "explosive"
	icon_keyboard = "security_key"
	req_access = list(ACCESS_BRIG)
	light_color = COLOR_SOFT_RED
	var/id = 0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed
	circuit = /obj/item/circuitboard/computer/prisoner


/obj/machinery/computer/prisoner/management/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat = ""
	if(screen == 0)
		dat += "<HR><A href='?src=[REF(src)];lock=1'>{Connexion}</A>"
	else if(screen == 1)
		dat += "<H3>Gestion de carte d'identité de prisonnier</H3>"
		if(contained_id)
			dat += text("<A href='?src=[REF(src)];id=eject'>[contained_id]</A><br>")
			dat += text("Points collecté : [contained_id.points]. <A href='?src=[REF(src)];id=reset'>Réinitialiser.</A><br>")
			dat += text("But de carte : [contained_id.goal].  <A href='?src=[REF(src)];id=setgoal'>Définir </A><br>")
			dat += text("La loi spatiale recommande des quotas de 100 points par minute qu'ils serviraient normalement dans la prison.<BR>")
		else
			dat += text("<A href='?src=[REF(src)];id=insert'>Insérer la carte d'identité du prisonnier.</A><br>")
		dat += "<H3>Gestion des implants des prisonniers</H3>"
		dat += "<HR>Implants chimique<BR>"
		var/turf/current_turf = get_turf(src)
		for(var/obj/item/implant/chem/C in GLOB.tracked_chem_implants)
			var/turf/implant_turf = get_turf(C)
			if(!is_valid_z_level(current_turf, implant_turf))
				continue//Out of range
			if(!C.imp_in)
				continue
			dat += "Identité : [C.imp_in.name] | Quantitié restante : [C.reagents.total_volume] <BR>"
			dat += "| Injecter : "
			dat += "<A href='?src=[REF(src)];inject1=[REF(C)]'>(<font class='bad'>(1)</font>)</A>"
			dat += "<A href='?src=[REF(src)];inject5=[REF(C)]'>(<font class='bad'>(5)</font>)</A>"
			dat += "<A href='?src=[REF(src)];inject10=[REF(C)]'>(<font class='bad'>(10)</font>)</A><BR>"
			dat += "********************************<BR>"
		dat += "<HR>Implants de localisation<BR>"
		for(var/obj/item/implant/tracking/T in GLOB.tracked_implants)
			if(!isliving(T.imp_in))
				continue
			var/turf/implant_turf = get_turf(T)
			if(!is_valid_z_level(current_turf, implant_turf))
				continue//Out of range

			var/loc_display = "Unknown"
			var/mob/living/M = T.imp_in
			if(is_station_level(implant_turf.z) && !isspaceturf(M.loc))
				var/turf/mob_loc = get_turf(M)
				loc_display = mob_loc.loc

			dat += "Identité : [T.imp_in.name] | Position : [loc_display]<BR>"
			dat += "<A href='?src=[REF(src)];warn=[REF(T)]'>(<font class='bad'><i>Possesseur du message</i></font>)</A> |<BR>"
			dat += "********************************<BR>"
		dat += "<HR><A href='?src=[REF(src)];lock=1'>{Déconnexion}</A>"
	var/datum/browser/popup = new(user, "computer", "Ordinateur de gestion des prisonniers", 400, 500)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/computer/prisoner/management/attackby(obj/item/I, mob/user, params)
	if(isidcard(I))
		if(screen)
			id_insert(user)
		else
			to_chat(user, span_danger("Accès non-authorisé."))
	else
		return ..()

/obj/machinery/computer/prisoner/management/process()
	if(!..())
		src.updateDialog()
	return

/obj/machinery/computer/prisoner/management/Topic(href, href_list)
	if(..())
		return
	if(usr.contents.Find(src) || (in_range(src, usr) && isturf(loc)) || issilicon(usr))
		usr.set_machine(src)

		if(href_list["id"])
			if(href_list["id"] == "insert" && !contained_id)
				id_insert(usr)
			else if(contained_id)
				switch(href_list["id"])
					if("eject")
						id_eject(usr)
					if("reset")
						contained_id.points = 0
					if("setgoal")
						var/num = tgui_input_text(usr, "Entrer le but du prisonnier", "Prisoner Management", 1, 1000, 1)
						if(isnull(num))
							return
						contained_id.goal = round(num)
		else if(href_list["inject1"])
			var/obj/item/implant/I = locate(href_list["inject1"]) in GLOB.tracked_chem_implants
			if(I && istype(I))
				I.activate(1)
		else if(href_list["inject5"])
			var/obj/item/implant/I = locate(href_list["inject5"]) in GLOB.tracked_chem_implants
			if(I && istype(I))
				I.activate(5)
		else if(href_list["inject10"])
			var/obj/item/implant/I = locate(href_list["inject10"]) in GLOB.tracked_chem_implants
			if(I && istype(I))
				I.activate(10)

		else if(href_list["lock"])
			if(allowed(usr))
				screen = !screen
				playsound(src, 'sound/machines/terminal_on.ogg', 50, FALSE)
			else
				to_chat(usr, span_danger("Accès non-authorisé."))

		else if(href_list["warn"])
			var/warning = tgui_input_text(usr, "Entrer votre message ici", "Messaging")
			if(!warning)
				return
			var/obj/item/implant/I = locate(href_list["warn"]) in GLOB.tracked_implants
			if(I && istype(I) && I.imp_in)
				var/mob/living/R = I.imp_in
				to_chat(R, span_hear("Vous entendez une voix dans votre tête qui vous dit : '[warning]'"))
				log_directed_talk(usr, R, warning, LOG_SAY, "Message d'un implant")

		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return
