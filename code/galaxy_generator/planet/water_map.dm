/*

В начале спавнится rand(5, 15) одиночных водных клеток, которые методом стекания уходят в низины
Далее эти низины полностью заполняются. В другом цикле.

Делается проверка на процент воды

Если процент слишком мал, тогда из каждой запомнившейся точки стекания (Из первых 5-15) делая точка выше
и сканирует местность вокруг на границы выше неё.
Если в пределах этой границы найдется незанятая водой низина, она заполняется
Проверка. Следующая точка из первых


*/


//Использование алгоритма нахождения пути для прокладывания рек
/datum/planet/proc/river_path(var/datum/planet_location/last_loc, var/datum/planet_location/L2)
	if(!last_loc || !L2)	return 0
	var/access_list[max_X][max_Y] //Карта препятствий

	var/list/BestWay = list() //Список координат тайлов лучшего пути

	for(var/X = 1, X<=max_X, X++)	for(var/Y = 1, Y<=max_Y, Y++)	//Цикл для проверки всех тайлов карты на проходимость
		access_list[X][Y] = !IsOpenForRiver(map[X][Y], last_loc.height) //Проходимость

	access_list[L2.X][L2.Y] = 0

	BestWay += last_loc //Добавление в него начальной координаты как стартовой

	while(math_distance(last_loc.X, L2.X, last_loc.Y, L2.Y) > sqrt(2)) //Пока точка пути не окажется рядом с конечной целью, будет идти цикл
		var/min_dist[2] //Самый близний тайл подходящего пути и расстояние до него

		for(var/datum/planet_location/nearest in near_places(last_loc.X, last_loc.Y)) //Среди соседей ищем подходящий тайл с наименьшим расстоянием до конечно точки
			if(access_list[nearest.X][nearest.Y]==0 && !(nearest in BestWay)) //Если тайл доступен. но при этом он не в списке вычисленного пути, обрабатываем
				if(!min_dist[1] || min_dist[2] >= math_distance(nearest.X, L2.X, nearest.Y, L2.Y)) //Проверка ближайшего тайла на дальность до конечного тайла
					min_dist[1] = nearest
					min_dist[2] = math_distance(nearest.X, L2.X, nearest.Y, L2.Y) //Минимальная дистанция приравнивается разнице между ближайшим тайлом и целью


		if(min_dist[1]) //Если нашелся любой тайл, позволяющий продвинуться дальше к цели, идем по нему
			BestWay += min_dist[1]
			last_loc = min_dist[1]
		else //Если не нашелся...
			//Делаем данную точку недоступной
			access_list[last_loc.X][last_loc.Y] = 1
			BestWay -= BestWay[BestWay.len]

			if(!BestWay.len)
				world.log << "RIVER HAS NO FOUNDED PATH!"
				return 0
			else
				last_loc = BestWay[BestWay.len]
	return BestWay+L2 //ПРи использовании функции, возвращается список координат лучшего пути

proc/IsOpenForRiver(var/datum/planet_location/L, var/height) //Процедура проверки тайлов на проходимось
	if(L.height != height)	return 0
	else					return 1





//Нужно усовершенствовать алгоритм, чтобы он находил границы только в определенном радиусе

/datum/planet/proc/borders(var/H, var/mapX, var/mapY)
	//Цель данной функции - вернуть лист координат, доступных из данной точки
	//Чтобы не заходило за границу, достаточно проверять на наличие рядом заполненных
	var/datum/planet_location/L = map[mapX][mapY]
	H = max(H, L.height) //Выше заданный параметр или естественная высота точки?
	var/access_list[max_X][max_Y]
	access_list[mapX][mapY] = 1
	var/list/actual_places = list(L)
	while(actual_places.len) //Слишком много итераций. Нужно сделать отслеживающий механизм
		for(var/datum/planet_location/LOC in actual_places)
			Sleeper(1, 1000)
			for(var/datum/planet_location/near_L in near_places(LOC.X, LOC.Y))
				if(near_L.height <= H && !access_list[near_L.X][near_L.Y])
					access_list[near_L.X][near_L.Y] = 1
					actual_places += near_L
			actual_places.Remove(LOC)

	var/list/border_map = list()

	for(var/x=1, x<=max_X, x++)	for(var/y=1, y<=max_Y, y++)
		if(access_list[x][y])	border_map += map[x][y]


	return border_map


/datum/planet/proc/find_lower(var/X, var/Y, var/H) //Поиск ближайшей более низкой точки в доступной зоне
	var/datum/planet_location/L = map[X][Y]
	H = max(H, L.height)


	var/access_list[max_X][max_Y]
	access_list[X][Y] = 1
	var/list/actual_places = list(L)
	while(actual_places.len) //Слишком много итераций. Нужно сделать отслеживающий механизм
		for(var/datum/planet_location/LOC in actual_places)
			Sleeper(1, 1000)
			for(var/datum/planet_location/near_L in near_places(LOC.X, LOC.Y))
				if(near_L.height < H)	return near_L
				else if(near_L.height == H && !access_list[near_L.X][near_L.Y])
					access_list[near_L.X][near_L.Y] = 1
					actual_places += near_L
			actual_places.Remove(LOC)



	return 0


