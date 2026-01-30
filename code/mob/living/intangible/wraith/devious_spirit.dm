TYPEINFO(/mob/living/intangible/wraith/devious_spirit)
	start_speech_outputs = list(SPEECH_OUTPUT_WRAITHCHAT_POLTERGEIST)

/mob/living/intangible/wraith/devious_spirit
	name = "Devious Spirit"
	real_name = "Devious Spirit"
	desc = "Every cell in your body dislikes this thing."
	icon = 'icons/mob/mob.dmi'
	icon_state = "poltergeist"
	deaths = 2
	hud_path = /datum/hud/wraith/poltergeist
	var/mob/living/intangible/wraith/master = null
	forced_haunt_duration = 15 SECONDS
	death_icon_state = "derangedghost"
	name_generator_path = /datum/wraith_name_generator/poltergeist

	New()
		..()
		src.addAbility(/datum/targetable/wraithAbility/hallucinate)
		src.addAbility(/datum/targetable/wraithAbility/fake_sound)
		src.addAbility(/datum/targetable/wraithAbility/lay_trap)
		src.addAbility(/datum/targetable/wraithAbility/)
