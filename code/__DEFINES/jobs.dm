#define JOB_AVAILABLE 0
#define JOB_UNAVAILABLE_GENERIC 1
#define JOB_UNAVAILABLE_BANNED 2
#define JOB_UNAVAILABLE_PLAYTIME 3
#define JOB_UNAVAILABLE_ACCOUNTAGE 4
#define JOB_UNAVAILABLE_SLOTFULL 5
/// Job unavailable due to incompatibility with an antag role.
#define JOB_UNAVAILABLE_ANTAG_INCOMPAT 6

/// Used when the `get_job_unavailable_error_message` proc can't make sense of a given code.
#define GENERIC_JOB_UNAVAILABLE_ERROR "Error: Unknown job availability."

#define DEFAULT_RELIGION "Christianity"
#define DEFAULT_DEITY "Space Jesus"
#define DEFAULT_BIBLE "Default Bible Name"
#define DEFAULT_BIBLE_REPLACE(religion) "The Holy Book of [religion]"

#define JOB_DISPLAY_ORDER_DEFAULT 0


/**
 * =======================
 * WARNING WARNING WARNING
 * WARNING WARNING WARNING
 * WARNING WARNING WARNING
 * =======================
 * These names are used as keys in many locations in the database
 * you cannot change them trivially without breaking job bans and
 * role time tracking, if you do this and get it wrong you will die
 * and it will hurt the entire time
 */

//No department
#define JOB_ASSISTANT "Assistant"
#define JOB_PRISONER "Prisonnier"
//Command
#define JOB_CAPTAIN "Capitaine"
#define JOB_HEAD_OF_PERSONNEL "Chef du personnel"
#define JOB_HEAD_OF_SECURITY "Chef de la sécurité"
#define JOB_RESEARCH_DIRECTOR "Directeur des recherches"
#define JOB_CHIEF_ENGINEER "Chef ingénieur"
#define JOB_CHIEF_MEDICAL_OFFICER "Chef médecin"
//Silicon
#define JOB_AI "IA"
#define JOB_CYBORG "Cyborg"
#define JOB_PERSONAL_AI "IA personnelle"
//Security
#define JOB_WARDEN "Gardien"
#define JOB_DETECTIVE "Détective"
#define JOB_SECURITY_OFFICER "Officier de sécurité"
#define JOB_SECURITY_OFFICER_MEDICAL "Officier de sécurité (Médical)"
#define JOB_SECURITY_OFFICER_ENGINEERING "Officier de sécurité (Ingénierie)"
#define JOB_SECURITY_OFFICER_SCIENCE "Officier de sécurité (Recherche)"
#define JOB_SECURITY_OFFICER_SUPPLY "Officier de sécurité (Cargo)"
//Engineering
#define JOB_STATION_ENGINEER "Ingénieur technique"
#define JOB_ATMOSPHERIC_TECHNICIAN "Technicien atmosphérique"
//Medical
#define JOB_MEDICAL_DOCTOR "Médecin"
#define JOB_PARAMEDIC "Brancardier"
#define JOB_CHEMIST "Chimiste"
#define JOB_VIROLOGIST "Virologue"
//Science
#define JOB_SCIENTIST "Scientifique"
#define JOB_ROBOTICIST "Roboticien"
#define JOB_GENETICIST "Généticien"
//Supply
#define JOB_QUARTERMASTER "Contre-maître"
#define JOB_CARGO_TECHNICIAN "Technicien cargo"
#define JOB_SHAFT_MINER "Mineur"
//Service
#define JOB_BARTENDER "Barman"
#define JOB_BOTANIST "Botaniste"
#define JOB_COOK "Chef cuistot"
#define JOB_JANITOR "Concierge"
#define JOB_CLOWN "Clown"
#define JOB_MIME "Mime"
#define JOB_CURATOR "Conservateur"
#define JOB_LAWYER "Avocat"
#define JOB_CHAPLAIN "Chapelain"
#define JOB_PSYCHOLOGIST "Psychiatre"
//ERTs
#define JOB_ERT_DEATHSQUAD "Commando de la mort"
#define JOB_ERT_COMMANDER "Commandant de l'Equipe de Réponse aux Urgences"
#define JOB_ERT_OFFICER "Officier de sécurité de l'Equipe de Réponse aux Urgences"
#define JOB_ERT_ENGINEER "Ingénieur de l'Equipe de Réponse aux Urgences"
#define JOB_ERT_MEDICAL_DOCTOR "Médecin de l'Equipe de Réponse aux Urgences"
#define JOB_ERT_CHAPLAIN "Prêtre de l'Equipe de Réponse aux Urgences"
#define JOB_ERT_JANITOR "Concierge de l'Equipe de Réponse aux Urgences"
#define JOB_ERT_CLOWN "Officier de divertissement de l'Equipe de Réponse aux Urgences"
//CentCom
#define JOB_CENTCOM "Haut Commandant"
#define JOB_CENTCOM_OFFICIAL "Officier de CentCom"
#define JOB_CENTCOM_ADMIRAL "Amiral"
#define JOB_CENTCOM_COMMANDER "Commandant de CentCom"
#define JOB_CENTCOM_VIP "Invité VIP"
#define JOB_CENTCOM_BARTENDER "Barman de CentCom"
#define JOB_CENTCOM_CUSTODIAN "Gardien"
#define JOB_CENTCOM_THUNDERDOME_OVERSEER "Surveillant du Thunderdome"
#define JOB_CENTCOM_MEDICAL_DOCTOR "Officier médical de CentCom"
#define JOB_CENTCOM_RESEARCH_OFFICER "Officier de recherche"
#define JOB_CENTCOM_SPECIAL_OFFICER "Officier des Forces Spéciales"
#define JOB_CENTCOM_PRIVATE_SECURITY "Force de Sécurité Privé"


