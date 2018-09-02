var/sector_size = 32 //�������� 64 ��� �������������� ��������
var/old_procent = 0
var/o_time
var/R_const = 4



proc/num2RGB_by_percent(var/current_int, var/max_int, var/min_int, var/color)
	var/percent = min(100, max(0, round(100 * (current_int-min_int)/(max_int-min_int)) ))
	switch(color)
		if("R")	return rgb(153+percent, 153, 153)
		if("G")	return rgb(153, 153+percent, 153)
		if("B")	return rgb(153, 153, 153+percent)




var/datum/planet/Planet

//��� �������� ���������� ���� ������ ���� ������� - ������
world/New()
	spawn(50)
		Planet = new/datum/planet(8)//�������� 32 ��� ����������� ����������� ���. ����� ������, �� ������ ���� �������������, ��� ������ ����� ������ �� 1-2 ��������(� ��� ���� 1 �� ��� �� ������ ������� ������ �������?)
	..()//32x64 ���������� 256 MB, 64x64 ���������� 1 GB ����������� ������
	//������������ �������� ������ ����� � �������, ������� ���������� �������� �� �� �� �������������

/mob/var/tracking = 1
mob/Stat()

	if(Planet && Planet.map && tracking)
		var/procent = round( 100*(1-(blank_LEN(Planet.map, Planet.max_X, Planet.max_Y)/(Planet.max_X*Planet.max_Y))) )
		stat("Percent", "[procent]%")
		if(!o_time)	o_time = world.timeofday
		if(procent-10>=old_procent || procent == 100)
			world << "[procent]%: [(world.timeofday-o_time)/10] s"
			old_procent = 10*round(procent/10)
			o_time = world.timeofday
			if(procent >= 100)	tracking = 0




/datum/coordinate //���������� ���������
	var/x
	var/y
	var/z

	New(var/a, var/b, var/c=1) //������������� X,Y � Z � A,B � C
		..()
		x = a
		y = b
		z = c

/datum/planet_location
	var/temperature_year_min//������� �������� ����������� �� ������ � ����
	var/temperature_year_max
	var/biom = "field" // Forest && Mountain
	var/special = "grass"
	var/height = 1  //�������� - 10
	//var/dif_height = 0 //�������� ������ �� ����� � ��� �� �������
	var/X
	var/Y
	var/river = 0 //1 - ���� ����, 2 - �����, 3 - �����
	var/water = 0

	New(var/h, var/Xn, var/Yn)
		..()
		height = h
		X = Xn
		Y = Yn



//���� ������� ��������� ������ �� ���������, �� ���������� ��������, ������� �� �����



//�������� ����������� �� ���� �����
//���������� �� ������ ���������� �����, ������ ������� ������� ������������� ������� (2^n)+1, ��� n �� ����������� �����
//������ �� ������ ������� ������� ������ ����� ��������� �������� ������ (rand(-10,10)
//� ��� ����� � �����, ���� �� ����� ��������� ��� �����, ��������� ��� ����: ��������� ����� � ��������� ��������
//� ������ �� ��� ����������� ������ ������� ����� ��� ��������� �����, ���� ������� �� ����
//� ������� ������ ������������ ��������� ��������, ������� ����������� ��� ���������� �������� ������


proc/blank_LEN(var/list/L, var/X, var/Y)
	var/count = 0
	for(var/x = 1, x<=X, x++)
		for(var/y = 1, y<=Y, y++)
			if(!L[x][y])	count++
	return count


