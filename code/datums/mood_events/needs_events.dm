//nutrition
/datum/mood_event/fat
	description = "<B>J'ai trop mangé...</B>" //muh fatshaming. French's edit : C'était pas compliqué de rendre ça moins malaisant...
	mood_change = -6

/datum/mood_event/wellfed
	description = "Je suis repu.e !"
	mood_change = 8

/datum/mood_event/fed
	description = "J'ai mangé récemment."
	mood_change = 5

/datum/mood_event/hungry
	description = "Je commence à avoir faim."
	mood_change = -6

/datum/mood_event/starving
	description = "Je meurs de faim !"
	mood_change = -10

//charge
/datum/mood_event/supercharged
	description = "Je ne peux pas contenir toute cette énergie, je dois en relacher rapidement !"
	mood_change = -10

/datum/mood_event/overcharged
	description = "Je commence à avoir trop d'énergie, je devrais sans doute en relacher."
	mood_change = -4

/datum/mood_event/charged
	description = "Je sens l'énergie dans mes veines !"
	mood_change = 6

/datum/mood_event/lowpower
	description = "Je commence à manquer d'énergie, je devrais aller me recharger."
	mood_change = -6

/datum/mood_event/decharged
	description = "Je suis en manque d'énergie !"
	mood_change = -10

//Disgust
/datum/mood_event/gross
	description = "J'ai vu quelque chose de dégoutant."
	mood_change = -4

/datum/mood_event/verygross
	description = "Je crois que je vais vomir..."
	mood_change = -6

/datum/mood_event/disgusted
	description = "Bon sang, c'était vraiment répugnant..."
	mood_change = -8

/datum/mood_event/disgust/bad_smell
	description = "Quelque chose ne sent vraiment pas bon par ici."
	mood_change = -6

/datum/mood_event/disgust/nauseating_stench
	description = "L'odeur d'une carcasse en décomposition est inssoutenable !"
	mood_change = -12

//Generic needs events
/datum/mood_event/favorite_food
	description = "J'ai vraiment apprécié manger ça."
	mood_change = 5
	timeout = 4 MINUTES

/datum/mood_event/gross_food
	description = "Je n'aime pas vraiment manger ça."
	mood_change = -2
	timeout = 4 MINUTES

/datum/mood_event/disgusting_food
	description = "C'était dégoutant !"
	mood_change = -6
	timeout = 4 MINUTES

/datum/mood_event/breakfast
	description = "Rien de mieux qu'un bon petit déjeuner en début de service."
	mood_change = 2
	timeout = 10 MINUTES

/datum/mood_event/nice_shower
	description = "J'ai pris une douche, récemment."
	mood_change = 4
	timeout = 5 MINUTES

/datum/mood_event/fresh_laundry
	description = "Rien de mieux qu'un uniforme bien propre."
	mood_change = 2
	timeout = 10 MINUTES
