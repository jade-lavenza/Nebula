#define RUNESCRIBE_DIFFICULTY_EASY   1
#define RUNESCRIBE_DIFFICULTY_HARD   2
#define RUNESCRIBE_DIFFICULTY_MASTER 3

// working notes
// TODO
// - silver needles for etching
// - skill for spellcraft + jewelry
// - attackby/do after instead of altclick
//
// - strength of spell is determined by quality and purity of the blank
// - first use of chisel on blank:  scope of spell (melee, range, AOE)
// - second use of chisel on blank: intent of spell (harmful, positive, etc)
// - third use of chisel on blank:  only available to high skill crafters, allows variant specialized spells (fireball becoming flame lance etc)
//
// All uses have a long delay and a skill check, failing the skill check:
// - stage 1 will just fail
// - stage 2 will destroy the spell and produce anima shards for recycling or potions
// - stage 3 will set the blank off like an AOE spell and destroy it in the process (bad for dangerous spells)

/obj/item/runestone/proc/can_scribe(mob/user, obj/item/implement)
	if(!istype(user) || QDELETED(user) || (loc != user && !user.Adjacent(src)) || user.incapacitated())
		return FALSE
	if(!istype(material, /decl/material/solid/anima) || QDELETED(src) || cracked)
		return FALSE
	if(work_tool && !IS_TOOL(implement, work_tool))
		return FALSE
	return TRUE

/obj/item/runestone/proc/scribe_check(mob/user, obj/item/tool, difficulty)
	if(!can_scribe(user, tool))
		return FALSE
	if(work_skill && !tool.do_tool_interaction(work_tool, user, src, (2 SECONDS) + (difficulty * 2 SECONDS), "carefully etching", "etching", check_skill = work_skill))
		return FALSE
	if(!can_scribe(user, tool))
		return FALSE
	return TRUE

/obj/item/runestone/proc/try_scribe_spell(mob/user, obj/item/tool)

	if(!can_scribe(user, tool))
		return FALSE

	. = TRUE // We mostly don't care after this point. Return type is only used for attackby() return.
	var/decl/material/solid/anima/anima_mat = material

	// Stage one: choose range.
	if(!stored_spell)
		var/effect_type = input(user, "What type of effect do you wish this runestone to evoke?", "Spellscribing") as null|anything in global._anima_spell_effect_types
		if(QDELETED(src) || !effect_type || stored_spell)
			return
		if(!scribe_check(user, tool, RUNESCRIBE_DIFFICULTY_EASY))
			return
		// Recheck due to do_after
		if(QDELETED(src) || stored_spell)
			return
		stored_spell = new(global._anima_spell_effect_types[effect_type])
		to_chat(user, SPAN_NOTICE("You carefully etch \the [src] with channels suitable for a [stored_spell.effect_type] evocation."))
		update_strings()
		return

	// Stage two: choose specific spell.
	if(!stored_spell.spell_master)
		var/list/possible_spells = anima_mat.get_cantrips_by_effect_type(user, stored_spell.effect_type)
		if(!length(possible_spells))
			to_chat(user, SPAN_WARNING("You do not know any suitable workings to etch into \the [src]."))
			return
		var/decl/runestone_spell_archetype/chosen_spell = input(user, "Which spell do you wish this runestone to evoke?", "Spellscribing") as null|anything in possible_spells
		if(!chosen_spell)
			return
		if(!scribe_check(user, tool, RUNESCRIBE_DIFFICULTY_HARD))
			if(can_scribe(user, tool)) // if it's just a tool failure then be nice, if it's a skill or do_after fail have a little bit of mercy
				if(anima_density <= 1 || prob(15))
					to_chat(user, SPAN_DANGER("You slip up, and \the [src] cracks apart!"))
					crack_runestone(user, FALSE) // whoopsie poopsie
				else
					to_chat(user, SPAN_DANGER("You fumble, and the existing runework is damaged."))
					anima_density--
					update_strings()
			return
		// Refresh spell list for checking.
		possible_spells = anima_mat.get_cantrips_by_effect_type(user, stored_spell.effect_type)
		if(!(chosen_spell in possible_spells) || QDELETED(src) || stored_spell.spell_master)
			return
		to_chat(user, SPAN_NOTICE("You painstakingly etch the runes required to evoke [chosen_spell] onto \the [src]."))
		stored_spell.spell_master = chosen_spell
		update_strings()
		return

	if(stored_spell.masterwork_effect)
		to_chat(user, SPAN_WARNING("\The [src] is completely covered in runework, and cannot be further etched."))
		return

	// Stage three: choose masterwork rune effect.
	var/list/masterwork_effects = stored_spell.spell_master.get_masterwork_effects(user, tool)
	if(!length(masterwork_effects))
		to_chat(user, SPAN_WARNING("You cannot see any way to refine the runes etched into \the [src]."))
		return

	var/decl/anima_spell_effect/chosen_effect = input(user, "Which masterwork effect do you wish this runestone to evoke?", "Spellscribing") as null|anything in masterwork_effects
	if(!chosen_effect || !stored_spell || !stored_spell.spell_master || stored_spell.masterwork_effect || !(chosen_effect in stored_spell.spell_master.get_masterwork_effects(user, tool)))
		return
	if(!scribe_check(user, tool, RUNESCRIBE_DIFFICULTY_MASTER))
		if(can_scribe(user, tool)) // if it's just a tool failure then be nice, if it's a skill or do_after fail have no mercy
			to_chat(user, SPAN_DANGER("You slip up, and \the [src] cracks apart!"))
			crack_runestone(user, FALSE) // whoopsie poopsie
		return
	if(!chosen_effect || !stored_spell || !stored_spell.spell_master || stored_spell.masterwork_effect || !(chosen_effect in stored_spell.spell_master.get_masterwork_effects(user, tool)))
		return
	to_chat(user, SPAN_NOTICE("You delicately etch cross-links and esoteric runes that translate [stored_spell.spell_master] into [chosen_effect]."))
	stored_spell.masterwork_effect = chosen_effect
	update_strings()

#undef RUNESCRIBE_DIFFICULTY_EASY
#undef RUNESCRIBE_DIFFICULTY_HARD
#undef RUNESCRIBE_DIFFICULTY_MASTER
