turf
	icon = 'turfs.dmi'

	floor
		icon_state = "floor"

obj
	wall
		icon = 'walls.dmi'
		icon_state = "wall"
		opacity = 1
		var/icon/base_icon

		proc/dif_dir(var/mob/M)
			if(dir==SOUTH && y-M.y==1)	return 0
			if(dir==NORTH && y-M.y==-1)	return 0
			if(dir==WEST && x-M.x==1)	return 0
			if(dir==EAST && x-M.x==-1)	return 0
			return 1

		Cross(atom/movable/O)
			if(dif_dir(O)==0)
				O.Bump(src)
			else ..()

		New()
			..()
			base_icon = new/icon(icon, icon_state, dir)
			icon = null

