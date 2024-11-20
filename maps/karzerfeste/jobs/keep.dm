/decl/department/karzerfeste/keep
	name             = "Keep Staff"
	colour           = "#404e68"
	display_color    = "#8c96c4"

/datum/job/karzerfeste/keep
	abstract_type    = /datum/job/karzerfeste/keep
	department_types = list(/decl/department/karzerfeste/keep)

/datum/job/karzerfeste/keep/cook
	title            = "Keep Cook"
	outfit_type      = /decl/outfit/job/karzerfeste/cook

/obj/abstract/landmark/start/karzerfeste/cook
	name             = "Keep Cook"

/datum/job/karzerfeste/keep/builder
	title            = "Keep Builder"
	outfit_type      = /decl/outfit/job/karzerfeste/builder

/obj/abstract/landmark/start/karzerfeste/builder
	name             = "Keep Builder"

/datum/job/karzerfeste/keep/inn
	title            = "Innkeeper"
	outfit_type      = /decl/outfit/job/karzerfeste/innkeeper

/obj/abstract/landmark/start/karzerfeste/innkeeper
	name             = "Innkeeper"

/datum/job/karzerfeste/keep/servant
	title            = "Keep Servant"
	outfit_type      = /decl/outfit/job/karzerfeste/servant

/obj/abstract/landmark/start/karzerfeste/servant
	name             = "Keep Servant"
