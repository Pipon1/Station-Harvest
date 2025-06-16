/datum/mood_event/handcuffed
	description = "Ces menottes me gênent."
	mood_change = -1

/datum/mood_event/broken_vow //Used for when mimes break their vow of silence
	description = "J'ai trainé mon nom dans la honte, et trahis mes chers collègues en brisant notre serment secret..."
	mood_change = -8

/datum/mood_event/on_fire
	description = "JE SUIS EN FEU !!!"
	mood_change = -12

/datum/mood_event/suffocation
	description = "PEUX PAS... RESPIRER..."
	mood_change = -12

/datum/mood_event/burnt_thumb
	description = "Je ne devrais pas jouer avec les briquets..."
	mood_change = -1
	timeout = 2 MINUTES

/datum/mood_event/cold
	description = "Il fait beaucoup trop froid ici."
	mood_change = -5

/datum/mood_event/hot
	description = "Il commence à faire très chaud ici."
	mood_change = -5

/datum/mood_event/creampie
	description = "Je suis plein.e de crème. Ça sent l'odeur de tarte."
	mood_change = -2
	timeout = 3 MINUTES

/datum/mood_event/slipped
	description = "J'ai glissé chef. Je devrais être plus prudent.e, la prochaine fois..."
	mood_change = -2
	timeout = 3 MINUTES

/datum/mood_event/eye_stab
	description = "J'étais un aventurier comme toi, jusqu'à ce que je prenne un tournevis dans l'oeil..."
	mood_change = -4
	timeout = 3 MINUTES

/datum/mood_event/delam //SM delamination
	description = "Ces traders d'ingénieurs, incapable de faire leur job correctement..."
	mood_change = -2
	timeout = 4 MINUTES

/datum/mood_event/cascade // Big boi delamination
	description = "Les ingénieurs l'ont finalement fait, on va tous mourir..."
	mood_change = -8
	timeout = 5 MINUTES

/datum/mood_event/depression_minimal
	description = "Je me sens déprimé."
	mood_change = -10
	timeout = 2 MINUTES

/datum/mood_event/depression_mild
	description = "Je me sens mal, sans raison particulière."
	mood_change = -12
	timeout = 2 MINUTES

/datum/mood_event/depression_moderate
	description = "Je me sens misérable."
	mood_change = -14
	timeout = 2 MINUTES

/datum/mood_event/depression_severe
	description = "J'ai perdu tout espoir."
	mood_change = -16
	timeout = 2 MINUTES

/datum/mood_event/shameful_suicide //suicide_acts that return SHAME, like sord
	description = "Je peux même pas en finir !"
	mood_change = -15
	timeout = 60 SECONDS

/datum/mood_event/dismembered
	description = "AHH ! J'UTILISAIS CE MEMBRE !"
	mood_change = -10
	timeout = 8 MINUTES

/datum/mood_event/tased
	description = "Il n'y a pas de \"z\" dans \"taser\". Mais il y en a dans \"zappé.e\"."
	mood_change = -3
	timeout = 2 MINUTES

/datum/mood_event/embedded
	description = "Enlevez ça !"
	mood_change = -7

/datum/mood_event/table
	description = "Quelqu'un m'a jeté sur une table !"
	mood_change = -2
	timeout = 2 MINUTES

/datum/mood_event/table/add_effects()
	if(isfelinid(owner)) //Holy snowflake batman!
		var/mob/living/carbon/human/H = owner
		SEND_SIGNAL(H, COMSIG_ORGAN_WAG_TAIL, TRUE, 3 SECONDS)
		description = "Iel veut jouer sur la table !"
		mood_change = 2

/datum/mood_event/table_limbsmash
	description = "Cette tradeuse de table, mec ça fait super mal..."
	mood_change = -3
	timeout = 3 MINUTES

/datum/mood_event/table_limbsmash/add_effects(obj/item/bodypart/banged_limb)
	if(banged_limb)
		description = "Ma tradeuse de [banged_limb.plaintext_zone], mec ça fait super mal..."

/datum/mood_event/brain_damage
	mood_change = -3

/datum/mood_event/brain_damage/add_effects()
	var/damage_message = pick_list_replacements(BRAIN_DAMAGE_FILE, "brain_damage")
	description = "Hurr durr... [damage_message]"

/datum/mood_event/hulk //Entire duration of having the hulk mutation
	description = "HULK TOUKC!"
	mood_change = -4

/datum/mood_event/epilepsy //Only when the mutation causes a seizure
	description = "J'aurais dû faire attention aux avertissements..."
	mood_change = -3
	timeout = 5 MINUTES

/datum/mood_event/nyctophobia
	description = "Il fait sombre par là..."
	mood_change = -3

/datum/mood_event/claustrophobia
	description = "Pourquoi je me sens autant piégé ?! Laissez moi sortir !!!"
	mood_change = -7
	timeout = 1 MINUTES

/datum/mood_event/bright_light
	description = "Je déteste la lumière... J'ai besoin de trouver un endroit plus sombre..."
	mood_change = -12

/datum/mood_event/family_heirloom_missing
	description = "L'objet hérité de ma famille me manque..."
	mood_change = -4

