/obj/structure/door
	name = "door"
	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"
	hitsound = 'sound/weapons/genhit.ogg'
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC | MAT_FLAG_ALTERATION_COLOR
	max_health = 50
	density =  TRUE
	anchored = TRUE
	opacity =  TRUE

	var/has_window = FALSE
	var/changing_state = FALSE
	var/icon_base
	var/door_sound_volume = 25

/obj/structure/door/Initialize()
	..()
	if(!istype(material))
		return INITIALIZE_HINT_QDEL
	if(!icon_base)
		icon_base = material.door_icon_base
	update_icon()
	if(material?.luminescence)
		set_light(material.luminescence, 0.5, material.color)
	return INITIALIZE_HINT_LATELOAD

/obj/structure/door/LateInitialize(mapload, dir=0, populate_parts=TRUE)
	..()
	update_nearby_tiles(need_rebuild = TRUE)

/obj/structure/door/update_nearby_tiles(need_rebuild)
	. = ..()
	update_connections(TRUE)

/obj/structure/door/Destroy()
	update_nearby_tiles()
	return ..()

/obj/structure/door/get_blend_objects()
	var/static/list/blend_objects = list(
		/obj/structure/wall_frame,
		/obj/structure/window,
		/obj/structure/grille,
		/obj/machinery/door
	)
	return blend_objects

// Preference is: constructed walls, other doors, other walls.
/obj/structure/door/proc/get_turf_blend_priority(turf/neighbor)
	if(istype(neighbor, /turf/wall))
		return istype(neighbor, /turf/wall/natural) ? 1 : 3
	if(locate(/obj/structure/door) in neighbor)
		return 2
	return 0

/obj/structure/door/update_connections(var/propagate = FALSE)

	. = ..()

	if(!isturf(loc))
		return

	var/highest_priority
	var/highest_dir

	for(var/turf/neighbor as anything in RANGE_TURFS(loc, 1))

		if(propagate && istype(neighbor, /turf/wall))
			var/turf/wall/wall = neighbor
			wall.wall_connections = null
			wall.other_connections = null
			wall.queue_icon_update()

		var/turf_dir = get_dir(loc, neighbor)
		if(turf_dir & (turf_dir - 1)) // if diagonal
			continue // skip diagonals

		var/turf_priority = get_turf_blend_priority(neighbor)
		if(turf_priority > highest_priority)
			highest_dir      = turf_dir
			highest_priority = turf_priority

	if(highest_priority > 0 && highest_dir)
		set_dir(turn(highest_dir, 90))

/obj/structure/door/get_material_health_modifier()
	. = 10

/obj/structure/door/on_update_icon()
	..()
	icon_state = "[icon_base][!density ? "_open" : ""]"

/obj/structure/door/proc/post_change_state()
	update_nearby_tiles()
	update_icon()
	changing_state = FALSE

/obj/structure/door/attack_hand(mob/user)
	if(user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		return density ? open(user) : close(user)
	return ..()

/obj/structure/door/proc/close(mob/user)
	set waitfor = FALSE
	if(!can_close(user))
		return FALSE
	flick("[icon_base]_closing", src)
	playsound(src, material.dooropen_noise, door_sound_volume, 1)

	changing_state = TRUE
	sleep(1 SECOND)
	set_density(TRUE)
	set_opacity(!has_window && material.opacity > 0.5)
	post_change_state()
	return TRUE

/obj/structure/door/proc/open(mob/user)
	set waitfor = FALSE
	if(!can_open(user))
		return FALSE
	flick("[icon_base]_opening", src)
	playsound(src, material.dooropen_noise, door_sound_volume, 1)

	changing_state = TRUE
	sleep(1 SECOND)
	set_density(FALSE)
	set_opacity(FALSE)
	post_change_state()
	return TRUE

/obj/structure/door/update_lock_overlay()
	return // TODO

/obj/structure/door/proc/can_open(mob/user)
	if(lock)
		try_unlock(user, user?.get_active_held_item())
		if(lock.isLocked())
			to_chat(user, SPAN_WARNING("\The [src] is locked."))
			return FALSE
	return density && !changing_state

/obj/structure/door/proc/can_close()
	return !density && !changing_state

/obj/structure/door/attack_ai(mob/living/user)
	return attack_hand_with_interaction_checks(user)

/obj/structure/door/explosion_act(severity)
	. = ..()
	if(!QDELETED(src))
		take_damage(100 - (severity * 30))

/obj/structure/door/can_repair(var/mob/user)
	. = ..()
	if(. && !density)
		to_chat(user, SPAN_WARNING("\The [src] must be closed before it can be repaired."))
		return FALSE

/obj/structure/door/can_install_lock()
	return TRUE

/obj/structure/door/attackby(obj/item/used_item, mob/user)
	add_fingerprint(user, 0, used_item)

	if((user.a_intent == I_HURT && used_item.get_attack_force(user)) || istype(used_item, /obj/item/stack/material))
		return ..()

	if(used_item.user_can_attack_with(user, silent = TRUE))
		if(try_key_unlock(used_item, user))
			return TRUE

		if(try_install_lock(used_item, user))
			return TRUE

	if(density)
		open(user)
	else
		close(user)
	return TRUE

/obj/structure/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group)
		return !density
	if(istype(mover, /obj/effect/ir_beam))
		return !opacity
	return !density

