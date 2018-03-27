/mob/verb/search_path(var/mob/target in world) //Функция поиска пути, активируемая игроком
	usr.travel_to(target) //Отправка пользователя к цели

/mob/proc/travel_to(var/mob/target) //Процедура, которую использует ИИ для путешествия к цели
	var/list/Way = src.find_path(target) //Список координат тайлов пути
	for(var/datum/coordinate/C3 in Way) //Цикл для определения координаты следующего тайла и соответственно его координаты
		src.Move(locate(C3.x, C3.y, C3.z)) //Перемещение на следующую на пути координату/тайл

/mob/proc/find_path(var/mob/target) //Процедура поиска лучшего пути
	var/list/Best_Way = list() //Список координат тайлов лучшего пути
	var/map = new/list(world.maxx, world.maxy) //Определение размеров карты (максимально допустимый при поиске пути X и Y)

	for(var/X = 1, X<=world.maxx, X++)	for(var/Y = 1, Y<=world.maxy, Y++)	//Цикл для проверки всех тайлов карты на проходимость
		if( isopen(locate(X, Y, z)) ) //Проверка на проходимость
			map[X][Y] = 1 //Проходимый
		else
			map[X][Y] = 0 //Непроходимый



	var/datum/coordinate/last_coordinate = new/datum/coordinate(x, y, z) //Добавление конечной координаты +
	Best_Way += last_coordinate //Добавление начальной координаты

	//var/i = 0

	while( !(target in range(1, locate(last_coordinate.x, last_coordinate.y,last_coordinate.z))) ) //Пока НПС не окажется рядом с конечной целью, будет идти цикл
		//...
		//Сперва нужно создать список ближайших тайлов и индекса их приоритета
		/*i++
		if(i>1000)
			world << "start of end"
			for(var/datum/coordinate/C3 in Best_Way)
				world << "[C3.x]-[C3.y]-[C3.z]"
			return 0
			Проверка на бесконечный цикл */


		var/list/nearest_tiles = list() //Список ближайших тайлов
		var/turf/base_tile = locate(last_coordinate.x, last_coordinate.y, last_coordinate.z) //Поиск тайла на координатах конца пути +
		var/list/min_dist //Список тайлов наименьшего пути (прямой?)


		world << "---" //Поисковик багов
		world << "Start: [last_coordinate.x] - [last_coordinate.y]"
		for(var/turf/nearest in orange(1, base_tile)) //Для ближайших тайлов на расстоянии 1 от конца пути +
			if(map[nearest.x][nearest.y] == 1) //Проверка на проходимость (если проходимый, то переход на следующий шаг)

				var/is_new_path = 1 //Переменная, показывающая, что путь новый
				for(var/datum/coordinate/C3 in Best_Way) //Цикл, который проходит по всем координатам тайлов в лучшем пути
					if(C3.x == nearest.x && C3.y == nearest.y && C3.z == nearest.z) //Проверка на то, является ли проверенный циклом тайл ближайшим
						is_new_path = 0 //Тайлу приписывается, что он - не новый путь
						break //Остановка цикла

				if(!is_new_path) //Если путь новый
					continue //То продолжить

				nearest_tiles += list(nearest.x, nearest.y, distance(nearest, target)) //Добавление проверенных координат в список ближайших тайлов
				if(!min_dist || min_dist[2] > distance(nearest, target)) //Проверка ближайшего тайла на дальность до конечного тайла
					world << "[nearest.x]-[nearest.y]-[distance(nearest, target)]" //Поисковик ошибок
					min_dist = list(new/datum/coordinate(nearest.x, nearest.y, nearest.z), distance(nearest, target)) //Минимальная дистанция приравнивается разнице между ближайшим тайлом и целью

		//Раз мы нашли ближайшие ПОДХОДЯЩИЕ тайлы, теперь мы должны понять, какие из них наиболее подходят под параметры алгоритма
		//Параметр непроходимости и тупиковости проверен. Осталось проверить параметр наилучшего расстояния до цели

		if(min_dist) //Если есть минимальная дистанция
			Best_Way += min_dist[1] //Приписать к лучшему пути минимальную дистанцию до цели
			last_coordinate = min_dist[1] //Координата конца пути приравнивается к минимальной дистанции
			world << "= [min_dist[2]]"
		else
			Best_Way -= Best_Way[Best_Way.len] //В противном случае из лучшего пути вычитается его длина
			map[last_coordinate.x][last_coordinate.y] = 0 //Размер карты устанавливается на 0
			if(Best_Way.len) //Если есть длина лучшего пути
				last_coordinate = Best_Way[Best_Way.len] //Координата конца пути приравнивается к длине лучшего пути

		if(Best_Way == list()) //Если лучший путь пуст
			world << "ERROR OF FIND WAY!" //То выдать ошибку
			return 0 //И вернуть 0 в Лучший Путь


	return Best_Way //ПРи использовании функции, возвращается список координат лучшего пути

proc/isopen(var/atom/location) //Процедура проверки тайлов на проходимось
	for(var/atom/O in range(0, location)) //Для ближайших тайлов
		if(O.density) //если плотность не равна 0
			return 0 //Вернуть "проходимости" 0
		if(istype(O, /obj/wall)) //Если стена
			return 0 //Вернуть то же самое

	return 1 //Вернуть проходимость 1 после проверки если там нет плотных объектов

/datum/coordinate //Переменные координаьт
	var/x
	var/y
	var/z

	New(var/a, var/b, var/c) //Приравнивание X,Y и Z к A,B и C
		..()
		x = a
		y = b
		z = c