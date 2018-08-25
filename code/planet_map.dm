var/sector_size = 32 //Максимум 64 для реалистичности масштаба
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

//Для простоты рассмотрим пока только одну планету - Теплую
world/New()
	spawn(50)
		Planet = new/datum/planet(8)//Максимум 32 для адекватного потребления ОЗУ. Можно больше, но только если гарантируется, что игроки будут строго на 1-2 планетах(У вас есть 1 ГБ ОЗУ на каждую планету такого размера?)
	..()//32x64 потребляет 256 MB, 64x64 потребляет 1 GB оперативной памяти
	//Процессорная мощность крайне важна в будущем, поэтому переносить нагрузку на неё не рекомендуется

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




/datum/coordinate //Переменные координат
	var/x
	var/y
	var/z

	New(var/a, var/b, var/c=1) //Приравнивание X,Y и Z к A,B и C
		..()
		x = a
		y = b
		z = c

/datum/planet_location
	var/temperature_year_min//Средние значения температуры на январь и июль
	var/temperature_year_max
	var/biom = "field" // Forest && Mountain
	var/special = "grass"
	var/height = 1  //Максимум - 10
	//var/dif_height = 0 //Разность высоты на одной и той же локации
	var/X
	var/Y
	var/river = 0 //1 - есть река, 2 - исток, 3 - устье
	var/water = 0

	New(var/h, var/Xn, var/Yn)
		..()
		height = h
		X = Xn
		Y = Yn



//Если сделать генерацию строго по квадратам, то получается картинка, похожая на город



//Алгоритм оказывается до жути прост
//Изначально мы должны заспавнить карту, каждая сторона которой соответствует формуле (2^n)+1, где n не обязательно общая
//Дальше мы должны придать угловым точкам карты случайные значения высоты (rand(-10,10)
//И уже потом в цикле, пока не будет закрашена вся карта, повторять два шага: Обработку ромба и обработку квадрата
//В каждом из них вычисляется высота средней точки для имеющихся фигур, если таковой не было
//К средней высоте прибавляется случайное значение, которое уменьшается при уменьшении размеров фигуры


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
	var/middle_temperature = 287 //Средняя температура планеты
	var/star_orbit_fault = 0.8 // Максимальное отклонение годовой температуры

	New(var/ps)
		planet_size = ps
		spawn(1)//Надежда на то, что это будет происходить в другом канале процессора. Но я могу и ошибаться
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
		map[max_Y][max_Y]	= new/datum/planet_location(rand(-10, 10), max_Y, max_Y)//Ручной шаг ромба, для того, чтобы работал алгоритм не для квадратных карт
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

			//Сетка карты
			if( (X/sector_size)-round(X/sector_size) == 0 && X!=1 && X!=Planet.max_X )
				col = "#000000"
			else if( (Y/sector_size)-round(Y/sector_size) == 0 && Y!=1 && Y!=Planet.max_Y )
				col = "#000000"


			map_icon.DrawBox(col, X, Y)//+max(0, 513-Planet.max_Y))
	usr << browse_rsc(map_icon, "map.jpg")
	html += "<p><img src=map.jpg></p></body>"
	usr << browse(html, "window=planet_map; size=600x600;" )



/mob/proc/temperature_omap() //Для лета
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




	//Ставим на карте Х точек с рандомными координатами и рандомными биомами
	//Проверяем точки на близость, и в случае черезмерной близости перегенерируем координату точки
	//Выбираем на карте случайную точку
	//Проверяем, есть ли там биом
	//В случае присутствия биома, выбираем случайное направление и на этом направлении проверяем, есть ли в соседнем секторе биом
	//В случае отсутствия биома в проверенном секторе, копируем туда биом из исходного сектора
	//В зависимости от биома с помощью фукнкции rand() ставим высоту (от биома зависит минимальная и максимальная высота)
	//Повторяем то же самое для разницы в высоте
	//Раз в двести циклов проверяем все тайлы карты на наличие биомов
	//В случае наличия хотя бы одного сектора без биома повторяем всю процедуру еще 200 раз


/*
1. Берется список всех биомов и для каждого из них генерируется процент для данной планеты
  Например: 70% полей и 30% морей
  Формулу пока не придумал, но это не рандом
2. Для каждого биома выбирается количество генерируемых точек равное количеству процентов
   Или по иной формуле, в случае если секторов на планете меньше 100
3. Эти точки раскидываются по карте рандомным способом
4. Дальше, циклом от точки к точке, они "растекаются" по карте, не заменяясь.
5. Если точке некуда "растекаться" и норма биомов не выполнеа,
     выбирается рандомное пустое место на карте и там генерируется еще одна спавн-точка
6. И так до тех пор, пока вся карта не будет заполнена.
7. Если все нормы выполнены, а на карте еще остались пустые сектора, они заполняются рандомными биомами

----
8. Для каждого биома есть свои ограничения высоты и её различий
9. Различия высоты приоритетно будут нулевыми
10. Различия по высоте между соседними секторами - максимум 3
11. Чем выше различия по высоте в биоме, тем больше шанс, что его общая высота будет повышена
      при генерации карты
    А в остальном, влияние на высоту соседнего биома будет рандомным
    То есть, сделать соседний биом выше или ниже

*/