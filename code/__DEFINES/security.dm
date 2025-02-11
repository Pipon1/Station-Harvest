
// CATEGORY HEADERS

/// Fingerpints detected
#define DETSCAN_CATEGORY_FINGERS "Des empreintes digitale"
/// Displays any bloodprints found and their uefi
#define DETSCAN_CATEGORY_BLOOD "Du sang"
/// Clothing and glove fibers
#define DETSCAN_CATEGORY_FIBER "Des fibres"
/// Liquids detected
#define DETSCAN_CATEGORY_DRINK "Des liquides"
/// ID Access
#define DETSCAN_CATEGORY_ACCESS "Des niveaux d'accès"

// The categories below do not have hard rules on what info is displayed, and are for categorizing info thematically.

/// Generic extra information category
#define DETSCAN_CATEGORY_NOTES "Notes additionnelles"
/// Attributes that might be illegal, but don't have ties to syndicate/aren't exclusively produced by them
#define DETSCAN_CATEGORY_ILLEGAL "Technologie illégale"
/// The emags and other in-house technology from the syndicate
#define DETSCAN_CATEGORY_SYNDIE "Technologie du syndicat"
/// praise be
#define DETSCAN_CATEGORY_HOLY "Sainte donnée"
/// The mode that the items in, what kind of item is dispensed, etc
#define DETSCAN_CATEGORY_SETTINGS "Activée les paramètres"

// If your category is not in this list it WILL NOT BE DISPLAYED
/// defines the order categories are displayed, with the original categories, then custom ones, then finally the extra info.
#define DETSCAN_DEFAULT_ORDER(...) list(\
	DETSCAN_CATEGORY_FINGERS, \
	DETSCAN_CATEGORY_BLOOD, \
	DETSCAN_CATEGORY_FIBER, \
	DETSCAN_CATEGORY_DRINK, \
	DETSCAN_CATEGORY_ACCESS, \
	DETSCAN_CATEGORY_SETTINGS, \
	DETSCAN_CATEGORY_HOLY, \
	DETSCAN_CATEGORY_ILLEGAL, \
	DETSCAN_CATEGORY_SYNDIE, \
	DETSCAN_CATEGORY_NOTES, \
)

/// the order departments show up in for the id scan (its sorted by red to blue on the color wheel)
#define DETSCAN_ACCESS_ORDER(...) list(\
	REGION_SECURITY, \
	REGION_ENGINEERING, \
	REGION_SUPPLY, \
	REGION_GENERAL, \
	REGION_MEDBAY, \
	REGION_COMMAND, \
	REGION_RESEARCH, \
	REGION_CENTCOM, \
)

/// if any categories list has this entry, it will be hidden
#define DETSCAN_BLOCK "DETSCAN_BLOCK"

/// Wanted statuses
#define WANTED_ARREST "Arrestable"
#define WANTED_DISCHARGED "Libérable"
#define WANTED_NONE "Rien"
#define WANTED_PAROLE "En liberté conditionnelle"
#define WANTED_PRISONER "Prisonnier"
#define WANTED_SUSPECT "Suspecté"

/// List of available wanted statuses
#define WANTED_STATUSES(...) list(\
	WANTED_NONE, \
	WANTED_SUSPECT, \
	WANTED_ARREST, \
	WANTED_PRISONER, \
	WANTED_PAROLE, \
	WANTED_DISCHARGED, \
)