/obj/structure/door/CanFluidPass(coming_from)
	return !density

/obj/structure/door/Bumped(atom/movable/AM)
	if(!density || changing_state || !istype(AM))
		return

	if(AM.get_object_size() <= MOB_SIZE_SMALL)
		return

	if(ismob(AM))
		var/mob/M = AM
		if(M.restrained() || issmall(M))
			return
	open(ismob(AM) ? AM : null)

/obj/structure/door/get_alt_interactions(var/mob/user)
	. = ..()
	if(density)
		. += /decl/interaction_handler/knock_on_door

/decl/interaction_handler/knock_on_door
	name = "Knock On Door"
	expected_target_type = /obj/structure/door
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEEDS_TURF

/decl/interaction_handler/knock_on_door/invoked(atom/target, mob/user, obj/item/prop)
	if(!istype(target) || !target.density)
		return FALSE
	user.do_attack_animation(src)
	playsound(target.loc, 'sound/effects/glassknock.ogg', 80, 1)
	if(user.a_intent == I_HURT)
		target.visible_message(
			SPAN_DANGER("\The [user] bangs against \the [src]!"),
			blind_message = "You hear a banging sound!"
		)
	else
		target.visible_message(
			SPAN_NOTICE("\The [user] knocks on \the [target]."),
			blind_message = SPAN_NOTICE("You hear a knocking sound.")
		)
	return TRUE

#define MATERIAL_DOOR_SUBTYPE(PATH, MATERIAL)\
/obj/structure/door/##PATH{\
	material = MATERIAL;\
	color = MATERIAL::color;\
	icon_state = MATERIAL::door_icon_base;\
}\
/obj/structure/door/##PATH

// Subtypes below.
MATERIAL_DOOR_SUBTYPE(iron, /decl/material/solid/metal/iron)

MATERIAL_DOOR_SUBTYPE(silver, /decl/material/solid/metal/silver)

MATERIAL_DOOR_SUBTYPE(gold, /decl/material/solid/metal/gold)

MATERIAL_DOOR_SUBTYPE(uranium, /decl/material/solid/metal/uranium)

MATERIAL_DOOR_SUBTYPE(sandstone, /decl/material/solid/stone/sandstone)

MATERIAL_DOOR_SUBTYPE(basalt, /decl/material/solid/stone/basalt)
	desc = "A door hewn of raw basalt, unthinkably heavy and smooth to the touch."

MATERIAL_DOOR_SUBTYPE(diamond, /decl/material/solid/gemstone/diamond)

MATERIAL_DOOR_SUBTYPE(wood, /decl/material/solid/organic/wood)

MATERIAL_DOOR_SUBTYPE(mahogany, /decl/material/solid/organic/wood/mahogany)

MATERIAL_DOOR_SUBTYPE(maple, /decl/material/solid/organic/wood/maple)

MATERIAL_DOOR_SUBTYPE(ebony, /decl/material/solid/organic/wood/ebony)

MATERIAL_DOOR_SUBTYPE(walnut, /decl/material/solid/organic/wood/walnut)

/obj/structure/door/wood/saloon
	opacity = FALSE

MATERIAL_DOOR_SUBTYPE(wood/saloon/ebony, /decl/material/solid/organic/wood/ebony)
MATERIAL_DOOR_SUBTYPE(wood/saloon/walnut, /decl/material/solid/organic/wood/walnut)

MATERIAL_DOOR_SUBTYPE(glass, /decl/material/solid/glass)
MATERIAL_DOOR_SUBTYPE(plastic, /decl/material/solid/organic/plastic)
MATERIAL_DOOR_SUBTYPE(exotic_matter, /decl/material/solid/exotic_matter)

/obj/structure/door/shuttle
	material = /decl/material/solid/metal/steel
