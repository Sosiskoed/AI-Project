proc/DistCenter(var/x1, var/y1, var/x2, var/y2)
	return sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2))

proc/SmoothIcon(var/icon/I_add, var/icon/I_base, var/direct)
	I_add.Flip(WEST)
	var/Xm[2]//Минимумы и максимумы координат
	var/Ym[2]

	switch(direct) //Пришлось выкинуть формулы определения координат, потому что они не годятся для изометрии
		if(NORTH) //Здесь тайл просто делится на несколько кусков
			Xm[1] = 33
			Xm[2] = 63
			Ym[1] = 17
			Ym[2] = 32
		if(WEST)
			Xm[1] = 2
			Xm[2] = 32
			Ym[1] = 17
			Ym[2] = 32
		if(EAST)
			Xm[1] = 33
			Xm[2] = 63
			Ym[1] = 1
			Ym[2] = 16
		if(SOUTH)
			Xm[1] = 2
			Xm[2] = 32
			Ym[1] = 1
			Ym[2] = 16
		if(NORTHWEST)
			Xm[1] = 2
			Xm[2] = 63
			Ym[1] = 17
			Ym[2] = 32
		if(NORTHEAST)
			Xm[1] = 33
			Xm[2] = 63
			Ym[1] = 1
			Ym[2] = 32
		if(SOUTHEAST)
			Xm[1] = 2
			Xm[2] = 63
			Ym[1] = 1
			Ym[2] = 16
		if(SOUTHWEST)
			Xm[1] = 2
			Xm[2] = 32
			Ym[1] = 1
			Ym[2] = 32

	for(var/x=Xm[1], x<=Xm[2], x++)	for(var/y=Ym[1], y<=Ym[2], y++)
		if(!prob(DistCenter(x, y, 32, 16)))	continue
		if(I_add.GetPixel(x,y))
			I_base.DrawBox(I_add.GetPixel(x,y),x,y)

	return I_base


turf
	icon = 'icons/turfs/floor.dmi'
	var/smooth

	floor
		icon_state = "floor"
		name = "floor"

		plate
			icon_state = "plate"

		upload
			icon_state = "upload"


	ground //Размазанные турфы
		icon = 'icons/ground.dmi'
		smooth = 1
		darkgrass
			icon_state = "darkgrass1"

			New()
				icon_state = "darkgrass[rand(1, 16)]"
				..()

		lakewater
			icon_state = "lakewater1"

			New()
				icon_state = "lakewater[rand(1, 16)]"
				..()


		New()
			..()
			//Сперва нужно отсеять все крайние турфы
			if(x!=1 || x!=world.maxx || x!=1 || y!=world.maxy)
				//Сначала нужно определить рядом стоящие тайлы с тем же свойством
				for(var/modX = -1, modX<=1, modX++)	for(var/modY = -1, modY<=1, modY++)
					if(!modX && !modY)	continue
					var/turf/ground/G = locate(x+modX, y+modY, z)
					var/direct
					if(G && G.smooth && !istype(G, src))
						if(modX==-1 && modY==-1)	direct = SOUTHWEST
						if(modX==-1 && modY==0)		direct = WEST
						if(modX==-1 && modY==1)		direct = NORTHWEST

						if(modX==0  && modY==-1)	direct = SOUTH
						if(modX==0  && modY==1)		direct = NORTH

						if(modX==1  && modY==-1)	direct = SOUTHEAST
						if(modX==1  && modY==0)		direct = EAST
						if(modX==1  && modY==1)		direct = NORTHEAST

						icon = SmoothIcon(icon(G.icon, G.icon_state), icon(icon, icon_state), direct)


obj
	wall
		icon = 'icons/turfs/walls.dmi'
		icon_state = "concrete"
		density = 1
		opacity = 1
		layer = 4.1
		var/icon/base_icon
		var/base_icon_state
		var/base_alpha

		/*proc/dif_dir(var/atom/movable/O)
			if(dir==SOUTH && O.y>=src.y)	return 0
			if(dir==NORTH && O.y<=src.y)	return 0
			if(dir==WEST && O.x>=src.x)		return 0
			if(dir==EAST && O.x<=src.x)		return 0
			return 1*/

		proc/check_dirs()
			var/has_door = ""
			for(var/obj/door/D in range(0))
				if(dir == D.dir)
					has_door = "_d"
					break

			for(var/obj/wall/W in range(0))
				if( (dir==SOUTH && W.dir==EAST) || (dir==NORTH && W.dir==WEST) || (dir==WEST && W.dir==NORTH) || (dir==EAST && W.dir==SOUTH))
					icon_state = "[base_icon_state][has_door]-angle"
					return




		New()
			..()
			base_icon = new/icon(icon, icon_state, dir)
			icon = null
			base_alpha = alpha
			base_icon_state = icon_state
			check_dirs()

		concrete
			name = "concrete wall"
			icon_state = "concrete"

			south
				dir = SOUTH
				layer = 4.2
			north
				dir = NORTH
				layer = 4.1
			west
				dir = WEST
				layer = 4.1
			east
				dir = EAST
				layer = 4.2

		night_wallpaper
			name = "night wallpaper"
			icon_state = "night_wallpaper"
			luminosity = 1

			south
				dir = SOUTH
				layer = 4.2
			north
				dir = NORTH
				layer = 4.1
			west
				dir = WEST
				layer = 4.1
			east
				dir = EAST
				layer = 4.2

		glass
			name = "giant window"
			opacity = 0
			icon_state = "glass_wall"