/datum/planet/proc/Temperature()
	//Глобальная температура будет выражаться всего в двух параметрах: Годовой максимум и минимум
	//Они будут сгенерированы на основе средней "вертикали" температуры(Зависимость от расстояния до экватора)
	//Если в будущем будет влажность, мгновенная температура будет учитывать и её.


	//По сути данный блок отвечает всего лишь за незримую разницу в факторах температуры вроде плотности атмосферы, частоты дождей и так далее

	var/equator_range = max_Y/2 // Расстояние от полюса до экватора


	//В будущем надо будет делать разницу для южного и северного полушария

	for(var/X=1, X<=max_X, X++)	for(var/Y=1, Y<=max_Y, Y++)
		var/datum/planet_location/PL = map[X][Y]
		//Разница между максимальной температурой на экваторе и минимальной на полюсе
		var/dif_temp = (middle_temperature*(2-star_orbit_fault))-(middle_temperature*(star_orbit_fault))
		//Средняя температура для данной долготы
		var/middle_local_temp = middle_temperature*star_orbit_fault + dif_temp * ((Y<=equator_range) ? Y/equator_range : (2-(Y/equator_range)))



		PL.temperature_year_min = max(0, middle_local_temp - rand(0, round(middle_local_temp*0.05)))
		PL.temperature_year_max = max(0, middle_local_temp + rand(0, round(middle_local_temp*0.05)))

		if(Y>equator_range) //Для противоположного полушария
			var/temp_t = PL.temperature_year_min
			PL.temperature_year_min = PL.temperature_year_max
			PL.temperature_year_max = temp_t


		Sleeper(1, 2500)