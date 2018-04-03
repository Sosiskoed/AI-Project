/obj/door
	icon = 'icons/turfs/doors.dmi'
	icon_state = "brown"
	density = 1
	opacity = 1
	var/base_icon
	var/base_icon_state
	layer = 4.3
	var/status = "closed"

	New()
		..()
		base_icon = icon
		base_icon_state = icon_state//Лучше засорить оперативку лишней переменной, чем процессор лишними обработками текста

	Click()
		..()
		if(status == "closed")
			density = 0
			opacity = 0
			status = "open"
			src.icon = null
			switch(dir)
				if(SOUTH)
					src.icon = new/icon(base_icon, base_icon_state, EAST)
					pixel_x = -48
					pixel_y = -48

				if(EAST)
					src.icon = new/icon(base_icon, base_icon_state, SOUTH)
					pixel_x = 48
					pixel_y = -48
				if(NORTH)
					src.icon = new/icon(base_icon, base_icon_state, WEST)
					pixel_x = 48
					pixel_y = -48
				if(WEST)
					src.icon = new/icon(base_icon, base_icon_state, NORTH)
					pixel_x = -48
					pixel_y = -48

			//icon_state = base_icon_state+"-open"
		else
			density = 1
			opacity = 1
			status = "closed"
			src.icon = null
			switch(dir)
				if(SOUTH)
					src.icon = new/icon(base_icon, base_icon_state, SOUTH)
					pixel_x = 0
					pixel_y = 0
				if(EAST)
					src.icon = new/icon(base_icon, base_icon_state, EAST)
					pixel_x = 0
					pixel_y = 0
				if(NORTH)
					src.icon = new/icon(base_icon, base_icon_state, NORTH)
					pixel_x = 0
					pixel_y = 0
				if(WEST)
					src.icon = new/icon(base_icon, base_icon_state, WEST)
					pixel_x = 0
					pixel_y = 0