#define JOB_DISPLAY_ORDER_ASSISTANT 1
#define JOB_DISPLAY_ORDER_CAPTAIN 2
#define JOB_DISPLAY_ORDER_HEAD_OF_PERSONNEL 3
#define JOB_DISPLAY_ORDER_BARTENDER 4
#define JOB_DISPLAY_ORDER_BOTANIST 5
#define JOB_DISPLAY_ORDER_COOK 6
#define JOB_DISPLAY_ORDER_JANITOR 7
#define JOB_DISPLAY_ORDER_CLOWN 8
#define JOB_DISPLAY_ORDER_MIME 9
#define JOB_DISPLAY_ORDER_CURATOR 10
#define JOB_DISPLAY_ORDER_LAWYER 11
#define JOB_DISPLAY_ORDER_CHAPLAIN 12
#define JOB_DISPLAY_ORDER_PSYCHOLOGIST 13
#define JOB_DISPLAY_ORDER_AI 14
#define JOB_DISPLAY_ORDER_CYBORG 15
#define JOB_DISPLAY_ORDER_CHIEF_ENGINEER 16
#define JOB_DISPLAY_ORDER_STATION_ENGINEER 17
#define JOB_DISPLAY_ORDER_ATMOSPHERIC_TECHNICIAN 18
#define JOB_DISPLAY_ORDER_QUARTERMASTER 19
#define JOB_DISPLAY_ORDER_CARGO_TECHNICIAN 20
#define JOB_DISPLAY_ORDER_SHAFT_MINER 21
#define JOB_DISPLAY_ORDER_CHIEF_MEDICAL_OFFICER 22
#define JOB_DISPLAY_ORDER_MEDICAL_DOCTOR 23
#define JOB_DISPLAY_ORDER_PARAMEDIC 24
#define JOB_DISPLAY_ORDER_CHEMIST 25
#define JOB_DISPLAY_ORDER_VIROLOGIST 26
#define JOB_DISPLAY_ORDER_RESEARCH_DIRECTOR 27
#define JOB_DISPLAY_ORDER_SCIENTIST 28
#define JOB_DISPLAY_ORDER_ROBOTICIST 29
#define JOB_DISPLAY_ORDER_GENETICIST 30
#define JOB_DISPLAY_ORDER_HEAD_OF_SECURITY 31
#define JOB_DISPLAY_ORDER_WARDEN 32
#define JOB_DISPLAY_ORDER_DETECTIVE 33
#define JOB_DISPLAY_ORDER_SECURITY_OFFICER 34
#define JOB_DISPLAY_ORDER_PRISONER 35


