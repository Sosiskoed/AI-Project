var/max_speed = 1

mob/var/speed = 1

mob/New()
	..()
	if(speed > max_speed)
		max_speed = speed



mob
	var/dirs = ""

	//proc
	//	north_key
	Move(var/location)
		walk_to(src, location,,,32)
		sleep(max_speed-speed + 1)  //if fly or run, -1
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
			if( (W in view(1)) && ((W.x > src.x && W.y <= src.y) || (W.y < src.y && W.x >= src.x)) )
				if(W in visible_walls)
					client.images -= visible_walls[W]
					visible_walls -= W

			else if( (W in view(1)) && (W.x > src.x && W.y > src.y))
				if((W in visible_walls) && W.dir == EAST)
					client.images -= visible_walls[W]
					visible_walls -= W


			else if( (W in view(1)) && (W.y < src.y && W.x < src.x))
				if((W in visible_walls) && W.dir == SOUTH)
					client.images -= visible_walls[W]
					visible_walls -= W

			else
				if( !(W in visible_walls) )
					visible_walls[W] = image(W.base_icon, W)
					client.images += visible_walls[W]