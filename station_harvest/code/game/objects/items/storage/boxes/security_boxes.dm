/obj/item/storage/box/restrainimp
	name = "boxed restraining implants"
	desc = "Box of restraining implants. It has a picture of a clown getting yelled at."
	illustration = "implant"

/obj/item/storage/box/restrainimp/PopulateContents()
	var/static/items_inside = list(
		/obj/item/implantcase/restraining = 5,
		/obj/item/implanter = 1,
	)
	generate_items_inside(items_inside,src)
