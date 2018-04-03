/*
	These are simple defaults for your project.
 */

world
	fps = 25		// 25 frames per second
	icon_size = "64x80"	// 32x32 icon size by default

	view = 6		// show up to 6 tiles outward from center (13x13 view)
	map_format = ISOMETRIC_MAP

	New()
		..()
		Start()

		spawn(0)	for()
			sleep(36000)
			HourLoop()

	Del()
		End()
		..()

	proc/End()
	proc/Start()
	proc/HourLoop()



// Make objects move 32 pixels per tick when walking
var/list/languages = list("ru", "en")
mob
	step_size = 64
	var/language = "ru"

	New()
		..()
		if(client)	language = client.language

client
	var/language = "ru"

obj
	step_size = 32