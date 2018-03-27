obj
	energy_trigger
		icon = 'icons/obj.dmi'
		icon_state = "emachine_on"
		var/on = 1
		var/block = 0

		proc/floor_switch(var/t="")
			block = 1
			for(var/i=1, i<=max(world.maxx, world.maxy), i++)
				var/trigger = 0
				for(var/turf/floor/F in range(i, src))
					if(F.icon_state != "floor[t]")
						F.icon_state = "floor[t]"
						trigger = 1


				if(!trigger)
					block = 0
					break
				sleep(1)


		Click()
			if(!block)
				if(on==1)
					on = 0
					icon_state = "emachine_off"
					floor_switch("_off")
				else
					on = 1
					icon_state = "emachine_on"
					floor_switch()
