atom
	verb
		Say(txt as text)
			sleep(5)
			if(text)	for(var/atom/A in hearers())
				A.Hear(txt, src)

	movable/Move()
		..()
		for(var/atom/movable/A in view())
			A.View_Move(src)

	proc
		Hear(var/text, var/atom/sender)//1 для лога, второй для речи
			src << "\icon[sender][ExText(sender.name)] says \"[ExText(text)]\""//Для лога-оутпута

		View_Move(var/atom/movable/A)




/*proc/OUTPUT(var/text, var/atom/sender)
	if(src==usr)
		var/lengrid = text2num(copytext(winget(usr, "gridout.grid", "cells"), 3))
		world << "[lengrid]+[src.name]"
		src << output("\icon[sender]", "outputwindow.output:1,[lengrid]")
		src << output("[T]", "outputwindow.output:2,[lengrid]")
		winset(usr, null, "outputwindow.output.cells=2x[lengrid+1]")
	src << "\icon[sender][T]"Для лога-оутпута*/

var/ttl = 0
var/ticks = 30
var/old_time = 0
var/last_time = 0

/world/New()
	spawn(0)
		for()
			sleep(1)
			ticks++

			if(world.timeofday-old_time > 10)
				ttl = ticks
				ticks = 0
				old_time = world.timeofday
	..()

mob
	Login()
		var/mob/player/P = locate(/mob/player) in world
		P.ckey = usr.ckey
		//P.client.key = "Arthur"
		P.name = "Arthur"


	Stat()
		stat("global FPS: ", ttl)


	icon = 'icons/mobs.dmi'

	player
		icon_state = "player"

	verb/test_time(var/num as num)
		usr << "[time2text(world.timeofday)] - [time2text(world.timeofday-num)]"