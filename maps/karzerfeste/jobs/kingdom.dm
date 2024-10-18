/decl/department/karzerfete/kingdom
	name             = "Splinter Kingdom Emissaries"
	colour           = "#404e68"
	display_color    = "#8c96c4"

/datum/job/karzerfeste/kingdom
	abstract_type    = /datum/job/karzerfeste/kingdom
	department_types = list(/decl/department/karzerfete/kingdom)

/datum/job/karzerfeste/kingdom/representative
	title       = "Kingdom Representative"
	alt_titles  = list("Baron", "Baroness") // too Lifeweb? Shooting for Dwarf Fortress
	outfit_type = /decl/outfit/job/karzerfeste/kingdom_representative

/obj/abstract/landmark/start/karzerfeste/kingdom_representative
	name        = "Kingdom Representative"

/datum/job/karzerfeste/kingdom/honor_guard
	title       = "Kingdom Honor Guard"
	outfit_type =  /decl/outfit/job/karzerfeste/kingdom_honor_guard

/obj/abstract/landmark/start/karzerfeste/kingdom_honor_guard
	name        = "Kingdom Honor Guard"
