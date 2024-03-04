var/global/list/_anima_spell_effect_types = list(
	"area of effect" = ANIMA_SPELL_AOE,
	"close-range"    = ANIMA_SPELL_MELEE,
	"long-range"     = ANIMA_SPELL_RANGED
)

/datum/anima_working
	var/effect_type = ANIMA_SPELL_AOE
	var/effect_strength = 1
	var/decl/runestone_spell_archetype/spell_master
	var/decl/anima_spell_effect/masterwork_effect

/datum/anima_working/New(_effect)
	effect_type = _effect