/*


Итак, есть массив map
Сперва нужно определить границы


*/
datum/point
	var/base[2]
	var/connect1[2]
	var/connect2[2]



/datum/space_station
	var/Map[][]
	var/size = 12


	proc/Generate(var/X=1, var/Y=1)
		size = (X+size>world.maxx) ? world.maxx-X : size
		size = (Y+size>world.maxy) ? world.maxy-Y : size

		var/map[size][size]
		var/current_x//Расположение первой точки отсчета
		var/current_y
		for(var/x=1, x<=size, x++)	for(var/y=1, y<=size, y++)
			map[x][y] = prob(40) //Сначала создаем большое количество точек для определения границ
			if(map[x][y] && !current_x && !current_y)
				current_x = x
				current_y = y




		for() //Всего два шага в цикле: Найти по Х и по У точки
			var/founded
			for(var/i=y+1, y<=size, y++) //Сначала ищем вторую точку сверху
				if(map[x][i])
					if(istype(map[x][i], datum/point))
						if(istype(map[x][y], datum/point))
							var/datum/point/P1 = map[x][y]
							P1.connect2[1] = x
							P1.connect2[2] = i
						else

							var/datum/point/P2 = map[x][i]
							P2.connect2[1] = x
							P2.connect2[2] = y

					else
						if(istype(map[x][y], datum/point)) //Если точка уже соединена с чем либо, это становится вторым соединением
							var/datum/point/P1 = map[x][y]
							P1.connect2[1] = x
							P1.connect2[2] = i
						else //Иначе создаем её с нуля
							var/datum/point/P1 = new
							P1.base[1] = x
							P1.base[2] = y
							P1.connect1[1] = x
							P1.connect1[2] = i
							map[x][y] = P1


						var/datum/point/P2 = new
						P2.base[1] = x
						P2.base[2] = i
						P2.connect1[1] = x
						P2.connect1[2] = y
						map[x][i] = P2


					current_y = i
					founded = 1
					break



			for(var/i=x+1, y<=size, y++) //Дальше справа
				if(map[x][i])
					if(istype(map[x][i], datum/point))
						if(istype(map[x][y], datum/point))
							var/datum/point/P1 = map[x][y]
							P1.connect2[1] = x
								P1.connect2[2] = i
						else
							var/datum/point/P2 = map[x][i]
						P2.connect2[1] = x
						P2.connect2[2] = y

					else
						if(istype(map[x][y], datum/point)) //Если точка уже соединена с чем либо, это становится вторым соединением
							var/datum/point/P1 = map[x][y]
							P1.connect2[1] = x
							P1.connect2[2] = i
						else //Иначе создаем её с нуля
							var/datum/point/P1 = new
							P1.base[1] = x
							P1.base[2] = y
							P1.connect1[1] = x
							P1.connect1[2] = i
							map[x][y] = P1


						var/datum/point/P2 = new
						P2.base[1] = x
						P2.base[2] = i
						P2.connect1[1] = x
						P2.connect1[2] = y
						map[x][i] = P2

					break