/datum/mood_event/healsbadman
	description = "J'ai l'impression d'être une marionnette à qui on pourait couper les fils à tout moment !"
	mood_change = -4
	timeout = 2 MINUTES

/datum/mood_event/jittery
	description = "je suis nerveux, tendu, et je ne peux pas rester immobile !!"
	mood_change = -2

/datum/mood_event/choke
	description = "JE NE PEUX PAS RESPIRER !!!"
	mood_change = -10

/datum/mood_event/vomit
	description = "Je viens juste de vomir. Dégueu."
	mood_change = -2
	timeout = 2 MINUTES

/datum/mood_event/vomitself
	description = "Je viens de me vomir dessus. C'est dégoutant."
	mood_change = -4
	timeout = 3 MINUTES

/datum/mood_event/painful_medicine
	description = "Peut-être que les médicaments sont censé être bon pour moi, mais là tout de suite c'est plus douloureux qu'autre chose."
	mood_change = -5
	timeout = 60 SECONDS

/datum/mood_event/spooked
	description = "Le râle de ces os... Ça me hante encore maintenant."
	mood_change = -4
	timeout = 4 MINUTES

/datum/mood_event/loud_gong
	description = "Ce bruit de gong était super fort, ça m'a fait super mal aux oreilles !"
	mood_change = -3
	timeout = 2 MINUTES

/datum/mood_event/notcreeping
	description = "Les voix ne sont pas heureuses, et elles tordent mes pensées pour que je me remette au travail."
	mood_change = -6
	timeout = 3 SECONDS
	hidden = TRUE

/datum/mood_event/notcreepingsevere//not hidden since it's so severe
	description = "J'AI BESOIN DE ELLUI !!"
	mood_change = -30
	timeout = 3 SECONDS

/datum/mood_event/notcreepingsevere/add_effects(name)
	var/list/unstable = list(name)
	for(var/i in 1 to rand(3,5))
		unstable += copytext_char(name, -1)
	var/unhinged = uppertext(unstable.Join(""))//example Tinea Luxor > TINEA LUXORRRR (with randomness in how long that slur is)
	description = "THEY NEEEEEEED [unhinged]!!"

/datum/mood_event/tower_of_babel
	description = "Ma bouche forme des mots qui ressemblent plutôt à du vacarme..."
	mood_change = -1
	timeout = 15 SECONDS

/datum/mood_event/back_pain
	description = "Je ne supporte pas les sacs à dos, ça me fait super mal !"
	mood_change = -15

/datum/mood_event/sad_empath
	description = "Quelqu'un n'a pas l'air bien..."
	mood_change = -1
	timeout = 60 SECONDS

/datum/mood_event/sad_empath/add_effects(mob/sadtarget)
	description = "[sadtarget.name] n'a pas l'air bien..."

/datum/mood_event/sacrifice_bad
	description = "Ces traders de sauvages !"
	mood_change = -5
	timeout = 2 MINUTES

/datum/mood_event/artbad
	description = "Des enfants de maternelles font plus de l'art que moi."
	mood_change = -2
	timeout = 2 MINUTES

/datum/mood_event/graverobbing
	description = "Je viens juste de profaner la tombe de quelqu'un... J'ai l'impression que la terre sous mes ongles ne partir jamais..."
	mood_change = -8
	timeout = 3 MINUTES

/datum/mood_event/deaths_door
	description = "Voilà, c'est la fin... Je vais vraiment mourir."
	mood_change = -20

/datum/mood_event/gunpoint
	description = "Iel est fou ! Je devrais être plus prudent.e..."
	mood_change = -10

/datum/mood_event/tripped
	description = "Je peux pas croire que je suis tombé dans ce vieux piège..."
	mood_change = -5
	timeout = 2 MINUTES

/datum/mood_event/untied
	description = "Je déteste quand mes chaussures ne sont pas lacées !"
	mood_change = -3
	timeout = 60 SECONDS

/datum/mood_event/gates_of_mansus
	description = "J'AI EU UN APERÇU D'HORREURS VENUES D'AUTRES MONDES. LA RÉALITÉ S'EST DÉROULÉE DEVANT MES YEUX !"
	mood_change = -25
	timeout = 4 MINUTES

/datum/mood_event/high_five_alone
	description = "J'ai essayé de faire un high-five mais personne ne m'a répondu, c'était vraiment embarassant."
	mood_change = -2
	timeout = 60 SECONDS

/datum/mood_event/high_five_full_hand
	description = "Bon sang, je ne sais même pas comment faire un high-five correct..."
	mood_change = -1
	timeout = 45 SECONDS

/datum/mood_event/left_hanging
	description = "Mais tout le monde aime les high fives ! Peut-être que les gens... me détestent ?"
	mood_change = -2
	timeout = 90 SECONDS

/datum/mood_event/too_slow
	description = "NON ! COMMENT EST-CE QUE J'AI PU ÊTRE... TROP LENT ???"
	mood_change = -2 // multiplied by how many people saw it happen, up to 8, so potentially massive. the ULTIMATE prank carries a lot of weight
	timeout = 2 MINUTES

