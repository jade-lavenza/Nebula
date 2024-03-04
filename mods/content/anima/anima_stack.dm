/obj/item/stack/material/anima
	name                = "blanks"
	desc                = "Crystalline anima, cut into rough, unworked rounds and ready for etching."
	singular_name       = "blank"
	plural_name         = "blanks"
	icon_state          = "anima"
	icon                = 'mods/content/anima/icons/anima_blank.dmi'
	plural_icon_state   = "anima-mult"
	max_icon_state      = "anima-max"
	stack_merge_type    = /obj/item/stack/material/anima
	crafting_stack_type = /obj/item/stack/material/anima
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	max_amount          = 5

/obj/item/stack/material/anima/mapped/fire
	amount = 1
	material = /decl/material/solid/anima/fire
	is_spawnable_type = TRUE

/obj/item/stack/material/anima/mapped/fire/five
	name = "5 fire anima blanks"
	amount = 5

/obj/item/stack/material/anima/mapped/water
	amount = 1
	material = /decl/material/solid/anima/water
	is_spawnable_type = TRUE

/obj/item/stack/material/anima/mapped/water/five
	name = "5 water anima blanks"
	amount = 5

/obj/item/stack/material/anima/mapped/air
	amount = 1
	material = /decl/material/solid/anima/air
	is_spawnable_type = TRUE

/obj/item/stack/material/anima/mapped/air/five
	name = "5 air anima blanks"
	amount = 5

/obj/item/stack/material/anima/mapped/stone
	amount = 1
	material = /decl/material/solid/anima/stone
	is_spawnable_type = TRUE

/obj/item/stack/material/anima/mapped/stone/five
	name = "5 stone anima blanks"
	amount = 5

/decl/stack_recipe/anima
	abstract_type     = /decl/stack_recipe/anima
	craft_stack_types = /obj/item/stack/material/anima
	required_material = /decl/material/solid/anima

/decl/stack_recipe/anima/runestone
	result_type       = /obj/item/runestone