/datum/planet/proc/PlanetPercentWater()
	var/count = 0
	for(var/X=1, X<=max_X, X++)	for(var/Y=1, Y<=max_Y, Y++)
		var/datum/planet_location/L = map[X][Y]
		if(L.river || L.water)
			count++

	return 100*(count/(max_X*max_Y))


/datum/planet/proc/PlanetHasNormalSea(var/percent_of_water=70)
	var/count = 0
	for(var/X=1, X<=max_X, X++)	for(var/Y=1, Y<=max_Y, Y++)
		var/datum/planet_location/L = map[X][Y]
		if(L.river || L.water)
			count++

	world.log << "[100*(count/(max_X*max_Y))]"


	if(percent_of_water > 100*(count/(max_X*max_Y)) )
		return 0
	else
		return 1


/datum/planet/proc/Water(var/percent = 70)
	//Что есть точка?
	//Датум или просто координата?
	//Попробуем сначала датум

	var/list/random_water_points = list() //Список небольшого количества точек, которые, стекая, образуют реки, а в конце моря и озера

	for(var/i = 1, i<=rand(15*planet_size, 30*planet_size), i++) //Блок добавления этих самых точек в список
		var/X = rand(1, max_X)
		var/Y = rand(1, max_Y)

		var/datum/planet_location/L = map[X][Y]
		if(!(L in random_water_points))
			random_water_points += L


	world.log << "1 - [time2text(world.timeofday)]"

	for(var/i=1, i<=random_water_points.len, i++) //Дальше стекание каждой точки с образованием рек и морей
		//Нужно чередовать мгновенно стекание с определением границ
		//В каждом шаге цикла, рандомная точка "стекает" до самого конца
		Sleeper(1, 10)

		var/datum/planet_location/lower_place
		do  //Пока находится точка ниже, ЭТА точка стекает туда
			//Дальше сравнивается высота соседних клеток И берется наинизший сосед
			var/datum/planet_location/L = random_water_points[i]
			lower_place = find_lower(L.X, L.Y, L.height)

			if(lower_place)
				L.river = 2 //Исток реки
				for(var/datum/planet_location/near_L in near_places(L.X, L.Y))
					if(near_L.river)
						L.river = 1
						break
				for(var/datum/planet_location/river_loc in river_path(L, lower_place))
					if(!river_loc.river)
						river_loc.river = 1


				//То тут оставляется след от реки, который становится истоком, если рядом нет других тайлов с рекой


				random_water_points[i] = lower_place//И тайл моря сдвигается на вычисленную координату
		while(lower_place)

	world.log << "2 - [time2text(world.timeofday)]"


	//Дальше нужно заполнить пространства точек морями
	for(var/i=1, i<=random_water_points.len, i++)
		var/datum/planet_location/L = random_water_points[i]
		var/list/border_territory = borders(L.height, L.X, L.Y)

		for(var/j=i+1, j<=random_water_points.len, j++) //Если есть две точки рядом, они обьединяются
			var/datum/planet_location/L_other = random_water_points[j]
			if(L_other in border_territory)
				random_water_points.Remove(L_other)

		for(var/datum/planet_location/L_near in border_territory)
			L_near.river = 0
			L_near.water++//Повышение уровня моря

	//Дальше нужно повышать уровень моря поточечно, пока не станет нужный процент
	var/iter = 1
	var/process = 0
	world.log << "3 - [time2text(world.timeofday)]"
	while(PlanetHasNormalSea(percent)==0)
		Sleeper(1, 250)
		if(iter > random_water_points.len)
			if(!process)
				break
			iter = 1
			process = 0

		var/datum/planet_location/L = random_water_points[iter]
		var/list/border_territory = borders(L.height+L.water, L.X, L.Y)


		for(var/j=iter+1, j<=random_water_points.len, j++) //Если есть две точки рядом, они обьединяются
			var/datum/planet_location/L_other = random_water_points[j]
			if(L_other in border_territory)
				random_water_points.Remove(L_other)

		for(var/datum/planet_location/L_near in border_territory)
			L_near.water++//Повышение уровня моря
			process = 1


		if(PlanetHasNormalSea(percent))
			var/WaterPercent = PlanetPercentWater()
			for(var/datum/planet_location/L_near in border_territory)
				//L_near.river = 0
				L_near.water = max(0, L_near.water-1)//Понижение уровня моря
			if(abs(WaterPercent-percent) < abs(PlanetPercentWater()-percent)) //Грубая примерка
				for(var/datum/planet_location/L_near in border_territory)
					L_near.water++
			PlanetHasNormalSea(percent)
			break


		iter++
	world.log << "4 - [time2text(world.timeofday)]"

	for(var/X=1, X<=max_X, X++)	for(var/Y=1, Y<=max_Y, Y++)
		var/datum/planet_location/L = map[X][Y]
		if(L.water)	L.river = 0

	world.log << "5 - [time2text(world.timeofday)]"