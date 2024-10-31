/datum/action/shut_eyes_closed
	name = "Toggle Eyes Closed"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "adjust_vision"
	desc = "Close your eyes shut and allow the world to vanish before you!"
	var/list/sources = list()

/datum/action/shut_eyes_closed/New(Target, granted_source)
	. = ..()
	sources = list(granted_source)

/datum/action/shut_eyes_closed/proc/add_source(granted_source)
	sources |= granted_source

/datum/action/shut_eyes_closed/proc/remove_source(granted_source)
	sources -= granted_source
	if(length(sources))
		return
	Remove(owner)
	qdel(src)

/// when the button is pressed you will close your eyes by gaining the blind trait, and then be able to remove it again if the blind trait is from this quirk
/datum/action/shut_eyes_closed/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return
	if(!isliving(owner))
		return
	var/mob/living/eye_controller = owner
	if(eye_controller.is_blind_from(SHUT_EYES_CLOSED))
		eye_controller.cure_blind(SHUT_EYES_CLOSED)
	else
		eye_controller.become_blind(SHUT_EYES_CLOSED)

/// allows people who gain phobias from quirks, brain traumas, or being sacrificed to shut their eyes
/datum/brain_trauma/mild/phobia/on_gain()
	. = ..()
	owner.allow_eye_control("[name]-[phobia_type]")

/datum/brain_trauma/mild/phobia/on_lose(silent)
	. = ..()
	owner.remove_eye_control("[name]-[phobia_type]")


/mob/living/proc/allow_eye_control(source)
	var/datum/action/shut_eyes_closed/action = locate() in actions
	if(action)
		action.add_source(source)
	else
		action = new (src, source)
		action.Grant(src)

/mob/living/proc/remove_eye_control(source)
	var/datum/action/shut_eyes_closed/action = locate() in actions
	if(!action)
		return
	action.remove_source(source)
