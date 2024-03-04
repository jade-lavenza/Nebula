// Handles all effects associated with a spell.
/decl/runestone_spell_archetype
	abstract_type = /decl/runestone_spell_archetype
	var/name
	var/decl/anima_spell_effect/base_effect
	var/list/masterwork_effects
	var/arcana_skill = SKILL_SCIENCE

/decl/runestone_spell_archetype/Initialize()
	for(var/spell_effect in masterwork_effects)
		masterwork_effects -= spell_effect
		masterwork_effects |= GET_DECL(spell_effect)
	base_effect = GET_DECL(base_effect)
	name = base_effect.name
	return ..()

/decl/runestone_spell_archetype/proc/has_effect_type(effect_type)
	return TRUE

/decl/runestone_spell_archetype/proc/get_masterwork_effects(mob/user, obj/item/implement)
	// TODO: skill/trait/mind checks on user
	return masterwork_effects

/decl/runestone_spell_archetype/flash
	base_effect = /decl/anima_spell_effect/flash
	masterwork_effects = list(
		/decl/anima_spell_effect/gloom
	)

/decl/runestone_spell_archetype/flare
	base_effect = /decl/anima_spell_effect/flare
