/datum/keybinding/artificial_intelligence
	category = CATEGORY_AI
	weight = WEIGHT_AI

/datum/keybinding/artificial_intelligence/can_use(client/user)
	return isAI(user.mob)

/datum/keybinding/artificial_intelligence/reconnect
	hotkey_keys = list("-")
	name = "reconnect"
	full_name = "Se reconnecter a votre noyau"
	description = "Vous reconnecte à votre dernier noyau utilisé."
	keybind_signal = COMSIG_KB_SILICON_RECONNECT_DOWN

/datum/keybinding/artificial_intelligence/reconnect/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/silicon/ai/our_ai = user.mob
	our_ai.deploy_to_shell(our_ai.redeploy_action.last_used_shell)
	return TRUE
