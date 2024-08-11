/decl/anima_spell_effect
	abstract_type = /decl/anima_spell_effect
	var/name
	var/description
	var/cost = 1

/decl/anima_spell_effect/proc/evoke_spell(mob/user, atom/target, obj/item/runestone/runestone, caster_effect, caster_strength, in_proximity, deliberate = TRUE)
	// Get our spell parameters.
	var/spent_cost     = runestone ? min(runestone.anima_density, cost) : cost
	var/evoke_effect   = caster_effect   || runestone?.stored_spell?.effect_type || ANIMA_SPELL_AOE
	if(!in_proximity && evoke_effect == ANIMA_SPELL_MELEE)
		evoke_effect = ANIMA_SPELL_RANGED
	var/evoke_strength = caster_strength || runestone?.anima_density || 1

	// Cast the actual spell.
	do_evocation(user, target, evoke_effect, evoke_strength, deliberate)

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

/decl/anima_spell_effect/proc/do_evocation(mob/user, atom/target, evoke_effect = ANIMA_SPELL_AOE, evoke_strength = 1, deliberate = TRUE)

/decl/anima_spell_effect/flash
	name = "Flash"
	description = "Release the channeled anima in a blinding flash of light."

/decl/anima_spell_effect/flash/do_evocation(mob/user, atom/target, evoke_effect = ANIMA_SPELL_AOE, evoke_strength = 1, deliberate = TRUE)

	if(evoke_effect == ANIMA_SPELL_AOE)
		user.visible_message("\The [user] emits a blinding flash of light ([evoke_strength])!")
		for(var/mob/living/victim in view(evoke_strength, user))
			if(deliberate && victim == user)
				continue
			victim.handle_flashed(rand(evoke_strength, evoke_strength*2 + 1)) // min is 1 to 2, max is 3 to 7; base flash is 2 to 7 in a range of 3 tiles
	else
		user.visible_message("\The [user] drowns \the [target] in a blinding flash of light ([evoke_strength])!")
		if(isliving(target))
			var/mob/living/victim = target
			victim.handle_flashed(evoke_strength * 2 + 1) // since we're only attacking one target, we just go with the max instead of a random value
	return TRUE

/decl/anima_spell_effect/gloom
	name = "Gloom"
	description = "Burn the channeled anima to create a burst of unnatural darkness."

/decl/anima_spell_effect/gloom/do_evocation(mob/user, atom/target, evoke_effect = ANIMA_SPELL_AOE, evoke_strength = 1, deliberate = TRUE)
	if(evoke_effect == ANIMA_SPELL_AOE)
		user.visible_message("\The [user] emits a burst of unnatural darkness ([evoke_strength])!")
		var/atom/movable/gloom/gloom = new(target, evoke_strength) // with AOE spell, target is user's turf
		QDEL_IN_CLIENT_TIME(gloom, evoke_strength * 5 SECONDS)
	else
		user.visible_message("\The [user] drowns \the [target] in unnatural darkness ([evoke_strength])!")
		if(isliving(target))
			var/mob/living/victim = target
			victim.overlay_fullscreen("gloom", /obj/screen/fullscreen/blackout)
			addtimer(CALLBACK(victim, TYPE_PROC_REF(/mob, clear_fullscreen), "gloom"), evoke_strength * 3 SECONDS)
	return TRUE

/atom/movable/gloom
	simulated = FALSE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE

/atom/movable/gloom/Initialize(ml, strength)
	. = ..()
	set_light(strength, -10, "#ffffff") // negative light, cleared on destroy

/decl/anima_spell_effect/flare
	name = "Flare"
	description = "Release the channeled anima in an undirected burst of flame."

/decl/anima_spell_effect/flare/do_evocation(mob/user, atom/target, evoke_effect = ANIMA_SPELL_AOE, evoke_strength = 1, deliberate = TRUE)
	var/turf/source_turf = get_turf(user)
	// level 1 flare is hot enough to boil water. level 3 flare is hot enough to light a campfire and ignite wood
	// divided by 0.9 and plus one to ensure inefficiency doesn't stop us from lighting campfires
	var/fire_temperature = Interpolate(T100C, initial(/decl/material/solid/organic/wood::ignition_point) / 0.9 + 1, (evoke_strength - 1) / 3)
	if(evoke_effect == ANIMA_SPELL_AOE)
		user.visible_message("\The [user] is wreathed in a blast of fire ([evoke_strength])!")
		for(var/turf/T in RANGE_TURFS(source_turf, evoke_strength))
			T = T.resolve_to_actual_turf()
			var/obj/effect/fake_fire/variable/owned/flare = new(T, fire_temperature, evoke_strength SECONDS, deliberate ? user : null)
	else
		user.visible_message("\The [user] hurls a blast of fire over \the [target] ([evoke_strength])!")
		var/obj/item/projectile/fireball/projectile = new(source_turf)
		projectile.fire_lifetime = evoke_strength SECONDS
		// level 1 flare is hot enough to boil water. level 3 flare is hot enough to light a campfire and ignite wood
		projectile.fire_temperature = Interpolate(T100C, initial(projectile::fire_temperature), (evoke_strength - 1) / 3)
		projectile.launch_from_gun(target, user.get_target_zone(), user)
	return TRUE
