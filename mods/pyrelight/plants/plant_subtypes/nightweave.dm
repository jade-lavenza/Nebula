/obj/structure/flora/growing/nightweave
	name = "nightweave"
	desc = "A rare, poisonous bloom reputed to have medicinal properties."
	is_spawnable_type = TRUE
	icon = 'mods/pyrelight/icons/plants/nightweave.dmi'

/obj/structure/flora/growing/nightweave/get_possible_fruits()
	var/static/list/possible_fruits = list(/obj/item/chems/food/fruit/flower_nightweave)
	return possible_fruits
