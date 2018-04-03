turf
	icon = 'icons/turfs.dmi'

	floor
		icon_state = "floor"
		name = "floor"



obj
	wall
		name = "wall"
		icon = 'icons/walls.dmi'
		icon_state = "wall"
		density = 1
		opacity = 1
		var/icon/base_icon
		var/base_alpha

		proc/dif_dir(var/atom/movable/O)
			if(dir==SOUTH && O.y>=src.y)	return 0
			if(dir==NORTH && O.y<=src.y)	return 0
			if(dir==WEST && O.x>=src.x)		return 0
			if(dir==EAST && O.x<=src.x)		return 0
			return 1


		New()
			..()
			base_icon = new/icon(icon, icon_state, dir)
			icon = null
			base_alpha = alpha

obj
	wall
		south
			dir = 2
			layer = 4.2

		east
			dir = 4
			layer = 4.2

		north
			dir = 1
			layer = 4.1

		west
			dir = 8
			layer = 4.1