/obj/item/passport
	name = "passport"
	icon = 'icons/obj/items/passport.dmi'
	icon_state = "passport"
	force = 0.5
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "A passport. Its origin seems unknown."

	var/info
	var/fingerprint

/obj/item/passport/proc/set_info(mob/living/carbon/human/H)
	if(!istype(H))
		return

	var/decl/cultural_info/culture = H.get_cultural_value(TAG_HOMEWORLD)
	var/pob = culture ? culture.name : "Unset"

	if(H.dna)
		fingerprint = md5(H.dna.uni_identity)
	else
		fingerprint = "N/A"

	var/decl/pronouns/G = H.get_pronouns(ignore_coverings = TRUE)
	info = "\icon[src] [src]:\nName: [H.real_name]\nSpecies: [H.get_species_name()]\nGender: [capitalize(G.name)]\nAge: [H.get_age()]\nPlace of Birth: [pob]\nFingerprint: [fingerprint]"

/obj/item/passport/attack_self(mob/user)
	user.visible_message(
		SPAN_ITALIC("\The [user] opens and checks \the [src]."),
		SPAN_ITALIC("You open \the [src] and check for some main information."),
		SPAN_ITALIC("You hear the faint rustle of pages."),
		5)
	to_chat(user, info || SPAN_WARNING("\The [src] is completely blank!"))
