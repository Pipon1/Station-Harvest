/datum/keybinding/movement
	category = CATEGORY_MOVEMENT
	weight = WEIGHT_HIGHEST

/datum/keybinding/movement/north
	hotkey_keys = list("W", "North")
	name = "North"
	full_name = "Se déplacer vers le nord"
	description = "Déplace votre personnage vers le nord"
	keybind_signal = COMSIG_KB_MOVEMENT_NORTH_DOWN

/datum/keybinding/movement/south
	hotkey_keys = list("S", "South")
	name = "South"
	full_name = "Se déplacer vers le sud"
	description = "Déplace votre personnage vers le sud"
	keybind_signal = COMSIG_KB_MOVEMENT_SOUTH_DOWN

/datum/keybinding/movement/west
	hotkey_keys = list("A", "West")
	name = "West"
	full_name = "Se déplacer vers l'ouest"
	description = "Déplace votre personnage vers l'ouest'"
	keybind_signal = COMSIG_KB_MOVEMENT_WEST_DOWN

/datum/keybinding/movement/east
	hotkey_keys = list("D", "East")
	name = "East"
	full_name = "Se déplacer vers l'Est"
	description = "Déplace votre personnage vers l'est"
	keybind_signal = COMSIG_KB_MOVEMENT_EAST_DOWN

/datum/keybinding/movement/zlevel_upwards
	hotkey_keys = list("Northeast") // PGUP
	name = "Upwards"
	full_name = "Se déplacer vers l'étage supérieur"
	description = "Déplace votre personnage vers l'étage supérieur si possible"
	keybind_signal = COMSIG_KB_MOVEMENT_ZLEVEL_MOVEUP_DOWN

/datum/keybinding/movement/zlevel_upwards/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.up()
	return TRUE

/datum/keybinding/movement/zlevel_downwards
	hotkey_keys = list("Southeast") // PGDOWN
	name = "Downwards"
	full_name = "Se déplacer vers l'étage inférieur"
	description = "Déplace votre personnage vers l'étage inférieur si possible"
	keybind_signal = COMSIG_KB_MOVEMENT_ZLEVEL_MOVEDOWN_DOWN

/datum/keybinding/movement/zlevel_downwards/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.down()
	return TRUE
