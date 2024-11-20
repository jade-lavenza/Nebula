/decl/trait/malus/amphibious
	name = "Amphibious"
	description = "Your skin is permeable and prone to drying out. Liquids you touch act as if you consumed them, and you get thirsty faster than normal."
	trait_cost = -1 // increase if thirst ever becomes important/deadly
	allow_robotic = TRAIT_ROBOTIC_FORBIDDEN
	uid = "trait_amphibious"

/obj/screen/drink/handle_click(mob/living/user, params)
	if(user.hydration_icon != src || !istype(user) || !user.has_trait(/decl/trait/malus/amphibious))
		return ..()
	switch(icon_state)
		if("hydration0")
			to_chat(user, SPAN_WARNING("You are soaking wet."))
		if("hydration1")
			to_chat(user, SPAN_NOTICE("You are pleasantly wet."))
		if("hydration2")
			to_chat(user, SPAN_NOTICE("You are a bit damp."))
		if("hydration3")
			to_chat(user, SPAN_WARNING("You are quite dry."))
		if("hydration4")
			to_chat(user, SPAN_DANGER("You are drying out!"))

/decl/material/affect_touch(var/mob/living/victim, var/removed, var/datum/reagents/holder)
	if((. = ..()) || !victim.has_trait(/decl/trait/malus/amphibious))
		return
	// You get about 1/3 of the liquid portion or of removed, whichever is lower.
	var/liquid_ingested = CHEMS_QUANTIZE(min(LIQUID_VOLUME(holder, type), removed) / 3)
	if(liquid_ingested <= 0) // no liquid to ingest!
		return
	affect_ingest(victim, liquid_ingested, holder)
	return TRUE

/mob/living/get_thirst_factor()
	. = ..()
	if(has_trait(/decl/trait/malus/amphibious))
		. *= 5/3