/datum/planet
	var/clear_tiles
	var/max_X
	var/max_Y
	var/planet_size = 1
	var/map
	var/square_R
	var/error = 0
	var/middle_temperature = 287 //������� ����������� �������
	var/star_orbit_fault = 0.8 // ������������ ���������� ������� �����������

	New(var/ps)
		planet_size = ps
		spawn(1)//������� �� ��, ��� ��� ����� ����������� � ������ ������ ����������. �� � ���� � ���������
			Generation()

	proc/Generation()
		max_X = 1 + planet_size*sector_size
		max_Y = 1 + planet_size*sector_size/2
		square_R = planet_size*sector_size/2

		map = new/list(max_X, max_Y)

		map[1][1] 			= new/datum/planet_location(rand(-10, 10), 1, 		1  )
		map[max_X][max_Y] 	= new/datum/planet_location(rand(-10, 10), max_X, max_Y)
		map[max_X][1]		= new/datum/planet_location(rand(-10, 10), max_X, 	1  )
		map[1][max_Y] 		= new/datum/planet_location(rand(-10, 10), 1, 	  max_Y)
		map[max_Y][max_Y]	= new/datum/planet_location(rand(-10, 10), max_Y, max_Y)//������ ��� �����, ��� ����, ����� ������� �������� �� ��� ���������� ����
		map[max_Y][1]		= new/datum/planet_location(rand(-10, 10), max_Y, 1)

		var/height_tags = new/list(planet_size, max(planet_size/2, 1), 2)

		for(var/hx = 1, hx <= planet_size, hx++)	for(var/hy = 1, hy <= max(planet_size/2, 1), hy++)
			height_tags[hx][hy][1] = pick(prob(20);-10, prob(100);-3)
			height_tags[hx][hy][2] = pick(prob(20);10, prob(100);3)


		while(Planet.square_R>=2)
			sleep(1)
			Square(height_tags)
		world.log << "Height map is done!"
		sleep(10)
		Smoothing()
		world.log << "Smoothing of map is done!"
		sleep(10)
		Temperature()
		world.log << "Temperature map is done!"
		sleep(10)
		Water()
		world.log << "Generation is done!"


/datum/planet/proc/near_places(var/X, var/Y, var/range=1)
	var/list/datum/planet_location/LOCS = list()
	for(var/mod_x=-range, mod_x<=range, mod_x++)	for(var/mod_y=-range, mod_y<=range, mod_y++)

		if(mod_x==0 && mod_y==0)
			continue
		if(X+mod_x<1 || X+mod_x>max_X || Y+mod_y<1 || Y+mod_y>max_Y)
			continue
		LOCS += map[X+mod_x][Y+mod_y]
	return LOCS






proc/copy_list(var/list/L, var/X, var/Y)
	var/new_list
	if(X && Y)
		new_list = new/list(X, Y)
		for(var/x=1, x<=X, x++)		for(var/y=1, y<=Y, y++)
			new_list[x][y] = (L[x][y]) ? 1 : 0
	else
		new_list = new/list(L.len)
		for(var/x=1, x<=L.len, x++)
			new_list[x] = (L[x]) ? 1 : null
	return new_list



/mob/verb/view_height_map()
	if(!Planet)
		usr << "Sorry, map is not exist"
		return
	omap()

/mob/verb/view_temperature_map()
	if(!Planet)
		usr << "Sorry, map is not exist"
		return
	temperature_omap()


/mob/proc/omap()
	var/icon/map_icon = new/icon('icons/giant_icons.dmi', "blank")
	var/html = "<body>"
	for(var/Y = 1, Y<=Planet.max_Y, Y++)
		html += "<tr height=5>"
		for(var/X = 1, X<Planet.max_X, X++)
			var/datum/planet_location/L = Planet.map[X][Y]
			var/col = "#FF0000"
			if(L)
				if(L.water)
					col = rgb(0, 0, 255-10*L.water)
				else if(L.river==2)
					col = rgb(50, 50, 255)
				else if(L.river==1)
					col = rgb(30, 30, 200)
				else
					col = rgb(120+L.height*12, 200-L.height*5, 120+L.height*12)

			//����� �����
			if( (X/sector_size)-round(X/sector_size) == 0 && X!=1 && X!=Planet.max_X )
				col = "#000000"
			else if( (Y/sector_size)-round(Y/sector_size) == 0 && Y!=1 && Y!=Planet.max_Y )
				col = "#000000"


			map_icon.DrawBox(col, X, Y)//+max(0, 513-Planet.max_Y))
	usr << browse_rsc(map_icon, "map.jpg")
	html += "<p><img src=map.jpg></p></body>"
	usr << browse(html, "window=planet_map; size=600x600;" )



