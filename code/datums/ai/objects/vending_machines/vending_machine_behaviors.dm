/datum/ai_behavior/vendor_crush
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT
	///Time before machine can untilt itself after tilting
	var/untilt_cooldown = 1 SECONDS
	///Time to telegraph and tilt over
	var/time_to_tilt = 0.8 SECONDS

/datum/ai_behavior/vendor_crush/setup(datum/ai_controller/controller, target_key)
	. = ..()
	set_movement_target(controller, controller.blackboard[target_key])

/datum/ai_behavior/vendor_crush/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	if(controller.blackboard[BB_VENDING_BUSY_TILTING])
		return

	controller.ai_movement.stop_moving_towards(controller)
	controller.set_blackboard_key(BB_VENDING_BUSY_TILTING, TRUE)
	var/turf/target_turf = get_turf(controller.blackboard[BB_VENDING_CURRENT_TARGET])
	new /obj/effect/temp_visual/telegraphing/vending_machine_tilt(target_turf)
	addtimer(CALLBACK(src, PROC_REF(tiltonmob), controller, target_turf), time_to_tilt)

/datum/ai_behavior/vendor_crush/proc/tiltonmob(datum/ai_controller/controller, turf/target_turf)
	var/obj/machinery/vending/vendor_pawn = controller.pawn
	if(vendor_pawn.tilt(target_turf)) //We hit something
		vendor_pawn.say(pick("Agrandi ça !", "Mange mon cul de métal !", "Tu veux goûter à mes produits ?", "SMASH!", "N'aimes tu pas ces prix écrasant ?"))
		controller.set_blackboard_key(BB_VENDING_LAST_HIT_SUCCESFUL, TRUE)
	else
		vendor_pawn.say(pick("Reviens ici !", "Ne veux tu pas mon amour bon marché ?"))
		controller.set_blackboard_key(BB_VENDING_LAST_HIT_SUCCESFUL, FALSE)
	finish_action(controller, TRUE)

/datum/ai_behavior/vendor_crush/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.set_blackboard_key(BB_VENDING_BUSY_TILTING, FALSE)
	controller.set_blackboard_key(BB_VENDING_UNTILT_COOLDOWN, world.time + untilt_cooldown)

/datum/ai_behavior/vendor_rise_up //what a gamer
	///Time before machine can tilt again after untilting if last hit was a success
	var/succes_tilt_cooldown = 5 SECONDS

/datum/ai_behavior/vendor_rise_up/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/obj/machinery/vending/vendor_pawn = controller.pawn
	vendor_pawn.visible_message(span_warning("[vendor_pawn] se redresse !"))
	if(controller.blackboard[BB_VENDING_LAST_HIT_SUCCESFUL])
		controller.set_blackboard_key(BB_VENDING_TILT_COOLDOWN, world.time + succes_tilt_cooldown)
	vendor_pawn.untilt()
	finish_action(controller, TRUE)
