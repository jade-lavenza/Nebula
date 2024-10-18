/decl/department/karzerfeste/guild
	name             = "Adventurer's Guild"
	colour           = "#807858"

/datum/job/karzerfeste/guild
	abstract_type    = /datum/job/karzerfeste/guild
	department_types = list(/decl/department/karzerfeste/guild)

/datum/job/karzerfeste/guild/master
	title            = "Guildmaster"
	alt_titles       = list("Guildmistress")
	outfit_type      = /decl/outfit/job/karzerfeste/guildmaster

/obj/abstract/landmark/start/karzerfeste/guildmaster
	name             = "Guildmaster"

/datum/job/karzerfeste/guild/clerk
	title            = "Guild Clerk"
	outfit_type      = /decl/outfit/job/karzerfeste/guild_clerk

/obj/abstract/landmark/start/karzerfeste/guild_clerk
	name             = "Guild Clerk"

/datum/job/karzerfeste/guild/adventurer
	title            = "Adventurer"
	outfit_type      = /decl/outfit/job/karzerfeste/adventurer

/obj/abstract/landmark/start/karzerfeste/adventurer
	name             = "Adventurer"

/datum/job/karzerfeste/guild/greenhorn
	title            = "Greenhorn Adventurer"
	outfit_type      = /decl/outfit/job/karzerfeste/adventurer/greenhorn

/obj/abstract/landmark/start/karzerfeste/greenhorn_adventurer
	name             = "Greenhorn Adventurer"

// Maybe appraiser instead?
/datum/job/karzerfeste/guild/armorer
	title            = "Guild Armorer"
	outfit_type      = /decl/outfit/job/karzerfeste/guild_armorer

/obj/abstract/landmark/start/karzerfeste/armorer
	name             = "Guild Armorer"

// Cargo guy, commands the cargo boat
// Also works as an appraiser? Sells stuff upriver for locals and adventurers
// Do they need deckhands/cargo techs?
/datum/job/karzerfeste/guild/merchant
	title            = "Guild Merchant"
	outfit_type      = /decl/outfit/job/karzerfeste/guild_merchant

/obj/abstract/landmark/start/karzerfeste/guild_merchant
	name             = "Guild Merchant"
