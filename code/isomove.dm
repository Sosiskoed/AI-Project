var/max_speed = 1

mob/var/speed = 1

mob/New()
	..()
	if(speed > max_speed)
		max_speed = speed



mob
	var/dirs = ""
	var/in_move = 0

	//proc
	//	north_key
	Move(var/location)
		if(in_move)	return
		in_move = 1
		walk_to(src, location,,,64)
		sleep(max_speed-speed + 1)  //if fly or run, -1
		in_move = 0
		..()


mob/New()
	..()
	spawn(15)
		src.Move(locate(x, y, z))

mob/var/list/visible_walls = list()

mob/Move()
	..()
	if(client)
		for(var/obj/wall/W in visible_walls)
			if(!(W in view(world.view*2)))
				client.images -= visible_walls[W]
				visible_walls -= W

		for(var/obj/wall/W in view(world.view*2))
			if(W in visible_walls)
				var/image/I = visible_walls[W]
				if( (W in view(1)) && ((W.x > src.x && W.y <= src.y) || (W.y < src.y && W.x >= src.x)) )
					I.alpha = round(W.base_alpha/4)

				else if( (W in view(1)) && (W.x > src.x && W.y > src.y))
					if(W.dir == EAST)
						I.alpha = round(W.base_alpha/4)


				else if( (W in view(1)) && (W.y < src.y && W.x < src.x))
					if(W.dir == SOUTH)
						I.alpha = round(W.base_alpha/4)

				else if ( !(W in view(1)) )
					I.alpha = W.base_alpha

			else
				visible_walls[W] = image(W.base_icon, W)
				client.images += visible_walls[W]