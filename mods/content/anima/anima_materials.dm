/decl/material/solid/anima
	name                         = "anima"
	solid_name                   = "crystalline anima"
	uid                          = "mat_anima"
	opacity                      = 0.7
	color                        = COLOR_GRAY40
	abstract_type                = /decl/material/solid/anima
	uid                          = "mat_anima_generic"
	var/anima_type               = "unaspected"
	var/runestone_glow_intensity = 0.3
	/// Simple spells that can be scribed onto runestones or cast on the fly.
	var/list/cantrips
	/// Spell used when a blank is cracked.
	var/decl/runestone_spell_archetype/undirected_spell
	/// Skill used for general spell knowledge.
	var/arcana_skill = SKILL_SCIENCE // TODO: arcana or magic skill

/decl/material/solid/anima/Initialize()
	name        = "[anima_type] anima"
	solid_name  = "crystalline [anima_type] anima"
	liquid_name = "molten [anima_type] anima"
	gas_name    = "gaseous [anima_type] anima"
	for(var/spell in cantrips)
		cantrips -= spell
		cantrips |= GET_DECL(spell)
	undirected_spell = GET_DECL(undirected_spell)
	return ..()

/decl/material/solid/anima/proc/get_spells()
	return list()

/decl/material/solid/anima/proc/get_cantrips_by_effect_type(mob/user, effect_type)
	// TODO: check arcana_skill on user
	for(var/decl/runestone_spell_archetype/cantrip in cantrips)
		if(cantrip.has_effect_type(effect_type))
			LAZYDISTINCTADD(., cantrip)

/decl/material/solid/anima/air
	anima_type               = "air"
	color                    = COLOR_SKY_BLUE
	runestone_glow_intensity = 0.6
	uid                      = "mat_anima_air"

/decl/material/solid/anima/fire
	anima_type               = "fire"
	color                    = COLOR_ORANGE
	runestone_glow_intensity = 0.6
	cantrips                 = list(
		/decl/runestone_spell_archetype/flash,
		/decl/runestone_spell_archetype/flare
	)
	undirected_spell = /decl/runestone_spell_archetype/flare
	uid = "mat_anima_fire"

/decl/material/solid/anima/water
	anima_type               = "water"
	color                    = COLOR_CYAN
	runestone_glow_intensity = 0.6
	uid                      = "mat_anima_water"

/decl/material/solid/anima/stone
	anima_type               = "stone"
	color                    = COLOR_SILVER
	runestone_glow_intensity = 0.6
	uid                      = "mat_anima_stone"
