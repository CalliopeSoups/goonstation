
/mob/living/carbon
	gender = MALE // WOW RUDE
	var/last_eating = 0

	var/oxyloss = 0
	var/toxloss = 0
	var/brainloss = 0
	//var/brain_op_stage = 0
	//var/heart_op_stage = 0

	infra_luminosity = 4

/mob/living/carbon/New()
	START_TRACKING
	. = ..()

/mob/living/carbon/disposing()
	STOP_TRACKING
	..()

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.) // Slip/stick handling
		var/turf/T = NewLoc
		var/datum/statusEffect/wet_floor/status = T.hasStatus("wet_floor")
		if (!src.throwing && !src.lying && status)
			status.wet_behavior(src)

/mob/living/carbon/relaymove(mob/user, direction, delay, running)
	src.organHolder?.stomach?.relaymove(user, direction, delay, running)

/mob/living/carbon/gib(give_medal, include_ejectables)
	for (var/mob/dead/target_observer/obs in src)
		obs.cancel_camera()

	for(var/mob/M in src.organHolder?.stomach?.contents)
		src.visible_message(SPAN_ALERT("<B>[M] bursts out of [src]!</B>"))
		M.set_loc(src.loc)

	. = ..(give_medal, include_ejectables)

/mob/living/carbon/swap_hand()
	var/obj/item/grab/block/B = src.check_block(ignoreStuns = 1)
	if(B)
		qdel(B)
	src.hand = !src.hand

/mob/living/carbon/lastgasp(allow_dead=FALSE, grunt = -1)
	if(grunt == -1)
		grunt = pick("NGGH","OOF","UGH","ARGH","BLARGH","BLUH","URK")
	return ..()


/mob/living/carbon/full_heal()
	src.take_toxin_damage(-INFINITY)
	src.take_oxygen_deprivation(-INFINITY)
	..()

/mob/living/carbon/take_brain_damage(var/amount)
	if (..())
		return

	if (src.traitHolder && src.traitHolder.hasTrait("reversal"))
		amount *= -1

	src.brainloss = clamp(src.brainloss + amount, 0, 120)

	if (src.brainloss >= 120 && isalive(src))
		// instant death, we can assume a brain this damaged is no longer able to support life
		src.visible_message(SPAN_ALERT("<b>[src.name]</b> goes limp, their facial expression utterly blank."))
		src.death()
		return

	return

/mob/living/carbon/take_toxin_damage(var/amount)
	if (!toxloss && amount < 0)
		amount = 0
	if (..())
		return 1

	if (src.traitHolder && src.traitHolder.hasTrait("reversal"))
		amount *= -1

	var/resist_toxic = src.bioHolder?.HasEffect("resist_toxic")

	if(resist_toxic && amount > 0)
		if(resist_toxic > 1)
			src.toxloss = 0
			return 1 //prevent organ damage
		else
			amount *= 0.33

	src.toxloss = max(0,src.toxloss + amount)
	return

/mob/living/carbon/take_oxygen_deprivation(var/amount)
	if (!oxyloss && amount < 0)
		return
	if (..())
		return

	if (HAS_ATOM_PROPERTY(src, PROP_MOB_BREATHLESS))
		src.oxyloss = 0
		return

	if (ispug(src))
		var/mob/living/carbon/human/H = src
		amount *= 2
		if (!isdead(src))
			H.emote(pick("wheeze", "cough", "sputter"))

	src.oxyloss = max(0,src.oxyloss + amount)
	return

/mob/living/carbon/get_brain_damage()
	return src.brainloss

/mob/living/carbon/get_toxin_damage()
	return src.toxloss

/mob/living/carbon/get_oxygen_deprivation()
	return src.oxyloss

