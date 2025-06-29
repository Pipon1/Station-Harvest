/datum/job/cargo_technician
	title = JOB_CARGO_TECHNICIAN
	description = "Distribuez les commandes aux départements qui les ont demandés, \
		collectez les caisses vides, chargez et déchargez la navette d'approvisionnement, \
		renvoyez des contrats."
	department_head = list(JOB_QUARTERMASTER)
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 3
	supervisors = SUPERVISOR_QM
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "CARGO_TECHNICIAN"

	outfit = /datum/outfit/job/cargo_tech
	plasmaman_outfit = /datum/outfit/plasmaman/cargo

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_CAR
	display_order = JOB_DISPLAY_ORDER_CARGO_TECHNICIAN
	bounty_types = CIV_JOB_RANDOM
	departments_list = list(
		/datum/job_department/cargo,
		)

	family_heirlooms = list(/obj/item/clipboard)

	mail_goodies = list(
		/obj/item/pizzabox = 10,
		/obj/item/stack/sheet/mineral/gold = 5,
		/obj/item/stack/sheet/mineral/uranium = 4,
		/obj/item/stack/sheet/mineral/diamond = 3,
		/obj/item/gun/ballistic/rifle/boltaction = 1,
		/obj/item/gun/ballistic/automatic/wt550 = 1,
	)
	rpg_title = "Merchantman"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/cargo_tech
	name = "Cargo Technician"
	jobtype = /datum/job/cargo_technician

	backpack_contents = list(
		/obj/item/boxcutter = 1,
	)
	id_trim = /datum/id_trim/job/cargo_technician
	uniform = /obj/item/clothing/under/rank/cargo/tech
	belt = /obj/item/modular_computer/pda/cargo
	ears = /obj/item/radio/headset/headset_cargo
	l_hand = /obj/item/universal_scanner

/datum/outfit/job/cargo_tech/mod
	name = "Cargo Technician (MODsuit)"

	back = /obj/item/mod/control/pre_equipped/loader
