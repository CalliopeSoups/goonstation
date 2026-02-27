TYPEINFO(/mob/living/critter/wraith/devious_doll)
	start_speech_outputs = list(SPEECH_PREFIX_WRAITHCHAT)

/mob/living/critter/wraith/devious_doll
	name = "Devious Doll"
	real_name = "Devious Doll"
	desc = "Every cell in your body dislikes this thing."
	icon = 'icons/mob/wraith_critters.dmi'
	icon_state = "devious_doll"
	default_speech_output_channel = SAY_CHANNEL_WRAITH
	event_handler_flags =  IMMUNE_OCEAN_PUSH | IMMUNE_SINGULARITY | IMMUNE_TRENCH_WARP | MOVE_NOCLIP
	health_brute = 50
	health_brute_vuln = 0.7
	health_burn = 50
	health_burn_vuln = 0.3
	hand_count = 2
	can_bleed = FALSE
	var/deaths = 2
	var/mob/living/intangible/wraith/master = null // give wraith ability to summon these so you can progress with lay_trap

	New()
		..()
		src.be_incorporeal()

		src.bioHolder.AddEffect("breathless", 0, 0, 0, 1)
		src.bioHolder.AddEffect("rad_resist", 0, 0, 0, 1)
		src.bioHolder.AddEffect("detox", 0, 0, 0, 1)

		src.add_ability_holder(/datum/abilityHolder/wraith)
		src.addAbility(/datum/targetable/wraithAbility/hallucinate/doll_hallucinate)
		src.addAbility(/datum/targetable/wraithAbility/fake_sound/doll_fake_sound)
		src.addAbility(/datum/targetable/wraithAbility/lay_trap/doll_lay_trap)
		src.addAbility(/datum/targetable/wraithAbility/haunt)

	setup_healths()
		add_hh_flesh(src.health_brute, src.health_brute_vuln)
		add_hh_flesh_burn(src.health_burn, src.health_burn_vuln)

	setup_hands()
		..()
		var/datum/handHolder/HH = hands[1]
		HH.icon = 'icons/mob/hud_human.dmi'
		HH.icon_state = "handl"

		HH = hands[2]
		HH.icon = 'icons/mob/hud_human.dmi'
		HH.name = "right hand"
		HH.suffix = "-R"
		HH.icon_state = "handr"

	proc/be_corporeal() // chopped up from slashers, could make into global procs or something if wanted?
		if(!src.hasStatus("incorporeal"))
			return

		src.delStatus("incorporeal")
		src.setStatus("corporeal", duration = INFINITE_STATUS)
		src.density = 1
		REMOVE_ATOM_PROPERTY(src, PROP_MOB_INVISIBILITY, src)
		REMOVE_ATOM_PROPERTY(src, PROP_ATOM_NEVER_DENSE, src)
		REMOVE_ATOM_PROPERTY(src, PROP_MOB_NO_MOVEMENT_PUFFS, src)
		REMOVE_ATOM_PROPERTY(src, PROP_MOB_NOCLIP, src)
		src.alpha = 250
		src.see_invisible = INVIS_NONE
		src.visible_message(SPAN_ALERT("[src] appears in a puff of smoke!"))
		src.nodamage = FALSE
		src.can_place_things = TRUE

	proc/be_incorporeal()
		src.visible_message(SPAN_ALERT("[src] vanishes!"))
		src.setStatus("incorporeal", duration = INFINITE_STATUS)
		APPLY_ATOM_PROPERTY(src, PROP_ATOM_NEVER_DENSE, src)
		APPLY_ATOM_PROPERTY(src, PROP_MOB_INVISIBILITY, src, INVIS_GHOST)
		APPLY_ATOM_PROPERTY(src, PROP_MOB_NO_MOVEMENT_PUFFS, src)
		APPLY_ATOM_PROPERTY(src, PROP_MOB_NOCLIP, src)
		src.sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
		src.see_invisible = INVIS_GHOST
		src.see_in_dark = SEE_DARK_FULL
		src.flags |= UNCRUSHABLE
		src.nodamage = TRUE
		src.alpha = 160
		src.density = 0
		src.can_place_things = FALSE







