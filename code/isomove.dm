client
	var/dirs = ""

	//proc
	//	north_key
	Move(var/location)
		walk_to(src, location,,,32)
		..()