/datum/mood_event/too_slow/add_effects(param)
	var/people_laughing_at_you = 1 // start with 1 in case they're on the same tile or something
	for(var/mob/living/carbon/iter_carbon in oview(owner, 7))
		if(iter_carbon.stat == CONSCIOUS)
			people_laughing_at_you++
			if(people_laughing_at_you > 7)
				break

	mood_change *= people_laughing_at_you
	return ..()

//These are unused so far but I want to remember them to use them later
/datum/mood_event/surgery
	description = "IEL EST EN TRAIN DE M'OUVRIR !!"
	mood_change = -8

/datum/mood_event/bald
	description = "J'ai besoin de quelque chose pour couvrir ma tête..."
	mood_change = -3

/datum/mood_event/bad_touch
	description = "Je n'aime pas quand les gens me touchent."
	mood_change = -3
	timeout = 4 MINUTES

/datum/mood_event/very_bad_touch
	description = "Je n'aime vraiment pas quand les gens me touchent."
	mood_change = -5
	timeout = 4 MINUTES

/datum/mood_event/noogie
	description = "Aïe ! Ça fait mal..."
	mood_change = -2
	timeout = 60 SECONDS

/datum/mood_event/noogie_harsh
	description = "AÏE !! C'était plus qu'une petit frottement de tête !"
	mood_change = -4
	timeout = 60 SECONDS

/datum/mood_event/aquarium_negative
	description = "Tous les poissons sont morts..."
	mood_change = -3
	timeout = 90 SECONDS

/datum/mood_event/tail_lost
	description = "Ma queue !! Pourquoi ?!"
	mood_change = -8
	timeout = 10 MINUTES

/datum/mood_event/tail_balance_lost
	description = "J'ai perdu mon équilibre, sans ma queue."
	mood_change = -2

/datum/mood_event/tail_regained_right
	description = "J'ai retrouvé ma queue, mais c'était traumatisant..."
	mood_change = -2
	timeout = 5 MINUTES

/datum/mood_event/tail_regained_wrong
	description = "Est-ce que c'est une sorte de mauvaise blague ?! Ce n'est PAS la bonne queue."
	mood_change = -12 // -8 for tail still missing + -4 bonus for being frakenstein's monster
	timeout = 5 MINUTES

/datum/mood_event/burnt_wings
	description = "MES PRÉCIEUSES AILES !!"
	mood_change = -10
	timeout = 10 MINUTES

/datum/mood_event/holy_smite //punished
	description = "J'ai été puni.e par ma divinité !"
	mood_change = -5
	timeout = 5 MINUTES

/datum/mood_event/banished //when the chaplain is sus! (and gets forcably de-holy'd)
	description = "J'ai été excommunié.e !"
	mood_change = -10
	timeout = 10 MINUTES

/datum/mood_event/heresy
	description = "J'arrive à peine à respirer avant autant d'HÉRÉSIE dans l'air !"
	mood_change = -5
	timeout = 5 MINUTES

/datum/mood_event/soda_spill
	description = "Cool ! C'est ok, je voulais des vêtements collants, pas une boisson fraiche..."
	mood_change = -2
	timeout = 1 MINUTES

/datum/mood_event/watersprayed
	description = "Je déteste être aspergé.e d'eau !"
	mood_change = -1
	timeout = 30 SECONDS

/datum/mood_event/gamer_withdrawal
	description = "J'aimerai bien jouer..."
	mood_change = -5

/datum/mood_event/gamer_lost
	description = "Si je ne suis même pas bon.ne aux jeux vidéos, est-ce que je peux vraiment m'appeler un.e gameu.r.euse ?"
	mood_change = -10
	timeout = 10 MINUTES

/datum/mood_event/lost_52_card_pickup
	description = "C'est vraiment embarassant ! C'est génant, de ramasser toutes ces cartes sur le sol..."
	mood_change = -3
	timeout = 3 MINUTES

/datum/mood_event/russian_roulette_lose
	description = "J'ai joué avec ma vie et j'ai perdu ! J'imagine que c'est la fin..."
	mood_change = -20
	timeout = 10 MINUTES

/datum/mood_event/bad_touch_bear_hug
	description = "On m'a serré.e beaucoup trop fort."
	mood_change = -1
	timeout = 2 MINUTES

/datum/mood_event/rippedtail
	description = "J'ai déchiré.e leur queue, bon sang qu'est-ce que j'ai fait ?!"
	mood_change = -5
	timeout = 30 SECONDS

/datum/mood_event/sabrage_fail
	description = "Flute ! C'était censé me rendre plus cool, mais ça ne s'est pas passé comme prévu !"
	mood_change = -2
	timeout = 4 MINUTES

/datum/mood_event/body_purist
	description = "Mon corps n'est plus entièrement organique et je DÉTESTE ÇA !"

/datum/mood_event/body_purist/add_effects(power)
	mood_change = power

/datum/mood_event/unsatisfied_nomad
	description = "Je suis resté.e ici trop longtemps ! Je veux sortir et aller explorer l'espace !"
	mood_change = -3
