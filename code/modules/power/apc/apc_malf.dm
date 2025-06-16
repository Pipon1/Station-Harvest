/obj/machinery/power/apc/proc/get_malf_status(mob/living/silicon/ai/malf)
	if(!istype(malf) || !malf.malf_picker)
		return APC_AI_NO_MALF
	if(malfai != (malf.parent || malf))
		return APC_AI_NO_HACK
	if(occupier == malf)
		return APC_AI_HACK_SHUNT_HERE
	if(istype(malf.loc, /obj/machinery/power/apc))
		return APC_AI_HACK_SHUNT_ANOTHER
	return APC_AI_HACK_NO_SHUNT

/obj/machinery/power/apc/proc/malfhack(mob/living/silicon/ai/malf)
	if(!istype(malf))
		return
	if(get_malf_status(malf) != 1)
		return
	if(malf.malfhacking)
		to_chat(malf, span_warning("Vous êtes déja entrain de pirater un CEL !"))
		return
	to_chat(malf, span_notice("Vous commencez à pirater les systèmes du CEL. Cela va prendre du temps et vous ne pourrez pas pérfomer d'autre actions pendant ce processus."))
	malf.malfhack = src
	malf.malfhacking = addtimer(CALLBACK(malf, TYPE_PROC_REF(/mob/living/silicon/ai/, malfhacked), src), 600, TIMER_STOPPABLE)

	var/atom/movable/screen/alert/hackingapc/hacking_apc
	hacking_apc = malf.throw_alert(ALERT_HACKING_APC, /atom/movable/screen/alert/hackingapc)
	hacking_apc.target = src

/obj/machinery/power/apc/proc/malfoccupy(mob/living/silicon/ai/malf)
	if(!istype(malf))
		return
	if(istype(malf.loc, /obj/machinery/power/apc)) // Already in an APC
		to_chat(malf, span_warning("Vous devez quitter votre CEL actuel !"))
		return
	if(!malf.can_shunt)
		to_chat(malf, span_warning("Vous ne pouvez pas transférer le coeur !"))
		return
	if(!is_station_level(z))
		return
	malf.ShutOffDoomsdayDevice()
	occupier = new /mob/living/silicon/ai(src, malf.laws, malf) //DEAR GOD WHY? //IKR????
	occupier.adjustOxyLoss(malf.getOxyLoss())
	if(!findtext(occupier.name, "CEL Copier"))
		occupier.name = "[malf.name] CEL Copier"
	if(malf.parent)
		occupier.parent = malf.parent
	else
		occupier.parent = malf
	malf.shunted = TRUE
	occupier.eyeobj.name = "[occupier.name] (Oeil de l'IA)"
	if(malf.parent)
		qdel(malf)
	for(var/obj/item/pinpointer/nuke/disk_pinpointers in GLOB.pinpointer_list)
		disk_pinpointers.switch_mode_to(TRACK_MALF_AI) //Pinpointer will track the shunted AI
	var/datum/action/innate/core_return/return_action = new
	return_action.Grant(occupier)
	occupier.cancel_camera()

/obj/machinery/power/apc/proc/malfvacate(forced)
	if(!occupier)
		return
	if(occupier.parent && occupier.parent.stat != DEAD)
		occupier.mind.transfer_to(occupier.parent)
		occupier.parent.shunted = FALSE
		occupier.parent.setOxyLoss(occupier.getOxyLoss())
		occupier.parent.cancel_camera()
		qdel(occupier)
		return
	to_chat(occupier, span_danger("Coeur primaire endommagé, il n'est pas possible de retourner au coeur primaire."))
	if(forced)
		occupier.forceMove(drop_location())
		INVOKE_ASYNC(occupier, TYPE_PROC_REF(/mob/living, death))
		occupier.gib()

	if(!occupier.nuking) //Pinpointers go back to tracking the nuke disk, as long as the AI (somehow) isn't mid-nuking.
		for(var/obj/item/pinpointer/nuke/disk_pinpointers in GLOB.pinpointer_list)
			disk_pinpointers.switch_mode_to(TRACK_NUKE_DISK)
			disk_pinpointers.alert = FALSE

/obj/machinery/power/apc/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	if(card.AI)
		to_chat(user, span_warning("[card] est déja occupé !"))
		return
	if(!occupier)
		to_chat(user, span_warning("Il n'y a rien à transféré dans [src] !"))
		return
	if(!occupier.mind || !occupier.client)
		to_chat(user, span_warning("[occupier] est soit innactif, soit détruit !"))
		return
	if(!occupier.parent.stat)
		to_chat(user, span_warning("[occupier] refuse toutes les tentatives de transfert !") )
		return
	if(transfer_in_progress)
		to_chat(user, span_warning("Il y'a déja un transfert en cours !"))
		return
	if(interaction != AI_TRANS_TO_CARD || occupier.stat)
		return
	var/turf/user_turf = get_turf(user)
	if(!user_turf)
		return
	transfer_in_progress = TRUE
	user.visible_message(span_notice("[user] enfonce la [card] dans [src]..."), span_notice("Processus de transfert initié. Requête d'aprobation envoyé à l'IA..."))
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	SEND_SOUND(occupier, sound('sound/misc/notice2.ogg')) //To alert the AI that someone's trying to card them if they're tabbed out
	if(tgui_alert(occupier, "[user] essaie de vous transférer dans une [card.name]. Consentez-vous au transfert ?", "Transfert CEL", list("Oui - Transferez Niu", "Non - Gardez moi ici")) == "Non - Gardez moi ici")
		to_chat(user, span_danger("L'IA a refusé le requête de transfert. Processus annulé."))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, TRUE)
		transfer_in_progress = FALSE
		return
	if(user.loc != user_turf)
		to_chat(user, span_danger("La position a été modifiée. Processus annulé."))
		to_chat(occupier, span_warning("[user] a été déplacé ! Transfert annulé."))
		transfer_in_progress = FALSE
		return
	to_chat(user, span_notice("L'IA a accepté à la requête. Transfert de l'ia en cours..."))
	to_chat(occupier, span_notice("Le transfert est en cours. Vous serez pprochainement déplacé dans la [card]."))
	if(!do_after(user, 50, target = src))
		to_chat(occupier, span_warning("[user] a été interrompu ! Transfert annulé."))
		transfer_in_progress = FALSE
		return
	if(!occupier || !card)
		transfer_in_progress = FALSE
		return
	user.visible_message(span_notice("[user] a transféré [occupier] à [card] !"), span_notice("Transfert complet ! [occupier] est maintenant stocké dans la [card]."))
	to_chat(occupier, span_notice("Transfert complété ! Vous êtes maintenant stocké dans la [card.name] de [user]."))
	occupier.forceMove(card)
	card.AI = occupier
	occupier.parent.shunted = FALSE
	occupier.cancel_camera()
	occupier = null
	transfer_in_progress = FALSE
	return
