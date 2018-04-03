turf
	icon = 'icons/turfs/floor.dmi'

	floor
		icon_state = "floor"
		name = "floor"

		plate
			icon_state = "plate"

		upload
			icon_state = "upload"



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