/mob/proc/temperature_omap() //��� ����
	var/icon/map_icon = new/icon('icons/giant_icons.dmi', "blank")
	var/html = "<body>"
	for(var/Y = 1, Y<=Planet.max_Y, Y++)
		html += "<tr height=5>"
		for(var/X = 1, X<Planet.max_X, X++)
			var/datum/planet_location/L = Planet.map[X][Y]
			var/col = "#FF0000"
			if(L)
				if(L.temperature_year_max<=Planet.middle_temperature)
					col = num2RGB_by_percent(L.temperature_year_max,
						Planet.middle_temperature*Planet.star_orbit_fault,
						Planet.middle_temperature,
						"B")
				else
					col = num2RGB_by_percent(L.temperature_year_max,
						Planet.middle_temperature*(2-Planet.star_orbit_fault),
						Planet.middle_temperature,
						"R")



			if( (X/sector_size)-round(X/sector_size) == 0 && X!=1 && X!=Planet.max_X )
				col = "#000000"
			else if( (Y/sector_size)-round(Y/sector_size) == 0 && Y!=1 && Y!=Planet.max_Y )
				col = "#000000"


			map_icon.DrawBox(col, X, Y)//+max(0, 513-Planet.max_Y))
	usr << browse_rsc(map_icon, "temperature_map.jpg")
	html += "<p><img src=temperature_map.jpg></p></body>"
	usr << browse(html, "window=planet_temperature_map; size=600x600;" )




	//������ �� ����� � ����� � ���������� ������������ � ���������� �������
	//��������� ����� �� ��������, � � ������ ����������� �������� �������������� ���������� �����
	//�������� �� ����� ��������� �����
	//���������, ���� �� ��� ����
	//� ������ ����������� �����, �������� ��������� ����������� � �� ���� ����������� ���������, ���� �� � �������� ������� ����
	//� ������ ���������� ����� � ����������� �������, �������� ���� ���� �� ��������� �������
	//� ����������� �� ����� � ������� �������� rand() ������ ������ (�� ����� ������� ����������� � ������������ ������)
	//��������� �� �� ����� ��� ������� � ������
	//��� � ������ ������ ��������� ��� ����� ����� �� ������� ������
	//� ������ ������� ���� �� ������ ������� ��� ����� ��������� ��� ��������� ��� 200 ���


/*
1. ������� ������ ���� ������ � ��� ������� �� ��� ������������ ������� ��� ������ �������
  ��������: 70% ����� � 30% �����
  ������� ���� �� ��������, �� ��� �� ������
2. ��� ������� ����� ���������� ���������� ������������ ����� ������ ���������� ���������
   ��� �� ���� �������, � ������ ���� �������� �� ������� ������ 100
3. ��� ����� ������������� �� ����� ��������� ��������
4. ������, ������ �� ����� � �����, ��� "�����������" �� �����, �� ���������.
5. ���� ����� ������ "�����������" � ����� ������ �� ��������,
     ���������� ��������� ������ ����� �� ����� � ��� ������������ ��� ���� �����-�����
6. � ��� �� ��� ���, ���� ��� ����� �� ����� ���������.
7. ���� ��� ����� ���������, � �� ����� ��� �������� ������ �������, ��� ����������� ���������� �������

----
8. ��� ������� ����� ���� ���� ����������� ������ � � ��������
9. �������� ������ ����������� ����� ��������
10. �������� �� ������ ����� ��������� ��������� - �������� 3
11. ��� ���� �������� �� ������ � �����, ��� ������ ����, ��� ��� ����� ������ ����� ��������
      ��� ��������� �����
    � � ���������, ������� �� ������ ��������� ����� ����� ���������
    �� ����, ������� �������� ���� ���� ��� ����

*/