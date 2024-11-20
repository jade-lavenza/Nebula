/decl/trait/malus/brittle_bones
	name = "Brittle Bones"
	description = "Your bones are abnormally brittle, able to fracture with less damage than normal and more likely to fracture when taking blunt damage."
	trait_cost = -4
	allow_robotic = TRAIT_ROBOTIC_FORBIDDEN
	uid = "trait_brittle_bones"

/decl/trait/malus/brittle_bones/apply_trait(mob/living/holder)
	for(var/obj/item/organ/external/limb in holder.get_external_organs())
		limb.min_broken_damage = floor(limb.min_broken_damage * 0.8)
		limb.blunt_fracture_multiplier *= 3/2