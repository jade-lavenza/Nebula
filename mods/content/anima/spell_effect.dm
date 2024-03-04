/decl/anima_spell_effect
	abstract_type = /decl/anima_spell_effect
	var/name
	var/description
	var/cost = 1

/decl/anima_spell_effect/proc/evoke_spell(mob/user, atom/target, obj/item/runestone/runestone, caster_effect, caster_strength, in_proximity)
	// Get our spell parameters.
	var/spent_cost     = runestone ? min(runestone.anima_density, cost) : cost
	var/evoke_effect   = caster_effect   || runestone?.stored_spell?.effect_type || ANIMA_SPELL_AOE
	if(!in_proximity && evoke_effect == ANIMA_SPELL_MELEE)
		evoke_effect = ANIMA_SPELL_RANGED
	var/evoke_strength = caster_strength || runestone?.anima_density || 1

	// Cast the actual spell.
	do_evocation(user, target, evoke_effect, evoke_strength)

	// Expend resources.
	if(runestone)
		if(runestone.anima_density > spent_cost && evoke_effect != ANIMA_SPELL_AOE)
			runestone.anima_density -= spent_cost
			runestone.update_icon()
			runestone.update_strings()
		else if(!QDELETED(runestone))
			to_chat(user, SPAN_DANGER("Your runestone crumbles to dust!"))
			qdel(runestone)
	// else
	//    take anima from caster's pool

/decl/anima_spell_effect/proc/show_primed_message(mob/user, effect_type)
	to_chat(user, SPAN_NOTICE("Raw anima wreathes your [parse_zone(user.get_active_held_item_slot())], ready to be directed."))

/decl/anima_spell_effect/proc/do_evocation(mob/user, atom/target, evoke_effect = ANIMA_SPELL_AOE, evoke_strength = 1)

/decl/anima_spell_effect/flash
	name = "Flash"
	description = "Release the channeled anima in a blinding flash of light."

/decl/anima_spell_effect/flash/do_evocation(mob/user, atom/target, evoke_effect = ANIMA_SPELL_AOE, evoke_strength = 1)

	if(evoke_effect == ANIMA_SPELL_AOE)
		user.visible_message("\The [user] emits a blinding flash of light ([evoke_strength])!")
	else
		user.visible_message("\The [user] drowns \the [target] in a blinding flash of light ([evoke_strength])!")
	return TRUE

/decl/anima_spell_effect/gloom
	name = "Gloom"
	description = "Burn the channeled anima to create a burst of unnatural darkness."

/decl/anima_spell_effect/gloom/do_evocation(mob/user, atom/target, evoke_effect = ANIMA_SPELL_AOE, evoke_strength = 1)
	if(evoke_effect == ANIMA_SPELL_AOE)
		user.visible_message("\The [user] emits a burst of unnatural darkness ([evoke_strength])!")
	else
		user.visible_message("\The [user] drowns \the [target] in unnatural darkness ([evoke_strength])!")
	return TRUE

/decl/anima_spell_effect/flare
	name = "Flare"
	description = "Release the channeled anima in an undirected burst of flame."

/decl/anima_spell_effect/flare/do_evocation(mob/user, atom/target, evoke_effect = ANIMA_SPELL_AOE, evoke_strength = 1)
	if(evoke_effect == ANIMA_SPELL_AOE)
		user.visible_message("\The [user] is wreathed in a blast of fire! ([evoke_strength])!")
	else
		user.visible_message("\The [user] hurls a blast of fire over \the [target] ([evoke_strength])!")
	return TRUE