#define DEPARTMENT_UNASSIGNED "No Department"

#define DEPARTMENT_BITFLAG_SECURITY (1<<0)
#define DEPARTMENT_SECURITY "Security"
#define DEPARTMENT_BITFLAG_COMMAND (1<<1)
#define DEPARTMENT_COMMAND "Command"
#define DEPARTMENT_BITFLAG_SERVICE (1<<2)
#define DEPARTMENT_SERVICE "Service"
#define DEPARTMENT_BITFLAG_CARGO (1<<3)
#define DEPARTMENT_CARGO "Cargo"
#define DEPARTMENT_BITFLAG_ENGINEERING (1<<4)
#define DEPARTMENT_ENGINEERING "Engineering"
#define DEPARTMENT_BITFLAG_SCIENCE (1<<5)
#define DEPARTMENT_SCIENCE "Science"
#define DEPARTMENT_BITFLAG_MEDICAL (1<<6)
#define DEPARTMENT_MEDICAL "Medical"
#define DEPARTMENT_BITFLAG_SILICON (1<<7)
#define DEPARTMENT_SILICON "Silicon"
#define DEPARTMENT_BITFLAG_ASSISTANT (1<<8)
#define DEPARTMENT_ASSISTANT "Assistant"
#define DEPARTMENT_BITFLAG_CAPTAIN (1<<9)
#define DEPARTMENT_CAPTAIN "Captain"

/* Job datum job_flags */
/// Whether the mob is announced on arrival.
#define JOB_ANNOUNCE_ARRIVAL (1<<0)
/// Whether the mob is added to the crew manifest.
#define JOB_CREW_MANIFEST (1<<1)
/// Whether the mob is equipped through SSjob.EquipRank() on spawn.
#define JOB_EQUIP_RANK (1<<2)
/// Whether the job is considered a regular crew member of the station. Equipment such as AI and cyborgs not included.
#define JOB_CREW_MEMBER (1<<3)
/// Whether this job can be joined through the new_player menu.
#define JOB_NEW_PLAYER_JOINABLE (1<<4)
/// Whether this job appears in bold in the job menu.
#define JOB_BOLD_SELECT_TEXT (1<<5)
/// Reopens this position if we lose the player at roundstart.
#define JOB_REOPEN_ON_ROUNDSTART_LOSS (1<<6)
/// If the player with this job can have quirks assigned to him or not. Relevant for new player joinable jobs and roundstart antags.
#define JOB_ASSIGN_QUIRKS (1<<7)
/// Whether this job can be an intern.
#define JOB_CAN_BE_INTERN (1<<8)

#define FACTION_NONE "None"
#define FACTION_STATION "Station"

// Variable macros used to declare who is the supervisor for a given job, announced to the player when they join as any given job.
#define SUPERVISOR_CAPTAIN "the Captain"
#define SUPERVISOR_CE "the Chief Engineer"
#define SUPERVISOR_CMO "the Chief Medical Officer"
#define SUPERVISOR_HOP "the Head of Personnel"
#define SUPERVISOR_HOS "the Head of Security"
#define SUPERVISOR_QM "the Quartermaster"
#define SUPERVISOR_RD "the Research Director"
