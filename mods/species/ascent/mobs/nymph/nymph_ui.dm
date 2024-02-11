/obj/screen/intent/ascent_nymph
	icon_state = "intent_harm"
	screen_loc = ANYMPH_SCREEN_LOC_INTENT

/obj/screen/intent/ascent_nymph/on_update_icon()
	if(intent == I_HURT || intent == I_GRAB)
		intent = I_GRAB
		icon_state = "intent_harm"
	else
		intent = I_DISARM
		icon_state = "intent_help"

/obj/screen/ascent_nymph_molt
	name = "molt"
	icon = 'icons/obj/action_buttons/organs.dmi'
	screen_loc =  ANYMPH_SCREEN_LOC_MOLT
	icon_state = "molt-on"
	requires_ui_style = FALSE

/obj/screen/ascent_nymph_molt/handle_click(mob/user, params)
	var/mob/living/carbon/alien/ascent_nymph/nymph = user
	if(istype(nymph)) nymph.molt()

/datum/hud/ascent_nymph
	var/obj/screen/ascent_nymph_molt/molt
	var/obj/screen/food/food
	var/obj/screen/drink/drink

/decl/ui_style/ascent
	restricted = TRUE
	uid  = "ui_style_ascent"
	//'mods/species/ascent/icons/ui.dmi'

/datum/hud/ascent_nymph/get_ui_style_data()
	return GET_DECL(/decl/ui_style/ascent)

/datum/hud/ascent_nymph/get_ui_color()
	return COLOR_WHITE

/datum/hud/ascent_nymph/get_ui_alpha()
	return 255

/datum/hud/ascent_nymph/FinalizeInstantiation()
	var/decl/ui_style/ui_style = get_ui_style_data()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()
	molt          = new(                                null, mymob, ui_style, ui_color, ui_alpha)
	food          = new /obj/screen/food(               null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_NUTRITION)
	drink         = new /obj/screen/drink(              null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_HYDRATION)
	action_intent = new /obj/screen/intent/ascent_nymph(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_INTENT)
	mymob.healths = new /obj/screen/ascent_nymph_health(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_HEALTH)
	src.other = list()
	src.adding = list(mymob.healths, molt, food, drink, action_intent)
	..()

/obj/screen/ascent_nymph_health
	name = "health"
	screen_loc = ANYMPH_SCREEN_LOC_HEALTH
