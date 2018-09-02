/*

� ������ ��������� rand(5, 15) ��������� ������ ������, ������� ������� �������� ������ � ������
����� ��� ������ ��������� �����������. � ������ �����.

�������� �������� �� ������� ����

���� ������� ������� ���, ����� �� ������ ������������� ����� �������� (�� ������ 5-15) ����� ����� ����
� ��������� ��������� ������ �� ������� ���� ��.
���� � �������� ���� ������� �������� ��������� ����� ������, ��� �����������
��������. ��������� ����� �� ������


*/


//������������� ��������� ���������� ���� ��� ������������� ���
/datum/planet/proc/river_path(var/datum/planet_location/last_loc, var/datum/planet_location/L2)
	if(!last_loc || !L2)	return 0
	var/access_list[max_X][max_Y] //����� �����������

	var/list/BestWay = list() //������ ��������� ������ ������� ����

	for(var/X = 1, X<=max_X, X++)	for(var/Y = 1, Y<=max_Y, Y++)	//���� ��� �������� ���� ������ ����� �� ������������
		access_list[X][Y] = !IsOpenForRiver(map[X][Y], last_loc.height) //������������

	access_list[L2.X][L2.Y] = 0

	BestWay += last_loc //���������� � ���� ��������� ���������� ��� ���������

	while(math_distance(last_loc.X, L2.X, last_loc.Y, L2.Y) > sqrt(2)) //���� ����� ���� �� �������� ����� � �������� �����, ����� ���� ����
		var/min_dist[2] //����� ������� ���� ����������� ���� � ���������� �� ����

		for(var/datum/planet_location/nearest in near_places(last_loc.X, last_loc.Y)) //����� ������� ���� ���������� ���� � ���������� ����������� �� ������� �����
			if(access_list[nearest.X][nearest.Y]==0 && !(nearest in BestWay)) //���� ���� ��������. �� ��� ���� �� �� � ������ ������������ ����, ������������
				if(!min_dist[1] || min_dist[2] >= math_distance(nearest.X, L2.X, nearest.Y, L2.Y)) //�������� ���������� ����� �� ��������� �� ��������� �����
					min_dist[1] = nearest
					min_dist[2] = math_distance(nearest.X, L2.X, nearest.Y, L2.Y) //����������� ��������� �������������� ������� ����� ��������� ������ � �����


		if(min_dist[1]) //���� ������� ����� ����, ����������� ������������ ������ � ����, ���� �� ����
			BestWay += min_dist[1]
			last_loc = min_dist[1]
		else //���� �� �������...
			//������ ������ ����� �����������
			access_list[last_loc.X][last_loc.Y] = 1
			BestWay -= BestWay[BestWay.len]

			if(!BestWay.len)
				world.log << "RIVER HAS NO FOUNDED PATH!"
				return 0
			else
				last_loc = BestWay[BestWay.len]
	return BestWay+L2 //��� ������������� �������, ������������ ������ ��������� ������� ����

proc/IsOpenForRiver(var/datum/planet_location/L, var/height) //��������� �������� ������ �� �����������
	if(L.height != height)	return 0
	else					return 1





//����� ����������������� ��������, ����� �� ������� ������� ������ � ������������ �������

/datum/planet/proc/borders(var/H, var/mapX, var/mapY)
	//���� ������ ������� - ������� ���� ���������, ��������� �� ������ �����
	//����� �� �������� �� �������, ���������� ��������� �� ������� ����� �����������
	var/datum/planet_location/L = map[mapX][mapY]
	H = max(H, L.height) //���� �������� �������� ��� ������������ ������ �����?
	var/access_list[max_X][max_Y]
	access_list[mapX][mapY] = 1
	var/list/actual_places = list(L)
	while(actual_places.len) //������� ����� ��������. ����� ������� ������������� ��������
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


/datum/planet/proc/find_lower(var/X, var/Y, var/H) //����� ��������� ����� ������ ����� � ��������� ����
	var/datum/planet_location/L = map[X][Y]
	H = max(H, L.height)


	var/access_list[max_X][max_Y]
	access_list[X][Y] = 1
	var/list/actual_places = list(L)
	while(actual_places.len) //������� ����� ��������. ����� ������� ������������� ��������
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
	//��� ���� �����?
	//����� ��� ������ ����������?
	//��������� ������� �����

	var/list/random_water_points = list() //������ ���������� ���������� �����, �������, ������, �������� ����, � � ����� ���� � �����

	for(var/i = 1, i<=rand(15*planet_size, 30*planet_size), i++) //���� ���������� ���� ����� ����� � ������
		var/X = rand(1, max_X)
		var/Y = rand(1, max_Y)

		var/datum/planet_location/L = map[X][Y]
		if(!(L in random_water_points))
			random_water_points += L


	world.log << "1 - [time2text(world.timeofday)]"

	for(var/i=1, i<=random_water_points.len, i++) //������ �������� ������ ����� � ������������ ��� � �����
		//����� ���������� ��������� �������� � ������������ ������
		//� ������ ���� �����, ��������� ����� "�������" �� ������ �����
		Sleeper(1, 10)

		var/datum/planet_location/lower_place
		do  //���� ��������� ����� ����, ��� ����� ������� ����
			//������ ������������ ������ �������� ������ � ������� ��������� �����
			var/datum/planet_location/L = random_water_points[i]
			lower_place = find_lower(L.X, L.Y, L.height)

			if(lower_place)
				L.river = 2 //����� ����
				for(var/datum/planet_location/near_L in near_places(L.X, L.Y))
					if(near_L.river)
						L.river = 1
						break
				for(var/datum/planet_location/river_loc in river_path(L, lower_place))
					if(!river_loc.river)
						river_loc.river = 1


				//�� ��� ����������� ���� �� ����, ������� ���������� �������, ���� ����� ��� ������ ������ � �����


				random_water_points[i] = lower_place//� ���� ���� ���������� �� ����������� ����������
		while(lower_place)

	world.log << "2 - [time2text(world.timeofday)]"


	//������ ����� ��������� ������������ ����� ������
	for(var/i=1, i<=random_water_points.len, i++)
		var/datum/planet_location/L = random_water_points[i]
		var/list/border_territory = borders(L.height, L.X, L.Y)

		for(var/j=i+1, j<=random_water_points.len, j++) //���� ���� ��� ����� �����, ��� ������������
			var/datum/planet_location/L_other = random_water_points[j]
			if(L_other in border_territory)
				random_water_points.Remove(L_other)

		for(var/datum/planet_location/L_near in border_territory)
			L_near.river = 0
			L_near.water++//��������� ������ ����

	//������ ����� �������� ������� ���� ���������, ���� �� ������ ������ �������
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


		for(var/j=iter+1, j<=random_water_points.len, j++) //���� ���� ��� ����� �����, ��� ������������
			var/datum/planet_location/L_other = random_water_points[j]
			if(L_other in border_territory)
				random_water_points.Remove(L_other)

		for(var/datum/planet_location/L_near in border_territory)
			L_near.water++//��������� ������ ����
			process = 1


		if(PlanetHasNormalSea(percent))
			var/WaterPercent = PlanetPercentWater()
			for(var/datum/planet_location/L_near in border_territory)
				//L_near.river = 0
				L_near.water = max(0, L_near.water-1)//��������� ������ ����
			if(abs(WaterPercent-percent) < abs(PlanetPercentWater()-percent)) //������ ��������
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