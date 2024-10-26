/decl/trait/wyrd/wild/animal_form
	abstract_type = /decl/trait/wyrd/wild/animal_form
	name = "Animal Semblance"
	description = "Some wyrdlings possess the ability to 'veer' into the form of an \
	animal, known as the 'semblance'. Such wyrdlings use masks of bone or wood to focus \
	and control	the veering, making it difficult for them to conceal their abilities."
	parent = /decl/trait/wyrd/wild
	incompatible_with = null
	var/mask_type

/decl/trait/wyrd/wild/animal_form/Initialize()
	incompatible_with = subtypesof(/decl/trait/wyrd/wild/animal_form) - type
	. = ..()

/decl/trait/wyrd/wild/animal_form/apply_trait(mob/living/holder)
	. = ..()
	if(mask_type)
		var/obj/item/clothing/mask/ghost_caul/mask = new mask_type
		if(!holder.equip_to_slot_if_possible(mask, slot_wear_mask_str))
			holder.put_in_hands_or_store_or_drop(mask)

/decl/trait/wyrd/wild/animal_form/fox
	name = "Fox Semblance"
	mask_type = /obj/item/clothing/mask/ghost_caul/fox
	uid = "trait_wyrd_wild_fox"

/decl/trait/wyrd/wild/animal_form/deer
	name = "Deer Semblance"
	mask_type = /obj/item/clothing/mask/ghost_caul/deer
	uid = "trait_wyrd_wild_deer"

/decl/trait/wyrd/wild/animal_form/deer_antlers
	name = "Crowned Deer Semblance"
	mask_type = /obj/item/clothing/mask/ghost_caul/deer_antlers
	uid = "trait_wyrd_wild_deer_antlers"

/decl/trait/wyrd/wild/animal_form/rabbit
	name = "Rabbit Semblance"
	mask_type = /obj/item/clothing/mask/ghost_caul/rabbit
	uid = "trait_wyrd_wild_rabbit"

/decl/trait/wyrd/wild/animal_form/bear
	name = "Bear Semblance"
	mask_type = /obj/item/clothing/mask/ghost_caul/bear
	uid = "trait_wyrd_wild_bear"

/decl/trait/wyrd/wild/animal_form/wolf
	name = "Wolf Semblance"
	mask_type = /obj/item/clothing/mask/ghost_caul/wolf
	uid = "trait_wyrd_wild_wolf"
