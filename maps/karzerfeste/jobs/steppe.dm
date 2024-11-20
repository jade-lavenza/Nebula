/decl/department/karzerfete/steppe
	name             = "Nine Mothers Emissaries"
	colour           = "#404e68"
	display_color    = "#8c96c4"

/datum/job/karzerfeste/steppe
	abstract_type    = /datum/job/karzerfeste/steppe
	department_types = list(/decl/department/karzerfete/steppe)

// Emissary of the council of matriarches?
// Daughter or favoured brother?
/datum/job/karzerfeste/steppe/representative
	title       = "Nine Mothers Representative"
	outfit_type = /decl/outfit/job/karzerfeste/steppe_representative

/obj/abstract/landmark/start/karzerfeste/steppe_representative
	name        = "Nine Mothers Representative"

// Blooded family of the representative or esteemed member of the clan?
/datum/job/karzerfeste/steppe/honor_guard
	title       = "Nine Mothers Honor Guard"
	outfit_type =  /decl/outfit/job/karzerfeste/steppe_honor_guard

/obj/abstract/landmark/start/karzerfeste/steppe_honor_guard
	name        = "Nine Mothers Honor Guard"
