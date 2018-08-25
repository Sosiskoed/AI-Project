//Процедура сглаживания
/datum/planet/proc/Smoothing()
	for(var/X = 1, X <= max_X, X++)	for(var/Y = 1, Y<=max_Y, Y++)
		var/medium_height = 0
		var/list/nearest = near_places(X, Y)

		for(var/datum/planet_location/PL in nearest)
			medium_height += PL.height

		var/datum/planet_location/L = map[X][Y]
		L.height = round(medium_height/nearest.len)
		Sleeper(1, 2500)



/datum/planet/proc/height(var/medium_height, var/line, var/min_height_tag, var/max_height_tag)
	medium_height = round(medium_height)
	var/min_rand = max(medium_height-line/R_const, -10)
	var/max_rand = min(medium_height+line/R_const, 10)
	min_rand = abs(abs(medium_height)-abs(min_rand))    // << Сомнительное место
	max_rand = abs(abs(medium_height)-abs(max_rand))
	if(medium_height+min_rand < min_height_tag)		min_rand -= min(min_rand,  min_height_tag - (medium_height+min_rand))
	if(medium_height+max_rand > max_height_tag)		max_rand -= min(max_rand,  (medium_height+max_rand) - max_height_tag)
	return max(-10, min(medium_height + rand(-min_rand, max_rand), 10))



/datum/planet/proc/Square(var/list/height_tags)	//Считается, что присутствуют все 4 точки по умолчанию
	var/planet_map = copy_list(map, max_X, max_Y)
	var/list/new_places = list()
	for(var/X=1, X<=max_X-2, X+=square_R)	for(var/Y=1, Y<=max_Y-2, Y+=square_R/2)	//Ищем левый нижний угол для начала черчения квадрата
		if(!planet_map[X][Y])	continue
		var/X1 = X + square_R/2
		var/Y1 = Y + square_R/2
		var/datum/planet_location/SW = map[X][Y]
		var/datum/planet_location/NW = map[X][Y+square_R]
		var/datum/planet_location/NE = map[X+square_R][Y+square_R]
		var/datum/planet_location/SE = map[X+square_R][Y]

		var/medium_height = (NW.height+SW.height+NE.height+SE.height)/4
		var/ht_x = 1+round((X-1)/sector_size)
		var/ht_y = 1+round((Y-1)/sector_size)

		map[X1][Y1] = new/datum/planet_location(height(medium_height, square_R+1, height_tags[ht_x][ht_y][1], height_tags[ht_x][ht_y][2]), X1, Y1)


		new_places += map[X1][Y1]
		Sleeper(1, 2500)

	square_R /= 2
	if(new_places.len)
		Diamond(new_places, height_tags)



/datum/planet/proc/Diamond(var/list/new_places, var/list/height_tags)	//Считается, что присутствуют минимум 2 точки по умолчанию
	var/R = square_R
	for(var/datum/planet_location/PL in new_places)
		var/X = PL.X
		var/Y = PL.Y
		var/datum/planet_location/NW = map[X-R][Y+R]
		var/datum/planet_location/NE = map[X+R][Y+R]
		var/datum/planet_location/SW = map[X-R][Y-R]
		var/datum/planet_location/SE = map[X+R][Y-R]

		var/datum/planet_location/N = (Y+2*R<=max_Y) ? map[X][Y+2*R] : null
		var/datum/planet_location/S = (Y-2*R>=1) 	 	? map[X][Y-2*R] : null
		var/datum/planet_location/W = (X-2*R>=1) 	 	? map[X-2*R][Y] : null
		var/datum/planet_location/E = (X+2*R<=max_X) ? map[X+2*R][Y] : null


		//Модуль сравниваняи по краю и одновременно нахождения четвертой точки
		if(!W || !E)
			//Нужно вычислить расстояние до края от центра
			//И взять на таком же расстоянии с другой стороны тайл
			//Если он, конечно, существует
			var/edge_X = max_X-X+1
			if(map[edge_X][Y])
				if(!W)	W = map[edge_X][Y]
				else	E = map[edge_X][Y]

		var/ht_x_n = 1+round((X-2)/sector_size);	var/ht_y_n = 1+round((Y+R-2)/sector_size);
		var/ht_x_s = 1+round((X-2)/sector_size);	var/ht_y_s = 1+round((Y-R-1)/sector_size);
		var/ht_x_w = 1+round((X-R-1)/sector_size);	var/ht_y_w = 1+round((Y-2)/sector_size);
		var/ht_x_e = 1+round((X+R-2)/sector_size);	var/ht_y_e = 1+round((Y-2)/sector_size)



		//Точки находятся всегда. Нужно верно определить для них квадрант

		var/medium_height_N = (PL.height + NW.height + NE.height + ((N) ? N.height : 0)) / (3 + ((N) ? 1 : 0))
		var/medium_height_S = (PL.height + SW.height + SE.height + ((S) ? S.height : 0)) / (3 + ((S) ? 1 : 0))
		var/medium_height_W = (PL.height + NW.height + SW.height + ((W) ? W.height : 0)) / (3 + ((W) ? 1 : 0))
		var/medium_height_E = (PL.height + NE.height + SE.height + ((E) ? E.height : 0)) / (3 + ((E) ? 1 : 0))

		map[X][Y+R] = new/datum/planet_location(height(medium_height_N, 1+R*2, height_tags[ht_x_n][ht_y_n][1], height_tags[ht_x_n][ht_y_n][2]), X, Y+R)
		map[X][Y-R] = new/datum/planet_location(height(medium_height_S, 1+R*2, height_tags[ht_x_s][ht_y_s][1], height_tags[ht_x_s][ht_y_s][2]), X, Y-R)
		map[X-R][Y] = new/datum/planet_location(height(medium_height_W, 1+R*2, height_tags[ht_x_w][ht_y_w][1], height_tags[ht_x_w][ht_y_w][2]), X-R, Y)
		map[X+R][Y] = new/datum/planet_location(height(medium_height_E, 1+R*2, height_tags[ht_x_e][ht_y_e][1], height_tags[ht_x_e][ht_y_e][2]), X+R, Y)

		Sleeper(1, 2500)