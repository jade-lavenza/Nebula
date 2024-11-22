/decl/trait/mutation/defect/nerve_poppy
	name = "Nerve Poppy"
	description = "You lack a well-developed sense of pain. You can't tell where on your body pain is coming from."
	trait_cost = -3
	allow_robotic = TRAIT_ROBOTIC_FORBIDDEN
	uid = "trait_nerve_poppy"
	var/list/flesh_hud_reduced_colours = list("#00ff00", "#ffaa00", "#ffaa00", "#ffaa00", "#660000", "#660000", "#660000")
	var/list/robot_hud_reduced_colours = list("#ffffff", "#666666", "#666666", "#666666", "#000000", "#000000", "#000000")
	var/const/pain_multiplier = 0.75

/mob/living/custom_pain(message, power, force, obj/item/organ/external/affecting, nohalloss)
	if(!message || !affecting || !has_trait(/decl/trait/mutation/defect/nerve_poppy))
		return ..()
	// Make sure we still pass affecting so that it affects things like limb usability.
	return ..("Something hurts, but you can't tell where!", floor(power * /decl/trait/mutation/defect/nerve_poppy::pain_multiplier), force, affecting, nohalloss)

/obj/item/organ/external/get_sensed_pain()
	if(!owner || !owner.has_trait(/decl/trait/mutation/defect/nerve_poppy))
		return ..()
	return floor(owner.getHalLoss() / length(owner.get_external_organs()) * /decl/trait/mutation/defect/nerve_poppy::pain_multiplier)

/obj/item/organ/external/get_damage_hud_colours()
	if(!owner || !owner.has_trait(/decl/trait/mutation/defect/nerve_poppy))
		return ..()
	var/decl/trait/mutation/defect/nerve_poppy/poppy = GET_DECL(__IMPLIED_TYPE__)
	return !BP_IS_PROSTHETIC(src) ? poppy.flesh_hud_reduced_colours : poppy.robot_hud_reduced_colours

/mob/living/human/check_self_injuries(include_pain = TRUE, include_visible = TRUE)
	if(!include_pain || !has_trait(/decl/trait/mutation/defect/nerve_poppy))
		return ..()
	if(include_visible)
		. = ..(FALSE, include_visible)
	else
		to_chat(src, SPAN_NOTICE("You try to take note of how your body feels..."))
	var/pain_string
	var/pain = floor(getHalLoss() * /decl/trait/mutation/defect/nerve_poppy::pain_multiplier) // bad at judging pain overall
	if(pain > 0)
		switch(pain / 100)
			if(0 to 0.35)
				pain_string = SPAN_WARNING("slightly sore")
			if(0.35 to 0.65)
				pain_string = SPAN_DANGER("very sore")
			if(0.65 to INFINITY)
				pain_string = SPAN_DANGER("throbbing with agony")
	if(pain_string)
		to_chat(src, "Your body is [pain_string].")
	else
		to_chat(src, "You <span class='notice'>don't notice any pain</span> right now.")