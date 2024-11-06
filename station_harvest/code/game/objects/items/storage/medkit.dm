/obj/item/storage/pill_bottle/nosleeppill
	name = "Modafinil pills"
	desc = "Contains pill to stay awake. Consume with precautions."

/obj/item/storage/pill_bottle/nosleeppill/PopulateContents()
	for(var/i in 1 to 8)
		new /obj/item/reagent_containers/pill/nosleeppill(src)
