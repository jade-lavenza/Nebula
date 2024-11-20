/decl/trait/malus/cold_blooded
	name = "Cold-Blooded"
	description = "Your body is unable to regulate its own temperature. Your movement and work speed are decreased significantly when you are cold."
	trait_cost = -2
	allow_robotic = TRAIT_ROBOTIC_FORBIDDEN
	uid = "trait_cold_blooded"

/mob/living/skill_delay_mult(skill_path, factor)
	. = ..()
	if(has_trait(/decl/trait/malus/cold_blooded))
		var/decl/bodytype/root_bodytype = get_bodytype()
		if(root_bodytype)
			if (bodytemperature < root_bodytype.cold_discomfort_level)
				// the base caps at about 280%, so we don't want to end up with something silly like 900%
				// so we add a flat amount based on factor and cap it at 500% (5)
				. = clamp(. + (root_bodytype.cold_discomfort_level - bodytemperature) * factor, ., 5)
			else if(bodytemperature > root_bodytype.heat_discomfort_level)
				// likewise don't let it go below 50% as the base minimum is 70%
				. = clamp(. - (bodytemperature - root_bodytype.heat_discomfort_level) * factor, ., 0.5)

/mob/living/human/get_movement_delay(var/travel_dir)
	. = ..()
	var/decl/bodytype/root_bodytype = get_bodytype()
	if(has_trait(/decl/trait/malus/cold_blooded) && root_bodytype && bodytemperature > root_bodytype.heat_discomfort_level)
		. -= min((bodytemperature - root_bodytype.heat_discomfort_level) / 10 * 1.75, 10)

/decl/bodytype/get_environment_discomfort(mob/living/human/victim, msg_type)
	if(!victim.has_trait(/decl/trait/malus/cold_blooded) || msg_type != "heat")
		return ..()
	if(!prob(5))
		return
	// custom heat comfort messages
	to_chat(victim, SPAN_DANGER(pick(\
		"You feel soothingly warm.",\
		"You feel the heat sink into your bones.",\
		"You feel comfortable and full of energy."\
	)))

/mob/living/has_metabolic_thermoregulation()
	if(has_trait(/decl/trait/malus/cold_blooded))
		return FALSE
	return ..()